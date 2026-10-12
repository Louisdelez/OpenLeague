from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_troy_scratch_progress.json';log='logs/native-troy-scratch-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 518 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/troy_reset_contract.json');assert native['passed'] and len(native['cases'])==432
files=['data/4.20/troy_scratch_contract.json','tools/probe_native_troy_scratch.py','crates/core/src/native_troy_scratch.rs','data/4.20/troy_resume_contract.json','tools/probe_native_troy_resume.py','crates/core/src/native_troy_resume.rs','data/4.20/troy_pause_contract.json','tools/probe_native_troy_pause.py','data/4.20/troy_prewarm_contract.json','tools/probe_native_troy_prewarm.py','crates/core/src/native_troy_prewarm.rs','data/4.20/troy_reset_caller_contract.json','tools/probe_native_troy_reset_caller.py','data/4.20/troy_reset_contract.json','tools/probe_native_troy_reset.py','crates/core/src/native_troy_reset.rs','crates/core/src/native_complex_particle_storage.rs','data/4.20/troy_scalar_contract.json','crates/core/src/native_troy_scalar.rs','data/4.20/troy_position_bounds_contract.json','crates/core/src/native_troy_position_bounds.rs','crates/core/src/native_troy_properties.rs','crates/core/src/lib.rs',log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'),key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action='Qualifier la mise à jour complète93F2F0, ses entrées de visibilité et ses producteurs de particules, les producteurs audio réels, les émetteurs à la mort, la carte audio8000, le flag enfant10000 et les mises à jour des émetteurs ; qualifier les corps du gestionnaire et les producteurs natifs, composer le cycle complet puis le raccorder au rendu normal des52groupes/244placements Map10, reconstruire les applications et poursuivre les24domaines.'
caller=load('data/4.20/troy_reset_caller_contract.json');warm=load('data/4.20/troy_prewarm_contract.json');assert len(caller['cases'])==363 and len(warm['cases'])==240
paused=load('data/4.20/troy_pause_contract.json');assert len(paused['cases'])==432 and paused['passed']
resumed=load('data/4.20/troy_resume_contract.json');assert resumed['passed'] and len(resumed['cases'])==1152
scratch=load('data/4.20/troy_scratch_contract.json');assert scratch['passed'] and len(scratch['cases'])==16
proof={'updated_utc':now,'complete':False,'native_sha256':scratch['native_sha256'],'core_tests_passed':518,'scratch_cases':16,'scratch_native_footprint_bytes':300,'scratch_constructor_and_noop_drop_ported':True,'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Whole8E2E80 constructor compared byte-for-byte over16cases: zero/CC/FF/random contents and four alignments.300bytes initialized, tail bytes and16-byte guards preserved.','Native six6BD9D0 constructors execute viaC982E4; subsequent memsets overwrite their temporary values. Final footprint zero except114/118/11C=7F7FFFFF and120/124/128=FF7FFFFF.','OriginalC97C54 vector destruction executes six5642D0 no-op destructors. Stack ret16 and unchanged bytes/guards verified. Rust ownership drop is no-op.','Rust raw75-word packet retains unnamed channels until frame producers qualified. initialize_into rejects undersized destinations before writing.'],'adapters':scratch['adapters'],'limits':scratch['limits']+['Frame93F2F0 and ordinary graphical/audio integration remain incomplete. No domain/champion kit complete.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('troy-scratch-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_troy_scratch_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=518,core_source_tests_passed=518,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=518,latest_native_execution_progress=receipt,troy_scratch_cases=16,troy_scratch_constructor_ported=True,troy_scratch_normal_frame_binding=False,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=518;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     if receipt not in domain.setdefault('progress_evidence',[]):domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('517 tests moteur','518 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-troy-scratch"><h2>Buffer temporaire des effets</h2><p>Constructeur8E2E80 et destructionC97C54 qualifiés sur16captures mémoire. Port Rust de300octets, bornes natives et conservation des octets extérieurs.518tests moteur passent. Consommation par93F2F0 et rendu/audio ordinaires restent à qualifier.</p><a href="native_troy_scratch_progress.json">Preuves et limites</a></section>';s=s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':518,'scratch_cases':16,'complete':False}))
