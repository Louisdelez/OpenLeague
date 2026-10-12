"""Real UDP purchases with native starting gold. No gold/stat/position injection."""
import json,socket,subprocess,time,os,hashlib
from pathlib import Path
import wire
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5906)
exe=root/'target/debug/openleague-server.exe';process=None;clients=[];checks=[];states=[]
def send(c,m):c.sendto(json.dumps(m).encode(),address)
def receive(c,kind,timeout=4):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  try:p=wire.packet(c)
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('Missing '+kind)
def state(c,id,predicate):
 end=time.monotonic()+4;min_tick=(states[-1]['tick']+6) if states else 0
 while time.monotonic()<end:
  s=receive(c,'State');p=next(p for p in s['players'] if p['id']==id)
  if s["tick"]>=min_tick and predicate(p):states.append({'tick':s['tick'],'player':p});return p
 raise AssertionError('State assertion did not converge')
try:
 with (root/'logs/shop-server.log').open('w') as log:
  process=subprocess.Popen([str(exe)],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5906'),stdout=log,stderr=log,creationflags=0x08000000)
  for name in ['garen','ahri']:
   c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.2);clients.append(c)
   end=time.monotonic()+15
   while True:
    assert process.poll() is None
    send(c,{'Join':{'champion':name}})
    try:w=receive(c,'Welcome',.5);break
    except AssertionError:assert time.monotonic()<end
   if name=='garen':blue=w['player']
   else:red=w['player']
  c=clients[0];seq=0
  def command(action):
   global seq
   seq+=1;send(c,{'Command':{'sequence':seq,'action':action}})
  p=state(c,blue,lambda p:p['gold']==825 and p['inventory']==[None]*6);checks.append('native 825 starting gold and six empty slots')
  command({'Buy':{'item':1036}});state(c,blue,lambda p:p['inventory'][0]==1036 and p['gold']==465);checks.append('native long sword costs 360 and replicates')
  command({'Buy':{'item':1036}});state(c,blue,lambda p:p['inventory'][:2]==[1036,1036] and p['gold']==105);checks.append('nonunique component duplicates occupy separate slots')
  command({'Buy':{'item':1036}});assert 'gold' in receive(c,'Rejected')['reason'];state(c,blue,lambda p:p['gold']==105 and p['inventory'][:2]==[1036,1036]);checks.append('unaffordable buy rejected without mutation')
  send(c,{'Command':{'sequence':seq,'action':{'Sell':{'slot':0}}}});state(c,blue,lambda p:p['gold']==105 and p['inventory'][0]==1036);checks.append('replayed sequence cannot sell item')
  command({'SwapItems':{'from':0,'to':5}});state(c,blue,lambda p:p['inventory'][5]==1036 and p['inventory'][0] is None and p['gold']==105);checks.append('slot swap preserves identity and gold')
  command({'Sell':{'slot':5}});state(c,blue,lambda p:p['inventory'][5] is None and p['gold']==357);checks.append('sell refund and removal replicated')
  command({'Sell':{'slot':5}});assert 'empty' in receive(c,'Rejected')['reason'];state(c,blue,lambda p:p['gold']==357);checks.append('repeated sell rejected without double refund')
  command({'Buy':{'item':1057}});assert 'not implemented' in receive(c,'Rejected')['reason'];checks.append('disabled unsupported item explicitly rejected')
  command({'SwapItems':{'from':6,'to':0}});assert 'slot' in receive(c,'Rejected')['reason'];checks.append('invalid inventory slot rejected')
  # Other team uses its own native shop and starting balance.
  c=clients[1];seq=0
  command({'Buy':{'item':1029}});state(c,red,lambda p:p['gold']==525 and p['inventory'][0]==1029)
  command({'Buy':{'item':1031}});state(c,red,lambda p:p['gold']==75 and p['inventory'][0]==1031 and p['inventory'][1] is None);checks.append('purple shop recipe consumes armor and deducts only remaining 450')
  send(c,{'Join':{'champion':'garen'}});receive(c,'Welcome');state(c,red,lambda p:p['gold']==75 and p['inventory'][0]==1031 and p['champion']=='ahri');checks.append('join heartbeat does not reset inventory or gold')
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.2);clients.append(c)
  send(c,{'Join':{'champion':'garen'}});fresh=receive(c,'Welcome')['player'];seq=0
  original=state(c,fresh,lambda p:p['gold']==825);native_hp=original['max_health']
  command({'Buy':{'item':1028}});state(c,fresh,lambda p:p['gold']==425 and abs(p['max_health']-native_hp-150)<.001 and p['inventory'][0]==1028);checks.append('native ruby crystal adds 150 maximum health and costs 400')
  command({'Sell':{'slot':0}});state(c,fresh,lambda p:p['gold']==705 and abs(p['max_health']-native_hp)<.001 and p['health']<=p['max_health']);checks.append('health item sale restores cap and clamps current health')
  command({'Buy':{'item':1001}});state(c,fresh,lambda p:p['gold']==380 and p['inventory'][0]==1001)
  command({'Buy':{'item':1001}});assert 'group' in receive(c,'Rejected')['reason'];state(c,fresh,lambda p:p['gold']==380 and p['inventory'].count(1001)==1);checks.append('native boots limited-to-one restriction enforced without double deduction')
  command({'Buy':{'item':1006}});state(c,fresh,lambda p:p['gold']==200 and p['inventory'][1]==1006);checks.append('native regeneration component purchase replicates')
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.2);clients.append(c)
  send(c,{'Join':{'champion':'garen'}});crafted=receive(c,'Welcome')['player'];seq=0
  command({'Buy':{'item':1028}});state(c,crafted,lambda p:p['gold']==425 and p['inventory'][0]==1028)
  command({'Buy':{'item':1006}});state(c,crafted,lambda p:p['gold']==245 and p['inventory'][1]==1006)
  command({'Buy':{'item':3801}});p=state(c,crafted,lambda p:p['gold']==225 and p['inventory'][0]==3801 and p['inventory'][1] is None and abs(p['max_health']-native_hp-200)<.001);checks.append('native two-component recipe consumes ruby and bead once, costs only 20 and adds final health bonus')
  command({'Sell':{'slot':0}});state(c,crafted,lambda p:p['gold']==645 and p['inventory'][0] is None and abs(p['max_health']-native_hp)<.001);checks.append('crafted item resale uses total recipe price and removes final health bonus')
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.2);clients.append(c)
  send(c,{'Join':{'champion':'garen'}});gloves=receive(c,'Welcome')['player'];seq=0
  command({'Buy':{'item':1051}});state(c,gloves,lambda p:p['gold']==425 and p['inventory'][0]==1051);checks.append('native critical gloves cost 400 and replicate')
  command({'Buy':{'item':1051}});state(c,gloves,lambda p:p['gold']==25 and p['inventory'][:2]==[1051,1051]);checks.append('nonunique critical components stack in separate inventory slots')
  command({'Sell':{'slot':0}});state(c,gloves,lambda p:p['gold']==305 and p['inventory'][0] is None and p['inventory'][1]==1051);checks.append('critical component resale removes only selected copy')
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.2);clients.append(c)
  send(c,{'Join':{'champion':'garen'}});cloak=receive(c,'Welcome')['player'];seq=0
  command({'Buy':{'item':1018}});state(c,cloak,lambda p:p['gold']==95 and p['inventory'][0]==1018);checks.append('native critical cloak costs 730 and replicates on opposite team')
  proof={'passed':True,'checks':checks,'states':states,'server_sha256':hashlib.sha256(exe.read_bytes()).hexdigest(),'limits':['Transactions and replication only; native shop radius/sell rounding, full catalog, visuals, audio and item interactions remain incomplete.']}
  (root/'docs/shop_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':True,'checks':len(checks)}))
finally:
 for c in clients:c.close()
 if process and process.poll() is None:process.terminate();process.wait(timeout=10)
