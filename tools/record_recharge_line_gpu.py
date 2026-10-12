from pathlib import Path
import json,hashlib,shutil,sys
from datetime import datetime,timezone
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image,ImageDraw
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
history=r/'docs/plan_history'/('recharge-line-record-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
reports=[];artifacts={}
for backend in ('vulkan','dx12'):
 path=f'logs/native-hud-recharge-line-{backend}-gpu.json';d=load(path);assert d['passed'] and len(d['cases'])==18
 gallery=Image.new('RGB',(6*128,3*150),(24,24,24));draw=ImageDraw.Draw(gallery)
 for case in d['cases']:
  index=case['case'];raw=f'logs/native-hud-recharge-line-{backend}-case{index}.rgba';data=(r/raw).read_bytes();assert len(data)==64*64*4
  png=f'logs/native-hud-recharge-line-{backend}-case{index}.png';im=Image.frombytes('RGBA',(64,64),data);im.save(r/png);artifacts[raw]=sha(raw);artifacts[png]=sha(png)
  # Display-only nearest magnification against gray; raw readbacks are authoritative.
  im=im.resize((128,128),Image.Resampling.NEAREST);gallery.paste(im,(index%6*128,index//6*150),im);draw.text((index%6*128+4,index//6*150+130),f'{backend} {index}',fill=(230,230,230))
 gallery_path=f'logs/native-hud-recharge-line-{backend}-gallery.png';gallery.save(r/gallery_path);artifacts[gallery_path]=sha(gallery_path)
 reports.append({'backend':backend,'path':path,'sha256':sha(path),'cases':18,'pixels':d['pixels'],'gallery':gallery_path})
build='logs/native-hud-recharge-line-gpu-build.log';assert 'Finished' in (r/build).read_text(encoding='utf-8',errors='replace')
for path in ['crates/client/src/native_hud_recharge_line.rs','crates/client/src/native_hud_recharge_line_gpu_probe.rs','assets/shaders/native_hud_recharge_line.wgsl',build,'target/debug/openleague-client.exe']:artifacts[path]=sha(path)
receipt='docs/native_hud_recharge_line_gpu_progress.json';proof=dict(updated_utc=now,complete=False,gpu_reports=reports,artifacts_sha256=artifacts,ordinary_hud_recharge_integrated=False,client_rebuilt=True,server_rebuilt=False,client_last_unit_test_count=361,findings=['Indexed LineStrip uses original seven-vertex geometry and final U16 indices4,5,6. Actual shader moves final vertex using native direction and UV, passes packed ARGB-derived RGBA, premultiplies RGB by alpha, then uses native ONE/INVSRCALPHA blend.','Each GPU case checks that nontransparent pixels remain within1.1pixel of native segments, both segments have interior coverage within1.6pixel, output is a narrow line and pixel colors match one/two overlapping segment blends within1byte.','18cases per backend:17directions over a full revolution plus a translucent-color case. Raw4096-pixel RGBA buffers retained; gallery magnification is display-only.'],limits=['Supplied normalized viewport projection, original matrix production and D3D9 edge rasterization not qualified. These coverage bounds do not claim original framebuffer pixel identity.','Isolated probe only; full sector/trait ordinary HUD integration and live cooldown expiry still pending. Core/server binary not rebuilt.361 unit tests are earlier evidence, not a test run of the newly added line renderer.','No domain or champion kit complete. Continue full24domain objective.'])
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
next_action='Intégrer le secteur et le trait LineStrip GPU au HUD réel avec les délais autoritaires ; reconstruire serveur/client ; vérifier la partie et le cycle de recharge Vulkan/DX12. Poursuivre les 24 domaines.'
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_recharge_line_gpu_progress=receipt);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(current_source_progress=receipt,ordinary_client_build_matches_current_source=True,ordinary_server_build_matches_current_source=False,recharge_line_gpu_cases_per_backend=18,recharge_line_gpu_backends=['vulkan','dx12'],ordinary_hud_recharge_integrated=False)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id']=='17':domain.setdefault('progress_evidence',[]).append(receipt);domain.update(progress_updated_utc=now)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');assert 'id="recharge-line-gpu-progress"' not in s;s=s.replace('</body>','<section id="recharge-line-gpu-progress"><h2>Trait de recharge GPU</h2><p>Deux segments indexés LineStrip portés et vérifiés sur Vulkan et DirectX12 : 18 cas par backend. Projection fournie explicitement ; fidélité des bords D3D9 et HUD réel encore à qualifier.</p><a href="native_hud_recharge_line_gpu_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,latest_source_progress=receipt,next_steps=[next_action]);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_recharge_line_gpu.py'),r/'tools/record_recharge_line_gpu.py')
print(json.dumps({'complete':False,'cases_per_backend':18,'receipt':receipt}))
