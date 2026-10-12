from pathlib import Path
import subprocess,os,json,time,hashlib,socket,datetime
r=Path('E:/OpenLeague');server=client=None
capture=r/'logs/visibility-texture-133.png';probe=r/'logs/visibility-texture-133.json'
try:
 for p in [capture,probe]:assert not p.exists()
 check=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);check.bind(('127.0.0.1',16005));check.close()
 with (r/'logs/visibility-texture-server.log').open('w') as sl,(r/'logs/visibility-texture-client.log').open('w') as cl:
  env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:16005')
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=env,stdout=sl,stderr=sl,creationflags=0x08000000)
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=dict(env,WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(capture),OPENLEAGUE_SCREENSHOT_DELAY='20',OPENLEAGUE_VISIBILITY_TEXTURE_PROBE=str(probe),RUST_LOG='warn'),stdout=cl,stderr=cl,creationflags=0x08000000)
  print(json.dumps({'client_pid':client.pid,'server_pid':server.pid}),flush=True)
  deadline=time.monotonic()+80
  while True:
   assert server.poll() is None and client.poll() is None,'runtime stopped'
   try:d=json.loads(probe.read_text())
   except (FileNotFoundError,json.JSONDecodeError):d=None
   if d and d['uploads']>3 and d['nonzero_texels']>0 and d['error'] is None and capture.exists() and capture.stat().st_size>10000:break
   assert time.monotonic()<deadline,('texture runtime timeout',d)
   time.sleep(.1)
  sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
  receipt={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'normal_server':True,'client_sha256':sha(r/'target/debug/openleague-client.exe'),'measurement':d,'capture':str(capture),'capture_sha256':sha(capture),'visual_inspection_required':True,'limits':['Image asset updates observed in live Vulkan client; GPU texture readback and material sampling not verified.','Raw mask expansion only; full native fade/blur pipeline remains open.']}
  (r/'docs/visibility_texture_runtime_capture.json').write_text(json.dumps(receipt,indent=2)+'\n')
  print(json.dumps(receipt),flush=True)
finally:
 for process in [client,server]:
  if process and process.poll() is None:
   process.terminate()
   try:process.wait(timeout=10)
   except subprocess.TimeoutExpired:process.kill();process.wait(timeout=5)
