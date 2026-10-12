from pathlib import Path
import os,subprocess,socket,json,struct,time,math,hashlib,datetime,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',5954);clients=[];ids=[];seq=[0,0,0];server=None;heartbeat=0;names=['annie','garen','annie'];samples=[];checks=[]
def send(i,p):clients[i].sendto(json.dumps(p).encode(),addr)
def command(i,a):seq[i]+=1;send(i,{'Command':{'sequence':seq[i],'action':a}})
def receive(i,kind='State',timeout=5):
 global heartbeat
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  assert server.poll() is None
  if len(ids)==3 and time.monotonic()>heartbeat:
   for n in range(3):send(n,{'Join':{'champion':names[n]}})
   heartbeat=time.monotonic()+2
  try:p=wire.packet(clients[i])
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('Missing '+kind)
def actor(s,i):return next(p for p in s['players'] if p['id']==ids[i])
def wait(i,predicate,timeout=6):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  s=receive(i)
  if predicate(s):return s
 raise AssertionError('State predicate timed out')
try:
 with (r/'logs/annie-w-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5954'),stdout=log,stderr=log,creationflags=0x08000000)
  for i in range(3):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+15
   while True:
    send(i,{'Join':{'champion':names[i]}})
    try:ids.append(receive(i,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<end
  command(0,{'Buy':{'item':1052}});wait(0,lambda s:actor(s,0)['inventory'][0]==1052 and actor(s,0)['gold']==390);checks.append('native20AP_purchase')
  command(0,{'Learn':{'slot':1}});wait(0,lambda s:actor(s,0)['ranks'][1]==1);checks.append('ordinary_W_learning')
  command(0,{'Cast':{'slot':1,'target':None}});assert receive(0,'Rejected')['reason']=='directional spell requires ground point';checks.append('legacy_cast_missing_direction_rejected')
  command(0,{'CastAt':{'slot':4,'point':{'x':100,'z':100}}});assert receive(0,'Rejected')['reason']=='invalid skill slot';checks.append('invalid_ground_slot_rejected')
  meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0];center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000));goals=[min(points,key=lambda p:math.hypot(p['x']-(center['x']+offset),p['z']-center['z'])) for offset in [-200,0,50]]
  for i in range(3):command(i,{'Move':{'point':goals[i]}})
  state=wait(0,lambda s:len(s['players'])==3 and all(math.hypot(actor(s,i)['position']['x']-goals[i]['x'],actor(s,i)['position']['z']-goals[i]['z'])<10 for i in range(3)),75)
  for i in range(3):command(i,'Stop')
  mana=actor(state,0)['mana'];enemy_hp=actor(state,1)['health'];ally_hp=actor(state,2)['health']
  command(0,{'CastAt':{'slot':1,'point':{'x':goals[0]['x']-1000,'z':goals[0]['z']}}});state=wait(0,lambda s:actor(s,0)['effects']['annie_w'] is not None);p=actor(state,0);cast=p['effects']['annie_w']['releases']-8;ready=p['cooldowns'][1];assert ready-cast==240;assert abs(p['mana']-(mana-70))<1.;checks.append('native70mana240tick_cooldown8tick_cast')
  command(0,{'CastAt':{'slot':1,'point':goals[1]}});assert receive(0,'Rejected')['reason']=='skill blocked during cast';checks.append('committed_cast_repeat_rejected')
  state=wait(0,lambda s:s['tick']>=cast+15);assert actor(state,1)['health']==enemy_hp;assert actor(state,2)['health']==ally_hp;checks.append('backward_cone_misses_targets')
  command(0,{'CastAt':{'slot':1,'point':goals[1]}});assert receive(0,'Rejected')['reason']=='skill on cooldown';checks.append('cooldown_repeat_rejected')
  state=wait(0,lambda s:s['tick']>=ready,10)
  # Aim beyond native damage range: point sets direction, cone length stays625.
  command(0,{'CastAt':{'slot':1,'point':{'x':goals[0]['x']+1000,'z':goals[0]['z']}}});state=wait(0,lambda s:actor(s,0)['effects']['annie_w'] is not None);release=actor(state,0)['effects']['annie_w']['releases'];hp=actor(state,1)['health'];assert hp==enemy_hp
  state=wait(0,lambda s:actor(s,1)['health']<hp);assert release<=state['tick']<=release+5
  defs=json.loads((r/'data/4.20/champions.json').read_text(encoding='utf-8'));mr=next(d['magic_resist'] for d in defs if d['id']=='garen');regen=json.loads((r/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'))['garen']['health_regen'];expected=87*100/(100+mr);observed=hp-actor(state,1)['health'];assert abs(observed-expected)<.3,(observed,expected,regen);checks.append('native70plus0_85AP_network_damage')
  assert actor(state,2)['health']==ally_hp;checks.append('ally_in_cone_not_damaged');samples.append({'tick':state['tick'],'enemy_hp':actor(state,1)['health'],'ally_hp':actor(state,2)['health'],'expected_damage':expected,'observed_damage':observed})
  hp_after=actor(state,1)['health'];state=wait(0,lambda s:s['tick']>=release+40);assert actor(state,1)['health']>=hp_after;checks.append('single_AoE_pulse_no_repeated_damage')
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':len(checks),'check_names':checks,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'players':3,'first_cast':cast,'first_ready':ready,'second_release':release,'native_raw_damage':87,'observed_damage':observed,'expected_damage':expected,'samples':samples,'limits':['Actual3client UDP ordinary purchase/learn/Move/CastAt. Verified cost/CD/pending/block, reverse miss, forward enemy hit, ally immunity and single pulse; no state injection.','Exact contact/native server sequence, other visibility/invulnerability/classes, clip playback/particles/audio/fullHUD/physicalinput not qualified. Pyromania/R/Tibbers and all remaininggame scope incomplete.']};(r/'docs/annie_w_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(checks),'three-client UDP W checks; damage',observed,'expected',expected,flush=True)
finally:
 for c in clients:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
