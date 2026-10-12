from pathlib import Path
import subprocess,os,socket,time,json,hashlib,datetime
r=Path('E:/OpenLeague');stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');prefix=r/'logs'/('replay-configured-scene-'+stamp);png=prefix.with_suffix('.png')
address='127.0.0.1:16124';sock=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);sock.bind(('127.0.0.1',16124));sock.close()
camera=json.loads((r/'logs/endgame-camera-pan-runtime.jsonl').read_text().splitlines()[-1]);focus=[v/20 for v in camera['native_render_focus']]
env=dict(os.environ,OPENLEAGUE_SERVER=address,OPENLEAGUE_SCREENSHOT=str(png),OPENLEAGUE_SCREENSHOT_DELAY='12',OPENLEAGUE_RENDER_FOCUS=','.join(str(x) for x in focus),WGPU_BACKEND='vulkan',RUST_LOG='warn')
processes=[];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
with prefix.with_suffix('.server.log').open('w') as sl,prefix.with_suffix('.client.log').open('w') as cl:
 try:
  processes.append(subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=env,stdout=sl,stderr=subprocess.STDOUT,creationflags=0x08000000));time.sleep(1)
  processes.append(subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=subprocess.STDOUT,creationflags=0x08000000))
  print(json.dumps({'server_pid':processes[0].pid,'client_pid':processes[1].pid,'capture':str(png)}),flush=True)
  deadline=time.monotonic()+120
  while time.monotonic()<deadline:
   assert all(p.poll() is None for p in processes),'owned process exited'
   if png.exists() and png.stat().st_size>10000:break
   time.sleep(1)
  assert png.exists() and png.stat().st_size>10000
  log=prefix.with_suffix('.client.log').read_text(encoding='utf-8',errors='replace')
  line=next(line for line in log.splitlines() if line.startswith('Native replay service configured '));state=json.loads(line.removeprefix('Native replay service configured '))
  assert state['live_allocations']>0 and state['PingTimeForReconnectMessage']==5000
  assert not any(text in log for text in ['panicked at','ShaderValidationError','Native replay service shutdown failed'])
  proof={'passed':True,'complete':False,'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'capture':str(png),'capture_sha256':sha(png),'client_log':str(prefix.with_suffix('.client.log')),'client_log_sha256':sha(prefix.with_suffix('.client.log')),'client_sha256':sha(r/'target/debug/openleague-client.exe'),'server_sha256':sha(r/'target/debug/openleague-server.exe'),'map_sha256':sha(r/'assets/maps/twisted_treeline.glb'),'configured_service':state,'normal_client_startup':True,'normal_server':True,'diagnostic_fixed_camera':True,'visual_inspected':False,'ordinary_match_completed':False,'limits':['Real graphical client startup with local server and new owned service. App screenshot diagnostic selects fixed camera and capture timing. This does not establish original framebuffer equivalence or complete map/gameplay.','Only spawned verification processes are terminated after capture; normal graphical AppExit/drop teardown is not proved. Standalone executable diagnostic separately proves service teardown and zero owned allocations. Frame/replay streaming/actor integration remains open.']}
  print(json.dumps({'passed':True,'capture':str(png),'configured_service':state}),flush=True)
 finally:
  for p in reversed(processes):
   if p.poll() is None:
    p.terminate()
    try:p.wait(timeout=10)
    except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)
proof['client_log_sha256']=sha(prefix.with_suffix('.client.log'))
(r/'docs/replay_configured_scene_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
