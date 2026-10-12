"""Local movement probe using real server commands and visible Vulkan client."""
from pathlib import Path
import json,socket,subprocess,time,os,struct,math,datetime,hashlib
import wire
import argparse
parser=argparse.ArgumentParser();parser.add_argument("--reuse-client",type=int);parser.add_argument("--reuse-server",type=int);parser.add_argument("--renderer-player",type=int);args=parser.parse_args()
r=Path(__file__).resolve().parents[1];address=('127.0.0.1',5914);c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.2)
base=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5914',WGPU_BACKEND='vulkan')
if args.reuse_client is not None:
 assert args.reuse_server is not None
 class Existing:
  def __init__(self,pid):self.pid=pid
  def poll(self):
   import ctypes
   kernel=ctypes.windll.kernel32;kernel.OpenProcess.restype=ctypes.c_void_p;handle=kernel.OpenProcess(0x1000,False,self.pid)
   if not handle:return -1
   code=ctypes.c_ulong();kernel.GetExitCodeProcess(ctypes.c_void_p(handle),ctypes.byref(code));kernel.CloseHandle(ctypes.c_void_p(handle));return None if code.value==259 else code.value
 server=Existing(args.reuse_server);client=Existing(args.reuse_client)
else:
 serverlog=(r/'logs/native-entity-yaw-server.log').open('w');server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=base,stdout=serverlog,stderr=serverlog,creationflags=0x08000000)
 clientenv=dict(base,OPENLEAGUE_SCREENSHOT=str(r/'logs/native-entity-yaw-map10.png'),OPENLEAGUE_SCREENSHOT_DELAY='35',OPENLEAGUE_ENTITY_YAW_TRACE=str(r/'logs/native-entity-yaw-live.json'))
 for k in list(clientenv):
  if k.startswith('OPENLEAGUE_CAMERA_SHAKE_') or k=='OPENLEAGUE_RENDER_FOCUS':clientenv.pop(k)
 clientout=(r/'logs/native-entity-yaw-client.out.log').open('w');clienterr=(r/'logs/native-entity-yaw-client.err.log').open('w');client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=clientenv,stdout=clientout,stderr=clienterr,creationflags=0x08000000)
def send(p):c.sendto(json.dumps(p).encode(),address)
def packet():
 try:return wire.packet(c)
 except (socket.timeout,ConnectionResetError):return None
try:
 started=time.monotonic();welcome=None;lastjoin=0;lastmove=0;seq=0;samples=[];targets=[];allocation_attempts=0
 meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text());cells=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();width=meta['width']
 def distance(a,b):return math.hypot(a['x']-b['x'],a['z']-b['z'])
 while time.monotonic()-started<58:
  assert client.poll() is None and server.poll() is None,'Runtime exited'
  now=time.monotonic()
  if now-lastjoin>2:send({'Join':{'champion':'garen'}});lastjoin=now
  p=packet()
  if not p:continue
  if 'Rejected' in p:print('Rejected',p['Rejected'],flush=True)
  if 'Welcome' in p:welcome=p['Welcome']['player']
  if 'State' not in p or welcome is None:continue
  state=p['State']
  if args.renderer_player is not None and not any(a['id']==args.renderer_player for a in state['players']):
   allocation_attempts+=1;assert allocation_attempts<=2,'Renderer ID not observed; verify current player ID before retrying';print('Selecting next team allocation for visible allied probe',flush=True);c.close();c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.2);welcome=None;lastjoin=0;lastmove=0;seq=0;targets=[];samples=[];continue
  actor=next((a for a in state['players'] if a['id']==welcome),None)
  if actor is None:continue
  if not targets:
   home=actor['position'];available=[]
   for z in range(meta['height']):
    for x in range(width):
     if struct.unpack_from('<H',cells,(z*width+x)*11+4)[0]&2:continue
     point={'x':meta['min'][0]+(x+.5)*meta['cellSize'],'z':meta['min'][2]+(z+.5)*meta['cellSize']};d=distance(home,point)
     if 1400<d<1800:available.append((abs(point['z']-home['z']),point))
   assert available;target=min(available,key=lambda v:v[0])[1];targets=[target,home]
  if now-lastmove>9:
   seq+=1;send({'Command':{'sequence':seq,'action':{'Move':{'point':targets[(seq-1)%2]}}}});lastmove=now
  samples.append({'tick':state['tick'],'position':actor['position']})
  if (r/'logs/native-entity-yaw-live.json').exists() and (r/'logs/native-entity-yaw-map10.png').exists() and len({(v['position']['x'],v['position']['z']) for v in samples})>10:break
 assert (r/'logs/native-entity-yaw-live.json').exists(),'No live orientation trace';assert (r/'logs/native-entity-yaw-map10.png').exists(),'No actual framebuffer'
 assert len({(s['position']['x'],s['position']['z']) for s in samples})>10,'Driver did not move'
 proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'port':5914,'server':server.pid,'client':client.pid,'driver_player':welcome,'renderer_player':args.renderer_player,'move_commands':seq,'samples':samples,'targets':targets,'reuse_existing_processes':args.reuse_client is not None,'client_sha256':hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),'server_sha256':hashlib.sha256((r/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'diagnostic':True,'passed':True,'complete':False}
 (r/'logs/native-entity-yaw-runtime.json').write_text(json.dumps(proof,indent=2)+'\n');(r/'logs/live_processes.json').write_text(json.dumps({'port':5914,'server':server.pid,'client':client.pid},indent=2)+'\n');print('Actual runtime movement:',client.pid,server.pid,len(samples),'snapshots')
finally:c.close()
