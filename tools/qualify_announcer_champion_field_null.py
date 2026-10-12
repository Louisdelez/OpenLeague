from pathlib import Path
import json,shutil,struct
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
gdt=end+0x1000;fs_base=heap+0xf000;limit=0xfffff
def descriptor(base,access,flags):return (limit&0xffff)|((base&0xffff)<<16)|(((base>>16)&255)<<32)|(access<<40)|(((limit>>16)&15)<<48)|(flags<<52)|(((base>>24)&255)<<56)
u.mem_write(gdt,b'\0'*8+struct.pack('<QQQ',descriptor(0,0x9b,12),descriptor(0,0x93,12),descriptor(fs_base,0x93,4)));u.reg_write(UC_X86_REG_GDTR,(0,gdt,31,0))
for register,selector in [(UC_X86_REG_CS,8),(UC_X86_REG_DS,16),(UC_X86_REG_ES,16),(UC_X86_REG_SS,16),(UC_X86_REG_FS,24)]:u.reg_write(register,selector)
assert u.reg_read(UC_X86_REG_FS_BASE)==fs_base
u.mem_unmap(0,0x10000);cache=0x2d7c0f0
actor=heap+0x1000;vt=heap+0x6000;getter=end+0x100;get_error=end+0x200;write32(actor,vt);write32(vt+0x1f8,getter);write32(0xfa43bc,get_error)
def capture(uc,a,size,user):
 if a==getter:ops.append({'op':'champion_getter','result':None});finish(eax=0);return
 if a==0x991f80:
  sp=u.reg_read(UC_X86_REG_ESP);ops.append({'op':'diagnostic','format_hex':cbytes(u.reg_read(UC_X86_REG_ECX)).hex(),'args':[read32(sp+i) for i in [4,8,12]]});finish();return
 if a==get_error:ops.append({'op':'GetLastError','result':last_error});finish(eax=last_error);return
 assert 0x400000<=a<0x1000000,hex(a)
def invalid(uc,access,address,size,value,user):faults.append({'address':address,'size':size,'access':access,'value':value});return False
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid);cases=[]
for entry,flags,last_error in __import__('itertools').product([0x6d4520,0x6d45a0],[0x400,0x1400],[0,97,0xffffffff]):
 ops=[];faults=[];write32(actor+0x1c,flags);write32(fs_base,0xabcdef00);sp=stack+0xc000;write32(sp,end);write32(sp+4,actor);u.reg_write(UC_X86_REG_ESP,sp)
 try:u.emu_start(entry,end,count=100000);raise AssertionError('unexpected NULL getter success')
 except unicorn.UcError as e:error=str(e)
 assert faults==[{'address':0,'size':4,'access':unicorn.UC_MEM_WRITE_UNMAPPED,'value':last_error}] and [o['op'] for o in ops]==['champion_getter','diagnostic','GetLastError']
 cases.append({'entry':hex(entry),'flags':flags,'last_error':last_error,'ops':ops.copy(),'faults':faults.copy(),'error':error})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original6D4520/6D45A0 eligible NULL getter branch calls diagnostic then GetLastError and faults writing address0. Actual zero page unmapped and32bit FS/SS configured; no success result invented.','Raw getter, diagnostic logging and Windows GetLastError explicitly supplied. Native process fault/exception dispatch/termination not executed; Rust should expose this unsupported native fault after preserving diagnostic order.']}
(r/'data/4.20/audio_announcer_champion_field_null_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_champion_field_null.py'),r/'tools/qualify_announcer_champion_field_null.py');print(json.dumps({'native_champion_null_getter_cases':len(cases)}))
