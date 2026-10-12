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
 deadline=time.monotonic()+1
 while True:
  try:return json.loads(probe.read_text())
  except (FileNotFoundError,PermissionError,json.JSONDecodeError):
   if time.monotonic()>=deadline:return {}
   time.sleep(.01)
try:
 baseline=r/'logs/annie-ready-pause-v83-baseline.png';probe=r/'logs/annie-ready-pause-v83-live.json'
 assert not probe.exists(),'preserve previous evidence'
 with (r/'logs/annie-ready-pause-v83-server.log').open('w') as sl,(r/'logs/annie-ready-pause-v83-client.log').open('w') as cl:
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
  env.update(OPENLEAGUE_PAIR_TARGET='ready',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(baseline),OPENLEAGUE_READY_LIVE_PROBE=probe.as_posix(),OPENLEAGUE_PROJECTED_PIXEL_PAIR=(r/'logs/annie-ready-pause-v83-pixels.json').as_posix(),OPENLEAGUE_RENDER_FOCUS=f"{point['x']/20},{height/20},{point['z']/20}")
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=cl)
  deadline=time.monotonic()+100
  while not (baseline.exists() and baseline.stat().st_size>10000):
   assert time.monotonic()<deadline,'startup timeout';assert client.poll() is None,'client stopped';state=receive()
  deadline=time.monotonic()+10
  while True:
   m=measurement()
   if m.get('visible_quads',0)>0:break
   assert time.monotonic()<deadline,('ready not visible',m);receive()
  command({'Move':{'point':{'x':point['x']+300.,'z':point['z']}}})
  time.sleep(.06)
  seq+=1;send({'PauseRequest':{'sequence':seq,'paused':True}})
  deadline=time.monotonic()+3
  while True:
   state=receive();m=measurement()
   if m.get('clock',{}).get('paused'):break
   assert time.monotonic()<deadline,'pause not applied'
  frozen=[];deadline=time.monotonic()+2
  while time.monotonic()<deadline:
   state=receive();m=measurement();frozen.append({'tick':state['tick'],'clock':m['clock'],'quads':m['quads'],'visible_quads':m['visible_quads'],'animations':m['animations'],'bones':m['bones']})
  assert len(frozen)>=5 and all(x['visible_quads']>0 and x['clock']['paused'] for x in frozen)
  assert all(any(len(p['clips'])>1 and any(0.<c['weight']<1. for c in p['clips']) for p in x['animations']) for x in frozen),'crossfade expired before pause'
  assert len({x['tick'] for x in frozen})==1
  assert len({x['clock']['time_bits'] for x in frozen})==1
  assert len({json.dumps(x['quads'],sort_keys=True) for x in frozen})==1,'ready transforms/materials changed while paused'
  assert all(x['animations'] and x['bones'] for x in frozen),'missing animation or bone observations'
  assert len({json.dumps(x['animations'],sort_keys=True) for x in frozen})==1,'animation clocks/weights changed while paused'
  assert len({json.dumps(x['bones'],sort_keys=True) for x in frozen})==1,'animated bone transforms changed while paused'
  seq+=1;send({'PauseRequest':{'sequence':seq,'paused':False}});deadline=time.monotonic()+12
  while True:
   receive();m=measurement()
   if not m['clock']['paused'] and m['quads']!=frozen[-1]['quads'] and m['animations']!=frozen[-1]['animations'] and m['bones']!=frozen[-1]['bones']:break
   assert time.monotonic()<deadline,'ready failed to resume'
  pixel_path=r/'logs/annie-ready-pause-v83-pixels.json'
  pixels=json.loads(pixel_path.read_text());assert pixels['target']=='ready'
  paused=[row for row in pixels['rows'] if row.get('paused') and row['draws']>0]
  assert len(paused)>=3,'missing paused GPU frames'
  assert len({row['effect_time_bits'] for row in paused})==1,'GPU clock changed while paused'
  raw_frames=[row for row in paused if row.get('paused_rgba')]
  assert len(raw_frames)==2,'missing raw paused atlas pair'
  pixel_findings={'rows':len(paused),'min_changed_pixels':min(row['changed_pixels'] for row in paused),'max_changed_pixels':max(row['changed_pixels'] for row in paused),'raw_frames':raw_frames,'report':str(pixel_path)}
  result={'gpu_findings':pixel_findings,'passed':True,'complete':False,'backend':'vulkan','frozen_samples':frozen,'resumed':m,'client_sha256':sha(r/'target/debug/openleague-client.exe'),'limits':['Actual ECS transforms/materials and visibility; no raw GPU pixel equivalence.','Seeded diagnostic readiness; original ready emitter reconstruction remains partially qualified.']}
  (r/'docs/annie_ready_pause_v83.json').write_text(json.dumps(result,indent=2));print('PASS animation clips/bones and StunReady freeze/resume')
except Exception as e:
 (r/'docs/annie_ready_pause_v83_failed.json').write_text(json.dumps({'error':repr(e),'measurement':measurement()},indent=2));raise
finally:
 (r/'logs/annie-ready-pause-v83-events.json').write_text(json.dumps(journal,indent=2))
 if c:c.close()
 for p in [client,server]:
  if p is not None and p.poll() is None:p.terminate();p.wait(timeout=15)
