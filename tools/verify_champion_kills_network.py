"""Actual three-client UDP champion kill/Exhaust assist/rewards; no injected damage/state."""
from pathlib import Path
import os,subprocess,socket,json,struct,time,math,hashlib,datetime
import wire
r=Path(__file__).resolve().parents[1];address=('127.0.0.1',5924);clients=[];ids=[];seq=[0,0,0];server=None;heartbeat=0

def send(i,p):clients[i].sendto(json.dumps(p).encode(),address)
def command(i,action):seq[i]+=1;send(i,{'Command':{'sequence':seq[i],'action':action}})
def receive(i,kind='State',timeout=4):
 global heartbeat
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  assert server.poll() is None,'Server exited'
  if len(ids)==3 and time.monotonic()>heartbeat:
   for n in range(3):send(n,{'Join':{'champion':'garen'}})
   heartbeat=time.monotonic()+2
  try:p=wire.packet(clients[i])
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('No '+kind+' packet')
def actor(state,i):return next(p for p in state['players'] if p['id']==ids[i])
def wait(predicate,timeout=6):
 end=time.monotonic()+timeout
 while True:
  state=receive(0)
  if predicate(state):return state
  assert time.monotonic()<end,'Predicate timeout'
try:
 log=(r/'logs/champion-kill-network-server.log').open('w',encoding='utf-8');server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5924'),stdout=log,stderr=log,creationflags=0x08000000)
 for i in range(3):
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+15
  while True:
   send(i,{'Join':{'champion':'garen','summoners':['Exhaust',None] if i==2 else [None,None]}})
   try:ids.append(receive(i,'Welcome',.5)['player']);break
   except AssertionError:assert time.monotonic()<end
 state=wait(lambda s:len(s['roster'])==3);assert not state['kill_events']
 meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0];center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
 for i in range(3):command(i,{'Move':{'point':center}})
 state=wait(lambda s:len(s['players'])==3 and all(math.hypot(actor(s,i)['position']['x']-center['x'],actor(s,i)['position']['z']-center['z'])<10 for i in range(3)),75)
 for i in range(3):command(i,'Stop')
 state=wait(lambda s:s['tick']>=state['tick']+6);initial_gold=[actor(state,i)['gold'] for i in range(3)];initial_xp=actor(state,0)['experience'];samples=[]
 command(0,{'Attack':{'target':ids[1]}})
 state=wait(lambda s:actor(s,1)['health']<=140,45);assert actor(state,1)['health']>0;command(0,'Stop')
 command(2,{'SummonerTarget':{'slot':0,'target':ids[1]}})
 state=wait(lambda s:actor(s,2)['summoners']['ready_at'][0]>0);mark=actor(state,2)['summoners']['ready_at'][0]-6300;assert actor(state,1)['health']>0
 command(0,{'Attack':{'target':ids[1]}})
 state=wait(lambda s:bool(s['kill_events']),10);event=state['kill_events'][-1];assert event['killer']==ids[0] and event['victim']==ids[1] and event['assists']==[ids[2]] and event['first_blood'] and event['killer_gold']==400
 assert event['tick']-mark<=450
 age=event['tick']/30;fraction=.25+.25*min(1,max(0,(age-90)/120));expected_assist=300*fraction
 assert abs(actor(state,0)['gold']-initial_gold[0]-400)<.01;assert abs(actor(state,2)['gold']-initial_gold[2]-expected_assist)<.01;assert abs(actor(state,0)['experience']-initial_xp-165)<.01
 assert actor(state,0)['score']['kills']==1 and actor(state,1)['score']['deaths']==1 and actor(state,2)['score']['assists']==1
 for i in range(3):assert next(p for p in state['roster'] if p['id']==ids[i])['score']==actor(state,i)['score']
 death=state;state=wait(lambda s:s['tick']>=event['tick']+6);assert len(state['kill_events'])==1 and actor(state,1)['score']['deaths']==1
 # Observe actual server respawn and retain public death count from victim-owned snapshots.
 respawn=actor(state,1)['respawn_at'];end=time.monotonic()+20
 while True:
  victim=receive(1)
  if victim['tick']>=respawn and actor(victim,1)['health']>0:break
  assert time.monotonic()<end,'Respawn timeout'
 assert actor(victim,1)['score']['deaths']==1;assert len(victim['kill_events'])==1
 proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':10,'port':5924,'players':ids,'event':event,'assist_mark_tick':mark,'initial_gold':initial_gold,'killer_gold_after':actor(death,0)['gold'],'assistant_gold_after':actor(death,2)['gold'],'expected_assist':expected_assist,'kill_xp':actor(death,0)['experience']-initial_xp,'scores':[actor(death,i)['score'] for i in range(3)],'respawn_tick_observed':victim['tick'],'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'limits':['Three actual localhost UDP clients: attack/navigation/Exhaust commands and authoritative snapshots only. No direct damage/state injection.','Base/firstblood/control-assist/respawn checked at level1; fullbounty adjustments, support/pets, sharedXP and originalleveldifference algorithm incomplete. Entire24domains remain incomplete.']}
 (r/'docs/champion_kill_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof),flush=True)
finally:
 for c in clients:c.close()
 if server is not None and server.poll() is None:server.terminate();server.wait(timeout=10)
