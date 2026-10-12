from pathlib import Path
import subprocess,os,time,json,hashlib,datetime
from PIL import Image
r=Path('E:/OpenLeague');tag='window-lifecycle-v31-dx12';server=client=None
paths=[r/'logs'/f'{tag}{suffix}.png' for suffix in ['', '-resized','-fullscreen','-restored','-unminimized']]
assert not any(p.exists() for p in paths)
log=r/'logs'/f'{tag}-client.log'
try:
 with (r/'logs'/f'{tag}-server.log').open('w') as sl,log.open('w') as cl:
  server=subprocess.Popen([str(r/'target/debug/examples/annie_ready_fixture.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:10501'),stdout=sl,stderr=sl,creationflags=0x08000000)
  time.sleep(1)
  env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:10501',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='dx12',OPENLEAGUE_SCREENSHOT=str(paths[0]),OPENLEAGUE_RENDER_LIFECYCLE='1',OPENLEAGUE_RENDER_MINIMIZE='1')
  for k in ['OPENLEAGUE_PROJECTED_PIXEL_PAIR','OPENLEAGUE_PROJECTED_CAMERA_REENTRY','OPENLEAGUE_PROJECTED_LIVE_PROBE']:env.pop(k,None)
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=cl,creationflags=0x08000000)
  deadline=time.monotonic()+190
  while time.monotonic()<deadline and client.poll() is None:
   if all(p.exists() and p.stat().st_size>10000 for p in paths):break
   time.sleep(.5)
  time.sleep(2)
  text=log.read_text(errors='replace');fatal=[s for s in ['ResizeBuffers failed','Invalid surface','panicked at','Quitting the application'] if s in text]
  frames=[{'path':str(p.relative_to(r)),'size':list(Image.open(p).size),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths if p.exists()]
  d={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':len(frames)==5 and not fatal and client.poll() is None,'fatal':fatal,'exit_code':client.poll(),'frames':frames,'client_sha256':hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),'limits':['Seeded local fixture, no claim of ordinary progression.','Resize/fullscreen/restore/minimize requested via Bevy; screenshot after unminimize. Capture-concurrent resize not exercised.','Prior v26 failure remains open even if this scenario passes.']}
  (r/'docs'/f'{tag}.json').write_text(json.dumps(d,indent=2)+'\n');print(json.dumps(d,indent=2),flush=True)
finally:
 for p in [client,server]:
  if p and p.poll() is None:
   p.terminate()
   try:p.wait(timeout=10)
   except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)
