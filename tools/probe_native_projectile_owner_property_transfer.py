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
engine=vector+0x13000;child=vector+0x14000;child_config=vector+0x14600;child_owner=vector+0x14800;array=vector+0x15000
def output():return dict(flags=u.mem_read(instance+0x1dc,1)[0],params=words(instance+0xbc,3),color=words(instance+0xc8,8),channels=words(instance+0x74,3),position=words(instance+0x90,3),minimum=words(instance+0x130,3),maximum=words(instance+0x13c,3),child_factor=read(child+0x104))

rows=[]
for flag,present,owner_live,position,owner_weight in itertools.product([0,0x400],[False,True],[False,True],[[0.,0.,0.],[100.,200.,300.],[-55.,24.,-90.]],[0.,1.]):
 for a,n in [(wrapper,0x200),(troy,0x180),(control,0x20),(provider,0x60),(provider_control,0x20),(body,0x600),(handle,0x20),(owner_control,0x20)]:u.mem_write(a,b'\0'*n)
 live=True;events=[];u.mem_write(nameptr,b'AnnieQ.troy\0');u.mem_write(posptr,struct.pack('<3f',500.,600.,700.));run(0x93fd60,troy,[0,nameptr,0]);w(wrapper,0x10a4960);w(wrapper+0xb0,0x212);w(0x2d628c0,0);run(0x7172b0,0,[0,posptr,0,0,0],nameptr)
 w(body,0x10b2b5c);w(body+0x1c,flag);u.mem_write(body+0x60,struct.pack('<3f',*position));u.mem_write(body+0x6c,struct.pack('<3f',0.,0.,1.));w(provider,0x10b0d20);w(provider+4,handle);w(provider+8,owner_control);w(provider+0x1c,body);w(handle,body);w(owner_control+4,30 if owner_live else 0);w(owner_control+8,30);w(provider_control+4,30);w(provider_control+8,30)
 if present:run(0x6c9bd0,wrapper,[provider,provider_control])
 before=properties();result=run(0x6c97b0,wrapper,[0]);after=properties()
 for a,n in [(instance,0x300),(metadata,0x300),(engine,0x400),(child,0x600),(child_config,0x400),(child_owner,0x100),(array,0x100)]:u.mem_write(a,b'\0'*n)
 w(troy+0x114,instance);w(instance,engine);w(instance+0xe8,metadata);u.mem_write(metadata+0x138,struct.pack('<f',500.));u.mem_write(metadata+0x13c,struct.pack('<f',1.));u.mem_write(engine+0x34c,struct.pack('<2f',0.,1.))
 w(instance+8,array);w(instance+12,array+4);w(array,child);w(child+8,child_config);w(child+4,child_owner);u.mem_write(child_config+0x35c,struct.pack('<f',1.));u.mem_write(child_config+0x36c,struct.pack('<f',owner_weight));u.mem_write(child_config+0x364,struct.pack('<f',0.));u.mem_write(child_owner+0xe0,struct.pack('<2f',2.,0.));w(child+0x104,0x3f800000)
 u.mem_write(instance+0xbc,struct.pack('<3f',1.,1.,0.));emitter_before=output()
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack-0x100);u.reg_write(UC_X86_REG_EDI,troy);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x94071e,0x9408e8,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x9408e8
 rows.append(dict(flags=flag,provider_present=present,owner_live=owner_live,owner_position=position,owner_weight=owner_weight,before=before,after=after,continues=bool(result&255),emitter_before=emitter_before,emitter_after=output()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),entries=['7172B0','6C9BD0','6C97B0','94071E..9408E8','93FB60'],adapters=['Inherited factory adapters; original concrete provider callbacks, Troy setters and property transfer execute consecutively.','Supplied instance/engine/config extent500 scalar remap0..1 target1 and one child: scalar weight1, owner weight0/1 and owner factor2.','Original empty optional body component and default wrapper flags; resource parser, child producer and full frame scheduling remain separate.'],findings=['Zero provider radius transfers into instance C4; child scalar expression falls back to factor1 when nonpositive, or uses supplied owner factor2 when its coefficient is1.','Visibility byte1 produces instance flag bit8. Eight-word property block transfers only for acquired flag400 provider.'],limits=['Supplied remap/child inputs are not a qualification of Annie resource parsing or gameplay owner-factor producers.','No renderer integration, final request reset or whole-game acceptance.'])
(r/'data/4.20/projectile_owner_property_transfer_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(rows),native_addresses=proof['native_instruction_addresses'])))
