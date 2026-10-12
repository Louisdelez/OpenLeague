"""Three real UDP players: targeted ally Heal and recent-Heal reduction after actual combat."""
import datetime, hashlib, json, math, os, socket, struct, subprocess, time
from pathlib import Path
import wire
root=Path(__file__).resolve().parents[1]
address=('127.0.0.1',5917)
clients=[]
process=None
sequences=[0,0,0]

def send(c,p): c.sendto(json.dumps(p).encode(),address)
def receive(c,kind,timeout=3):
    end=time.monotonic()+timeout
    while time.monotonic()<end:
        try: p=wire.packet(c)
        except (socket.timeout,ConnectionResetError): continue
        if p is not None and kind in p: return p[kind]
    raise AssertionError('No '+kind+' packet')
def command(index,action):
    sequences[index]+=1
    send(clients[index],{'Command':{'sequence':sequences[index],'action':action}})
def player(state,index): return next(p for p in state['players'] if p['id']==ids[index])
def wait(predicate,index=0,timeout=4):
    end=time.monotonic()+timeout
    while True:
        state=receive(clients[index],'State')
        if predicate(state): return state
        assert time.monotonic()<end,'State predicate timed out'
def reject(index,target):
    command(index,{'SummonerTarget':{'slot':0,'target':target}})
    assert 'heal ally' in receive(clients[index],'Rejected')['reason']
    s=receive(clients[index],'State')
    assert player(s,index)['summoners']['ready_at'][0]==0
    return s

def regeneration(p,start,end):
    # Server advance increments its tick before applying regeneration; exact current formula.
    rate=json.loads((root/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'))['garen']['health_regen']
    return sum((rate+(p['max_health']*.004 if p['perseverance_interrupted_at'] is None or t-p['perseverance_interrupted_at']>=270 else 0))/30 for t in range(start+1,end+1))

try:
    with (root/'logs/heal-ally-server.log').open('w') as log:
        process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5917'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
        ids=[]
        for index in range(3):
            c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c)
            packet={'Join':{'champion':'garen','summoners':['Heal',None] if index in (0,2) else [None,None]}}
            deadline=time.monotonic()+15
            while True:
                send(c,packet)
                try: ids.append(receive(c,'Welcome',.5)['player']);break
                except AssertionError: assert time.monotonic()<deadline
        state=wait(lambda s:len(s['roster'])==3)
        teams={p['id']:p['team'] for p in state['roster']}
        assert teams[ids[0]]==teams[ids[2]]!=teams[ids[1]]
        reject(0,ids[1]);reject(0,999999);reject(0,ids[0])
        meta=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'))
        cells=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes()
        points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0]
        center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
        command(2,{'Move':{'point':center}})
        state=wait(lambda s:math.hypot(player(s,0)['position']['x']-player(s,2)['position']['x'],player(s,0)['position']['z']-player(s,2)['position']['z'])>850,timeout=12)
        reject(0,ids[2])
        for index in range(3): command(index,{'Move':{'point':center}})
        deadline=time.monotonic()+75;heartbeat=0
        while True:
            assert process.poll() is None
            if time.monotonic()>heartbeat:
                for c in clients:send(c,{'Join':{'champion':'garen'}})
                heartbeat=time.monotonic()+2
            state=receive(clients[0],'State')
            if len(state['players'])==3 and all(math.hypot(player(state,i)['position']['x']-center['x'],player(state,i)['position']['z']-center['z'])<60 for i in range(3)): break
            assert time.monotonic()<deadline,'Native-grid convergence timed out'
        for index in range(3): command(index,'Stop')
        # Enemy basic attacks naturally wound both allies; no authoritative state injection.
        for victim in (0,2):
            start=player(state,victim)['health']
            command(1,{'Attack':{'target':ids[victim]}})
            state=wait(lambda s:start-player(s,victim)['health']>190,timeout=12)
            command(1,'Stop')
            stopped_tick=state['tick']
            state=wait(lambda s:s['tick']>=stopped_tick+36)
        assert all(player(state,i)['max_health']-player(state,i)['health']>140 for i in (0,2))
        # Drain stale snapshots before observing each cast.
        state=wait(lambda s:s['tick']>=state['tick']+3)
        baseline=state
        command(0,{'SummonerTarget':{'slot':0,'target':ids[2]}})
        state=wait(lambda s:player(s,0)['effects']['heal_speed_until']>s['tick'])
        cast_tick=player(state,0)['effects']['heal_speed_until']-30
        first={}
        for index in (0,2):
            p=player(state,index);before=player(baseline,index)
            amount=p['health']-before['health']-regeneration(before,baseline['tick'],state['tick'])
            assert abs(amount-90)<.008,('First allied heal',index,amount)
            assert p['effects']['heal_check_until']==cast_tick+1050
            assert p['effects']['heal_speed_until']==cast_tick+30
            first[index]=amount
        assert player(state,1)['effects']['heal_check_until']==0
        assert player(state,0)['summoners']['ready_at'][0]==cast_tick+7200
        assert player(state,2)['summoners']['ready_at'][0]==0
        baseline=state
        command(2,{'SummonerTarget':{'slot':0,'target':ids[0]}})
        state=wait(lambda s:player(s,2)['summoners']['ready_at'][0]>s['tick'])
        second_tick=player(state,2)['effects']['heal_speed_until']-30
        second={}
        for index in (0,2):
            p=player(state,index);before=player(baseline,index)
            amount=p['health']-before['health']-regeneration(before,baseline['tick'],state['tick'])
            assert abs(amount-45)<.008,('Recent allied heal',index,amount)
            assert p['effects']['heal_check_until']==second_tick+1050
            assert p['effects']['heal_speed_until']==second_tick+30
            second[index]=amount
        assert player(state,2)['summoners']['ready_at'][0]==second_tick+7200
        command(2,{'SummonerTarget':{'slot':0,'target':ids[0]}})
        assert 'cooldown' in receive(clients[2],'Rejected')['reason']
        checks=['three owned UDP identities and allied/enemy team allocation','enemy/unknown/self explicit targets rejected without cooldown','out-of-range actual moving allied target rejected without cooldown','both allied targets wounded by real opposing ordinary attacks without injected HP','explicit allied target and caster each restore 90 HP after exact current regeneration subtraction','one-second speed and 35-second recent timer replicated on both allies','enemy does not receive Heal effect and allied recipient cooldown remains ready','second ally casts and each recent recipient restores 45 HP','recent timer and movement boost refresh without magnitude stacking','second caster receives 240-second cooldown and repeat is rejected']
        proof={'passed':True,'checks':checks,'first_healing':first,'recent_healing':second,'first_cast_tick':cast_tick,'second_cast_tick':second_tick,'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Verifies current server reconstruction via real UDP, not original Riot runtime equivalence.','Human cursor/launcher selection, native FX/audio, general healing modifiers and level/range/contact policies remain incompletely qualified.','Exact expiry boundary, dead target and level endpoints remain core fixtures rather than this live scenario.']}
        (root/'docs/heal_ally_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
        print(json.dumps({'passed':True,'checks':len(checks),'first':first,'recent':second}))
finally:
    for c in clients:c.close()
    if process is not None and process.poll() is None:
        process.terminate()
        try:process.wait(timeout=10)
        except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
