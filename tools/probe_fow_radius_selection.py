from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0],'native prerequisites','exec'))
entry=0x86a9b0;stop=0x86a9e1;stub=end+0x200;config_stub=end+0x240;value=end+0x400;fallback=end+0x404;calls=[]
native_code_ranges=list(native_code_ranges)+[(stub,stub+11),(config_stub,config_stub+7)]
u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',value)+b'\xe9'+struct.pack('<i',entry-(stub+11)))
u.mem_write(config_stub,b'\xd9\x05'+struct.pack('<I',fallback)+b'\xc3')
def config_boundary(uc,address,size,user):
 if address==0x8b20f0:
  top=uc.reg_read(UC_X86_REG_ESP);raw=bytes(uc.mem_read(top+4,4));f=struct.unpack('<f',raw)[0];assert f==1350.
  assert uc.reg_read(UC_X86_REG_ECX)==0x108bff4 and uc.reg_read(UC_X86_REG_EDX)==0x1086ee0
  calls.append(f);uc.mem_write(fallback,raw);uc.reg_write(UC_X86_REG_EIP,config_stub)
u.hook_add(unicorn.UC_HOOK_CODE,config_boundary)
cases=[]
for candidate in [-1.,-0.0001,0.,0.0001,100.,1200.,1350.,2000.]:
 calls.clear();u.mem_write(value,struct.pack('<f',candidate));u.mem_write(sp+0x24,bytes(4));u.reg_write(UC_X86_REG_ESP,sp-0x14)
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(stub,stop,count=10000);assert u.reg_read(UC_X86_REG_EIP)==stop
 result=struct.unpack('<f',u.mem_read(sp+0x24,4))[0]
 expected=struct.unpack('<f',struct.pack('<f',candidate if candidate>0. else 1350.))[0]
 assert result==expected,(candidate,result,expected)
 cases.append(dict(candidate=candidate,result=result,result_bits=read32(sp+0x24),global_lookup_calls=list(calls)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,passed=True,complete=False,entry=hex(entry),stop=hex(stop),cases=cases,original_instruction_addresses=len([a for a in visited if a<end]),runtime_adapters=['FLD input stub supplies resource-reader return and jumps into native selection.','Global lookup8B20F0 boundary returns the exact native1350fallback argument, modeling a missing override; original config loader not executed.'],limits=['Qualifies original positive-character-value versus global-fallback selection only. Actual resource/cache loaders and explicit global overrides not executed.','This source path is traced in native constructors but complete source activation/lifecycle and all actor types remain open.'])
(r/'data/4.20/fow_radius_selection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=cases,native_addresses=proof['original_instruction_addresses'])))
