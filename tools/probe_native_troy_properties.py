"""Original94071E..9408E8 with complete scalar/matrix/color/bounds helpers."""
from pathlib import Path
import json,struct,datetime,shutil,ctypes,random,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_position_bounds.py').read_text(encoding='utf-8').split('\nconstants=')[0]
setup=setup.replace("('addss','58')", "('addss','58'),('divss','5e')")
setup=setup.replace('not 0x921f60<=a<0x922000','not (0x921f60<=a<0x922000 or 0x93fb60<=a<0x93fcb8)')
setup=setup.replace(".split('\\ncases=[]')[0]", ".split('\\ncases=[]')[0].replace('\\nu.hook_add(unicorn.UC_HOOK_CODE,hook)\\n','\\nregistered_hook=u.hook_add(unicorn.UC_HOOK_CODE,hook)\\n')")
exec(compile(setup,'native properties setup','exec'))
u.hook_del(registered_hook);native_hook=hook
machine=bytes.fromhex('d901d91ac3');address=kernel.VirtualAlloc(None,4096,0x3000,0x40);assert address;ctypes.memmove(address,machine,len(machine));blocks.append(address)
copy_float=ctypes.CFUNCTYPE(None,ctypes.POINTER(ctypes.c_uint32),ctypes.POINTER(ctypes.c_uint32))(address)
x87_copies=0;restore=None
def x87_hook(uc,a,size,user):
 global restore,x87_copies
 if restore is not None:
  src,old=restore;write32(src,old);restore=None
 if not enabled:return
 ins=next(cs.disasm(bytes(u.mem_read(a,size)),a),None)
 if ins is None or ins.mnemonic!='fld' or ins.operands[0].type!=CS_OP_MEM or ins.operands[0].size!=4:return
 m=ins.operands[0].mem
 def reg(identifier):return u.reg_read(getattr(registers,'UC_X86_REG_'+ins.reg_name(identifier).upper())) if identifier else 0
 src=(reg(m.base)+reg(m.index)*m.scale+m.disp)&0xffffffff;value=read32(src)
 input_word=ctypes.c_uint32(value);output_word=ctypes.c_uint32();copy_float(ctypes.byref(input_word),ctypes.byref(output_word));x87_copies+=1
 if output_word.value!=value:write32(src,output_word.value);restore=(src,value)
u.hook_add(unicorn.UC_HOOK_CODE,x87_hook)
actor=heap+0x9000;actor_config=heap+0xa000;engine=heap+0xb000;wrapper=heap+0xc000;state=heap+0xd000;state_vtable=heap+0xd100;status_entry=end+0x800
status=0;events=[]
def transfer_hook(uc,a,size,user):
 if a==0x9408e8:u.emu_stop();return
 if a==status_entry:
  assert u.reg_read(UC_X86_REG_ECX)==state;events.append('owner_status');finish(eax=status);return
 native_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,transfer_hook)
special=[0,0x80000000,1,0x3f000000,0x3f800000,0x40000000,0xbf800000,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7fa01234,0xffa05678,0x7fc01234,0xffc05678]
request_values=[0,1,2,4,8,0x10,0x20,0x80,0x100,0x800,0x1000,0x4000,0x20000,0x259bf,0xffffffff]
profiles=list(itertools.product(request_values,[0,128],[None,0,1,2,255],[0,8]))
rng=random.Random(420)
profiles += [(rng.getrandbits(32),rng.getrandbits(32),rng.choice([None,0,1,2,255]),rng.randrange(256)) for _ in range(128)]
cases=[]
def snapshot():
 return {'requests':read32(wrapper+0x144),'flags':u.mem_read(actor+0x1dc,1)[0],'source_flags':read32(actor+0x70),'channels':[hex(read32(actor+0x74+i*4)) for i in range(3)],'field_80':hex(read32(actor+0x80)),'params':[hex(read32(actor+0xbc+i*4)) for i in range(3)],'color':[hex(read32(actor+0xc8+i*4)) for i in range(8)],'matrix':[hex(read32(actor+0xf0+i*4)) for i in range(16)],'position':[hex(read32(actor+0x90+i*4)) for i in range(3)],'minimum':[hex(read32(actor+0x130+i*4)) for i in range(3)],'maximum':[hex(read32(actor+0x13c+i*4)) for i in range(3)],'direction':[hex(read32(actor+0x9c+i*4)) for i in range(3)],'children':[[hex(read32(heap+0xe000+kind*0x4000+j*0x600+(0x104 if kind==0 else 0xe0))) for j in range(2 if kind==0 else 1)] for kind in range(2)],'events':events.copy()}
for index,(requests,source_flags,owner_status,flags) in enumerate(profiles):
 phase=index%15
 source={'requests':requests,'flags':source_flags,'owner_status':owner_status,'visibility':index%256,'params':[hex(special[(phase+i)%15]) for i in range(3)],'color':[hex(special[(phase+i+3)%15]) for i in range(8)],'matrix':[hex(special[(phase+i+7)%15]) for i in range(16)],'channels':[hex(special[(phase+i+1)%15]) for i in range(3)],'field_80':hex(special[(phase+2)%15]),'position':[hex(special[(phase+i+4)%15]) for i in range(3)],'direction':[hex(special[(phase+i+8)%15]) for i in range(3)]}
 scalar_config={'lower':hex(bits(0.)),'upper':hex(bits(1.)),'target':hex(special[(phase+5)%15])};coefficient=special[(phase+6)%15]
 children=[]
 for kind in range(2):
  children.append([{'coefficients':[hex(special[(phase+j*2+i*3)%15]) for i in range(3)],'owner':[hex(special[(phase+j+i+8)%15]) for i in range(2)],'previous':hex(0x7fa0beef+j)} for j in range(2 if kind==0 else 1)])
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];status=owner_status or 0
  for ptr,size in [(actor,0x300),(actor_config,0x300),(engine,0x400),(wrapper,0x200)]:u.mem_write(ptr,b'\0'*size)
  write32(actor,engine);write32(actor+0xe8,actor_config);write32(actor_config+0x138,coefficient);write32(actor_config+0x13c,int(scalar_config['target'],16));write32(engine+0x34c,int(scalar_config['lower'],16));write32(engine+0x350,int(scalar_config['upper'],16))
  for kind,row in enumerate(children):
   array=heap+0x16000+kind*0x100
   for j,entry in enumerate(row):
    child=heap+0xe000+kind*0x4000+j*0x600;childconfig=child+0x200;owner=child+0x100;u.mem_write(child,b'\0'*0x600);write32(array+j*4,child)
    if kind==0:write32(child+8,childconfig);write32(child+4,owner);offsets=[0x35c,0x36c,0x364];result_offset=0x104
    else:write32(child+4,childconfig);write32(child,owner);offsets=[0x210,0x220,0x218];result_offset=0xe0
    for offset,v in zip(offsets,entry['coefficients']):write32(childconfig+offset,int(v,16))
    for k,v in enumerate(entry['owner']):write32(owner+0xe0+k*4,int(v,16))
    write32(child+result_offset,int(entry['previous'],16))
   start=8 if kind==0 else 0x38;write32(actor+start,array);write32(actor+start+4,array+len(row)*4)
  for offset,width in [(0x74,3),(0xbc,3),(0xc8,8),(0xf0,16),(0x90,3),(0x130,3),(0x13c,3),(0x9c,3)]:
   for i in range(width):write32(actor+offset+i*4,0xa5000000+offset+i)
  write32(actor+0x70,0x12345678);write32(actor+0x80,0x7fa04567);u.mem_write(actor+0x1dc,bytes([flags]))
  write32(wrapper,0x10d6db4);write32(wrapper+0x114,actor);write32(wrapper+0x144,requests);write32(wrapper+0x24,source_flags);u.mem_write(wrapper+0x84,bytes([source['visibility']]))
  write32(wrapper+0xc8,state if owner_status is not None else 0);write32(state,state_vtable);write32(state_vtable+0x1c,status_entry)
  for offset,key in [(0x58,'params'),(0x64,'color'),(0x88,'matrix'),(0x2f,'channels'),(0x40,'position'),(0x4c,'direction')]:u.mem_write(wrapper+offset,struct.pack('<'+'I'*len(source[key]),*[int(v,16) for v in source[key]]))
  write32(wrapper+0x3c,int(source['field_80'],16))
  before=snapshot();sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,sp-0x100);u.reg_write(UC_X86_REG_EDI,wrapper);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x94071e,0x9408e8,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x9408e8 and restore is None
  captures.append(snapshot())
 cases.append({'source':source,'scalar_config':scalar_config,'coefficient':hex(coefficient),'children':children,'before':before,'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'94071E..9408E8','cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_x87_copies':x87_copies,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Original property request dispatch, concrete wrapper virtual98/928AE0, whole93FB60/921EC0/8DE500/921F60 execute.','Owner virtual1C returns explicitly supplied raw byte; call occurrence/order observed.','Separate actual CPU SSE arithmetic and FLD32/FSTP32 operand conversion reference, preserving raw original emulator capture.','Explicit engine/config/child/owner property inputs and sentinel destination buffers.'],'limits':['Ends before reset request200, audio map8000, child flag10000 and owner pose callbacks. Requests remain unchanged; complete940frame not qualified.','Engine/config producers, owner virtual body, graphical resource acquisition and ordinary rendering incomplete.','Default masked arithmetic control only; no concurrent resource mutation.']}
(r/'data/4.20/troy_properties_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'sse_operations':cpu_calls,'x87_copies':x87_copies,'disagreements':proof['emulator_cpu_case_disagreements']}))
