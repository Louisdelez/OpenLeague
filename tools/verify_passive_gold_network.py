"""Real local UDP ambient-gold boundaries, including a late join."""
from pathlib import Path
import os,subprocess,socket,json,time,hashlib,datetime
import wire
r=Path(__file__).resolve().parents[1];address=('127.0.0.1',5928);clients=[];ids=[];server=None;samples=[];late_samples=[];heartbeat=0

def send(i):clients[i].sendto(json.dumps({'Join':{'champion':'garen'}}).encode(),address)
def receive(i,kind='State',timeout=5):
 global heartbeat
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  assert server.poll() is None,'Server exited'
  if time.monotonic()>heartbeat:
   for n in range(len(clients)):send(n)
   heartbeat=time.monotonic()+2
  try:p=wire.packet(clients[i])
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('No '+kind)
def join():
 i=len(clients);c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c)
 end=time.monotonic()+15
 while True:
  send(i)
  try:ids.append(receive(i,'Welcome',.5)['player']);return i
  except AssertionError:assert time.monotonic()<end
try:
 with (r/'logs/passive-gold-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5928'),stdout=log,stderr=log,creationflags=0x08000000)
  join();late=False;seen=set();late_seen=set();deadline=time.monotonic()+95
  while True:
   state=receive(0);tick=state['tick'];p=next(p for p in state['players'] if p['id']==ids[0]);expected=825+8*(0 if tick<2250 else 1+(tick-2250)//150)
   assert p['gold']==expected,(tick,p['gold'],expected);assert state['winner'] is None
   if p['gold'] not in seen:
    seen.add(p['gold']);print('tick',tick,'gold',p['gold'],flush=True)
   samples.append({'tick':tick,'gold':p['gold']})
   if tick>=2290 and not late:
    join();late=True
   if late:
    own=receive(1);own_tick=own['tick'];p=next(p for p in own['players'] if p['id']==ids[1]);assert p['gold']==825+8*(0 if own_tick<2400 else 1+(own_tick-2400)//150)
    late_seen.add(p['gold']);late_samples.append({'tick':own_tick,'gold':p['gold']})
   if tick>=2410 and 833 in late_seen:break
   assert time.monotonic()<deadline,'Timed out'
  assert {825,833,841}.issubset(seen)
  assert {825,833}.issubset(late_seen)
  result={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':4,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'port':5928,'samples':samples,'late_join_samples':late_samples,'late_join_player':ids[1],'last_tick':tick,'limits':['Payment boundaries reconstructed, not original server timing proof. Dead player behavior tested in core, not this UDP scenario. Full game remains incomplete.']}
  (r/'docs/passive_gold_network_validation.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
  print('PASS: initial gold, no early payments, two global payments, late join without backfill',flush=True)
finally:
 for c in clients:c.close()
 if server is not None:
  server.terminate();server.wait(timeout=10)
