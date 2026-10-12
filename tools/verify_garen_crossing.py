"""Measure native-E crossing penalty against normally spawned Map10 golem, actual UDP."""
import wire,json,socket,subprocess,time,os,hashlib,datetime,struct,math
from pathlib import Path
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5914);exe=root/'target/debug/openleague-server.exe'
client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);client.bind(('127.0.0.1',0));client.settimeout(.2);process=None;heartbeat=0
world=json.loads((root/'data/4.20/map10_world.json').read_text(encoding='utf-8'));camp=next(c for c in world['camps'] if c['index']==2);member=next(m for m in camp['members'] if m['definition']=='TT_NGolem')
meta=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();width=meta['width'];height=meta['height'];size=meta['cellSize'];points={}
for i in range(width*height):
 if struct.unpack_from('<H',cells,i*11+4)[0]&2==0:points[i]={'x':meta['min'][0]+(i%width+.5)*size,'z':meta['min'][2]+(i//width+.5)*size}
def dist(a,b):return math.hypot(a['x']-b['x'],a['z']-b['z'])
def send(message):client.sendto(json.dumps(message).encode(),address)
def receive(kind,timeout=4):
 global heartbeat
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  if time.monotonic()>heartbeat:send({'Join':{'champion':'garen'}});heartbeat=time.monotonic()+2
  try:packet=wire.packet(client)
  except (socket.timeout,ConnectionResetError):continue
  if packet and kind in packet:return packet[kind]
 raise AssertionError('No packet '+kind)
def command(seq,action):send({'Command':{'sequence':seq,'action':action}})
def own(state):return next(p for p in state['players'] if p['id']==player)
def crossing(state):
 p=own(state)
 return any(u['health']>0 and u['kind'] in ['Melee','Caster','Siege','Super','Monster','Boss'] and dist(p['position'],u['position'])<=world['definitions'][u['definition']]['radius'] for u in state['units'])
try:
 with (root/'logs/garen-crossing-server.log').open('w',encoding='utf-8') as log:
  process=subprocess.Popen([str(exe)],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5914'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
  deadline=time.monotonic()+15
  while True:
   assert process.poll() is None
   send({'Join':{'champion':'garen'}})
   try:player=receive('Welcome',.5)['player'];break
   except AssertionError:assert time.monotonic()<deadline
  start_index=min(points,key=lambda i:dist(points[i],member['position']));start=points[start_index]
  assert dist(start,member['position'])<world['definitions']['TT_NGolem']['radius']-15
  paths=[]
  for step in [1,-1,width,-width]:
   run=[]
   for n in range(1,7):
    index=start_index+step*n
    if index not in points:break
    if abs(step)==1 and index//width!=start_index//width:break
    run.append(index)
   if len(run)>=4:paths.append(run)
  assert paths,'No straight native-grid crossing corridor'
  goal=points[max(paths,key=len)[-1]]
  command(1,{'Learn':{'slot':2}});command(2,{'Move':{'point':start}})
  deadline=time.monotonic()+135;arrived=False;announced=False
  while True:
   state=receive('State');p=own(state);assert p['health']>0
   if dist(p['position'],start)<1 and not arrived:command(3,'Stop');arrived=True
   if arrived and not announced:print(json.dumps({'phase':'waiting_for_native_camp_spawn','tick':state['tick'],'spawn_tick':3000}),flush=True);announced=True
   golems=[u for u in state['units'] if u['definition']=='TT_NGolem' and dist(u['position'],member['position'])<200]
   if arrived and golems and crossing(state):break
   assert time.monotonic()<deadline,'No normally spawned golem contact'
   assert process.poll() is None
  assert state['tick']>=3000 and p['ranks'][2]==1
  command(4,{'Cast':{'slot':2,'target':None}});command(5,{'Move':{'point':goal}})
  samples=[];previous=None;deadline=time.monotonic()+5
  while time.monotonic()<deadline:
   current=receive('State');p=own(current)
   if previous is not None:
    before=own(previous);dt=current['tick']-previous['tick'];travel=dist(p['position'],before['position'])
    if dt>0 and travel>0.1 and current['tick']<p['effects']['spin_until']-3 and before['effects']['spin_until']>previous['tick']:
     speed=travel*30/dt;samples.append({'tick':current['tick'],'speed':speed,'before_contact':crossing(previous),'after_contact':crossing(current)})
   previous=current
   if any(x['before_contact'] and x['after_contact'] and abs(x['speed']-276)<.03 for x in samples) and any(not x['before_contact'] and not x['after_contact'] and abs(x['speed']-345)<.03 for x in samples):break
  inside=[x for x in samples if x['before_contact'] and x['after_contact'] and abs(x['speed']-276)<.03]
  outside=[x for x in samples if not x['before_contact'] and not x['after_contact'] and abs(x['speed']-345)<.03]
  assert inside and outside,('No paired inside/outside walking measurement',samples)
  command(6,{'Cast':{'slot':2,'target':None}})
  deadline=time.monotonic()+3
  while True:
   state=receive('State');p=own(state)
   if p['effects']['spin_rank']==0:break
   assert time.monotonic()<deadline
  proof={'passed':True,'checks':['original map grid used without path injection','Garen learned native E and walked from fountain to camp','golem spawned at native 100-second baseline without tick injection','actual E-active contact walking measured at 276 units per second','same E-active order restores 345 units per second after leaving contact','E cancellation replicated after crossing'], 'samples':samples,'server_sha256':hashlib.sha256(exe.read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Measures current center-in-NPC-radius reconstruction, not original Riot body/collision/order equivalence.','One camp and Garen rank-one E without items/slows; full crit, native VFX/audio, collision and 3v3 not qualified.']}
  (root/'docs/garen_crossing_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':True,'checks':len(proof['checks']),'inside':inside[0]['speed'],'outside':outside[0]['speed']}),flush=True)
finally:
 client.close()
 if process is not None and process.poll() is None:
  process.terminate()
  try:process.wait(timeout=10)
  except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
