import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { root, inside, validateNote, makeHandoff, mergeGemini, sha256 } from './project.mjs';

function fixture(t) {
  const parent = path.join(root, '.ai-tools/state/tests');
  fs.mkdirSync(parent, {recursive: true});
  const dir = fs.mkdtempSync(path.join(parent, 'openleague-continuity-'));
  // Only this exact test-created directory is reclaimed.
  t.after(() => {
    if (path.dirname(path.resolve(dir)) !== path.resolve(parent) || !path.basename(dir).startsWith('openleague-continuity-')) throw new Error('Unexpected cleanup path');
    fs.rmSync(dir, {recursive: true});
  });
  return dir;
}
const note = () => ({objective: 'Continue the current task', done: [], in_progress: [], validation: [], blockers: [], next: ['Inspect current source'], evidence: [], limits: []});

test('handoff rejects empty next actions and fabricated scalar validation', () => {
  assert.throws(() => validateNote({...note(), next: []}));
  assert.throws(() => validateNote({...note(), validation: true}));
  assert.deepEqual(validateNote(note()), note());
});

test('handoff input cannot escape the project', t => {
  const dir = fixture(t);
  assert.throws(() => inside(dir, '../private.json'));
  assert.throws(() => inside(dir, path.resolve(dir, 'absolute.json')));
  assert.equal(inside(dir, 'notes/task.json'), path.join(dir, 'notes/task.json'));
});

test('junction escape is rejected', t => {
  const dir = fixture(t), other = fixture(t);
  fs.symlinkSync(other, path.join(dir, 'outside'), process.platform === 'win32' ? 'junction' : 'dir');
  assert.throws(() => inside(dir, 'outside/note.json'));
});

test('handoff observes a dirty Git tree without changing its index or context', t => {
  const dir = fixture(t);
  const git = args => { const r = spawnSync('git', ['-C', dir, ...args], {encoding: 'utf8'}); assert.equal(r.status, 0, r.stderr); return r.stdout; };
  git(['init', '-q']);
  fs.writeFileSync(path.join(dir, 'AGENTS.md'), 'Project instructions\n');
  git(['add', 'AGENTS.md']);
  git(['-c', 'user.name=Continuity Test', '-c', 'user.email=test@example.invalid', 'commit', '-qm', 'test: baseline']);
  fs.writeFileSync(path.join(dir, 'AGENTS.md'), 'Changed instructions\n');
  const index = fs.readFileSync(path.join(dir, '.git/index'));
  const result = makeHandoff(dir, note());
  assert.equal(result.git.head.length, 40);
  assert.match(result.git.changes, /^ M AGENTS\.md/m);
  assert.equal(result.context[0].sha256, sha256('Changed instructions\n'));
  assert.deepEqual(fs.readFileSync(path.join(dir, '.git/index')), index);
  assert.equal(result.checkpoint.available, false);
  assert.match(result.acceptance, /No completion/);
});

test('Gemini adapter preserves unrelated settings and skills', t => {
  const dir = fixture(t);
  fs.mkdirSync(path.join(dir, '.gemini/skills/existing'), {recursive: true});
  fs.writeFileSync(path.join(dir, '.gemini/skills/existing/SKILL.md'), 'existing');
  fs.writeFileSync(path.join(dir, '.gemini/settings.json'), JSON.stringify({theme: 'dark', mcpServers: {other: {command: 'other'}}}));
  fs.mkdirSync(path.join(dir, '.rulesync/skills/openleague-resume'), {recursive: true});
  fs.writeFileSync(path.join(dir, '.rulesync/skills/openleague-resume/SKILL.md'), 'resume');
  fs.writeFileSync(path.join(dir, 'AGENTS.md'), 'shared rules');
  fs.writeFileSync(path.join(dir, '.rulesync/mcp.jsonc'), JSON.stringify({mcpServers: {'openleague-memory': {command: 'node', args: ['.ai-tools/memory.mjs'], timeout: 120000}}}));
  mergeGemini(dir);
  const settings = JSON.parse(fs.readFileSync(path.join(dir, '.gemini/settings.json')));
  assert.equal(settings.theme, 'dark');
  assert.equal(settings.mcpServers.other.command, 'other');
  assert.equal(fs.readFileSync(path.join(dir, 'GEMINI.md'), 'utf8'), 'shared rules');
  assert.equal(fs.readFileSync(path.join(dir, '.gemini/skills/existing/SKILL.md'), 'utf8'), 'existing');
});
