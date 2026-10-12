from pathlib import Path
import json,socket,subprocess,os,time,sys,hashlib,datetime,select
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',16051);prefix=r/'logs/normal-structure-combat';probe=prefix.with_suffix('.jsonl');png=prefix.with_suffix('.png');peers=[];ids=[];seq=[];server=client=None
join={'Join':{'champion':'garen','summoners':['Heal',None]}}
def command(i,action):
 seq[i]+=1;peers[i].sendto(json.dumps({'Command':{'sequence':seq[i],'action':action}}).encode(),addr)
try:
 for p in [probe,png,prefix.with_suffix('.server.log'),prefix.with_suffix('.client.log')]:assert not p.exists(),p
 check=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);check.bind(addr);check.close()
 with prefix.with_suffix('.server.log').open('w',encoding='utf-8') as sl,prefix.with_suffix('.client.log').open('w',encoding='utf-8') as cl:
  env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:16051')
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=env,stdout=sl,stderr=sl,creationflags=0x08000000)
  for i in range(5):
   p=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);p.bind(('127.0.0.1',0));p.settimeout(.1);peers.append(p);seq.append(0);deadline=time.monotonic()+15
   while True:
    for peer in peers:peer.sendto(json.dumps(join).encode(),addr)
    try:packet=wire.packet(p)
    except (socket.timeout,ConnectionResetError):packet=None
    if packet and 'Welcome' in packet:ids.append(packet['Welcome']['player']);break
    assert time.monotonic()<deadline,'join timeout'
  state=None
  while state is None:
   try:packet=wire.packet(peers[0]);state=packet['State'] if packet and 'State' in packet else None
   except (socket.timeout,ConnectionResetError):pass
  # Authored outer enemy tower; dependencies and HP remain untouched.
  world=json.loads((r/'data/4.20/map10_world.json').read_text(encoding='utf-8'))
  rule=next(s for s in world['structures'] if s['team']==1 and s['name']=='Turret_T2_L_02')
  point=rule['position'];height=rule['height'];target=None;initial=None;observations=[];rejections={};snapshots={};setup=set();last_action={};heartbeat=0;last_progress=0;start=time.monotonic()
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=dict(env,OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(png),OPENLEAGUE_SCREENSHOT_DELAY='180',OPENLEAGUE_RENDER_FOCUS=f"{point['x']/20},{height/20},{point['z']/20}",OPENLEAGUE_DESTRUCTION_ANIMATION_PROBE=str(probe),RUST_LOG='warn'),stdout=cl,stderr=cl,creationflags=0x08000000)
  print(json.dumps(dict(server_pid=server.pid,client_pid=client.pid,target=rule['name'],position=point,control_players=ids)),flush=True)
  deadline=time.monotonic()+300;destroyed=False
  while time.monotonic()<deadline:
   assert server.poll() is None and client.poll() is None,'normal runtime stopped'
   now=time.monotonic()
   if now>=heartbeat:
    for p in peers:p.sendto(json.dumps(join).encode(),addr)
    heartbeat=now+1
   ready,_,_=select.select(peers,[],[],.05)
   for p in ready:
    i=peers.index(p)
    try:packet=wire.packet(p)
    except (socket.timeout,ConnectionResetError):continue
    if not packet:continue
    if 'Rejected' in packet:
     reason=packet['Rejected']['reason'];rejections[reason]=rejections.get(reason,0)+1;continue
    if 'State' not in packet:continue
    s=packet['State'];snapshots[i]=s
    unit=next((u for u in s['units'] if u['name']==rule['name']),None)
    if unit:
     target=unit['id'];initial=unit['max_health'] if initial is None else initial
     if not observations or unit['health']!=observations[-1]['health']:observations.append(dict(tick=s['tick'],health=unit['health'],roster=len(s['roster'])))
     if unit['health']<=0:destroyed=True
    if i not in [0,2,4]:continue
    actor=next((p for p in s['players'] if p['id']==ids[i]),None)
    if not actor:continue
    if i not in setup:
     command(i,{'Buy':{'item':1028}});command(i,{'Buy':{'item':1036}});command(i,{'Learn':{'slot':0}});setup.add(i)
    if actor['health']<=0:continue
    if actor['health']<actor['max_health']*.5 and now-last_action.get((i,'heal'),0)>5:
     command(i,{'Summoner':{'slot':0}});last_action[(i,'heal')]=now
    if not destroyed and now-last_action.get((i,'order'),0)>2:
     if unit and unit['health']>0:command(i,{'Attack':{'target':unit['id']}})
     else:command(i,{'Move':{'point':point}})
     last_action[(i,'order')]=now
   if now-last_progress>30:
    print(json.dumps(dict(seconds=round(now-start),last=observations[-1] if observations else None,attacker_health={str(i):next((p['health'] for p in s['players'] if p['id']==ids[i]),None) for i,s in snapshots.items() if i in [0,2,4]})),flush=True);last_progress=now
   if destroyed and png.exists() and png.stat().st_size>10000:break
  sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
  receipt=dict(checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,diagnostic_fixture=False,normal_server=True,target_name=rule['name'],target_id=target,initial_health=initial,destruction_observed=destroyed,health_history=observations,rejections=rejections,control_players=ids,elapsed_seconds=time.monotonic()-start,client_sha256=sha(r/'target/debug/openleague-client.exe'),server_sha256=sha(r/'target/debug/openleague-server.exe'),capture=str(png) if png.exists() else None,limits=['Only ordinary Join/Buy/Learn/Move/Attack/Heal packets used; no simulation clock, stats, position or health injection. Fixed camera and animation observation are diagnostic display settings.','Five UDP controls plus one graphical player; this is not a complete six-client match/victory/results qualification.','Existing server executable reused; source build consistency not qualified here. Native LoL destruction behavior/material/event fidelity remain unqualified.'])
  if png.exists():receipt['capture_sha256']=sha(png)
  (r/'docs/normal_structure_combat_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
  print(json.dumps(dict(destruction_observed=destroyed,health_changes=len(observations),capture=receipt['capture'])),flush=True)
finally:
 for p in peers:p.close()
 for process in [client,server]:
  if process and process.poll() is None:
   process.terminate()
   try:process.wait(timeout=10)
   except subprocess.TimeoutExpired:process.kill();process.wait(timeout=5)
