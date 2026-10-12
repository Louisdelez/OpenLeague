from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_projectile_stop_dispatch_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/projectile_stop_dispatch_contract.json');assert a['passed'] and len(a['cases'])==120
core_log='logs/native-projectile-stop-dispatch-tests.log';client_log='logs/annie-native-stop-dispatch-tests.log'
assert 'test result: ok. 1 passed; 0 failed;' in (r/core_log).read_text(encoding='utf-8-sig')
assert 'test result: ok. 3 passed; 0 failed;' in (r/client_log).read_text(encoding='utf-8-sig')
files=['data/4.20/projectile_stop_dispatch_contract.json','tools/probe_native_projectile_stop_dispatch.py','crates/core/src/native_projectile_stop_dispatch.rs','crates/core/src/lib.rs','crates/client/src/projected_live.rs',core_log,client_log]
next_action='Recompiler le client graphique avec la chaîne native d’arrêt du projectile, vérifier nettoyage et rendu DX12/Vulkan ; qualifier ensuite pose et ordonnancement natifs et poursuivre les 24 domaines.'
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],native_cases=120,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=1,focused_client_tests_passed=3,full_suites_rerun=False,graphical_client_rebuilt=False,current_runtime_capture=False,artifacts_sha256={p:sha(p) for p in files},findings=a['findings'],adapters=a['adapters'],limits=a['limits']+['Native marker/cleanup/request port connected to client Lifetime; existing 50 original owner-end frames and asset-release test pass.','Rust port covers semantic state only; native ownership counters are oracle evidence, not a Rust shared-ownership implementation.','Live disappearance still supplies controller end; local cleanup runs in the same frame. Full original registry scheduling remains unqualified.','Current graphical executable predates this source edit; no new live capture or complete Annie qualification claimed.','Full objective remains incomplete; zero accepted domains.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('projectile-stop-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_projectile_stop_dispatch_progress=receipt)
 changes=dict(latest_native_execution_progress=receipt,native_projectile_stop_dispatch_cases=120,native_projectile_stop_dispatch_focused_core_tests=1,native_projectile_stop_dispatch_focused_client_tests=3,annie_source_matches_graphical_binary=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Arrêt natif du projectile et de son effet</h2><p>120 profils originaux, port Rust et raccordement à Annie : 1 contrôle core et 3 contrôles client réussis. Déclencheur réseau, ordonnancement, pose et nouvelle qualification graphique encore ouverts.</p><a href="native_projectile_stop_dispatch_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
