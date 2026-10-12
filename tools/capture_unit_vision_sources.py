from pathlib import Path
import os,subprocess,socket,time,json,sys,datetime,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',16004);server=None;client=None;peers=[];ids=[];heartbeat=0;last_state=None;baseline=None
capture=r/'logs/unit-vision-132.png';probe=r/'logs/unit-vision-132.json';clientlog=r/'logs/unit-vision-132-client.log';serverlog=r/'logs/unit-vision-132-server.log'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def heartbeats():
 global heartbeat
 if time.monotonic()>=heartbeat:
  for i,p in enumerate(peers):p.sendto(json.dumps({'Join':{'champion':['garen','annie'][i],'summoners':[None,None]}}).encode(),addr)
  heartbeat=time.monotonic()+1
def measurement():
 try:return json.loads(probe.read_text())
 except (FileNotFoundError,json.JSONDecodeError):return None
def drain_state():
 global last_state
 for i,p in enumerate(peers):
  p.settimeout(.001)
  for _ in range(200):
   try:packet=wire.packet(p)
   except (socket.timeout,ConnectionResetError):break
   if i==0 and packet and 'State' in packet:last_state=packet['State']
def eligible_units(state,team):
 return [u for u in state['units'] if u['team']==team and u['health']>0 and u['kind'] in ['Melee','Caster','Siege','Super','Pet','Turret','Fountain']]
try:
 for p in [capture,probe,clientlog,serverlog]:assert not p.exists(),str(p)
 check=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);check.bind(addr);check.close()
 with serverlog.open('w',encoding='utf-8') as sl,clientlog.open('w',encoding='utf-8') as cl:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:16004'),stdout=sl,stderr=sl,creationflags=0x08000000)
  for i in range(2):
   p=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);p.bind(('127.0.0.1',0));p.settimeout(.1);peers.append(p);deadline=time.monotonic()+15
   while True:
    assert server.poll() is None,'server stopped';heartbeats()
    try:packet=wire.packet(p)
    except (socket.timeout,ConnectionResetError):packet=None
    if packet and 'Welcome' in packet:ids.append(packet['Welcome']['player']);break
    assert time.monotonic()<deadline,'normal server join timeout'
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:16004',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(capture),OPENLEAGUE_SCREENSHOT_DELAY='85',OPENLEAGUE_CHAMPION_VISION_PROBE=str(probe),RUST_LOG='warn'),stdout=cl,stderr=cl,creationflags=0x08000000)
  print(json.dumps(dict(client_pid=client.pid,server_pid=server.pid,control_player_ids=ids)),flush=True);deadline=time.monotonic()+140
  while True:
   assert client.poll() is None and server.poll() is None,'runtime stopped';heartbeats();drain_state();m=measurement()
   if m and last_state and m['error'] is None and m['pending']==0:
    team=next(p['team'] for p in last_state['players'] if p['id']==ids[0]);units=eligible_units(last_state,team)
    expected=set(u['id'] for u in units)|set(p['id'] for p in last_state['players'] if p['team']==team and p['health']>0)
    if set(m['source_ids'])==expected and abs(m['tick']-last_state['tick'])<=12:
     if baseline is None and last_state['tick']<2200:
      baseline=dict(measurement=m,units=[{'id':u['id'],'definition':u['definition'],'kind':u['kind']} for u in units]);print(json.dumps(dict(baseline_sources=m['sources'],baseline_units=baseline['units'])),flush=True)
     lanes=[u for u in units if u['kind'] in ['Melee','Caster','Siege','Super']]
     if baseline and lanes and last_state['tick']>=2400 and m['visible_cells']>0 and capture.exists() and capture.stat().st_size>10000:break
   assert time.monotonic()<deadline,('normal wave vision timeout',m)
   time.sleep(.05)
  assert ids[0] in m['source_ids'] and ids[1] not in m['source_ids']
  receipt=dict(checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,diagnostic_fixture=False,normal_server=True,client_sha256=sha(r/'target/debug/openleague-client.exe'),server_sha256=sha(r/'target/debug/openleague-server.exe'),baseline=baseline,measurement=m,server_tick=last_state['tick'],eligible_units=[{'id':u['id'],'definition':u['definition'],'kind':u['kind']} for u in units],lane_source_ids=[u['id'] for u in lanes],control_player_ids=ids,capture=str(capture),capture_sha256=sha(capture),visual_inspection_required=True,limits=['Normal server generated its first lane wave; live CPU source identities matched allied eligible player/unit snapshot identities with<=12tick skew.','Unit eligibility preserves current server rules; native full actor registration/class/filter producers and source ownership remain adapters/open.','Server binary reused with hash recorded. No GPU fog binding, altar/ward/stealth or six-client full-match qualification.'])
  (r/'docs/unit_vision_runtime_capture.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');print(json.dumps(receipt),flush=True)
finally:
 for p in peers:p.close()
 for p in [client,server]:
  if p and p.poll() is None:
   p.terminate()
   try:p.wait(timeout=10)
   except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)
