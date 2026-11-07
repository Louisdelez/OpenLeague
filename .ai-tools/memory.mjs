// Project-local stdio MCP launcher. stdout belongs exclusively to the MCP protocol.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawn } from 'node:child_process';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const state = path.join(root, '.ai-tools/state/basic-memory');
const python = path.join(root, '.ai-tools/.venv', process.platform === 'win32' ? 'Scripts/python.exe' : 'bin/python');
if (!fs.existsSync(python)) {
  console.error('Basic Memory is not installed. See docs/ai/README.md. Plain Markdown and project.mjs resume remain usable.');
  process.exit(1);
}
fs.mkdirSync(state, {recursive: true});
const config = path.join(state, 'config.json');
const data = fs.existsSync(config) ? JSON.parse(fs.readFileSync(config, 'utf8')) : {};
data.projects = {openleague: {path: path.join(root, 'docs/ai/memory'), mode: 'local'}};
data.default_project = 'openleague';
data.semantic_search_enabled = false;
data.ensure_frontmatter_on_sync = false;
data.logfire_enabled = false;
data.logfire_send_to_logfire = false;
const serialized = `${JSON.stringify(data, null, 2)}\n`;
if (!fs.existsSync(config) || fs.readFileSync(config, 'utf8') !== serialized) {
  const temporary = path.join(state, `config-${process.pid}-${Date.now()}.tmp`);
  fs.writeFileSync(temporary, serialized, {flag: 'wx'});
  fs.renameSync(temporary, config);
}
const env = {...process.env, BASIC_MEMORY_CONFIG_DIR: state, BASIC_MEMORY_SEMANTIC_SEARCH_ENABLED: 'false', BASIC_MEMORY_LOGFIRE_ENABLED: 'false', BASIC_MEMORY_LOGFIRE_SEND_TO_LOGFIRE: 'false', FASTMCP_CHECK_FOR_UPDATES: 'off', FASTMCP_TELEMETRY_MODE: 'off', FASTMCP_SHOW_SERVER_BANNER: 'false', PYTHONUTF8: '1', PYTHONDONTWRITEBYTECODE: '1'};
const child = spawn(python, ['-B', '-m', 'basic_memory.cli.main', ...(process.argv.slice(2).length ? process.argv.slice(2) : ['mcp'])], {cwd: root, env, stdio: 'inherit', windowsHide: true});
child.on('error', error => { console.error(error.message); process.exitCode = 1; });
child.on('exit', code => { process.exitCode = code ?? 1; });
for (const signal of ['SIGINT', 'SIGTERM']) process.on(signal, () => child.kill(signal));
