from pathlib import Path
import sys,json,struct,hashlib,heapq
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from lupa.lua51 import LuaRuntime
import lupa
r=Path('E:/OpenLeague');audit=json.loads((r/'data/4.20/endgame_lua_source_audit.json').read_text());raw=Path(audit['source']).read_bytes();assert hashlib.sha256(raw).hexdigest()==audit['sha256']
assert raw[:12]==bytes.fromhex('1b4c75615100010404040800')
def adapt(size_t):
 cursor=[12];out=bytearray(bytes.fromhex('1b4c756151000104')+bytes([size_t])+bytes.fromhex('040800'));words=[]
 def read(n):
  start=cursor[0];cursor[0]+=n;b=raw[start:cursor[0]];assert len(b)==n;return b
 def count():
  b=read(4);out.extend(b);return struct.unpack('<I',b)[0]
 def string():
  n=struct.unpack('<I',read(4))[0];out.extend(n.to_bytes(size_t,'little'));out.extend(read(n))
 def function():
  string();out.extend(read(12));n=count();code=read(n*4);words.append(hashlib.sha256(code).hexdigest());out.extend(code)
  for _ in range(count()):
   tag=read(1);out.extend(tag)
   if tag==bytes([1]):out.extend(read(1))
   elif tag==bytes([3]):out.extend(read(8))
   elif tag==bytes([4]):string()
   else:assert tag==bytes([0])
  for _ in range(count()):function()
  out.extend(read(count()*4))
  for _ in range(count()):string();out.extend(read(8))
  for _ in range(count()):string()
 function();assert cursor[0]==len(raw);return bytes(out),words
original,original_words=adapt(4);adapted,adapted_words=adapt(8);assert original==raw;assert original_words==adapted_words
runtime=LuaRuntime(encoding=None);assert runtime.eval(b'_VERSION')==b'Lua 5.1';assert runtime.eval(b'string.dump(function() end)')[:12]==adapted[:12]
timing=json.loads((r/'data/4.20/native_endgame_default_timing.json').read_text());native={c['name']:c['value'] for c in timing['cases']}
cases=[]
for winner in [100,200]:
 for champions in [0,1,6,12]:
  for death_animation in [False,True]:
   L=LuaRuntime(encoding=None,unpack_returned_tuples=True);g=L.globals();clock=[0.];log=[];timers=[];serial=[0];hq={100:'orderHQ',200:'chaosHQ'};loser=300-winner;point={'x':12379.5439453125 if loser==200 else 2981.038818359375,'y':13.884383201599121,'z':7289.94091796875}
   def value(v):
    if isinstance(v,bytes):return v.decode('utf-8')
    if v is None or isinstance(v,(bool,int,float,str)):return v
    try:return {str(value(k)):value(v[k]) for k in v.keys()}
    except AttributeError:return repr(v)
   def record(name,*args):log.append(dict(time=clock[0],name=name,args=[value(v) for v in args]))
   def observe(name):return lambda *args:record(name,*args)
   # Engine APIs are deliberately adapters; bytecode itself is executed by Lua5.1.
   for f in audit['prototype']['functions']:
    for name in f['constants']:
     if isinstance(name,str) and name.startswith('INPUT_LOCK_'):g[name.encode()]=name.encode()
   g[b'TEAM_ORDER']=100;g[b'TEAM_CHAOS']=200
   for name in ['SetInvulnerable','SetTargetable','SetBuildingHealthRegenEnabled','SetInputLockFlag','DisableHUDForEndOfGame','SetBarracksSpawnEnabled','CloseShop','HaltAllAI','MoveCameraFromCurrentPositionToPoint','SetGreyscaleEnabledWhenDead','FadeOutMainSFX','SetHQCurrentSkin','FadeMinions','SetMinionsNoRender','EndGame']:g[name.encode()]=observe(name)
   def get_hq(team):record('GetHQ',team);return hq[team].encode()
   def get_position(actor):record('GetPosition',actor);assert actor==hq[loser].encode();return L.table_from({k.encode():v for k,v in point.items()})
   def for_each(*args):
    record('LuaForEachChampion',*args);assert len(args)==2 and args[0]==0
    callback=g[args[1]] if isinstance(args[1],bytes) else args[1]
    for i in range(champions):callback(f'champion{i}'.encode())
   def init_timer(name,delay,*extra):
    record('InitTimer',name,delay,*extra);assert isinstance(name,bytes) and delay>=0 and extra==(False,);serial[0]+=1;heapq.heappush(timers,(clock[0]+delay,serial[0],name))
   g[b'GetHQ']=get_hq;g[b'GetPosition']=get_position;g[b'LuaForEachChampion']=for_each;g[b'InitTimer']=init_timer
   g[b'GetEoGPanToHQTime']=lambda:native['pan'];g[b'GetEoGNexusChangeSkinTime']=lambda:native['nexus_skin'];g[b'GetEoGUseNexusDeathAnimation']=lambda:death_animation
   L.execute(adapted);g[b'EndOfGameCeremony'](winner,hq[loser].encode())
   def step(now):
    while timers and timers[0][0]<=now:
     due,_,name=heapq.heappop(timers);clock[0]=due;g[name]()
    clock[0]=now
   for now in [.999999,1.,3.499999,3.5,5.499999,5.5]:
    step(now)
    assert all(row['time']>=1. for row in log if row['name']=='FadeOutMainSFX')
    assert all(row['time']>=3.5 for row in log if row['name'] in ['SetHQCurrentSkin','FadeMinions'])
    assert all(row['time']>=5.5 for row in log if row['name'] in ['SetMinionsNoRender','EndGame'])
   calls=lambda name:[row for row in log if row['name']==name]
   cameras=calls('MoveCameraFromCurrentPositionToPoint');assert len(cameras)==champions;assert all(row['time']==0. and row['args']==[f'champion{i}',point,3.,True] for i,row in enumerate(cameras)), cameras
   assert calls('SetGreyscaleEnabledWhenDead')==[dict(time=0.,name='SetGreyscaleEnabledWhenDead',args=[f'champion{i}',False]) for i in range(champions)]
   locks=['CAMERALOCKING','CAMERAMOVEMENT','ABILITIES','SUMMONERSPELLS','MOVEMENT','SHOP','MINIMAPMOVEMENT']
   assert calls('SetInputLockFlag')==[dict(time=0.,name='SetInputLockFlag',args=['INPUT_LOCK_'+name,True]) for name in locks]+[dict(time=5.5,name='SetInputLockFlag',args=['INPUT_LOCK_CHAT',True])]
   assert calls('SetBarracksSpawnEnabled')==[dict(time=0.,name='SetBarracksSpawnEnabled',args=[False])]
   for name,enabled in [('SetInvulnerable',True),('SetTargetable',False),('SetBuildingHealthRegenEnabled',False)]:
    assert calls(name)==[dict(time=0.,name=name,args=[hq[team],enabled]) for team in [100,200]]
   assert calls('HaltAllAI')==[dict(time=0.,name='HaltAllAI',args=[])]
   assert calls('FadeOutMainSFX')==[dict(time=1.,name='FadeOutMainSFX',args=[2.])]
   assert calls('FadeMinions')==[dict(time=3.5,name='FadeMinions',args=[loser,0.,2.])], {'winner':winner,'death_animation':death_animation,'fade':calls('FadeMinions'),'skin':calls('SetHQCurrentSkin')}
   assert calls('SetMinionsNoRender')==[dict(time=5.5,name='SetMinionsNoRender',args=[loser,True])], calls('SetMinionsNoRender')
   assert calls('EndGame')==[dict(time=5.5,name='EndGame',args=[winner])], calls('EndGame')
   assert calls('SetHQCurrentSkin')==([] if death_animation else [dict(time=3.5,name='SetHQCurrentSkin',args=[loser,1])]), {'death_animation':death_animation,'skin':calls('SetHQCurrentSkin')}
   assert not timers
   cases.append(dict(winner=winner,loser=loser,champions=champions,use_death_animation=death_animation,calls=log))
d=dict(source=audit['source'],source_sha256=audit['sha256'],runtime='Lua 5.1',lupa_version=lupa.__version__,adapted_sha256=hashlib.sha256(adapted).hexdigest(),source_roundtrip_exact=True,instruction_arrays_preserved=True,instruction_array_sha256=original_words,cases=cases,complete=False,limits=['Actual original instruction arrays executed by bundled Lua5.1 VM. Only size_t string length fields adapted from32 to64bits; no Lua instruction or numeric constant changed. This is not the original game embedded VM binary.','Engine APIs, champion iteration, HQ descriptors, symbolic input-lock values and timers are adapters. Original registration, message delivery, fade interpolation/audio mixing, rendering and latency not executed.','Default death-animation=false is native getter-qualified. True branch executes original Lua instructions but original configuration overrides remain unqualified.','Simulated timers prove requested callback deadlines and Lua call order, not the native timer scheduler implementation.'])
Path('E:/mapslol3v3/native_endgame_lua51_contract.json').write_text(json.dumps(d,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(dict(cases=len(cases),source_roundtrip_exact=True,instruction_arrays_preserved=True,default_false_cases=sum(not c['use_death_animation'] for c in cases),complete=False)))
