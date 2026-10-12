from pathlib import Path
import itertools,json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
table=heap+0x4000;allocator=heap+0x5000;allocator_table=heap+0x5100;obj=heap+0x6000;clone=heap+0x7000;payload=heap+0x8000;out=heap+0x9000;info=heap+0x9100;calls=[];failure=False;phase='create';clone_failure=False
put(allocator,'I',allocator_table);put(allocator_table+4,'I',trap+0x500);put(table,'III',0x00810003,0xb3e260,0xb3df60);put(0x14a7abc,'II',table,1)
regions=[(0xb09360,0xb093b7),(0xb094b0,0xb09514),(0xb3e260,0xb3e29d),(0xb3df60,0xb3df7d),(0xb3dfe0,0xb3e032),(0xb3e040,0xb3e07d),(0xb3e0b0,0xb3e0ff),(0xb3e3e0,0xb3e3fb)]
def guard(uc,a,n,d):
 if a==trap+0x500:
  size=read(u.reg_read(UC_X86_REG_ESP)+4,'I')[0];calls.append({'kind':'allocate','size':size,'phase':phase});ret(0 if failure or(phase=='clone'and clone_failure)else(clone if phase=='clone'else obj),4);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(entry,args,this=None):
 sp=stack+0x8000;put(sp,'I'*(len(args)+1),trap,*args);u.reg_write(UC_X86_REG_ESP,sp)
 if this is not None:u.reg_write(UC_X86_REG_ECX,this)
 u.emu_start(entry,trap,count=2000);assert u.reg_read(UC_X86_REG_EIP)==trap;return u.reg_read(UC_X86_REG_EAX)
creators=[]
for kind,pattern,failure in itertools.product(['effect','parameter'],[0,0xa5,0xff],[False,True]):
 phase='create';u.mem_write(obj,bytes([pattern])*84);u.mem_write(info,bytes([pattern])*8);calls.clear();status=invoke(0xb09360 if kind=='effect'else 0xb094b0,[allocator,0x00810003,out]);pointer=read(out,'I')[0];metadata=None
 if pointer and kind=='effect':assert invoke(0xb3e3e0,[info],obj)==1;metadata=bytes(u.mem_read(info,8)).hex()
 creators.append({'kind':kind,'pattern':pattern,'failure':failure,'result':status,'pointer':pointer,'raw':bytes(u.mem_read(obj,84 if kind=='effect'else 32)).hex(),'info':metadata,'calls':list(calls)})
parameters=[];failure=False;blob=struct.pack('<fffffBI',.2,2.5,-60.,8.,.75,255,0xdeadbeef);u.mem_write(payload,blob)
for pattern,length,clone_failure in itertools.product([0,0xa5,0xff],[0,1,25,255],[False,True]):
 phase='create';u.mem_write(obj,bytes([pattern])*32);u.mem_write(clone,bytes([pattern])*32);calls.clear();assert invoke(0xb094b0,[allocator,0x00810003,out])==1;assert invoke(0xb3e040,[allocator,payload,length],obj)==1;before=bytes(u.mem_read(obj,32)).hex();phase='clone';pointer=invoke(0xb3dfe0,[allocator],obj)
 parameters.append({'pattern':pattern,'length':length,'payload':blob.hex(),'clone_failure':clone_failure,'before_clone':before,'clone_pointer':pointer,'clone_raw':bytes(u.mem_read(clone,32)).hex(),'source_after':bytes(u.mem_read(obj,32)).hex(),'calls':list(calls)})
proof={'passed':True,'complete':False,'creator_case_count':len(creators),'parameter_case_count':len(parameters),'creator_cases':creators,'parameter_cases':parameters,'native_sha256':hashlib.sha256(b).hexdigest(),'registration':{'start':'0x7062bf','end':'0x7062d7','sha256':hashlib.sha256(p.get_data(0x7062bf-base,0x18)).hexdigest(),'parameter_creator':'0xb3df60','effect_creator':'0xb3e260','type':3,'company':0,'id':129,'packed_id':0x00810003},'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual factory wrappers, builtin Meter creation, GetPluginInfo, parameter default initialization/set-block/clone execute. Only allocator supplies/fails controlled memory; no plugin/parameter result adapters.'],'findings':['Native registration passes parameter B3DF60 and effect B3E260 for packed plugin8454147.','Effect allocation84 bytes initializes selected fields only; parameter allocation32 initializes only vtable until Init. Preserve other bytes.','Parameter block reads five raw f32 words, a byte expanded to u32 and an unaligned u32,25 bytes total. Any nonzero declared length uses this same reader; zero length selects native defaults.','Parameter clone copies all seven words after vtable into new32-byte allocation.'],'limits':['Preparatory builtin port evidence; actual registration producer, resource loading, instance Init/Reset/Destroy/Process and RTPC binding remain required.','Payload backing includes25 valid bytes even for nonzero declared lengths1/255; truncated physical buffers not qualified.','No semantic names inferred for opaque parameter fields; no normal DSP or audible/device acceptance.']}
(r/'data/4.20/audio_meter_plugin_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(creators),'actual Meter creator cases and',len(parameters),'actual parameter init/clone cases')
