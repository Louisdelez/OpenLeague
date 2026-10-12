from pathlib import Path
import json,struct,hashlib,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0]
exec(compile(prefix,'native shader vectors','exec'))
record=vector+0x6000;global_vec=vector+0x7000;global_data=vector+0x7100
static_data=vector+0x8000;merged_data=vector+0x9000;string_data=vector+0xa000
compiler=vector+0xb000;compiler_table=vector+0xb100;compile_boundary=end+0x100
frame=stack+0x1000;token_state={};compiler_submissions=[]
def pairs(ptr):
 return [dict(name=string(read(a)),value=string(read(a+4))) for a in range(read(ptr),read(ptr+4),8)]
def ctext(ptr):
 return bytes(u.mem_read(ptr,1024)).split(b'\0')[0].decode('ascii')
def native_hook(uc,a,size,user):
 visited.add(a);sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x564c20:
  dest=uc.reg_read(UC_X86_REG_ECX);source,length=struct.unpack('<2I',uc.mem_read(sp+4,8));b=bytes(uc.mem_read(source,length))+b'\0'
  if length<16:u.mem_write(dest,b);w(dest+20,15)
  else:u.mem_write(string_data,b);w(dest,string_data);w(dest+20,1023)
  w(dest+16,length);finish(dest,8);return
 if a==0xc9f4c6:
  ptr,delimiters,state=struct.unpack('<3I',uc.mem_read(sp+4,12));delims=set(ctext(delimiters).encode())
  cursor=ptr or token_state.get(state,0)
  if not cursor:finish(0);return
  while u.mem_read(cursor,1)[0] in delims:cursor+=1
  if u.mem_read(cursor,1)==b'\0':token_state[state]=0;finish(0);return
  start=cursor
  while u.mem_read(cursor,1)!=b'\0' and u.mem_read(cursor,1)[0] not in delims:cursor+=1
  if u.mem_read(cursor,1)==b'\0':token_state[state]=0
  else:u.mem_write(cursor,b'\0');token_state[state]=cursor+1
  finish(start);return
 if a==compile_boundary:
  output,definitions,count=struct.unpack('<3I',uc.mem_read(sp+4,12))
  compiler_submissions.append([dict(name=string(read(definitions+i*8)),value=string(read(definitions+i*8+4))) for i in range(count)])
  finish(0x12345678);return
 assert (0x98c430<=a<0x98c542 or 0x6f1820<=a<0x6f190a or 0x6f3c70<=a<0x6f3d00 or
         0x5e0f10<=a<0x5e0f3b or 0x98f1e0<=a<0x98f2e1 or 0x98c288<=a<0x98c2ad or 0x98db78<=a<0x98db9d),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,native_hook)
w(compiler,compiler_table);w(compiler_table+0x10,compile_boundary)
def invoke(entry,this,args=b''):
 w(stack,end);u.mem_write(stack+4,args);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,this)
 u.emu_start(entry,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
catalog=json.loads((r/'data/4.20/native_shader_descriptor_catalog.json').read_text(encoding='utf-8'))
options=json.loads((r/'data/4.20/native_renderer_fog_options_contract.json').read_text(encoding='utf-8'))
rows=[x for x in catalog['descriptors'] if x['name'].startswith('Environment')]
cases=[]
for row in rows:
 for option in options['cases']:
  u.mem_write(record,bytes(128));w(record+0x2c,static_data);w(record+0x30,static_data);w(record+0x34,static_data+1024)
  descriptor=int(row['native_descriptor'],16);defines=read(descriptor+8)
  token_state.clear();invoke(0x98c430,record,struct.pack('<I',defines))
  static=pairs(record+0x2c)
  expected_static=[dict(name=n,value='1') for n in row['defines'].split(';') if n]
  assert static==expected_static,(row['name'],static)
  globals=option['submission']['macro_vector'];w(global_vec,global_data);w(global_vec+4,global_data+len(globals)*8);w(global_vec+8,global_data+1024)
  for i,pair in enumerate(globals):
   address=storage+i*128;u.mem_write(address,pair['name'].encode()+b'\0');u.mem_write(address+96,pair['value'].encode()+b'\0');w(global_data+i*8,address);w(global_data+i*8+4,address+96)
  w(record+8,merged_data);w(record+12,merged_data);w(record+16,merged_data+1024)
  invoke(0x6f1820,record+8,struct.pack('<I',global_vec))
  assert pairs(record+8)==globals
  invoke(0x98f1e0,record+8,struct.pack('<4I',read(record+12),read(record+0x2c),read(record+0x30),0))
  expected=globals+expected_static;assert pairs(record+8)==expected
  for start,stop in [(0x98c288,0x98c2ad),(0x98db78,0x98db9d)]:
   compiler_submissions.clear();u.reg_write(UC_X86_REG_EDI,record);u.reg_write(UC_X86_REG_ESI,compiler);u.reg_write(UC_X86_REG_ESP,stack)
   u.emu_start(start,stop,count=1000);assert u.reg_read(UC_X86_REG_EIP)==stop
   assert compiler_submissions==[expected]
  cases.append(dict(shader=row['name'],source=row['source'],static_defines=row['defines'],palette=option['palette'],fog_enabled=option['fog_enabled'],fog_quality=option['fog_quality'],submitted_macros=expected,vertex_and_pixel_submission=True))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,
 native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),descriptor_count=len(rows),native_addresses=len(visited),cases=cases,
 entries=dict(static_define_parser='0x98c430',global_pair_copy='0x6f1820',static_pair_insert='0x98f1e0',vertex_compiler_submission=['0x98c288','0x98c2ad'],pixel_compiler_submission=['0x98db78','0x98db9d']),
 findings=['All33 archived Environment descriptors parse into native static pairs; absent value defaults to1.',
 'Original pair vectors copy global palette/fog options then append static descriptor pairs. Order and values are preserved at both vertex and pixel compiler virtual-call boundaries.',
 '48 palette/fog combinations per descriptor; no deduplication occurs in the controlled append sequence.'],
 adapters=['Native string assignment564C20 adapted to supplied SSO/heap capacity; CRT strtok_sC9F4C6 adapted to controlled delimiter-aware mutable tokens.',
 'Vector destinations preallocated; native parsing branches, copying, insertion and both compiler argument preparation tails execute.',
 'Compiler virtual boundary records macro pointer/count and returns dummy code handle; no shader compilation or GPU executes.'],
 limits=['Both compiler submission tails execute in isolation; file loading, complete compiler bodies and actual stage routing remain unqualified.',
 'Registry entry/cache selection and per-environment dynamic macro refresh remain unqualified. Global vectors are verified fixture inputs, not a complete runtime initializer.',
 'All observed Environment descriptors use bare names; explicit name=value tokenizer semantics not qualified.',
 'Physical shader compilation, effective runtime settings, shader variant routing and full GPU frame fidelity remain open.'])
(r/'data/4.20/native_shader_macro_merge_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),descriptors=len(rows),native_addresses=len(visited),vertex_submission=True,pixel_submission=True)))
