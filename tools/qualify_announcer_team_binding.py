from pathlib import Path
import json,struct,itertools,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x7000;local=heap+0x8000;table=heap+0x9000;getter=end+0x200;output=heap+0x6000;input_address=heap+0x5000
write32(actor+0x124,table);write32(local+0x124,table);write32(table+12,getter)
pattern=cbytes(0x10a718c).decode();assert pattern==' your team | enemy team@'
# Binding is an actual native instruction sequence, not a pattern/function guess.
assert bytes(u.mem_read(0x6d4b2e,5))==b'\x68'+struct.pack('<I',0x6d3630)
assert bytes(u.mem_read(0x6d4b34,5))==b'\x68'+struct.pack('<I',0x10a718c)
calls=[];appends=[];teams={}
def capture(uc,a,size,user):
 if a==getter:
  identity=u.reg_read(UC_X86_REG_ECX)-0x124;calls.append('actor' if identity==actor else 'local');finish(eax=teams[identity]);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);ptr,n=read32(sp+4),read32(sp+8);assert u.reg_read(UC_X86_REG_ECX)==output;appends.append(bytes(u.mem_read(ptr,n)).decode('ascii'));finish(8,output);return
 assert 0x400000<=a<0x1000000,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
cases=[]
for actor_team,local_team,mode,token in itertools.product([None,100,200,300],[None,100,200,300],[0,1,2,4],[pattern,pattern+'Trailing',pattern.upper(),' wrong token@']):
 teams={actor:actor_team,local:local_team};calls=[];appends=[];write32(0x2d77f48,local if local_team is not None else 0);write32(0x2d79058,mode)
 u.mem_write(input_address,token.encode()+b'\0');sp=stack+0x8000;u.mem_write(sp,struct.pack('<IIII',end,0x10a718c,actor if actor_team is not None else 0,0x6d3630));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,output);u.emu_start(0x6ed1f0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 matched=bool(u.reg_read(UC_X86_REG_EAX)&255);assert matched==token.lower().startswith(pattern),(token,matched)
 cases.append({'actor_team':actor_team,'local_team':local_team,'mode':mode,'input':token,'matched':matched,'appends':list(appends),'getter_calls':list(calls)})
proof={'native_sha256':digest,'function':'0x6ED1F0 + 0x6D3630','pattern':pattern,'passed':True,'complete':False,'cases':cases,'limits':['Original token matcher, CRT comparison and team function executed; actor/local virtual getter and final string append explicitly supplied.','6D4B2E/6D4B34 binding instructions checked byte-exact; outer complete template scan not executed.','No event trigger, scheduler, voice admission or playback claim.']}
(r/'data/4.20/audio_announcer_team_binding_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_team_binding.py'),r/'tools/qualify_announcer_team_binding.py');print(json.dumps({'native_cases':len(cases),'matched':sum(c['matched'] for c in cases)}))
