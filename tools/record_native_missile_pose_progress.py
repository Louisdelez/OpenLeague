from pathlib import Path
import json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_missile_owner_pose_progress.json';log='logs/native-missile-owner-pose-tests.log'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 2 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
o=load('data/4.20/missile_effect_owner_pose_pipeline_contract.json');b=load('data/4.20/missile_effect_owner_full_binding_contract.json');assert o['passed'] and b['passed']
next_action='Qualifier le producteur natif de direction du projectile et sa création complète, raccorder la pose10B0D20 au rendu d’Annie, puis contrôler scale/alpha/récepteurs terrain et poursuivre les24domaines.'
files=['crates/core/src/native_missile_owner_pose.rs','crates/core/src/native_actor_effect_owner.rs','crates/core/src/native_troy_owner_pose.rs','crates/core/src/native_missile_effect_owner.rs','crates/core/src/lib.rs','data/4.20/missile_effect_owner_pose_pipeline_contract.json','data/4.20/missile_effect_owner_full_binding_contract.json','tools/probe_native_missile_pose_pipeline.py','tools/probe_native_missile_full_binding.py',log]
proof=dict(updated_utc=now,complete=False,native_sha256=o['native_sha256'],native_pipeline_cases=72,native_full_binding_cases=16,actual_cpu_rsqrt_operations=9,focused_core_tests_passed=2,filtered_core_tests=592,full_core_suite_rerun=False,ordinary_projected_binding=False,client_rebuilt=False,artifacts_sha256={p:sha(p) for p in files},findings=['Original6C9BD0 and actual Troy vtable68/9286C0 retain the provider at effect+C8/+CC;16combinations execute without virtual receiver adaptation.','72combinations execute binding then full94099A..940AEE owner pose phase with concrete10B0D20 virtual bodies, original Simple setters, direction/matrix copies, status93F1A0 and empty callback queue.','Core native_missile_owner_pose connects common actor position/direction/status ports and projectile orientation to the Troy transfer. Rust matches source/emitter raw words and flags in72native cases.','Direction matrices queried only for source flag10 without20. Missing linkage, expired effect or expired weak owner preserve prior emitter state.'],limits=['Single-threaded mutex adapter; callback queue empty. Complete callback concurrency/destruction not covered here.','RSQRTSS references use the physical CPU; ordinary finite data and default arithmetic modes only.','Projectile creation, live direction producers, complete particle update and ordinary rendering remain incomplete.','Two focused tests run,592filtered; no new full core suite, client rebuild, GPU/audio or champion completion.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('missile-owner-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_missile_owner_pose_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{});e.update(latest_native_execution_progress=receipt,native_missile_owner_pipeline_cases=72,native_missile_owner_full_binding_cases=16,native_missile_owner_focused_tests=2,native_missile_owner_live_bound=False)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15'] and receipt not in dom.setdefault('progress_evidence',[]):dom['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 if p.exists():s=p.read_text(encoding='utf-8');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Pose native du projectile</h2><p>Récepteur natif du propriétaire exécuté sur16cas sans substituer sa fonction. Pose complète avec fournisseur10B0D20 exécutée sur72cas, raccordée au cycle Rust et comparée bit à bit. Deux tests ciblés passent,592filtrés. Direction native du projectile, création complète et rendu normal restent ouverts.</p><a href="native_missile_effect_owner_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')

if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,complete=False,focused_tests=2)))
