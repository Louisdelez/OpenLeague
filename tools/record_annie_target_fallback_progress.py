from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_target_fallback_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
log='logs/annie-native-target-fallback-tests.log';assert 'test result: ok. 1 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
s=(r/'crates/client/src/annie_q_vfx.rs').read_text(encoding='utf-8');assert 'shot.target_native, target_native, dt' in s
seq=load('data/4.20/missile_motion_sequences_contract.json');missing=sum(not f['live_target'] for c in seq['sequences'] for f in c['frames'])
next_action='Qualifier le routage complet de validité de cible (mort/visibilité) et la pose propriétaire native ; reconstruire et capturer le client modifié, puis poursuivre les24domaines.'
files=['crates/client/src/annie_q_vfx.rs','data/4.20/missile_motion_sequences_contract.json',log]
proof=dict(updated_utc=now,complete=False,focused_client_tests_passed=1,filtered_client_tests=370,full_suite_rerun=False,oracle_frames=384,oracle_missing_target_frames=missing,artifacts_sha256={p:sha(p) for p in files},findings=['Existing visual flight now routes snapshot target absence as None to native motion instead of skipping update. Stored last target persists.','New flights still require an observed launch bone and target; no initial destination is invented.','Client consumer helper matches384native frames, including valid/invalid transitions; ordinary ECS target lookup compiled.'],limits=['Helper oracle and source routing do not constitute runtime capture of disappearing target.','Missing snapshot entity is one validity condition; original virtual90 death/visibility/object lifecycle semantics remain to qualify.','Current graphical binary retains previous-source build until next rebuild; earlier DX12 captures remain scoped to their source hashes.','Native full pose, collisions, stop signal, skins/audio and all24domains remain incomplete.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-target-fallback-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,annie_target_fallback_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(latest_native_execution_progress=receipt,annie_target_fallback_focused_tests=1,annie_source_matches_graphical_binary=False)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Cible absente du projectile d’Annie</h2><p>Le consommateur conserve la dernière cible et poursuit le déplacement natif quand elle disparaît du snapshot. Compilation client et test de384étapes réussis. Validation de mort/visibilité et capture spécifique encore ouvertes.</p><a href="annie_target_fallback_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,missing_target_oracle_frames=missing,complete=False)))
