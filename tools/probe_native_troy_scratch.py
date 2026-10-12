"""Whole8E2E80 scratch constructor; inspect every output byte and guards."""
from pathlib import Path
import json,datetime,shutil,random
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_troy_reset.py').read_text(encoding='utf-8').split('\nfor index,(complex_count')[0],'scratch setup','exec'))
cases=[];rng=random.Random(420)
for alignment in [0,4,8,12]:
 for fill in [bytes(0x150),bytes([0xcc])*0x150,bytes([0xff])*0x150,bytes(rng.randrange(256) for _ in range(0x150))]:
  obj=heap+0x5000+alignment;u.mem_write(obj-16,b'\xa5'*16+fill+b'\x5a'*16);sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x8e2e80,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4 and u.reg_read(UC_X86_REG_EAX)==obj
  assert bytes(u.mem_read(obj-16,16))==b'\xa5'*16 and bytes(u.mem_read(obj+0x150,16))==b'\x5a'*16
  after=bytes(u.mem_read(obj,0x150))
  write32(sp,end)
  for i,v in enumerate([obj+0x6c,16,6,0x5642d0]):write32(sp+4+i*4,v)
  u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xc97c54,end,count=100000)
  assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+20
  destroyed=bytes(u.mem_read(obj,0x150));assert destroyed==after
  assert bytes(u.mem_read(obj-16,16))==b'\xa5'*16 and bytes(u.mem_read(obj+0x150,16))==b'\x5a'*16
  cases.append({'alignment':alignment,'before':fill.hex(),'after':after.hex(),'after_destroy':destroyed.hex()})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'8E2E80','destructor_entry':'C97C54','element_destructor':'5642D0','cases':cases,'adapters':['Whole constructor executes including six native6BD9D0 element constructors viaC982E4, original memset and raw writes. Stack balance, returned this pointer and16-byte guards checked.','Original vector destructionC97C54 executes six5642D0 no-op element destructors, with four stack arguments and ret16 checked. Scratch bytes and guards unchanged.','Allocator/security setup inherited; no graphical/audio frame producer is executed.'],'limits':['Scratch consumption/frame93F2F0 and graphical/audio integration remain incomplete. Exceptional construction/destruction not qualified here.']}
(r/'data/4.20/troy_scratch_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'changed_offsets':[hex(i) for i,(a,b) in enumerate(zip(bytes.fromhex(cases[1]['before']),bytes.fromhex(cases[1]['after']))) if a!=b]}))
