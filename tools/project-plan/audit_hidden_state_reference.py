"""Explicit local hidden-state contracts; no historical wire or whole-game confidentiality claim."""
import pathlib,json,hashlib,re
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision106')
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
TARGETS=[f'SYS-13.3-{i:02}' for i in range(1,8)]
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
CANDIDATE_SHA='ff6c02a328f148fd528d6f7ec3a872ad0dc0d0651b07f6feee858a0764094ca9'
def collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 candidate=load(V/'hidden-state-associations.json');source=load(V/'hidden-state-source-review.json');scope=load(V/'hidden-state-field-scope.json');tests=load(V/'hidden-state-tests.json')
 check('fixed_candidate',keep(V/'hidden-state-associations.json')['sha256']==CANDIDATE_SHA)
 for name in ['hidden-state-source-review.json','hidden-state-field-scope.json','hidden-state-tests.json']:keep(V/name)
 for d in [candidate,source]:check('producer_'+d['producer']['path'],keep(d['producer']['path'])==d['producer'])
 for s in candidate['current_sources']+source['current_sources']+scope['sources']:check('source_'+s['path'],keep(s['path'])==s)
 lib=(root/'crates/core/src/lib.rs').read_text(encoding='utf8');body=lib.split('pub struct Snapshot {',1)[1].split('\n}',1)[0];fields=re.findall(r'^\s*pub (\w+)\s*:',body,re.M)
 check('31fields',fields==source['snapshot_fields'] and len(fields)==31)
 projection=(root/'crates/core/src/vision.rs').read_text(encoding='utf8');references=[dict(line=i+1,text=l.strip()) for i,l in enumerate(projection.splitlines()) if 'snapshot.' in l or '.retain(' in l];check('projection_references',references==source['snapshot_projection_references'])
 check('explicit_local_protocol','not the original wire format' in (root/'crates/core/src/attack_presentation.rs').read_text(encoding='utf8'))
 check('explicit_session_mode','legacy UDP remains an explicit separate mode' in (root/'crates/client/src/session_connection.rs').read_text(encoding='utf8'))
 check('test_census',tests['passed'] is True and tests['complete'] is True and len(tests['cases'])==10)
 for c in tests['cases']:
  for k in ['binary','log']:check(k+'_'+c['name'],keep(c[k]['path'])==c[k])
  text=pathlib.Path(c['log']['path']).read_text(encoding='utf8');check('test_'+c['name'],c['passed'] is True and c['exit_code']==0 and '--exact' in c['command'] and '--locked' in c['command'] and '--offline' in c['command'] and '1 passed; 0 failed' in text and 'test '+c['name']+' ... ok' in text)
 for a in candidate['associations']:
  check('partial_local_'+a['task_id'],a['native_bindings']==[] and a['entry_boundary_only'] is False and a['full_task_scope_complete'] is False)
  for anchor in a['anchors']:check('anchor_'+anchor['role'],anchor['needle'] in (root/anchor['path']).read_text(encoding='utf8').splitlines()[anchor['line']-1])
 return dict(candidates=candidate,sources=source,scope=scope,tests=tests,source_checks=checks,explicit_local_contract=True,full_confidentiality_qualified=False,historical_wire_equivalence=False,game_or_gpu_executed=False),list(pins.values())
_CACHE={}
def audit(q,root='F:/OpenLeague',verify_files=True):
 require(verify_files,'no bypass');root=pathlib.Path(root);key=str(root.resolve());require(q['schema']=='openleague_hidden_state_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 if key not in _CACHE:_CACHE[key]=collect(root)
 f,p=_CACHE[key]
 for s in p:require(pin(s['path'])==s,'source changed '+s['path'])
 require(q['facts']==f and q['source_identities']==p,'changed facts/sources');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require(q['associations']==f['candidates']['associations'],'associations changed');require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==a['task_id'],'unknown binding')
 return dict(verified=True,checks_count=len(q['checks']),tasks=7,roles=14,source_pins=len(p),rust_tests=10,explicit_local_contract=True,native_or_game_executed=False)
