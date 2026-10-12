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
def capture(uc,a,size,user):
 if a==0x564c20:
  sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX);src,n=read32(sp+4),read32(sp+8);text=bytes(u.mem_read(src,n)).decode('ascii');changes.append(text);put(ecx,text);finish(8,ecx);return
 assert 0x400000<=a<0x1000000,hex(a)
def invalid(uc,access,address,size,value,user):faults.append({'address':address,'size':size,'access':access});return False
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid);cases=[]
for entry in [0x6d3d30,0x6d4470]:
 write32(0x2d7c0ec,1);put(cache,'prior');write32(fs_base,0xabcdef00);faults=[];changes=[];sp=stack+0xc000;write32(sp,end);write32(sp+4,0);u.reg_write(UC_X86_REG_ESP,sp)
 try:u.emu_start(entry,end,count=100000);raise AssertionError('unexpected observer-null success')
 except unicorn.UcError as e:error=str(e)
 assert faults==[{'address':0x124,'size':4,'access':unicorn.UC_MEM_READ_UNMAPPED}] and changes==['unknown'] and string(cache)=='unknown',(hex(entry),faults,changes,string(cache),error,hex(u.reg_read(UC_X86_REG_EIP)))
 cases.append({'entry':hex(entry),'actor':None,'fs_base':fs_base,'faults':faults.copy(),'cache_changes':changes.copy(),'cache_after_fault':string(cache),'error':error})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original plain/localized observercolorhex callbacks execute with real x86 FS segment base using GDT; page zero unmapped while SEH head remains valid at FS:0.','Native actor-null case resets cache to unknown then faults reading actor+124. Rust reports explicit missing actor instead of host-process crash; no success fallback invented.','Native exception dispatch/unwinding after the fault is not executed. Live caller validity and playback remain incomplete.']}
(r/'data/4.20/audio_announcer_observer_null_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_observer_null.py'),r/'tools/qualify_announcer_observer_null.py')
print(json.dumps({'native_fs_aware_observer_null_cases':len(cases)}))
