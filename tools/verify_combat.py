import wire
"""Exercise movement into combat and native Q against two actual UDP-owned champions."""
import json,socket,subprocess,time,os,math,struct
from pathlib import Path
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5898)
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
 with (root/'logs/combat-server.log').open('w') as log:
    process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5898'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
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
    assert purple['effects']['silence_until']>state['tick'],'Q did not silence opponent'
    command(clients[1],4,{'Cast':{'slot':0,'target':None}})
    assert 'silenced' in receive(clients[1],'Rejected')['reason']
    receipt={'passed':True,'checks':['two UDP-owned opposing champions','both players move through native grid into shared visibility and combat range','learned Q applies real combat damage','Q silence replicated','silenced opponent cast rejected'],'damage':initial_health-purple['health'],'snapshot':state,'limits':'Validates level-one Garen Q and basic attack only; does not qualify a full champion kit or full match.'}
    (root/'docs/combat_validation.json').write_text(json.dumps(receipt,indent=2));print(json.dumps({'passed':True,'checks':len(receipt['checks']),'damage':receipt['damage']}))
finally:
 for client in clients:client.close()
 if process is not None and process.poll() is None:
    process.terminate()
    try:process.wait(timeout=10)
    except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
