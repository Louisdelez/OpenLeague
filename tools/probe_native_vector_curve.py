"""Original94D130 vector fields and94D6B0/94ECB0 nonrotation vector curves."""
from pathlib import Path
import json,struct,datetime,shutil,random,re
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_complex_scalar_parameter.py').read_text(encoding='utf-8').split('\ninputs=')[0].replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook);','\n');exec(compile(setup,'scalar setup','exec'));previous_hook=hook
def hook(uc,a,size,user):
 if a==0x993ba0:
  sp=u.reg_read(UC_X86_REG_ESP);text=cbytes(read32(sp+4)).decode('ascii');fmt=cbytes(read32(sp+8)).decode('ascii');assert fmt in ('%f %f %f','%f %f %f %f');n=min(len(text.split()),fmt.count('%f'))
  for i in range(n):u.mem_write(read32(sp+12+4*i),struct.pack('<f',float(text.split()[i])))
  finish(eax=n);return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
inputs=[('absent',{},'p-scale',[1.,1.,1.]),('constant',{'p-scale':[2.,3.,4.]},'p-scale',[1.,1.,1.]),('linear',{'p-scale':[2.,3.,4.],'p-scale1':[0.,0.,1.,2.],'p-scale2':[1.,2.,3.,4.]},'p-scale',[1.,1.,1.]),('without-base',{'p-scale1':[0.,2.,3.,4.],'p-scale2':[1.,4.,5.,6.]},'p-scale',[2.,3.,4.]),('gap',{'p-scale':[2.,3.,4.],'p-scale1':[0.,0.,1.,2.],'p-scale3':[1.,2.,3.,4.]},'p-scale',[1.,1.,1.]),('incomplete-pair',{'p-scale':[2.,3.,4.],'p-scale1':[0.,5.,6.]},'p-scale',[1.,1.,1.]),('bad-base-count',{'p-scale':[2.]},'p-scale',[1.,1.,1.]),('rgba',{'e-rgba':[255.,128.,64.],'e-rgba1':[0.,0.,0.,0.],'e-rgba2':[1.,1.,1.,1.]},'e-rgba',[1.,1.,1.])]
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text())
for definition in catalog['definitions']:
 document=json.loads((r/definition['asset']).read_text())
 for group in definition['groups']:
  if group['declared_type']=='Simple':continue
  for key,default in [('p-scale',[1.,1.,1.]),('p-postoffset',[0.,0.,0.])]:
   supplied={name:(value if isinstance(value,list) else [value]) for name,value in document['sections'][group['name']].items() if name==key or (name.startswith(key) and name[len(key):].isdigit())};inputs.append(('map:'+definition['reference']+':'+group['name']+':'+key,supplied,key,default))
field_cases=[]
for name,fields,key,default in inputs:
 cursor=heap+0x4000;allocation_cursor=heap+0x10000;calls=[];u.mem_write(obj,b'\0'*24);u.mem_write(keyptr,key.encode('ascii')+b'\0');sp=stack+0x8000;write32(sp,end);write32(sp+4,section);write32(sp+8,keyptr);u.mem_write(sp+12,struct.pack('<3f',*default));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_EDX,path);u.emu_start(0x94d130,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 count=(read32(obj+4)-read32(obj))//4;assert (read32(obj+16)-read32(obj+12))//12==count
 times=list(struct.unpack('<'+'f'*count,bytes(u.mem_read(read32(obj),4*count)))) if count else [];values=[list(struct.unpack('<3f',bytes(u.mem_read(read32(obj+12)+i*12,12)))) for i in range(count)];field_cases.append({'name':name,'key':key,'fields':fields,'default':default,'returned':bool(u.reg_read(UC_X86_REG_EAX)&255),'times':times,'values':values})
datasets=[{'name':'constant','times':[0.],'values':[[2.,3.,4.]]},{'name':'linear','times':[0.,1.],'values':[[0.,-2.,7.],[1.,3.,-5.]]},{'name':'duplicate','times':[0.,.5,.5,1.],'values':[[0.,1.,2.],[1.,2.,3.],[3.,4.,5.],[0.,-1.,-2.]]}]
rng=random.Random(420)
for i in range(8):datasets.append({'name':f'random-{i}','times':sorted([0.,1.]+[f32(rng.random()) for _ in range(5)]),'values':[[f32(rng.uniform(-50,50)) for _ in range(3)] for _ in range(7)]})
knots=heap+0x3000;timesptr=heap+0x6000;valuesptr=heap+0x7000;output=heap+0x8000;sampleout=heap+0x9000;bakes=[];samples=[]
for row in datasets:
 times=row['times'];values=row['values'];n=len(times);u.mem_write(timesptr,struct.pack('<'+'f'*n,*times));u.mem_write(valuesptr,struct.pack('<'+'f'*(n*3),*(v for xyz in values for v in xyz)));u.mem_write(knots,struct.pack('<6I',timesptr,timesptr+n*4,timesptr+n*4,valuesptr,valuesptr+n*12,valuesptr+n*12))
 for count in [0,1,3,7,16,256]:
  allocation_cursor=heap+0x10000;u.mem_write(output,b'\0'*12);sp=stack+0x8000;write32(sp,end);write32(sp+4,knots);write32(sp+8,count);write32(sp+12,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,output);u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(0x94d6b0,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end;actual=(read32(output+4)-read32(output))//12;payload=bytes(u.mem_read(read32(output),actual*12)) if actual else b'';bakes.append({**row,'requested_count':count,'actual_count':actual,'output_bits':[hex(v) for v in struct.unpack('<'+'I'*(actual*3),payload)]})
 for time in [-.1,0.,.25,.5,.500001,.75,1.,1.1]+times:
  time=f32(time);sp=stack+0x8000;write32(sp,end);write32(sp+4,sampleout);u.mem_write(sp+8,struct.pack('<f',time));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,knots);u.emu_start(0x94ecb0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;samples.append({**row,'time':time,'output_bits':[hex(v) for v in struct.unpack('<3I',bytes(u.mem_read(sampleout,12)))]})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'field_reader_entry':'0x94d130','bake_entry':'0x94d6b0','sample_entry':'0x94ecb0','field_cases':field_cases,'bake_cases':bakes,'samples':samples,'original_instruction_addresses':len(visited),'adapters':['Numeric raw-field lookup, CRT sscanf, string/format transport, allocation/free/cookie. Original vector field control, component scaling, lower_bound, SSE interpolation and nonrotation bake execute.'],'limits':['Sorted finite knots only. Supplied defaults in Map10 field fixtures are not proof of each caller default.','Rotation bake flag0 only; rotation conversion mode, axis probability readers, native lexical/cache conversion, runtime age normalization and ordinary rendering remain pending.']};(r/'data/4.20/vector_curve_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'field_cases':len(field_cases),'bake_cases':len(bakes),'samples':len(samples),'table_vectors':sum(v['actual_count'] for v in bakes),'native_addresses':len(visited),'passed':True}))
