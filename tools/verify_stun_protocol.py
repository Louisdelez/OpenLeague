from pathlib import Path
import os,subprocess,socket,json,time,hashlib,datetime,math,struct
import wire
r=Path(__file__).resolve().parents[1];addr=('127.0.0.1',5942);server=None;c=None;sequence=0
try:
 with (r/'logs/stun-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5942'),stdout=log,stderr=log,creationflags=0x08000000);c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1)
  def send(p):c.sendto(json.dumps(p).encode(),addr)
  def receive(kind='State',timeout=5):
   end=time.monotonic()+timeout
   while time.monotonic()<end:
    assert server.poll() is None
    try:p=wire.packet(c)
    except (socket.timeout,ConnectionResetError):continue
    if p and kind in p:return p[kind]
   raise AssertionError('Missing '+kind)
  end=time.monotonic()+15
  while True:
   send({'Join':{'champion':'garen'}})
   try:id=receive('Welcome',.5)['player'];break
   except AssertionError:assert time.monotonic()<end
  state=receive();actor=next(p for p in state['players'] if p['id']==id);assert actor['stuns']==[];start=actor['position'];meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0];distance=lambda p:math.hypot(p['x']-start['x'],p['z']-start['z']);goal=min((p for p in points if distance(p)>60),key=distance)
  send({'Command':{'sequence':1,'action':{'Move':{'point':goal}}}});end=time.monotonic()+5
  while True:
   state=receive();actor=next(p for p in state['players'] if p['id']==id)
   if distance(actor['position'])>1:break
   assert time.monotonic()<end
  send({'Command':{'sequence':2,'action':{'GrantStun':{'target':id,'duration':100}}}});assert receive('Rejected')['reason']=='malformed or unsupported packet'
  send({'Command':{'sequence':3,'action':'Stop'}});end=time.monotonic()+5
  while True:
   state=receive();actor=next(p for p in state['players'] if p['id']==id)
   if actor['destination'] is None:break
   assert time.monotonic()<end
  assert actor['stuns']==[]
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':4,'check_names':['live serializedstuns empty','normalMove accepted','client arbitraryGrantStun rejected','Stop accepted andstuns unchanged'],'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'last_tick':state['tick'],'limits':['Local UDP wire/regression/authority checks only. Actualstun gameplay not tested onnetwork: no stunproducing championkit yet. Core fixtures exercise real Simulation API; not native runtime acceptance. Entiregame incomplete.']};(r/'docs/stun_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS4local UDP protocolchecks; no networkstun producer',flush=True)
finally:
 if c is not None:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
