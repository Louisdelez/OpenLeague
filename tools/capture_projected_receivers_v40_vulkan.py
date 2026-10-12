from pathlib import Path
import os,subprocess,socket,json,time,sys,hashlib,datetime
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',10501);server=None;client=None;c=None;seq=0;heartbeat=0
def send(p):c.sendto(json.dumps(p).encode(),addr)
def receive(kind='State',timeout=5):
 global heartbeat
 deadline=time.monotonic()+timeout
 while time.monotonic()<deadline:
  assert server.poll() is None,'fixture stopped'
  if time.monotonic()>=heartbeat:send({'Join':{'champion':'annie'}});heartbeat=time.monotonic()+2
  try:p=wire.packet(c)
  except (socket.timeout,ConnectionResetError):continue
  if p and kind in p:return p[kind]
 raise AssertionError('Missing '+kind)
def command(action):
 global seq
 seq+=1;send({'Command':{'sequence':seq,'action':action}})
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def measurement():
 try:return json.loads(probe.read_text())
 except (FileNotFoundError,json.JSONDecodeError):return {}
try:
 baseline=r/'logs/projected-core-cycle-v40-receivers-vulkan-baseline.png';probe=r/'logs/projected-core-cycle-v40-receivers-vulkan-on.json';on=probe.with_suffix('.png');off=probe.with_suffix('.off.png')
 for p in [baseline,probe,on,off]:assert not p.exists(),str(p)
 with (r/'logs/projected-core-cycle-v40-receivers-vulkan-server.log').open('w',encoding='utf-8') as sl,(r/'logs/projected-core-cycle-v40-receivers-vulkan-client.log').open('w',encoding='utf-8') as cl:
  server=subprocess.Popen([str(r/'target/debug/examples/annie_ready_fixture.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_PROJECTED_TERRAIN_PROBE=(r/'logs/receiver-surfaces-v40-vulkan.json').as_posix(),OPENLEAGUE_PROJECTED_CAMERA_REENTRY='1',OPENLEAGUE_SERVER='127.0.0.1:10501'),stdout=sl,stderr=sl,creationflags=0x08000000)
  c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);deadline=time.monotonic()+15
  while True:
   send({'Join':{'champion':'annie'}})
   try:owner=receive('Welcome',.5)['player'];break
   except AssertionError:assert time.monotonic()<deadline
  command({'Learn':{'slot':0}})
  while True:
   state=receive();actor=next(p for p in state['players'] if p['id']==owner)
   if actor['ranks'][0]==1:break
  point=actor['position'];height=actor['height']
  env=dict(os.environ,OPENLEAGUE_PROJECTED_TERRAIN_PROBE=(r/'logs/receiver-surfaces-v40-vulkan.json').as_posix(),OPENLEAGUE_PROJECTED_CAMERA_REENTRY='1',OPENLEAGUE_SERVER='127.0.0.1:10501',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(baseline),OPENLEAGUE_PROJECTED_LIVE_PROBE=probe.as_posix(),OPENLEAGUE_PROJECTED_PIXEL_PAIR=(r/'logs/projected-core-cycle-v40-receivers-vulkan-pixels.json').as_posix(),OPENLEAGUE_PROJECTED_PIPELINE_PROBE=(r/'logs/projected-core-cycle-v40-receivers-vulkan-pipeline.json').as_posix(),OPENLEAGUE_RENDER_FOCUS=f"{point['x']/20},{height/20},{point['z']/20}")
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=cl,creationflags=0x08000000)
  deadline=time.monotonic()+85
  while not (baseline.exists() and baseline.stat().st_size>10000):
   assert time.monotonic()<deadline,'startup capture timeout';assert client.poll() is None,'client stopped';state=receive()
  target=next(p['id'] for p in state['players'] if p['champion']=='garen')
  states=[]
  for shot in [1,2]:
   if shot==2:
    deadline=time.monotonic()+12
    while True:
     state=receive();actor=next(p for p in state['players'] if p['id']==owner)
     if state['tick']>=actor['cooldowns'][0]:break
     assert time.monotonic()<deadline,'cooldown timeout'
   command({'Cast':{'slot':0,'target':target}})
   deadline=time.monotonic()+25
   while True:
    assert client.poll() is None,'client stopped';state=receive();m=measurement()
    if m.get('spawned')==shot and m.get('cleaned')==shot and m.get('active_effects')==0 and off.exists() and off.stat().st_size>10000:break
    assert time.monotonic()<deadline,('normal projection cleanup timeout',m)
   assert m['native_parent_frame_binding']
   assert m['native_spatial_selection_binding']
   assert m['native_visibility_activation_binding'] and m['native_visibility_suppression_binding']
   assert m['native_owner_scale_gate_binding']
   assert m['native_owner_acquisition_gate_binding']
   assert m['native_pose_binding'] and not m['native_position_coordinate_roundtrip']
   assert m['native_stop_dispatch_binding'] and m['native_clock_binding']
   assert m['max_visible_draws']>0
   assert m['active_draws']==0 and m['visible_frames']>0 and m['max_vertices']>0
   states.append(m);print(json.dumps({'shot':shot,'measurement':m}),flush=True)
  cleanup_deadline=time.monotonic()+10
  pixel_path=r/'logs/projected-core-cycle-v40-receivers-vulkan-pixels.json'
  while True:
   pixel_report=json.loads(pixel_path.read_text())
   active_owners={row['entity'] for row in pixel_report['rows'] if row['draws']>0}
   cleanup_files=list(pixel_path.parent.glob(pixel_path.stem+'.entity-*-clean.rgba'))
   if len(active_owners)==2 and len(cleanup_files)==2:break
   assert time.monotonic()<cleanup_deadline,'missing GPU cleanup atlases'
   receive()
  surface_path=r/'logs/receiver-surfaces-v40-vulkan.json'
  surface=json.loads(surface_path.read_text())
  assert surface['restored_terrain_meshes']==2351,('missing native map receiver meshes',surface)
  assert surface['source_triangles']>900000,('unexpected receiver geometry',surface)
  assert surface['clipped_triangles']>0,('no projection intersection',surface)
  traces=states[-1]['parent_traces'];assert len(traces)==2
  flush_deadline=time.monotonic()+3
  expected_images=[probe.with_suffix(f".owner-{trace['identity']}-{phase}.png") for trace in traces for phase in ['initial','hidden','returned']]
  while not all(p.exists() and p.stat().st_size>10000 for p in expected_images) and time.monotonic()<flush_deadline:receive()

  qualified=[];phase_images=[]
  for trace in traces:
   frames=trace['frames'];hidden=[(j,f) for j,f in enumerate(frames) if f['path']=='Skip']
   if not hidden:continue
   assert all(f['storage']==0 and f['active']==0 for _,f in hidden)
   assert len({f['simulation_time_bits'] for _,f in hidden})==1
   returned=[f for f in frames[hidden[-1][0]+1:] if f['visible'] and f['active']>0]
   if not returned:continue
   identity=trace['identity'];images=[probe.with_suffix(f'.owner-{identity}-{phase}.png') for phase in ['initial','hidden','returned']]
   if all(p.exists() and p.stat().st_size>10000 for p in images):qualified.append(identity);phase_images.extend(images)
  assert qualified,('No complete camera exit/reentry captured',traces)
  receipt={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'diagnostic_fixture':True,'normal_binding':True,'port':10501,'owner':owner,'target':target,'client_sha256':sha(r/'target/debug/openleague-client.exe'),'fixture_sha256':sha(r/'target/debug/examples/annie_ready_fixture.exe'),'receiver_geometry':surface,'receiver_geometry_sha256':sha(surface_path),'measurements':states,'camera_reentry_qualified_identities':qualified,'camera_phase_images':[{'path':str(p.relative_to(r)),'sha256':sha(p)} for p in phase_images],'captures':[{'path':str(p.relative_to(r)),'sha256':sha(p)} for p in [baseline,off]+phase_images],'visual_inspection_required':True,'limits':['Current Vulkan framebuffer with normal projectile-driven projection, fixture seeds level6/position/readiness; not ordinary progression acceptance.','Phase screenshots are authoritative; legacy shot requests are disabled during this diagnostic. Two server casts; normal consumer creates and cleans its own mesh/material/entity. Geometry counters are CPU observations, not pixel attribution.','Native camera/query/merge and existing spatial registry now drive activation. Stable local identities/current-owner frame scheduling/root filter disabled remain adapters; team/FOW, dynamic camera reentry visual acceptance, receiver fidelity and full Q remain open.']}
  (r/'docs/projected_core_cycle_capture_v40_receivers_vulkan.json').write_text(json.dumps(receipt,indent=2)+'\n');print('Normal projected capture and repeat cleanup recorded',flush=True)
finally:
 if c:c.close()
 for p in [client,server]:
  if p and p.poll() is None:
   p.terminate()
   try:p.wait(timeout=10)
   except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)


