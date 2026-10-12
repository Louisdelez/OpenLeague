from pathlib import Path
import os,subprocess,socket,json,struct,time,math,hashlib,datetime,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
address=('127.0.0.1',5946);clients=[];ids=[];seq=[0,0];server=None;heartbeat=0;checks=[];names=['annie','garen'];samples=[]
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
def wait(i,predicate,timeout=6):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  s=receive(i)
  if predicate(s):return s
 raise AssertionError('State predicate timed out')
try:
 with (r/'logs/annie-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5946'),stdout=log,stderr=log,creationflags=0x08000000)
  for i in range(2):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+15
   while True:
    send(i,{'Join':{'champion':names[i]}})
    try:ids.append(receive(i,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<end
  command(0,{'Buy':{'item':2004}});state=wait(0,lambda s:actor(s,0)['inventory'][0]==2004 and actor(s,0)['gold']==790);checks.append('native_mana_potion_purchase')
  command(0,{'Learn':{'slot':0}});wait(0,lambda s:actor(s,0)['ranks'][0]==1);checks.append('ordinary_Annie_Q_learning')
  command(0,{'Cast':{'slot':1,'target':None}});assert receive(0,'Rejected')['reason']=='Annie spell not implemented';checks.append('unsupported_kit_slots_explicit')
  command(0,{'Cast':{'slot':0,'target':ids[1]}});assert receive(0,'Rejected')['reason']=='spell target not visible';checks.append('hidden_enemy_Q_rejected')
  meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0];center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
  for i in range(2):command(i,{'Move':{'point':center}})
  state=wait(0,lambda s:len(s['players'])==2 and all(math.hypot(actor(s,i)['position']['x']-center['x'],actor(s,i)['position']['z']-center['z'])<10 for i in range(2)),75)
  for i in range(2):command(i,'Stop')
  before=actor(state,1)['health'];maxmana=actor(state,0)['mana'];command(0,{'Cast':{'slot':0,'target':ids[1]}})
  state=wait(0,lambda s:actor(s,0)['cooldowns'][0]>0);p=actor(state,0);ready=p['cooldowns'][0];cast=ready-120;assert abs(p['mana']-(maxmana-60))<1.;checks.append('Q_native_mana_and120tick_cooldown')
  command(0,{'Cast':{'slot':0,'target':ids[1]}});assert receive(0,'Rejected')['reason'] in ['skill blocked during cast','skill on cooldown'];checks.append('repeat_Q_rejected')
  state=wait(0,lambda s:actor(s,1)['health']<before);assert actor(state,1)['health']>0;checks.append('Q_actual_network_damage')
  command(0,{'UseItem':{'slot':0}});state=wait(0,lambda s:actor(s,0)['effects']['mana_potion_ticks']>0);p=actor(state,0);use=state['tick']-(450-p['effects']['mana_potion_ticks']);initial=p['mana'];initial_tick=state['tick'];assert p['inventory'][0] is None;checks.append('mana_potion_consumed_after_ordinary_spell')
  regen=json.loads((r/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'))['annie']['mana_regen'];errors=[]
  while state['tick']<initial_tick+90:
   p=actor(state,0);expected=min(maxmana,initial+(state['tick']-initial_tick)*(regen+100/15)/30);error=abs(p['mana']-expected);errors.append(error);assert error<.03,(state['tick'],p['mana'],expected,regen);assert p['effects']['mana_potion_ticks']==450-(state['tick']-use);samples.append({'tick':state['tick'],'mana':p['mana'],'expected':expected});state=receive(0)
  checks.append('mana_potion_network_restoration_and_timer')
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':len(checks),'check_names':checks,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'cast_tick':cast,'potion_use_tick':use,'max_mana_error':max(errors),'samples':samples,'limits':['Actual ordinary two-client UDP Q cast/mana/damage and mana potion restoration; no state injection. Q kill refund/cast timing/projectile survival tested in core only. Annie passive, W/E/R, spell animation/particles/audio/projectile renderer and original server policy fidelity incomplete.']};(r/'docs/annie_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(checks),'network checks, mana error',max(errors),flush=True)
finally:
 for c in clients:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
