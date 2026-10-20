import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { spawnSync, spawn } from 'node:child_process';

export const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const contextFiles = ['AGENTS.md', 'docs/ai/CURRENT.md', 'docs/ai/HANDOFF.md', 'docs/ai/DECISIONS.md'];
export const sha256 = data => crypto.createHash('sha256').update(data).digest('hex');

export function inside(base, relative) {
  if (path.isAbsolute(relative)) throw new Error('Use a project-relative path');
  const full = path.resolve(base, relative);
  const rel = path.relative(base, full);
  if (rel === '..' || rel.startsWith(`..${path.sep}`) || path.isAbsolute(rel)) throw new Error('Path leaves project');
  let probe = full;
  while (!fs.existsSync(probe)) probe = path.dirname(probe);
  const realBase = fs.realpathSync(base);
  const realProbe = fs.realpathSync(probe);
  const actual = path.relative(realBase, realProbe);
  if (actual === '..' || actual.startsWith(`..${path.sep}`) || path.isAbsolute(actual)) throw new Error('Symlink leaves project');
  return full;
}

export function readJson(file) { return JSON.parse(fs.readFileSync(file, 'utf8').replace(/^\uFEFF/, '')); }

export function gitState(base) {
  const run = args => {
    const result = spawnSync('git', ['--no-optional-locks', '-C', base, ...args], {
      encoding: 'utf8', windowsHide: true, timeout: 15000, maxBuffer: 4 * 1024 * 1024
    });
    return result.status === 0 ? result.stdout.trimEnd() : null;
  };
  return {
    head: run(['rev-parse', 'HEAD']),
    branch: run(['branch', '--show-current']),
    changes: run(['status', '--porcelain=v1', '--untracked-files=normal']),
    note: 'Read-only Git observation; no fetch, index refresh, staging or reset.'
  };
}

export function checkpoint(base) {
  const file = path.join(base, 'docs/resume_checkpoint.json');
  if (!fs.existsSync(file)) return { available: false, note: 'Detailed local checkpoint absent in this clone' };
  const data = readJson(file);
  return {
    available: true, file: 'docs/resume_checkpoint.json',
    file_modified_utc: fs.statSync(file).mtime.toISOString(),
    recorded_updated_utc: data.updated_utc ?? data.saved_utc ?? null,
    next_action: data.next_action ?? null,
    warning: 'Recorded evidence only. Internal dates may predate later appended evidence; verify the relevant linked receipt.'
  };
}

export function validateNote(note) {
  if (!note || typeof note !== 'object' || Array.isArray(note)) throw new Error('Expected a JSON object');
  if (typeof note.objective !== 'string' || !note.objective.trim()) throw new Error('objective is required');
  for (const key of ['done', 'in_progress', 'validation', 'blockers', 'next', 'evidence', 'limits']) {
    if (!Array.isArray(note[key]) || note[key].some(v => typeof v !== 'string')) throw new Error(`${key} must be a list of strings`);
  }
  if (!note.next.some(s => s.trim())) throw new Error('At least one concrete next action is required');
  if (JSON.stringify(note).length > 64000) throw new Error('Keep the handoff below 64 KB; link detailed evidence');
  return note;
}

export function makeHandoff(base, note) {
  validateNote(note);
  return {
    schema: 'openleague-agent-handoff/v1', created_utc: new Date().toISOString(),
    project: 'OpenLeague', git: gitState(base), checkpoint: checkpoint(base),
    context: contextFiles.filter(f => fs.existsSync(path.join(base, f))).map(f => ({path: f, sha256: sha256(fs.readFileSync(path.join(base, f)))})),
    note,
    authority: 'Context only; follow the receiving session user request and verify the working tree.',
    acceptance: 'No completion or fresh test result is inferred by this tool.'
  };
}

export function packageBin(name) {
  const dir = path.join(root, '.ai-tools/node_modules', name);
  const pkg = readJson(path.join(dir, 'package.json'));
  const bin = typeof pkg.bin === 'string' ? pkg.bin : Object.values(pkg.bin)[0];
  return path.resolve(dir, bin);
}

function runPackage(name, args, inherit = true) {
  const result = spawnSync(process.execPath, [packageBin(name), ...args], {
    cwd: root, stdio: inherit ? 'inherit' : 'pipe', encoding: 'utf8', windowsHide: true,
    timeout: 120000, maxBuffer: 4 * 1024 * 1024
  });
  if (result.error) throw result.error;
  if (result.status !== 0) throw new Error(`${name} exited ${result.status}: ${result.stderr ?? ''}`);
  return result.stdout;
}

export function mergeGemini(base) {
  // Gemini CLI uses the same canonical rules and skills. Rulesync 35 has no Gemini target.
  const instructions = fs.readFileSync(path.join(base, 'AGENTS.md'), 'utf8');
  fs.writeFileSync(path.join(base, 'GEMINI.md'), instructions);
  const target = path.join(base, '.gemini/settings.json');
  const settings = fs.existsSync(target) ? readJson(target) : {};
  const servers = readJson(path.join(base, '.rulesync/mcp.jsonc')).mcpServers;
  const memory = servers['openleague-memory'];
  settings.mcpServers = {...settings.mcpServers, 'openleague-memory': {command: memory.command, args: memory.args, timeout: memory.timeout}};
  fs.mkdirSync(path.dirname(target), {recursive: true});
  fs.writeFileSync(target, `${JSON.stringify(settings, null, 2)}\n`);
  const source = path.join(base, '.rulesync/skills');
  for (const name of fs.readdirSync(source)) {
    if (!name.startsWith('openleague-')) continue;
    const out = path.join(base, '.gemini/skills', name);
    fs.mkdirSync(out, {recursive: true});
    fs.copyFileSync(path.join(source, name, 'SKILL.md'), path.join(out, 'SKILL.md'));
  }
}

function doctor() {
  const required = [...contextFiles, 'GEMINI.md', 'CLAUDE.md', '.github/copilot-instructions.md', 'opencode.jsonc', '.mcp.json', '.codex/config.toml', '.gemini/settings.json', '.rulesync/mcp.jsonc'];
  const files = required.map(file => ({file, exists: fs.existsSync(path.join(root, file))}));
  const packages = ['rulesync', 'continues', 'repomix'].map(name => {
    try { const p = readJson(path.join(root, '.ai-tools/node_modules', name, 'package.json')); return {name, installed: fs.existsSync(packageBin(name)), version: p.version}; }
    catch { return {name, installed: false}; }
  });
  const python = path.join(root, '.ai-tools/.venv', process.platform === 'win32' ? 'Scripts/python.exe' : 'bin/python');
  const ok = files.every(f => f.exists) && packages.every(p => p.installed) && fs.existsSync(python);
  console.log(JSON.stringify({ok, root, node: process.version, files, packages, memory_python_installed: fs.existsSync(python), client_sessions_tested: false, note: 'Configuration presence is not proof that every external agent loaded it.'}, null, 2));
  if (!ok) process.exitCode = 1;
}

export async function main(args) {
  const [command = 'help', ...rest] = args;
  if (command === 'resume') {
    for (const file of contextFiles) {
      const full = path.join(root, file);
      if (fs.existsSync(full)) console.log(`\n--- ${file} ---\n${fs.readFileSync(full, 'utf8')}`);
    }
    const git = gitState(root);
    const lines = (git.changes ?? '').split('\n');
    if (lines.length > 80) git.changes = `${lines.slice(0, 80).join('\n')}\n... ${lines.length - 80} more entries; inspect git status for the full list.`;
    console.log(JSON.stringify({git, checkpoint: checkpoint(root)}, null, 2));
  } else if (command === 'doctor') doctor();
  else if (command === 'sync') { runPackage('rulesync', ['generate']); mergeGemini(root); }
  else if (command === 'check') {
    runPackage('rulesync', ['generate', '--check']);
    if (fs.readFileSync(path.join(root, 'GEMINI.md'), 'utf8') !== fs.readFileSync(path.join(root, 'AGENTS.md'), 'utf8')) throw new Error('GEMINI.md is stale; run sync');
  } else if (command === 'handoff') {
    if (rest.length !== 2 || rest[0] !== '--input') throw new Error('Usage: handoff --input <project-relative-note.json>');
    const bundle = makeHandoff(root, readJson(inside(root, rest[1])));
    const id = `${Date.now()}-${crypto.randomUUID()}`;
    const out = inside(root, `.ai-tools/state/handoffs/${id}.json`);
    fs.mkdirSync(path.dirname(out), {recursive: true});
    fs.writeFileSync(out, `${JSON.stringify(bundle, null, 2)}\n`, {flag: 'wx'});
    console.log(`Private handoff: ${out}\nReceiving agent: read this file, run node .ai-tools/project.mjs resume, and verify current files before continuing.`);
  } else if (command === 'sessions') {
    if (rest.length) throw new Error('sessions takes no arguments; use continues directly for advanced filters');
    const {getSessionsByCwd} = await import(pathToFileURL(path.join(root, '.ai-tools/node_modules/continues/dist/utils/index.js')).href);
    const sessions = await getSessionsByCwd(root);
    console.log(JSON.stringify({project: root, total: sessions.length, sessions: sessions.slice(0, 20).map(s => ({id: s.id, source: s.source, cwd: s.cwd, updatedAt: s.updatedAt, summary: s.summary})), note: 'Only matching project sessions are shown. The upstream local cache can contain metadata for other projects.'}, null, 2));
  } else if (command === 'switch') {
    if (rest.length !== 3 || rest[1] !== '--in' || !/^[a-z0-9_-]+$/i.test(rest[0]) || !['claude','codex','copilot','gemini','opencode','kimi','cursor','droid','qwen-code'].includes(rest[2])) throw new Error('Usage: switch <session-id> --in <claude|codex|copilot|gemini|opencode|kimi|cursor|droid|qwen-code>');
    const child = spawn(process.execPath, [packageBin('continues'), 'resume', rest[0], '--in', rest[2]], {cwd: root, stdio: 'inherit', windowsHide: false});
    child.on('error', e => { console.error(e.message); process.exitCode = 1; });
    child.on('exit', code => { process.exitCode = code ?? 1; });
  } else if (command === 'export') {
    fs.mkdirSync(path.join(root, '.ai-tools/state'), {recursive: true});
    runPackage('repomix', ['--config', 'repomix.config.json']);
  } else {
    console.log('OpenLeague continuity: resume | doctor | sync | check | handoff --input <note.json> | sessions | switch <session-id> --in <tool> | export');
    if (command !== 'help') process.exitCode = 1;
  }
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  main(process.argv.slice(2)).catch(error => { console.error(error.message); process.exitCode = 1; });
}
