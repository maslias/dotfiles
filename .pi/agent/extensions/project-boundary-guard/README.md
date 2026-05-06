# project-boundary-guard (pi extension)

A softer replacement/alternative for `bash-guard`.

## Policy

The guard only intercepts agent-issued `bash` tool calls.

Inside the current Git repository, normal project work is allowed without prompts, including routine Git commands.

The guard asks for permission when:

1. A command matches one of the critical/destructive patterns below.
2. A command explicitly accesses a path outside the current Git repository/project root.

In subagent/headless sessions, where prompting is not possible, matching commands are blocked.

## Critical patterns

- `rm -r`, `rm -rf`, `rm -Rf`
- `find ... -delete`
- `sudo`, `doas`, `su`
- `curl|sh`, `curl|bash`, `wget|sh`, `wget|bash`, `bash <(curl ...)`
- destructive disk/volume commands:
  - `diskutil erase*`, `zeroDisk`, `secureErase`, `reformat`
  - `mkfs*`, `newfs_*`, `wipefs`, `dd of=/dev/...`
  - `parted`, `fdisk`, `gdisk`, `sgdisk`, `gpt`, `asr restore`
  - selected destructive `zpool` operations
- system/service disruption:
  - `shutdown`, `reboot`, `halt`, `poweroff`
  - `launchctl bootout/disable/remove`
  - `systemctl stop/disable/mask`
- destructive Git operations only:
  - `git reset --hard`
  - `git clean -f...`
  - `git push --force`, `git push -f`, `git push --force-with-lease`
  - `git reflog expire`
  - `git gc --prune`
  - `git branch -D`
- infra/cloud deletion:
  - `terraform destroy`
  - `kubectl delete`
  - `helm uninstall`
  - `aws s3 rm --recursive`
  - `gcloud ... delete`
  - `az ... delete`

## Outside-project detection

The current Git root from `git rev-parse --show-toplevel` is used as project boundary. If no Git root exists, `ctx.cwd` is used.

The guard detects obvious outside-project usage in common path-taking commands, for example:

```bash
ls ~/.ssh
cat /etc/hosts
cp file ~/Desktop/
cd .. && ls
find /Users/marciii -name foo
```

Limitations: this is a command-string guard, not a sandbox. It cannot know what arbitrary scripts do internally.

## Slash command

Toggle the guard in the current session:

```txt
/boundary-guard
```

Explicit commands:

```txt
/boundary-guard on
/boundary-guard off
/boundary-guard status
/boundary-guard toggle
```

The current state is stored in the session branch and restored on reload/resume. The footer status shows `guard:on` or `guard:off`.

## Install / reload

This extension is auto-discovered from:

```txt
~/.pi/agent/extensions/project-boundary-guard/
```

Run `/reload` in pi after installation.

If the old `bash-guard` extension is still enabled, both guards will run. To use only this softer policy, disable or rename the old extension directory.
