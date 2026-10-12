from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '361 passed; 0 failed' in (r/'logs/native-hud-effect-packets-client-tests.log').read_text(encoding='utf-8',errors='replace')
packets=load('data/4.20/native_hud_effect_packets_contract.json');states=load('data/4.20/native_hud_effect_state_contract.json')
assert packets['passed'] and packets['packet_cases']==32 and packets['visibility_cases']==10
assert states['passed'] and states['case_count']==20
gpu=[]
for backend in ('vulkan','dx12'):
 p=f'logs/native-hud-recharge-{backend}-gpu.json'
 if (r/p).exists():
  d=load(p);assert d['passed'] and len(d['cases'])==15;gpu.append({'backend':backend,'path':p,'sha256':sha(p),'pixels':d['pixels']})
build=(r/'logs/native-hud-recharge-gpu-build.log').read_text(encoding='utf-8',errors='replace')
assert 'Finished' in build and 'error:' not in build
history=r/'docs/plan_history'/('recharge-gpu-record-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
files=['crates/client/src/native_hud_effect_packets.rs','crates/client/src/native_hud_recharge_material.rs','crates/client/src/native_hud_recharge_gpu_probe.rs','assets/shaders/native_hud_recharge.wgsl','data/4.20/native_hud_effect_packets_contract.json','data/4.20/native_hud_effect_state_contract.json','logs/native-hud-effect-packets-client-tests.log','logs/native-hud-recharge-gpu-build.log','target/debug/openleague-client.exe']
proof=dict(updated_utc=now,complete=False,client_tests_passed=361,core_tests_passed=434,native_packet_creation_cases=32,native_visibility_cases=10,native_alpha_transition_cases=20,gpu_reports=gpu,ordinary_hud_recharge_integrated=False,client_rebuilt=True,server_rebuilt=False,artifacts_sha256={p:sha(p) for p in files},findings=['Original Effect packet producer9A88F0 requests alpha mode1; original visibility updater preserves other packet flags; source texture/owner/instance fields match the Rust port.','Original renderer99F3A0 alpha transition tail and helper execute20 supplied cached-state cases. Other matrix/declaration/color branches remain unqualified.','Cooldown shader port preserves original atan2 direction, strict angle boundary, unclamped gradient and unpremultiplied source color; native reset ONE/INVSRCALPHA blending retained.'],limits=['Offscreen shader qualification is distinct from ordinary HUD integration and original framebuffer identity. LineStrip transport, native projection and live authority transport still pending.','361 client tests predate the new isolated GPU probe code; probe is verified by successful compilation and any attached actual GPU reports. Core434 evidence is from the prior cooldown metadata qualification, not a new core run.','No complete champion kit or domain; six-client match, map acceptance, launcher/services and package remain open.'])
receipt='docs/native_hud_recharge_gpu_progress.json';(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
next_action='Porter le trait indexé LineStrip, intégrer les deux primitives au HUD piloté par les délais autoritaires, reconstruire serveur/client et qualifier le cycle réel Vulkan/DX12. Poursuivre les 24 domaines.'
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_recharge_gpu_progress=receipt);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=361,client_tests_passed=361,current_source_progress=receipt,ordinary_client_build_matches_current_source=True,ordinary_server_build_matches_current_source=False,native_effect_packet_cases=32,native_effect_visibility_cases=10,native_effect_alpha_cases=20,recharge_offscreen_gpu_backends=[a['backend'] for a in gpu],ordinary_hud_recharge_integrated=False)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id']=='17':domain.update(progress_updated_utc=now);domain.setdefault('progress_evidence',[]).append(receipt)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');assert 'id="recharge-gpu-progress"' not in s;s=s.replace('</body>','<section id="recharge-gpu-progress"><h2>Shader de recharge GPU</h2><p>361 tests client avant ajout de la sonde GPU. Paquets natifs : 32 créations, 10 visibilités, 20 transitions alpha. Sonde isolée du secteur : '+', '.join(a['backend'] for a in gpu)+'. Trait LineStrip et HUD réel encore à intégrer.</p><a href="native_hud_recharge_gpu_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_recharge_gpu_progress.py'),r/'tools/record_recharge_gpu_progress.py')
print(json.dumps({'complete':False,'gpu_backends':[a['backend'] for a in gpu],'proof':receipt}))
