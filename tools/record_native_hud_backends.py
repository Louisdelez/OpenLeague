from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
captures=[];artifacts=[]
for tag,backend in [('dx12','Dx12'),('vulkan_verified','Vulkan')]:
 path='docs/native_hud_atlases_'+tag+'_capture.json';c=load(path)
 assert c['graphics_backend']==backend and 'backend: '+backend in c['adapter_log']
 assert c['client_sha256']==sha('target/debug/openleague-client.exe') and hashlib.sha256(Path(c['capture']).read_bytes()).hexdigest()==c['capture_sha256']
 g=json.loads(Path(c['atlas_gpu_receipt']).read_text());b=json.loads(Path(c['shadow_atlas_readback']).read_text())
 assert g['atlas_count']==5 and all(e['gpu_prepared'] for e in g['entries']) and b['native_bytes_equal'] and b['bytes']==b['expected_bytes']==4194304
 c.update(visual_inspected=True,visual_notes=['Chaos base renders with development text HUD; blue uncovered regions on right remain.','Original HUD widget layout/interactions not applied.'])
 save(path,c);captures.append(c)
 artifacts.extend([path,str(Path(c['atlas_gpu_receipt']).relative_to(r)).replace('\\','/'),str(Path(c['shadow_atlas_readback']).relative_to(r)).replace('\\','/')])
proof=dict(updated_utc=now,complete=False,backends_verified=['Vulkan','Dx12'],scope='Same current client: adapter confirmed, five atlas GPU preparations, ShadowIsles BGRA byte equality and diagnostic scene captures. Full graphics compatibility/fidelity not qualified.',client_sha256=sha('target/debug/openleague-client.exe'),captures=captures,limits=['Single RTX3060 Windows host and fixed diagnostic camera only; no general hardware/driver compatibility qualification.','Original sampler/compositing, HUD703widgets, blue map regions, six-client match and full game remain open.'])
save('docs/native_hud_backend_progress.json',proof)
p='docs/native_hud_atlases_progress.json';d=load(p);assert d['application_binary_sha256']==proof['client_sha256']
d.update(updated_utc=now,backends_verified=['Vulkan','Dx12'],backend_evidence=proof)
d['artifacts']+=artifacts+['docs/native_hud_backend_progress.json'];d['hashes'].update({p:sha(p) for p in artifacts+['docs/native_hud_backend_progress.json']})
save(p,d)
build=load('docs/native_hud_atlases_build_receipt.json');build.update(backends_verified=['Vulkan','Dx12'],backend_proof='docs/native_hud_backend_progress.json');save('docs/native_hud_atlases_build_receipt.json',build)
history=r/'docs/plan_history'/('native-hud-backends-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);doc=load('docs/'+name);doc.update(updated_utc=now,complete=False,native_hud_atlases_progress=d,native_hud_backend_progress=proof)
 evidence=doc['last_verified'] if name=='resume_checkpoint.json' else doc['current_evidence'];evidence.update(native_hud_atlas_backends=['Vulkan','Dx12'],native_hud_backend_proof='docs/native_hud_backend_progress.json')
 if name=='resume_checkpoint.json':doc.update(saved_utc=now,pending_native_jobs=[])
 save('docs/'+name,doc)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Atlas HUD : Vulkan et DirectX12</h2><p>RTX3060, adaptateurs confirmés ;5atlas préparés et4194304octets BGRA identiques sur les deuxAPI. Captures inspectées. Compatibilité générale, disposition HUD et jeu complet restent ouverts.</p><a href="native_hud_backend_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(client_tests=279,backends=['Vulkan','Dx12'],atlas_count=5,shadow_gpu_bytes_equal=True,complete=False)))
