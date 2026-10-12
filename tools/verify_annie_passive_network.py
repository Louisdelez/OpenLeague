from pathlib import Path
import os,subprocess,socket,json,struct,time,math,hashlib,datetime,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
address=('127.0.0.1',5974);clients=[];ids=[];seq=[0,0];names=['annie','garen'];server=None;heartbeat=0;checks=[];shots=[]
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
 with (r/'logs/annie-passive-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5974'),stdout=log,stderr=log,creationflags=0x08000000)
  for i in range(2):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+15
   while True:
    send(i,{'Join':{'champion':names[i]}})
    try:ids.append(receive(i,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<end
  command(0,{'Learn':{'slot':0}});state=wait(lambda s:actor(s,0)['ranks'][0]==1);assert actor(state,0)['effects']['pyromania']==0;checks.append('ordinary_spawn_zero_charges_and_Q_learning')
  meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0];center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
  for i in range(2):command(i,{'Move':{'point':center}})
  state=wait(lambda s:len(s['players'])==2 and all(math.hypot(actor(s,i)['position']['x']-center['x'],actor(s,i)['position']['z']-center['z'])<10 for i in range(2)),75)
  for i in range(2):command(i,'Stop')
  for cast in range(1,6):
   state=wait(lambda s:s['tick']>=actor(s,0)['cooldowns'][0],5)
   hp=actor(state,1)['health'];command(0,{'Cast':{'slot':0,'target':ids[1]}})
   state=wait(lambda s:actor(s,0)['effects']['annie_q'] is not None)
   assert actor(state,0)['effects']['pyromania']==min(cast-1,4);pending=actor(state,0)['effects']['annie_q'];release=pending['releases']
   state=wait(lambda s:s['tick']>release and actor(s,1)['health']<hp-5 and actor(s,0)['effects']['annie_q'] is None and not s['spell_projectiles'])
   charges=actor(state,0)['effects']['pyromania'];assert charges==(cast if cast<5 else 0)
   active=[stun for stun in actor(state,1)['stuns'] if stun['expires_at']>state['tick']]
   assert bool(active)==(cast==5)
   shots.append({'cast':cast,'release':release,'observation_tick':state['tick'],'charges':charges,'target_health':actor(state,1)['health'],'stuns':active})
   checks.append('Q'+str(cast)+'_impact_charge_and_stun_state')
  stun=shots[-1]['stuns'][0];assert stun['source']==ids[0] and stun['tag']=='Pyromania' and stun['expires_at']==shots[-1]['release']+1+38
  checks.append('level1_stun38_ticks_and_owner_replicated')
  send(0,{'GrantStun':{'target':ids[1],'duration':100}});assert receive(0,'Rejected')['reason'];checks.append('client_arbitrary_stun_rejected')
  state=wait(lambda s:s['tick']>=stun['expires_at']);assert not actor(state,1)['stuns'];checks.append('replicated_stun_expiry')
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':len(checks),'check_names':checks,'shots':shots,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'players':2,'limits':['Actual ordinary server UDP: native-grid movement, learnedQ, five casts, no arbitrary state/XP fixture injection.','Stun durations from reproduced historical Riot patch4.1 quotation, not recovered native numeric field. Event ordering/death/miss/immunity policies reconstructed; no full historical runtime acceptance.','No new visual/audio/input qualification; all24domains incomplete.']}
  (r/'docs/annie_passive_network.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(checks),'ordinary2clientUDP Pyromania checks',flush=True)
finally:
 for c in clients:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
