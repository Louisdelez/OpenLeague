from pathlib import Path
import subprocess,os,socket,time,json,hashlib,datetime
r=Path('E:/OpenLeague');prefix=r/'logs/chaos-base-normal-scene';png=prefix.with_suffix('.png');assert not png.exists()
address='127.0.0.1:16104';check=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);check.bind(('127.0.0.1',16104));check.close()
camera=json.loads((r/'logs/endgame-camera-pan-runtime.jsonl').read_text().splitlines()[-1]);focus=[v/20 for v in camera['native_render_focus']]
env=dict(os.environ,OPENLEAGUE_SERVER=address,OPENLEAGUE_SCREENSHOT=str(png),OPENLEAGUE_SCREENSHOT_DELAY='25',OPENLEAGUE_RENDER_FOCUS=','.join(str(x) for x in focus),WGPU_BACKEND='vulkan',RUST_LOG='warn')
processes=[]
with prefix.with_suffix('.server.log').open('w') as sl,prefix.with_suffix('.client.log').open('w') as cl:
 try:
  processes.append(subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=env,stdout=sl,stderr=subprocess.STDOUT,creationflags=0x08000000));time.sleep(1)
  processes.append(subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=subprocess.STDOUT,creationflags=0x08000000))
  print(json.dumps(dict(server_pid=processes[0].pid,client_pid=processes[1].pid,capture=str(png))),flush=True)
  deadline=time.monotonic()+120
  while time.monotonic()<deadline:
   assert all(p.poll() is None for p in processes),'owned process exited'
   if png.exists() and png.stat().st_size>10000:break
   time.sleep(1)
  assert png.exists() and png.stat().st_size>10000
  sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
  proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,normal_server=True,diagnostic_fixed_camera=True,diagnostic_focus_world=focus,diagnostic_winner_injection=False,ordinary_match_completed=False,capture=str(png),capture_sha256=sha(png),client_sha256=sha(r/'target/debug/openleague-client.exe'),server_sha256=sha(r/'target/debug/openleague-server.exe'),map_sha256=sha(r/'assets/maps/twisted_treeline.glb'),visual_inspected=False,limits=['Camera fixed through existing screenshot diagnostic; ordinary victory/six graphical clients not qualified.','No original-game framebuffer reference; current scene capture only.'])
  (r/'docs/chaos_base_scene_capture.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof),flush=True)
 finally:
  for p in reversed(processes):
   if p.poll() is None:
    p.terminate()
    try:p.wait(timeout=10)
    except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)
