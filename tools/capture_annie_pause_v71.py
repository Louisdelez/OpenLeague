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
 baseline=r/'logs/annie-pause-v71-baseline.png';probe=r/'logs/annie-pause-v71-live.json'
 assert not probe.exists(),'preserve previous evidence'
 with (r/'logs/annie-pause-v71-server.log').open('w') as sl,(r/'logs/annie-pause-v71-client.log').open('w') as cl:
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
  env.update(OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='dx12',OPENLEAGUE_SCREENSHOT=str(baseline),OPENLEAGUE_PROJECTED_LIVE_PROBE=probe.as_posix(),OPENLEAGUE_PROJECTED_PIXEL_PAIR=(r/'logs/annie-pause-v71-pixels.json').as_posix(),OPENLEAGUE_RENDER_FOCUS=f"{point['x']/20},{height/20},{point['z']/20}")
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=cl)
  deadline=time.monotonic()+100
  while not (baseline.exists() and baseline.stat().st_size>10000):
   assert time.monotonic()<deadline,'startup timeout';assert client.poll() is None,'client stopped';state=receive()
  target=next(p['id'] for p in state['players'] if p['champion']=='garen')
  command({'Cast':{'slot':0,'target':target}})
  deadline=time.monotonic()+10
  while True:
   m=measurement()
   if m.get('active_draws',0)>0:break
   assert time.monotonic()<deadline,('no visible projectile',m)
   receive(timeout=1)
  seq+=1;send({'PauseRequest':{'sequence':seq,'paused':True}})
  deadline=time.monotonic()+3
  while True:
   state=receive();m=measurement()
   if m.get('clock',{}).get('paused'):break
   assert time.monotonic()<deadline,('pause not applied',m)
  assert m['active_draws']>0,('pause missed projectile',m)
  frozen=[];deadline=time.monotonic()+2
  while time.monotonic()<deadline:
   state=receive();m=measurement();frozen.append({'tick':state['tick'],'projectiles':state.get('spell_projectiles'),'clock':m['clock'],'effects':m['active_effect_states'],'draws':m['active_draws']})
  assert len(frozen)>=5
  assert all(x['effects'] and all('owner_position' in e and 'projection_position' in e for e in x['effects']) for x in frozen),'missing active pose evidence'
  assert len({x['tick'] for x in frozen})==1,'simulation advanced during pause'
  assert len({x['clock']['time_bits'] for x in frozen})==1,'effect clock advanced during pause'
  assert all(x['draws']>0 and x['clock']['paused'] for x in frozen)
  assert len({json.dumps(x['effects'],sort_keys=True) for x in frozen})==1,'effect pose or age changed during pause'
  assert len({json.dumps(x['projectiles'],sort_keys=True) for x in frozen})==1,'projectile simulation changed'
  seq+=1;send({'PauseRequest':{'sequence':seq,'paused':False}})
  deadline=time.monotonic()+20
  while True:
   state=receive();m=measurement()
   if not m.get('clock',{}).get('paused',True) and m.get('cleaned',0)>0 and m.get('active_effects')==0:break
   assert time.monotonic()<deadline,('resume/cleanup timeout',m)
  assert m['clock']['time_bits']>frozen[-1]['clock']['time_bits']
  pixel_path=r/'logs/annie-pause-v71-pixels.json';deadline=time.monotonic()+10
  while True:
   pixels=json.loads(pixel_path.read_text());rows=pixels['rows']
   if any(row.get('cleanup_rgba') for row in rows):break
   assert time.monotonic()<deadline,'missing GPU cleanup';receive()
  paused_rows=[row for row in rows if row.get('paused') and row['draws']>0 and row['changed_pixels']>0]
  assert len(paused_rows)>=3,'no sustained visible paused GPU projection'
  assert len({row['effect_time_bits'] for row in paused_rows})==1,'GPU effect time changed during pause'
  result={'status':'passed','backend':'dx12','frozen_samples':frozen,'paused_gpu_frames':paused_rows,'gpu_report':str(pixel_path),'final':m,'client_sha256':sha(r/'target/debug/openleague-client.exe'),'fixture_sha256':sha(r/'target/debug/examples/annie_paused_fixture.exe'),'limits':['Diagnostic seeded level6/positions. Not ordinary champion progression.','GPU pixel capture requires separate inspection; whole-frame animation freeze not asserted.','Local pause authorization policy, not official server fidelity.']}
  (r/'docs/annie_pause_v71.json').write_text(json.dumps(result,indent=2))
  print('Pause, frozen clock/pose/projectile and resume/cleanup passed.',flush=True)
except Exception as e:
 (r/'docs/annie_pause_v71_failed.json').write_text(json.dumps({'error':repr(e),'measurement':measurement()},indent=2));raise
finally:
 (r/'logs/annie-pause-v71-events.json').write_text(json.dumps(journal,indent=2))
 if c:c.close()
 for p in [client,server]:
  if p is not None and p.poll() is None:p.terminate();p.wait(timeout=15)
