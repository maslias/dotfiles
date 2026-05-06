import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { existsSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const baseDir = dirname(fileURLToPath(import.meta.url));
const repoDir = join(baseDir, "repo");
const skillsDir = join(repoDir, "skills");
const usingSuperpowersPath = join(skillsDir, "using-superpowers", "SKILL.md");
const markerType = "superpowers-bootstrap-v1";
const activationMarkerType = "superpowers-activated-v1";

function stripFrontmatter(markdown: string): string {
	const match = markdown.match(/^---\r?\n[\s\S]*?\r?\n---\r?\n([\s\S]*)$/);
	return match ? match[1].trim() : markdown.trim();
}

function buildBootstrap(): string | null {
	if (!existsSync(usingSuperpowersPath)) return null;
	const content = stripFrontmatter(readFileSync(usingSuperpowersPath, "utf8"));

	return `<EXTREMELY_IMPORTANT>
You have Superpowers.

The Superpowers skills directory has been registered with pi for this session. The full content of the using-superpowers skill is included below and is ALREADY LOADED; do not load using-superpowers again.

Pi platform adaptation:
- Pi does not have Claude Code's Skill, Task, or TodoWrite tools.
- When a Superpowers skill says to invoke/use/load a skill, use pi's skill system: either the user can run /skill:<name>, or you should use the read tool to read that skill's SKILL.md from the available skills paths before responding or acting.
- Announce skill usage exactly as the Superpowers workflow requires, e.g. "Using <skill-name> to <purpose>."
- Map Read/Write/Edit/Bash to pi's read/write/edit/bash tools.
- Map TodoWrite checklists to an explicit checklist in your response or, when useful for longer work, maintain a project-local TODO/plan document.
- Map Task/subagent workflows to pi-compatible execution: either perform the task yourself in isolated steps, or ask the user to start parallel pi agents/worktrees when the skill requires true subagents.
- User instructions remain higher priority than Superpowers skills.

${content}
</EXTREMELY_IMPORTANT>`;
}

function hasBootstrapMarker(ctx: any): boolean {
	return ctx.sessionManager
		.getEntries()
		.some((entry: any) => entry.type === "custom" && entry.customType === markerType);
}

function hasActivationMarker(ctx: any): boolean {
	return ctx.sessionManager
		.getEntries()
		.some((entry: any) => entry.type === "custom" && entry.customType === activationMarkerType);
}

function promptMentionsSuperpowers(prompt: string): boolean {
	return /\bsuperpowers\b/i.test(prompt);
}

export default function superpowersPiExtension(pi: ExtensionAPI) {
	pi.on("resources_discover", () => {
		if (!existsSync(skillsDir)) return {};
		return { skillPaths: [skillsDir] };
	});

	pi.on("before_agent_start", async (event, ctx) => {
		const activated = promptMentionsSuperpowers(event.prompt) || hasActivationMarker(ctx);
		if (!activated) return;
		if (!hasActivationMarker(ctx)) {
			pi.appendEntry(activationMarkerType, { activatedAt: Date.now(), source: "prompt" });
		}
		if (hasBootstrapMarker(ctx)) return;
		const bootstrap = buildBootstrap();
		if (!bootstrap) return;

		pi.appendEntry(markerType, { injectedAt: Date.now(), source: usingSuperpowersPath });
		return {
			message: {
				customType: markerType,
				content: bootstrap,
				display: false,
				details: { source: usingSuperpowersPath },
			},
		};
	});

	pi.registerCommand("superpowers", {
		description: "Show Superpowers status and pi adaptation notes",
		handler: async (_args, ctx) => {
			const skillCount = existsSync(skillsDir) ? pi.getCommands().filter((cmd) => cmd.source === "skill" && cmd.sourceInfo.path.startsWith(skillsDir)).length : 0;
			const active = hasActivationMarker(ctx);
			ctx.ui.notify(`Superpowers for pi ${active ? "active" : "installed"}: ${skillCount || "?"} skills from ${skillsDir}`, "info");
			pi.sendMessage(
				{
					customType: "superpowers-status",
					content: `Superpowers for pi is installed.\n\nStatus: ${active ? "active for this session" : "inactive until a prompt mentions superpowers"}\nSkills path: ${skillsDir}\nBootstrap skill: ${usingSuperpowersPath}\n\nUse /skill:<name> to force-load a Superpowers skill. The using-superpowers bootstrap activates only after a user prompt mentions superpowers, then remains active for the session so chained workflows can continue.`,
					display: true,
				},
				{ deliverAs: "nextTurn" },
			);
		},
	});

	pi.registerCommand("superpowers-update", {
		description: "Update bundled Superpowers skills from GitHub (requires git/network)",
		handler: async (_args, ctx) => {
			ctx.ui.notify("Updating Superpowers skills...", "info");
			const result = await pi.exec("bash", ["-lc", `set -euo pipefail\nTMP=$(mktemp -d)\ntrap 'rm -rf \"$TMP\"' EXIT\ngit clone --depth 1 https://github.com/obra/superpowers.git \"$TMP/superpowers\"\nrm -rf ${JSON.stringify(repoDir)}\nmkdir -p ${JSON.stringify(baseDir)}\ncp -a \"$TMP/superpowers\" ${JSON.stringify(repoDir)}\nrm -rf ${JSON.stringify(join(repoDir, ".git"))}`], { timeout: 120000 });
			if (result.code === 0) {
				ctx.ui.notify("Superpowers updated. Run /reload to rediscover skills.", "success");
			} else {
				ctx.ui.notify(`Superpowers update failed: ${result.stderr || result.stdout}`, "error");
			}
		},
	});
}
