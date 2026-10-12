from pathlib import Path
import os,subprocess,time,datetime,hashlib,json
r=Path('E:/OpenLeague');capture=r/'logs/map10-view-startup-127.png';log=r/'logs/map10-view-startup-127.log';receipt=r/'docs/map10_view_startup_capture.json'
assert not capture.exists() and not log.exists(),'capture already exists; preserve evidence'
client=None
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
try:
 with log.open('w',encoding='utf-8') as stream:
  env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5998',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(capture),OPENLEAGUE_SCREENSHOT_DELAY='25',RUST_LOG='warn')
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=stream,stderr=stream,creationflags=0x08000000)
  print(json.dumps(dict(client_pid=client.pid,capture=str(capture))),flush=True)
  deadline=time.monotonic()+85
  while not (capture.exists() and capture.stat().st_size>10000):
   assert client.poll() is None,'client stopped before capture'
   assert time.monotonic()<deadline,'current startup capture timeout'
   time.sleep(.2)
  time.sleep(1)
  assert client.poll() is None,'client stopped after capture'
  data=dict(checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,client_alive_at_capture=True,client_sha256=sha(r/'target/debug/openleague-client.exe'),capture=str(capture),capture_sha256=sha(capture),log=str(log),render_backend_requested='vulkan',server_connected=False,visual_inspection_required=True,limits=['Current standalone client startup and real framebuffer only; no server or gameplay sources, visibility or fog masks qualified.','Startup inserts native geometry/view resource through its ordinary setup; exact view buffers are covered by unit/native comparison, not framebuffer pixel attribution.'])
  receipt.write_text(json.dumps(data,indent=2)+'\n',encoding='utf-8');print(json.dumps(data),flush=True)
finally:
 if client and client.poll() is None:
  client.terminate()
  try:client.wait(timeout=10)
  except subprocess.TimeoutExpired:client.kill();client.wait(timeout=5)
