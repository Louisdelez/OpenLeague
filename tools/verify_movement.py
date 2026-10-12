"""Measure authoritative Q+boots walking and Q expiry on a straight native-grid corridor."""
import json,socket,subprocess,time,os,struct,math,hashlib,datetime
from pathlib import Path
import wire
r=Path(__file__).resolve().parents[1];address=('127.0.0.1',5911);c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.15);process=None

def send(m):c.sendto(json.dumps(m).encode(),address)
def receive(kind,timeout=4):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  try:p=wire.packet(c)
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('No '+kind)
def cmd(sequence,action):send({'Command':{'sequence':sequence,'action':action}})
def distance(a,b):return math.hypot(a['x']-b['x'],a['z']-b['z'])
try:
 with (r/'logs/movement-server.log').open('w') as log:
  exe=r/'target/debug/openleague-server.exe';process=subprocess.Popen([str(exe)],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5911'),stdout=log,stderr=log,creationflags=0x08000000)
  deadline=time.monotonic()+15
  while True:
   send({'Join':{'champion':'garen'}})
   try:id=receive('Welcome',.5)['player'];break
   except AssertionError:assert time.monotonic()<deadline
  def state():
   s=receive('State');return s,next(p for p in s['players'] if p['id']==id)
  s,p=state();home=p['position'];cmd(1,{'Buy':{'item':1001}});cmd(2,{'Learn':{'slot':0}})
  while p['inventory'][0]!=1001 or p['ranks'][0]!=1:s,p=state()
  assert p['gold']==500,'Boots price/start balance mismatch'
  meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();w=meta['width'];h=meta['height'];runs=[]
  def point(x,z):return {'x':meta['min'][0]+(x+.5)*meta['cellSize'],'z':meta['min'][2]+(z+.5)*meta['cellSize']}
  for z in range(h):
   length=0
   for x in range(w):
    length=length+1 if struct.unpack_from('<H',cells,(z*w+x)*11+4)[0]&2==0 else 0
    if length>=24:
     a,b=point(x-23,z),point(x,z)
     runs.extend([(distance(home,a),a,b),(distance(home,b),b,a)])
  assert runs,'No native straight corridor found'
  _,start,goal=min(runs,key=lambda v:v[0]);cmd(3,{'Move':{'point':start}})
  deadline=time.monotonic()+65;heartbeat=0
  while distance(p['position'],start)>.01 or p['destination'] is not None:
   if time.monotonic()>heartbeat:send({'Join':{'champion':'garen'}});heartbeat=time.monotonic()+2
   s,p=state();assert time.monotonic()<deadline,'Failed to reach corridor start'
  cmd(4,{'Cast':{'slot':0,'target':None}});cmd(5,{'Move':{'point':goal}})
  samples=[];deadline=time.monotonic()+6;expiry=None
  while True:
   s,p=state()
   if p['effects']['speed_until']>0:
    expiry=p['effects']['speed_until'];samples.append({'tick':s['tick'],'position':p['position'],'destination':p['destination']})
   if expiry and s['tick']>=expiry+18:break
   assert time.monotonic()<deadline,'No movement/Q expiry measurement'
  active=[v for v in samples if v['destination'] is not None and v['tick']<expiry-3]
  expired=[v for v in samples if v['destination'] is not None and v['tick']>=expiry+3]
  assert len(active)>=5 and len(expired)>=4,'Insufficient constant-speed samples'
  def speed(values):return distance(values[0]['position'],values[-1]['position'])*30/(values[-1]['tick']-values[0]['tick'])
  q_speed=speed(active);base_speed=speed(expired)
  assert abs(q_speed-479.75)<.02,('Q + boots speed mismatch',q_speed)
  assert abs(base_speed-370.)<.02,('Expired Q speed mismatch',base_speed)
  cmd(6,'Stop')
  proof={'passed':True,'checks':['native starting balance buys boots and learns Q without injected stats','server routes champion to a native straight corridor','Q plus boots measured at post-bonus soft-capped speed','expired Q restores native base plus boots speed while order continues'],'measured_q_speed':q_speed,'expected_q_speed':479.75,'measured_expired_speed':base_speed,'expected_expired_speed':370.,'q_expires_at':expiry,'samples':samples,'corridor_start':start,'corridor_goal':goal,'server_sha256':hashlib.sha256(exe.read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Validates current reconstructed soft-cap interpretation on native grid, not original Riot runtime equivalence.','No slow/resistance, collisions, dash/blink/forced movement or full navigation qualification.']}
  (r/'docs/movement_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':True,'checks':len(proof['checks']),'q_speed':q_speed,'expired_speed':base_speed}))
finally:
 c.close()
 if process and process.poll() is None:process.terminate();process.wait(timeout=10)
