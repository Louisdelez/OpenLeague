from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/annie_native_clock_consumer_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
log='logs/annie-native-clock-consumer-tests.log';assert 'test result: ok. 3 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
next_action='Achever la construction graphique et capturer deux tirs d’Annie avec horloge native ; qualifier pose, fin de vie, Vulkan et fidélité complète ; poursuivre les 24 domaines.'
files=['crates/client/src/projected_live.rs','crates/core/src/native_troy_clock.rs','crates/core/src/native_troy_resource_initial.rs','data/4.20/simple_owner_end_contract.json',log]
proof=dict(updated_utc=now,complete=False,focused_client_tests_passed=3,native_frames=50,full_client_suite_rerun=False,graphical_client_rebuilt=False,current_runtime_capture=False,build_session_id=89073,artifacts_sha256={p:sha(p) for p in files},findings=['Normal projection now samples native928360 clock and starts via93E5D0 verified core fields.','Absolute f32 clock values reach emission, ages and native stop; prior f64 relative-age subtraction removed.','Actual Lifetime consumer matches50original owner-end frames; asset/entity cleanup regression passes.'],limits=['Local Bevy elapsed seconds supplies time to native wrapper using constructor default origin0/scale1/offset0; original source and pause/speed transitions remain unqualified.','Server disappearance still supplies stop signal; exact original owner/end/collision interface not qualified.','Graphical executable building; no current framebuffer claimed yet. Identity orientation/default factors/FOW1 remain explicit limitations.','Zero completed domains; all24domains114tasks retained.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('annie-clock-consumer-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,annie_native_clock_consumer_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(latest_native_execution_progress=receipt,annie_native_clock_frames=50,annie_native_clock_focused_client_tests=3,annie_source_matches_graphical_binary=False)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Horloge native raccordée à Annie</h2><p>Horloge et démarrage raccordés au consommateur normal : 50 frames originales comparées, 3 tests client passent. Reconstruction graphique en cours ; captures et fidélité complète encore ouvertes.</p><a href="annie_native_clock_consumer_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)

