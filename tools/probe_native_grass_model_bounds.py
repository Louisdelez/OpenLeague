from pathlib import Path
import json,struct,ast,hashlib,math,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
u.mem_map(terrain+0x10000,0x800000)
parser={'struct':struct};tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'source parser','exec'),parser)
vertex=terrain+0x10000;mesh=terrain+0x2000;model=terrain+0x3000;provider=terrain+0x4000;min_out=terrain+0x5000;max_out=terrain+0x5100;resource=terrain+0x6000;frame=sp-0x1000;override=None;requests=[]
def cstring(pointer):return bytes(u.mem_read(pointer,80)).split(b'\0')[0].decode('ascii')
def boundary(uc,a,size,user):
 if a==0x8b22a0:
  stack=u.reg_read(UC_X86_REG_ESP);default=list(struct.unpack('<3f',u.mem_read(read32(stack+12),12)))
  section=cstring(read32(stack+4));key=cstring(read32(stack+8));assert section=='MeshSkin' and key=='OverrideBoundingBox'
  value=default if override is None else override;out=u.reg_read(UC_X86_REG_ECX);u.mem_write(out,struct.pack('<3f',*value));requests.append(dict(section=section,key=key,default_bits=list(struct.unpack('<3I',struct.pack('<3f',*default))),value_bits=list(struct.unpack('<3I',struct.pack('<3f',*value)))))
  u.reg_write(UC_X86_REG_EAX,out);u.reg_write(UC_X86_REG_EIP,read32(stack));u.reg_write(UC_X86_REG_ESP,stack+4)
 elif a==0x9933e0:
  stack=u.reg_read(UC_X86_REG_ESP);assert read32(stack+4)==0x80;u.mem_write(provider,bytes(0x80));u.reg_write(UC_X86_REG_EAX,provider);u.reg_write(UC_X86_REG_EIP,read32(stack));u.reg_write(UC_X86_REG_ESP,stack+4)
 elif a in [0x96d8a0,0x96db70]:
  # Vertex/index view construction is irrelevant to this static provider box.
  stack=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read32(stack));u.reg_write(UC_X86_REG_ESP,stack+8)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
def reset(entry,ecx,edx=0,args=[],stop=end):
 write32(sp,end)
 for i,v in enumerate(args):write32(sp+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.reg_write(UC_X86_REG_EDX,edx);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(entry,stop,count=3000000);assert u.reg_read(UC_X86_REG_EIP)==stop
records=[];inventory=json.loads(Path('E:/mapslol3v3/output/Champions_4_20/import_inventory.json').read_text(encoding='utf-8'))
for row in inventory:
 if row['kind']!='champion' or row['status']!='exported':continue
 path=Path(row['mesh']);b=path.read_bytes();magic,major,minor=struct.unpack_from('<IHH',b);assert magic==0x112233 and minor==1 and major in [0,1,2,4]
 offset=8
 if major:materials=struct.unpack_from('<I',b,offset)[0];offset+=4+materials*80
 if major<4:index_count,vertex_count=struct.unpack_from('<II',b,offset);stride=52;offset+=8;header_bounds=None
 else:
  flags,index_count,vertex_count,stride,kind=struct.unpack_from('<5I',b,offset);assert stride in [52,56] and kind in [0,1];header_bounds=list(struct.unpack_from('<6f',b,offset+20));offset+=60
 offset+=index_count*2;raw=b[offset:offset+vertex_count*stride];assert len(raw)==vertex_count*stride and 0<vertex_count<=65536
 positions=[struct.unpack_from('<3f',raw,i*stride) for i in range(vertex_count)];assert all(math.isfinite(v) for p in positions for v in p)
 computed=[min(p[i] for p in positions) for i in range(3)]+[max(p[i] for p in positions) for i in range(3)]
 if major<4:
  u.mem_write(vertex,raw);reset(0x953b80,vertex,vertex_count,[stride,min_out,max_out]);native=list(struct.unpack('<3f',u.mem_read(min_out,12)))+list(struct.unpack('<3f',u.mem_read(max_out,12)));assert struct.pack('<6f',*native)==struct.pack('<6f',*computed);mesh_bounds=native
 else:mesh_bounds=header_bounds
 config=Path(row['source_config']);properties=parser['ini'](config);authored=properties.get(parser['hashkey']('MeshSkin','OverrideBoundingBox'))
 if isinstance(authored,str):authored=[float(v) for v in authored.replace(',',' ').split()]
 if authored is not None:assert isinstance(authored,list) and len(authored)==3 and all(math.isfinite(float(v)) for v in authored);authored=list(map(float,authored))
 records.append(dict(name=row['asset'].lower(),mesh=str(path),mesh_sha256=hashlib.sha256(b).hexdigest(),config=str(config),config_sha256=hashlib.sha256(config.read_bytes()).hexdigest(),major=major,vertex_count=vertex_count,stride=stride,mesh_bounds=mesh_bounds,override=authored,skin_scale=row['skin_scale']))
 print(row['asset'],vertex_count,flush=True)
assert len(records)==122
synthetic=[dict(name='fixture-'+str(i),mesh_bounds=b,override=o) for i,(b,o) in enumerate([([0.]*6,None),([2.,3.,4.,-5.,-6.,-7.],None),([-.1,-.2,-.3,.4,.5,.6],None),([-1.,-2.,-3.,4.,5.,6.],[10.,20.,30.]),([-1.,-2.,-3.,4.,5.,6.],[-10.,-20.,-30.])])]
cases=[]
for record in records+synthetic:
 override=record['override'];requests.clear();u.mem_write(mesh,bytes(0x80));u.mem_write(model,bytes(0xb0));u.mem_write(mesh+0x50,struct.pack('<6f',*record['mesh_bounds']));write32(model+0xa0,mesh)
 u.mem_write(frame,bytes(0x300));u.mem_write(frame+0x24,b'MeshSkin\0');write32(frame+0x34,8);write32(frame+0x38,15);u.mem_write(resource,bytes(0x20));u.mem_write(resource,b'Base\0');write32(resource+0x10,4);write32(resource+0x14,15)
 u.reg_write(UC_X86_REG_ESP,frame);u.reg_write(UC_X86_REG_ESI,model);u.reg_write(UC_X86_REG_EDI,resource);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x9640cf,0x9641f3,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x9641f3 and read32(model+0xa4)==provider and read32(provider)==0x10d9d80
 values=list(struct.unpack('<6I',u.mem_read(provider+0x1c,24)));reset(0x66c0b0,provider);assert u.reg_read(UC_X86_REG_EAX)==provider+0x1c
 result=dict(record,provider_bounds_bits=values,requests=list(requests));cases.append(result)
catalog={c['name']:c for c in cases if not c['name'].startswith('fixture-')}
proof=dict(passed=True,complete=False,updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,native_addresses=len(visited),cases=cases,limits=['122 base champion resources, SKN0/1/2 actual953B80 scan or SKN4 authored header bounds; original mesh file IO/GPU buffer creation and influence conversion are not executed.','Original9640CF dimensions/defaults/override consumer,960D40 provider constructor and66C0B0 getter execute; configuration vector lookup, allocation and unused vertex/index view construction adapted.','Static provider bounds only; pose bounds+34/virtual14 are a separate path. Related forms/skins/NPC models and actual live actor lifecycle remain open.'])
(r/'data/4.20/grass_model_bounds_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');(r/'data/4.20/native_grass_model_bounds.json').write_text(json.dumps(catalog,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),addresses=len(visited),overrides=sum(c['override'] is not None for c in records))))
