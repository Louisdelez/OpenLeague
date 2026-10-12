from pathlib import Path
import os,subprocess,socket,json,struct,time,math,hashlib,datetime,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',5950);clients=[];ids=[];seq=[0,0];server=None;heartbeat=0;names=['annie','garen'];samples=[];checks=[]
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
def wait(i,predicate,timeout=6):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  s=receive(i)
  if predicate(s):return s
 raise AssertionError('State predicate timed out')
try:
 with (r/'logs/annie-e-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5950'),stdout=log,stderr=log,creationflags=0x08000000)
  for i in range(2):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);end=time.monotonic()+15
   while True:
    send(i,{'Join':{'champion':names[i]}})
    try:ids.append(receive(i,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<end
  command(0,{'Buy':{'item':1052}});wait(0,lambda s:actor(s,0)['inventory'][0]==1052 and actor(s,0)['gold']==390);checks.append('native20AP_tome_purchase')
  command(0,{'Learn':{'slot':2}});wait(0,lambda s:actor(s,0)['ranks'][2]==1);checks.append('ordinary_E_rank_learning')
  meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0];center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
  for i in range(2):command(i,{'Move':{'point':center}})
  state=wait(0,lambda s:len(s['players'])==2 and all(math.hypot(actor(s,i)['position']['x']-center['x'],actor(s,i)['position']['z']-center['z'])<10 for i in range(2)),75)
  for i in range(2):command(i,'Stop')
  mana=actor(state,0)['mana'];command(0,{'Cast':{'slot':2,'target':None}});state=wait(0,lambda s:actor(s,0)['effects']['molten_until']>0);p=actor(state,0);expires=p['effects']['molten_until'];cast=expires-150;assert abs(p['mana']-(mana-20))<.5;assert p['effects']['molten_rank']==1;checks.append('native20mana150tick_buff')
  assert p['cooldowns'][2]-cast==300;checks.append('native300tick_cooldown')
  command(0,{'Cast':{'slot':2,'target':None}});assert receive(0,'Rejected')['reason']=='skill on cooldown';checks.append('repeat_E_rejected')
  command(1,{'Attack':{'target':ids[0]}})
  growth=json.loads((r/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'))['garen'];defs=json.loads((r/'data/4.20/champions.json').read_text(encoding='utf-8'));definition=next(d for d in defs if d['id']=='garen') if isinstance(defs,list) else defs['garen'];mr=definition['magic_resist'];expected=(20+20*.2)*100/(100+mr);previous=None;hits=[];post_expiry_losses=[]
  while state['tick']<expires+65:
   a=actor(state,0);g=actor(state,1);samples.append({'tick':state['tick'],'annie_hp':a['health'],'garen_hp':g['health'],'molten_until':a['effects']['molten_until']})
   if previous is not None:
    dt=state['tick']-previous[0];drop=previous[1]-g['health']
    if drop>1:
     assert previous[0]<expires,'retaliation after expiry';assert abs(drop-expected)<.5,(drop,expected,dt);hits.append({'tick':state['tick'],'drop':drop,'expected':expected})
    if previous[0]>=expires+5:post_expiry_losses.append(drop);assert drop<=.01
   previous=(state['tick'],g['health']);state=receive(0)
  assert len(hits)>=2;checks.append('native24raw_magical_retaliation_multiple_basic_hits')
  assert post_expiry_losses;checks.append('retaliation_stops_at_buff_expiry')
  tail=[s for s in samples if s['tick']>=expires+5];assert tail[-1]['annie_hp']<tail[0]['annie_hp'];checks.append('enemy_attacks_continue_after_expiry')
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':len(checks),'check_names':checks,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'cast_tick':cast,'expires_at':expires,'native_retaliation_raw':24,'expected_mitigated_return':expected,'observed_returns':hits,'samples':samples,'limits':['Actual two-client ordinary purchase/learn/cast/attack UDP checks; no state injection. Armor/MR numerical bonuses and monster/tower/zero/death/modifier policies covered in core, not all network scenarios. Passive/W/R/Tibbers/VFX/audio and original server event order incomplete.']};(r/'docs/annie_e_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(checks),'UDP E checks; observed',len(hits),'ripostes',flush=True)
finally:
 for c in clients:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
