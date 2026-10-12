"""Original file e-life-scale caller, binary boolean wrapper and typed conversion."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook
emitter=heap+0xa000;provider=heap+0xb000;wrapper=heap+0xb800;read_text=heap+0xc000;current_boolean=None;current_text=None;reads=[];arguments=[];clock_target=read32(0xfa4378);trace=[]
def hook(uc,a,size,user):
 trace.append(a)
 if len(trace)>40:trace.pop(0)
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==clock_target:finish(eax=1);return
 if a==0x8afc30:
  assert u.reg_read(UC_X86_REG_ECX)==provider
  arguments.append({'key_hash':hex(read32(sp+16)),'default_byte':read32(sp+20)&255})
 if a in (0x8af7b0,0x8af290):
  kind='boolean' if a==0x8af7b0 else 'text';reads.append(kind);dest=read32(sp+8);value=current_boolean if kind=='boolean' else current_text
  if value is not None:
   if kind=='boolean':u.mem_write(dest,bytes([value]))
   else:
    u.mem_write(dest,b'\0'*24);raw=value.encode('ascii')
    if len(raw)<16:u.mem_write(dest,raw+b'\0');write32(dest+20,15)
    else:u.mem_write(read_text,raw+b'\0');write32(dest,read_text);write32(dest+20,len(raw)+1)
    write32(dest+16,len(raw))
  finish(8,int(value is not None));return
 if a==0x564900:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def execute_fragment():
 try:u.emu_start(0x91204b,0x912090,count=100000)
 except Exception:
  print('TRACE',[hex(v) for v in trace]);print('ERROR',hex(u.reg_read(UC_X86_REG_EIP)),hex(u.reg_read(UC_X86_REG_ESP)),hex(u.reg_read(UC_X86_REG_ECX)),hex(clock_target));raise
def run(boolean,text,ready,name):
 global current_boolean,current_text,reads,arguments
 current_boolean=boolean;current_text=text;reads=[];arguments=[];u.mem_write(provider,b'\0'*0x180);u.mem_write(provider+0x148,bytes([ready]));write32(wrapper,provider);u.mem_write(emitter,b'\0'*0x584)
 sp=stack+0x8000;u.mem_write(sp-0x200,b'\0'*0x600);write32(sp+0x14,wrapper);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,section);u.reg_write(UC_X86_REG_EDI,emitter);execute_fragment();assert u.reg_read(UC_X86_REG_EIP)==0x912090 and len(arguments)==1
 return {'name':name,'boolean':boolean,'text':text,'provider_ready':ready,'arguments':arguments[0],'reads':reads.copy(),'enabled_byte':u.mem_read(emitter+0x2f4,1)[0]}
cases=[]
for boolean,text,ready in itertools.product([None,0,1,2,255],[None,'','0','1','true','false','10',' 1','1anything','long text without number'],[False,True]):cases.append(run(boolean,text,ready,'boundary'))
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text())
for definition in catalog['definitions']:
 doc=json.loads((r/definition['asset']).read_text())
 for group in definition['groups']:
  if group['declared_type']=='Simple':continue
  value=doc['sections'][group['name']].get('e-life-scale');assert value is None or isinstance(value,(bool,str))
  cases.append(run(int(value) if isinstance(value,bool) else None,value if isinstance(value,str) else None,True,'map:'+definition['reference']+':'+group['name']))
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'caller':['0x91204b','0x912090'],'binary_bool_entry':'0x8afc30','typed_bool_entry':'0x8ae530','cases':cases,'original_instruction_addresses':len(visited),'adapters':['Underlying binary bool/text storage supplied; clock/thread query, string destruction and cookie transport adapted. Original hashing, file caller default, binary wrapper, typed source precedence and first-character text conversion execute. Provider legal binary-ready/disabled fixture states supplied.'],'limits':['Global Hacks lookup/override and text-file provider branch excluded; only file fallback caller and binary provider qualified.','Underlying cache/INIBIN storage population, owner-scale source and full lifetime/render lifecycle pending. Raw typed bool bytes are preserved, not normalized by the binary wrapper.']}
(r/'data/4.20/complex_life_scale_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'map_cases':sum(c['name'].startswith('map:') for c in cases),'default':cases[0]['arguments'],'passed':True}))
