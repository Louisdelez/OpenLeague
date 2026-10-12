from pathlib import Path
import json,sys
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'key prerequisites','exec'))
cases=[]
keys=[bytes((i*37+13)&255 for i in range(n)) for n in [1,4,16,32,56,57,64]]+[bytes(16),bytes([255])*16,bytes(range(16)),bytes.fromhex('00112233445566778899aabbccddeeff')]
try:
 for index,key in enumerate(keys):
  for iv in [[0,0],[0x12345678,0xfedcba98]]:
   poison=165 if index%2 else 0;snapshot();before=set(live);p=call(0x9933e0,0,[0x1058]);keyptr=heap+0xe000;ivptr=heap+0xe100;u.mem_write(keyptr,key);u.mem_write(ivptr,struct.pack('<2I',*iv))
   assert call(0x98f710,p,[keyptr,len(key),ivptr])==p
   output=bytes(u.mem_read(p,0x1058)).hex();blocks=[]
   for block in [[0,0],[0xffffffff,0xffffffff],[0x01234567,0x89abcdef],iv]:
    bp=heap+0xe200;u.mem_write(bp,struct.pack('<2I',*block));call(0x98f890,p,[bp]);blocks.append({'input':block,'output':[read32(bp),read32(bp+4)]})
   call(0xc98528,0,[p]);snapshot();assert set(live)==before
   cases.append({'fill':poison,'key_hex':key.hex(),'iv':iv,'object_hex':output,'blocks':blocks})
 result={'passed':True,'native_sha256':digest,'initial_tables_hex':bytes(u.mem_read(0x10dd320,0x1048)).hex(),'cases':cases,'limits':['Actual98F710 key construction and98F890 block transform execute on owned4184-byte objects. Inputs cover positive key lengths1/4/16/32/56/57/64, clamping to56, four16-byte patterns and two initial vectors. Primitive memory/allocator/CRT boundaries are supplied.','Zero-length key behavior reads unwritten stack bytes and is not qualified. No packet chaining mode, packet encryption/decryption or network traffic is claimed.']}
except Exception as e:
 import traceback
 traceback.print_exc();result={'passed':False,'native_sha256':digest,'cases_completed':len(cases),'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'last_calls':call_trail[-12:]}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in result.items() if k not in ['cases','initial_tables_hex','limits']}))
if not result['passed']:sys.exit(1)
