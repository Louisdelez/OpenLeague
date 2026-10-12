from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague')
prerequisites=(r/'tools/probe_fow_event_creation_generated.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(prerequisites,'native bounds prerequisites','exec'))
native_path=Path(json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8-sig'))['source'])
scb_path=native_path.parent/'LEVELS/Map10/Scene/__LevelSize_.SCB'
scb_raw=scb_path.read_bytes()
assert scb_raw[:8]==b'r3d2Mesh' and struct.unpack_from('<HH',scb_raw,8)==(2,2)
authored=list(struct.unpack_from('<6f',scb_raw,152))
asset=0x40008000;state=0x40009000
inputs=[authored,[1.,2.,3.,1001.,12.,2003.],[-500.,-100.,-250.,500.,200.,750.],[-0.,-0.,-0.,0.,0.,0.],[-1.e7,-5.,-1.e7,1.e7,5.,1.e7],[1.0000001,0.,-1.0000001,1.0000002,1.,1.0000002]]
cases=[]
for bounds in inputs:
 u.mem_write(asset,bytes(128));u.mem_write(asset+0x64,struct.pack('<6f',*bounds));u.mem_write(state,bytes(0x500))
 u.reg_write(UC_X86_REG_EAX,asset);u.reg_write(UC_X86_REG_EDI,state);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 u.emu_start(0x86fa49,0x86fac2,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x86fac2
 spans=[read32(0x2d6dd48+i*4) for i in range(3)]
 centers=[read32(0x2d6dd3c+i*4) for i in range(3)]
 assert u.mem_read(state+0x46c,1)==b'\x01'
 cases.append(dict(bounds_bits=list(struct.unpack('<6I',struct.pack('<6f',*bounds))),span_bits=spans,center_bits=centers,bounds_ready=True,view_extent_bits=spans[0]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x86fa49',stop='0x86fac2',native_addresses=len({a for a in visited if 0x86fa49<=a<0x86fac2}),resource=dict(path=str(scb_path),sha256=hashlib.sha256(scb_raw).hexdigest(),size=len(scb_raw),format='r3d2Mesh 2.2',bounds_offset=152,authored_bounds=authored),cases=cases,limits=['Original SSE bounds arithmetic and ready flag execute; asset bounds field layout is supplied from original SCB header. Resource registration, SCB loader and lookup producers are not executed.','Constructor caller6B3462 loads global2D6DD48: X span. Caller discovery is static disassembly; complete caller and camera/configuration producers remain unqualified.','Native center Y is zero; SCB header maxY differs from flat vertex height and must not be recomputed from vertices.','No ordinary source/view activation, server visibility or GPU fog binding qualified.'])
(r/'assets/maps/tt_level_size.scb').write_bytes(scb_raw)
(r/'data/4.20/fow_level_bounds_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],map10_bounds=authored,map10_extent_bits=cases[0]['view_extent_bits'])))
