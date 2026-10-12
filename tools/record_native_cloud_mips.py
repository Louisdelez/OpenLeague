from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof=load('data/4.20/native_cloud_mip_chain_contract.json');assert proof['passed'] and proof['mip_count']==11
capture=load('docs/chaos_base_native_cloud_mips_capture.json')
assert capture['client_sha256']==hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
assert 'Finished `dev` profile' in (r/'logs/native-cloud-mips-build.log').read_text(encoding='utf-8')
capture.update(visual_inspected=True,visual_observation='Rendered terrain/environment and readable French HUD. Blue edge gaps at Chaos base remain. No full original-frame comparison.')
save('docs/chaos_base_native_cloud_mips_capture.json',capture)
action='Qualifier numériquement les shaders brouillard/nuages sur cas contrôlés au GPU : interpolation sommet, alpha colormap, facteurs de vision et coordonnées. Les11mipmaps Cloud2 sont désormais conservés sous formeBC1 sans recompression, chargés par Bevy et liés au nouveau client ; filtrage physique original et producteur natif restent ouverts. Qualifier profil/options, exclusions FULLBRIGHT/NOLIGHTING, matériaux Blender et référence du fond Chaos ; poursuivre cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et tous les24domaines.'
receipt=dict(updated_utc=now,complete=False,source_mip_count=11,all_mip_blocks_byte_exact=True,recompressed=False,bevy_loader_verified=True,
 runtime_capture_inspected=True,application_binary_sha256=capture['client_sha256'],capture=capture,
 previous_client_tests_passed=240,client_tests_rerun=False,full_gpu_numeric_fidelity=False,
 artifacts=['data/4.20/native_cloud_mip_chain_contract.json','assets/maps/terrain_native/cloudOpacityMap.ktx2','crates/client/src/native_high_fog.rs','logs/native-cloud-mips-build.log','docs/chaos_base_native_cloud_mips_capture.json'],
 limits=proof['limits']+['Actual gameplay captured with fixed camera; six-client match, final quality/settings dispatch and full rendering remain incomplete.',
 'Earlier240client tests remain prior source evidence; this step verifies mip bytes, Bevy loading, executable build and runtime capture.'],next_action=action)
receipt['hashes']={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in receipt['artifacts']};save('docs/native_cloud_mips_progress.json',receipt)
archive=r/'docs/plan_history'/('native-cloud-mips-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_cloud_mips_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[]);d['last_verified'].update(client_sha256=capture['client_sha256'],cloud_mip_count=11,client_tests_current_binary=False)
 else:d['current_evidence'].update(client_sha256=capture['client_sha256'],cloud_mip_count=11,client_tests_current_binary=False)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
for name in ['capture_native_cloud_mips_scene.py','record_native_cloud_mips.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Mipmaps originaux Cloud2 conservés</h2><p>Les 11 niveaux BC1 du DDS sont conservés octet pour octet dans un conteneur KTX2, sans recompression. Chargeur Bevy vérifié ; nouveau client compilé et capture réelle inspectée. Fidélité numérique du filtrage et du brouillard encore à qualifier ; zones bleues de la base encore présentes. Les 240 tests précédents restent des preuves antérieures.</p><a href="native_cloud_mips_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(mips=11,byte_exact=True,current_client=capture['client_sha256'],capture_inspected=True,complete=False)))
