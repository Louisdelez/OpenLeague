from pathlib import Path
import json,struct,itertools,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x7000;local=heap+0x8000;table=heap+0x9000;getter=end+0x200
write32(actor+0x124,table);write32(local+0x124,table);write32(table+12,getter);calls=[];teams={}
def capture(uc,a,size,user):
 if a==getter:
  identity=u.reg_read(UC_X86_REG_ECX)-0x124;calls.append('actor' if identity==actor else 'local');finish(eax=teams[identity]);return
 assert 0x6d3630<=a<0x6d36e0,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
cases=[]
for actor_team,local_team,mode in itertools.product([None,100,200,300],[None,100,200,300],[0,1,2,4]):
 teams={actor:actor_team,local:local_team};calls=[];write32(0x2d77f48,local if local_team is not None else 0);write32(0x2d79058,mode)
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,actor if actor_team is not None else 0));u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x6d3630,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 address=u.reg_read(UC_X86_REG_EAX);value=cbytes(address).decode('ascii')
 if actor_team is not None and local_team is not None:assert value==('YourTeam' if actor_team==local_team else 'EnemyTeam')
 cases.append({'actor_team':actor_team,'local_team':local_team,'mode':mode,'output':value,'output_address':hex(address),'getter_calls':list(calls)})
proof={'native_sha256':digest,'function':'0x6D3630','passed':True,'complete':False,'cases':cases,'limits':['Original control flow and returned native literals executed; actor/local virtual team getter explicitly supplied.','Selection of this function by template evaluator and full template parsing remain unqualified.','No announcement scheduling, voice or playback claim.']}
(r/'data/4.20/audio_announcer_team_tokens_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_team_tokens.py'),r/'tools/qualify_announcer_team_tokens.py');print(json.dumps({'native_cases':len(cases),'outputs':sorted({c['output'] for c in cases})}))
