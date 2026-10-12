"""Real tower damage/death/respawn over UDP, without injected combat state."""
import json,socket,subprocess,time,os,math
from pathlib import Path
import wire
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5900)
c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.2);process=None
try:
 with (root/'logs/respawn-server.log').open('w') as log:
  process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5900'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
  deadline=time.monotonic()+150;heartbeat=0;player_id=None;spawn=None;death=None;blocked=False;sent=False;result=None
  while time.monotonic()<deadline:
   assert process.poll() is None,'Server stopped'
   if time.monotonic()>=heartbeat:c.sendto(json.dumps({'Join':{'champion':'garen'}}).encode(),address);heartbeat=time.monotonic()+2
   try:packet=wire.packet(c)
   except (socket.timeout,ConnectionResetError):continue
   if not packet:continue
   if 'Welcome' in packet:player_id=packet['Welcome']['player']
   if 'Rejected' in packet and 'dead' in packet['Rejected']['reason']:blocked=True
   if 'State' not in packet or player_id is None:continue
   state=packet['State'];p=next(p for p in state['players'] if p['id']==player_id)
   if not sent:
    spawn=p['position'];enemy=next(u for u in state['units'] if u['kind']=='Fountain' and u['team']!=p['team'])
    c.sendto(json.dumps({'Command':{'sequence':1,'action':{'Move':{'point':enemy['position']}}}}).encode(),address);sent=True
   if p['health']<=0 and death is None:
    assert p['respawn_at'] is not None
    death={'observed_tick':state['tick'],'respawn_at':p['respawn_at'],'position':p['position']}
    c.sendto(json.dumps({'Command':{'sequence':2,'action':'Stop'}}).encode(),address)
    print('Actual champion death observed',death,flush=True)
   if death is not None and p['health']>0:
    assert state['tick']>=death['respawn_at'];assert blocked,'Dead command was not rejected'
    assert math.hypot(p['position']['x']-spawn['x'],p['position']['z']-spawn['z'])<1
    assert p['health']==p['max_health'] and p['respawn_at'] is None
    result={'passed':True,'checks':4,'death':death,'respawn_tick':state['tick'],'health':p['health'],'limits':'Early-match baseline timer only; native scaling and champion revival passives not qualified.'};break
  assert result is not None,'No real tower death and respawn within timeout'
  (root/'docs/respawn_network_validation.json').write_text(json.dumps(result,indent=2),encoding='utf-8');print(json.dumps(result),flush=True)
finally:
 c.close()
 if process is not None and process.poll() is None:
  process.terminate()
  try:process.wait(timeout=10)
  except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
