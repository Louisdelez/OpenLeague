"""Real UDP Exhaust: native slow/cadence, outgoing damage, defense shred and Q purge."""
import datetime,hashlib,json,math,os,socket,struct,subprocess,time
from pathlib import Path
import wire
root=Path(__file__).resolve().parents[1];address=('127.0.0.1',5918)
clients=[];process=None;sequences=[0,0]
def send(c,p):c.sendto(json.dumps(p).encode(),address)
def receive(c,kind,timeout=3):
    end=time.monotonic()+timeout
    while time.monotonic()<end:
        try:p=wire.packet(c)
        except (socket.timeout,ConnectionResetError):continue
        if p is not None and kind in p:return p[kind]
    raise AssertionError('No '+kind+' packet')
def command(index,action):
    sequences[index]+=1;send(clients[index],{'Command':{'sequence':sequences[index],'action':action}})
def player(state,index):return next(p for p in state['players'] if p['id']==ids[index])
def wait(predicate,index=0,timeout=4):
    end=time.monotonic()+timeout
    while True:
        state=receive(clients[index],'State')
        if predicate(state):return state
        assert time.monotonic()<end,'State predicate timeout'
def corrected_hit(before,after,target):
    p=player(after,target);initial=player(before,target)
    hit_tick=p['perseverance_interrupted_at'];assert hit_tick>before['tick']
    return initial['health']-p['health']+regen*(after['tick']-hit_tick)/30
try:
    with (root/'logs/exhaust-server.log').open('w') as log:
        process=subprocess.Popen([str(root/'target/debug/openleague-server.exe')],cwd=root,env=dict(os.environ,OPENLEAGUE_SERVER='127.0.0.1:5918'),stdout=log,stderr=log,creationflags=0x08000000 if os.name=='nt' else 0)
        ids=[]
        for index in range(2):
            c=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);c.bind(('127.0.0.1',0));c.settimeout(.1);clients.append(c)
            deadline=time.monotonic()+15
            while True:
                send(c,{'Join':{'champion':'garen','summoners':['Exhaust',None]}})
                try:ids.append(receive(c,'Welcome',.5)['player']);break
                except AssertionError:assert time.monotonic()<deadline
        state=wait(lambda s:len(s['roster'])==2)
        command(0,{'Learn':{'slot':0}})
        for target in (None,ids[0],999999,ids[1]):
            command(0,{'SummonerTarget':{'slot':0,'target':target}})
            rejection=receive(clients[0],'Rejected')['reason'];assert any(token in rejection for token in ('exhaust','Exhaust'))
        state=receive(clients[0],'State');assert player(state,0)['summoners']['ready_at'][0]==0
        meta=json.loads((root/'assets/maps/tt_navigation_grid.json').read_text(encoding='utf-8'));cells=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes()
        points=[{'x':meta['min'][0]+(i%meta['width']+.5)*meta['cellSize'],'z':meta['min'][2]+(i//meta['width']+.5)*meta['cellSize']} for i in range(meta['width']*meta['height']) if struct.unpack_from('<H',cells,i*11+4)[0]&2==0]
        center=min(points,key=lambda p:math.hypot(p['x']-7700,p['z']-7000))
        for index in range(2):command(index,{'Move':{'point':center}})
        deadline=time.monotonic()+75;heartbeat=0
        while True:
            assert process.poll() is None
            if time.monotonic()>heartbeat:
                for c in clients:send(c,{'Join':{'champion':'garen'}})
                heartbeat=time.monotonic()+2
            state=receive(clients[0],'State')
            if len(state['players'])==2 and all(math.hypot(player(state,i)['position']['x']-center['x'],player(state,i)['position']['z']-center['z'])<10 for i in range(2)):break
            assert time.monotonic()<deadline,'Navigation convergence timeout'
        for index in range(2):command(index,'Stop')
        state=wait(lambda s:s['tick']>=state['tick']+6)
        definition=next(p for p in json.loads((root/'data/4.20/champions.json').read_text(encoding='utf-8')) if p['id']=='garen')
        growth=json.loads((root/'data/4.20/champion_growth_420.json').read_text(encoding='utf-8'))['garen'];regen=growth['health_regen']
        baseline=state
        command(0,{'SummonerTarget':{'slot':0,'target':ids[1]}})
        state=wait(lambda s:player(s,1)['effects']['exhaust_until']>s['tick'])
        cast_tick=player(state,1)['effects']['exhaust_until']-75
        assert player(state,0)['summoners']['ready_at'][0]==cast_tick+6300
        assert player(state,1)['perseverance_interrupted_at']==cast_tick
        slow=next(x for x in player(state,1)['slows'] if x['tag']=='SummonerExhaustSlow')
        assert abs(slow['fraction']-.3)<.0001 and slow['expires_at']==cast_tick+75
        assert player(state,1)['health']==player(baseline,1)['health'],'Exhaust itself should not damage'
        baseline=state;command(0,{'Attack':{'target':ids[1]}})
        state=wait(lambda s:player(s,1)['health']<player(baseline,1)['health']-.01)
        command(0,'Stop')
        shred_damage=corrected_hit(baseline,state,1)
        expected_shred=definition['attack_damage']*100/(100+definition['armor']-10)
        assert abs(shred_damage-expected_shred)<.006,('Defense shred',shred_damage,expected_shred)
        here=player(state,1)['position'];origin=min(points,key=lambda p:math.hypot(p['x']-here['x'],p['z']-here['z']))
        candidates=[p for p in points if abs(p['z']-origin['z'])<.01 and 100<=p['x']-origin['x']<=150];assert candidates
        goal=min(candidates,key=lambda p:abs(p['x']-origin['x']-100))
        command(1,{'Move':{'point':goal}});samples=[];previous=state;move_start=state['tick']
        while state['tick']<move_start+18:
            state=receive(clients[0],'State');p=player(state,1);old=player(previous,1);dt=state['tick']-previous['tick']
            if dt>0 and previous['tick']>=move_start+3:
                samples.append(math.hypot(p['position']['x']-old['position']['x'],p['position']['z']-old['position']['z'])*30/dt)
            previous=state
        assert any(abs(v-241.5)<.03 for v in samples),('Slow walking',samples)
        command(1,'Stop');state=wait(lambda s:s['tick']>=state['tick']+3)
        baseline=state;command(1,{'Attack':{'target':ids[0]}})
        cadence=None;deadline=time.monotonic()+4
        while True:
            state=receive(clients[0],'State');attacker=player(state,1)
            if attacker['windup'] is not None:
                cadence=attacker['next_attack']-attacker['windup']['started']
            if player(state,0)['health']<player(baseline,0)['health']-.01:break
            assert time.monotonic()<deadline
        command(1,'Stop')
        expected_cadence=max(12,round(definition['attack_cooldown_ticks']/.7))
        assert cadence==expected_cadence,('Reduced attack speed',cadence,expected_cadence)
        reduced_damage=corrected_hit(baseline,state,0)
        expected_reduced=definition['attack_damage']*.6*100/(100+definition['armor'])
        assert state['tick']<cast_tick+75 and abs(reduced_damage-expected_reduced)<.006,('Outgoing reduction',reduced_damage,expected_reduced)
        command(0,{'SummonerTarget':{'slot':0,'target':ids[1]}});assert 'cooldown' in receive(clients[0],'Rejected')['reason']
        state=wait(lambda s:s['tick']>=cast_tick+78)
        assert not player(state,1)['slows']
        # Fresh opposing caster applies Exhaust to Garen; Q only purges its slow.
        command(1,{'SummonerTarget':{'slot':0,'target':ids[0]}})
        state=wait(lambda s:player(s,0)['effects']['exhaust_until']>s['tick'])
        second_tick=player(state,0)['effects']['exhaust_until']-75
        command(0,{'Cast':{'slot':0,'target':None}})
        state=wait(lambda s:player(s,0)['effects']['empowered_until']>s['tick'])
        assert not player(state,0)['slows'] and player(state,0)['effects']['exhaust_until']==second_tick+75
        baseline=state;command(0,{'Attack':{'target':ids[1]}})
        state=wait(lambda s:player(s,1)['health']<player(baseline,1)['health']-.01)
        command(0,'Stop');q_damage=corrected_hit(baseline,state,1)
        native=next(p for p in json.loads((root/'data/4.20/native_spells_420.json').read_text(encoding='utf-8')) if p['champion'].lower()=='garen' and p['slot']==0)
        expected_q=(1.4*definition['attack_damage']+float(native['values']['Effect1Level1Amount']))*.6*100/(100+definition['armor'])
        # Baseline wound can regenerate between observations before the impact; subtract it.
        elapsed=player(state,1)['perseverance_interrupted_at']-baseline['tick']
        q_damage+=regen*elapsed/30
        assert abs(q_damage-expected_q)<.01,('Q damage stays reduced after slow purge',q_damage,expected_q)
        checks=['Exhaust loadout server-selected for two real opposing players','missing/self/unknown/out-of-range enemy casts rejected without cooldown','targeted Exhaust replicates native 75-tick duration and 6300-tick cooldown','non-damaging enemy ability interrupts Garen passive without removing HP','actual ordinary incoming attack uses target armor reduced by 10','native-grid walking measures 241.5 under 30 percent slow','real attack windup uses period with 30 percent AS bonus penalty','actual outgoing ordinary attack reduced by 40 percent','repeat cast rejected and expired slow removed','opposing Exhaust plus Garen Q removes only slow and preserves debuff','actual empowered Q damage remains reduced after slow purge']
        proof={'passed':True,'checks':checks,'defense_shred_hit':shred_damage,'expected_defense_shred_hit':expected_shred,'slow_walk_samples':samples,'attack_cadence_ticks':cadence,'outgoing_hit':reduced_damage,'expected_outgoing_hit':expected_reduced,'q_after_purge_hit':q_damage,'expected_q_after_purge_hit':expected_q,'server_sha256':hashlib.sha256((root/'target/debug/openleague-server.exe').read_bytes()).hexdigest(),'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'limits':['Current reconstruction verified, not original Riot runtime equivalence.','Magic resistance/magical damage, world target, true damage, W/shield/tenacity and multiple-caster refresh covered in core fixtures, not this live scenario.','Native particles/audio and human cursor/launcher input unqualified; full Exhaust modifiers and all summoners incomplete.']}
        (root/'docs/exhaust_network_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':True,'checks':len(checks),'walking':samples,'shred_damage':shred_damage,'reduced_damage':reduced_damage,'cadence':cadence,'q_after_purge':q_damage}))
finally:
    for c in clients:c.close()
    if process is not None and process.poll() is None:
        process.terminate()
        try:process.wait(timeout=10)
        except subprocess.TimeoutExpired:process.kill();process.wait(timeout=10)
