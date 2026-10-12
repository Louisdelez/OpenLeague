from pathlib import Path
from native_x87 import HardwareFyl2x
import json,struct,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
source=heap+0x100;output=heap+0x200;entry=trap+0x100;code=b'\xdb\xe3\xd9\x05'+struct.pack('<I',source)+b'\xd9\xec\xd9\xc9\xd9\xf1\xdb\x3d'+struct.pack('<I',output)+b'\xc3';u.mem_write(entry,code);fyl2x=entry+12;hardware=HardwareFyl2x();current={}
def guard(uc,a,n,d):
 if a==fyl2x:
  status=u.reg_read(UC_X86_REG_FPSW);top=(status>>11)&7;y=u.reg_read(UC_X86_REG_FP0+((top+1)&7));x=u.reg_read(UC_X86_REG_FP0+top);result,physical=hardware.evaluate(y,x,u.reg_read(UC_X86_REG_FPCW));current.update({'y':list(y),'x':list(x),'hardware_result':list(result),'hardware_status':physical})
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[]
for bits in [0,0x80000000,0x3f800000,0xbf800000,0x3e800000,0x40000000,0x7f800000,0xff800000,0xffc00000]:
 put(source,'I',bits);put(stack+0x8000,'I',trap);u.reg_write(UC_X86_REG_ESP,stack+0x8000);current.clear();u.emu_start(entry,trap,count=50);assert u.reg_read(UC_X86_REG_EIP)==trap;rows.append({'bits':bits,**current,'unicorn_result':list(read(output,'QH'))})
assert rows[0]['unicorn_result']==[0,0] and rows[0]['hardware_result']==[0x8000000000000000,0xffff]
proof={'passed':True,'case_count':len(rows),'cases':rows,'hardware':hardware.metadata(),'instruction_code_hex':code.hex(),'difference_count':sum(row['hardware_result']!=row['unicorn_result']for row in rows),'finding':'Unicorn FYL2X maps zero-domain to0 rather than actual x87 negative infinity. Native DSP silence reference must use actual instruction arithmetic instead of this emulator result.','limits':['Instruction-level comparison on localx86_64 processor, not a full original client hardware run. Other native helper/emulator semantics remain subject to DSP integration comparisons.']};hardware.close();(r/'data/4.20/audio_x87_fyl2x_audit.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'physical/unicorn FYL2X comparisons;',proof['difference_count'],'exact80-bit differences')
