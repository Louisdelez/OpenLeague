from pathlib import Path
import os,subprocess,socket,json,time,sys,hashlib,datetime
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',10501);server=None;client=None;c=None;seq=0;heartbeat=0
from projected_udp_batch import BatchProxy
proxy=None
server2=None
c_old=None
c_new=None
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
   snap=p['State'];record('state',{'session':snap['session'],'tick':snap['tick'],'spell_projectiles':snap.get('spell_projectiles',[]),'players':[{k:a.get(k) for k in ['id','champion','position','health','cooldowns','ranks']} for a in snap['players']]})
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
 baseline=r/'logs/projected-core-cycle-v67-receivers-dx12-baseline.png';probe=r/'logs/projected-core-cycle-v67-receivers-dx12-on.json';on=probe.with_suffix('.png');off=probe.with_suffix('.off.png')
 for p in [baseline,probe,on,off]:assert not p.exists(),str(p)
 with (r/'logs/projected-core-cycle-v67-receivers-dx12-server.log').open('w',encoding='utf-8') as sl,(r/'logs/projected-core-cycle-v67-receivers-dx12-client.log').open('w',encoding='utf-8') as cl:
  server=subprocess.Popen([str(r/'target/debug/examples/annie_ready_fixture.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_Q_STARTUP_PROBE='1',OPENLEAGUE_PROJECTED_TERRAIN_PROBE=(r/'logs/receiver-surfaces-v67-dx12.json').as_posix(),OPENLEAGUE_PROJECTED_CAMERA_REENTRY='1',OPENLEAGUE_SERVER='127.0.0.1:10501'),stdout=sl,stderr=sl,creationflags=0x08000000)
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
  env=dict(os.environ,OPENLEAGUE_Q_STARTUP_PROBE='1',OPENLEAGUE_PROJECTED_TERRAIN_PROBE=(r/'logs/receiver-surfaces-v67-dx12.json').as_posix(),OPENLEAGUE_PROJECTED_CAMERA_REENTRY='1',OPENLEAGUE_SERVER='127.0.0.1:10502',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='dx12',OPENLEAGUE_SCREENSHOT=str(baseline),OPENLEAGUE_PROJECTED_LIVE_PROBE=probe.as_posix(),OPENLEAGUE_PROJECTED_PIXEL_PAIR=(r/'logs/projected-core-cycle-v67-receivers-dx12-pixels.json').as_posix(),OPENLEAGUE_PROJECTED_PIPELINE_PROBE=(r/'logs/projected-core-cycle-v67-receivers-dx12-pipeline.json').as_posix(),OPENLEAGUE_RENDER_FOCUS=f"{point['x']/20},{height/20},{point['z']/20}")
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=cl,creationflags=0x08000000)
  deadline=time.monotonic()+85
  while not (baseline.exists() and baseline.stat().st_size>10000):
   assert time.monotonic()<deadline,'startup capture timeout';assert client.poll() is None,'client stopped';state=receive()
  target=next(p['id'] for p in state['players'] if p['champion']=='garen')
  # Prepare a second local match before interrupting the visible effect.
  server2=subprocess.Popen([str(r/'target/debug/examples/annie_ready_fixture.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:10503'),stdout=sl,stderr=sl,creationflags=0x08000000)
  c_old=c;old_seq=seq;old_owner=owner
  c_new=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c_new.bind(('127.0.0.1',0));c_new.settimeout(.1)
  c=c_new;addr=('127.0.0.1',10503);seq=0;heartbeat=0;join_deadline=time.monotonic()+20
  while True:
   send({'Join':{'champion':'annie'}})
   try:welcome=receive('Welcome',.5);break
   except AssertionError:assert time.monotonic()<join_deadline
  new_session=welcome['session'];new_owner=welcome['player'];command({'Learn':{'slot':0}})
  while True:
   state=receive()
   if next(p for p in state['players'] if p['id']==new_owner)['ranks'][0]==1:break
  new_seq=seq;c=c_old;addr=('127.0.0.1',10501);seq=old_seq;heartbeat=0;owner=old_owner
  command({'Cast':{'slot':0,'target':target}})
  deadline=time.monotonic()+5
  while True:
   assert time.monotonic()<deadline,'old projection never became live'
   before=measurement()
   if before.get('active_draws')==1 and before.get('max_visible_draws',0)>0:break
   time.sleep(.005)
  old_packets=list(proxy.welcomes.values());assert old_packets
  old_server_pid=server.pid
  record('visible_before_switch',before)
  proxy.back.connect(('127.0.0.1',10503))
  proxy.back.send(json.dumps({'Join':{'champion':'garen'}}).encode())
  c=c_new;addr=('127.0.0.1',10503);seq=new_seq;heartbeat=0;owner=new_owner
  # Require actual new-session acceptance by the still-running graphical client.
  deadline=time.monotonic()+20
  while True:
   assert time.monotonic()<deadline,'graphical reconnect not observed'
   state=receive()
   log=(r/'logs/projected-core-cycle-v67-receivers-dx12-client.log').read_text(errors='replace')
   accepted=[json.JSONDecoder().raw_decode(line.split('ANNIE_RECEIVE ',1)[1])[0] for line in log.splitlines() if 'ANNIE_RECEIVE ' in line]
   if any(x['session']==new_session for x in accepted) and any(p['champion']=='garen' for p in state['players']):break
  # Replay original, unchanged old datagrams after the new handshake.
  for packet in old_packets:proxy.front.sendto(packet,proxy.peer)
  record('old_datagrams_replayed',{'count':len(old_packets),'new_session':new_session,'old_server_pid':old_server_pid,'new_server_pid':server2.pid,'client_pid':client.pid})
  target=next(p['id'] for p in state['players'] if p['champion']=='garen')
  while next(p for p in state['players'] if p['id']==owner)['ranks'][0]!=1:state=receive()
  command({'Cast':{'slot':0,'target':target}})
  deadline=time.monotonic()+5
  while time.monotonic()<deadline:
   assert client.poll() is None
   receive()
  log=(r/'logs/projected-core-cycle-v67-receivers-dx12-client.log').read_text(errors='replace')
  accepted=[json.JSONDecoder().raw_decode(line.split('ANNIE_RECEIVE ',1)[1])[0] for line in log.splitlines() if 'ANNIE_RECEIVE ' in line]
  sessions=list(dict.fromkeys(x['session'] for x in accepted));assert len(sessions)==2 and sessions[-1]==new_session,('unexpected accepted sessions',sessions)
  cut=next(i for i,x in enumerate(accepted) if x['session']==new_session)
  assert all(x['session']==new_session for x in accepted[cut:]),'stale session accepted after reconnect'
  record('reconnect_verified',{'sessions':sessions,'same_client_pid':client.pid,'old_packets_replayed':len(old_packets)})
  assert proxy.error is None,proxy.error
  result=measurement()
  assert result.get('created_effects',0)>=1,('missing replayed lifecycle',result)
  assert result.get('active_effects',-1)==0,('effect did not retire',result)
  assert result.get('active_draws',-1)==0,('draw did not retire',result)
  assert result.get('created_effects')==1,('old effect replayed in new session',result)
  receipt={'complete':False,'diagnostic_fixture':True,'batched_real_datagrams':proxy.batches,'measurement':measurement(),'client_sha256':sha(r/'target/debug/openleague-client.exe'),'limits':['Packets delayed and released in order without payload changes.','A controlled delivery perturbation does not prove original v49 failure cause.']}
  (r/'docs/projected_batch_v67.json').write_text(json.dumps(receipt,indent=2)+'\n')
  print(json.dumps(receipt))
finally:
 if proxy:proxy.close()
 (r/'logs/projected-v67-dx12-wire.json').write_text(json.dumps(journal,indent=2)+'\n')
 for sock in {c,c_old,c_new}:
  if sock:sock.close()
 for p in [client,server,server2]:
  if p and p.poll() is None:
   p.terminate()
   try:p.wait(timeout=10)
   except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)


