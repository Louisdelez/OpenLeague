from pathlib import Path
import subprocess,os,json,time,hashlib,socket,datetime
r=Path('E:/OpenLeague');server=client=None
capture=r/'logs/fow-vertex-diagnostic-150.png';probe=r/'logs/fow-vertex-diagnostic-150.json'
try:
 for p in [capture,probe]:assert not p.exists()
 check=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);check.bind(('127.0.0.1',16020));check.close()
 with (r/'logs/fow-vertex-diagnostic-server.log').open('w') as sl,(r/'logs/fow-vertex-diagnostic-client.log').open('w') as cl:
  env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:16020')
  server=subprocess.Popen([str(r/'target/debug/openleague-server.exe')],cwd=r,env=env,stdout=sl,stderr=sl,creationflags=0x08000000)
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=dict(env,WGPU_BACKEND='vulkan',OPENLEAGUE_ACTOR_FOW_PROBE=str(r/'logs/fow-vertex-diagnostic-bindings.json'),OPENLEAGUE_FOW_MASK_PROBE='1',OPENLEAGUE_FOW_GPU_PROBE=str(r/'logs/fow-vertex-diagnostic-stages.json'),OPENLEAGUE_FOW_GPU_READBACK=str(r/'logs/fow-vertex-diagnostic-readback.json'),OPENLEAGUE_SCREENSHOT=str(capture),OPENLEAGUE_SCREENSHOT_DELAY='20',OPENLEAGUE_VISIBILITY_TEXTURE_PROBE=str(probe),RUST_LOG='warn'),stdout=cl,stderr=cl,creationflags=0x08000000)
  print(json.dumps({'client_pid':client.pid,'server_pid':server.pid}),flush=True)
  deadline=time.monotonic()+80
  while True:
   assert server.poll() is None and client.poll() is None,'runtime stopped'
   try:d=json.loads(probe.read_text())
   except (FileNotFoundError,json.JSONDecodeError):d=None
   
   try:
    actors=json.loads((r/'logs/fow-vertex-diagnostic-bindings.json').read_text());stages=json.loads((r/'logs/fow-vertex-diagnostic-stages.json').read_text());readback=json.loads((r/'logs/fow-vertex-diagnostic-readback.json').read_text())
   except (FileNotFoundError,json.JSONDecodeError):actors={};stages=None;readback=None
   if actors.get('bound_meshes',0)>0 and actors['skinned_meshes']>0 and actors['ready_materials']==actors['bound_meshes'] and all(m==0 for m in actors['factor_modes']) and stages and stages['frames']>3 and readback and readback['bytes']==1048576 and readback['alpha_ready'] and readback['rgb_equal'] and readback['distinct_red_values']>2 and readback['nonzero_texels']>0 and d and d['uploads']>3 and d['nonzero_texels']>0 and d['error'] is None and capture.exists() and capture.stat().st_size>10000:break
   assert time.monotonic()<deadline,('texture runtime timeout',d)
   time.sleep(.1)
  sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
  receipt={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'normal_server':True,'actor_bindings':actors,'actor_mask_diagnostic':True,'gpu_stages':stages,'gpu_readback':readback,'normal_terrain_environment_factors':True,'client_sha256':sha(r/'target/debug/openleague-client.exe'),'measurement':d,'capture':str(capture),'capture_sha256':sha(capture),'visual_inspection_required':True,'limits':['Current ordinary local-server Vulkan client: final GPU visibility read back, normal terrain/environment factors enabled; exact pixel values and native original branch routing unqualified.','Native base factors bound to current loaded gameplay/ambient model descendants; all122champions/skins and original shader-variant fidelity remain open.']}
  (r/'docs/fow_vertex_diagnostic_runtime_capture.json').write_text(json.dumps(receipt,indent=2)+'\n')
  print(json.dumps(receipt),flush=True)
finally:
 for process in [client,server]:
  if process and process.poll() is None:
   process.terminate()
   try:process.wait(timeout=10)
   except subprocess.TimeoutExpired:process.kill();process.wait(timeout=5)
