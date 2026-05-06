const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');

const source = readFileSync('index.ts', 'utf8');

assert.match(source, /const activationMarkerType = "superpowers-activated-v1";/, 'defines a separate session activation marker');
assert.match(source, /function promptMentionsSuperpowers\(prompt: string\): boolean \{\s*return \/\\bsuperpowers\\b\/i\.test\(prompt\);\s*\}/, 'detects explicit superpowers mentions case-insensitively');
assert.match(source, /if \(!activated\) return;/, 'does not inject the bootstrap before activation');
assert.match(source, /promptMentionsSuperpowers\(event\.prompt\) \|\| hasActivationMarker\(ctx\)/, 'activation latches after the first explicit mention');
assert.match(source, /return \{ skillPaths: \[skillsDir\] \};/, 'continues registering skills for explicit skill usage');
assert.doesNotMatch(source, /During normal work, the extension injects the using-superpowers bootstrap once per session/, 'status text no longer claims unconditional bootstrap injection');

const skillFiles = require('node:fs').readdirSync('repo/skills', { withFileTypes: true })
  .filter((entry) => entry.isDirectory())
  .map((entry) => `repo/skills/${entry.name}/SKILL.md`);
for (const file of skillFiles) {
  const skill = readFileSync(file, 'utf8');
  const description = skill.match(/^description:\s*(.+)$/m)?.[1] ?? '';
  assert.match(description, /Superpowers/i, `${file} description is gated by Superpowers activation`);
  if (file.endsWith('/using-superpowers/SKILL.md')) {
    assert.match(description, /prompt mentions superpowers/i, 'using-superpowers only triggers on explicit user mention');
  } else {
    assert.match(description, /Superpowers is active/i, `${file} only triggers after activation`);
  }
}

console.log('superpowers activation source checks passed');
