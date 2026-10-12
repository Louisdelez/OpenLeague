"""Real camp damage, relic heal/haste/respawn event, no injected state or accelerated clock."""
import json,socket,subprocess,time,os,math,struct,hashlib
from pathlib import Path
import wire
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5901)
c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.2);process=None
cfg=json.loads((root/'data/4.20/map10_interactions.json').read_text(encoding='utf-8'));world=json.loads((root/'data/4.20/map10_world.json').read_text(encoding='utf-8'))
meta=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding="utf-8"));cells=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes()
points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0]
def dist(a,b):return math.hypot(a['x']-b['x'],a['z']-b['z'])
def walkable(p):return min(points,key=lambda v:dist(p,v))
camp=min([x for x in world['camps'] if x['index']<=3],key=lambda x:dist(x['members'][0]['position'],cfg['relic_position']))
seq=0

def command(action):
 global seq
 seq+=1;c.sendto(json.dumps({'Command':{'sequence':seq,'action':action}}).encode(),address)
try:
 with (root/'logs/relic-server.log').open('w') as log:
  process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5901'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
  deadline=time.monotonic()+215;heartbeat=0;pid=None;phase=0;previous_hp=None;damage=None;pickup=None;result=None
  while time.monotonic()<deadline:
   assert process.poll() is None,'Server exited'
   if time.monotonic()>=heartbeat:c.sendto(json.dumps({'Join':{'champion':'garen'}}).encode(),address);heartbeat=time.monotonic()+2
   try:packet=wire.packet(c)
   except (socket.timeout,ConnectionResetError):continue
   if not packet:continue
   if 'Welcome' in packet:pid=packet['Welcome']['player']
   if 'Rejected' in packet:raise AssertionError(packet['Rejected']['reason'])
   if 'State' not in packet or pid is None:continue
   state=packet['State'];p=next(x for x in state['players'] if x['id']==pid);m=state['map10']
   assert p['health']>0,'Champion died before relic pickup'
   if phase==0:command({'Learn':{'slot':0}});command({'Move':{'point':walkable(camp['members'][0]['position'])}});phase=1
   if phase==1:
    monsters=[u for u in state['units'] if u['kind']=='Monster' and u['name'].startswith('camp_'+str(camp['index'])+'_')]
    if monsters:command({'Attack':{'target':min(monsters,key=lambda u:dist(u['position'],p['position']))['id']}});phase=2
   if phase==2 and p['health']<p['max_health']:
    damage={'tick':state['tick'],'health':p['health']};command({'Cast':{'slot':0,'target':None}});command({'Move':{'point':walkable(cfg['relic_position'])}});phase=3
    print('Real camp damage observed',damage,flush=True)
   if m['relic_last_picker']==pid and pickup is None:
    assert phase==3 and previous_hp is not None
    assert state['tick']>=5400 and m['relic_pickup_tick']>=5400
    assert p['health']>previous_hp,'No actual relic healing'
    assert m['relic_ready_tick']==m['relic_pickup_tick']+2700 and not m['relic_available']
    assert p['effects']['relic_haste_until']==m['relic_pickup_tick']+150
    pickup={'tick':m['relic_pickup_tick'],'health_before':previous_hp,'health_after':p['health'],'next_ready':m['relic_ready_tick']}
    print('Actual relic pickup observed',pickup,flush=True)
   if pickup is not None and state['tick']>=pickup['tick']+150:
    assert not m['relic_available'] and m['relic_pickup_tick']==pickup['tick']
    result={'passed':True,'checks':6,'damage':damage,'pickup':pickup,'after_haste_tick':state['tick'],'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'limits':['Real integration of reconstructed rules; exact 4.20 server coefficients and haste curve remain unqualified.','Relic respawn timer replicated; second actual pickup is covered by core tests, not this real-time probe.','Native particle rendering and audible output not visually/audibly qualified.']};break
   previous_hp=p['health']
  assert result is not None,'No real relic pickup in timeout'
  (root/'docs/relic_network_validation.json').write_text(json.dumps(result,indent=2),encoding='utf-8');print(json.dumps(result),flush=True)
finally:
 c.close()
 if process is not None and process.poll() is None:
  process.terminate()
  try:process.wait(timeout=10)
  except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
