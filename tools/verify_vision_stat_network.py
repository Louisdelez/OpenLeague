"""Validate new native radius state on ordinary server UDP snapshots."""
from pathlib import Path
import os,json,socket,subprocess,time,hashlib
import wire
r=Path(__file__).resolve().parents[1];probe=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);probe.bind(('127.0.0.1',0));addr=probe.getsockname();probe.close()
clients=[];process=None;checks=0
def receive(c,kind,timeout=2):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  try:p=wire.packet(c)
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('missing '+kind)
def send(c,p):c.sendto(json.dumps(p).encode(),addr)
try:
 with (r/'logs/vision-stat-network-server.log').open('w') as log:
  process=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER=f'{addr[0]}:{addr[1]}'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
  ids=[]
  for _ in range(2):
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c);deadline=time.monotonic()+10
   while True:
    assert process.poll() is None
    send(c,{'Join':{'champion':'garen'}})
    try:ids.append(receive(c,'Welcome',.5)['player']);break
    except AssertionError:assert time.monotonic()<deadline
  observed=[]
  for i,c in enumerate(clients):
   deadline=time.monotonic()+5
   while True:
    state=receive(c,'State')
    if len(state['roster'])==2:break
    assert time.monotonic()<deadline
   assert {p['id'] for p in state['roster']}==set(ids);checks+=1
   assert {p['id'] for p in state['players']}=={ids[i]};checks+=1
   values=state['players'][0]['vision_radius_modifiers'];assert values=={'flat_bubble_radius_mod':0.,'percent_bubble_radius_mod':0.};checks+=1
   observed.append(dict(player=ids[i],modifiers=values,visible_players=[p['id'] for p in state['players']],tick=state['tick']))
   send(c,{'Command':{'sequence':1,'action':{'Attack':{'target':ids[1-i]}}}});assert 'visible' in receive(c,'Rejected')['reason'];checks+=1
  receipt=dict(passed=True,checks=checks,server_sha256=hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),observed=observed,limits=['Ordinary server UDP snapshots validate zero defaults and hidden enemy state; modified radius effect is separately checked in actual simulation tests, not through network buff commands.','Native original LoL protocol, complete abilities/buff producers and graphical fog remain open.'])
  (r/'docs/vision_stat_network_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');print(json.dumps(receipt))
finally:
 for c in clients:c.close()
 if process is not None and process.poll() is None:
  process.terminate()
  try:process.wait(timeout=10)
  except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
