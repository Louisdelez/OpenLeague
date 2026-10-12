import wire
"""Exercise movement into combat and native Q against two actual UDP-owned champions."""
import json,socket,subprocess,time,os,math,struct
from pathlib import Path
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5915)
clients=[];process=None

def send(client,packet):client.sendto(json.dumps(packet).encode(),address)
def receive(client,kind,timeout=3):
    end=time.monotonic()+timeout
    while time.monotonic()<end:
        try: packet=wire.packet(client)
        except (socket.timeout,ConnectionResetError): continue
        if packet is not None and kind in packet:return packet[kind]
    raise AssertionError('No '+kind+' packet')
def command(client,sequence,action):send(client,{'Command':{'sequence':sequence,'action':action}})
try:
 with (root/'logs/garen-passive-server.log').open('w') as log:
    process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5915'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
    ids=[]
    for _ in range(2):
        client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);client.bind(('127.0.0.1',0));client.settimeout(.1);clients.append(client)
        deadline=time.monotonic()+15
        while True:
            send(client,{'Join':{'champion':'garen'}})
            try:ids.append(receive(client,'Welcome',.5)['player']);break
            except AssertionError:assert time.monotonic()<deadline
    state=receive(clients[0],'State')
    while len(state['roster'])!=2:state=receive(clients[0],'State')
    blue=next(p for p in state['players'] if p['id']==ids[0])
    command(clients[0],1,{'Learn':{'slot':0}});command(clients[1],1,{'Learn':{'slot':0}})
    meta=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding="utf-8"));cells=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[]
    for i in range(meta['width']*meta['height']):
        if struct.unpack_from('<H',cells,i*11+4)[0]&2==0:
            points.append({'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']})
    center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
    command(clients[0],2,{'Move':{'point':center}})
    command(clients[1],2,{'Move':{'point':center}})
    attack_range=next(p['attack_range'] for p in json.loads((root/'data/4.20/champions.json').read_text(encoding="utf-8")) if p['id']=='garen')
    deadline=time.monotonic()+75;heartbeat=0
    while True:
        assert process.poll() is None,'Server died during navigation'
        if time.monotonic()>heartbeat:
            for client in clients:send(client,{'Join':{'champion':'garen'}})
            heartbeat=time.monotonic()+2
        state=receive(clients[0],'State');blue=next(p for p in state['players'] if p['id']==ids[0]);purple=next((p for p in state['players'] if p['id']==ids[1]),None)
        if purple is None:
            assert time.monotonic()<deadline,'Opponent never entered shared vision'
            continue
        distance=math.hypot(blue['position']['x']-purple['position']['x'],blue['position']['z']-purple['position']['z'])
        if distance<=attack_range:break
        assert time.monotonic()<deadline,'Enemy did not reach native-grid combat position'
    command(clients[1],3,'Stop');command(clients[0],3,{'Cast':{'slot':0,'target':None}});command(clients[0],4,{'Attack':{'target':ids[1]}})
    initial_health=purple['health'];deadline=time.monotonic()+3
    while True:
        state=receive(clients[0],'State');blue=next(p for p in state['players'] if p['id']==ids[0]);purple=next(p for p in state['players'] if p['id']==ids[1])
        if purple['health']<initial_health:break
        assert time.monotonic()<deadline,'No combat damage'
    command(clients[0],5,'Stop')
    interrupted=purple['perseverance_interrupted_at'];assert interrupted is not None
    regen=json.loads((root/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'))['garen']['health_regen']
    samples=[];baseline=None;deadline=time.monotonic()+20;heartbeat=0
    while True:
        if time.monotonic()>heartbeat:
            for client in clients:send(client,{'Join':{'champion':'garen'}})
            heartbeat=time.monotonic()+2
        state=receive(clients[0],'State');purple=next(p for p in state['players'] if p['id']==ids[1])
        assert purple['perseverance_interrupted_at']==interrupted,'Uncontrolled extra incoming damage'
        assert purple['health']>0 and purple['health']<purple['max_health'],'Target died or capped during measurement'
        samples.append({'tick':state['tick'],'health':purple['health']})
        if baseline is None and state['tick']>=interrupted+9:baseline=samples[-1]
        if baseline and state['tick']>=interrupted+240:before=samples[-1];break
        assert time.monotonic()<deadline
    observed_base=(before['health']-baseline['health'])*30/(before['tick']-baseline['tick'])
    assert abs(observed_base-regen)<.01,('Base regeneration mismatch',observed_base,regen)
    active=None
    while True:
        if time.monotonic()>heartbeat:
            for client in clients:send(client,{'Join':{'champion':'garen'}})
            heartbeat=time.monotonic()+2
        state=receive(clients[0],'State');purple=next(p for p in state['players'] if p['id']==ids[1]);assert purple['perseverance_interrupted_at']==interrupted
        current={'tick':state['tick'],'health':purple['health']};samples.append(current)
        if active is None and state['tick']>=interrupted+273:active=current
        if active and state['tick']>=active['tick']+90:finish=current;break
        assert time.monotonic()<deadline
    observed_active=(finish['health']-active['health'])*30/(finish['tick']-active['tick']);expected_active=regen+purple['max_health']*.004
    assert abs(observed_active-expected_active)<.01,('Passive regeneration mismatch',observed_active,expected_active)
    import hashlib,datetime
    proof={'passed':True,'checks':['two actual opposing UDP-owned Garens navigate native map into combat','native Q damages target without HP/XP injection','last interruption tick replicated after incoming champion damage','base-only regeneration measured before native nine-second cooldown','additional native level-one max-health regeneration measured after cooldown','target remains alive and below max health without further damage during both measurements'], 'samples':samples,'observed_base':observed_base,'expected_base':regen,'observed_active':observed_active,'expected_active':expected_active,'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Level-one real combat recovery only; higher tiers and minion/monster exceptions tested by authoritative fixtures, not complete native runtime.','Shielded-hit, unknown environmental-source, non-damaging ability and exact tick policies remain incompletely qualified.','Native VFX/audio/HUD and full champion kit unqualified.']}
    (root/'docs/garen_passive_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':True,'checks':len(proof['checks']),'base':observed_base,'active':observed_active,'expected_active':expected_active}))
finally:
 for client in clients:client.close()
 if process is not None and process.poll() is None:
    process.terminate()
    try:process.wait(timeout=10)
    except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
