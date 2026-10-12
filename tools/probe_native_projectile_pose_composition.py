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
for pending,live,owner_live,position,direction in itertools.product([0,1,2,4,7],[False,True],[False,True],[[0.,0.,0.],[100.,200.,300.],[-55.,24.,-90.]],[[0.,0.,1.],[1.,2.,3.],[0.,-1.,0.]]):
 for a,n in [(wrapper,0x200),(troy,0x180),(control,0x20),(provider,0x60),(provider_control,0x20),(body,0x600),(metadata,0x300),(instance,0x300),(handle,0x20),(owner_control,0x20),(body_config,0x800)]:u.mem_write(a,b'\0'*n)
 events=[];u.mem_write(nameptr,b'AnnieQ.troy\0');u.mem_write(posptr,struct.pack('<3f',500.,600.,700.));assert run(0x93fd60,troy,[0,nameptr,0])==troy
 w(wrapper,0x10a4960);w(wrapper+0xb0,0x212);w(wrapper+0x144,pending);w(0x2d628c0,0)
 assert run(0x7172b0,0,[0,posptr,0,0,0],nameptr)==wrapper
 # Actual projectile position sync from moving544 into exposed owner position60.
 w(body+0x57c,body);w(body+0x140,body_config);u.mem_write(body+0x544,struct.pack('<3f',*position));u.mem_write(body+0x6c,struct.pack('<3f',*direction));run(0x7631c0,body,[0])
 w(body,0x10b2b5c);w(body+0x1c,0x400);w(body+0x114,8);w(body+0x118,1)
 w(provider,0x10b0d20);w(provider+4,handle);w(provider+8,owner_control);w(provider+0x1c,body);w(provider+0xc,7);w(handle,body);w(owner_control+4,2 if owner_live else 0);w(owner_control+8,3);w(provider_control+4,3);w(provider_control+8,3)
 run(0x6c9bd0,wrapper,[provider,provider_control]);update_return=run(0x6c97b0,wrapper,[0]);after_update=state()
 # Qualified owner phase with concrete producer, supplied resource instance.
 w(troy+0x114,instance);w(instance+0xe8,metadata);u.mem_write(metadata+0x138,struct.pack('<f',500.));w(metadata+0x1bc,0);w(instance+0x70,0x80)
 identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.];u.mem_write(instance+0xf0,struct.pack('<16f',*identity));u.mem_write(instance+0x90,struct.pack('<3f',-1.,-2.,-3.));u.mem_write(instance+0x9c,struct.pack('<3f',-4.,-5.,-6.));before=pose_state()
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack-0x100);u.reg_write(UC_X86_REG_EDI,troy);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x94099a,0x940aee,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x940aee
 rows.append(dict(pending_flags=pending,effect_live=live,owner_live=owner_live,position=position,direction=direction,flags=read(troy+0x24),after_wrapper_update=after_update,update_return=update_return,before=before,result=pose_state()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),actual_cpu_rsqrt_operations=cpu_operations,entries=['93FD60','7172B0','6C8E30','6C97B0','7631C0','6C9BD0','9286C0','94099A..940AEE'],adapters=['Factory adapters inherited from projectile_factory_pose_contract, including supplied allocation/resource weak lifetime and omitted collision/logging.','Concrete10B0D20 methods execute; no pose/status callback returns substituted. Physical CPU supplies original RSQRTSS arithmetic.','Mutex endpoints9941B0/994210 omitted for a single-threaded empty deferred queue.','Troy114 emitter resource instance supplied with position/direction/matrix sentinels, extent500, config flags0 and source flags80; its construction is separate.'],findings=['Position synchronization7631C0, actual factory/load, bound provider update and concrete Troy owner phase execute in sequence.','Initial pending flags determine orientation gate after binding; empty provider assumptions from prior factory qualification are removed here.','Failed owner acquisition reaches native wrapper termination marking; final Troy owner phase does not overwrite absent-owner state.'],limits=['Direction input comes from supplied body6C; native motion producer qualified separately and must be connected in the client.','Allocation/parser/registry/collision bookkeeping, concurrent lifetime, populated deferred queues and full940 frame remain open.','Original primary/secondary actor statuses supplied as flags400, status1, current8/previous7; their live producers remain unqualified.','No client-renderer or whole-game acceptance.'])
(r/'data/4.20/projectile_pose_composition_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(rows),native_instruction_addresses=proof['native_instruction_addresses'],cpu_rsqrt_operations=cpu_operations)))
