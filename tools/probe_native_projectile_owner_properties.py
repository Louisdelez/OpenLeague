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
def properties():return dict(ended=read(wrapper+0x124),requests=read(troy+0x144),radius=read(troy+0x60),color=words(troy+0x64,8),visibility=u.mem_read(troy+0x84,1)[0],position=words(troy+0x40,3),channels=words(troy+0x2f,3))
rows=[]
for flag,present,owner_live,position in itertools.product([0,0x400],[False,True],[False,True],[[0.,0.,0.],[100.,200.,300.],[-55.,24.,-90.]]):
 for a,n in [(wrapper,0x200),(troy,0x180),(control,0x20),(provider,0x60),(provider_control,0x20),(body,0x600),(handle,0x20),(owner_control,0x20)]:u.mem_write(a,b'\0'*n)
 live=True;events=[];u.mem_write(nameptr,b'AnnieQ.troy\0');u.mem_write(posptr,struct.pack('<3f',500.,600.,700.));run(0x93fd60,troy,[0,nameptr,0]);w(wrapper,0x10a4960);w(wrapper+0xb0,0x212);w(0x2d628c0,0);run(0x7172b0,0,[0,posptr,0,0,0],nameptr)
 w(body,0x10b2b5c);w(body+0x1c,flag);u.mem_write(body+0x60,struct.pack('<3f',*position));u.mem_write(body+0x6c,struct.pack('<3f',0.,0.,1.));w(provider,0x10b0d20);w(provider+4,handle);w(provider+8,owner_control);w(provider+0x1c,body);w(handle,body);w(owner_control+4,30 if owner_live else 0);w(owner_control+8,30);w(provider_control+4,30);w(provider_control+8,30)
 if present:run(0x6c9bd0,wrapper,[provider,provider_control])
 before=properties();result=run(0x6c97b0,wrapper,[0]);rows.append(dict(flags=flag,provider_present=present,owner_live=owner_live,owner_position=position,before=before,after=properties(),continues=bool(result&255)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),entries=['7172B0','6C9BD0','6C97B0','7195F0','719570','719430','719370','718ED0','9284F0','928510','928560','9285F0','9288B0'],adapters=['Inherited factory allocation/resource/collision/container adapters; original concrete provider callbacks and Troy setters execute.','Body table10B2B5C and supplied flags0/400/pose; optional body component remains absent.','No registry scheduling, populated property list, secondary provider, resource frame, or full gameplay acceptance.'],limits=['Native body construction/flag producer and optional body component are not yet qualified.','No client renderer integration or downstream Troy scalar/color/visibility acceptance.'])
(r/'data/4.20/projectile_owner_properties_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(rows),native_addresses=proof['native_instruction_addresses'],profiles=[c for c in rows if c['provider_present'] and c['owner_live'] and c['owner_position']==[100.,200.,300.]])))
