import wire
"""Exercise movement into combat and native Q against two actual UDP-owned champions."""
import json,socket,subprocess,time,os,math,struct
from pathlib import Path
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5909)
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
 with (root/'logs/lifesteal-server.log').open('w') as log:
    process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5909'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
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
    command(clients[0],1,{'Buy':{'item':1036}});command(clients[0],2,{'Buy':{'item':1053}});command(clients[1],1,{'Learn':{'slot':0}})
    while True:
        state=receive(clients[0],'State');blue=next(p for p in state['players'] if p['id']==ids[0])
        if blue['inventory'][0]==1053 and blue['gold']==25:break
    meta=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding="utf-8"));cells=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[]
    for i in range(meta['width']*meta['height']):
        if struct.unpack_from('<H',cells,i*11+4)[0]&2==0:
            points.append({'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']})
    center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
    command(clients[0],3,{'Move':{'point':center}})
    command(clients[1],3,{'Move':{'point':center}})
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
    command(clients[0],4,'Stop');command(clients[1],4,'Stop')
    command(clients[1],5,{'Cast':{'slot':0,'target':None}});command(clients[1],6,{'Attack':{'target':ids[0]}})
    max_hp=blue['max_health'];deadline=time.monotonic()+5
    while True:
        state=receive(clients[0],'State');blue=next(p for p in state['players'] if p['id']==ids[0])
        if blue['health']<max_hp-20:break
        assert time.monotonic()<deadline,'Opponent Q did not create missing health'
    command(clients[1],7,'Stop');stop_tick=state['tick']
    while state['tick']<stop_tick+6:state=receive(clients[0],'State')
    blue=next(p for p in state['players'] if p['id']==ids[0]);purple=next(p for p in state['players'] if p['id']==ids[1]);baseline={'tick':state['tick'],'health':blue['health']}
    champion=json.loads((root/'data/4.20/champions.json').read_text(encoding='utf-8'));growth=json.loads((root/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'));ashe=next(p for p in champion if p['id']=='ashe');garen=next(p for p in champion if p['id']=='garen')
    regen=growth['ashe']['health_regen'];raw=ashe['attack_damage']+10;mitigated=raw*100/(100+garen['armor']);expected_heal=mitigated*.08
    command(clients[0],5,{'Attack':{'target':ids[1]}});deadline=time.monotonic()+4;windup=None
    while True:
        state=receive(clients[0],'State');blue=next(p for p in state['players'] if p['id']==ids[0]);purple=next(p for p in state['players'] if p['id']==ids[1])
        elapsed=(state['tick']-baseline['tick'])/30;healing=blue['health']-baseline['health']-regen*elapsed
        if blue.get('windup'):
            windup=blue['windup'];assert abs(healing)<.004,'Life steal before impact'
        if healing>1:break
        assert time.monotonic()<deadline,'No attack life steal observed'
    command(clients[0],6,'Stop')
    assert windup is not None,'No attack windup observed'
    assert purple['health']<purple['max_health'],'Attack did not damage opponent'
    assert state['tick']>windup['release'],'Life steal before missile impact'
    assert abs(healing-expected_heal)<.004,('Wrong life steal healing',healing,expected_heal)
    import hashlib,datetime
    receipt={'passed':True,'checks':['native sword and scepter recipe purchases consume component and only remaining 440 gold without injected currency','opponent learned Q creates missing health through actual combat','ordinary ranged windup does not heal','ranged impact damages enemy and restores health','healing equals native eight percent of post-armor ordinary attack damage after subtracting native regeneration'], 'baseline':baseline,'windup':windup,'impact_snapshot':state,'measured_heal':healing,'expected_heal':expected_heal,'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Ordinary level-one Ashe attack only; native critical/passive/on-hit semantics, shield/overkill cases and historical full fidelity unqualified.','Enemy Q used only to create missing health; no direct health/damage client injection.']}
    (root/'docs/lifesteal_network_validation.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8');print(json.dumps({'passed':True,'checks':len(receipt['checks']),'measured_heal':healing,'expected_heal':expected_heal}))

finally:
 for client in clients:client.close()
 if process is not None and process.poll() is None:
    process.terminate()
    try:process.wait(timeout=10)
    except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
