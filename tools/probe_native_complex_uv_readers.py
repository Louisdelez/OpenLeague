"""Original four2D UV configuration callers,94AF20 and reader/baker/probabilities."""
from pathlib import Path
import json,struct,datetime,shutil,re
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_complex_scalar_parameter.py').read_text().split('\ninputs=')[0].replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook);','\n');exec(compile(setup,'scalar setup','exec'));previous_hook=hook;stop_address=None;reader_result=None;reader_return=0;arguments=[]
def hook(uc,a,size,user):
 global reader_result
 if a==stop_address:uc.emu_stop();return
 if a==reader_return:reader_result=bool(u.reg_read(UC_X86_REG_EAX)&255)
 if a==0x94af20:
  sp=u.reg_read(UC_X86_REG_ESP);arguments.append({'key':cbytes(read32(sp+12)).decode(),'default':list(struct.unpack('<2f',bytes(u.mem_read(sp+24,8))))})
 if a==0x993ba0:
  sp=u.reg_read(UC_X86_REG_ESP);text=cbytes(read32(sp+4)).decode('ascii');fmt=cbytes(read32(sp+8)).decode('ascii');assert fmt in ('%f %f','%f %f %f');tokens=text.split();n=min(len(tokens),fmt.count('%f'))
  for axis in range(n):u.mem_write(read32(sp+12+axis*4),struct.pack('<f',float(tokens[axis])))
  finish(eax=n);return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
emitter=heap+0xa000;prior=heap+0xb000
bindings=[('e-uvoffset',0x913549,0x91359d,0x25c,0x913579,False),('e-uvoffset-mult',0x91359d,0x9135f1,0x274,0x9135cd,False),('p-uvscroll-rgb',0x914dbc,0x914e07,0x228,0x914de5,True),('p-uvscroll-rgb-mult',0x914e07,0x914e52,0x294,0x914e30,True)]
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text());groups=[]
for definition in catalog['definitions']:
 doc=json.loads((r/definition['asset']).read_text())
 for group in definition['groups']:
  if group['declared_type']!='Simple':groups.append((definition['reference']+':'+group['name'],doc['sections'][group['name']]))
cases=[]
for key,start,stop,offset,returned,global_config in bindings:
 fixtures=[('absent',{}),('constant',{key:[2.,3.]}),('numbered',{key:[2.,3.],key+'1':[0.,.5,1.],key+'2':[1.,1.5,2.]}),('without-base',{key+'1':[0.,.5,1.],key+'2':[1.,1.5,2.]}),('probability',{key:[2.,3.],key+'XP1':[0.,.5],key+'XP2':[1.,1.5],key+'YP':[2.]})]
 for name,values in groups:
  supplied={name:(v if isinstance(v,list) else [v]) for name,v in values.items() if re.fullmatch(re.escape(key)+r'(?:\d+|[XY]P\d*)?',name)};fixtures.append(('map:'+name,supplied))
 for prior_count in [0,1]:
  for name,fields in fixtures:
   cursor=heap+0x4000;allocation_cursor=heap+0x10000;calls=[];arguments=[];reader_result=None;reader_return=returned;stop_address=stop;u.mem_write(emitter,b'\0'*0x584)
   if prior_count:u.mem_write(prior,struct.pack('<2f',9.,8.));u.mem_write(emitter+offset,struct.pack('<3I',prior,prior+8,prior+8))
   sp=stack+0x8000;u.mem_write(sp-0x200,b'\0'*0x800);write32(sp+16,path);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,stack+0x9000);u.reg_write(UC_X86_REG_FPCW,0x37f)
   if global_config:u.reg_write(UC_X86_REG_ESI,emitter);u.reg_write(UC_X86_REG_EDI,section);u.reg_write(UC_X86_REG_EBX,path)
   else:u.reg_write(UC_X86_REG_EDI,emitter);u.reg_write(UC_X86_REG_ESI,section)
   u.emu_start(start,stop,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==stop and len(arguments)==1 and reader_result is not None;assert arguments[0]['key']==key
   target=emitter+offset;n=(read32(target+4)-read32(target))//8;payload=bytes(u.mem_read(read32(target),n*8));probabilities=[]
   for axis in range(2):
    prob=read32(target+12+axis*4);value=None
    if prob:
     count=(read32(prob+24)-read32(prob+20))//4
     def decoded(off):return list(struct.unpack('<'+'f'*count,bytes(u.mem_read(read32(prob+off),count*4)))) if count else []
     value={'constant':bool(u.mem_read(prob,1)[0]),'constant_bits':hex(read32(prob+4)),'fast':bool(u.mem_read(prob+8,1)[0]),'begin_bits':hex(read32(prob+12)),'difference_bits':hex(read32(prob+16)),'times':decoded(20),'values':decoded(32)}
    probabilities.append(value)
   cases.append({'name':name,'key':key,'prior_count':prior_count,'fields':fields,'arguments':arguments[0],'reader_returned':reader_result,'table_bits':[hex(v) for v in struct.unpack('<'+'I'*(n*2),payload)],'probabilities':probabilities})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Decoded numeric field getters, CRT scanf/string/format transport, heap/free/cookie and initialized probability startup. Original four caller argument/default/fallback fragments,94AF20,94C300,94DF00,94E420,94EDF0 and91B410 execute. Legal zero/one-vector prior storage supplied.'],'limits':['Finite sorted numeric fields only. Raw INIBIN/text/cache/lexical conversion not qualified. Other2Dparameter keys and rotation normalization outside UV scope.','UV runtime probability draw/caller sequence, initial stored birth offset/rates and ordinary material/render binding still unqualified.']}
(r/'data/4.20/complex_uv_readers_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'map_cases':sum(c['name'].startswith('map:') for c in cases),'defaults':{c['key']:c['arguments']['default'] for c in cases if c['name']=='absent'},'passed':True}))
