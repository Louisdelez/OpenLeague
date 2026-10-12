"""Observe native wave/camp timers on a real 30 Hz server without clock injection."""
import json, socket, subprocess, time, os, hashlib
from pathlib import Path
import wire
root=Path(__file__).resolve().parents[1]
address=('127.0.0.1',5899)
client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
client.bind(('127.0.0.1',0));client.settimeout(.2)
process=None
try:
 with (root/'logs/world-server.log').open('w') as log:
  process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5899'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
  deadline=time.monotonic()+125;heartbeat=0;observations={};initial_positions={};max_units=0
  while time.monotonic()<deadline:
   assert process.poll() is None,'World server stopped'
   if time.monotonic()>=heartbeat:
    client.sendto(json.dumps({'Join':{'champion':'garen'}}).encode(),address);heartbeat=time.monotonic()+2
   try:packet=wire.packet(client)
   except (socket.timeout,ConnectionResetError):continue
   if not packet or 'State' not in packet:continue
   state=packet['State'];tick=state['tick'];units=state['units'];max_units=max(max_units,len(units))
   lane=[u for u in units if u['kind'] in ['Melee','Caster','Siege','Super']]
   camps=[u for u in units if u['kind']=='Monster']
   if 'structures' not in observations:
    assert len(units)==18,'Initial map must have 18 structures'
    assert len({u['id'] for u in units+state['players']})==len(units)+len(state['players'])
    observations['structures']={'tick':tick,'count':18}
   if tick<2250:assert not lane,'Wave spawned before native 75 seconds'
   if lane and 'first_wave' not in observations:
    assert 2250<=tick<2280
    observations['first_wave']={'tick':tick,'count':len(lane)}
    print('Native first wave observed at tick',tick,flush=True)
   if 2370<=tick<2600 and 'full_wave' not in observations:
    assert len(lane)==24,'First wave must contain 24 units across both teams and lanes'
    assert sum(u['kind']=='Melee' for u in lane)==12
    assert sum(u['kind']=='Caster' for u in lane)==12
    initial_positions={u['id']:u['position'] for u in lane}
    observations['full_wave']={'tick':tick,'count':24}
   if initial_positions and tick>=2700 and 'movement' not in observations:
    moved=sum(u['position']!=initial_positions.get(u['id']) for u in lane if u['id'] in initial_positions)
    assert moved>0,'Lane AI did not advance'
    observations['movement']={'tick':tick,'moving_units':moved}
   if tick<3000:assert not camps,'Normal camps spawned before scheduled 100 seconds'
   if camps:
    assert len(camps)==16,'Expected all 16 normal monsters from the six camps'
    assert not any(u['kind']=='Boss' for u in units),'Boss must wait until 600 seconds'
    observations['camps']={'tick':tick,'count':16};break
  assert set(observations)=={'structures','first_wave','full_wave','movement','camps'},observations
  result={'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'passed':True,'checks':7,'observations':observations,'max_units':max_units,'transport':'Actual fragmented UDP snapshots decoded; simulation clock never changed','limits':['Basic NPC AI only; complete native target priorities, collision and boss mechanics remain incomplete.','Camp timer qualification uses decoded community engine timing; native delay anchor remains to verify.']}
  (root/'docs/world_network_validation.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
  print(json.dumps(result),flush=True)
finally:
 client.close()
 if process is not None and process.poll() is None:
  process.terminate()
  try:process.wait(timeout=10)
  except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
