from pathlib import Path
import json,struct,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0]
exec(compile(prefix,'native options base','exec'))
owner=vector+0x9000;sentinel=vector+0xa000;nodes=vector+0xb000;callback=end+0x100
mode='';context=False;assertions=[];config_requests=[];configured=0
def options_hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==callback:finish(int(context));return
 if a==0x991e60:assertions.append([read(sp+4+i*4) for i in range(5)]);finish(0);return
 if a==0x8b1c20:
  config_requests.append(dict(section=string(uc.reg_read(UC_X86_REG_ECX)),key=string(uc.reg_read(UC_X86_REG_EDX)),default=read(sp+4),flags=read(sp+8)));finish(configured);return
 ranges={'getter':[(0x835080,0x8350f1)],'name':[(0x836c40,0x836ea0)],'section':[(0x836f70,0x836fd6)],'dispatch':[(0x8373d0,0x8373f5)],'default':[(0x835ca6,0x835cc6)]}
 assert any(begin<=a<stop for begin,stop in ranges[mode]),(mode,hex(a));visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,options_hook)
def signed(x):return x if x<0x80000000 else x-0x100000000
def invoke(entry,key,ecx=owner):
 w(stack,end);w(stack+4,key);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,ecx);assertions.clear()
 u.emu_start(entry,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 return u.reg_read(UC_X86_REG_EAX)
# Execute original namespace table, not an inferred INI section.
mode='section';sections=[]
for key in range(5):sections.append(dict(id=key,name=string(invoke(0x836f70,key))))
assert sections[2]['name']=='Performance'
# Execute original key-name switch, including both owner virtual states.
w(0x2d787b8,owner);w(owner,vt);w(vt+0xb0,callback)
mode='name';names=[]
for context,key in itertools.product([False,True],range(1,51)):
 name=string(invoke(0x836c40,key));names.append(dict(context=context,id=key,name=name))
 assert name
assert all(c['name']=='EnvironmentQuality' for c in names if c['id']==16)
# Execute original dispatcher prefix to the native EnvironmentQuality branch.
mode='dispatch';dispatch=[]
for key in [15,16,19,20]:
 index=image[0x837880-base+key-1];target=struct.unpack_from('<I',image,0x837840-base+index*4)[0]
 w(stack,end);w(stack+4,key);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
 u.emu_start(0x8373d0,target,count=100);assert u.reg_read(UC_X86_REG_EIP)==target
 dispatch.append(dict(id=key,target=hex(target)))
assert next(c['target'] for c in dispatch if c['id']==16)=='0x837630'
# Original initializer call-site passes Performance, EnvironmentQuality, default3,
# flags0 and stores integer key16. Config parsing and map insertion are boundaries.
mode='default';defaults=[]
for configured in [-2147483648,-1,0,1,2,3,4,5,2147483647]:
 config_requests.clear();u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack+0x100)
 u.emu_start(0x835ca6,0x835cc6,count=100)
 assert config_requests==[dict(section='Performance',key='EnvironmentQuality',default=3,flags=0)]
 assert read(stack+0x100-8)==16 and signed(read(stack+0x100-4))==configured
 defaults.append(dict(supplied_config_return=configured,request=config_requests[0],stored_id=16,stored_value=configured))
# Supplied valid sorted-tree shapes; node links/layout match original getter reads.
# Red-black insertion/balancing is not part of this read qualification.
mode='getter';cases=[]
def build(entries,shape):
 u.mem_write(sentinel,b'\0'*32);u.mem_write(sentinel+0xd,b'\1');w(owner+0x10,sentinel)
 count=0
 def make(rows):
  nonlocal count
  if not rows:return sentinel
  mid=len(rows)//2 if shape=='balanced' else 0 if shape=='right' else len(rows)-1
  address=nodes+count*32;count+=1;key,value=rows[mid];u.mem_write(address,b'\0'*32)
  w(address,make(rows[:mid]));w(address+8,make(rows[mid+1:]));w(address+0x10,key);w(address+0x14,value)
  return address
 w(sentinel+4,make(entries))
datasets=[[],[(16,3)],[(-2147483648,-2147483648),(-1,-7),(0,0),(15,4),(16,-1),(17,0),(19,2147483647),(20,1),(2147483647,5)]]
for shape,entries,key in itertools.product(['balanced','left','right'],datasets,[-2147483648,-2,-1,0,1,14,15,16,17,18,19,20,21,2147483647]):
 build(entries,shape);value=signed(invoke(0x835080,key));expected=dict(entries).get(key,0)
 assert value==expected and bool(assertions)==(key not in dict(entries))
 cases.append(dict(shape=shape,entries=[dict(id=k,value=v) for k,v in entries],id=key,value=value,missing=bool(assertions)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),integer_getter='0x835080',key_names='0x836c40',sections='0x836f70',dispatch='0x8373d0',native_addresses=len(visited),environment=dict(id=16,section='Performance',key='EnvironmentQuality',default=3,dispatch_target='0x837630'),sections_table=sections,name_cases=names,dispatch_cases=dispatch,default_cases=defaults,getter_cases=cases,getter_case_count=len(cases),limits=['Original instruction paths execute; configuration getter8B1C20, owner context callback and missing-key assertion logging adapted.','Integer tree links/layout/contents supplied; original insertion, balancing, full configuration lookup/text parsing and persistence not executed.','Environment option identity/default/getter/dispatch prefix qualified; menu, complete callbacks, dependent renderer rebuild and material exclusions remain open.'])
(r/'data/4.20/native_graphics_options_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(getter_cases=len(cases),name_cases=len(names),default_cases=len(defaults),native_addresses=len(visited),environment=proof['environment'])))
