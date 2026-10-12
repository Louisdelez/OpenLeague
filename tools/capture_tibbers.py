from pathlib import Path
import os,subprocess,socket,json,time,sys,hashlib,datetime
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',5966);clients=[];ids=[];server=None;client=None;seq=0
def send(i,p):clients[i].sendto(json.dumps(p).encode(),addr)
def receive(i,kind='State',timeout=10):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  try:p=wire.packet(clients[i])
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise RuntimeError('Missing '+kind)
def command(a):
 global seq
 seq+=1;send(0,{'Command':{'sequence':seq,'action':a}})
def actor(s,i):return next(p for p in s['players'] if p['id']==ids[i])
try:
 with (r/'logs/tibbers-render-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/examples/tibbers_fixture.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5966'),stdout=log,stderr=log,creationflags=0x08000000)
  for i,name in enumerate(['annie','garen']):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c)
   end=time.monotonic()+12
   while True:
    send(i,{'Join':{'champion':name}})
    try:ids.append(receive(i,'Welcome',.5)['player']);break
    except RuntimeError:assert time.monotonic()<end
  command({'Learn':{'slot':3}})
  while True:
   state=receive(0)
   if actor(state,0)['ranks'][3]==1:break
  point=actor(state,0)['position'];command({'CastAt':{'slot':3,'point':point}})
  while True:
   state=receive(0);pets=[u for u in state['units'] if u.get('pet') and u['pet']['owner']==ids[0]]
   if pets:break
  pet_id=pets[0]['id'];capture=r/'logs/tibbers-map10.png';assert not capture.exists()
  with (r/'logs/tibbers-render-client.log').open('w',encoding='utf-8') as log:
   env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5966',OPENLEAGUE_CHAMPION='annie',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(capture),OPENLEAGUE_RENDER_FOCUS=f"{point['x']/20},0,{point['z']/20}")
   client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=log,stderr=log,creationflags=0x08000000)
   deadline=time.monotonic()+70;heartbeat=0
   while time.monotonic()<deadline:
    assert server.poll() is None and client.poll() is None
    if time.monotonic()>=heartbeat:
     for i,name in enumerate(['annie','garen']):send(i,{'Join':{'champion':name}})
     heartbeat=time.monotonic()+2
    state=receive(0,timeout=3)
    if capture.exists() and capture.stat().st_size>10000:break
   assert capture.exists()
   current=next(u for u in state['units'] if u['id']==pet_id);assert current['health']>0
   proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'diagnostic_fixture':True,'fixture_pid':server.pid,'client_pid':client.pid,'port':5966,'client_sha256':hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),'fixture_sha256':hashlib.sha256((r/'target/debug/examples/tibbers_fixture.exe').read_bytes()).hexdigest(),'capture':'logs/tibbers-map10.png','capture_sha256':hashlib.sha256(capture.read_bytes()).hexdigest(),'tick':state['tick'],'pet_id':pet_id,'pet':current,'limits':['Actual Vulkan client connected to separate diagnostic level6/centre-position fixture; not ordinary production progression.','Framebuffer generated; visual inspection still required. No physicalinput, native animationtiming/pose, particles, audible sound or original-runtime fidelity acceptance.']};(r/'docs/tibbers_render_capture.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Captured living Tibbers',pet_id,'at tick',state['tick'],flush=True)
finally:
 for c in clients:c.close()
 for p in [client,server]:
  if p is not None and p.poll() is None:p.terminate();p.wait(timeout=10)
