"""Execute original RGBA field reader, baker and interpolation on decoded fields."""
from pathlib import Path
import json,struct,datetime,shutil,random,re
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_vector_curve.py').read_text().split('\ninputs=')[0].replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)','\n')
exec(compile(setup,'vector setup','exec'));color_previous_hook=hook
def hook(uc,a,size,user):
 if a==0x993ba0:
  sp=u.reg_read(UC_X86_REG_ESP);text=cbytes(read32(sp+4)).decode('ascii');fmt=cbytes(read32(sp+8)).decode('ascii');assert fmt in ('%f','%f %f','%f %f %f','%f %f %f %f','%f %f %f %f %f');n=min(len(text.split()),fmt.count('%f'))
  for i in range(n):u.mem_write(read32(sp+12+4*i),struct.pack('<f',float(text.split()[i])))
  finish(eax=n);return
 color_previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
inputs=[('absent',{},'e-rgba',[1.]*4),('constant',{'e-rgba':[255.,128.,64.,32.]},'e-rgba',[1.]*4),('linear',{'e-rgba':[255.,128.,64.,32.],'e-rgba1':[0.,0.,1.,2.,3.],'e-rgba2':[1.,2.,3.,4.,5.]},'e-rgba',[1.]*4),('no-base',{'e-rgba1':[0.,2.,3.,4.,5.],'e-rgba2':[1.,4.,5.,6.,7.]},'e-rgba',[2.,3.,4.,5.]),('gap',{'e-rgba':[255.]*4,'e-rgba1':[0.,0.,1.,2.,3.],'e-rgba3':[1.,2.,3.,4.,5.]},'e-rgba',[1.]*4),('bad-pair',{'e-rgba':[255.]*4,'e-rgba1':[0.,5.,6.,7.]},'e-rgba',[1.]*4),('bad-base',{'e-rgba':[2.]},'e-rgba',[1.]*4),('case-sensitive',{'E-rgba':[255.,128.,64.,32.]},'E-rgba',[1.]*4)]
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text())
for definition in catalog['definitions']:
 document=json.loads((r/definition['asset']).read_text())
 for group in definition['groups']:
  if group['declared_type']=='Simple':continue
  supplied={name:(v if isinstance(v,list) else [v]) for name,v in document['sections'][group['name']].items() if re.fullmatch(r'e-rgba\d*',name)}
  inputs.append(('map:'+definition['reference']+':'+group['name'],supplied,'e-rgba',[1.]*4))
field_cases=[]
for name,fields,key,default in inputs:
 cursor=heap+0x4000;allocation_cursor=heap+0x10000;calls=[];u.mem_write(obj,b'\0'*24);u.mem_write(keyptr,key.encode()+b'\0');sp=stack+0x8000;write32(sp,end);write32(sp+4,section);write32(sp+8,keyptr);u.mem_write(sp+12,struct.pack('<4f',*default));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_EDX,path);u.emu_start(0x9498c0,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 count=(read32(obj+4)-read32(obj))//4;assert (read32(obj+16)-read32(obj+12))//16==count
 times=list(struct.unpack('<'+'f'*count,bytes(u.mem_read(read32(obj),4*count)))) if count else []
 values=[list(struct.unpack('<4f',bytes(u.mem_read(read32(obj+12)+i*16,16)))) for i in range(count)]
 field_cases.append({'name':name,'key':key,'fields':fields,'default':default,'returned':bool(u.reg_read(UC_X86_REG_EAX)&255),'times':times,'values':values})
datasets=[{'name':'constant','times':[.25],'values':[[2.,3.,4.,5.]]},{'name':'linear','times':[0.,1.],'values':[[0.,-2.,7.,.5],[1.,3.,-5.,1.]]},{'name':'duplicate','times':[0.,.5,.5,1.],'values':[[0.,1.,2.,3.],[1.,2.,3.,4.],[3.,4.,5.,6.],[0.,-1.,-2.,-3.]]}]
rng=random.Random(420)
for i in range(8):datasets.append({'name':f'random-{i}','times':sorted([0.,1.]+[f32(rng.random()) for _ in range(5)]),'values':[[f32(rng.uniform(-50,50)) for _ in range(4)] for _ in range(7)]})
knots=heap+0x3000;timesptr=heap+0x6000;valuesptr=heap+0x7000;output=heap+0x8000;sampleout=heap+0x9000;bakes=[];samples=[]
for row in datasets:
 times=row['times'];values=row['values'];n=len(times);u.mem_write(timesptr,struct.pack('<'+'f'*n,*times));u.mem_write(valuesptr,struct.pack('<'+'f'*(n*4),*(v for rgba in values for v in rgba)));u.mem_write(knots,struct.pack('<6I',timesptr,timesptr+n*4,timesptr+n*4,valuesptr,valuesptr+n*16,valuesptr+n*16))
 for count in [0,1,3,7,16,256]:
  allocation_cursor=heap+0x10000;u.mem_write(output,b'\0'*12);sp=stack+0x8000;write32(sp,end);write32(sp+4,knots);write32(sp+8,count);write32(sp+12,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,output);u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(0x94de30,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
  actual=(read32(output+4)-read32(output))//16;payload=bytes(u.mem_read(read32(output),actual*16)) if actual else b'';bakes.append({**row,'requested_count':count,'actual_count':actual,'output_bits':[hex(v) for v in struct.unpack('<'+'I'*(actual*4),payload)]})
 for time in [-.1,0.,.25,.5,.500001,.75,1.,1.1]+times:
  time=f32(time);sp=stack+0x8000;write32(sp,end);write32(sp+4,sampleout);u.mem_write(sp+8,struct.pack('<f',time));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,knots);u.emu_start(0x949750,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
  samples.append({**row,'time':time,'output_bits':[hex(v) for v in struct.unpack('<4I',bytes(u.mem_read(sampleout,16)))]})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'field_reader_entry':'0x9498c0','bake_entry':'0x94de30','sample_entry':'0x949750','field_cases':field_cases,'bake_cases':bakes,'samples':samples,'original_instruction_addresses':len(visited),'adapters':['Decoded numeric raw getters, CRT sscanf, string/format transport, allocation/free/cookie. Original RGBA reader, component scaling, lower_bound, interpolation and baker execute.'],'limits':['Sorted finite nonempty knots only. Map default supplied as fixture, caller fallback still requires execution.','Full RGBA parameter probabilities, runtime normalized age and ordinary graphical consumers remain pending. Raw lexical/cache conversion not qualified.']}
(r/'data/4.20/color_curve_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'field_cases':len(field_cases),'bake_cases':len(bakes),'samples':len(samples),'rgba_values':sum(v['actual_count'] for v in bakes),'passed':True}))
