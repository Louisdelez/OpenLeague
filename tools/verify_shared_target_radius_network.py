from pathlib import Path
import os,subprocess,socket,json,struct,time,math,hashlib,datetime,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
address=('127.0.0.1',5972);clients=[];ids=[];seq=[0,0];names=['garen','annie'];server=None;heartbeat=0;checks=[];shots=[]
def send(i,p):clients[i].sendto(json.dumps(p).encode(),address)
def command(i,a):seq[i]+=1;send(i,{'Command':{'sequence':seq[i],'action':a}})
def receive(i,kind='State',timeout=5):
 global heartbeat
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  assert server.poll() is None
  if len(ids)==2 and time.monotonic()>heartbeat:
   for n in range(2):send(n,{'Join':{'champion':names[n]}})
   heartbeat=time.monotonic()+2
  try:p=wire.packet(clients[i])
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('Missing '+kind)
def actor(s,i):return next(p for p in s['players'] if p['id']==ids[i])
def wait(predicate,timeout=8):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  s=receive(0)
  if predicate(s):return s
 raise AssertionError('State predicate timed out')
try:
 with (r/'logs/shared-target-radius-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5972'),stdout=log,stderr=log,creationflags=0x08000000)
  for i in range(2):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+15
   while True:
    send(i,{'Join':{'champion':names[i]}})
    try:ids.append(receive(i,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<end
  meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0]
  goals=[min(points,key=lambda p:math.hypot(p['x']-x,p['z']-7000)) for x in [7300,7700]]
  for i in range(2):command(i,{'Move':{'point':goals[i]}})
  state=wait(lambda s:len(s['players'])==2 and all(math.hypot(actor(s,i)['position']['x']-goals[i]['x'],actor(s,i)['position']['z']-goals[i]['z'])<10 for i in range(2)),75)
  for i in range(2):command(i,'Stop')
  hp=actor(state,1)['health'];command(0,{'Attack':{'target':ids[1]}})
  state=wait(lambda s:actor(s,1)['health']<hp-5,10)
  p=actor(state,0);q=actor(state,1);gap=math.hypot(p['position']['x']-q['position']['x'],p['position']['z']-q['position']['z'])
  # Native Garen melee range is125; Annie explicit gameplay radius55.
  assert 125<gap<=180,(gap,p['position'],q['position']);assert p['destination'] is None
  checks=['ordinary_native_map_movement','pursuit_stops_within125_plus55','attack_hits_from_outside_center_only_range','replicated_no_remaining_destination']
  proof={'passed':True,'complete':False,'checks':len(checks),'check_names':checks,'gap':gap,'tick':state['tick'],'players':2,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'limits':['Ordinary production UDP server with two clients, no fixture injection.','Original Riot server geometry, other control interactions and visual/audio acceptance remain unqualified.']}
  (r/'docs/shared_target_radius_network.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(checks),'ordinary UDP range checks',gap,flush=True)
finally:
 for c in clients:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
