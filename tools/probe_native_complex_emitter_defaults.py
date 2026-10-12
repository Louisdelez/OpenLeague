"""Execute original Complex constructor and defaults, adapting heap/cookie only."""
from pathlib import Path
import sys,struct,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'));base=p.OPTIONAL_HEADER.ImageBase
u.mem_map(heap+0x10000,0x100000);obj=heap+0x1000;owner=heap+0x3000;allocation_cursor=heap+0x10000;visited=set();allocations=[];frees=[];written=set()
def memory_write(uc,access,address,size,value,user):
 if obj<=address<obj+0x584:written.update(range(address-obj,min(address-obj+size,0x584)))
def hook(uc,a,size,user):
 global allocation_cursor
 visited.add(a)
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a in (0xc9f39b,0x9933e0):
  n=read32(u.reg_read(UC_X86_REG_ESP)+4);assert 0<n<0x10000,(hex(a),n);ptr=allocation_cursor;allocation_cursor+=(n+31)&~15;assert allocation_cursor<heap+0x110000;u.mem_write(ptr,b'\xa5'*n);allocations.append({'entry':hex(a),'pointer':hex(ptr),'bytes':n});finish(eax=ptr);return
 if a==0xc98528:
  ptr=read32(u.reg_read(UC_X86_REG_ESP)+4);assert ptr==0 or heap+0x10000<=ptr<allocation_cursor;frees.append(hex(ptr));finish(eax=u.reg_read(UC_X86_REG_EAX));return
 assert any(base+s.VirtualAddress<=a<base+s.VirtualAddress+s.Misc_VirtualSize for s in p.sections if s.Characteristics&0x20000000),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_WRITE,memory_write);cases=[]
offsets=[0x28,0x30,0x34,0x54,0x78,0x7c,0x80,0xa4,0xa8,0xac,0xb0,0xd4,0xe8,0x2e8,0x2ec,0x2f0,0x304,0x308,0x30c,0x318,0x334,0x4b8,0x57c,0x580]
for prior in (0,0x3f000000,0xa5a5a5a5):
 for importance in (0,1,2):
  allocation_cursor=heap+0x10000;allocations.clear();frees.clear();u.mem_write(obj,b'\0'*0x584);u.mem_write(owner,b'\0'*0x200)
  for offset in offsets:write32(obj+offset,prior)
  # Constructor's own runtime custom allocator globals are absent by default.
  write32(0x14bef58,0);write32(0x14bef40,0)
  sp=stack+0x8000;write32(sp,end);write32(sp+4,owner);write32(sp+8,importance);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj)
  written.clear()
  try:u.emu_start(0x90fa70,end,count=1000000)
  except Exception:
   print('failure',hex(u.reg_read(UC_X86_REG_EIP)),hex(u.reg_read(UC_X86_REG_ECX)));raise
  assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==obj
  state=bytes(u.mem_read(obj,0x584));assert read32(obj)==importance
  widths={o:(2 if o==0x2e8 else 1 if o==0x4b8 else 4) for o in offsets};fields={hex(o):int.from_bytes(state[o:o+widths[o]],'little') for o in offsets};pointers=[{'offset':hex(o),'relative_to_heap':read32(obj+o)-heap} for o in range(0,0x584,4) if heap+0x10000<=read32(obj+o)<allocation_cursor]
  cases.append({'prior_bits':prior,'importance':importance,'scalar_bits':fields,'scalar_widths':{hex(o):v for o,v in widths.items()},'state_bytes':state.hex(),'initialized_byte_offsets':sorted(written),'owned_heap_pointers':pointers,'allocations':list(allocations),'free_requests':list(frees)})
for importance in (0,1,2):
 equivalent=[c for c in cases if c['importance']==importance];assert all(c['initialized_byte_offsets']==equivalent[0]['initialized_byte_offsets'] for c in equivalent)
 for c in equivalent:
  actual=bytes.fromhex(c['state_bytes']);expected=bytes.fromhex(equivalent[0]['state_bytes']);assert all(actual[i]==expected[i] for i in c['initialized_byte_offsets']);assert c['scalar_bits']==equivalent[0]['scalar_bits']
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'entry':'0x90fa70','defaults_entry':'0x910180','original_instruction_addresses':len(visited-{0xc975f5,0xc9f39b,0x9933e0,0xc98528}),'cases':cases,'adapters':['Heap allocation/free and stack cookie only. Native constructors, vector reservation and default writes execute.'],'limits':['Constructor supplied a zeroed parent-system memory object; parent system construction and emitter ownership lifecycle not executed.','Nine constructor snapshots cover three prior scalar seeds and three importance values. Field meanings require native reader/consumer qualification.','No emitted particle, curve interpolation, actual render or full map completion proved.']};(r/'data/4.20/complex_emitter_defaults_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'native_addresses':proof['original_instruction_addresses'],'allocations_per_case':len(cases[0]['allocations']),'initialized_bytes':len(cases[0]['initialized_byte_offsets']),'fields':cases[0]['scalar_bits']}))
