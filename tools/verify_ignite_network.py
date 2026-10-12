"""Actual localhost UDP Ignite acceptance; no fixture state injection."""
from pathlib import Path
import os,subprocess,socket,json,struct,time,math,hashlib,datetime
import wire
r=Path(__file__).resolve().parents[1];address=('127.0.0.1',5920);clients=[];ids=[];seq=[0,0];server=None;samples=[];heartbeat=0

def send(index,p):clients[index].sendto(json.dumps(p).encode(),address)
def command(index,action):seq[index]+=1;send(index,{'Command':{'sequence':seq[index],'action':action}})
def receive(index,kind='State',timeout=4):
 global heartbeat
 deadline=time.monotonic()+timeout
 while time.monotonic()<deadline:
  assert server.poll() is None,'Server exited'
  if len(ids)==2 and time.monotonic()>heartbeat:
   for i in range(2):send(i,{'Join':{'champion':'garen'}})
   heartbeat=time.monotonic()+2
  try:p=wire.packet(clients[index])
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('No '+kind+' packet')
def actor(state,index):return next(p for p in state['players'] if p['id']==ids[index])
def wait(predicate,timeout=6):
 deadline=time.monotonic()+timeout
 while True:
  state=receive(0)
  if predicate(state):return state
  assert time.monotonic()<deadline,'Predicate timeout'
try:
 log=(r/'logs/ignite-network-server.log').open('w',encoding='utf-8');server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5920'),stdout=log,stderr=log,creationflags=0x08000000)
 for i,spell in enumerate(['Ignite','Heal']):
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c)
  deadline=time.monotonic()+15
  while True:
   send(i,{'Join':{'champion':'garen','summoners':[spell,None]}})
   try:ids.append(receive(i,'Welcome',.5)['player']);break
   except AssertionError:assert time.monotonic()<deadline
 state=wait(lambda s:len(s['roster'])==2)
 for target in [None,ids[0],999999,ids[1]]:
  command(0,{'SummonerTarget':{'slot':0,'target':target}});reason=receive(0,'Rejected')['reason'];assert 'ignite' in reason
 state=receive(0);assert actor(state,0)['summoners']['ready_at'][0]==0
 meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0];center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
 for i in range(2):command(i,{'Move':{'point':center}})
 state=wait(lambda s:len(s['players'])==2 and all(math.hypot(actor(s,i)['position']['x']-center['x'],actor(s,i)['position']['z']-center['z'])<10 for i in range(2)),75)
 for i in range(2):command(i,'Stop')
 state=wait(lambda s:s['tick']>=state['tick']+6);before=actor(state,1)['health'];regen=json.loads((r/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'))['garen']['health_regen'];assert abs(before-actor(state,1)['max_health'])<.01
 command(0,{'SummonerTarget':{'slot':0,'target':ids[1]}});state=wait(lambda s:actor(s,1)['effects'].get('ignite') is not None)
 burn=actor(state,1)['effects']['ignite'];cast=burn['expires_at']-150;assert burn['source']==ids[0] and burn['remaining_ticks']==4 and burn['damage_per_tick']==14;assert actor(state,0)['summoners']['ready_at'][0]==cast+5400
 command(0,{'SummonerTarget':{'slot':0,'target':ids[1]}});assert receive(0,'Rejected')['reason']=='summoner spell on cooldown'
 healed=False;heal_tick=None;seen_hits=set();max_error=0
 while state['tick']<cast+153:
  victim=actor(state,1);elapsed=state['tick']-cast;hits=min(5,1+elapsed//30);seen_hits.add(hits)
  if elapsed>=0:
   half_ticks=min(elapsed,149);full_ticks=max(0,elapsed-149);expected=before-hits*14+regen*(half_ticks*.5+full_ticks)/30+(45 if healed and heal_tick is not None and state['tick']>=heal_tick else 0)
   error=abs(victim['health']-expected);max_error=max(max_error,error);assert error<.02,('Health trajectory',state['tick'],victim['health'],expected,error)
   samples.append({'tick':state['tick'],'health':victim['health'],'expected':expected,'ignite':victim['effects'].get('ignite')})
  if elapsed>=95 and not healed:
   command(1,{'Summoner':{'slot':0}})
   # Observe owner-side cast stamp; server is authoritative and frames can span several ticks.
   own=receive(1)
   while actor(own,1)['summoners']['ready_at'][0]==0:own=receive(1)
   heal_tick=actor(own,1)['summoners']['ready_at'][0]-7200;healed=True
  state=receive(0)
 assert seen_hits=={1,2,3,4,5};assert actor(state,1)['effects'].get('ignite') is None;assert actor(state,0)['summoners']['ready_at'][0]==cast+5400
 proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':8,'port':5920,'players':ids,'cast_tick':cast,'heal_tick':heal_tick,'damage_ticks_seen':sorted(seen_hits),'heal_received':45,'maximum_health_trajectory_error':max_error,'samples':samples,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'limits':['Actual localhost UDP commands/navigation/state measured; no direct damage/state injection.','Only two clients/Garen level1/one caster; level18/lifecycle/buff policies separately unit-tested.','Original precise ticks/overlap/vision-sharing/fountain exceptions still reconstructed; particles/sound absent. Entire game incomplete.']}
 (r/'docs/ignite_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k!='samples'}),flush=True)
finally:
 for c in clients:c.close()
 if server is not None and server.poll() is None:server.terminate();server.wait(timeout=10)
