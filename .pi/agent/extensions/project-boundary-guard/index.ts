import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";
import { execFileSync } from "node:child_process";
import { homedir } from "node:os";
import path from "node:path";
import { parse as shellParse } from "shell-quote";

type OpToken = { op: string; [k: string]: unknown };
type Token = string | OpToken;

type GuardDecision = {
	severity: "critical" | "boundary";
	reasons: string[];
};

function isOpToken(t: Token): t is OpToken {
	return typeof t === "object" && t !== null && "op" in t;
}

function strings(tokens: Token[]): string[] {
	return tokens.filter((t) => typeof t === "string") as string[];
}

function basename(cmd: string): string {
	return path.basename(cmd);
}

function hasShortFlag(args: string[], flag: string): boolean {
	const letter = flag.replace(/^-+/, "");
	return args.some((a) => a === flag || (/^-[^-]/.test(a) && a.slice(1).includes(letter)));
}

function hasAny(args: string[], values: string[]): boolean {
	return args.some((a) => values.includes(a));
}

function splitSegments(tokens: Token[]): Token[][] {
	const out: Token[][] = [];
	let current: Token[] = [];
	for (const t of tokens) {
		if (isOpToken(t) && ["&&", "||", ";", "&"].includes(t.op)) {
			if (current.length) out.push(current);
			current = [];
			continue;
		}
		current.push(t);
	}
	if (current.length) out.push(current);
	return out;
}

function safeParse(command: string): Token[] {
	try {
		return shellParse(command) as Token[];
	} catch {
		// If parsing fails we do not block by default; this guard is intentionally soft.
		return [];
	}
}

function detectCritical(command: string, tokens: Token[]): string[] {
	const reasons: string[] = [];
	const ops = tokens.filter(isOpToken).map((t) => t.op);
	const segments = splitSegments(tokens);

	// Remote code execution via pipe or process substitution.
	if (/\b(curl|wget)\b[^#\n]*\|\s*(ba?sh|zsh|fish|dash|sh)\b/i.test(command)) {
		reasons.push("curl/wget piped to shell (remote code execution)");
	}
	if (/\b(ba?sh|zsh|fish|dash|sh)\s+<\s*\(\s*(curl|wget)\b/i.test(command)) {
		reasons.push("shell executing process substitution from curl/wget");
	}

	for (const seg of segments) {
		const args = strings(seg);
		if (!args.length) continue;
		const cmd = basename(args[0]);
		const rest = args.slice(1);

		if (cmd === "sudo" || cmd === "doas" || cmd === "su") {
			reasons.push(`${cmd} (elevated privileges)`);
		}

		if (cmd === "rm" && (hasShortFlag(rest, "-r") || rest.includes("--recursive"))) {
			reasons.push("recursive delete (rm -r / rm -rf)");
		}
		if (cmd === "find" && rest.includes("-delete")) {
			reasons.push("find -delete (bulk deletion)");
		}

		if (cmd === "git") {
			const sub = rest[0];
			const subArgs = rest.slice(1);
			if (sub === "reset" && subArgs.includes("--hard")) reasons.push("git reset --hard (discard changes)");
			if (sub === "clean" && (hasShortFlag(subArgs, "-f") || subArgs.includes("--force"))) reasons.push("git clean -f (delete untracked files)");
			if (sub === "push" && (hasShortFlag(subArgs, "-f") || subArgs.includes("--force") || subArgs.includes("--force-with-lease"))) reasons.push("git push --force/-f (rewrite remote history)");
			if (sub === "reflog" && subArgs.includes("expire")) reasons.push("git reflog expire (removes recovery history)");
			if (sub === "gc" && subArgs.some((a) => a.startsWith("--prune"))) reasons.push("git gc --prune (can permanently delete objects)");
			if (sub === "branch" && subArgs.includes("-D")) reasons.push("git branch -D (force-delete branch)");
		}

		if (cmd.startsWith("mkfs")) reasons.push("mkfs (filesystem formatting)");
		if (cmd.startsWith("newfs_")) reasons.push("newfs_* (filesystem formatting)");
		if (cmd === "wipefs") reasons.push("wipefs (disk signature wipe)");
		if (cmd === "dd" && rest.some((a) => /^of=\/dev\//.test(a))) reasons.push("dd of=/dev/... (raw disk write)");
		if (["parted", "fdisk", "gdisk", "sgdisk", "gpt"].includes(cmd)) reasons.push(`${cmd} (partition table management)`);
		if (cmd === "cryptsetup") reasons.push("cryptsetup (disk encryption management)");
		if (cmd === "zpool" && hasAny(rest, ["destroy", "detach", "remove"])) reasons.push("zpool destructive operation");
		if (cmd === "diskutil" && rest.some((a) => /^(erase|eraseDisk|eraseVolume|zeroDisk|secureErase|reformat)$/i.test(a))) reasons.push("diskutil destructive disk operation");
		if (cmd === "asr" && rest.includes("restore")) reasons.push("asr restore (can overwrite volumes)");

		if (["shutdown", "reboot", "halt", "poweroff"].includes(cmd)) reasons.push(`${cmd} (system power operation)`);
		if (cmd === "launchctl" && hasAny(rest, ["bootout", "disable", "remove"])) reasons.push("launchctl service modification");
		if (cmd === "systemctl" && hasAny(rest, ["stop", "disable", "mask"])) reasons.push("systemctl service disruption");

		if (cmd === "terraform" && rest[0] === "destroy") reasons.push("terraform destroy (infrastructure teardown)");
		if (cmd === "kubectl" && rest[0] === "delete") reasons.push("kubectl delete (Kubernetes resource deletion)");
		if (cmd === "helm" && rest[0] === "uninstall") reasons.push("helm uninstall (Kubernetes release deletion)");
		if (cmd === "aws" && rest[0] === "s3" && rest[1] === "rm" && rest.includes("--recursive")) reasons.push("aws s3 rm --recursive (bulk S3 deletion)");
		if (cmd === "gcloud" && rest.includes("delete")) reasons.push("gcloud delete (cloud resource deletion)");
		if (cmd === "az" && rest.includes("delete")) reasons.push("az delete (cloud resource deletion)");
	}

	// If shell-quote surfaced a pipe, only critical when combined with shell execution above.
	void ops;
	return [...new Set(reasons)];
}

function gitRoot(cwd: string): string | null {
	try {
		return execFileSync("git", ["rev-parse", "--show-toplevel"], {
			cwd,
			encoding: "utf8",
			stdio: ["ignore", "pipe", "ignore"],
		}).trim();
	} catch {
		return null;
	}
}

function isInside(child: string, parent: string): boolean {
	const rel = path.relative(parent, child);
	return rel === "" || (!!rel && !rel.startsWith("..") && !path.isAbsolute(rel));
}

function expandPath(raw: string, cwd: string): string | null {
	if (!raw || raw.startsWith("-") || /^[A-Za-z_][A-Za-z0-9_]*=/.test(raw)) return null;
	if (/^[a-z][a-z0-9+.-]*:/.test(raw)) return null; // URL/scheme
	if (raw === "." || raw === ".." || raw.startsWith("./") || raw.startsWith("../")) return path.resolve(cwd, raw);
	if (raw === "~") return homedir();
	if (raw.startsWith("~/")) return path.resolve(homedir(), raw.slice(2));
	if (path.isAbsolute(raw)) return path.resolve(raw);
	return null;
}

const PATH_ARGUMENT_COMMANDS = new Set([
	"cat", "less", "more", "head", "tail", "ls", "tree", "find", "grep", "rg", "fd",
	"cp", "mv", "rm", "mkdir", "rmdir", "touch", "chmod", "chown", "ln", "readlink", "realpath",
	"tar", "zip", "unzip", "rsync", "du", "df", "open", "code", "vim", "nano", "sed", "perl",
]);

function detectOutsideProject(tokens: Token[], repoRoot: string, initialCwd: string): string[] {
	const reasons: string[] = [];
	let cwd = initialCwd;

	for (const seg of splitSegments(tokens)) {
		const args = strings(seg);
		if (!args.length) continue;
		const cmd = basename(args[0]);
		const rest = args.slice(1);

		if (cmd === "cd") {
			const targetRaw = rest.find((a) => !a.startsWith("-")) ?? "~";
			const target = expandPath(targetRaw, cwd) ?? path.resolve(cwd, targetRaw);
			if (!isInside(target, repoRoot)) reasons.push(`cd outside project: ${targetRaw} -> ${target}`);
			cwd = target;
			continue;
		}

		if (!PATH_ARGUMENT_COMMANDS.has(cmd)) continue;

		for (const arg of rest) {
			const resolved = expandPath(arg, cwd);
			if (!resolved) continue;
			if (!isInside(resolved, repoRoot)) reasons.push(`path outside project: ${arg} -> ${resolved}`);
		}
	}

	return [...new Set(reasons)];
}

function analyze(command: string, cwd: string): GuardDecision | null {
	const tokens = safeParse(command);
	const critical = detectCritical(command, tokens);
	if (critical.length) return { severity: "critical", reasons: critical };

	const root = gitRoot(cwd) ?? cwd;
	const outside = detectOutsideProject(tokens, root, cwd);
	if (outside.length) return { severity: "boundary", reasons: outside };

	return null;
}

async function confirm(ctx: any, title: string, command: string, reasons: string[]): Promise<boolean> {
	if (!ctx.hasUI) return false;
	const body = `${reasons.map((r) => `• ${r}`).join("\n")}\n\nCommand:\n${command}`;
	return await ctx.ui.confirm(title, body);
}

const subagentDepth = Number(process.env.PI_SUBAGENT_DEPTH ?? "0");
const isSubagent = Number.isFinite(subagentDepth) && subagentDepth >= 1;

export default function (pi: ExtensionAPI) {
	const recentlyDenied = new Map<string, number>();
	const DENY_REMEMBER_MS = 60_000;
	const STATE_ENTRY = "project-boundary-guard-state";
	let enabled = true;

	function setEnabled(value: boolean) {
		enabled = value;
		pi.appendEntry(STATE_ENTRY, { enabled, timestamp: Date.now() });
	}

	pi.on("session_start", (_event, ctx) => {
		// Restore latest state for the active branch. Defaults to enabled.
		for (const entry of ctx.sessionManager.getBranch() as any[]) {
			if (entry.type === "custom" && entry.customType === STATE_ENTRY && typeof entry.data?.enabled === "boolean") {
				enabled = entry.data.enabled;
			}
		}
		ctx.ui.setStatus?.("project-boundary-guard", enabled ? "guard:on" : "guard:off");
	});

	pi.registerCommand("boundary-guard", {
		description: "Toggle project-boundary-guard: /boundary-guard [on|off|status|toggle]",
		handler: async (args, ctx) => {
			const action = args.trim().toLowerCase() || "toggle";
			if (action === "on" || action === "enable" || action === "enabled") {
				setEnabled(true);
			} else if (action === "off" || action === "disable" || action === "disabled") {
				setEnabled(false);
			} else if (action === "toggle") {
				setEnabled(!enabled);
			} else if (action !== "status") {
				ctx.ui.notify("Usage: /boundary-guard [on|off|status|toggle]", "warning");
				return;
			}

			ctx.ui.setStatus?.("project-boundary-guard", enabled ? "guard:on" : "guard:off");
			ctx.ui.notify(`project-boundary-guard is ${enabled ? "enabled" : "disabled"}`, enabled ? "success" : "warning");
		},
	});

	pi.on("tool_call", async (event, ctx) => {
		if (!isToolCallEventType("bash", event)) return;
		if (!enabled) return;

		const command = event.input.command;
		const decision = analyze(command, ctx.cwd);
		if (!decision) return;

		const now = Date.now();
		const lastDenied = recentlyDenied.get(command);
		if (lastDenied && now - lastDenied < DENY_REMEMBER_MS) {
			return {
				block: true,
				reason: "Blocked by project-boundary-guard: this exact command was denied recently. Do not retry it unchanged.",
			};
		}

		if (isSubagent || !ctx.hasUI) {
			return {
				block: true,
				reason:
					`Blocked by project-boundary-guard (${decision.severity}): ${decision.reasons.join("; ")}. ` +
					"This session cannot prompt for permission; ask the user/parent session to approve or use a project-local safer command.",
			};
		}

		const allowed = await confirm(
			ctx,
			decision.severity === "critical" ? "Critical bash command" : "Command accesses outside the project",
			command,
			decision.reasons,
		);

		if (allowed) return;
		recentlyDenied.set(command, now);
		return {
			block: true,
			reason:
				`Blocked by user via project-boundary-guard (${decision.severity}). ` +
				"Ask for permission or choose a safer project-local command.",
		};
	});
}
