from pathlib import Path
import os,subprocess,socket,time,json,sys,datetime,hashlib,struct
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',16019);server=None;client=None;peers=[];ids=[];heartbeat=0
capture=r/'logs/grass-live-215.png';probe=r/'logs/grass-live-215.json';clientlog=r/'logs/grass-live-215-client.log';serverlog=r/'logs/grass-live-215-server.log'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def heartbeats():
 global heartbeat
 if time.monotonic()>=heartbeat:
  for i,p in enumerate(peers):p.sendto(json.dumps({'Join':{'champion':['garen','annie'][i],'summoners':[None,None]}}).encode(),addr)
  heartbeat=time.monotonic()+1
def measurement():
 try:return json.loads(probe.read_text())
 except (FileNotFoundError,json.JSONDecodeError):return None
try:
 for p in [capture,probe,clientlog,serverlog]:assert not p.exists(),str(p)
 check=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);check.bind(addr);check.close()
 with serverlog.open('w',encoding='utf-8') as sl,clientlog.open('w',encoding='utf-8') as cl:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:16019'),stdout=sl,stderr=sl,creationflags=0x08000000)
  for i in range(2):
   p=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);p.bind(('127.0.0.1',0));p.settimeout(.1);peers.append(p);deadline=time.monotonic()+15
   while True:
    assert server.poll() is None,'server stopped';heartbeats()
    try:packet=wire.packet(p)
    except (socket.timeout,ConnectionResetError):packet=None
    if packet and 'Welcome' in packet:ids.append(packet['Welcome']['player']);break
    assert time.monotonic()<deadline,'normal server join timeout'
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:16019',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(capture),OPENLEAGUE_SPATIAL_ACTORS_PROBE=str(probe),RUST_LOG='warn'),stdout=cl,stderr=cl,creationflags=0x08000000)
  print(json.dumps(dict(client_pid=client.pid,server_pid=server.pid,control_player_ids=ids)),flush=True)
  deadline=time.monotonic()+100
  while True:
   assert client.poll() is None and server.poll() is None,'runtime stopped';heartbeats();m=measurement()
   if m and m['registered']>=2 and m['root_members']==m['registered'] and m['error'] is None and any(v['id']==ids[0] for v in m['objects']) and capture.exists() and capture.stat().st_size>10000:break
   assert time.monotonic()<deadline,('normal spatial capture timeout',m)
   time.sleep(.1)
  initial=m;actor=next(v for v in m['objects'] if v['id']==ids[0]);decode=lambda bits:struct.unpack('<f',struct.pack('<I',bits))[0];x,z=decode(actor['center_bits'][0]),decode(actor['center_bits'][2])
  nav=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text());cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();cx=int((x-nav['min'][0])//nav['cellSize']);cz=int((z-nav['min'][2])//nav['cellSize']);target=None
  for dx,dz in [(1,0),(-1,0),(0,1),(0,-1)]:
   nx,nz=cx+dx,cz+dz
   if not(0<=nx<nav['width'] and 0<=nz<nav['height']):continue
   index=nz*nav['width']+nx;flags=struct.unpack_from('<H',cells,index*11+4)[0]
   if flags&2==0:target={'x':nav['min'][0]+(nx+.5)*nav['cellSize'],'z':nav['min'][2]+(nz+.5)*nav['cellSize']};break
  assert target is not None,'no adjacent walkable movement target'
  peers[0].sendto(json.dumps({'Command':{'sequence':1,'action':{'Move':{'point':target}}}}).encode(),addr)
  deadline=time.monotonic()+15
  while True:
   assert client.poll() is None and server.poll() is None;heartbeats();m=measurement();current=next((v for v in m['objects'] if v['id']==ids[0]),None) if m else None
   if current and current['center_bits']!=actor['center_bits'] and current['integer_bounds']!=actor['integer_bounds'] and m['error'] is None:break
   assert time.monotonic()<deadline,('normal movement did not update spatial index',m,target)
   time.sleep(.1)
  peers[0].sendto(json.dumps({'Command':{'sequence':2,'action':'Stop'}}).encode(),addr)
  receipt=dict(checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,normal_server=True,diagnostic_fixture=False,client_sha256=sha(r/'target/debug/openleague-client.exe'),server_sha256=sha(r/'target/debug/openleague-server.exe'),initial=initial,after_movement=m,movement_target=target,control_player_ids=ids,capture=str(capture),capture_sha256=sha(capture),visual_inspection_required=True,limits=['Normal local server, three connected players, loaded base champion models and movement via actual Command packet.','Snapshot identity/position and base actor scale1 are adapters; forms/skins/NPC registry and dynamic size producers remain open.','Spatial tree integration only; eligibility/camera/collector/mask/WALL are not bound. Screenshot shows startup rather than guaranteeing a movement-frame capture. No six-client victory/results qualification.','Server binary reused; hash recorded.'])
  (r/'docs/grass_live_registry_runtime.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(registered=m['registered'],movement_verified=True,capture=str(capture))),flush=True)
finally:
 for p in peers:p.close()
 for p in [client,server]:
  if p and p.poll() is None:
   p.terminate()
   try:p.wait(timeout=10)
   except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)
