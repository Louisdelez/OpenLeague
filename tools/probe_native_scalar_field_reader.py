"""Original scalar reader control flow; supplied field lookup and CRT transport."""
from pathlib import Path
import sys,struct,json,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'));base=p.OPTIONAL_HEADER.ImageBase
u.mem_map(heap+0x10000,0x100000);obj=heap+0x1000;section=heap+0x2000;keyptr=heap+0x2100;path=heap+0x2200;cursor=heap+0x4000;allocation_cursor=heap+0x10000;visited=set();calls=[];fields={}
def hook(uc,a,size,user):
 global allocation_cursor
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a in (0xc9f39b,0x9933e0):
  n=read32(sp+4);assert 0<n<65536;ptr=allocation_cursor;allocation_cursor+=(n+31)&~15;u.mem_write(ptr,b'\xa5'*n);finish(eax=ptr);return
 if a==0xc98528:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a==0x564c20:
  src,n=read32(sp+4),read32(sp+8);put(ecx,bytes(u.mem_read(src,n)).decode('ascii'));finish(8,ecx);return
 if a==0x8b0750:
  name=cbytes(read32(ecx+4)).decode('ascii');value=fields.get(name,'');calls.append({'key':name,'value':value,'hash':hex(read32(ecx+8))});out=read32(sp+4);u.mem_write(out,value.encode('ascii')+b'\0');finish(eax=out);return
 if a==0x5d74c0:
  assert cbytes(read32(sp+4))==b'%1%2';key=cbytes(read32(read32(sp+8))).decode('ascii');index=read32(read32(sp+12));s=key+str(index);u.mem_write(ecx,s.encode('ascii')+b'\0');finish(eax=len(s));return
 if a==0x993ba0:
  text=cbytes(read32(sp+4)).decode('ascii');fmt=cbytes(read32(sp+8)).decode('ascii');assert fmt in ('%f','%f %f');tokens=text.split();n=min(len(tokens),1 if fmt=='%f' else 2)
  for i in range(n):u.mem_write(read32(sp+12+i*4),struct.pack('<f',float(tokens[i])))
  finish(eax=n);return
 if a in (0xc99ab0,0xc99ae0):raise AssertionError('unqualified CRT copy '+hex(a))
 assert any(base+s.VirtualAddress<=a<base+s.VirtualAddress+s.Misc_VirtualSize for s in p.sections if s.Characteristics&0x20000000),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);write32(0x14bef58,0);write32(0x14bef40,0)
u.mem_write(section,b'mist\0');u.mem_write(path,b'fixture.troy\0')
inputs=[('absent',{},'e-rate',100.),('constant',{'e-rate':'5'},'e-rate',100.),('linear',{'e-rate':'5','e-rate1':'0 0','e-rate2':'1 1'},'e-rate',100.),('no-base',{'e-rate1':'0 2','e-rate2':'1 4'},'e-rate',3.),('gap',{'e-rate':'5','e-rate1':'0 0','e-rate3':'1 1'},'e-rate',100.),('incomplete-pair',{'e-rate':'5','e-rate1':'0'},'e-rate',100.),('duplicate',{'e-rate':'2','e-rate1':'0.5 1','e-rate2':'0.5 3'},'e-rate',100.),('rgba-scale',{'e-rgba':'255','e-rgba1':'0 0','e-rgba2':'1 1'},'e-rgba',1.)]
inputs.extend([('rgba-absent-base',{'e-rgba1':'0 2','e-rgba2':'1 4'},'e-rgba',3.),('rgba-case-sensitive',{'E-rgba':'255'},'E-rgba',1.)])
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text());particle_default=struct.unpack('<f',bytes(u.mem_read(0x1138e98,4)))[0]
for definition in catalog['definitions']:
 document=json.loads((r/definition['asset']).read_text())
 for group in definition['groups']:
  if group['declared_type']=='Simple':continue
  section_values=document['sections'][group['name']]
  for key,default in [('e-rate',0.),('p-life',particle_default)]:
   supplied={}
   for field,value in section_values.items():
    if field==key or (field.startswith(key) and field[len(key):].isdigit()):
     assert isinstance(value,(int,float,list));supplied[field]=' '.join(str(v) for v in value) if isinstance(value,list) else str(value)
   inputs.append(('map:'+definition['reference']+':'+group['name']+':'+key,supplied,key,default))
cases=[]
for name,fields,key,default in inputs:
 cursor=heap+0x4000;allocation_cursor=heap+0x10000;calls=[];u.mem_write(obj,b'\0'*24);u.mem_write(keyptr,key.encode('ascii')+b'\0');sp=stack+0x8000;write32(sp,end);write32(sp+4,section);write32(sp+8,keyptr);u.mem_write(sp+12,struct.pack('<f',default));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_EDX,path);u.emu_start(0x94cb60,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 count=(read32(obj+4)-read32(obj))//4;assert count<100;values_count=(read32(obj+16)-read32(obj+12))//4;assert count==values_count
 def values(address):return list(struct.unpack('<'+'f'*count,bytes(u.mem_read(address,4*count)))) if count else []
 cases.append({'name':name,'fields':fields,'key':key,'default':default,'returned':bool(u.reg_read(UC_X86_REG_EAX)&255),'times':values(read32(obj)),'values':values(read32(obj+12)),'lookups':calls})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'reader_entry':'0x94cb60','cases':cases,'original_instruction_addresses':len(visited),'adapters':['Supplied field lookup 8B0750, string storage 564C20, numbered-key formatting 5D74C0, CRT sscanf 993BA0 for explicitly supplied whitespace-separated finite numbers, allocation/free/cookie. Native hashing, reader branches, scaling and vector appends execute.'],'limits':['Original INIBIN lookup/cache and CRT lexical parsing not executed. Malformed lexical input, float extremes and lookup flags unqualified.','Numbered key formatter output supplied; original formatting implementation not qualified.','Native execution of reader is not ordinary emitter integration.']};(r/'data/4.20/scalar_field_reader_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(proof,indent=2))
