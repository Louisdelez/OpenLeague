from pathlib import Path
import os,subprocess,socket,json,time,sys,hashlib,datetime
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',5982);server=None;client=None;c=None;heartbeat=0
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def send(p):c.sendto(json.dumps(p).encode(),addr)
def receive(kind='State',timeout=5):
    global heartbeat
    end=time.monotonic()+timeout
    while time.monotonic()<end:
        assert server.poll() is None
        if time.monotonic()>=heartbeat:send({'Join':{'champion':'annie'}});heartbeat=time.monotonic()+2
        try:p=wire.packet(c)
        except (socket.timeout,ConnectionResetError):continue
        if p and kind in p:return p[kind]
    raise AssertionError('Missing '+kind)
try:
    capture=r/'logs/projected-render-baseline.png';probe=r/'logs/projected-render-on.json'
    on=probe.with_suffix('.png');off=r/'logs/projected-render-off.png'
    for p in [capture,probe,on,off]:assert not p.exists(),str(p)
    with (r/'logs/projected-render-server.log').open('w',encoding='utf-8') as sl,(r/'logs/projected-render-client.log').open('w',encoding='utf-8') as cl:
        server=subprocess.Popen([str(r/'target/debug/examples/annie_ready_fixture.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5982'),stdout=sl,stderr=sl,creationflags=0x08000000)
        c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);end=time.monotonic()+15
        while True:
            send({'Join':{'champion':'annie'}})
            try:owner=receive('Welcome',.5)['player'];break
            except AssertionError:assert time.monotonic()<end
        state=receive();actor=next(p for p in state['players'] if p['id']==owner);point=actor['position'];height=actor['height']
        env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5982',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(capture),OPENLEAGUE_PROJECTED_RENDER_PROBE=probe.as_posix(),OPENLEAGUE_RENDER_FOCUS=f"{point['x']/20},{height/20},{point['z']/20}")
        client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=cl,stderr=cl,creationflags=0x08000000)
        end=time.monotonic()+100
        while not (probe.exists() and on.exists() and off.exists() and off.stat().st_size>10000):
            assert time.monotonic()<end;assert client.poll() is None;receive()
        measured=json.loads(probe.read_text(encoding='utf-8'));assert measured['patch_vertices']>0
        assert measured['remaining_materials']==0 and not measured['remaining_probe_entity']
        proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'diagnostic_fixture':True,'native_emitter_bound':False,'client_pid':client.pid,'fixture_pid':server.pid,'client_sha256':sha(r/'target/debug/openleague-client.exe'),'fixture_sha256':sha(r/'target/debug/examples/annie_ready_fixture.exe'),'measurement':measured,'captures':[{'path':str(p.relative_to(r)),'sha256':sha(p)} for p in [on,off]],'optional_startup_capture_saved':capture.exists(),'visual_inspection_required':True,'limits':['Actual Vulkan framebuffer and real terrain projection material. Explicit probe, not native Q emitter lifecycle or ordinary progression.','Geometry/texture/material cleanup measured; visual effect requires inspection and native source comparison before fidelity acceptance.','FOW1, patch500/angle0, additive/depth states reconstructed; native shader variants, terrain receivers, skin and binding remain incomplete.']}
        (r/'docs/projected_render_live_capture.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        print(json.dumps({'patch_vertices':measured['patch_vertices'],'remaining_materials':measured['remaining_materials'],'actual_on_off_captures':True}))
finally:
    if c:c.close()
    for p in [client,server]:
        if p and p.poll() is None:
            p.terminate()
            try:p.wait(timeout=10)
            except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)
