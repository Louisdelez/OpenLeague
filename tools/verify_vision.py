"""Actual per-peer UDP vision without simulation-state injection."""
import json,socket,subprocess,time,os,math,struct,hashlib
from pathlib import Path
import wire
root=Path(__file__).resolve().parents[1];addr=('127.0.0.1',5903);clients=[];process=None
meta=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding="utf-8"));cells=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes()
points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&3==0]
center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
def send(c,p):c.sendto(json.dumps(p).encode(),addr)
def receive(c,kind,timeout=3):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  try:p=wire.packet(c)
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('No '+kind)
def command(i,n,action):send(clients[i],{'Command':{'sequence':n,'action':action}})
try:
 with (root/'logs/vision-server.log').open('w') as log:
  process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5903'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
  ids=[]
  for _ in range(2):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+15
   while True:
    send(c,{'Join':{'champion':'garen'}})
    try:ids.append(receive(c,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<end
  initial=receive(clients[0],'State')
  while len(initial['roster'])<2:initial=receive(clients[0],'State')
  assert [p['id'] for p in initial['players']]==[ids[0]]
  assert all(set(p)=={'id','team','champion'} for p in initial['roster'])
  assert not initial['map10']['relic_visible'] and initial['map10']['relic_ready_tick']==0
  command(0,1,{'Attack':{'target':ids[1]}});assert 'visible' in receive(clients[0],'Rejected')['reason']
  other=receive(clients[1],'State');home=next(p for p in other['players'] if p['id']==ids[1])['position']
  command(0,2,{'Move':{'point':center}});command(1,1,{'Move':{'point':center}})
  end=time.monotonic()+75;heartbeat=0;entered=None
  while time.monotonic()<end:
   assert process.poll() is None
   if time.monotonic()>=heartbeat:
    for c in clients:send(c,{'Join':{'champion':'garen'}})
    heartbeat=time.monotonic()+2
   state=receive(clients[0],'State')
   if any(p['id']==ids[1] for p in state['players']):entered=state['tick'];break
  assert entered is not None,'Enemy never became visible'
  command(0,3,'Stop');command(1,2,{'Move':{'point':home}})
  end=time.monotonic()+35;lost=None
  while time.monotonic()<end:
   if time.monotonic()>=heartbeat:
    for c in clients:send(c,{'Join':{'champion':'garen'}})
    heartbeat=time.monotonic()+2
   state=receive(clients[0],'State')
   if not any(p['id']==ids[1] for p in state['players']):lost=state['tick'];break
  assert lost is not None and lost>entered
  command(0,4,{'Attack':{'target':ids[1]}});assert 'visible' in receive(clients[0],'Rejected')['reason']
  result={'passed':True,'checks':7,'entered_vision_tick':entered,'lost_vision_tick':lost,'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'limits':['Real state filtering and targeting only. Terrain fog shading, remembered structures, stealth, wards and native vision fidelity remain incomplete.']}
  (root/'docs/vision_network_validation.json').write_text(json.dumps(result,indent=2),encoding='utf-8');print(json.dumps(result))
finally:
 for c in clients:c.close()
 if process is not None and process.poll() is None:
  process.terminate()
  try:process.wait(timeout=10)
  except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
