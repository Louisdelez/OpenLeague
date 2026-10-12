from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);memory=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(base,(len(memory)+4095)&~4095);u.mem_write(base,memory);u.mem_map(0x40000000,0x1000);visited=set();u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,size,user:visited.add(a))
w=lambda a,v:u.mem_write(a,struct.pack('<I',v&0xffffffff));read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
inputs=list(range(-16,17))+[-2147483648,2147483647];cases=[]
for value,previous,revision in itertools.product(inputs,[-1,0,1,2,3,4,5],[0,1,0xfffffffe,0xffffffff]):
 w(0x12258d8,previous);w(0x2d78fa8,revision);u.reg_write(UC_X86_REG_ESI,value&0xffffffff);u.reg_write(UC_X86_REG_ESP,0x40000800);u.emu_start(0x8376dd,0x837724,count=100)
 quality=max(0,min(value,4));expected=(revision+int(quality!=previous))&0xffffffff
 assert read(0x12258d8)==quality and read(0x2d78fa8)==expected
 cases.append({'input':value,'previous':previous,'initial_revision':revision,'quality':quality,'revision':expected})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8376dd','stop':'0x837724 before dependent rebuild','native_addresses':len(visited),'static_pe_initial_quality':struct.unpack_from('<i',memory,0x12258d8-base)[0],'cases':cases,'findings':['Native suffix clamps signed setting input to0..4 and changes global12258D8 with wrapping revision2D78FA8 only when quality changes.','Static original PE image initializes this global to3; this is not proof of a live user-selected quality setting.'],'limits':['Original user/configuration setting retrieval835080 and surrounding dispatch, dependent rebuild987600 and full renderer initializer remain open.','Inputs-16..16 and signed32bit extremes tested; Rust integration and actual runtime profile selection not yet performed.']}
(r/'data/4.20/environment_quality_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'initial_quality':proof['static_pe_initial_quality'],'passed':True}))
