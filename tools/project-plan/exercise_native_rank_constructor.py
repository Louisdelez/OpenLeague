"""Original 4.20 rank-constructor instructions with bounded lookup adapters.

Only the constructor fragment executes. INIBIN lookup, source scalar setup and
sprintf are explicit adapters. This is not a full config-cache or game run.
"""
import argparse,collections,datetime,hashlib,json,math,pathlib,struct,sys
S=pathlib.Path(__file__).parent;R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/pythonlibs'));sys.path.insert(0,str(R/'tools/project-plan'))
import pefile,unicorn
from unicorn.x86_const import *
from reference_inibin import read,hashkey
def load(p):return json.loads(p.read_bytes())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
ref=load(R/'docs/reference_client_4_20.json');binary=pathlib.Path(ref['source_root'])/ref['client']['binary'];raw=binary.read_bytes()
# Pin the complete actual binary identity from the reference, not an inferred
# folder/date. The source registry separately identifies all original artifacts.
expected='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
assert next(x['sha256'] for x in ref['sources'] if x['path']==ref['client']['binary'])==expected and hashlib.sha256(raw).hexdigest()==expected
pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
start=0x767a86;stop=0x767c49;fragment=image[start-base:stop-base]
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(image)+4095)&~4095);u.mem_write(base,image)
space=0x40000000;u.mem_map(space,0x40000);obj=space+0x1000;config=space+0x3000;frame=space+0x21000;stack=space+0x20000;float_value=space+0x38000;float_stub=space+0x38100;init=space+0x38200
u.mem_write(float_stub,b'\xd9\x05'+struct.pack('<I',float_value)+b'\xc3');u.mem_write(init,b'\xdb\xe3')
def w(a,v):u.mem_write(a,struct.pack('<I',v&0xffffffff))
def rd(a):return struct.unpack('<I',u.mem_read(a,4))[0]
def rf(a):return struct.unpack('<f',u.mem_read(a,4))[0]
def wf(a,v):u.mem_write(a,struct.pack('<f',float(v)))
def text(a):return bytes(u.mem_read(a,160)).split(b'\0')[0].decode('ascii')
def numeric(value):
 if value is None:raise ValueError('Missing value must use an explicit constructor-provided default')
 try:n=float(value)
 except (ValueError,TypeError):raise ValueError('Unqualified numeric text: '+repr(value))
 if not math.isfinite(n):raise ValueError('Nonfinite input not qualified')
 return n
active={};calls=[];visited=set();case_visited=set()
def leave(eax=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EAX,eax&0xffffffff);u.reg_write(UC_X86_REG_EIP,rd(sp));u.reg_write(UC_X86_REG_ESP,sp+4)
def hook(uc,address,size,unused):
 if address==0xc9811c:
  sp=u.reg_read(UC_X86_REG_ESP);out=rd(sp+4);fmt=text(rd(sp+8));rank=rd(sp+12)
  assert fmt in ['ManaCost%d','Cooldown%d','ChannelDuration%d','MaxAmmo%d','AmmoUsed%d','AmmoRechargeTime%d'] and 1<=rank<=6
  value=(fmt%rank).encode('ascii');u.mem_write(out,value+b'\0');calls.append({'api':'sprintf_adapter','format':fmt,'rank':rank,'field':value.decode()});leave(len(value));return
 if address in [0x8b2780,0x8b1f50,0x8b1a80]:
  sp=u.reg_read(UC_X86_REG_ESP)
  if address==0x8b2780:
   assert u.reg_read(UC_X86_REG_ECX)==config and text(u.reg_read(UC_X86_REG_EDX))=='SpellData'
   name=text(rd(sp+8));default=rf(sp+12)
  else:
   assert rd(sp+4)==config;name=text(rd(sp+12));default=rd(sp+16) if address==0x8b1a80 else rf(sp+16)
  value=active.get(hashkey('SpellData',name));present=value is not None;result=numeric(value) if present else default
  calls.append({'api':hex(address)+' lookup_adapter','field':name,'present':present,'native_raw':value,'constructor_default':default,'result':result})
  if address==0x8b1a80:leave(int(result))
  else:wf(float_value,result);u.reg_write(UC_X86_REG_EIP,float_stub)
  return
 assert start<=address<stop or float_stub<=address<float_stub+7 or init<=address<init+2,hex(address)
 if start<=address<stop:visited.add(address);case_visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
default_base=struct.unpack('<f',image[0x1138fa8-base:0x1138fa8-base+4])[0]
def run(values):
 global active,calls,case_visited
 # Reject malformed supplied text before emulation; native malformed-string
 # conversion remains unqualified, not changed to0 or a guessed prefix.
 relevant=['Cooldown','ChannelDuration','MaxAmmo','AmmoUsed','AmmoRechargeTime']+[name+str(i) for i in range(1,7) for name in ['Cooldown','ManaCost','ChannelDuration','MaxAmmo','AmmoUsed','AmmoRechargeTime']]
 for name in relevant:
  v=values.get(hashkey('SpellData',name))
  if v is not None:numeric(v)
 active=values;calls=[];case_visited=set();u.mem_write(obj,bytes(0x1000));u.mem_write(frame-0x200,bytes(0x300))
 for reg in [UC_X86_REG_EAX,UC_X86_REG_EBX,UC_X86_REG_ECX,UC_X86_REG_EDX]:u.reg_write(reg,0)
 for reg,value in [(UC_X86_REG_ESI,obj),(UC_X86_REG_EDI,config),(UC_X86_REG_EBP,frame),(UC_X86_REG_ESP,stack)]:u.reg_write(reg,value)
 w(frame-0xc4,15);u.mem_write(frame-0xd8,b'SpellData\0')
 for offset,name,default in [(0x28c,'Cooldown',default_base),(0x26c,'ChannelDuration',0),(0x2f4,'MaxAmmo',0),(0x310,'AmmoUsed',1),(0x32c,'AmmoRechargeTime',0)]:
  v=values.get(hashkey('SpellData',name));value=default if v is None else numeric(v)
  if name in ['MaxAmmo','AmmoUsed']:w(obj+offset,int(value))
  else:wf(obj+offset,value)
 u.emu_start(init,init+2,count=4);u.emu_start(start,stop,count=20000);assert u.reg_read(UC_X86_REG_EIP)==stop
 costs=[rf(obj+0x760+i*4) for i in range(6)];cooldowns=[rf(obj+0x290+i*4) for i in range(6)]
 assert len([x for x in calls if 'field' in x and x['field'].startswith('Cooldown') and 'lookup_adapter' in x['api']])==6
 return {'cooldowns':cooldowns,'mana_costs':costs,'calls':list(calls),'original_addresses_exercised':len(case_visited)}
synthetic=[]
for name,values,expected_cd,expected_cost in [
 ('missing_ranked_cooldowns_use_explicit_base',{hashkey('SpellData','Cooldown'):17.5},[17.5]*6,[0.]*6),
 ('ranked_override_kept',{hashkey('SpellData','Cooldown'):17.5,hashkey('SpellData','Cooldown2'):7.25,hashkey('SpellData','ManaCost1'):20.},[17.5,7.25,17.5,17.5,17.5,17.5],[20.,0,0,0,0,0]),
 ('absent_mana_cost_is_constructor_zero',{},[default_base]*6,[0.]*6)]:
 result=run(values);assert result['cooldowns']==expected_cd and result['mana_costs']==expected_cost;synthetic.append({'name':name,'passed':True,'observed':result})
for value in ['6.5.0',float('nan')]:
 try:run({hashkey('SpellData','Cooldown2'):value});raise AssertionError('Unqualified malformed input accepted')
 except ValueError as e:synthetic.append({'name':'refuse_unqualified_numeric_text_or_nonfinite','input':repr(value),'observed':str(e),'passed':True})
comparison=load(R/'docs/fidelity_catalogue_comparison_4_20.json');jobs={}
for row in comparison['rows']:
 if row['family'] in ['champion_spell','champion_spell_effect','champion_display_range','summoner']:jobs[row['subject']]=row['native_path']
cases=[];refusals=[]
for subject,path in jobs.items():
 p=pathlib.Path(path);values=read(p)
 try:result=run(values)
 except ValueError as e:refusals.append({'subject':subject,'source':str(p),'sha256':sha(p),'reason':str(e),'native_string_conversion_not_qualified':True});continue
 cases.append({'subject':subject,'source':str(p),'sha256':sha(p),'observed':result})
source={'path':str(binary),'sha256':expected,'version':ref['client']['version'],'channel':ref['client']['channel'],'branch':ref['client']['branch']}
result={'schema':'openleague_original_rank_constructor/v1','passed':True,'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'binary':source,'fragment':{'start':hex(start),'stop':hex(stop),'bytes':len(fragment),'sha256':hashlib.sha256(fragment).hexdigest(),'unique_native_addresses_exercised':len(visited)},
 'tools':{'python':{'path':sys.executable,'version':sys.version,'sha256':sha(pathlib.Path(sys.executable))},'unicorn':{'version':unicorn.__version__,'module':unicorn.__file__,'package_dlls':[{'path':str(p),'sha256':sha(p),'bytes':p.stat().st_size} for p in pathlib.Path(unicorn.__file__).parent.rglob('*.dll')]},'pefile':{'version':pefile.__version__,'module':pefile.__file__,'sha256':sha(pathlib.Path(pefile.__file__))}},
 'scalar_cooldown_default_from_binary':default_base,'synthetic_cases':synthetic,'actual_spell_cases':cases,'unqualified_input_refusals':refusals,
 'original_instructions_executed_in_isolated_memory':True,'historical_game_process_launched':False,'original_file_io_config_cache_overlay_executed':False,
 'adapters':['Scalar object fields initialized from the actual INIBIN and original scalar constructor defaults, not full object construction.','sprintf formats exact six field names and rank1..6.','Lookup calls use actual parsed INIBIN presence/value or the default supplied by original constructor. Original lookup/cache/overlay and malformed-string numeric conversion are not executed.','Tiny FLD/RET stub returns adapter float viax87; original constructor stores values and controls all six loop iterations.'],
 'limits':['This proves original constructor default argument/dataflow and actual array stores under the explicit lookup contract. It does not qualify full original SpellData construction, config inheritance/overrides, costs outside1..6, scripts or live gameplay.','Malformed native numeric strings stay open; no Python prefix parsing is substituted for native conversion.']}
parser=argparse.ArgumentParser();parser.add_argument('--output',required=True);args=parser.parse_args();output=pathlib.Path(args.output)
if output.exists():parser.error('Output already exists; preserve prior evidence and choose a new output file.')
result['producer']={'path':str(pathlib.Path(__file__).resolve()),'sha256':sha(pathlib.Path(__file__)),'command_line':[sys.executable,*sys.argv]}
output.parent.mkdir(parents=True,exist_ok=True);output.write_text(json.dumps(result,ensure_ascii=False,indent=2,allow_nan=False)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'actual_spell_cases':len(cases),'unqualified_refusals':refusals,'synthetic_cases':len(synthetic),'native_addresses_exercised':len(visited),'default_base':default_base,'binary_sha256':expected,'native_game_process_launched':False},ensure_ascii=False,indent=2))
