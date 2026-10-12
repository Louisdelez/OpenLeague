import wire
"""Exercise the real OpenLeague server over UDP; no injected health, XP or damage."""
import json,socket,subprocess,time,math,struct,os
from pathlib import Path
root=Path(__file__).resolve().parents[1]
address=('127.0.0.1',5897)
env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5897')
output=root/'logs/network-server.log';output.parent.mkdir(exist_ok=True)
clients=[];process=None
def send(client,message):client.sendto(json.dumps(message).encode(),address)
def receive(client,kind,timeout=3):
    end=time.monotonic()+timeout
    while time.monotonic()<end:
        try:packet=wire.packet(client)
        except (socket.timeout,ConnectionResetError):continue
        if packet is not None and kind in packet:return packet[kind]
    raise AssertionError('No packet '+kind)
def distance(a,b):return math.hypot(a['x']-b['x'],a['z']-b['z'])
try:
    with output.open('w') as log:
        process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=env,stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
        (root/'logs/network_process.json').write_text(json.dumps({'pid':process.pid,'executable':str(root/'target/debug/openleague-server.exe')}))
        ids=[]
        for champion in ['garen','ahri','annie','ashe','amumu','alistar']:
            client=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);client.bind(('127.0.0.1',0));client.settimeout(.2);clients.append(client)
            deadline=time.monotonic()+15
            while True:
                assert process.poll() is None,'Server exited before connection'
                send(client,{'Join':{'champion':champion}})
                try:welcome=receive(client,'Welcome',timeout=.5);break
                except AssertionError:
                    if time.monotonic()>=deadline:raise
            ids.append(welcome['player'])
        initial=receive(clients[0],'State')
        while len(initial['roster'])<6:initial=receive(clients[0],'State')
        assert len(set(ids))==6
        assert sorted(p['team'] for p in initial['roster'])==[0,0,0,1,1,1]
        extra=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);extra.bind(('127.0.0.1',0));extra.settimeout(.2);clients.append(extra)
        send(extra,{'Join':{'champion':'garen'}});assert 'full' in receive(extra,'Rejected')['reason']
        player=next(p for p in initial['players'] if p['id']==ids[0]);start=player['position']
        metadata=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding="utf-8"));binary=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes()
        width=metadata['width'];cell=metadata['cellSize'];minx,minz=metadata['min'][0],metadata['min'][2]
        x=int((start['x']-minx)//cell);z=int((start['z']-minz)//cell)
        goals=[]
        for dx,dz in [(2,0),(-2,0),(0,2),(0,-2)]:
            tx,tz=x+dx,z+dz
            if 0<=tx<width and 0<=tz<metadata['height']:
                index=tz*width+tx
                if struct.unpack_from('<H',binary,index*11+4)[0]&2==0:goals.append({'x':minx+(tx+.5)*cell,'z':minz+(tz+.5)*cell})
        assert goals,'No nearby walkable destination'
        send(clients[0],{'Command':{'sequence':1,'action':{'Move':{'point':goals[0]}}}})
        send(clients[0],{'Command':{'sequence':1,'action':'Stop'}})
        finish=None;end=time.monotonic()+2
        while time.monotonic()<end:
            snapshot=receive(clients[0],'State');current=next(p for p in snapshot['players'] if p['id']==ids[0])
            if distance(start,current['position'])>25:finish=snapshot;break
        assert finish is not None,'No authoritative movement'
        send(clients[0],{'Command':{'sequence':2,'action':{'Attack':{'target':ids[2]}}}})
        assert 'enemy' in receive(clients[0],'Rejected')['reason']
        send(clients[0],{'Command':{'sequence':3,'action':{'Move':{'point':{'x':-100000,'z':-100000}}}}})
        assert 'unreachable' in receive(clients[0],'Rejected')['reason']
        send(clients[0],{'Command':{'sequence':4,'action':{'Learn':{'slot':3}}}})
        assert 'higher level' in receive(clients[0],'Rejected')['reason']
        send(clients[0],{'Command':{'sequence':5,'action':{'Cast':{'slot':0,'target':None}}}})
        assert 'not learned' in receive(clients[0],'Rejected')['reason']
        send(clients[0],{'Command':{'sequence':6,'action':{'Learn':{'slot':0}}}})
        deadline=time.monotonic()+3
        while True:
            state=receive(clients[0],'State');garen=next(p for p in state['players'] if p['id']==ids[0])
            if garen['ranks'][0]==1:break
            assert time.monotonic()<deadline,'Skill learning not replicated'
        send(clients[0],{'Command':{'sequence':7,'action':{'Learn':{'slot':1}}}})
        assert 'no skill points' in receive(clients[0],'Rejected')['reason']
        send(clients[0],{'Command':{'sequence':8,'action':{'Cast':{'slot':0,'target':None}}}})
        deadline=time.monotonic()+3
        while True:
            state=receive(clients[0],'State');garen=next(p for p in state['players'] if p['id']==ids[0])
            if garen['cooldowns'][0]>state['tick']:
                assert garen['effects']['empowered_until']>state['tick'];break
            assert time.monotonic()<deadline,'Spell effects not replicated'
        send(clients[0],{'Command':{'sequence':9,'action':{'Cast':{'slot':0,'target':None}}}})
        assert 'cooldown' in receive(clients[0],'Rejected')['reason']
        send(clients[1],{'Command':{'sequence':1,'action':{'Cast':{'slot':0,'target':None}}}})
        assert 'not implemented' in receive(clients[1],'Rejected')['reason']
        clients[0].sendto(b'{"unknown":true}',address)
        assert 'unsupported' in receive(clients[0],'Rejected')['reason']
        # A closed local UDP peer must not bring down the remaining match on Windows.
        clients[2].close();time.sleep(.15)
        assert process.poll() is None,'Server exited on disconnected UDP peer'
        receive(clients[0],'State')
        receipt={'passed':True,'checks':['six distinct player identities','3v3 team allocation','seventh player rejected','movement server-owned on native grid','replayed sequence ignored','friendly attack rejected','out-of-map destination rejected','R rejected before level six','unlearned skill rejected','learned rank replicated','skill point budget enforced','native Q buff and cooldown replicated','repeat cast rejected on cooldown','unsupported kit explicitly rejected','malformed packet explicitly rejected','closed UDP peer does not crash match'],'initial':initial,'after_movement':finish,'limits':'Does not validate complete champion kits, combat timing, retransmission, full matches or visual fidelity.'}
        (root/'docs/network_validation.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
        print(json.dumps({'passed':True,'checks':len(receipt['checks'])}))
finally:
    for client in clients:client.close()
    if process is not None and process.poll() is None:
        process.terminate()
        try:process.wait(timeout=10)
        except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
