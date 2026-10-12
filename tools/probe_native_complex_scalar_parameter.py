"""Original94A7F0 scalar parameter reader, including bake/probability calls."""
from pathlib import Path
import json,struct,datetime,shutil,re
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text(encoding='utf-8').split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'probability setup','exec'));old_hook=hook
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0x8b0750:
  key=cbytes(read32(ecx+4)).decode('ascii');numbers=fields.get(key);value='' if numbers is None else ' '.join(str(v) for v in numbers);out=read32(sp+4);u.mem_write(out,value.encode('ascii')+b'\0');calls.append({'key':key,'kind':'scalar-raw'});finish(eax=out);return
 if a==0x564c20:
  src,n=read32(sp+4),read32(sp+8);put(ecx,bytes(u.mem_read(src,n)).decode('ascii'));finish(8,ecx);return
 if a==0x5f82a0:
  count=read32(sp+4);char=read32(sp+8)&255;assert count==1;put(ecx,string(ecx)+chr(char));finish(8,ecx);return
 if a==0x5d74c0:
  assert cbytes(read32(sp+4))==b'%1%2';s=cbytes(read32(read32(sp+8)))+str(read32(read32(sp+12))).encode('ascii');u.mem_write(ecx,s+b'\0');finish(eax=len(s));return
 if a==0x993ba0:
  text=cbytes(read32(sp+4)).decode('ascii');fmt=cbytes(read32(sp+8)).decode('ascii');assert fmt in ('%f','%f %f');tokens=text.split();count=min(len(tokens),1 if fmt=='%f' else 2)
  for index in range(count):u.mem_write(read32(sp+12+index*4),struct.pack('<f',float(tokens[index])))
  finish(eax=count);return
 old_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.mem_write(0x2d77b20,b'\1')
inputs=[('absent',{},'e-rate',0.),('constant',{'p-life':[2.]},'p-life',1.),('XP-only',{'p-life':[2.],'p-lifeXP1':[0.,10.],'p-lifeXP2':[1.,20.]},'p-life',1.),('P-over-XP',{'p-life':[2.],'p-lifeXP1':[0.,10.],'p-lifeXP2':[1.,20.],'p-lifeP1':[0.,.5],'p-lifeP2':[1.,1.5]},'p-life',1.),('scaled-base',{'p-life':[2.],'p-life1':[0.,1.],'p-life2':[1.,3.],'p-lifeP':[.5]},'p-life',1.),('negative',{'p-life':[-2.]},'p-life',1.)]
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text());particle_default=float_at(0x1138e98)
for definition in catalog['definitions']:
 document=json.loads((r/definition['asset']).read_text())
 for group in definition['groups']:
  if group['declared_type']=='Simple':continue
  for key,default in [('e-rate',0.),('p-life',particle_default)]:
   values=document['sections'][group['name']];supplied={name:(value if isinstance(value,list) else [value]) for name,value in values.items() if re.fullmatch(re.escape(key)+r'(?:\d+|XP\d*|P\d*)?',name)};inputs.append(('map:'+definition['reference']+':'+group['name']+':'+key,supplied,key,default))
cases=[]
for name,fields,key,default in inputs:
 cursor=heap+0x4000;allocation_cursor=heap+0x10000;calls=[];u.mem_write(obj,b'\0'*20);u.mem_write(keyptr,key.encode('ascii')+b'\0');sp=stack+0x8000;write32(sp,end)
 for offset,value in [(4,path),(8,section),(12,keyptr),(20,0),(24,0)]:write32(sp+offset,value)
 u.mem_write(sp+16,struct.pack('<f',default));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.emu_start(0x94a7f0,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 count=(read32(obj+4)-read32(obj))//4;payload=bytes(u.mem_read(read32(obj),count*4)) if count else b'';prob=read32(obj+12);probability=None
 if prob:
  n=(read32(prob+24)-read32(prob+20))//4
  def values(offset):return list(struct.unpack('<'+'f'*n,bytes(u.mem_read(read32(prob+offset),n*4)))) if n else []
  probability={'constant':bool(u.mem_read(prob,1)[0]),'constant_bits':hex(read32(prob+4)),'fast':bool(u.mem_read(prob+8,1)[0]),'begin_bits':hex(read32(prob+12)),'difference_bits':hex(read32(prob+16)),'times':values(20),'values':values(32)}
 cases.append({'name':name,'key':key,'default':default,'fields':fields,'returned':bool(u.reg_read(UC_X86_REG_EAX)&255),'maximum_bits':hex(read32(obj+16)),'table_bits':[hex(v) for v in struct.unpack('<'+'I'*count,payload)],'probability':probability,'lookups':calls})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'0x94a7f0','cases':cases,'original_instruction_addresses':len(visited),'adapters':['Decoded field getters, CRT/string/format transport, allocation/free/cookie. Original94A7F0/94C060/94CB60/94D080/94EC10/91B410 execute. Probability global initializer marked already initialized.'],'limits':['Raw getter/cache/lexical parity and global startup initializer not qualified.','Missing emitter-field caller fallback is outside this reader and covered by separate prior contract.','Ordinary emitter/render integration pending.']};(r/'data/4.20/complex_scalar_parameter_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'examples':[{k:c[k] for k in ['name','maximum_bits','probability']} for c in cases[:6]],'passed':True}))
