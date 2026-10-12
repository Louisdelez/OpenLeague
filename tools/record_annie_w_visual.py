from pathlib import Path
import json,hashlib,datetime,shutil,struct,ast
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
runtime=load('logs/annie-w-runtime.json');capture='logs/annie-w-map10.png'
assert runtime['client_sha256']==hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
assert runtime['server_sha256']==hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest()
save('docs/annie_w_live_validation.json',{'checked_utc':now,'complete':False,'runtime':runtime,'capture':capture,'capture_sha256':hashlib.sha256((r/capture).read_bytes()).hexdigest(),'dimensions':[1280,800],'restored_environment_visible':True,'annie_model_visible':True,'free_control_HUD_label_visible':True,'updated_spell_cursor_hint_visible':True,'limits':['Actual current Vulkan framebuffer inspected. Annie/restored map/free-control HUD/new cursor hint visible. No active W/Q clip playback, stun gameplay/HUD, particle/audio, physical keyboard/cursor, foreground or nativefullHUD acceptance proved.']})
glb=r/'assets/champions/annie.glb';blob=glb.read_bytes();length=struct.unpack_from('<I',blob,12)[0];g=json.loads(blob[20:20+length]);manifest=load('data/4.20/animation_manifest.json')['annie'];rows=[]
t=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct};exec(compile(ast.Module(body=[x for x in t.body if isinstance(x,ast.FunctionDef) and x.name in ['ini','hashkey']],type_ignores=[]),'p','exec'),ns)
root=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Characters/Annie/Spells')
for spell,role in [('Disintegrate','spell1'),('Incinerate','spell2')]:
 p=root/(spell+'.inibin');v=ns['ini'](p)[ns['hashkey']('SpellData','AnimationName')];index=manifest['roles'][role];name=g['animations'][index]['name'];assert name==manifest['clips'][index] and name.lower().endswith(v.lower());rows.append({'spell':spell,'source':str(p),'source_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'native_AnimationName':v,'role':role,'clip_index':index,'GLB_animation_name':name})
save('docs/annie_qw_animation_bindings.json',{'checked_utc':now,'passed':True,'complete':False,'bindings':rows,'glb_sha256':hashlib.sha256(blob).hexdigest(),'limits':['Two native INIBIN animation names agree with loaded GLB clip names/indices. Runtime pending states and W facing connected; actual native clip timing/full playback/pose/particles/audio remain unqualified.']})
d=load('docs/annie_w_integration_progress.json');d['visual']='docs/annie_w_live_validation.json';d['runtime']=runtime;d['animation_bindings']='docs/annie_qw_animation_bindings.json';d['network_damage_reconciliation']='docs/annie_w_network_damage_reconciliation.json';save('docs/annie_w_integration_progress.json',d)
d=load('docs/coverage.json')
for p in ['docs/annie_w_live_validation.json','docs/annie_qw_animation_bindings.json','docs/annie_w_network_damage_reconciliation.json']:
 if p not in d['evidence']:d['evidence'].append(p)
d['current_evidence']['annie_W']['render_receipt']='docs/annie_w_live_validation.json';save('docs/coverage.json',d)
d=load('docs/resume_checkpoint.json');d['saved_utc']=now;d['latest_changes'].append('Fresh GUI9444/server10392port5956 inspected,current map/Annie/control-libre HUD/newcursor hint visible. Native Q/W AnimationName verified against actual GLB indices14/15. W UDP damage reconciled with4base regeneration updates; error0.0000691. Activeclip/particles/audio/stun/nativeinput/fullkitunqualified.');save('docs/resume_checkpoint.json',d)
for name in ['record_annie_w_visual.py','reconcile_annie_w_damage.py']:shutil.copyfile('E:/mapslol3v3/'+name,r/'tools'/name)
print('Recorded current frame,2nativeclip bindings and precise UDP damage reconciliation; full goal remains incomplete.')
