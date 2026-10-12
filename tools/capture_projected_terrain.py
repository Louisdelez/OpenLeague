"""Measure real loaded restored map surfaces; no claim projected GPU particle exists."""
from pathlib import Path
import os,subprocess,socket,json,time,sys,hashlib,datetime,struct
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools'));import wire
addr=('127.0.0.1',5981);server=None;client=None;c=None;heartbeat=0
def send(packet):c.sendto(json.dumps(packet).encode(),addr)
def receive(kind='State',timeout=5):
    global heartbeat
    end=time.monotonic()+timeout
    while time.monotonic()<end:
        assert server.poll() is None
        if time.monotonic()>=heartbeat:send({'Join':{'champion':'annie'}});heartbeat=time.monotonic()+2
        try:packet=wire.packet(c)
        except (socket.timeout,ConnectionResetError):continue
        if packet and kind in packet:return packet[kind]
    raise AssertionError('Missing '+kind)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
try:
    capture=r/'logs/projected-terrain-loaded.png';probe=r/'logs/projected-terrain-loaded.json'
    for p in [capture,probe]:assert not p.exists(),str(p)
    with (r/'logs/projected-terrain-server.log').open('w',encoding='utf-8') as server_log,(r/'logs/projected-terrain-client.log').open('w',encoding='utf-8') as client_log:
        server=subprocess.Popen([str(r/'target/debug/examples/annie_ready_fixture.exe')],cwd=r,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5981'),stdout=server_log,stderr=server_log,creationflags=0x08000000)
        c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1)
        end=time.monotonic()+15
        while True:
            send({'Join':{'champion':'annie'}})
            try:owner=receive('Welcome',.5)['player'];break
            except AssertionError:assert time.monotonic()<end
        state=receive();actor=next(p for p in state['players'] if p['id']==owner);position=actor['position'];height=actor['height']
        env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5981',OPENLEAGUE_CHAMPION='garen',WGPU_BACKEND='vulkan',OPENLEAGUE_SCREENSHOT=str(capture),OPENLEAGUE_PROJECTED_TERRAIN_PROBE=probe.as_posix(),OPENLEAGUE_RENDER_FOCUS=f"{position['x']/20},{height/20},{position['z']/20}")
        client=subprocess.Popen([str(r/'target/debug/openleague-client.exe')],cwd=r,env=env,stdout=client_log,stderr=client_log,creationflags=0x08000000)
        end=time.monotonic()+90
        while not (capture.exists() and capture.stat().st_size>10000 and probe.exists()):
            assert time.monotonic()<end;assert client.poll() is None;receive()
        measured=json.loads(probe.read_text(encoding='utf-8'))
        # Independently count source primitive instances in the restored GLB.
        b=(r/'assets/maps/twisted_treeline.glb').read_bytes();n=struct.unpack_from('<I',b,12)[0];g=json.loads(b[20:20+n])
        mats={i for i,m in enumerate(g['materials']) if m.get('name') in ['NVRMaterial_TT_Jungle1','NVRMaterial_TT_Lanes1']}
        parts=[p for node in g['nodes'] if 'mesh' in node for p in g['meshes'][node['mesh']]['primitives'] if p.get('material') in mats]
        expected_triangles=sum(g['accessors'][p['indices']]['count']//3 for p in parts)
        assert measured['restored_terrain_meshes']==len(parts)==82
        assert measured['source_triangles']==expected_triangles==1163
        assert measured['clipped_triangles']>0
        assert measured['world_y_min']<measured['world_y_max']
        proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'diagnostic_fixture':True,'client_pid':client.pid,'fixture_pid':server.pid,'port':5981,'client_sha256':sha(r/'target/debug/openleague-client.exe'),'fixture_sha256':sha(r/'target/debug/examples/annie_ready_fixture.exe'),'restored_map_sha256':sha(r/'assets/maps/twisted_treeline.glb'),'measurement':measured,'independent_glb_counts':{'primitive_instances':len(parts),'triangles':expected_triangles},'capture':{'path':str(capture.relative_to(r)),'sha256':sha(capture)},'limits':['Actual Vulkan client loaded original restored map meshes. Projection geometry measured on CPU; projected particle is not rendered by this receipt.','Separate fixture seeds level6/readiness/center positions. No claim ordinary progression or complete game acceptance.','Explicit diagnostic patch half-size500/angle0, not qualified emitter field binding. Full terrain selection, original clipping/FOW/depth and textures remain open.']}
        (r/'docs/projected_terrain_live_capture.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        print(json.dumps({'meshes':measured['restored_terrain_meshes'],'source_triangles':measured['source_triangles'],'patch_triangles':measured['clipped_triangles'],'world_height_range':[measured['world_y_min'],measured['world_y_max']]}))
finally:
    if c:c.close()
    for p in [client,server]:
        if p and p.poll() is None:
            p.terminate()
            try:p.wait(timeout=10)
            except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)
