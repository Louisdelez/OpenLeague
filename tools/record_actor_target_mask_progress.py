from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_actor_target_mask_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/actor_target_mask_contract.json');assert a['passed'] and len(a['cases'])==3584
log='logs/native-actor-target-mask-tests.log';assert 'test result: ok. 2 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
next_action='Identifier les producteurs natifs des drapeaux de cible et du mode/sélecteur global, raccorder la pose propriétaire au rendu et vérifier les transitions réelles ; poursuivre les24domaines.'
files=['data/4.20/actor_target_mask_contract.json','tools/probe_native_actor_target_mask.py','crates/core/src/native_actor_target_validity.rs','crates/core/src/lib.rs',log]
proof=dict(updated_utc=now,complete=False,native_sha256=a['native_sha256'],native_cases=3584,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=2,full_core_suite_rerun=False,artifacts_sha256={p:sha(p) for p in files},findings=['Native617F10 with original6B2C30 helper matches Rust across3584profiles, including independently supplied outer/nested manager-mode results.','Raw fields retained: global override, manager mode, actor17C->24/2C and actor5EAbit1. No unsupported death/visibility labels.','Native6B2C30 selector-1 bypasses mask; selector-2 checks lowtwo bits; other selectors use1<<selector with x86 lowfive shift bits. Rust matches native validity and nested mode call order.'],adapters=a['adapters'],limits=a['limits']+['Core-only; network-state mapping and live consumer validity incomplete.','No full-suite/client/runtime qualification; zero domains closed.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('actor-target-mask-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_actor_target_mask_progress=receipt)
 if name=='goal_plan_revision.json':d.update(latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(latest_native_execution_progress=receipt,native_actor_target_mask_cases=3584,native_actor_target_mask_focused_tests=2)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Validité native des cibles</h2><p>3584profils de validité avec calcul original du masque comparés en Rust. Deux tests ciblés passent. Drapeaux bruts, sélecteurs spéciaux et ordre des appels conservés. Producteurs de données et intégration en partie encore ouverts.</p><a href="native_actor_target_mask_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(receipt)
