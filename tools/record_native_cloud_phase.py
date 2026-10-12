from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof=load('data/4.20/native_cloud_phase_contract.json');assert proof['passed'] and proof['case_count']==72 and proof['wrap']==10
tests=(r/'logs/native-cloud-phase-client-tests.log').read_text(encoding='utf-8-sig');assert '240 passed; 0 failed' in tests
binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest();assert binary=='d802f486c1f1318cab03f6f838c49961f2c1a11cb73c9654253bbda4a13153d2'
receipt=dict(updated_utc=now,complete=False,product_source_changed=True,native_cloud_phase_ported_to_rust=True,
 native_cloud_phase_cases=72,client_tests_passed=240,native_wrap_threshold=10.,native_wrap_strict=True,native_wrap_single_subtraction=True,
 application_binary_unchanged=True,application_binary_sha256=binary,native_cloud_runtime_gpu_integrated=False,
 artifacts=['data/4.20/native_cloud_phase_contract.json','crates/client/src/native_cloud_phase.rs','logs/native-cloud-phase-client-tests.log'],
 limits=proof['limits']+['Rust phase matches all72 original instruction cases, including negative values and long deltas. Full original x87 precision over all possible IEEE inputs not proven.',
 'The new module is not yet bound to production cloud uniforms. No new game executable build/capture; prior gamma/UTF8 framebuffer retained.','Blender high fog/cloud materials remain unfinished.'])
receipt['hashes']={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in receipt['artifacts']}
action='Qualifier le filtrage effectif du sampler s7 et la fusion des macros de brouillard dans le constructeur de shader. Phase native et constantes c231 qualifiées sur72cas et portées en Rust avec240tests client réussis. Lier ensuite cette phase et Cloud2 aux shaders terrain/environnement et intégrer brouillard deux couches, interpolation sommet, alpha colormap et couplage vision ; construire et inspecter le nouveau client. Fond Chaos toujours ouvert. Puis cérémonie/audio/sbires, réseau/launcher et partie ordinaire à six clients graphiques, avant les24domaines.'
receipt['next_action']=action;save('docs/native_cloud_phase_progress.json',receipt)
archive=r/'docs/plan_history'/('native-cloud-phase-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_cloud_phase_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
  d['last_verified'].update(client_tests=240,native_cloud_phase_cases=72,native_cloud_wrap_threshold=10.)
 else:d['current_evidence'].update(client_tests=240,native_cloud_phase_cases=72,native_cloud_runtime_gpu_integrated=False)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
shutil.copy2(stage/'record_native_cloud_phase.py',r/'tools/record_native_cloud_phase.py')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Défilement natif des nuages porté en Rust</h2><p>72cas natifs, coordonnées c231 et adresses U/V vérifiés. Seuil exact10, comparaison stricte et soustraction unique préservés. 240tests client réussis. Module Rust encore à lier au GPU ; filtre et shader à qualifier. Jeu incomplet.</p><a href="native_cloud_phase_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(client_tests=240,native_cases=72,wrap=10.,binary_unchanged=True,runtime_gpu_integrated=False)))
