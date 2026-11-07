"""Read exact external-reference decisions; never infer native LoL semantics."""
import json,hashlib,pathlib
REPOS=['bevyengine/bevy','chrisgliddon/bevy-skills','ChronoCoders/spawn','criticaldeveloper/codex-game-studio','dimforge/rapier','gfx-rs/wgpu','ketd/AnvilKit','leonardomso/rust-skills','Luminary-Analytics/plinth','mike007jd/game-superpowers','poorvith-mp/skills-gamedev','qiuaoru-coder/game-design-agent-skills']
PATHS=['crates/client/src/main.rs','crates/client/Cargo.toml','Cargo.toml','.ai-tools/project.mjs','crates/core/src/collision.rs','crates/client/examples/selector7_depth_gpu_probe.rs','crates/client/Cargo.toml','Cargo.toml','crates/client/src/main.rs','tools/project-plan/instructions.py','tools/project-plan/requirement_trace.py','tools/project-plan/requirement_trace.py']
RECEIPT='docs/reference_adoption_sources/decisions-v158.json'
class ReferenceDecisionError(ValueError):pass
def require(ok,message):
 if not ok:raise ReferenceDecisionError(message)
def audit(document,root,source_root):
 root=pathlib.Path(root).resolve(); source_root=pathlib.Path(source_root).resolve()
 catalog=json.loads((source_root/'catalog.json').read_bytes()); catalog={x['repo']:x for x in catalog}
 rows=document['decisions'];require(len(rows)==12,'Expected twelve decisions')
 expected={f'REF-{i+1:02}-ADOPT':(repo,PATHS[i]) for i,repo in enumerate(REPOS)}
 require(len({r['task_id'] for r in rows})==12,'Duplicate task')
 require({r['task_id'] for r in rows}==set(expected),'Unexpected task')
 for r in rows:
  repo,relative=expected[r['task_id']]; require(r['repository']==repo,'Repository rebound')
  require(r['commit']==catalog[repo]['commit'],'Commit changed')
  require(r['native_authority'] is False and r['full_task_scope_complete'] is False,'Scope overclaim')
  require(bool(r['decision']) and bool(r['decision_scope']),'Missing decision')
  source_name='Cargo.toml' if repo=='bevyengine/bevy' else 'README.md'
  for key,p,needle,lines in [('source',source_root/repo.replace('/','__')/source_name,r['source_anchor'],r['source_lines']),('current_consumer',root/relative,r['consumer_anchor'],r['consumer_lines'])]:
   pin=r[key];require(pathlib.Path(pin['path']).resolve()==p.resolve(),'Path rebound')
   data=p.read_bytes();require(len(data)==pin['bytes'] and hashlib.sha256(data).hexdigest()==pin['sha256'],'Content changed')
   content=data.decode('utf-8-sig').splitlines();require(bool(needle) and bool(lines),'Missing anchor')
   require(all(type(n)==int and 0<n<=len(content) and needle in content[n-1] for n in lines),'Anchor changed')
  original=next(f for f in catalog[repo]['files'] if f['path']==source_name)
  require(r['source']['sha256']==original['sha256'],'Catalog identity mismatch')
 return {'verified':True,'decisions':12,'native_authority':False,'full_adoption_complete':False}
def resolve(task_id,root,source_root):
 document=json.loads((pathlib.Path(root)/RECEIPT).read_bytes());audit(document,root,source_root)
 rows=[r for r in document['decisions'] if r['task_id']==task_id]
 require(len(rows)==1,'Unknown reference decision task')
 return rows[0]
