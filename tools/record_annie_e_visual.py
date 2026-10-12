from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
runtime=load('logs/annie-e-runtime.json');capture='logs/annie-e-map10.png'
assert runtime['client_sha256']==hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
assert runtime['server_sha256']==hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest()
save('docs/annie_e_live_validation.json',{'checked_utc':now,'complete':False,'runtime':runtime,'capture':capture,'capture_sha256':hashlib.sha256((r/capture).read_bytes()).hexdigest(),'dimensions':[1280,800],'restored_environment_visible':True,'annie_model_visible':True,'limits':['Actual Vulkan framebuffer of current Q/E client inspected. Annie and restored environment visible. No active E buff/retaliation particles/audio/animation or physical cursor/key/foreground/native full HUD acceptance proved.']})
d=load('docs/annie_e_integration_progress.json');d['visual']='docs/annie_e_live_validation.json';d['runtime']=runtime;save('docs/annie_e_integration_progress.json',d)
d=load('docs/coverage.json');d['evidence'].append('docs/annie_e_live_validation.json');d['evidence'].append('docs/annie_w_native_contract.json');d['current_evidence']['annie_E']['render_receipt']='docs/annie_e_live_validation.json';d['current_evidence']['annie_W_source_audit']={'receipt':'docs/annie_w_native_contract.json','implemented':False,'official_numeric_crosschecks':21,'complete':False};save('docs/coverage.json',d)
d=load('docs/resume_checkpoint.json');d['saved_utc']=now;d['latest_changes'].append('Fresh current GUI16348/server2140port5952 with Q/E build inspected on restored map; not E-active VFX/audio/input acceptance. W native21Riotcomparisons exposed wrongcommunitybase70+45rank andAP0.8; nativebase70..250/AP0.85/cone24.76. Wstillunimplemented.');save('docs/resume_checkpoint.json',d)
for name in ['qualify_annie_w.py','record_annie_e_visual.py']:shutil.copyfile('E:/mapslol3v3/'+name,r/'tools'/name)
print('Recorded current Q/E runtime frame and next W source audit; all24domains incomplete.')
