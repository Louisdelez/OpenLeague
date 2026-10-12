from pathlib import Path
import itertools,json,struct,traceback
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'logger prerequisites','exec'))
formats={hex(p):cbytes(p).decode('ascii') for p in [0x10de850,0x10d4c3c,0x10d4c20]}
print(json.dumps({'formats':formats}),flush=True)
base_windows=transport_windows
clock_words=[2014,11,4,20,23,59,58,999]
def transport_windows(dll,name,sp):
 if name=='GetLocalTime':
  u.mem_write(read32(sp+4),struct.pack('<8H',*clock_words));finish(pop=4);return True
 return base_windows(dll,name,sp)
entries=[]
def observe(uc,pc,size,user):
 if pc in [0x573fa0,0x5cce30,0x993860,0xc9b551]:
  sp=u.reg_read(UC_X86_REG_ESP)
  entries.append({'entry':hex(pc),'this':u.reg_read(UC_X86_REG_ECX),'arg1':read32(sp+4)})
u.hook_add(unicorn.UC_HOOK_CODE,observe)
call(0x901a70,0,[]);snapshot();cases=[]
try:
 for fill,message,source,number in itertools.product([0,165],[b'',b'Net Status: Initialize failed: low-level init',b'\x80\xe9\xff\n%name\x00ignored',b'A'*2534,b'B'*2535,b'C'*2560,b'D'*3000],[None,b'',b'file.cpp'],[0,0xffffffff]):
  u.mem_write(heap+0xa000,message+b'\0');u.mem_write(heap+0xc000,(source or b'')+b'\0');u.mem_write(0x2d8d358,bytes([fill])*2560);entries.clear()
  call(0x8f92b0,0x2d78ed0,[heap+0xa000,0 if source is None else heap+0xc000,number])
  cases.append({'fill':fill,'message_hex':message.hex(),'source_hex':None if source is None else source.hex(),'number':number,'clock':list(clock_words),'buffer_hex':bytes(u.mem_read(0x2d8d358,2560)).hex(),'calls':list(entries)})
 call(0x901c00,0,[])
 result={'passed':True,'native_sha256':digest,'formats':formats,'cases':cases,'limits':['Original8F92B0 and993860/CRT formatting execute with supplied SYSTEMTIME; the default member573FA0 executes. No replacement formatter. Null messages, invalid dates and nondefault callbacks are outside these profiles.']}
except Exception as e:
 traceback.print_exc();result={'passed':False,'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'completed':len(cases),'calls':entries,'windows':windows_calls[-8:]}
Path('E:/mapslol3v3/replay_logger_format_probe.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k not in ['cases','limits']}))
