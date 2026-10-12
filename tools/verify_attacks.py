import wire
"""Exercise movement into combat and native Q against two actual UDP-owned champions."""
import json,socket,subprocess,time,os,math,struct
from pathlib import Path
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5908)
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
 with (root/'logs/attack-server.log').open('w') as log:
    process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5908'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
    ids=[]
    for champion in ('ashe','garen'):
        client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);client.bind(('127.0.0.1',0));client.settimeout(.1);clients.append(client)
        deadline=time.monotonic()+15
        while True:
            send(client,{'Join':{'champion':champion}})
            try:ids.append(receive(client,'Welcome',.5)['player']);break
            except AssertionError:assert time.monotonic()<deadline
    state=receive(clients[0],'State')
    while len(state['roster'])!=2:state=receive(clients[0],'State')
    blue=next(p for p in state['players'] if p['id']==ids[0])
    meta=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding="utf-8"));cells=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[]
    for i in range(meta['width']*meta['height']):
        if struct.unpack_from('<H',cells,i*11+4)[0]&2==0:
            points.append({'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']})
    center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
    command(clients[0],2,{'Move':{'point':center}})
    command(clients[1],2,{'Move':{'point':center}})
    attack_range=next(p['attack_range'] for p in json.loads((root/'data/4.20/champions.json').read_text(encoding="utf-8")) if p['id']=='ashe')
    deadline=time.monotonic()+75;heartbeat=0
    while True:
        assert process.poll() is None,'Server died during navigation'
        if time.monotonic()>heartbeat:
            for client,champion in zip(clients,('ashe','garen')):send(client,{'Join':{'champion':champion}})
            heartbeat=time.monotonic()+2
        state=receive(clients[0],'State');blue=next(p for p in state['players'] if p['id']==ids[0]);purple=next((p for p in state['players'] if p['id']==ids[1]),None)
        if purple is None:
            assert time.monotonic()<deadline,'Opponent never entered shared vision'
            continue
        distance=math.hypot(blue['position']['x']-purple['position']['x'],blue['position']['z']-purple['position']['z'])
        if distance<=attack_range-30:break
        assert time.monotonic()<deadline,'Enemy did not reach native-grid combat position'
    command(clients[1],3,'Stop');command(clients[0],3,'Stop')
    stop_tick=state['tick']
    while state['tick'] < stop_tick+6:state=receive(clients[0],'State')
    purple=next(p for p in state['players'] if p['id']==ids[1]); initial_health=purple['health']
    command(clients[0],4,{'Attack':{'target':ids[1],'critical':True}})
    deadline=time.monotonic()+4; windup=None; missile=None; launch_state=None; stopped=False
    while True:
        state=receive(clients[0],'State');blue=next(p for p in state['players'] if p['id']==ids[0]);purple=next(p for p in state['players'] if p['id']==ids[1])
        if blue.get('windup'):
            windup=blue['windup'];assert purple['health']==initial_health,'Damage before attack release'
        shots=[p for p in state.get('projectiles',[]) if p['source']==ids[0]]
        if shots and not stopped:
            missile=shots[0];launch_state=state
            assert missile['speed']==2000.,'Ashe missile speed differs from native value'
            assert purple['health']==initial_health,'Missile damaged target before arrival'
            command(clients[0],5,'Stop');stopped=True
        if purple['health']<initial_health:break
        assert time.monotonic()<deadline,'Attack never landed'
    assert windup is not None,'No replicated windup observed'
    assert missile is not None and stopped,'No in-flight missile observed'
    assert windup['critical'] is False and missile['critical'] is False,'Client forged a critical result without chance bonus'
    assert missile['launched']>=windup['release'],'Projectile launched before windup ended'
    assert state['tick']>missile['launched'],'Projectile hit instantly'
    assert blue['target'] is None,'Stop did not clear attack order'
    assert not state['projectiles'],'Landed missile not removed'
    import hashlib,datetime
    receipt={'passed':True,'checks':['two opposing UDP-owned champions travel on native grid','windup replicated before damage','native Ashe projectile speed 2000','projectile flight replicated before damage','launch respects windup release tick','Stop clears attack order without cancelling launched missile','impact occurs after launch and removes missile','client critical flag cannot override zero native critical chance'], 'windup':windup,'projectile':missile,'impact_tick':state['tick'],'damage':initial_health-purple['health'],'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':'Main basic attack only. Historical special attacks, critical variants, projectile visuals and all champion kits remain unqualified.'}
    (root/'docs/attack_validation.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8');print(json.dumps(receipt))

finally:
 for client in clients:client.close()
 if process is not None and process.poll() is None:
    process.terminate()
    try:process.wait(timeout=10)
    except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
