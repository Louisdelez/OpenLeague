from pathlib import Path
import os,subprocess,socket,json,time,sys,hashlib,datetime
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',10501);server=None;client=None;c=None;seq=0;heartbeat=0
from projected_udp_batch import BatchProxy
proxy=None
c1=None
c2=None
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
  if p and 'Rejected' in p:
   record('rejected',p['Rejected']);raise AssertionError(('server rejected',p['Rejected']))
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
 baseline=r/'logs/projected-core-cycle-v60-receivers-dx12-baseline.png';probe=r/'logs/projected-core-cycle-v60-receivers-dx12-on.json';on=probe.with_suffix('.png');off=probe.with_suffix('.off.png')
 for p in [baseline,probe,on,off]:assert not p.exists(),str(p)
 with (r/'logs/projected-core-cycle-v60-receivers-dx12-server.log').open('w',encoding='utf-8') as sl,(r/'logs/projected-core-cycle-v60-receivers-dx12-client.log').open('w',encoding='utf-8') as cl:
  server=subprocess.Popen([str(r/'target/debug/examples/annie_ready_fixture.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_Q_STARTUP_PROBE='1',OPENLEAGUE_PROJECTED_TERRAIN_PROBE=(r/'logs/receiver-surfaces-v60-dx12.json').as_posix(),OPENLEAGUE_PROJECTED_CAMERA_REENTRY='1',OPENLEAGUE_SERVER='127.0.0.1:10501'),stdout=sl,stderr=sl,creationflags=0x08000000)
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);deadline=time.monotonic()+15
  while True:
   send({'Join':{'champion':'annie'}})
   try:owner=receive('Welcome',.5)['player'];break
   except AssertionError:assert time.monotonic()<deadline
  command({'Learn':{'slot':0}})
  while True:
   state=receive();actor=next(p for p in state['players'] if p['id']==owner)
   if actor['ranks'][0]==1:break
  point=actor['position'];height=actor['height']
  proxy=BatchProxy()
  env=dict(os.environ,OPENLEAGUE_Q_STARTUP_PROBE='1',OPENLEAGUE_PROJECTED_TERRAIN_PROBE=(r/'logs/receiver-surfaces-v60-dx12.json').as_posix(),OPENLEAGUE_PROJECTED_CAMERA_REENTRY='1',OPENLEAGUE_SERVER='127.0.0.1:10502',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='dx12',OPENLEAGUE_SCREENSHOT=str(baseline),OPENLEAGUE_PROJECTED_LIVE_PROBE=probe.as_posix(),OPENLEAGUE_PROJECTED_PIXEL_PAIR=(r/'logs/projected-core-cycle-v60-receivers-dx12-pixels.json').as_posix(),OPENLEAGUE_PROJECTED_PIPELINE_PROBE=(r/'logs/projected-core-cycle-v60-receivers-dx12-pipeline.json').as_posix(),OPENLEAGUE_RENDER_FOCUS=f"{point['x']/20},{height/20},{point['z']/20}")
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=cl,creationflags=0x08000000)
  deadline=time.monotonic()+85
  while not (baseline.exists() and baseline.stat().st_size>10000):
   assert time.monotonic()<deadline,'startup capture timeout';assert client.poll() is None,'client stopped';state=receive()
  target=next(p['id'] for p in state['players'] if p['champion']=='garen')
  # Two independent real clients on the same team, with separate command sequences.
  c1=c;seq1=seq
  c2=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c2.bind(('127.0.0.1',0));c2.settimeout(.1)
  c=c2;seq=0;heartbeat=0;send({'Join':{'champion':'annie'}})
  second=receive('Welcome')['player'];command({'Learn':{'slot':0}})
  while True:
   state=receive()
   if next(p for p in state['players'] if p['id']==second)['ranks'][0]==1:break
  seq2=seq;c=c1;seq=seq1;heartbeat=0
  command({'Cast':{'slot':0,'target':target}})
  first_deadline=time.monotonic()+5
  while True:
   assert time.monotonic()<first_deadline
   sample=receive()
   if any(m['source']==owner for m in sample['spell_projectiles']):break
  proxy.hold(10.0)
  c=c2;seq=seq2;heartbeat=0;command({'Cast':{'slot':0,'target':target}})
  held_ticks=set();hold_deadline=time.monotonic()+5;overlap=[]
  while len(held_ticks)<2:
   assert time.monotonic()<hold_deadline,'two second-owner states not observed'
   sample=receive();sources={m['source'] for m in sample['spell_projectiles']}
   if second in sources:held_ticks.add(sample['tick'])
   if {owner,second}<=sources:overlap.append(sample['tick'])
  assert overlap,'fixture did not produce overlapping missile owners'
  proxy.hold(0)
  record('release_after_observed_ticks',{'second_ticks':sorted(held_ticks),'overlap_ticks':overlap,'owners':[owner,second]})
  deadline=time.monotonic()+5
  while time.monotonic()<deadline:
   assert client.poll() is None
   receive()
  assert proxy.error is None,proxy.error
  result=measurement()
  assert result.get('created_effects',0)==2,('missing replayed lifecycle',result)
  assert result.get('active_effects',-1)==0,('effect did not retire',result)
  assert result.get('active_draws',-1)==0,('draw did not retire',result)
  assert result.get('max_visible_draws',0)>0,('live delayed effect was never visible',result)
  for trace in result['parent_traces']:
   times=[f['time'] for f in trace['frames']]
   assert times==sorted(times),('effect clock reversed',trace)
  receipt={'complete':False,'diagnostic_fixture':True,'batched_real_datagrams':proxy.batches,'measurement':measurement(),'client_sha256':sha(r/'target/debug/openleague-client.exe'),'limits':['Packets delayed and released in order without payload changes.','A controlled delivery perturbation does not prove original v49 failure cause.']}
  (r/'docs/projected_batch_v60.json').write_text(json.dumps(receipt,indent=2)+'\n')
  print(json.dumps(receipt))
finally:
 if proxy:proxy.close()
 (r/'logs/projected-v60-dx12-wire.json').write_text(json.dumps(journal,indent=2)+'\n')
 for sock in {c,c1,c2}:
  if sock:sock.close()
 for p in [client,server]:
  if p and p.poll() is None:
   p.terminate()
   try:p.wait(timeout=10)
   except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)


