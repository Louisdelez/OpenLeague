from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD element storage prerequisites','exec'))
owner=vector+0x6000;allocated=vector+0x8000
pools={1:(0x9aa4d0,0x1e4,0x228),2:(0x9aa6f0,0x214,0x284),3:(0x9aa5e0,0x1fc,0x30c)}
observed=[];current_kind=0;current_output=0
def storage_hook(uc,a,size,user):
 if a in [v[0] for v in pools.values()]:
  expected=pools[current_kind]
  assert a==expected[0] and uc.reg_read(UC_X86_REG_ECX)==owner+expected[1]
  observed.append({'entry':hex(a),'owner_pool_offset':expected[1]})
  finish(current_output);return
 assert 0x9a5200<=a<0x9a529a or 0xca1d00<=a<0xca1d90,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,storage_hook)
cases=[]
for current_kind,alignment,prefill,byte_path in itertools.product([1,2,3],range(4),[0,0xa5,0xff],[False,True]):
 current_output=allocated+alignment;size=pools[current_kind][2]
 u.mem_write(allocated-32,b'\x6d'*0x400);u.mem_write(current_output,bytes([prefill])*size)
 w(0x14ae664,2 if byte_path else 0);w(0x1222f40,0)
 observed.clear();w(stack,end);w(stack+4,current_kind)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.reg_write(UC_X86_REG_EFLAGS,2)
 u.emu_start(0x9a5200,end,count=20000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==current_output
 expected=bytearray(size)
 for offset,value in [(0x40,current_kind),(0x4c,0xffffffff),(0x1d0,0x3f800000),(0x1d4,0x3f800000),(0x1dc,0xffffffff)]:struct.pack_into('<I',expected,offset,value)
 output=bytes(u.mem_read(current_output,size));assert output==expected
 assert bytes(u.mem_read(allocated-32,32+alignment))==b'\x6d'*(32+alignment)
 assert bytes(u.mem_read(current_output+size,32))==b'\x6d'*32
 assert len(observed)==1
 cases.append(dict(kind=current_kind,alignment=alignment,prefill=prefill,memset_byte_path=byte_path,size=size,pool=observed[0],output_hex=output.hex(),guard_bytes_preserved=True))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x9a5200',native_sha256=hashlib.sha256(raw).hexdigest(),native_addresses=len(visited),case_count=len(cases),cases=cases,findings=['Kind1 allocates0x228 bytes, kind2 0x284, kind3 0x30c through separate owner pools.','Original CRT memsetCA1D00 executes for byte and dword paths; all element bytes compared and surrounding guards preserved.','Defaults: kind40, sentinel4c and1dc allones, fractions1d0/1d4 float1; other fields zero including flags, anchors, rect, motion and aspect.'],runtime_adapters=['Owner pool allocation returns supplied successful storage; original allocator lifetime/growth/failure remains open.','CRT CPU capability globals supplied to select original byte/dword memset paths; SIMD and actual CPU startup detection not qualified.'],limits=['Numeric kind allocation/defaults only: mapping from textual Type, named registration, property application and owner settings producers remain open.','Zero aspect in this storage is not a usable final layout default; later initializer required.','Does not render HUD widgets or prove complete UI/game.'])
(r/'data/4.20/native_hud_element_storage_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
