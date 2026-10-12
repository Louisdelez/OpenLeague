from pathlib import Path
import sys,json,hashlib,datetime
sys.path.insert(0,'E:/OpenLeague/tools');from native_lua import Chunk,initialization
deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy')
paths=list((deploy/'LEVELS/Map10/Scripts').glob('*.luaobj'))
for name in ['TT_OrderInhibitor','TT_ChaosInhibitor','OrderInhibitor','ChaosInhibitor']:
 paths+=list((deploy/'DATA/Characters'/name/'Scripts').glob('*.luaobj'))
records=[]
for p in paths:
 raw=p.read_bytes();chunk=Chunk(raw);proto=chunk.function();assert chunk.i==len(raw)
 findings=[]
 def visit(f):
  strings=[c for c in f['constants'] if isinstance(c,str) and any(word in c.lower() for word in ['inhib','barrack','respawn'])]
  if strings:findings.append(dict(lines=f['lines'],matching_strings=strings,constants=f['constants']))
  for child in f['functions']:visit(child)
 visit(proto)
 named_functions={}
 for pc,word in enumerate(proto['code'][:-1]):
  if word&63!=36:continue
  following=proto['code'][pc+1]
  if following&63==7 and (following>>6)&255==(word>>6)&255:
   name=proto['constants'][following>>14]
   if name in ['GetDisableMinionSpawnTime','DisableBarracksSpawn','BarrackReactiveEvent','HandleDestroyedObject']:named_functions[name]=proto['functions'][word>>14]
 records.append(dict(path=str(p),sha256=hashlib.sha256(raw).hexdigest(),findings=findings,initialization=initialization(proto),named_functions=named_functions))
level=next(record for record in records if record['path'].endswith('LevelScript.luaobj'));globals=level['initialization']['globals']
assert globals['DISABLE_MINION_SPAWN_BASE_TIME']==240. and globals['DISABLE_MINION_SPAWN_MAG_TIME']==0.
f=level['named_functions']['GetDisableMinionSpawnTime'];assert [(word&63) for word in f['code']]==[5,0,0,28,7,5,5,5,6,14,12,30,30]
timer_cases=[]
for disables in [0,1,2,5,10]:
 registers={0:0,1:100};env=dict(globals,GetLuaBarracks=lambda team,lane:{'NumOfSpawnDisables':disables});result=None
 for pc,word in enumerate(f['code']):
  op=word&63;a=(word>>6)&255;b=(word>>23)&511;c=(word>>14)&511;bx=word>>14
  operand=lambda i:f['constants'][i-256] if i>=256 else registers[i]
  if op==5:registers[a]=env[f['constants'][bx]]
  elif op==0:registers[a]=registers[b]
  elif op==28:
   assert b==3 and c==2;registers[a]=registers[a](registers[a+1],registers[a+2])
  elif op==7:env[f['constants'][bx]]=registers[a]
  elif op==6:registers[a]=registers[b][operand(c)]
  elif op==14:registers[a]=operand(b)*operand(c)
  elif op==12:registers[a]=operand(b)+operand(c)
  elif op==30:assert b==2;result=registers[a];break
  else:raise ValueError(op)
 assert result==240.;timer_cases.append(dict(prior_spawn_disables=disables,native_bytecode_duration_seconds=result))
report=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,files=records,qualified_barrack_spawn_disable_seconds=240,barrack_duration_cases=timer_cases,qualified_native_inhibitor_respawn_seconds=None,current_core_assumption_seconds=240,limits=['Original timer-function bytecode interpreted with explicit GetLuaBarracks adapter for five prior-disable counts; original Lua VM not executed.','Native minion-spawn suppression duration is240seconds. This does not prove inhibitor regeneration timer/anchor or native SetDisableMinionSpawn/SetDampenerState callbacks.','Current Rust inhibitor respawn uses240seconds; its native lifecycle/anchor remains unqualified.'])
Path('E:/mapslol3v3/map10_inhibitor_timer_source_audit.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(dict(files=len(records),spawn_disable_seconds=240,timer_cases=timer_cases,inhibitor_respawn_qualified=False)))
