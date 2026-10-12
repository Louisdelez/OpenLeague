from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof=load('data/4.20/native_shader_macro_merge_contract.json')
assert proof['passed'] and proof['case_count']==1584 and proof['descriptor_count']==33
assert all(c['vertex_and_pixel_submission'] for c in proof['cases'])
binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
assert binary=='d802f486c1f1318cab03f6f838c49961f2c1a11cb73c9654253bbda4a13153d2'
action='Intégrer Cloud2 et la phase Rust native aux uniforms terrain/environnement, puis brouillard à deux couches, opacité interpolée au sommet, alpha colormap et facteurs de vision selon les variantes natives. Les listes statiques/globales sont maintenant qualifiées sur33descripteurs et48configurations aux deux frontières de compilation ; rafraîchissement dynamique, paramètres finaux et ordre complet des passes restent ouverts. Construire, tester et inspecter le nouvel exécutable et la base Chaos ; poursuivre cérémonie/audio/sbires, reconnexion, retour launcher, partie ordinaire à six clients graphiques et tous les24domaines.'
receipt=dict(updated_utc=now,complete=False,native_shader_macro_cases=1584,native_environment_descriptors=33,
 native_macro_copy_and_append_qualified=True,vertex_and_pixel_submission_qualified=True,
 complete_shader_compilation_qualified=False,native_cloud_runtime_gpu_integrated=False,
 product_runtime_source_changed=False,application_binary_unchanged=True,application_binary_sha256=binary,
 artifacts=['data/4.20/native_shader_macro_merge_contract.json'],limits=proof['limits'],next_action=action)
receipt['hashes']={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in receipt['artifacts']}
save('docs/native_shader_macro_merge_progress.json',receipt)
archive=r/'docs/plan_history'/('native-shader-macro-merge-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_shader_macro_merge_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
  d['last_verified'].update(native_shader_macro_cases=1584,native_environment_descriptors=33)
 else:d['current_evidence'].update(native_shader_macro_cases=1584,native_environment_descriptors=33,native_cloud_runtime_gpu_integrated=False)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
for name in ['qualify_native_shader_macro_merge.py','record_native_shader_macro_merge.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Combinaison native des paramètres de shader</h2><p>33 définitions d’environnement × 48 configurations : parsing des noms, copie des paramètres globaux, ajout des paramètres statiques et transmission aux compilateurs vertex/pixel vérifiés. Adaptateurs de chaînes et compilation consignés. Le compilateur et le GPU complets ne sont pas exécutés. Prochaine étape : intégrer brouillard deux couches et nuages dans le moteur.</p><a href="native_shader_macro_merge_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(macro_cases=1584,descriptors=33,vertex_and_pixel=True,binary_unchanged=True,plan_saved=True)))
