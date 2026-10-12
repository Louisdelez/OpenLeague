"""Original lifetime p-xrgba caller, full94ACC0 reader, missing-field fallback."""
from pathlib import Path
import json,struct,datetime,shutil,re
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_color_curve.py').read_text().split('\ninputs=')[0].replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)','\n');exec(compile(setup,'color setup','exec'));previous_color_hook=hook
reader_result=None;arguments=[]
def hook(uc,a,size,user):
 global reader_result
 if a==0x915243:reader_result=bool(u.reg_read(UC_X86_REG_EAX)&255)
 if a==0x94acc0:
  sp=u.reg_read(UC_X86_REG_ESP);arguments.append({'key':cbytes(read32(sp+12)).decode(),'default':list(struct.unpack('<4f',bytes(u.mem_read(sp+24,16))))})
 previous_color_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
emitter=heap+0xa000;prior=heap+0xb000
fixtures=[('absent',{}),('constant',{'p-xrgba':[255.,128.,64.,32.]}),('linear',{'p-xrgba':[255.]*4,'p-xrgba1':[0.,0.,1.,2.,3.],'p-xrgba2':[1.,2.,3.,4.,5.]}),('probabilities',{'p-xrgba':[255.]*4,'p-xrgbaRP':[.5],'p-xrgbaGP1':[0.,.5],'p-xrgbaGP2':[1.,1.5],'p-xrgbaBP1':[1.,3.],'p-xrgbaBP2':[0.,1.],'p-xrgbaAP':[2.]}),('bad-base',{'p-xrgba':[255.]}),('numbered-no-base',{'p-xrgba1':[0.,0.,1.,2.,3.],'p-xrgba2':[1.,2.,3.,4.,5.]})]
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text())
for definition in catalog['definitions']:
 document=json.loads((r/definition['asset']).read_text())
 for group in definition['groups']:
  if group['declared_type']=='Simple':continue
  supplied={name:(v if isinstance(v,list) else [v]) for name,v in document['sections'][group['name']].items() if re.fullmatch(r'p-xrgba(?:\d+|[RGBA]P\d*)?',name)}
  fixtures.append(('map:'+definition['reference']+':'+group['name'],supplied))
cases=[]
for prior_count in [0,1]:
 for name,fields in fixtures:
  cursor=heap+0x4000;allocation_cursor=heap+0x10000;arguments=[];calls=[];reader_result=None;u.mem_write(emitter,b'\0'*0x584)
  if prior_count:u.mem_write(prior,struct.pack('<4f',9.,8.,7.,6.));u.mem_write(emitter+0x340,struct.pack('<3I',prior,prior+16,prior+16))
  sp=stack+0x8000;u.mem_write(sp-0x200,b'\0'*0x800);write32(sp+16,path);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,emitter);u.reg_write(UC_X86_REG_EDI,section);u.reg_write(UC_X86_REG_EBX,path);u.reg_write(UC_X86_REG_EBP,stack+0x9000);u.reg_write(UC_X86_REG_EAX,0);u.emu_start(0x9151f6,0x915271,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==0x915271 and len(arguments)==1 and reader_result is not None
  target=emitter+0x340;n=(read32(target+4)-read32(target))//16;payload=bytes(u.mem_read(read32(target),n*16));probabilities=[]
  for channel in range(4):
   prob=read32(target+12+channel*4);value=None
   if prob:
    c=(read32(prob+24)-read32(prob+20))//4
    def decoded(position):return list(struct.unpack('<'+'f'*c,bytes(u.mem_read(read32(prob+position),c*4)))) if c else []
    value={'constant':bool(u.mem_read(prob,1)[0]),'constant_bits':hex(read32(prob+4)),'fast':bool(u.mem_read(prob+8,1)[0]),'begin_bits':hex(read32(prob+12)),'difference_bits':hex(read32(prob+16)),'times':decoded(20),'values':decoded(32)}
   probabilities.append(value)
  cases.append({'name':name,'prior_count':prior_count,'fields':fields,'arguments':arguments[0],'reader_returned':reader_result,'table_bits':[hex(v) for v in struct.unpack('<'+'I'*(n*4),payload)],'probabilities':probabilities})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'caller_start':'0x9151f6','reader_entry':'0x94acc0','cases':cases,'original_instruction_addresses':len(visited),'adapters':['Decoded numeric raw getters, CRT/string/format/heap/cookie transport; scratch frame/file/section and legal prior zero/one-vector state. Original caller arguments, full reader/baker/RGBA probability readers and missing fallback execute.'],'limits':['Raw lexical/cache parity, whole constructor and malformed prior state not covered. Runtime RGBA probability application/order, normalized age producer and ordinary rendering remain pending.']}
(r/'data/4.20/complex_lifetime_color_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'map_cases':sum(c['name'].startswith('map:') for c in cases),'arguments':cases[0]['arguments'],'passed':True}))
