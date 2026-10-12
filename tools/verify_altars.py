"""Exercise actual opposing UDP players contesting and capturing an altar without clock injection."""
import json,socket,subprocess,time,os,math,struct,hashlib,select
from pathlib import Path
import wire
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5902);clients=[];process=None
meta=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding="utf-8"));cells=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes()
points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0]
def dist(a,b):return math.hypot(a['x']-b['x'],a['z']-b['z'])
def walk(p):return min(points,key=lambda q:dist(p,q))
ids={};seq=[0,0]
def command(index,action):
 seq[index]+=1;clients[index].sendto(json.dumps({'Command':{'sequence':seq[index],'action':action}}).encode(),address)
try:
 with (root/'logs/altar-server.log').open('w') as log:
  process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5902'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
  for _ in range(2):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.setblocking(False);clients.append(c)
  deadline=time.monotonic()+235;heartbeat=0;moved=False;phase=0;contest_tick=None;capture=None;result=None
  while time.monotonic()<deadline:
   assert process.poll() is None,'Server stopped'
   if time.monotonic()>=heartbeat:
    for c in clients:c.sendto(json.dumps({'Join':{'champion':'garen'}}).encode(),address)
    heartbeat=time.monotonic()+2
   readable,_,_=select.select(clients,[],[],.1)
   for c in readable:
    try:packet=wire.packet(c)
    except (BlockingIOError,ConnectionResetError):continue
    if not packet:continue
    if 'Welcome' in packet:ids[clients.index(c)]=packet['Welcome']['player']
    if 'Rejected' in packet:raise AssertionError(packet['Rejected']['reason'])
    if 'State' not in packet or c is not clients[0] or len(ids)<2:continue
    s=packet['State'];m=s['map10'];a=next(x for x in m['altars'] if x['name']=='altar_west');p=[next(x for x in s['players'] if x['id']==ids[j]) for j in range(2)]
    assert all(x['health']>0 for x in p),'Champion died during altar probe'
    if not moved:
     for j in range(2):command(j,{'Move':{'point':walk(a['position'])}})
     moved=True
    if s['tick']<5400:assert a['owner'] is None and a['capturing'] is None
    if s['tick']>=5400 and phase==0:
     assert all(dist(x['position'],a['position'])<a['radius'] for x in p)
     assert a['contested'] and a['progress_ticks']==0
     contest_tick=s['tick'];phase=1;print('Actual altar contested at tick',contest_tick,flush=True)
    if phase==1:
     assert a['owner'] is None and a['progress_ticks']==0
     if s['tick']>=contest_tick+60:
      command(1,{'Move':{'point':walk({'x':a['position']['x']+1400,'z':a['position']['z']})}});phase=2
    if phase==2 and a['owner']==p[0]['team']:
     capture={'tick':a['captured_tick'],'locked_until':a['locked_until'],'owner':a['owner']}
     assert a['locked_until']==a['captured_tick']+2700
     command(1,{'Move':{'point':walk(a['position'])}});phase=3;print('Actual altar capture',capture,flush=True)
    if phase==3 and dist(p[1]['position'],a['position'])<a['radius']:
     assert a['owner']==p[0]['team'] and a['capturing'] is None
     assert p[1]['id'] in m['revealed_by_altar']
     result={'passed':True,'checks':6,'contest_tick':contest_tick,'capture':capture,'locked_enemy_entry_tick':s['tick'],'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'limits':['Tests integration of reconstructed trigger radius, capture duration and contest semantics, not exact native server fidelity.','Altar vision currently exposes a replicated reveal flag; full fog filtering remains incomplete.','Native geometry/animation/audio acceptance and capture gold/mana regeneration remain incomplete.']};break
   if result:break
  assert result is not None,'No real altar contest/capture within timeout'
  (root/'docs/altar_network_validation.json').write_text(json.dumps(result,indent=2),encoding='utf-8');print(json.dumps(result),flush=True)
finally:
 for c in clients:c.close()
 if process is not None and process.poll() is None:
  process.terminate()
  try:process.wait(timeout=10)
  except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
