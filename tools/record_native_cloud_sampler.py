from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sampler=load('data/4.20/native_cloud_sampler_contract.json');options=load('data/4.20/native_renderer_fog_options_contract.json')
assert sampler['passed'] and sampler['case_count']==8 and options['passed'] and options['case_count']==48
binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
assert binary=='d802f486c1f1318cab03f6f838c49961f2c1a11cb73c9654253bbda4a13153d2'
artifacts=['data/4.20/native_cloud_sampler_contract.json','data/4.20/native_renderer_fog_options_contract.json']
action='Qualifier la fusion des définitions statiques des shaders avec les macros globales et environnement : options9608D0 vers initialisation980FA0 puis registres9804C0/980540, compilateurs98C070/98D960. Le filtrage linéaire et WRAP s7 sont prouvés sur la séquence native contrôlée reset/binding ; ordre de la frame et éventuels changements avant les draws restent ouverts. Intégrer ensuite Cloud2, phase native et brouillard deux couches terrain/environnement ; construire et inspecter le nouveau client. Puis cérémonie/audio/sbires, reconnexion, retour launcher, partie ordinaire à six clients graphiques et les24domaines.'
receipt=dict(updated_utc=now,complete=False,native_cloud_sampler_cases=8,native_renderer_options_cases=48,
 controlled_cloud_filter='linear',controlled_cloud_address='wrap',full_frame_sampler_state_qualified=False,
 static_descriptor_macro_merge_qualified=False,native_cloud_runtime_gpu_integrated=False,
 product_runtime_source_changed=False,application_binary_unchanged=True,application_binary_sha256=binary,
 artifacts=artifacts,hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in artifacts},
 limits=sampler['limits']+options['limits'],next_action=action)
save('docs/native_cloud_sampler_progress.json',receipt)
archive=r/'docs/plan_history'/('native-cloud-sampler-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_cloud_sampler_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
  d['last_verified'].update(native_cloud_sampler_cases=8,native_renderer_options_cases=48)
 else:d['current_evidence'].update(native_cloud_sampler_cases=8,native_renderer_options_cases=48,native_cloud_runtime_gpu_integrated=False)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
for name in ['qualify_native_cloud_sampler.py','qualify_native_renderer_fog_options.py','record_native_cloud_sampler.py']:
 shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Filtrage des nuages et options du brouillard</h2><p>8 cas de séquence native : reset linéaire puis répétition U/V des nuages. 48 cas : palette et brouillard transmis à l’initialisation. Fusion des définitions statiques, ordre complet des passes et intégration GPU encore à réaliser. Aucun nouveau test client ni exécutable dans cette étape ; les preuves précédentes gardent leurs empreintes.</p><a href="native_cloud_sampler_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(sampler_cases=8,renderer_options_cases=48,binary_unchanged=True,gpu_integrated=False,plan_saved=True)))
