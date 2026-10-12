from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,re,shutil
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_actor_effect_owner_progress.json';log='logs/native-actor-effect-owner-orientation-tests.log'
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 2 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
vector=read('data/4.20/actor_effect_owner_contract.json');matrix=read('data/4.20/actor_effect_owner_orientation_contract.json')
assert vector['passed'] and matrix['passed']
next_action='Confirmer le rattachement du fournisseur natif10B0E1C à la projection d’Annie et les producteurs de sa matrice, puis remplacer la pose simplifiée, qualifier scale/alpha/récepteurs terrain et poursuivre les24domaines du plan.'
files=['crates/core/src/native_actor_effect_owner.rs','crates/core/src/lib.rs','tools/probe_native_actor_effect_owner.py','tools/probe_native_actor_effect_orientation.py','data/4.20/actor_effect_owner_contract.json','data/4.20/actor_effect_owner_orientation_contract.json',log]
proof=dict(updated_utc=now,complete=False,native_sha256=vector['native_sha256'],native_vector_status_cases=len(vector['cases']),native_orientation_cases=len(matrix['cases']),actual_cpu_rsqrt_operations=matrix['actual_cpu_rsqrt_operations'],focused_core_tests_passed=2,filtered_core_tests=590,core_full_suite_rerun=False,core_port_implemented=True,ordinary_projected_binding=False,client_rebuilt=False,current_client_unchanged=True,artifacts_sha256={p:sha(p) for p in files},findings=['Concrete vtable10B0E1C supplies position object+60 and direction+6C via live weak/shared owner. Native acquisition and release preserve strong reference count.','Primary status branches on bit400 and type tag02D6DA00; secondary status compares object+114 with provider+C when bit400 is set. Type names in synthetic probe profiles do not prove gameplay class identity.','Orientation719890 copies object+18C0 then718F70 normalizes each row of the3x3 using5FA7C0 approximate sqrt, zeroes translation and forces homogeneousW=1.','Rust matches all measured ordinary finite cases including zero matrix, scaled axes and nonorthogonal rows. RSQRTSS uses the local physical x86 CPU.'],limits=[x for x in vector['limits'] if not x.startswith('Orientation719890')]+matrix['limits']+['Live rendering still uses reconstructed owner pose; no new GPU/audio/full-champion acceptance.','Two focused tests only; historical590 full-suite result is retained without claiming592 full-suite passes.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('actor-effect-owner-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=read('docs/'+name);d.update(updated_utc=now,native_actor_effect_owner_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  e=d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{});e.update(native_actor_effect_owner_cases=96,native_actor_effect_owner_matrix_cases=5,native_actor_effect_owner_focused_tests=2,native_actor_effect_owner_binding=False,latest_native_execution_progress=receipt)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for domain in d['domains']:
    if str(domain['id']).zfill(2) in ['03','15'] and receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
 if p.exists():
  s=p.read_text(encoding='utf-8');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=read('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Fournisseur natif de pose des effets</h2><p>96cas de position/direction/statut et5matrices qualifiés ;15opérations RSQRTSS sur processeur réel. Deux tests Rust ciblés passent,590autres filtrés. Rattachement à Annie et rendu normal encore ouverts.</p><a href="native_actor_effect_owner_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt,complete=False,focused_tests=2)))

