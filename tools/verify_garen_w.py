import wire
"""Exercise movement into combat and native Q against two actual UDP-owned champions."""
import json,socket,subprocess,time,os,math,struct
from pathlib import Path
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5912)
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
 with (root/'logs/garen-w-server.log').open('w') as log:
    process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5912'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
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
    command(clients[1],1,{'Buy':{'item':1029}});command(clients[1],2,{'Buy':{'item':1033}});command(clients[1],3,{'Learn':{'slot':1}})
    deadline=time.monotonic()+4
    while True:
        own=receive(clients[1],'State');target=next(p for p in own['players'] if p['id']==ids[1])
        if target['inventory'][:2]==[1029,1033] and target['ranks'][1]==1:break
        assert time.monotonic()<deadline,'Native defensive purchases/skill rank not replicated'
    assert target['gold']==25
    meta=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding="utf-8"));cells=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();points=[]
    for i in range(meta['width']*meta['height']):
        if struct.unpack_from('<H',cells,i*11+4)[0]&2==0:
            points.append({'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']})
    center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
    command(clients[0],4,{'Move':{'point':center}})
    command(clients[1],4,{'Move':{'point':center}})
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
    command(clients[1],5,'Stop');command(clients[0],5,'Stop');stop_tick=state['tick']
    while state['tick']<stop_tick+6:state=receive(clients[0],'State')
    purple=next(p for p in state['players'] if p['id']==ids[1]);initial=purple['health'];command(clients[0],6,{'Attack':{'target':ids[1]}})
    deadline=time.monotonic()+4;missile=None
    while True:
        state=receive(clients[0],'State');purple=next(p for p in state['players'] if p['id']==ids[1]);shots=[p for p in state['projectiles'] if p['source']==ids[0]]
        if shots and missile is None:missile=shots[0];command(clients[0],7,'Stop')
        if purple['health']<initial:break
        assert time.monotonic()<deadline,'No first damage observed'
    assert missile is not None
    champions=json.loads((root/'data/4.20/champions.json').read_text(encoding='utf-8'));garen=next(p for p in champions if p['id']=='garen');growth=json.loads((root/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'))
    expected_passive=missile['raw']*100/(100+garen['armor']+15*1.2);observed_passive=initial-purple['health']
    assert expected_passive-.3<observed_passive<=expected_passive+.001,('W passive damage mismatch',observed_passive,expected_passive)
    command(clients[1],6,{'Cast':{'slot':1,'target':None}});deadline=time.monotonic()+3
    while True:
        state=receive(clients[0],'State');purple=next(p for p in state['players'] if p['id']==ids[1])
        if purple['effects']['courage_until']>state['tick']:break
        assert time.monotonic()<deadline,'W active not replicated'
    baseline={'tick':state['tick'],'health':purple['health']};command(clients[0],8,{'Attack':{'target':ids[1]}});deadline=time.monotonic()+4
    while True:
        state=receive(clients[0],'State');purple=next(p for p in state['players'] if p['id']==ids[1])
        corrected=baseline['health']-purple['health']+growth['garen']['health_regen']*(state['tick']-baseline['tick'])/30
        if corrected>5:break
        assert time.monotonic()<deadline,'No active W incoming damage observed'
    command(clients[0],9,'Stop');expected_active=expected_passive*.7
    assert purple['effects']['courage_until']>state['tick'],'W expired before impact'
    assert abs(corrected-expected_active)<.005,('W active damage mismatch',corrected,expected_active)
    import hashlib,datetime
    proof={'passed':True,'checks':['native cloth and cloak purchases use original 825 gold and leave 25','learned W rank replicated before combat','ordinary ranged attack hits equipped enemy','W passive twenty percent bonus item armor matches observed damage','W active replicated','W active thirty percent incoming damage reduction matches observed damage after native regeneration subtraction'], 'passive_damage':observed_passive,'expected_passive_damage':expected_passive,'active_damage':corrected,'expected_active_damage':expected_active,'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Level-one physical attack and native item armor/W combination only; full magic, control, VFX/audio and champion kit fidelity not qualified.','Passive phase allows <=0.3 HP snapshot regeneration drift; active phase explicitly subtracts native regeneration.']}
    (root/'docs/garen_w_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':True,'checks':len(proof['checks']),'passive_damage':observed_passive,'active_damage':corrected,'expected_active':expected_active}))

finally:
 for client in clients:client.close()
 if process is not None and process.poll() is None:
    process.terminate()
    try:process.wait(timeout=10)
    except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
