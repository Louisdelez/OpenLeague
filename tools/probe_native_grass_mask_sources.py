from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);memory=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(memory)+4095)&~4095);u.mem_write(base,memory);arena=0x40000000;u.mem_map(arena,0x10000);out=arena;registry=arena+0x1000;wrapper=arena+0x2000;actor=arena+0x3000;vt=arena+0x4000;stack=arena+0x8000;end=arena+0xf000;visited=set();records=[];gates={};projected=[]
w=lambda a,v:u.mem_write(a,struct.pack('<I',v&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
def finish(pop=0,result=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EAX,result)
def hook(uc,a,size,user):
 if a in [arena+0x5000,arena+0x5010,arena+0x5020]:finish(result=gates[a]);return
 if a==0x744440:assert read(u.reg_read(UC_X86_REG_ESP)+4)==out;records.clear();finish(4);return
 if a==0x744460:
  assert u.reg_read(UC_X86_REG_ECX)==out;pointer=read(u.reg_read(UC_X86_REG_ESP)+4);records.append(list(struct.unpack('<4I',u.mem_read(pointer,16))));finish(4);return
 if a==0x986510:
  sp=u.reg_read(UC_X86_REG_ESP);destination=read(sp+4);radius_bits=read(sp+8);assert u.reg_read(UC_X86_REG_ECX)==actor+0x95;projected.append(radius_bits);u.mem_write(destination,struct.pack('<4f',10.,20.,30.,40.));finish(result=destination);return
 if a==0xc975f5:finish();return
 assert 0x73ad90<=a<0x73ae8f,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(registry,wrapper);w(wrapper+4,actor);w(actor,vt)
for slot,callback in [(0x74,arena+0x5000),(0x1e0,arena+0x5010),(0x90,arena+0x5020)]:w(vt+slot,callback)
w(0x2d628e8,registry);w(0x2d628ec,registry+4);cases=[];radius_bits=struct.unpack_from('<I',memory,0x1138b50-base)[0]
for enabled,flags_b0,flags_e0,v74,v1e0,v90 in itertools.product([0,1,2,255],[0,0x20,0x40,0xffffffff],[0,0x40,0x80,0xff],[0,1],[0,1],[0,1]):
 u.mem_write(actor+0xad,bytes([enabled]));w(actor+0xb0,flags_b0);u.mem_write(actor+0xe0,bytes([flags_e0]));gates={arena+0x5000:v74,arena+0x5010:v1e0,arena+0x5020:v90};w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,out);records=[];projected=[];u.emu_start(0x73ad90,end,count=500);expected=enabled!=0 and flags_b0&0x20==0 and flags_e0&0x40!=0 and bool(v74) and bool(v1e0) and bool(v90);assert len(records)==int(expected) and len(projected)==int(expected)
 if expected:assert projected==[radius_bits] and records==[list(struct.unpack('<4I',struct.pack('<4f',10.,20.,30.,40.)))]
 cases.append({'enabled_byte':enabled,'flags_b0':flags_b0,'flags_e0':flags_e0,'virtual74':v74,'virtual1e0':v1e0,'virtual90':v90,'eligible':expected})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x73ad90','native_addresses':len(visited),'margin_bits':radius_bits,'margin':struct.unpack('<f',struct.pack('<I',radius_bits))[0],'cases':cases,'findings':['Original source collector filters registry actors through byteAD, B0bit20, E0bit40 and virtual74/1E0/90 gates before projection.','Eligible actors pass the six-float AABB at actor+95 and original expansion margin0.3 to986510, append one four-word screen rectangle, and preserve projection output bits.'],'runtime_adapters':['Original collector instructions execute; actor virtual gates supplied independently; vector clear/append and security-cookie adapters.','Projection986510 adapted to distinctive output bits (float encodings used only as recognizable opaque words); actual output is four signed integer rectangle coordinates, not a float position or circle.'],'limits':['Registry producer and semantic meaning of gates, AABB producer, projection986510, camera matrices, source ordering for multiple actors and actual mask rendering remain open.','No synthetic circle or silently invented eligibility integrated into current renderer.']}
(r/'data/4.20/grass_mask_sources_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'margin':proof['margin'],'eligible_cases':sum(c['eligible'] for c in cases),'passed':True}))
