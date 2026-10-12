"""Original91B410 parameter reader and91B770 SSE curve evaluator."""
from pathlib import Path
import sys,struct,json,datetime,shutil
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'));base=p.OPTIONAL_HEADER.ImageBase
u.mem_map(heap+0x10000,0x100000);obj=heap+0x1000;keyptr=heap+0x2100;path=heap+0x2200;result=heap+0x2300;section=heap+0x2400;stub=end+0x100;capture=end+0x120
u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',result)+b'\xc3');u.mem_write(capture,b'\xd9\x1d'+struct.pack('<I',result)+b'\xc3')
cursor=heap+0x4000;allocation_cursor=heap+0x10000;visited=set();calls=[];fields={}
f32=lambda v:struct.unpack('<f',struct.pack('<f',v))[0]
def float_at(a):return struct.unpack('<f',bytes(u.mem_read(a,4)))[0]
sentinel=float_at(0x1139294);constants={hex(a):float_at(a) for a in (0x1139294,0x11389a0,0x11392b8,0x1138c78,0x1138c70)}
def hook(uc,a,size,user):
 global allocation_cursor
 if stub<=a<stub+7 or capture<=a<capture+7:return
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a in (0xc9f39b,0x9933e0):
  n=read32(sp+4);assert 0<n<65536;ptr=allocation_cursor;allocation_cursor+=(n+31)&~15;u.mem_write(ptr,b'\xa5'*n);finish(eax=ptr);return
 if a==0xc98528:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a==0xc9811c:
  out=read32(sp+4);fmt=cbytes(read32(sp+8));assert fmt==b'%s%d';s=cbytes(read32(sp+12))+str(read32(sp+16)).encode('ascii');u.mem_write(out,s+b'\0');finish(eax=len(s));return
 if a==0x8b2030:
  descriptor=u.reg_read(UC_X86_REG_EDX);key=cbytes(read32(descriptor+4)).decode('ascii');value=fields.get(key);calls.append({'key':key,'kind':'scalar'});v=sentinel if value is None else float(value[0]);u.mem_write(result,struct.pack('<f',v));u.reg_write(UC_X86_REG_EIP,stub);return
 if a==0x8b25b0:
  descriptor=read32(sp+4);key=cbytes(read32(descriptor+4)).decode('ascii');values=fields.get(key);calls.append({'key':key,'kind':'pair'});v=values if values is not None and len(values)>=2 else [sentinel,0.];u.mem_write(ecx,struct.pack('<2f',*v[:2]));finish(eax=ecx);return
 assert any(base+s.VirtualAddress<=a<base+s.VirtualAddress+s.Misc_VirtualSize for s in p.sections if s.Characteristics&0x20000000),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);write32(0x14bef58,0);write32(0x14bef40,0);u.mem_write(path,b'fixture.troy\0');u.mem_write(section,b'mist\0')
# Hash the section with original code, not a replacement implementation.
sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,section);u.emu_start(0x8e5210,end,count=10000);section_hash=u.reg_read(UC_X86_REG_EAX)
inputs=[('absent',{}),('constant',{'p-lifeP':[2.]}),('constant-overrides-numbered',{'p-lifeP':[3.],'p-lifeP1':[0.,10.],'p-lifeP2':[1.,20.]}),('linear',{'p-lifeP1':[0.,1.2],'p-lifeP2':[1.,.8]}),('single-point',{'p-lifeP1':[.5,7.]}),('bell',{'p-lifeP1':[0.,0.],'p-lifeP2':[.25,2.],'p-lifeP3':[.75,2.],'p-lifeP4':[1.,0.]}),('duplicates',{'p-lifeP1':[0.,0.],'p-lifeP2':[.5,1.],'p-lifeP3':[.5,3.],'p-lifeP4':[1.,0.]}),('gap',{'p-lifeP1':[0.,1.],'p-lifeP3':[1.,5.]})]
for start in [-.00011,-.0001,0.,.0001,.00011]:
 for stop in [.99989,.9999,1.,1.0001,1.00011]:inputs.append((f'fast-bounds:{start}:{stop}',{'p-lifeP1':[start,2.],'p-lifeP2':[stop,5.]}))
for start in [-.000002,constants['0x11392b8'],-.0000005,0.,.0000005,constants['0x11389a0'],.000002]:
 for stop in [.999998,constants['0x1138c70'],.9999995,1.,1.0000005,constants['0x1138c78'],1.000002]:inputs.append((f'fast-exact-bounds:{start}:{stop}',{'p-lifeP1':[start,2.],'p-lifeP2':[stop,5.]}))
inputs.append(('sentinel-constant-with-knots',{'p-lifeP':[sentinel],'p-lifeP1':[0.,2.],'p-lifeP2':[1.,3.]}))
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text())
for definition in catalog['definitions']:
 document=json.loads((r/definition['asset']).read_text())
 for group in definition['groups']:
  if group['declared_type']=='Simple':continue
  authored=document['sections'][group['name']]
  for key in ('e-rateP','e-rateXP','p-lifeP','p-lifeXP'):
   supplied={name:(value if isinstance(value,list) else [value]) for name,value in authored.items() if name==key or (name.startswith(key) and name[len(key):].isdigit())}
   inputs.append(('map:'+definition['reference']+':'+group['name']+':'+key,supplied))
cases=[];samples=[]
for name,fields in inputs:
 key=name.rsplit(':',1)[-1] if name.startswith('map:') else 'p-lifeP';cursor=heap+0x4000;allocation_cursor=heap+0x10000;calls=[];u.mem_write(obj,b'\0'*44);u.mem_write(keyptr,key.encode('ascii')+b'\0');sp=stack+0x8000;write32(sp,end)
 for offset,value in [(4,path),(8,section_hash),(12,section),(16,keyptr),(20,0)]:write32(sp+offset,value)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.emu_start(0x91b410,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 count=(read32(obj+24)-read32(obj+20))//4;assert count<100
 def values(address):return list(struct.unpack('<'+'f'*count,bytes(u.mem_read(address,4*count)))) if count else []
 row={'name':name,'key':key,'fields':fields,'returned':bool(u.reg_read(UC_X86_REG_EAX)&255),'constant':bool(u.mem_read(obj,1)[0]),'constant_bits':hex(read32(obj+4)),'fast':bool(u.mem_read(obj+8,1)[0]),'begin_bits':hex(read32(obj+12)),'difference_bits':hex(read32(obj+16)),'times':values(read32(obj+20)),'values':values(read32(obj+32)),'lookups':calls};cases.append(row)
 if row['returned']:
  for time in [-.1,0.,.25,.5,.500001,.75,1.,1.1]+row['times']:
   time=f32(time);sp=stack+0x8000;write32(sp,capture);u.mem_write(sp+4,struct.pack('<f',time));write32(sp+8,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.emu_start(0x91b770,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;samples.append({'case':name,'time':time,'output_bits':hex(read32(result))})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'reader_entry':'0x91b410','sample_entry':'0x91b770','constants':constants,'cases':cases,'samples':samples,'original_instruction_addresses':len(visited),'adapters':['Decoded numeric scalar/pair lookup, numbered-key sprintf, heap/cookie and x87 return transport. Original hashing, branches, vector appends, tolerance checks and SSE interpolation execute.'],'limits':['Native raw getters, cache, lexical conversion and malformed field behavior not qualified.','91B770 interpolates a supplied parameter. RNG call site, fast uniform optimization and ordinary emitter integration remain unqualified.']};(r/'data/4.20/probability_curve_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'samples':len(samples),'constants':constants,'native_addresses':len(visited),'map_authored':[(v['name'],v['times'],v['values']) for v in cases if v['name'].startswith('map:') and v['times']],'passed':True}))
