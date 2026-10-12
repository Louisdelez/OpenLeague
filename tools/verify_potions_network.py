from pathlib import Path
import os,subprocess,socket,json,struct,time,math,hashlib,datetime
import wire
r=Path(__file__).resolve().parents[1];address=('127.0.0.1',5938);clients=[];ids=[];seq=[0,0];server=None;heartbeat=0;samples=[];checks=[]
def send(i,p):clients[i].sendto(json.dumps(p).encode(),address)
def command(i,a):seq[i]+=1;send(i,{'Command':{'sequence':seq[i],'action':a}})
def receive(i,kind='State',timeout=5):
 global heartbeat
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  assert server.poll() is None
  if len(ids)==2 and time.monotonic()>heartbeat:
   for n in range(2):send(n,{'Join':{'champion':'garen'}})
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
 with (r/'logs/potion-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5938'),stdout=log,stderr=log,creationflags=0x08000000)
  for i in range(2):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+15
   while True:
    send(i,{'Join':{'champion':'garen','summoners':['Ignite',None] if i==0 else [None,None]}})
    try:ids.append(receive(i,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<end
  for count in range(1,6):
   command(1,{'Buy':{'item':2003}});wait(1,lambda s:actor(s,1)['inventory_counts'][0]==count and actor(s,1)['gold']==825-count*35)
  checks.append('fivepotionstack/native35price')
  command(1,{'Buy':{'item':2003}});assert receive(1,'Rejected')['reason']=='item stack limit reached';checks.append('sixthpurchase_rejected')
  command(1,{'UseItem':{'slot':0}});assert receive(1,'Rejected')['reason']=='health already full';checks.append('fullhealthuse_rejected')
  command(1,{'Buy':{'item':2004}});wait(1,lambda s:actor(s,1)['inventory'][1]==2004 and actor(s,1)['gold']==615)
  command(1,{'UseItem':{'slot':1}});assert receive(1,'Rejected')['reason']=='champion does not use mana';checks.append('Garenmanapotion_rejected')
  meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0];center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
  for i in range(2):command(i,{'Move':{'point':center}})
  state=wait(1,lambda s:len(s['players'])==2 and all(math.hypot(actor(s,i)['position']['x']-center['x'],actor(s,i)['position']['z']-center['z'])<10 for i in range(2)),75)
  for i in range(2):command(i,'Stop')
  before=actor(state,1)['health'];assert before==actor(state,1)['max_health'];regen=json.loads((r/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'))['garen']['health_regen']
  command(0,{'SummonerTarget':{'slot':0,'target':ids[1]}});state=wait(1,lambda s:actor(s,1)['effects'].get('ignite') is not None);cast=actor(state,1)['effects']['ignite']['expires_at']-150
  command(1,{'UseItem':{'slot':0}});state=wait(1,lambda s:actor(s,1)['effects']['health_potion_ticks']>0);p=actor(state,1);use=state['tick']-(450-p['effects']['health_potion_ticks']);assert p['inventory_counts'][0]==4 and p['inventory_counts'][1]==1;checks.append('consumption_count_and450tick_timer')
  errors=[];seen_half=False;seen_full=False
  while state['tick']<cast+212:
   p=actor(state,1);elapsed=state['tick']-cast;hits=min(5,1+elapsed//30);delivered=max(0,state['tick']-use);half=max(0,min(state['tick'],cast+149)-use);full=delivered-half
   expected=min(p['max_health'],before-hits*14+regen*(min(elapsed,149)*.5+max(0,elapsed-149))/30+10*(half*.5+full)/30)
   error=abs(p['health']-expected);errors.append(error);assert error<.04,(state['tick'],p['health'],expected,error);assert p['effects']['health_potion_ticks']==450-delivered
   seen_half|=elapsed<149;seen_full|=elapsed>180;samples.append({'tick':state['tick'],'health':p['health'],'expected':expected,'potion_remaining':p['effects']['health_potion_ticks']});state=receive(1)
  assert seen_half and seen_full;checks.extend(['half_potion_healing_duringIgnite','normal_potion_healing_afterIgnite','continuous_remaining_timer'])
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':len(checks),'check_names':checks,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'cast_tick':cast,'potion_use_tick':use,'max_health_trajectory_error':max(errors),'samples':samples,'limits':['Actual two-client UDP5-stack/UseItem/price/limits/rejections/timers and healthrestoration under/afterIgnite verified with ordinarycommands; no state injection.','Full450updatehealth/mana/queued/death tests in core. Networkmana-restoration not exercised because mana-spending championkits remain missing. Physical keyboard/click and VFX/audio fidelity unqualified. Fullgame incomplete.']};(r/'docs/potion_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(checks),'checks; maxhealtherror',max(errors),flush=True)
finally:
 for c in clients:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
