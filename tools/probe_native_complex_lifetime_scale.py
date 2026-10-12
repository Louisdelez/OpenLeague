"""Execute original Complex call arguments, vector reader and missing fallbacks."""
from pathlib import Path
import json,struct,datetime,shutil,re
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_vector_parameter.py').read_text(encoding='utf-8').split('\nbaseproof=')[0].replace(';u.hook_add(unicorn.UC_HOOK_CODE,hook)','');exec(compile(setup,'vector setup','exec'));vector_hook=hook;stop_address=None;arguments=[];current_return=0;reader_result=None
def hook(uc,a,size,user):
 global reader_result
 if a==stop_address:uc.emu_stop();return
 if a==current_return:reader_result=bool(u.reg_read(UC_X86_REG_EAX)&255)
 if a==0x94aa60:
  sp=u.reg_read(UC_X86_REG_ESP);arguments.append({'key':cbytes(read32(sp+12)).decode('ascii'),'default':list(struct.unpack('<3f',bytes(u.mem_read(sp+16,12)))),'mode':read32(sp+28),'count':read32(sp+32),'path':cbytes(read32(sp+4)).decode('ascii'),'section':cbytes(read32(sp+8)).decode('ascii')})
 vector_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
emitter=heap+0xa000;prior=heap+0xb000
bindings=[('p-xscale',0x915187,0x9151f6,0x324)]
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text());groups=[]
for definition in catalog['definitions']:
 document=json.loads((r/definition['asset']).read_text())
 for group in definition['groups']:
  if group['declared_type']!='Simple':groups.append((definition['reference']+':'+group['name'],document['sections'][group['name']]))
cases=[]
for key,start,stop,offset in bindings:
 fixtures=[('absent',{}),('constant',{key:[2.,3.,4.]}),('numbered',{key:[2.,3.,4.],key+'1':[0.,0.,1.,2.],key+'2':[1.,2.,3.,4.]}),('probability',{key:[2.,3.,4.],key+'XP1':[0.,.5],key+'XP2':[1.,1.5],key+'YP':[2.]})]
 for name,values in groups:
  supplied={name:(v if isinstance(v,list) else [v]) for name,v in values.items() if re.fullmatch(re.escape(key)+r'(?:\d+|[XYZ]P\d*)?',name)};fixtures.append(('map:'+name,supplied))
 for prior_count in [0,1]:
  for name,fields in fixtures:
   cursor=heap+0x4000;allocation_cursor=heap+0x10000;arguments=[];calls=[];current_return=0x9151cb;stop_address=stop;reader_result=None;u.mem_write(emitter,b'\0'*0x584)
   if prior_count:u.mem_write(prior,struct.pack('<3f',9.,8.,7.));u.mem_write(emitter+offset,struct.pack('<3I',prior,prior+12,prior+12))
   sp=stack+0x8000;u.mem_write(sp-0x200,b'\0'*0x800);write32(sp+16,path);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,emitter);u.reg_write(UC_X86_REG_EDI,section);u.reg_write(UC_X86_REG_EBX,path);u.reg_write(UC_X86_REG_EBP,stack+0x9000);u.reg_write(UC_X86_REG_EAX,0);u.emu_start(start,stop,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==stop and len(arguments)==1;arg=arguments[0];assert arg['key']==key and arg['path']=='fixture.troy' and arg['section']=='mist'
   target=emitter+offset;n=(read32(target+4)-read32(target))//12;payload=bytes(u.mem_read(read32(target),n*12));probabilities=[]
   for axis in range(3):
    prob=read32(target+12+axis*4);value=None
    if prob:
     c=(read32(prob+24)-read32(prob+20))//4
     def decoded(position):return list(struct.unpack('<'+'f'*c,bytes(u.mem_read(read32(prob+position),c*4)))) if c else []
     value={'constant':bool(u.mem_read(prob,1)[0]),'constant_bits':hex(read32(prob+4)),'fast':bool(u.mem_read(prob+8,1)[0]),'begin_bits':hex(read32(prob+12)),'difference_bits':hex(read32(prob+16)),'times':decoded(20),'values':decoded(32)}
    probabilities.append(value)
   assert reader_result is not None
   cases.append({'name':name,'key':key,'prior_count':prior_count,'start':hex(start),'stop':hex(stop),'offset':hex(offset),'arguments':arg,'fields':fields,'reader_returned':reader_result,'table_bits':[hex(v) for v in struct.unpack('<'+'I'*(n*3),payload)],'probabilities':probabilities})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Decoded raw numeric getters, CRT/string/format/heap/cookie transport. Original call argument setup, full vector reader and caller missing-field resize/value writes execute. Caller scratch frame/file/section and legal prior vector state supplied.'],'limits':['Fragments qualify each vector call and fallback, not whole Complex constructor/parser execution. Other fields, raw lexical/cache parity and ordinary rendered lifecycle pending.','Prior fixture covers legal zero/one-vector storage with null probability pointers; arbitrary caller corruption unsupported.']};(r/'data/4.20/complex_lifetime_scale_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'map_cases':sum(c['name'].startswith('map:') for c in cases),'native_addresses':len(visited),'defaults':{c['key']:c['arguments'] for c in cases if c['name']=='absent' and c['prior_count']==0},'passed':True}))
