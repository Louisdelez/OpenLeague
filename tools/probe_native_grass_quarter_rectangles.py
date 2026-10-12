from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools,math
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=p.read_bytes();pe=pefile.PE(data=raw);m=pe.get_memory_mapped_image();b=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(b,(len(m)+4095)&~4095);u.mem_write(b,m);u.mem_map(0,0x1000)
a=0x40000000;u.mem_map(a,0x10000);out=a;source=a+0x100;inputdata=a+0x1000;outputdata=a+0x3000;stack=a+0x8000;end=a+0xf000;visited=set();allocations=0
w=lambda addr,v:u.mem_write(addr,struct.pack('<I',v&0xffffffff));read=lambda addr:struct.unpack('<I',u.mem_read(addr,4))[0]
f32=lambda v:struct.unpack('<f',struct.pack('<f',v))[0]
def finish(pop=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop)
def hook(uc,addr,size,user):
 global allocations
 if addr==0x6b64b0:
  assert u.reg_read(UC_X86_REG_ECX)==out and read(u.reg_read(UC_X86_REG_ESP)+4)==1
  used=read(out+4)-read(out) if read(out) else 0;w(out,outputdata);w(out+4,outputdata+used);w(out+8,outputdata+used+16);allocations+=1;finish(4);return
 if addr==0xc975f5:finish();return
 assert 0x95ba70<=addr<0x95bbde,hex(addr);visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rectangles=[[-1,-1,0,0],[0,1,2,3],[-9,-8,-7,-6],[799,599,800,600],[16777217,16777219,2147483647,-2147483648],[3,4,5,6],[0,0,0,0]]
cases=[]
for count,shift in itertools.product(range(9),range(7)):
 rows=[rectangles[(i+shift)%len(rectangles)] for i in range(count)];allocations=0
 for i,row in enumerate(rows):u.mem_write(inputdata+i*16,struct.pack('<4i',*row))
 w(source,inputdata);w(source+4,inputdata+16*count);w(source+8,inputdata+16*count);w(stack,end)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,out);u.reg_write(UC_X86_REG_EDX,source);u.emu_start(0x95ba70,end,count=3000)
 actual=[list(struct.unpack('<4i',u.mem_read(read(out)+i*16,16))) for i in range(count)]
 expected=[[math.trunc(f32(f32(v)*0.25)) for v in row] for row in rows]
 assert actual==expected and read(out+4)-read(out)==16*count and allocations==count
 cases.append({'input_rectangles':rows,'quarter_rectangles':actual,'allocator_growth_calls':allocations})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x95ba70','native_addresses':len(visited),'cases':cases,'findings':['Native95BA70 converts each signed integer coordinate to float32, multiplies by0.25, truncates back to signed integer. Float32 rounding precedes scaling.','The output preserves order and multiplicity, including zero-sized and invalid sentinel rectangles. No clipping, union, merging or filtering occurs in this helper.'],'runtime_adapters':['Actual native scaling/vector-copy instructions execute; vector growth allocates fixed arena slots and security cookie is adapted.'],'limits':['Allocation implementation/alias branch and actual GPU quad raster remain open; no native rendered pixels claimed.']}
(r/'data/4.20/grass_quarter_rectangles_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'rectangles':sum(len(c['input_rectangles']) for c in cases),'native_addresses':len(visited),'passed':True}))
