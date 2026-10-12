from pathlib import Path
import os,subprocess,socket,json,time,sys,hashlib,datetime
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',5976);server=None;client=None;c=None;seq=0;heartbeat=0
def send(packet):c.sendto(json.dumps(packet).encode(),addr)
def receive(kind='State',timeout=5):
 global heartbeat
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  assert server.poll() is None
  if time.monotonic()>=heartbeat:send({'Join':{'champion':'annie'}});heartbeat=time.monotonic()+2
  try:p=wire.packet(c)
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('Missing '+kind)
def command(action):
 global seq
 seq+=1;send({'Command':{'sequence':seq,'action':action}})
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
try:
 on=r/'logs/annie-ready-alphaadd-on.png';off=r/'logs/annie-ready-alphaadd-off.png';probe=r/'logs/annie-ready-alphaadd-off.json'
 for p in [on,off,probe]:assert not p.exists(),str(p)
 with (r/'logs/annie-ready-alphaadd-render-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/examples/annie_ready_fixture.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5976'),stdout=log,stderr=log,creationflags=0x08000000)
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);end=time.monotonic()+15
  while True:
   send({'Join':{'champion':'annie'}})
   try:owner=receive('Welcome',.5)['player'];break
   except AssertionError:assert time.monotonic()<end
  command({'Learn':{'slot':0}})
  while True:
   state=receive();p=next(p for p in state['players'] if p['id']==owner)
   if p['ranks'][0]==1:break
  assert p['effects']['pyromania']==4;point=p['position'];height=p['height']
  with (r/'logs/annie-ready-alphaadd-render-client.log').open('w',encoding='utf-8') as log:
   env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5976',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(on),OPENLEAGUE_READY_PROBE=str(probe),OPENLEAGUE_RENDER_FOCUS=f"{point['x']/20},{height/20},{point['z']/20}")
   client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=log,stderr=log,creationflags=0x08000000)
   end=time.monotonic()+80
   while not (on.exists() and on.stat().st_size>10000):
    assert time.monotonic()<end;assert client.poll() is None;state=receive()
   before=next(p for p in state['players'] if p['id']==owner);assert before['effects']['pyromania']==4
   target=next(p['id'] for p in state['players'] if p['champion']=='garen');command({'Cast':{'slot':0,'target':target}})
   end=time.monotonic()+30
   while not (off.exists() and off.stat().st_size>10000 and probe.exists()):
    assert time.monotonic()<end;assert client.poll() is None;state=receive()
   after=next(p for p in state['players'] if p['id']==owner);assert after['effects']['pyromania']==0
   diagnostic=json.loads(probe.read_text(encoding='utf-8'));assert diagnostic['max_emitters']==1 and diagnostic['max_quads']==10 and diagnostic['max_visible_quads']==10
   assert diagnostic['remaining_quads']==0 and diagnostic['remaining_particle_materials']==0 and diagnostic['emitters_after_consume']==0
   proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'diagnostic_fixture':True,'fixture_pid':server.pid,'client_pid':client.pid,'port':5976,'owner':owner,'target':target,'client_sha256':sha(r/'target/debug/openleague-client.exe'),'fixture_sha256':sha(r/'target/debug/examples/annie_ready_fixture.exe'),'captures':[{'path':str(p.relative_to(r)).replace('\\','/'),'sha256':sha(p)} for p in [on,off]],'probe':diagnostic,'before':before,'after':after,'limits':['Actual Vulkan framebuffer; separate fixture seeds level6/position/readiness. This is not ordinary progression proof.','Ready emitter drawn from recovered native texture/fields; shader fixed-alpha formula ported, blend4 original-runtime qualification/geometry/curve integration/birth clock/fog/skins still reconstructed or incomplete.','Framebuffer saved; visual inspection required. Native runtime comparison and audible output not qualified.']}
   (r/'docs/annie_ready_alphaadd_render_capture.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Captured actual Vulkan StunReady before/after consumed Q;10quads ->0 and10materials ->0',flush=True)
finally:
 if c is not None:c.close()
 for p in [client,server]:
  if p is not None and p.poll() is None:p.terminate();p.wait(timeout=10)
