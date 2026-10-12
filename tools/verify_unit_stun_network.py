from pathlib import Path
import subprocess,os,json,socket,time,sys,hashlib,datetime
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',5972);clients=[];ids=[];names=['annie','garen'];seq=[0,0];server=None;checks=[];heartbeat=0
def send(i,p):clients[i].sendto(json.dumps(p).encode(),addr)
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
def pet(s):return next((u for u in s['units'] if u.get('pet') and u['pet']['owner']==ids[0]),None)
def wait(pred,timeout=8):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  s=receive(0)
  if pred(s):return s
 raise AssertionError('State predicate timeout')
try:
 with (r/'logs/unit-stuns-network-server.log').open('w',encoding='utf-8') as log:
  binary=r/'target/debug/examples/unit_stun_fixture.exe';server=subprocess.Popen([str(binary)],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5972'),stdout=log,stderr=log,creationflags=0x08000000)
  for i in range(2):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+12
   while True:
    send(i,{'Join':{'champion':names[i]}})
    try:ids.append(receive(i,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<end
  command(0,{'Learn':{'slot':3}});state=wait(lambda s:actor(s,0)['ranks'][3]==1);point=actor(state,0)['position'];command(0,{'CastAt':{'slot':3,'point':point}});state=wait(lambda s:pet(s) is not None and pet(s)['stuns']);u=pet(state);expires=u['stuns'][0]['expires_at'];assert u['stuns'][0]['tag']=='diagnostic_npc_stun' and u['stuns'][0]['source'] is None and expires-u['pet']['spawned']==60;checks.append('NPC_stun_state_replicated')
  command(0,{'GrantStun':{'target':u['id'],'duration':30}});assert receive(0,'Rejected')['reason']=='malformed or unsupported packet';checks.append('arbitrary_client_stun_authority_rejected')
  before=u['position'];hp=actor(state,1)['health'];command(0,{'CastAt':{'slot':3,'point':{'x':point['x']-300,'z':point['z']}}});state=wait(lambda s:isinstance(pet(s)['pet']['order'],dict) and 'Move' in pet(s)['pet']['order']);assert pet(state)['position']==before;checks.append('owner_guide_queued_while_pet_stunned')
  state=wait(lambda s:s['tick']>=expires-10);assert state['tick']<expires and pet(state)['position']==before and pet(state)['next_attack']==0;checks.append('stun_pauses_pet_movement_and_attack')
  assert actor(state,1)['health']<hp;checks.append('pet_aura_continues_during_stun')
  state=wait(lambda s:s['tick']>=expires+3);assert pet(state)['stuns']==[] and pet(state)['position']!=before;checks.append('stun_expires_and_queued_movement_resumes')
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':len(checks),'check_names':checks,'fixture_sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'fixture_source_sha256':hashlib.sha256((r/'crates/server/examples/unit_stun_fixture.rs').read_bytes()).hexdigest(),'expires':expires,'pet_id':u['id'],'limits':['Separate diagnostic fixture seeds level6/positions and emits60tick NPC stun after summon. This does not prove an ordinary champion spell stun producer or original Riot semantics.','Real2clientUDP verifies snapshot control/order/aura/movement timing and rejects arbitrary GrantStun packet.','Boss immunity/tenacity/cleanse/status priorities/passive stun/actual animation/input/audio and full24domains unfinished.']};(r/'docs/unit_stuns_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(checks),'diagnostic2clientUDP NPC stun checks',flush=True)
finally:
 for c in clients:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
