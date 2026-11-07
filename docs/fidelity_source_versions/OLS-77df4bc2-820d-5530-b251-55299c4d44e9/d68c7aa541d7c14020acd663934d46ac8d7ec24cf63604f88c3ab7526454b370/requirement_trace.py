"""Read-only requirement/source/consumer/unknown graph for the real plan.

This module exposes evidence and refusals; it never converts an associated
resource, a generic loader or a passing trace check into gameplay acceptance.
"""
import argparse,collections,functools,hashlib,json,pathlib,re,sys,uuid
from fidelity_ids import for_task;import source_versions
from rads_reference_membership import instruction_summary,validate_binding
TRACE='docs/fidelity_requirement_trace_4_20.json'
SOURCES='docs/fidelity_sources_4_20.json'
UNKNOWNS='docs/fidelity_unknowns_4_20.json'
class TraceError(ValueError):pass
def digest(p):
 h=hashlib.sha256()
 with pathlib.Path(p).open('rb') as f:
  while b:=f.read(1024*1024):h.update(b)
 return h.hexdigest()
def unique(rows,key):
 d={x[key]:x for x in rows}
 if len(d)!=len(rows):raise TraceError('Duplicate '+key)
 return d
def documents(root):return [pathlib.Path(root)/p for p in [TRACE,SOURCES,UNKNOWNS]]
@functools.lru_cache(maxsize=2)
def _read(paths,signature):
 docs=[json.loads(pathlib.Path(p).read_bytes()) for p in paths]
 trace,sources,unknowns=docs
 if trace.get('schema')!='openleague_requirement_trace/v1' or sources.get('schema')!='openleague_fidelity_sources/v1' or unknowns.get('schema')!='openleague_fidelity_unknowns/v1':raise TraceError('Invalid trace schema')
 return {'trace':trace,'sources_document':sources,'unknowns_document':unknowns,'requirements':unique(trace['requirements'],'task_id'),'sources':unique(sources['sources'],'source_id'),'consumers':unique(sources['consumers'],'consumer_id'),'unknowns':unique(unknowns['unknowns'],'unknown_id')}
def load(root,required=True):
 paths=documents(root);existing=[p.is_file() for p in paths]
 if not any(existing) and not required:return None
 if not all(existing):raise TraceError('Incomplete source/trace/unknown registry; no invented fallback')
 return _read(tuple(map(str,paths)),tuple((p.stat().st_mtime_ns,p.stat().st_size) for p in paths))
def requirement(task,root):
 bundle=load(root,required=False)
 if bundle is None:return None
 row=bundle['requirements'].get(task['id'])
 if row is None or row['requirement_id']!=for_task(task):raise TraceError('Requirement trace missing or identity rebound: '+task['id'])
 return row
def resolve(task,root):
 bundle=load(root);row=requirement(task,root)
 return {'requirement':row,'native_sources':[{'binding':x,'source':bundle['sources'][x['source_id']]} for x in row['native_inputs']],
  'references':[{'binding':x,'source':bundle['sources'][x['source_id']]} for x in row['reference_inputs']],
  'consumers':[bundle['consumers'][x] for x in row['current_consumers']],
  'unknowns':[bundle['unknowns'][x] for x in row['unknown_ids']]}
def instruction_lines(task,root):
 bundle=load(root,required=False)
 if bundle is None:return []
 row=requirement(task,root)
 lines=['','TRAÇABILITÉ DE CETTE EXIGENCE',f'Registre : {pathlib.Path(root)/TRACE} ; tâche {task["id"]}, exigence {row["requirement_id"]}.',
  'Les liens ci-dessous constatent des ressources et points d’entrée ; ils ne prouvent pas la fidélité ni l’acceptation du comportement.',f'État du lien : {row["status"]}.']; append_entry_boundary_notice(row,lines)
 # Multiple original-code experiments may refer to the same PE. Keep
 # their selectors together so they cannot hide a distinct conflicting file.
 native_groups={}
 for item in row['native_inputs']:native_groups.setdefault(item['source_id'],[]).append(item)
 for sid,items in list(native_groups.items())[:3]:
  src=bundle['sources'][sid]
  bindings=' | '.join(dict.fromkeys('rôle '+item['relation']+' ; sélecteur '+(item.get('selector') or 'non précisé') for item in items))
  lines.append(f'- Source native associée : {src["path"]} ; SHA-256 {src["sha256"]} ; {bindings}.')
  membership_line=instruction_summary(src)
  if membership_line:lines.append(membership_line)
 if not row['native_inputs']:lines.append('- Aucune source native précise résolue pour cette exigence ; conserver la limite ou le contrat local explicite.')
 for cid in row['current_consumers'][:3]:
  c=bundle['consumers'][cid];lines.append(f'- Consommateur actuel ({c["role"]}) : {pathlib.Path(root)/c["path"]}:{c["line"]} ; {c["scope"]}.')
 lines.append(f'Inconnues ouvertes : {len(row["unknown_ids"])} ; recherches et conditions de résolution dans {pathlib.Path(root)/UNKNOWNS}, premiers identifiants '+(', '.join(row['unknown_ids'][:5]) or 'aucun identifiant relevé par cet inventaire, sans garantie de complétude sémantique')+'.')
 lines.append(f'Fiche complète : python -B tools/project-plan/requirement_trace.py --root "{root}" --task "{task["id"]}"')
 return lines
def validate(bundle,registry,root,verify_files=False):
 bytask=bundle['requirements'];sources=bundle['sources'];consumers=bundle['consumers'];unknowns=bundle['unknowns']
 if set(bytask)!={t['id'] for t in registry['tasks']}:raise TraceError('Requirement trace coverage incomplete')
 for t in registry['tasks']:
  row=bytask[t['id']]; validate_entry_boundary_coverage(row,consumers)
  if row['requirement_id']!=for_task(t) or row['required']!=t['required']:raise TraceError('Requirement definition/identity mismatch')
  if row.get('game_behavior_accepted') is not False:raise TraceError('Traceability is not gameplay acceptance')
  if not row['searches']:raise TraceError('Research log missing')
  for edge in row['native_inputs']+row['reference_inputs']:
   if edge['source_id'] not in sources:raise TraceError('Source edge missing')
  for cid in row['current_consumers']:
   if cid not in consumers:raise TraceError('Consumer edge missing')
  for uid in row['unknown_ids']:
   if uid not in unknowns or unknowns[uid]['requirement_id']!=row['requirement_id'] or unknowns[uid]['status']!='open':raise TraceError('Unknown edge missing or assigned to another requirement')
  for uid in row.get('resolved_unknown_ids',[]):
   if uid not in unknowns or unknowns[uid]['requirement_id']!=row['requirement_id'] or unknowns[uid]['status']!='resolved':raise TraceError('Resolved unknown edge inconsistent')
 if {r['legacy_id']:r['children'] for r in bundle['trace']['historical_parent_links']}!={r['legacy_id']:r['children'] for r in registry['crosswalk']}:raise TraceError('Historical links changed')
 if {r['task_id'] for r in bundle['trace']['archived_task_links']}!={r['id'] for r in registry['retired_aggregate_tasks']}:raise TraceError('Archived links lost')
 for u in unknowns.values():
  if not u['question'] or not u['research_performed'] or not u['resolution_condition'] or u['status'] not in ['open','resolved']:raise TraceError('Unknown has no precise question/research/closure or is falsely resolved')
  if u['status']=='resolved' and (not u.get('resolution_evidence') or not u.get('resolution_history')):raise TraceError('Unknown resolved without explicit evidence/history')
 for c in consumers.values():
  validate_entry_boundary_consumer(c,sources)
  if verify_files:
   p=pathlib.Path(root)/c['path'];lines=p.read_text(encoding='utf-8').splitlines()
   if c['line']<1 or c['line']>len(lines) or c['needle'] not in lines[c['line']-1]:raise TraceError('Current consumer anchor changed: '+c['path'])
 for s in sources.values():
  if not s.get('path') or not s.get('kind') or not s.get('origin') or not s.get('version'):raise TraceError('Source provenance/version incomplete')
  if not isinstance(s.get('bytes'),int) or s['bytes']<0 or not re.fullmatch(r'[0-9a-f]{64}',s.get('sha256','')):raise TraceError('Source SHA/size identity invalid')
  expected=s.get('expected_sha256');_versions(s,root,verify_files)
  if expected is not None and s.get('expected_identity_matches')!=(s['sha256']==expected):raise TraceError('Prior source identity comparison misrepresented')
 membership_receipts={}
 for source in sources.values():
  binding=source.get('rads_release_membership')
  if binding is None:continue
  evidence=binding.get('evidence_source_id');receipt=None
  if verify_files and evidence in sources:
   if evidence not in membership_receipts:
    doc=json.loads(pathlib.Path(sources[evidence]['path']).read_bytes())
    if doc.get('schema')!='openleague_native_rads_manifest_membership/v1' or doc.get('audit_completed') is not True:raise TraceError('RADS membership receipt incomplete')
    membership_receipts[evidence]=unique(doc['rows']+doc['recovered_alternatives'],'source_id')
   receipt=membership_receipts[evidence]
  try:validate_binding(source,sources,receipt)
  except (ValueError,KeyError) as e:raise TraceError('Invalid source release membership: '+str(e)) from e
 verified=0
 if verify_files:
  allowed=[pathlib.Path(root).resolve(),pathlib.Path('E:/mapslol3v3').resolve(),pathlib.Path('D:/LeagueOfLegendsV2/4.20').resolve()]
  for s in sources.values():
   p=pathlib.Path(s['path']).resolve()
   if not any(p.is_relative_to(r) for r in allowed):raise TraceError('Source outside explicit project/reference roots')
   if not p.is_file():raise TraceError('Source missing: '+str(p))
   if p.stat().st_size!=s['bytes'] or digest(p)!=s['sha256']:raise TraceError('Source changed: '+str(p))
   verified+=1
 actual_counts={'active_requirements':len(bytask),'sources':len(sources),'consumers':len(consumers),'unknowns':len(unknowns),
  'status':dict(collections.Counter(x['status'] for x in bytask.values())),
  'open_unknowns':sum(x['status']=='open' for x in unknowns.values()),'resolved_unknowns':sum(x['status']=='resolved' for x in unknowns.values())}
 if any(bundle['trace'].get('counts',{}).get(k)!=v for k,v in actual_counts.items()):raise TraceError('Stale trace summary counts')
 if bundle['unknowns_document'].get('open_count')!=actual_counts['open_unknowns'] or bundle['unknowns_document'].get('resolved_count')!=actual_counts['resolved_unknowns']:raise TraceError('Stale unknown summary counts')
 return {'verified':True,'active_requirements':len(bytask),'sources':len(sources),'consumers':len(consumers),'open_unknowns':sum(x['status']=='open' for x in unknowns.values()),'resolved_unknowns':sum(x['status']=='resolved' for x in unknowns.values()),'source_hashes_verified':verified,'gameplay_accepted':False,'manual_state_mutated':False}
def _versions(source,root,verify_files):
 try:source_versions.validate_history(source,root,verify_files)
 except (ValueError,KeyError,TypeError) as e:raise TraceError("Invalid source version history: "+str(e)) from e

def main():
 p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--task');p.add_argument('--verify-files',action='store_true');args=p.parse_args()
 try:
  reg=json.loads((pathlib.Path(args.root)/'docs/completion_tasks_2026-10-20.json').read_bytes());bundle=load(args.root)
  if args.task:
   t=next((x for x in reg['tasks'] if x['id']==args.task),None)
   if t is None:raise TraceError('Unknown task')
   result=resolve(t,args.root)
  else:result=validate(bundle,reg,args.root,args.verify_files)
  print(json.dumps(result,ensure_ascii=False,indent=2));return 0
 except (TraceError,KeyError,OSError,ValueError) as e:print(json.dumps({'verified':False,'error':str(e)},ensure_ascii=False));return 1

def validate_entry_boundary_consumer(consumer,sources):
 if consumer['source_id'] not in sources:raise TraceError('Consumer source missing')
 if consumer.get('qualification_kind')=='entry_boundary_only' and consumer.get('provides_feature_consumer') is not False:
  raise TraceError('Entry boundary cannot claim a feature consumer')

def validate_entry_boundary_coverage(row,consumers):
 assessment=row.get('current_consumer_assessment')
 if assessment is None:return
 if (not isinstance(assessment,dict) or assessment.get('kind')!='entry_boundary_only'
     or assessment.get('feature_consumer_identified') is not False
     or assessment.get('feature_scope_complete') is not False):
  raise TraceError('Invalid or falsely completed entry-boundary assessment')
 if not row['unknown_ids']:raise TraceError('Boundary-only feature scope must remain an open question')
 active=[consumers[c] for c in row['current_consumers'] if c in consumers and consumers[c]['role']!='plan_requirement_consumer']
 if not active or any(c.get('qualification_kind')!='entry_boundary_only' or c.get('provides_feature_consumer') is not False for c in active):
  raise TraceError('Boundary-only assessment needs actual boundary anchors,not a feature claim')
 if not any(e.get('relation')=='entry_boundary_scope_evidence' for e in row['reference_inputs']):
  raise TraceError('Boundary-only assessment lacks scoped source evidence')

def append_entry_boundary_notice(row,lines):
 if row.get('current_consumer_assessment',{}).get('kind')=='entry_boundary_only':
  lines.append('- Limite actuelle : seules les frontières d’entrée sont identifiées ; le consommateur de la fonctionnalité demandée reste à identifier et qualifier. Un champ ignoré ou refusé ne valide ni effets, ni affichage, ni persistance.')

if __name__=='__main__':raise SystemExit(main())
