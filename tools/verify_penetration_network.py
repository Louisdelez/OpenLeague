from pathlib import Path
import os,subprocess,socket,json,time,hashlib,datetime
import wire
r=Path(__file__).resolve().parents[1];address=('127.0.0.1',5934);server=None;c=None;sequence=0;samples=[];checks=[]
def send(p):c.sendto(json.dumps(p).encode(),address)
def receive(kind='State',timeout=5):
 end=time.monotonic()+timeout
 while time.monotonic()<end:
  assert server.poll() is None
  try:p=wire.packet(c)
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('Missing '+kind)
def command(action):
 global sequence
 sequence+=1;send({'Command':{'sequence':sequence,'action':action}})
def state(predicate):
 end=time.monotonic()+5;after=samples[-1]['tick'] if samples else 0
 while time.monotonic()<end:
  s=receive();p=next(p for p in s['players'] if p['id']==id)
  if s['tick']>after and predicate(p):samples.append({'tick':s['tick'],'player':p});return p
 raise AssertionError('State predicate did not converge')
try:
 with (r/'logs/penetration-network-server.log').open('w',encoding='utf-8') as log:
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5934'),stdout=log,stderr=log,creationflags=0x08000000);c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);end=time.monotonic()+15
  while True:
   send({'Join':{'champion':'garen'}})
   try:id=receive('Welcome',.5)['player'];break
   except AssertionError:assert time.monotonic()<end
  state(lambda p:p['gold']==825);checks.append('initialgold825')
  command({'Buy':{'item':1001}});state(lambda p:p['gold']==500 and p['inventory'][0]==1001);checks.append('bootsbuy325')
  command({'Buy':{'item':3020}});assert receive('Rejected')['reason']=='insufficient gold';checks.append('Sorcupgrade775recognized/insufficient')
  command({'Sell':{'slot':0}});state(lambda p:p['gold']==727 and p['inventory'][0] is None);checks.append('nativeBootsrefund227')
  command({'Buy':{'item':1036}});state(lambda p:p['gold']==367 and p['inventory'][0]==1036)
  command({'Buy':{'item':1036}});before=state(lambda p:p['gold']==7 and p['inventory'][:2]==[1036,1036]);checks.append('twoLongswords720')
  command({'Buy':{'item':3134}});assert receive('Rejected')['reason']=='insufficient gold';after=state(lambda p:p['gold']==7 and p['inventory']==before['inventory']);checks.append('Brutalizer617upgradefailureatomic')
  command({'Sell':{'slot':0}});state(lambda p:p['gold']==259 and p['inventory'][0] is None)
  command({'Sell':{'slot':1}});state(lambda p:p['gold']==511 and all(x is None for x in p['inventory']));checks.append('twoLongswordrefunds252')
  command({'Buy':{'item':1052}});state(lambda p:p['gold']==76 and p['inventory'][0]==1052)
  command({'Sell':{'slot':0}});state(lambda p:p['gold']==381 and p['inventory'][0] is None);checks.append('nativeTomerefund305')
  proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'checks':len(checks),'check_names':checks,'samples':samples,'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'limits':['Real UDP economic/recipe failure checks only. New penetration damage/GarenR source-attribution/world damage validated in core, not this UDP script. Entire game incomplete.']};(r/'docs/penetration_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(checks),'real UDP economy checks',flush=True)
finally:
 if c is not None:c.close()
 if server is not None:server.terminate();server.wait(timeout=10)
