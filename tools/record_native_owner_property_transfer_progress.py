from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat();receipt='docs/native_projectile_owner_property_transfer_progress.json'
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
a=load('data/4.20/projectile_owner_property_transfer_contract.json');assert a['passed'] and len(a['cases'])==48
(r/'data/4.20/projectile_owner_property_transfer_contract.json').write_text(json.dumps(a,indent=2)+'\n',encoding='utf-8')
log='logs/native-projectile-owner-property-transfer-tests.log';assert 'test result: ok. 2 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
files=['data/4.20/projectile_owner_property_transfer_contract.json','tools/probe_native_projectile_owner_property_transfer.py','crates/core/src/native_projectile_owner_properties.rs',log]
next_action='Qualifier les coefficients/consommateurs de taille et visibilité de la ressource Annie, puis raccorder les paramètres ; poursuivre statuts, drapeaux, ordonnancement et les 24 domaines/114 tâches.'
proof=dict(updated_utc=now,complete=False,passed=True,native_sha256=a['native_sha256'],native_cases=48,prior_callback_cases=24,native_instruction_addresses=a['native_instruction_addresses'],focused_core_tests_passed=2,full_suites_rerun=False,client_owner_properties_integrated=False,current_runtime_capture=False,artifacts_sha256={p:sha(p) for p in files},findings=a['findings']+['Rust composition preserves source fields and passes original callbacks/setters into the qualified Troy property port;48composition profiles plus24callback regressions passed.'],adapters=a['adapters'],limits=a['limits']+['Client still supplies network disappearance as a controller-end trigger. Concrete property callbacks are not yet connected to the graphical consumer.','Optional body shapes, visibility overrides, actual Annie child/coefficient producers, full request reset and renderer consumers remain open.','Prior v20 graphics retain their original hashes; no new graphical build or current runtime qualification claimed.','Zero accepted domains; complete24domain114task objective preserved.'],next_action=next_action)
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
h=r/'docs/plan_history'/('native-owner-property-transfer-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));h.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 p=r/'docs'/name;shutil.copy2(p,h/name);d=load('docs/'+name);d.update(updated_utc=now,native_projectile_owner_property_transfer_progress=receipt)
 changes=dict(latest_native_execution_progress=receipt,native_projectile_owner_property_transfer_cases=48,native_projectile_owner_property_transfer_focused_core_tests=2,native_projectile_owner_properties_client_integrated=False)
 if name=='goal_plan_revision.json':d.update(**changes,next_steps=[next_action])
 else:
  d.setdefault('last_verified' if name=='resume_checkpoint.json' else 'current_evidence',{}).update(changes)
  if name=='resume_checkpoint.json':d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:];assert len(d['domains'])==24 and sum(len(x['tasks']) for x in d['domains'])==114
   for dom in d['domains']:
    if str(dom['id']).zfill(2) in ['03','15']:dom.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,h/p.name);s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Transfert des paramètres du propriétaire</h2><p>48 compositions natives et24 callbacks contrôlés par2tests ciblés. Taille nulle et facteurs enfant, visibilité et paramètres transférés. Producteurs des coefficients Annie et raccordement au rendu encore ouverts.</p><a href="native_projectile_owner_property_transfer_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(receipt)
