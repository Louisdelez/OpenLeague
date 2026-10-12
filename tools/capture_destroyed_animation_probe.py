from pathlib import Path
import json,subprocess,os,time,socket,hashlib,datetime
r=Path('E:/OpenLeague');port=16047;prefix=r/'logs/destroyed-animation-runtime';probe=prefix.with_suffix('.jsonl');png=prefix.with_suffix('.png')
client=server=None
try:
 for p in [probe,png,prefix.with_suffix('.client.log'),prefix.with_suffix('.server.log')]:assert not p.exists(),p
 check=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);check.bind(('127.0.0.1',port));check.close()
 with prefix.with_suffix('.server.log').open('w',encoding='utf-8') as sl,prefix.with_suffix('.client.log').open('w',encoding='utf-8') as cl:
  env=dict(os.environ,OPENLEAGUE_SERVER=f'127.0.0.1:{port}')
  server=subprocess.Popen([str(r/'target/debug/examples/destroyed_animation_fixture.exe')],cwd=r,env=env,stdout=sl,stderr=sl,creationflags=0x08000000)
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=dict(env,OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(png),OPENLEAGUE_SCREENSHOT_DELAY='40',OPENLEAGUE_DESTRUCTION_ANIMATION_PROBE=str(probe),RUST_LOG='warn'),stdout=cl,stderr=cl,creationflags=0x08000000)
  print(json.dumps(dict(client_pid=client.pid,server_pid=server.pid)),flush=True)
  deadline=time.monotonic()+110
  while True:
   assert server.poll() is None and client.poll() is None,'diagnostic runtime stopped'
   if png.exists() and png.stat().st_size>10000:break
   assert time.monotonic()<deadline,'framebuffer timeout'
   time.sleep(.2)
  records=[json.loads(line) for line in probe.read_text(encoding='utf-8').splitlines()]
  destroyed={a['model'] for row in records for a in row['actors'] if a['model'].endswith('_destroyed') and a['role']=='death' and any(c['elapsed']>0 for c in a['active_clips'])}
  intact={a['model'] for row in records for a in row['actors'] if not a['model'].endswith('_destroyed')}
  assert len(destroyed)==4,(destroyed,intact)
  sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
  receipt=dict(checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,diagnostic_fixture=True,ordinary_combat_destruction_verified=False,intact_models=sorted(intact),destroyed_models=sorted(destroyed),sample_count=len(records),capture=str(png),capture_sha256=sha(png),probe_sha256=sha(probe),client_sha256=sha(r/'target/debug/openleague-client.exe'),fixture_sha256=sha(r/'target/debug/examples/destroyed_animation_fixture.exe'),visual_inspection_required=True,limits=['Outgoing snapshot health/position seeded by explicit diagnostic fixture; ordinary combat destruction not verified.','Actual client model replacement, death role and AnimationPlayer elapsed time observed. Native loop flags, native events and materials/FX remain open.'])
  (r/'docs/destroyed_animation_runtime.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
  print(json.dumps(dict(destroyed=sorted(destroyed),samples=len(records),capture=str(png))),flush=True)
finally:
 for process in [client,server]:
  if process and process.poll() is None:
   process.terminate()
   try:process.wait(timeout=10)
   except subprocess.TimeoutExpired:process.kill();process.wait(timeout=5)
