"""Actual UDP recast/sequence/cooldown replication; damage tested by core fixture."""
import wire,json,socket,subprocess,time,os,hashlib,datetime
from pathlib import Path
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5913)
client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);client.bind(('127.0.0.1',0));client.settimeout(.2);process=None
exe=root/'target/debug/openleague-server.exe'
def send(message):client.sendto(json.dumps(message).encode(),address)
def receive(kind,timeout=4):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  try: packet=wire.packet(client)
  except (socket.timeout,ConnectionResetError):continue
  if packet and kind in packet:return packet[kind]
 raise AssertionError('No packet '+kind)
def command(seq,action):send({'Command':{'sequence':seq,'action':action}})
def state(predicate):
 end=time.monotonic()+4
 while time.monotonic()<end:
  snapshot=receive('State');p=next(p for p in snapshot['players'] if p['id']==player)
  if predicate(snapshot,p):return snapshot,p
 raise AssertionError('State predicate failed')
try:
 with (root/'logs/garen-cancel-server.log').open('w',encoding='utf-8') as log:
  process=subprocess.Popen([str(exe)],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5913'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
  end=time.monotonic()+15
  while True:
   assert process.poll() is None
   send({'Join':{'champion':'garen'}})
   try:player=receive('Welcome',.5)['player'];break
   except AssertionError:assert time.monotonic()<end
  command(1,{'Learn':{'slot':2}});state(lambda s,p:p['ranks'][2]==1)
  command(2,{'Cast':{'slot':2,'target':None}});started,p=state(lambda s,p:p['effects']['spin_until']>s['tick']);cooldown=p['cooldowns'][2]
  assert p['effects']['spin_rank']==1 and cooldown>started['tick']
  command(3,{'Cast':{'slot':2,'target':None}});cancelled,p=state(lambda s,p:p['effects']['spin_rank']==0)
  assert p['effects']['spin_until']<=cancelled['tick'] and p['effects']['next_spin']==0 and p['cooldowns'][2]==cooldown
  command(4,{'Cast':{'slot':2,'target':None}});assert 'cooldown' in receive('Rejected')['reason']
  command(3,{'Cast':{'slot':2,'target':None}})
  final,p=state(lambda s,p:s['tick']>=cancelled['tick']+6)
  assert p['effects']['spin_rank']==0 and p['cooldowns'][2]==cooldown
  command(5,'Stop');state(lambda s,p:s['tick']>final['tick']);assert process.poll() is None
  checks=['native E rank learned on actual server','first E activates spin with cooldown','second E cancels active spin and clears pending pulse state','recast preserves original cooldown','third E rejected on cooldown','replayed cancellation sequence cannot restart spin','Stop accepted after cancellation and server continues']
  proof={'passed':True,'checks':checks,'server_sha256':hashlib.sha256(exe.read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['One champion at fountain; stopping actual damage verified separately in authoritative core fixture.','Minimum recast delay, silence policy, cooldown refund/order and visual/audio native fidelity unqualified.']}
  (root/'docs/garen_cancel_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':True,'checks':len(checks)}))
finally:
 client.close()
 if process is not None and process.poll() is None:
  process.terminate()
  try:process.wait(timeout=10)
  except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
