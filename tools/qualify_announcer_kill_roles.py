from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x1000;other=heap+0x2000;vtable=heap+0x6000;getter=end+0x100;input_address=heap+0x4000;output=heap+0x4100
for owner in [actor,other]:write32(owner+0x124,vtable)
write32(vtable+12,getter)
def capture(uc,a,size,user):
 if a==getter:
  owner=u.reg_read(UC_X86_REG_ECX)-0x124;assert owner in [actor,other]
  value=values[len(reads)];reads.append({'owner':7 if owner==actor else 8,'value':value});finish(eax=value);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);pointer,n=read32(sp+4),read32(sp+8);assert u.reg_read(UC_X86_REG_ECX)==output
  outputs.append(bytes(u.mem_read(pointer,n)).hex());finish(8,output);return
 assert 0x400000<=a<0x1000000,hex(a)
def memory_read(uc,access,address,size,value,user):
 if address==actor+0x1c:assert size==4;fields.append('flags')
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read);cases=[]
for pattern,exists,local,flags,first,second,mode,variant in itertools.product([' champion kill source@',' champion kill destination@'],[False,True],['none','self','other'],[0,0x400,0x800,0x1000,0x2000,0x3800,0xffffffff],[0,100,200,300],[0,100,200,300],[0,2,3],['exact','upper','tail']):
 reads=[];fields=[];outputs=[];values=[first,second];input=pattern.upper() if variant=='upper' else pattern+'tail' if variant=='tail' else pattern
 write32(0x2d77f48,{'none':0,'self':actor,'other':other}[local]);write32(0x2d79058,mode);write32(actor+0x1c,flags);u.mem_write(input_address,input.encode()+b'\0')
 sp=stack+0xc000;write32(sp,end);write32(sp+4,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor if exists else 0)
 u.emu_start(0x6d4a10,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and len(outputs)==1
 assert fields==(['flags'] if pattern==' champion kill source@' and exists and local!='self' else [])
 cases.append({'pattern':pattern,'input':input,'exists':exists,'local':local,'flags':flags,'first':first,'second':second,'mode':mode,'output_hex':outputs[0],'getter_calls':reads.copy(),'field_reads':fields.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original plain registered kill-source/destination callbacks and dispatcher executed; no localized binding added.','Kill-source uses flags after local-identity shortcut. Kill-destination has no class check, actor-first team reads and repeated no-local team getters.','Actor/vtable/team getter and output storage supplied; normal event role selection, live actor ownership and playback remain incomplete.']}
(r/'data/4.20/audio_announcer_kill_roles_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_kill_roles.py'),r/'tools/qualify_announcer_kill_roles.py')
print(json.dumps({'native_kill_role_cases_prepared':len(cases)}))
