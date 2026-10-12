from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,shutil,sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');now=datetime.now(timezone.utc).isoformat();load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'));sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '362 passed; 0 failed' in (r/'logs/native-hud-recharge-live-client-tests.log').read_text(encoding='utf-8',errors='replace')
assert 'Finished' in (r/'logs/native-hud-recharge-live-build.log').read_text(encoding='utf-8',errors='replace')
history=r/'docs/plan_history'/('recharge-live-record-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
gpu=[];artifacts={};summaries=[]
for backend in ('vulkan','dx12'):
 prefix=f'logs/native-hud-recharge-live-{backend}-annie';run=load(prefix+'-run.json');assert run['passed']
 captures=[v for v in run['probe']['records'] if v['kind']=='capture_requested'];assert [c['label'] for c in captures]==['baseline','purchased','precast','cast','regenerated','ready']
 assert captures[3]['player']['cooldown_totals'][2]==300
 assert [e['slot'] for e in captures[3]['recharge_draw_trace']['elements'] if e['active']]==[2]
 assert not any(e['active'] for e in captures[-1]['recharge_draw_trace']['elements'])
 active=[]
 for c in captures:
  elements=c['recharge_draw_trace']['elements'];assert len(elements)==4
  for e in elements:
   if e['active']:
    total=c['player']['cooldown_totals'][e['slot']];remaining=c['player']['cooldowns'][e['slot']]-c['tick'];assert total>0 and remaining>0
    active.append({'phase':c['label'],'slot':e['slot'],'tick':c['tick'],'total':total,'remaining':remaining,'params':e['params'],'direction':e['direction']})
  png=prefix+'-'+c['label']+'.png';artifacts[png]=sha(png)
  if c['label'] in ('precast','cast','regenerated','ready'):
   image=Image.open(r/png);w,h=image.size;rect=c['recharge_draw_trace']['elements'][2]['rect'];bounds=(max(0,int(rect[0]*w)-4),max(0,int(rect[1]*h)-4),min(w,int(rect[2]*w)+4),min(h,int(rect[3]*h)+4));out=prefix+'-'+c['label']+'-e-crop.png';image.crop(bounds).save(r/out);artifacts[out]=sha(out)
 assert len(active)==2 and active[1]['remaining']<active[0]['remaining']
 for suffix in ('-run.json','-probe.json','-recharge-trace.json'):artifacts[prefix+suffix]=sha(prefix+suffix)
 summaries.append({'backend':backend,'run':prefix+'-run.json','captures':6,'active_recharges':active,'expiry_observed':True,'visual_inspection_pending':True})
for path in ['crates/client/src/native_hud_recharge_live.rs','crates/client/src/native_hud_live_probe.rs','crates/client/src/native_hud_recharge_line.rs','crates/client/src/native_hud_recharge_material.rs','assets/shaders/native_hud_recharge.wgsl','assets/shaders/native_hud_recharge_line.wgsl','logs/native-hud-recharge-live-build.log','logs/native-hud-recharge-live-client-tests.log','target/debug/openleague-client.exe','target/debug/openleague-server.exe']:artifacts[path]=sha(path)
receipt='docs/native_hud_recharge_live_progress.json';proof=dict(updated_utc=now,complete=False,client_tests_passed=362,core_last_tests_passed=434,ordinary_hud_recharge_integrated=True,client_rebuilt=True,server_rebuilt=True,runs=summaries,artifacts_sha256=artifacts,findings=['Ordinary client HUD uses four source SpellCooldownFX records, normalized native layout, original fragment math/colors, indexed LineStrip shader and native direction polynomial. Sector UI + linear full-viewport line target nearest-composited at original layer3.','Normal local UDP learning/cast commits total300ticks for Annie E; current snapshot controls visibility and remaining/total angle. Unknown active total hides the effect with explicit error; no guessed duration.','Actual six screenshot phases per backend: baseline,purchase,learnt,cast,mana regeneration,expiry. Recharge trace in each capture request is checked against current authoritative snapshot. Screenshot occurs asynchronously, a few ticks later may be rendered.'],limits=['Annie E only qualified in ordinary graphical run; other seven authoritative durations covered by prior core metadata tests, other champion kits/alternate resource forms remain incomplete.','Explicit normalized projection and offscreen line composition are OpenLeague transports, not claims of native D3D9 projection/raster/gamma/full-framebuffer equality. Whole HUD inter-element ordering and human visual fidelity acceptance remain open.','Client362 tests predate the optional capture trace addition; the trace addition is exercised by the two live GPU runs. Core434 is prior-source test evidence, not a new run. Full24domain goal remains unachieved.'])
(r/receipt).write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
next_action='Qualifier le HUD restant, les interactions et les défauts de textures/rendu de la carte Blender restaurée ; terminer Garen/Forêt torturée et la partie à six clients ; poursuivre les 24 domaines.'
for name in ('coverage.json','completion_plan.json','resume_checkpoint.json'):
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_hud_recharge_live_progress=receipt);e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(client_tests=362,client_tests_passed=362,current_source_progress=receipt,ordinary_client_build_matches_current_source=True,ordinary_server_build_matches_current_source=True,ordinary_hud_recharge_integrated=True,recharge_live_backends=['vulkan','dx12'],recharge_live_screenshot_count=12,recharge_live_visual_inspection_pending=True)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=next_action)
 if name=='completion_plan.json':
  d['next_execution_steps']=[next_action]+d.get('next_execution_steps',[])[1:]
  for domain in d.get('domains',[]):
   if domain['id']=='17':domain.setdefault('progress_evidence',[]).append(receipt);domain.update(progress_updated_utc=now)
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');assert 'id="recharge-live-progress"' not in s;s=s.replace('</body>','<section id="recharge-live-progress"><h2>Recharge dans le HUD réel</h2><p>362 tests client ; exécutables client/serveur reconstruits. Secteur et trait GPU pilotés par les délais autoritaires. Six phases capturées Vulkan et DirectX12 sur Annie E, de l’apprentissage à l’expiration. Inspection des pixels et fidélité complète encore distinctes.</p><a href="native_hud_recharge_live_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d.update(updated_utc=now,client_source_tests_passed=362,latest_source_progress=receipt,next_steps=[next_action]);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ('GOAL-OPENLEAGUE-ACTUALISE.txt','GOAL-OPENLEAGUE-NOUVEAU.txt'):
 p=r/'docs'/name;shutil.copy2(p,history/name);s=p.read_text(encoding='utf-8').replace('361 tests client réussis','362 tests client réussis');s=s.split('\nPROCHAINE ÉTAPE :')[0]+'\nPROCHAINE ÉTAPE : achever HUD/interactions et rendu de la carte restaurée ; terminer Garen/Forêt torturée et la partie à six clients ; poursuivre les 24 domaines. Secteur et trait de recharge intégrés ; Annie E capturé Vulkan/DX12, totalité du jeu non terminée.\n';assert len(s)<=4000;p.write_text(s,encoding='utf-8');Path('E:/mapslol3v3',name).write_text(s,encoding='utf-8')
p=r/'docs/goal_plan_revision.json';d=load('docs/goal_plan_revision.json');d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_recharge_live_progress.py'),r/'tools/record_recharge_live_progress.py')
print(json.dumps({'complete':False,'client_tests':362,'captures':12,'receipt':receipt}))
