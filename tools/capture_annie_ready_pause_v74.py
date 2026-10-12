from pathlib import Path
import os,subprocess,socket,json,time,sys,hashlib,datetime
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',10501);server=None;client=None;c=None;seq=0;heartbeat=0
journal=[]
def record(kind,value):journal.append({'elapsed':time.monotonic(),'kind':kind,'value':value})
def send(p):
 if 'Command' in p:record('command',p)
 c.sendto(json.dumps(p).encode(),addr)
def receive(kind='State',timeout=5):
 global heartbeat
 deadline=time.monotonic()+timeout
 while time.monotonic()<deadline:
  assert server.poll() is None,'fixture stopped'
  if time.monotonic()>=heartbeat:send({'Join':{'champion':'annie'}});heartbeat=time.monotonic()+2
  try:p=wire.packet(c)
  except (socket.timeout,ConnectionResetError):continue
  if p and 'State' not in p:record('packet',p)
  if p and 'Rejected' in p:
   record('rejected',p['Rejected']);raise AssertionError(('server rejected',p['Rejected']))
  if p and 'ClockControl' in p:
   event=p['ClockControl'];send({'ClockAck':{'session':event['session'],'ordinal':event['ordinal']}});record('clock',event)
  if p and 'State' in p:
   snap=p['State'];record('state',{'tick':snap['tick'],'spell_projectiles':snap.get('spell_projectiles',[]),'players':[{k:a.get(k) for k in ['id','champion','position','health','cooldowns','ranks']} for a in snap['players']]})
  if p and kind in p:return p[kind]
 raise AssertionError('Missing '+kind)
def command(action):
 global seq
 seq+=1;send({'Command':{'sequence':seq,'action':action}})
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def measurement():
 try:return json.loads(probe.read_text())
 except (FileNotFoundError,json.JSONDecodeError):return {}
try:
 baseline=r/'logs/annie-ready-pause-v74-baseline.png';probe=r/'logs/annie-ready-pause-v74-live.json'
 assert not probe.exists(),'preserve previous evidence'
 with (r/'logs/annie-ready-pause-v74-server.log').open('w') as sl,(r/'logs/annie-ready-pause-v74-client.log').open('w') as cl:
  env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:10501',OPENLEAGUE_ALLOW_PAUSE='1')
  env.pop('OPENLEAGUE_PROJECTED_CAMERA_REENTRY',None)
  server=subprocess.Popen([str(r/'target/debug/examples/annie_paused_fixture.exe')],cwd=r,env=env,stdout=sl,stderr=sl,creationflags=0x08000000)
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.02);deadline=time.monotonic()+45
  while True:
   send({'Join':{'champion':'annie'}})
   try:owner=receive('Welcome',.5)['player'];break
   except AssertionError:assert time.monotonic()<deadline
  command({'Learn':{'slot':0}})
  while True:
   state=receive();actor=next(p for p in state['players'] if p['id']==owner)
   if actor['ranks'][0]==1:break
  point=actor['position'];height=actor['height']
  env.update(OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(baseline),OPENLEAGUE_READY_LIVE_PROBE=probe.as_posix(),OPENLEAGUE_PROJECTED_PIXEL_PAIR=(r/'logs/annie-ready-pause-v74-pixels.json').as_posix(),OPENLEAGUE_RENDER_FOCUS=f"{point['x']/20},{height/20},{point['z']/20}")
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=cl)
  deadline=time.monotonic()+100
  while not (baseline.exists() and baseline.stat().st_size>10000):
   assert time.monotonic()<deadline,'startup timeout';assert client.poll() is None,'client stopped';state=receive()
  deadline=time.monotonic()+10
  while True:
   m=measurement()
   if m.get('visible_quads',0)>0:break
   assert time.monotonic()<deadline,('ready not visible',m);receive()
  seq+=1;send({'PauseRequest':{'sequence':seq,'paused':True}})
  deadline=time.monotonic()+3
  while True:
   state=receive();m=measurement()
   if m.get('clock',{}).get('paused'):break
   assert time.monotonic()<deadline,'pause not applied'
  frozen=[];deadline=time.monotonic()+2
  while time.monotonic()<deadline:
   state=receive();m=measurement();frozen.append({'tick':state['tick'],'clock':m['clock'],'quads':m['quads'],'visible_quads':m['visible_quads']})
  assert len(frozen)>=5 and all(x['visible_quads']>0 and x['clock']['paused'] for x in frozen)
  assert len({x['tick'] for x in frozen})==1
  assert len({x['clock']['time_bits'] for x in frozen})==1
  assert len({json.dumps(x['quads'],sort_keys=True) for x in frozen})==1,'ready transforms/materials changed while paused'
  seq+=1;send({'PauseRequest':{'sequence':seq,'paused':False}});deadline=time.monotonic()+12
  while True:
   receive();m=measurement()
   if not m['clock']['paused'] and m['quads']!=frozen[-1]['quads']:break
   assert time.monotonic()<deadline,'ready failed to resume'
  result={'passed':True,'complete':False,'backend':'vulkan','frozen_samples':frozen,'resumed':m,'client_sha256':sha(r/'target/debug/openleague-client.exe'),'limits':['Actual ECS transforms/materials and visibility; no raw GPU pixel equivalence.','Seeded diagnostic readiness; original ready emitter reconstruction remains partially qualified.']}
  (r/'docs/annie_ready_pause_v74.json').write_text(json.dumps(result,indent=2));print('PASS StunReady frozen material/pose and resumed evolution')
except Exception as e:
 (r/'docs/annie_ready_pause_v74_failed.json').write_text(json.dumps({'error':repr(e),'measurement':measurement()},indent=2));raise
finally:
 (r/'logs/annie-ready-pause-v74-events.json').write_text(json.dumps(journal,indent=2))
 if c:c.close()
 for p in [client,server]:
  if p is not None and p.poll() is None:p.terminate();p.wait(timeout=15)
