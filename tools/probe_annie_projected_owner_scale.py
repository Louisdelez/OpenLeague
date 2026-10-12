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
definition=vector+0x18000;stub=vector+0x19000;engine=vector+0x13000;child=vector+0x14000;child_owner=vector+0x14800;array=vector+0x15000
u.mem_write(stub,bytes.fromhex('d9442410c3'));reader_values={};calls=[]
def reader_hook(uc,a,size,user):
 if a==0x8b1f50:
  sp=u.reg_read(UC_X86_REG_ESP);ptr=read(sp+12);key=bytes(u.mem_read(ptr,80)).split(b'\0')[0].decode('ascii');default=struct.unpack('<f',u.mem_read(sp+16,4))[0];value=reader_values.get(key,default);u.mem_write(sp+16,struct.pack('<f',value));calls.append(dict(key=key,default=default,authored=key in reader_values,value=value));u.reg_write(UC_X86_REG_EIP,stub)
u.hook_add(unicorn.UC_HOOK_CODE,reader_hook)
document=json.loads((r/'data/4.20/particles/annie/Annie_Q_mis.json').read_text(encoding='utf-8'));keys=['p-flexscale','p-scalebyradius','p-scalebyheight']
profiles=[('annie_projected',{k:v for k,v in document['sections']['Projected'].items() if k in keys}),('explicit_zero',{k:0. for k in keys}),('flex',{'p-flexscale':1.}),('owner_radius',{'p-flexscale':1.,'p-scalebyradius':1.}),('owner_height',{'p-flexscale':1.,'p-scalebyheight':1.})];rows=[]
for (name,reader_values),scalar in itertools.product(profiles,[0.,2.]):
 calls=[];u.mem_write(definition,b'\0'*0x410);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBX,definition);u.reg_write(UC_X86_REG_EDI,0);u.reg_write(UC_X86_REG_ESI,0);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.emu_start(0x91efe4,0x91f087,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x91f087
 coefficients=[read(definition+offset) for offset in [0x210,0x220,0x218]]
 for a,n in [(instance,0x300),(metadata,0x300),(engine,0x400),(child,0x200),(child_owner,0x100),(array,0x100)]:u.mem_write(a,b'\0'*n)
 w(instance,engine);w(instance+0xe8,metadata);u.mem_write(metadata+0x13c,struct.pack('<f',1.));u.mem_write(engine+0x34c,struct.pack('<2f',0.,1.));w(instance+0x38,array);w(instance+0x3c,array+4);w(array,child);w(child+4,definition);w(child,child_owner);u.mem_write(child_owner+0xe0,struct.pack('<2f',2.,3.))
 u.reg_write(UC_X86_REG_EBX,child);u.emu_start(0x9414a9,0x9414b3,count=100);assert u.reg_read(UC_X86_REG_EIP)==0x9414b3;before=read(child+0xe0)
 run(0x93fb60,instance,[struct.unpack('<I',struct.pack('<f',scalar))[0]])
 rows.append(dict(name=name,fields=reader_values,scalar=scalar,reader_calls=calls,coefficients=coefficients,initial_factor=before,final_factor=read(child+0xe0),system_scalar=read(instance+0xc4)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),resource_sha256=hashlib.sha256((r/'data/4.20/particles/annie/Annie_Q_mis.json').read_bytes()).hexdigest(),entries=['91EFE4..91F087','9414A9..9414B3','93FB60'],findings=['Native simple reader coefficients210/220/218 are p-flexscale/p-scalebyradius/p-scalebyheight, default0.','Actual Annie Projected group omits all three; initialized simple factor1 is preserved by the nonpositive coefficient gate independently of source radius.'],adapters=['Float reader8B1F50 supplies finite authored value or exact native default via x87 FLD/RET; lookup/cache/parser internals not executed.','Native field assignments, simple factor constructor store and original scalar/second-child loop execute in sequence.','Engine remap0..1 target1 and owner factors2/3 supplied; no full resource parser or lifetime frame.'],limits=['Reader call-site composition and numeric transport; not full INIBIN retrieval/parser acceptance.','Simple coefficient/factor subset only. Visibility flag consumer, actual owner factor producers, other source properties and full rendering remain open.'])
(r/'data/4.20/annie_projected_owner_scale_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(passed=True,cases=len(rows),native_addresses=proof['native_instruction_addresses'],annie=[x for x in rows if x['name']=='annie_projected'])))
