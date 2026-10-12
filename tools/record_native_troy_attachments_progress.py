from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_attachments_progress.json';log='logs/native-troy-attachments-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 509 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_attachments_contract.json');assert native['passed'] and len(native['cases'])==864
files=['data/4.20/troy_attachments_contract.json','tools/probe_native_troy_attachments.py','crates/core/src/native_troy_attachments.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/native_troy_properties.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Achever reset200, carte audio8000, flag enfant10000 et les mises à jour des émetteurs ; qualifier les corps du gestionnaire de ressources attachées et les producteurs natifs, composer le cycle complet puis le raccorder au rendu normal des52groupes/244placements Map10, reconstruire les applications et poursuivre les24domaines.'
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':509,'native_troy_attachments_cases':864,'native_endpoint_events':948,'attachment_update_ported':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Whole941210 and concrete Troy virtual44/940F30 execute across864profiles.288also include original940C15 stop-bit gate. Rust matches948external endpoint events and their order.','Owner absent/ineligible skips all later calls. Owner key queried before linked-emitter presence and visibility. Only keyFFFFFFFF rejects. Visibility is tested as nonzero raw byte, not LSB.','When allowed, emitter source flag8 selects manager virtual30 versus2C. Each80byte attachment forwards ID, owner key and76byte descriptor unchanged, in original array order. Attachment records are not removed by this helper.','Frame caller skips941210 when emitter flags bit10 set. Whole helper preserves callback order for a null linked emitter; caller profiles exclude illegal null dereference.'],'adapters':native['adapters'],'limits':native['limits']+['508previous core tests and new attachment comparison pass; no domain/champion kit or ordinary graphical integration complete.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-attachments-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_attachments_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=509,core_source_tests_passed=509,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=509,latest_native_execution_progress=receipt,troy_attachments_cases=864,troy_attachments_ported=True,troy_attachments_graphical_binding=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=509;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('508 tests moteur','509 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-attachments"><h2>Ressources attachées Troy</h2><p>Fonction941210 et gate940C15 portés, comparés à864captures natives et948appels externes. Ordre des contrôles, flags, IDs et descripteurs correspondent.509tests moteur passent. Les corps du gestionnaire et le raccordement graphique/audio restent à qualifier.</p><a href="native_troy_attachments_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':509,'native_cases':864,'complete':False}))
