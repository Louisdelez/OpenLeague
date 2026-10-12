from pathlib import Path
import json,hashlib,shutil,re
from datetime import datetime,timezone
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();receipt='docs/native_complex_particle_storage_progress.json';log='logs/native-complex-particle-storage-core-tests.log'
def load(path):return json.loads((r/path).read_text(encoding='utf-8-sig'))
def sha(path):return hashlib.sha256((r/path).read_bytes()).hexdigest()
assert 'test result: ok. 494 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
native=load('data/4.20/complex_particle_storage_contract.json');assert len(native['cases'])==72 and len(native['map_uv_case']['packets'])==27
next_action='Achever la suppression native complète des particules et les ressources de traînée, l’origine des trois mots de mouvement, les valeurs globales et les transformations propriétaires ; terminer les mises à jour mouvement/surface/couleur et raccorder les 52 groupes et 244 placements Map10 au rendu, reconstruire les applications puis poursuivre les 24 domaines.'
files=['data/4.20/complex_particle_storage_contract.json','tools/probe_native_complex_particle_storage.py','data/4.20/complex_uv_birth_contract.json','data/4.20/complex_uv_update_contract.json','crates/core/src/native_complex_particle_storage.rs','crates/core/src/native_complex_uv_parameters.rs','crates/core/src/native_complex_uv_scroll.rs','crates/core/src/lib.rs',log]
executables=list((r/'target/debug/deps').glob('openleague_core-*.exe'))
files.append(str(max(executables,key=lambda p:p.stat().st_mtime).relative_to(r)).replace('\\','/'))
proof={'updated_utc':now,'complete':False,'native_sha256':native['native_sha256'],'core_tests_passed':494,'native_particle_append_cases':72,'native_appended_particles':144,'native_buffers_per_particle':13,'actual_map_uv_storage_particles':27,'stored_uv_frame_cases':512,'actual_cpu_x87_copies':native['actual_cpu_x87_copies'],'emulator_cpu_case_disagreements':native['emulator_cpu_case_disagreements'],'ordinary_emitter_consumer_bound':False,'ordinary_applications_rebuilt':False,'product_rust_sources_changed':True,'artifacts_sha256':{p:sha(p) for p in files},'findings':['Original entire937890append and all13buffer helpers captured across72cases/144particles, with empty/preallocated storage, native growth, optional height and0/1/4newborn null trail slots.','Owned Rust records match every captured channel and height callback argument. Actual CPU5859FLD/FSTPcopies qualify matrix/height/argument NaN quieting;24emulator discrepancies preserved separately.','Three native motion words are read without writes in937890. Their caller scratch and native global vectors remain explicit supplied inputs with unresolved source semantics.','27actualMap10UVconfigurations and shared birth draws are composed with full native storage; Rust matches all13buffer outputs. Stored UV updates additionally match512native/CPU/CRTframe cases and preserve companion attributes.'],'adapters':native['adapters'],'limits':native['limits']+['494core source tests passed. This is CPU storage and integration evidence, not a rebuilt ordinary renderer or visual acceptance.','Full birth payload production, scratch/global/owner source semantics, trail resource ownership, removal and motion/surface update remain incomplete.','No domain or champion kit closed; complete map, six-client graphical match and full game/package remain unqualified.'],'next_action':next_action}
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
history=r/'docs/plan_history'/('complex-particle-storage-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'));history.mkdir(parents=True,exist_ok=True)
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json','goal_plan_revision.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,native_complex_particle_storage_progress=receipt)
 if name=='goal_plan_revision.json':d.update(core_tests_passed=494,core_source_tests_passed=494,latest_native_execution_progress=receipt,next_steps=[next_action])
 else:
  d['complete']=False;e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(core_tests_passed=494,latest_native_execution_progress=receipt,complex_particle_append_cases=72,native_appended_particles=144,native_buffers_per_particle=13,actual_map_uv_storage_particles=27,stored_uv_frame_cases=512,latest_core_test_log=log)
  if name=='resume_checkpoint.json':e['core_tests']=494;d.update(saved_utc=now,next_projected_action=next_action)
  if name=='completion_plan.json':
   d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
   for domain in d['domains']:
    if domain['id'] in ('03','10','15'):
     domain.setdefault('progress_evidence',[])
     if receipt not in domain['progress_evidence']:domain['progress_evidence'].append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in (r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt',r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt',Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'),Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')):
 s=p.read_text(encoding='utf-8').replace('491 tests moteur','494 tests moteur');s=re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)',f'PROCHAINE ÉTAPE : {next_action}',s,flags=re.S);p.write_text(s,encoding='utf-8')
p=r/'docs/completion_plan.json';d=load('docs/completion_plan.json');d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');section='<section id="native-complex-particle-storage"><h2>Stockage des particules</h2><p>72 cas natifs, 144 particules et 13 buffers vérifiés ; transfert des UV de 27 groupes de la carte et 512 mises à jour UV comparés. 494 tests moteur passent. La suppression, les ressources de traînée, les sources de mouvement et le raccordement graphique restent à terminer.</p><a href="native_complex_particle_storage_progress.json">Preuves et limites</a></section>';s=re.sub(r'<section id="native-complex-particle-storage">.*?</section>',section,s,flags=re.S) if 'id="native-complex-particle-storage"' in s else s.replace('</body>',section+'</body>');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'receipt':receipt,'core_tests':494,'complete':False}))
