from pathlib import Path
import os,sys,json,socket,time,subprocess,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
address=('127.0.0.1',10504);owned=None;clients=[];events=[]
def send(c,p):c.send(json.dumps(p).encode())
def client():
 c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.connect(address);c.settimeout(.05);clients.append(c);return c
def take(c,predicate,timeout=12):
 deadline=time.monotonic()+timeout
 while time.monotonic()<deadline:
  assert owned.poll() is None,'server stopped'
  try:p=wire.packet(c)
  except (socket.timeout,ConnectionResetError):continue
  if p is None:continue
  if 'ClockControl' in p:events.append({'at':time.monotonic(),'clock':p['ClockControl']})
  if predicate(p):return p
 raise AssertionError('packet timeout')
def join(c,name):
 deadline=time.monotonic()+30
 while time.monotonic()<deadline:
  send(c,{'Join':{'champion':name}})
  try:return take(c,lambda p:'Welcome' in p,.5)['Welcome']
  except AssertionError:
   assert owned.poll() is None
 raise AssertionError('join timeout')
def state(c):return take(c,lambda p:'State' in p)['State']
def control(c,ordinal,flag=None):
 return take(c,lambda p:'ClockControl' in p and p['ClockControl']['ordinal']==ordinal and (flag is None or p['ClockControl']['payload'][9]==flag))['ClockControl']
def ack(c,w,n):send(c,{'ClockAck':{'session':w['session'],'ordinal':n}})
def spawn(enabled,log):
 global owned
 env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:10504',OPENLEAGUE_ALLOW_PAUSE='1' if enabled else '0')
 owned=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=env,stdout=log,stderr=log,creationflags=0x08000000)
def stop():
 global owned
 for c in clients:c.close()
 clients.clear()
 if owned and owned.poll() is None:
  owned.terminate()
  try:owned.wait(timeout=10)
  except subprocess.TimeoutExpired:owned.kill();owned.wait(timeout=5)
 owned=None
result={'complete':False,'passed':False}
try:
 with (r/'logs/server-pause-udp-v1-disabled.log').open('w') as log:
  spawn(False,log);c=client();w=join(c,'garen');send(c,{'PauseRequest':{'sequence':1,'paused':True}})
  rejected=take(c,lambda p:'Rejected' in p)['Rejected']['reason'];assert rejected=='pause disabled by local match host';result['disabled_host_rejection']=rejected;stop()
 with (r/'logs/server-pause-udp-v1-enabled.log').open('w') as log:
  spawn(True,log);c=client();w=join(c,'garen');before=state(c)
  send(c,{'PauseRequest':{'sequence':1,'paused':True}});first=control(c,1);repeat=control(c,1);assert first==repeat and first['opcode']==0xa1
  frozen=[state(c) for _ in range(4)];tick=frozen[-1]['tick'];assert all(s['tick']==tick for s in frozen)
  actor=next(p for p in frozen[-1]['players'] if p['id']==w['player'])
  point={'x':actor['position']['x']+100,'z':actor['position']['z']}
  send(c,{'Command':{'sequence':2,'action':{'Move':{'point':point}}}})
  assert take(c,lambda p:'Rejected' in p)['Rejected']['reason']=='match is paused';assert state(c)['tick']==tick;ack(c,w,1)
  c2=client();w2=join(c2,'annie');assert control(c2,1)['opcode']==0xa1;assert state(c2)['tick']==tick;ack(c2,w2,1)
  send(c,{'PauseRequest':{'sequence':3,'paused':False}});assert control(c,2,1)['opcode']==0x0a;resume_requested=time.monotonic();ack(c,w,2)
  send(c,{'PauseRequest':{'sequence':4,'paused':False}});assert take(c,lambda p:'Rejected' in p)['Rejected']['reason']=='resume already scheduled'
  assert control(c2,2,1)['opcode']==0x0a;ack(c2,w2,2)
  while time.monotonic()-resume_requested<2:assert state(c)['tick']==tick
  c3=client();w3=join(c3,'garen');assert control(c3,1)['opcode']==0xa1;assert state(c3)['tick']==tick;ack(c3,w3,1)
  while time.monotonic()-resume_requested<4:assert state(c)['tick']==tick
  assert control(c,3,0)['opcode']==0x0a;resumed=time.monotonic();ack(c,w,3)
  assert control(c2,3,0)['opcode']==0x0a;ack(c2,w2,3)
  assert control(c3,2,0)['opcode']==0x0a;ack(c3,w3,2)
  resumed_states=[]
  while time.monotonic()-resumed<1.1:
   s=state(c);resumed_states.append({'tick':s['tick'],'elapsed':time.monotonic()-resumed});assert s['tick']-tick<=int((time.monotonic()-resumed)*30)+8,'pause catchup debt'
  assert resumed_states[-1]['tick']>tick
  result.update(passed=True,frozen_tick=tick,duplicate_payload_identical=True,paused_join=True,countdown_join=True,countdown_seconds_observed=resumed-resume_requested,resumed_states=resumed_states,server_sha256=hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),limits=['Production local server with explicit OPENLEAGUE_ALLOW_PAUSE=1; official mode/player permission fidelity not claimed.','Real UDP and simulation tick checks; no graphical client or GPU paused-effect capture.','Three fresh socket identities tested; replacement process reusing an existing socket identity remains outside this case.'])
finally:
 stop();(r/'docs/server_pause_udp_v1.json').write_text(json.dumps(result,indent=2)+'\n');(r/'logs/server-pause-udp-v1-events.json').write_text(json.dumps(events,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='resumed_states'}))
