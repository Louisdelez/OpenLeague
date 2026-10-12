from pathlib import Path
import os,subprocess,socket,time,json,sys,datetime,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',16003);server=None;client=None;peers=[];ids=[];heartbeat=0
capture=r/'logs/champion-vision-130.png';probe=r/'logs/champion-vision-130.json';clientlog=r/'logs/champion-vision-130-client.log';serverlog=r/'logs/champion-vision-130-server.log'
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
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:16003'),stdout=sl,stderr=sl,creationflags=0x08000000)
  for i in range(2):
   p=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);p.bind(('127.0.0.1',0));p.settimeout(.1);peers.append(p);deadline=time.monotonic()+15
   while True:
    assert server.poll() is None,'server stopped';heartbeats()
    try:packet=wire.packet(p)
    except (socket.timeout,ConnectionResetError):packet=None
    if packet and 'Welcome' in packet:ids.append(packet['Welcome']['player']);break
    assert time.monotonic()<deadline,'normal server join timeout'
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:16003',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(capture),OPENLEAGUE_CHAMPION_VISION_PROBE=str(probe),RUST_LOG='warn'),stdout=cl,stderr=cl,creationflags=0x08000000)
  print(json.dumps(dict(client_pid=client.pid,server_pid=server.pid,control_player_ids=ids)),flush=True)
  deadline=time.monotonic()+100
  while True:
   assert client.poll() is None and server.poll() is None,'runtime stopped';heartbeats();m=measurement()
   if m and m['sources']==2 and m['visible_cells']>0 and m['pending']==0 and m['error'] is None and capture.exists() and capture.stat().st_size>10000:break
   assert time.monotonic()<deadline,('normal champion vision capture timeout',m)
   time.sleep(.1)
  assert ids[0] in m['source_ids'] and ids[1] not in m['source_ids'],('allied/enemy source filtering',m,ids)
  receipt=dict(checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,diagnostic_fixture=False,normal_server=True,client_sha256=sha(r/'target/debug/openleague-client.exe'),server_sha256=sha(r/'target/debug/openleague-server.exe'),measurement=m,control_player_ids=ids,capture=str(capture),capture_sha256=sha(capture),visual_inspection_required=True,limits=['Normal local server and three connected players; only living allied champion CPU mask integration checked.','Server binary reused; its hash recorded rather than claiming new server/core compilation.','Native source IDs/providers, full actor filtering and refresh initialization use snapshot adapter or remain incomplete; no GPU fog binding, NPC/ward/altar/stealth or six-client full-match acceptance.'])
  (r/'docs/champion_vision_runtime_capture.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');print(json.dumps(receipt),flush=True)
finally:
 for p in peers:p.close()
 for p in [client,server]:
  if p and p.poll() is None:
   p.terminate()
   try:p.wait(timeout=10)
   except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)
