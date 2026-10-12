"""Original p-linger/e-linger scalar caller defaults and clamp branches."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text().split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'));base=p.OPTIONAL_HEADER.ImageBase
obj=heap+0x1000;group=heap+0x2000;path=heap+0x2200;float_cell=heap+0x2400;dummy=heap+0x2600;stub=end+0x100;u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',float_cell)+b'\xc3');u.mem_write(group,b'fixture\0');u.mem_write(path,b'fixture.troy\0');u.mem_write(dummy,b'\0'*8);visited=set();requests=[];fields={}
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x8b1f50:
  assert cbytes(read32(sp+4))==cbytes(path) and cbytes(read32(sp+8))==cbytes(group) and read32(sp+20)==0
  key=cbytes(read32(sp+12)).decode();assert key in ('p-linger','e-linger');default=read32(sp+16);result=fields.get(key,default);requests.append({'key':key,'default_bits':hex(default),'result_bits':hex(result)});write32(float_cell,result);u.reg_write(UC_X86_REG_EIP,stub);return
 if stub<=a<stub+7:return
 assert any(base+s.VirtualAddress<=a<base+s.VirtualAddress+s.Misc_VirtualSize for s in p.sections if s.Characteristics&0x20000000),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def run(plife,elife,pvalue,evalue,name):
 global fields,requests
 fields={};requests=[]
 if pvalue is not None:fields['p-linger']=pvalue
 if evalue is not None:fields['e-linger']=evalue
 u.mem_write(obj,b'\0'*0x584);write32(obj+0xe8,plife);write32(obj+0x2f0,elife);sp=stack+0x7000;u.mem_write(sp-0x200,b'\0'*0x600);write32(sp+0x10,path);u.reg_write(UC_X86_REG_ESP,sp-16);u.reg_write(UC_X86_REG_ESI,group);u.reg_write(UC_X86_REG_EDI,obj);u.reg_write(UC_X86_REG_EAX,dummy);u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(0x9132c5,0x91339b,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x91339b
 return {'name':name,'particle_life_max_bits':hex(plife),'emitter_life_bits':hex(elife),'particle_authored_bits':None if pvalue is None else hex(pvalue),'emitter_authored_bits':None if evalue is None else hex(evalue),'particle_linger_bits':hex(read32(obj+0x338)),'emitter_linger_bits':hex(read32(obj+0x33c)),'requests':requests.copy()}
values=[None]+[bits(v) for v in [-2.,-0.,0.,.1,1.,20.]]+[0x7f7fffff,0x7f800000,0xff800000,0x7fc00000];lifes=[bits(0.),bits(3.),0x7f7fffff,0x7f800000,0x7fc00000];cases=[]
for plife,elife,pvalue,evalue in itertools.product(lifes,lifes,values,values):cases.append(run(plife,elife,pvalue,evalue,'boundary'))
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text());timing=json.loads((r/'data/4.20/complex_emitter_timing_contract.json').read_text());scalar=json.loads((r/'data/4.20/complex_scalar_parameter_contract.json').read_text())
for definition in catalog['definitions']:
 doc=json.loads((r/definition['asset']).read_text())
 for group_row in definition['groups']:
  if group_row['declared_type']=='Simple':continue
  name='map:'+definition['reference']+':'+group_row['name'];g=doc['sections'][group_row['name']]
  life=next(c for c in timing['cases'] if c['name']==name);plife=next(c for c in scalar['cases'] if c['name']==name+':p-life')
  pvalue=g.get('p-linger');evalue=g.get('e-linger');assert pvalue is None or isinstance(pvalue,(int,float));assert evalue is None or isinstance(evalue,(int,float))
  cases.append(run(int(plife['maximum_bits'],16),int(life['life_bits'],16),None if pvalue is None else bits(pvalue),None if evalue is None else bits(evalue),name))
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'fragment':['0x9132c5','0x91339b'],'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Original scalar getter arguments/defaults checked; raw f32 returned through fld/ret adapter. Original bound+10 SSE arithmetic, both original x87/SSE clamp paths and inherited zero e-linger default execute. Legal preceding coloroffset pointer supplied.'],'limits':['Raw getters/cache/lexical conversion not executed. Map maximum p-life and effective e-life supplied from separately executed native reader captures.','No whole constructor/lifecycle/owner flags update or graphical integration.']}
(r/'data/4.20/complex_linger_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'map_cases':sum(c['name'].startswith('map:') for c in cases),'example':cases[0],'passed':True}))
