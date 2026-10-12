from pathlib import Path
import json,subprocess,os,time,socket,hashlib,datetime,struct
r=Path('E:/OpenLeague');port=16059;prefix=r/'logs/intact-structure-runtime';probe=prefix.with_suffix('.jsonl');png=prefix.with_suffix('.png');client=server=None
binding=json.loads((r/'docs/intact_structure_animation_binding.json').read_text(encoding='utf-8'));expected={m['alias'] for m in binding['records']}
try:
 for p in [probe,png,prefix.with_suffix('.client.log'),prefix.with_suffix('.server.log')]:assert not p.exists(),p
 check=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);check.bind(('127.0.0.1',port));check.close()
 with prefix.with_suffix('.server.log').open('w',encoding='utf-8') as sl,prefix.with_suffix('.client.log').open('w',encoding='utf-8') as cl:
  env=dict(os.environ,OPENLEAGUE_SERVER=f'127.0.0.1:{port}')
  server=subprocess.Popen([str(r/'target/debug/examples/intact_structure_animation_fixture.exe')],cwd=r,env=env,stdout=sl,stderr=sl,creationflags=0x08000000)
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=dict(env,OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(png),OPENLEAGUE_SCREENSHOT_DELAY='35',OPENLEAGUE_RENDER_FOCUS='388,0,350',OPENLEAGUE_DESTRUCTION_ANIMATION_PROBE=str(probe),RUST_LOG='warn'),stdout=cl,stderr=cl,creationflags=0x08000000)
  print(json.dumps(dict(client_pid=client.pid,server_pid=server.pid)),flush=True);deadline=time.monotonic()+100
  while True:
   assert server.poll() is None and client.poll() is None,'diagnostic runtime stopped'
   if png.exists() and png.stat().st_size>10000:break
   assert time.monotonic()<deadline,'framebuffer timeout';time.sleep(.2)
  rows=[json.loads(line) for line in probe.read_text(encoding='utf-8').splitlines()];summaries={}
  for m in binding['records']:
   model=m['alias'];samples=[a for row in rows for a in row['actors'] if a['model']==model and a['role']=='idle'];assert samples,model
   elapsed=[c['elapsed'] for a in samples for c in a['active_clips']];assert len(elapsed)>2 and max(elapsed)>min(elapsed),(model,'no playback advancement')
   raw=(r/'assets'/m['asset']).read_bytes();g=json.loads(raw[20:20+struct.unpack_from('<I',raw,12)[0]]);joint_names={g['nodes'][j]['name'] for skin in g['skins'] for j in skin['joints']}
   observed={p['name'] for s in samples for p in s['joint_pose']};assert joint_names<=observed,(model,'unobserved joints',joint_names-observed)
   poses=[json.dumps(sorted((p['name'],p['translation'],p['rotation'],p['scale']) for p in s['joint_pose'] if p['name'] in joint_names)) for s in samples]
   summaries[model]=dict(samples=len(samples),first_elapsed=min(elapsed),last_elapsed=max(elapsed),observed_joints=len(joint_names),distinct_joint_poses=len(set(poses)),loop_completions=max(c['completions'] for s in samples for c in s['active_clips']))
  assert set(summaries)==expected
  sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();receipt=dict(checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,diagnostic_fixture=True,ordinary_combat=False,models=summaries,capture=str(png),capture_sha256=sha(png),probe_sha256=sha(probe),client_sha256=sha(r/'target/debug/openleague-client.exe'),fixture_sha256=sha(r/'target/debug/examples/intact_structure_animation_fixture.exe'),visual_inspection_required=True,limits=['Diagnostic positions/team/health in outgoing snapshots. Actual12models, idle AnimationPlayers and joint transforms observed; ordinary structure placement/combat not qualified by this fixture.','Native BLND time/loop/event semantics, runtime pose equivalence, materials/FX and full match remain open.'])
  (r/'docs/intact_structure_animation_runtime.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(models=len(summaries),moving_models=sum(s['distinct_joint_poses']>1 for s in summaries.values()),capture=str(png))),flush=True)
finally:
 for process in [client,server]:
  if process and process.poll() is None:
   process.terminate()
   try:process.wait(timeout=10)
   except subprocess.TimeoutExpired:process.kill();process.wait(timeout=5)
