from pathlib import Path
import ctypes,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_factory_pose.py').read_text(encoding='utf-8').split('rows=[]')[0],'factory setup','exec'))
provider=vector+0xc000;provider_control=vector+0xc100;body=vector+0xd000;metadata=vector+0xe000;instance=vector+0xf000;handle=vector+0x11000;owner_control=vector+0x11100;body_config=vector+0x12000
k=ctypes.windll.kernel32;k.VirtualAlloc.restype=ctypes.c_void_p;k.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_ulong,ctypes.c_ulong]
code=bytes.fromhex('f30f5201f30f1102c3');machine=k.VirtualAlloc(None,4096,0x3000,0x40);assert machine;ctypes.memmove(machine,code,len(code));rsqrt=ctypes.CFUNCTYPE(None,ctypes.POINTER(ctypes.c_uint32),ctypes.POINTER(ctypes.c_uint32))(machine);cpu_operations=0
def owner_hook(uc,a,size,user):
 global cpu_operations
 if a in [0x9941b0,0x994210]:finish(0);return
 if a in [0x5fa7d9,0x66d6f1]:
  reg=UC_X86_REG_XMM1 if a==0x5fa7d9 else UC_X86_REG_XMM2;x=u.reg_read(reg);src=ctypes.c_uint32(x&0xffffffff);dst=ctypes.c_uint32();rsqrt(ctypes.byref(src),ctypes.byref(dst));u.reg_write(reg,(x&~0xffffffff)|dst.value);u.reg_write(UC_X86_REG_EIP,a+size);cpu_operations+=1
u.hook_add(unicorn.UC_HOOK_CODE,owner_hook)
def pose_state():return dict(source_position=words(troy+0x40,3),source_direction=words(troy+0x4c,3),source_matrix=words(troy+0x88,16),position=words(instance+0x90,3),direction=words(instance+0x9c,3),matrix=words(instance+0xf0,16),minimum=words(instance+0x130,3),maximum=words(instance+0x13c,3),source_flags=read(instance+0x70))
rows=[]
sequences=[[True,True,True],[True,False,False],[False,True,True],[True,False,True],[False,False,False]]
for initial_ended,present,resource_live,sequence in itertools.product([0,1],[False,True],[False,True],sequences):
 for a,n in [(wrapper,0x200),(troy,0x180),(control,0x20),(provider,0x60),(provider_control,0x20),(body,0x600),(handle,0x20),(owner_control,0x20)]:u.mem_write(a,b'\0'*n)
 live=resource_live;events=[];u.mem_write(nameptr,b'AnnieQ.troy\0');u.mem_write(posptr,struct.pack('<3f',500.,600.,700.));assert run(0x93fd60,troy,[0,nameptr,0])==troy
 w(wrapper,0x10a4960);w(wrapper+0xb0,0x212);w(0x2d628c0,0);assert run(0x7172b0,0,[0,posptr,0,0,0],nameptr)==wrapper
 w(body,0x10b2b5c);w(body+0x1c,0x400);w(body+0x114,8);w(body+0x118,1)
 w(provider,0x10b0d20);w(provider+4,handle);w(provider+8,owner_control);w(provider+0x1c,body);w(provider+0xc,7);w(handle,body);w(owner_control+8,30);w(provider_control+4,30);w(provider_control+8,30)
 if present:run(0x6c9bd0,wrapper,[provider,provider_control])
 w(wrapper+0x124,initial_ended);stages=[]
 for i,owner_live in enumerate(sequence):
  w(owner_control+4,20 if owner_live else 0);u.mem_write(body+0x60,struct.pack('<3f',100.+i,200.+i,300.+i));u.mem_write(body+0x6c,struct.pack('<3f',1.,2.,3.))
  before=state();value=run(0x6c97b0,wrapper,[0]);after=state();stages.append(dict(owner_live=owner_live,owner_position=[100.+i,200.+i,300.+i],before=before,after=after,continues=bool(value&255)))
 rows.append(dict(initial_ended=initial_ended,provider_present=present,resource_live=resource_live,stages=stages))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),entries=['7172B0','6C9BD0','6C97B0','concrete provider table10B0D20'],findings=['Failed concrete owner acquisition sets wrapper124=1 but returns true for that update; subsequent update returns false even if supplied owner becomes live again.','An absent provider does not terminate the wrapper and preserves its position.','Expired resource rejects update before owner eligibility and does not mark wrapper ended.'],adapters=['Inherited factory allocation/resource/container/collision adapters from projectile_factory_pose_contract.','Original concrete weak-reference lock and provider callbacks execute. Supplied control-block strong counts exercise acquired/expired states; lifetime producer and concurrent ownership remain open.','Three frames per sequence; registry scheduling and destruction are not executed.'],limits=['No full resource-manager, owner lifetime producer, registry scheduler, or client rendering acceptance.'])
(r/'data/4.20/projectile_owner_acquisition_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(rows),frames=sum(len(c['stages']) for c in rows),native_addresses=proof['native_instruction_addresses'])))
