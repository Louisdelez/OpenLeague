"""Bounded real-client ambient-parent observation; fixture server, no audible claim."""
from pathlib import Path
import os, subprocess, json, time, hashlib, datetime
r=Path('E:/OpenLeague')
stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
base=r/'logs'/('ambient-retirement-'+stamp)
probe=base.with_suffix('.json')
server=client=None
samples=[]
result={'complete':False,'passed':False,'backend':'dx12','server_kind':'existing annie_paused_fixture','probe':str(probe)}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
try:
 env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:10631',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='dx12',OPENLEAGUE_READY_LIVE_PROBE=probe.as_posix(),OPENLEAGUE_SCREENSHOT=base.with_suffix('.png').as_posix(),OPENLEAGUE_RENDER_FOCUS='707.3434,7.242945,370.7506')
 for k in ['OPENLEAGUE_PROJECTED_CAMERA_REENTRY','OPENLEAGUE_PAIR_PHASE_TRACE','OPENLEAGUE_PAIR_TARGET','OPENLEAGUE_PROJECTED_PIXEL_PAIR'] :env.pop(k,None)
 with base.with_suffix('.server.log').open('w') as sl,base.with_suffix('.client.log').open('w') as cl:
  server=subprocess.Popen([str(r/'target/debug/examples/annie_paused_fixture.exe')],cwd=r,env=env,stdout=sl,stderr=sl,creationflags=0x08000000)
  client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=cl)
  result.update(client_pid=client.pid,server_pid=server.pid,client_sha256=sha(r/'target/debug/openleague-client.exe'),server_sha256=sha(r/'target/debug/examples/annie_paused_fixture.exe'))
  deadline=time.monotonic()+100;started=None;last=None
  while time.monotonic()<deadline:
   assert server.poll() is None,'fixture exited'
   assert client.poll() is None,'client exited'
   try:m=json.loads(probe.read_text())
   except (FileNotFoundError,PermissionError,json.JSONDecodeError):time.sleep(.1);continue
   a=m.get('audio',{})
   if a.get('active') and m.get('observation')!=last:
    if started is None:started=time.monotonic()
    last=m['observation'];samples.append({'observation':last,'clock':m['clock'],'audio':a})
    if time.monotonic()-started>=30:break
   time.sleep(.2)
  assert len(samples)>=10,'insufficient active observations'
  settled=samples[5:]
  assert all(not x['audio']['rejected'] for x in settled),'parent rejected real scene input'
  assert all(not x['audio']['unresolved'] for x in settled),'missing real attachment'
  assert any(x['audio'].get('owner_fallbacks') for x in settled),'native owner fallback not observed'
  assert len({x['audio']['pass_stamp'] for x in settled})>=5,'effect pass did not advance'
  assert any(a['handle']>0 for x in settled for a in x['audio']['active']),'no persistent logical registration'
  assert all(not x['audio']['backend_available'] for x in settled),'unexpected audio backend claim'
  assert samples[-1]['audio'].get('cleaned_count',0)>=10,'no repeated finished-parent cleanup'
  assert max(x['audio']['ended_count'] for x in settled)<20,'ended parents still accumulate'
  assert all(x['audio'].get('uninitialized_ended_count',0)==0 for x in settled),'uninitialized ended owner observed'
  result['passed']=True
except Exception as e:
 result['error']=repr(e)
 raise
finally:
 for proc in [client,server]:
  if proc is not None and proc.poll() is None:proc.terminate();proc.wait(timeout=15)
 result.update(samples=samples,owned_processes_stopped=all(p is None or p.poll() is not None for p in [client,server]),limits=['Diagnostic fixture and fixed camera, not a full match.','Logical parent observation only; physical voices and global RNG ownership remain incomplete; bounded run does not prove endurance.'])
 (r/'docs/ambient_retirement_runtime_validation.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
 print(json.dumps({k:v for k,v in result.items() if k!='samples'}))
