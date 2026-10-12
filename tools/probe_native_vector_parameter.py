"""Original94AA60 complete nonrotation vector reader with axis probabilities."""
from pathlib import Path
import json,struct,datetime,shutil,re
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_vector_curve.py').read_text(encoding='utf-8').split('\ninputs=')[0].replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)','\n');exec(compile(setup,'vector setup','exec'));u.hook_add(unicorn.UC_HOOK_CODE,hook)
baseproof=json.loads((r/'data/4.20/vector_curve_contract.json').read_text());inputs=[];catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text());mapfields={}
for definition in catalog['definitions']:
 document=json.loads((r/definition['asset']).read_text())
 for group in definition['groups']:
  if group['declared_type']=='Simple':continue
  for key in ['p-scale','p-postoffset']:mapfields['map:'+definition['reference']+':'+group['name']+':'+key]=document['sections'][group['name']]
for row in baseproof['field_cases']:
 fields=row['fields'].copy();key=row['key']
 if row['name'] in mapfields:
  fields.update({name:(value if isinstance(value,list) else [value]) for name,value in mapfields[row['name']].items() if re.fullmatch(re.escape(key)+r'[XYZ]P\d*',name)})
 inputs.append((row['name'],fields,key,row['default'],0))
for count in [16,256,512]:inputs.append((f'requested:{count}',{'p-scale':[2.,3.,4.],'p-scale1':[0.,0.,1.,2.],'p-scale2':[1.,2.,3.,4.],'p-scaleXP1':[0.,.5],'p-scaleXP2':[1.,1.5],'p-scaleYP':[2.]},'p-scale',[1.,1.,1.],count))
cases=[]
for name,fields,key,default,count in inputs:
 cursor=heap+0x4000;allocation_cursor=heap+0x10000;calls=[];u.mem_write(obj,b'\0'*28);u.mem_write(keyptr,key.encode('ascii')+b'\0');sp=stack+0x8000;write32(sp,end);write32(sp+4,path);write32(sp+8,section);write32(sp+12,keyptr);u.mem_write(sp+16,struct.pack('<3f',*default));write32(sp+28,0);write32(sp+32,count);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(0x94aa60,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 n=(read32(obj+4)-read32(obj))//12;payload=bytes(u.mem_read(read32(obj),n*12)) if n else b'';probabilities=[]
 for axis in range(3):
  prob=read32(obj+12+axis*4);value=None
  if prob:
   c=(read32(prob+24)-read32(prob+20))//4
   def values(offset):return list(struct.unpack('<'+'f'*c,bytes(u.mem_read(read32(prob+offset),c*4)))) if c else []
   value={'constant':bool(u.mem_read(prob,1)[0]),'constant_bits':hex(read32(prob+4)),'fast':bool(u.mem_read(prob+8,1)[0]),'begin_bits':hex(read32(prob+12)),'difference_bits':hex(read32(prob+16)),'times':values(20),'values':values(32)}
  probabilities.append(value)
 cases.append({'name':name,'fields':fields,'key':key,'default':default,'requested_count':count,'returned':bool(u.reg_read(UC_X86_REG_EAX)&255),'actual_count':n,'table_bits':[hex(v) for v in struct.unpack('<'+'I'*(n*3),payload)],'probabilities':probabilities,'state_bits':hex(read32(obj+24))})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'0x94aa60','rotation_mode':0,'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Decoded numeric raw getters/CRT/string/format/heap/cookie transport; probability startup marked initialized. Original full vector reader, field reader, baker and all axis probability readers execute.'],'limits':['Nonrotation only; native lexical/cache/startup/default-call-site parity not proven.','Axis probability sampling order, vector runtime age normalization and ordinary rendering remain pending.']};(r/'data/4.20/vector_parameter_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'vectors':sum(c['actual_count'] for c in cases),'passed':True}))
