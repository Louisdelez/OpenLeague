from pathlib import Path
import os,subprocess,socket,json,time,hashlib,datetime,math
import wire
r=Path(__file__).resolve().parents[1];addr=('127.0.0.1',5930);server=None;c=None;seq=0;samples=[]
def send(p):c.sendto(json.dumps(p).encode(),addr)
def receive(kind='State',timeout=5):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  assert server.poll() is None
  try:p=wire.packet(c)
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('Missing '+kind)
def command(action):
 global seq
 seq+=1;send({'Command':{'sequence':seq,'action':action}})
def wait(predicate):
 end=time.monotonic()+10
 while time.monotonic()<end:
  state=receive();p=next(p for p in state['players'] if p['id']==id)
  if predicate(state,p):samples.append({'tick':state['tick'],'player':p});return state,p
 raise AssertionError('State predicate failed')
try:
 with (r/'logs/caster-item-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5930'),stdout=log,stderr=log,creationflags=0x08000000)
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);end=time.monotonic()+15
  while True:
   send({'Join':{'champion':'garen'}})
   try:id=receive('Welcome',.5)['player'];break
   except AssertionError:assert time.monotonic()<end
  wait(lambda s,p:p['gold']==825)
  command({'Buy':{'item':1052}});wait(lambda s,p:p['gold']==390 and p['inventory'][0]==1052)
  command({'Buy':{'item':3108}});wait(lambda s,p:p['gold']==5 and p['inventory'][0]==3108 and sum(x is not None for x in p['inventory'])==1)
  command({'Buy':{'item':1058}});assert receive('Rejected')['reason']=='insufficient gold'
  command({'Learn':{'slot':0}});wait(lambda s,p:p['ranks'][0]==1)
  rows=json.loads((r/'data/4.20/native_spells_420.json').read_text(encoding='utf-8'));row=next(x for x in rows if x['champion'].lower()=='garen' and x['slot']==0);v=row['values'];base=float(v['Cooldown1']);speed=float(v['Effect5Level1Amount']);speed_ticks=math.ceil(speed*30)
  command({'Cast':{'slot':0,'target':None}});state,p=wait(lambda s,p:p['cooldowns'][0]>0);cast=p['effects']['speed_until']-speed_ticks;ready=p['cooldowns'][0];assert ready-cast==math.ceil(base*.9*30),(base,ready,cast)
  command({'Cast':{'slot':0,'target':None}});assert receive('Rejected')['reason']=='skill on cooldown'
  command({'Sell':{'slot':0}});state,p=wait(lambda s,p:p['inventory'][0] is None and p['gold']==579);assert p['cooldowns'][0]==ready
  state,p=wait(lambda s,p:s['tick']>=ready);command({'Cast':{'slot':0,'target':None}});state,p=wait(lambda s,p:p['cooldowns'][0]>ready);second=p['effects']['speed_until']-speed_ticks;assert p['cooldowns'][0]-second==math.ceil(base*30)
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':7,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'port':5930,'initial_gold':825,'recipe_final_gold':5,'sell_gold':579,'native_base_cooldown_seconds':base,'reduced_ticks':ready-cast,'base_ticks':p['cooldowns'][0]-second,'samples':samples,'limits':['Actual UDP purchase/recipe/error/cast/cooldown/sale tested without injection. Power numerical application, cap and multiitem uniqueness tested in core. Original server policies and all remaininggameplay not qualified.']}
  (r/'docs/caster_item_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS seven networkchecks, reduced',ready-cast,'base',p['cooldowns'][0]-second,flush=True)
finally:
 if c is not None:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
