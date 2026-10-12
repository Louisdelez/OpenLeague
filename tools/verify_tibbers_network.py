from pathlib import Path
import os,subprocess,socket,json,time,hashlib,datetime,sys,math
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',5964);clients=[];ids=[];seq=[0,0,0];names=['annie','garen','annie'];server=None;heartbeat=0;checks=[]
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
def pet(s):return next((u for u in s['units'] if u.get('pet') and u['pet']['owner']==ids[0]),None)
def wait(predicate,timeout=8):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  s=receive(0)
  if predicate(s):return s
 raise AssertionError('State predicate timed out')
try:
 with (r/'logs/tibbers-network-server.log').open('w',encoding='utf-8') as log:
  binary=r/'target/debug/examples/tibbers_fixture.exe';server=subprocess.Popen([str(binary)],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5964'),stdout=log,stderr=log,creationflags=0x08000000)
  for i in range(3):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+15
   while True:
    send(i,{'Join':{'champion':names[i]}})
    try:ids.append(receive(i,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<end
  state=wait(lambda s:len(s['players'])==3);assert actor(state,0)['level']==6 and actor(state,0)['experience']==2525;checks.append('explicit_level6_initial_fixture')
  command(0,{'Learn':{'slot':3}});state=wait(lambda s:actor(s,0)['ranks'][3]==1);command(0,{'Learn':{'slot':2}});state=wait(lambda s:actor(s,0)['ranks'][2]==1);checks.append('network_skill_learning')
  point=actor(state,1)['position'];mana=actor(state,0)['mana'];hp=actor(state,1)['health'];ally_hp=actor(state,2)['health']
  command(0,{'CastAt':{'slot':3,'point':point}});state=wait(lambda s:actor(s,0)['effects']['annie_r'] is not None);p=actor(state,0);release=p['effects']['annie_r']['releases'];cast=release-8;ready=p['cooldowns'][3];assert ready-cast==3600 and abs(p['mana']-(mana-100))<2.;checks.append('native_R_cost_cooldown_pending')
  command(0,{'CastAt':{'slot':3,'point':point}});assert receive(0,'Rejected')['reason']=='skill blocked during cast';checks.append('duplicate_pending_R_rejected')
  state=wait(lambda s:pet(s) is not None);u=pet(state);pid=u['id'];expires=u['pet']['expires'];assert u['kind']=='Pet' and u['definition']=='annietibbers' and u['max_health']==1200 and u['damage']==80 and u['armor']==30 and u['magic_resist']==30;assert u['pet']['owner']==ids[0] and expires-u['pet']['spawned']==1350;checks.append('native_pet_stats_owner_lifetime_replicated')
  assert actor(state,1)['health']<hp and actor(state,2)['health']==ally_hp;checks.append('summon_damage_enemy_ally_immunity')
  start=state['tick'];state=wait(lambda s:s['tick']>=start+45);assert pet(state)['next_attack']>0 and actor(state,1)['health']<hp-150;checks.append('pet_attack_aura_progress')
  command(0,{'Cast':{'slot':2,'target':None}});state=wait(lambda s:pet(s)['pet']['molten_rank']==1);assert pet(state)['pet']['molten_until']==actor(state,0)['effects']['molten_until'];checks.append('E_forwarding_replicated')
  mana=actor(state,0)['mana'];command(0,{'CastAt':{'slot':3,'point':actor(state,1)['position']}});state=wait(lambda s:isinstance(pet(s)['pet']['order'],dict) and 'Attack' in pet(s)['pet']['order']);assert pet(state)['pet']['order']['Attack']['target']==ids[1] and actor(state,0)['cooldowns'][3]==ready and actor(state,0)['mana']>=mana;checks.append('guide_attack_zero_mana_original_cooldown')
  # Independent player commands move the foe away; pet guide moves only its own pet.
  meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));import struct
  cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0]
  nearest=lambda x:min(points,key=lambda p:math.hypot(p['x']-x,p['z']-point['z']))
  foe_goal=nearest(point['x']+700);pet_goal=nearest(point['x']-500);command(1,{'Move':{'point':foe_goal}});command(0,{'CastAt':{'slot':3,'point':pet_goal}});state=wait(lambda s:isinstance(pet(s)['pet']['order'],dict) and 'Move' in pet(s)['pet']['order']);checks.append('guide_move_replicated')
  before=pet(state)['position'];state=wait(lambda s:math.hypot(pet(s)['position']['x']-before['x'],pet(s)['position']['z']-before['z'])>100);assert actor(state,0)['cooldowns'][3]==ready;checks.append('pet_path_movement_does_not_reset_summon_cooldown')
  state=wait(lambda s:s['tick']>=expires+3,50);assert pet(state) is None or pet(state)['health']==0;assert actor(state,1)['health']>0;assert actor(state,0)['cooldowns'][3]==ready;checks.append('45second_expiry_and_original_cooldown')
  command(0,{'CastAt':{'slot':3,'point':actor(state,0)['position']}});assert receive(0,'Rejected')['reason']=='skill on cooldown';checks.append('expired_pet_cannot_bypass_summon_cooldown')
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':len(checks),'check_names':checks,'fixture_sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'fixture_source_sha256':hashlib.sha256((r/'crates/server/examples/tibbers_fixture.rs').read_bytes()).hexdigest(),'players':3,'pet_id':pid,'release':release,'expires':expires,'ready':ready,'limits':['Separate diagnostic server seeds2525XP/level6 and centre positions at join. This is not ordinary match progression or a production-server gameplay proof.','Real UDP packets exercise learning/summon/control/E/aura/attacks/expiry serialization with no direct pet-damage/state commands; production ClientPacket authority unchanged.','Damage aggregate combines summon/basic/aura/native regen; exact separate damage amounts checked in core fixtures, not isolated here.','Original Riot server fidelity, passive stun, particles/audio, physicalinput and full24domains remain incomplete.']};(r/'docs/tibbers_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(checks),'three-client diagnostic UDP pet checks',flush=True)
finally:
 for c in clients:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
