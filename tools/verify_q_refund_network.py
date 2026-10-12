from pathlib import Path
import os,subprocess,socket,json,struct,time,math,hashlib,datetime,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
address=('127.0.0.1',5970);clients=[];ids=[];seq=[0,0];names=['annie','garen'];server=None;heartbeat=0;checks=[];shots=[]
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
 with (r/'logs/q-refund-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5970'),stdout=log,stderr=log,creationflags=0x08000000)
  for i in range(2):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+15
   while True:
    send(i,{'Join':{'champion':names[i]}})
    try:ids.append(receive(i,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<end
  command(0,{'Buy':{'item':3108}});state=wait(lambda s:actor(s,0)['inventory'][0]==3108 and actor(s,0)['gold']==5);checks.append('ordinary_Codex30AP10CDR_purchase')
  command(0,{'Learn':{'slot':0}});state=wait(lambda s:actor(s,0)['ranks'][0]==1);checks.append('ordinary_Q_learning')
  meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0];center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
  for i in range(2):command(i,{'Move':{'point':center}})
  state=wait(lambda s:len(s['players'])==2 and all(math.hypot(actor(s,i)['position']['x']-center['x'],actor(s,i)['position']['z']-center['z'])<10 for i in range(2)),75)
  for i in range(2):command(i,'Stop')
  command(0,{'Attack':{'target':ids[1]}});state=wait(lambda s:actor(s,1)['health']<220,40);command(0,'Stop');settle=state['tick']+45;state=wait(lambda s:s['tick']>=settle and actor(s,0)['windup'] is None);assert actor(state,1)['health']>0;checks.append('ordinary_basic_attacks_prepare_Q_last_hit')
  nonlethal=0
  for _ in range(5):
   if state['tick']<actor(state,0)['cooldowns'][0]:state=wait(lambda s:s['tick']>=actor(s,0)['cooldowns'][0],5)
   mana=actor(state,0)['mana'];before_tick=state['tick'];command(0,{'Cast':{'slot':0,'target':ids[1]}});state=wait(lambda s:actor(s,0)['effects']['annie_q'] is not None);q=actor(state,0)['effects']['annie_q'];ready=q['cooldown_ready'];cast=q['releases']-8;assert ready-cast==108 and q['refund_ticks']==54
   state=wait(lambda s:s['tick']>=q['releases']+3 and not s['spell_projectiles'] and actor(s,0)['effects']['annie_q'] is None);p=actor(state,0);shot={'cast':cast,'ready':ready,'impact_observation':state['tick'],'deadline_after':p['cooldowns'][0],'target_health':actor(state,1)['health'],'mana_before':mana,'mana_after':p['mana']};shots.append(shot)
   if actor(state,1)['health']<=0:
    assert p['cooldowns'][0]==cast+54 and p['score']['kills']==1 and actor(state,1)['score']['deaths']==1;assert p['mana']>=mana-.02;checks.extend(['Q_own_lethal_hit_rewards','native_mana_refund_on_kill','half_CDR_adjusted_cooldown_refund_on_kill']);break
   assert p['cooldowns'][0]==ready;assert p['mana']<mana-55;nonlethal+=1
  else:raise AssertionError('No lethal Q within5casts')
  assert nonlethal>=1;checks.append('nonlethal_Q_does_not_refund_mana_or_cooldown')
  command(0,{'Cast':{'slot':0,'target':ids[1]}});assert receive(0,'Rejected')['reason']=='skill on cooldown';checks.append('refunded_deadline_still_blocks_early_recast')
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':len(checks),'check_names':checks,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'players':2,'nonlethal_casts':nonlethal,'shots':shots,'limits':['Actual ordinary production-server two-client UDP: Codex purchase/learning/movement/basic attacks/Q nonlethal then lethal; no initial XP/state fixture or arbitrarydamage command.','Half of CDR-adjusted full duration reduction tested; original Riot arithmetic/rounding/late projectile overlap still requires historical runtime qualification.','Clip/particle/audio/passive/physicalinput/fullAnnie and full24domain scope incomplete.']};(r/'docs/annie_q_refund_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(checks),'ordinary2clientUDP Q refund checks',flush=True)
finally:
 for c in clients:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
