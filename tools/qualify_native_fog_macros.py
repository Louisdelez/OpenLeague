from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
prefix=prefix.replace('0x9593c0<=a<0x9595c5','0x987830<=a<0x9878be')
exec(compile(prefix,'native fog macro vector prerequisites','exec'))
initial_quality=struct.unpack_from('<i',image,0x1225904-base)[0];cases=[]
for enabled in [False,True]:
 for quality in [-1,0,1,2,3,4]:
  w(vector,storage);w(vector+4,storage);w(vector+8,storage+1024);u.mem_write(0x14be79f,bytes([enabled]));w(0x1225904,quality)
  w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,vector);u.emu_start(0x987830,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
  actual=[]
  for off in range(0,read(vector+4)-storage,8):
   name,value=struct.unpack('<2I',u.mem_read(storage+off,8));actual.append(dict(name=string(name),value=string(value)))
  names=[]
  if enabled:
   names=['VERTEX_FOG'] if quality==0 else ['FOG_PIXELSHADER_BLEND']
   if quality==1:names.append('FOG_QUALITY_LOW')
   elif (quality & 0xffffffff)>=2:names.append('FOG_TEXTURED_OPACITY')
  assert actual==[dict(name=n,value='1') for n in names],(enabled,quality,actual,names)
  cases.append(dict(enabled=enabled,quality=quality,macros=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x987830',vector_append='0x77de90',cases=cases,initial_pe_quality=initial_quality,quality_address='0x1225904',native_addresses=len(visited),
 findings=['Fog quality is independent from general environment quality12258D8.','Quality0 selects vertex fog;1 selects single-layer pixel fog;>=2 selects dual-layer textured-opacity pixel fog.','The Map10 native radius term is nonpositive; that does not imply zero top opacity. Top opacity=1-heightFog at opacity1.'],
 adapters=['Supplied vector storage and capacity; native builder and pair append execute without call adapters. Controlled enabled/quality values.'],
 limits=['Initial PE fog quality does not prove final game settings after initialization. Native quality producer and global macro merge/registry/compiler remain open.','Top-layer formula belongs to high-quality variant; native shader selection and clouds texture producer must be bound before claiming complete runtime fidelity.'])
(r/'data/4.20/native_fog_macros_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),initial_quality=initial_quality,native_addresses=len(visited))))
