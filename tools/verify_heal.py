import wire
"""Exercise movement into combat and native Q against two actual UDP-owned champions."""
import json,socket,subprocess,time,os,math,struct
from pathlib import Path
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5916)
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
 with (root/'logs/heal-server.log').open('w') as log:
    process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5916'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
    ids=[]
    for number in range(2):
        client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);client.bind(('127.0.0.1',0));client.settimeout(.1);clients.append(client)
        deadline=time.monotonic()+15
        while True:
            send(client,{'Join':{'champion':'garen','summoners':['Heal',None] if number==1 else [None,None]}})
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
    deadline=time.monotonic()+4
    while initial_health-purple['health']<110:
        state=receive(clients[0],'State');purple=next(p for p in state['players'] if p['id']==ids[1]);assert time.monotonic()<deadline
    command(clients[0],5,'Stop')
    baseline={'tick':state['tick'],'health':purple['health'],'interrupt':purple['perseverance_interrupted_at']}
    assert purple['summoners']['spells']==['Heal',None]
    command(clients[1],4,{'Summoner':{'slot':0}});deadline=time.monotonic()+3
    while True:
        state=receive(clients[1],'State');purple=next(p for p in state['players'] if p['id']==ids[1])
        if purple['effects']['heal_speed_until']>state['tick']:break
        assert time.monotonic()<deadline
    cast_tick=purple['effects']['heal_speed_until']-30
    assert purple['effects']['heal_check_until']==cast_tick+1050
    assert purple['summoners']['ready_at'][0]==cast_tick+7200
    assert purple['perseverance_interrupted_at']==baseline['interrupt'],'Healing should not refresh incoming-damage history'
    regen=json.loads((root/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'))['garen']['health_regen']
    restored=purple['health']-baseline['health']-regen*(state['tick']-baseline['tick'])/30
    assert abs(restored-90)<.005,('Heal magnitude mismatch',restored)
    here=purple['position'];origin_index=min(range(len(points)),key=lambda i:math.hypot(points[i]['x']-here['x'],points[i]['z']-here['z']))
    origin=points[origin_index];candidates=[p for p in points if abs(p['z']-origin['z'])<.01 and 200<=abs(p['x']-origin['x'])<=400]
    assert candidates
    goal=min(candidates,key=lambda p:abs(p['x']-origin['x']-300))
    command(clients[1],5,{'Move':{'point':goal}})
    samples=[];previous=state;deadline=time.monotonic()+3
    while state['tick']<cast_tick+36:
        state=receive(clients[1],'State');purple=next(p for p in state['players'] if p['id']==ids[1]);before=next(p for p in previous['players'] if p['id']==ids[1]);dt=state['tick']-previous['tick']
        if dt>0 and previous['tick']>=cast_tick+3 and state['tick']<cast_tick+27:
            samples.append(math.hypot(purple['position']['x']-before['position']['x'],purple['position']['z']-before['position']['z'])*30/dt)
        previous=state;assert time.monotonic()<deadline
    assert any(abs(speed-441.8)<.03 for speed in samples),('No straight boosted walking sample',samples)
    command(clients[1],6,{'Summoner':{'slot':0}});assert 'cooldown' in receive(clients[1],'Rejected')['reason']
    import hashlib,datetime
    checks=['server-selected Heal loadout replicated','real opposing Q and basic attack create missing HP without injection','level-one Heal restores 90 HP after native base-regeneration subtraction','one-second speed and 35-second recent-heal timer replicated','historical 240-second cooldown replicated','healing does not reset passive interruption history','actual walking reaches 441.8 units per second under current soft-cap reconstruction','repeat cast rejected on cooldown']
    proof={'passed':True,'checks':checks,'observed_heal':restored,'walking_samples':samples,'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Real UDP self-heal/boost only; explicit allied target/recent-heal half magnitude and level endpoints exercised in core fixtures.','Recipient-level policy, center range, exact movement stacking and original-runtime equivalence incompletely qualified.','Full healing modifiers, native particles/audio, cursor input and launcher human acceptance incomplete.']}
    (root/'docs/heal_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':True,'checks':len(checks),'heal':restored,'boost_samples':samples}))
finally:
 for client in clients:client.close()
 if process is not None and process.poll() is None:
    process.terminate()
    try:process.wait(timeout=10)
    except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
