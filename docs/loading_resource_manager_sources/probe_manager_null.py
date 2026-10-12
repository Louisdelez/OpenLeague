"""Execute the real manager producer with its allocation primitive returning zero."""
from pathlib import Path
import hashlib,json,struct
import pefile,unicorn
from unicorn.x86_const import *
S=Path(__file__).resolve().parent
source=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=source.read_bytes();digest=hashlib.sha256(raw).hexdigest()
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;blob=pe.get_memory_mapped_image()
GLOBAL=0x2d78f1c;ALLOC=0x9933e0;START=0x90b7c0;STACK=0x31000000;END=0x32000000
cases=[];addresses=set()
for initial in [0,0x30004000]:
 u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
 u.mem_map(base,(pe.OPTIONAL_HEADER.SizeOfImage+4095)&~4095);u.mem_write(base,blob)
 u.mem_map(0,0x10000);u.mem_map(STACK,0x10000);u.mem_map(END,0x1000)
 u.mem_write(GLOBAL,struct.pack('<I',initial))
 sp=STACK+0xe000;u.mem_write(sp,struct.pack('<I',END));u.reg_write(UC_X86_REG_ESP,sp)
 u.reg_write(UC_X86_REG_EBP,0x13572468);u.reg_write(UC_X86_REG_EAX,0xffffffff)
 requests=[];writes=[];case_addresses=[]
 def word(p):return int.from_bytes(u.mem_read(p,4),'little')
 def code(uc,pc,size,_):
  if pc==ALLOC:
   current=uc.reg_read(UC_X86_REG_ESP);requests.append({'bytes':word(current+4),'global_before':word(GLOBAL)})
   uc.reg_write(UC_X86_REG_EAX,0);uc.reg_write(UC_X86_REG_ESP,current+4);uc.reg_write(UC_X86_REG_EIP,word(current));return
  assert base<=pc<base+len(blob),hex(pc)
  assert bytes(uc.mem_read(pc,size))==blob[pc-base:pc-base+size]
  assert pc!=0x90a4c0,'constructor must not execute after null allocation'
  addresses.add(pc);case_addresses.append(pc)
 def write(uc,access,address,size,value,_):
  if address<GLOBAL+4 and address+size>GLOBAL:writes.append({'pc':uc.reg_read(UC_X86_REG_EIP),'address':address,'size':size,'value':value})
 u.hook_add(unicorn.UC_HOOK_CODE,code);u.hook_add(unicorn.UC_HOOK_MEM_WRITE,write)
 u.emu_start(START,END,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==END and word(GLOBAL)==0 and word(0)==0
 assert requests==[{'bytes':172,'global_before':initial}]
 assert writes==[{'pc':0x90b81b,'address':GLOBAL,'size':4,'value':0}]
 assert u.reg_read(UC_X86_REG_ESP)==sp+4 and u.reg_read(UC_X86_REG_EBP)==0x13572468
 cases.append({'initial_global':initial,'allocation_requests':requests,'global_writes':writes,'final_global':word(GLOBAL),
               'return_eax':u.reg_read(UC_X86_REG_EAX),'stack_restored':True,'frame_restored':True,'fs_chain_restored':True,
               'constructor_executed':False,'executed_instruction_addresses':case_addresses})
value={'passed':True,'complete':False,'native_source':str(source),'source_sha256':digest,'cases':cases,
       'producer_address':START,'producer_bytes_sha256':hashlib.sha256(blob[START-base:START-base+0x74]).hexdigest(),
       'primitive_hooks':[ALLOC],'executed_instruction_addresses':sorted(addresses),
       'limits':['Allocator returns zero at its explicit primitive boundary; no actual OS out-of-memory condition is induced.',
                 'Only90B7C0 null allocation return executes. No constructor, postpublication caller fragment, SEH exception or populated resource cache is qualified.',
                 'The nonzero starting global is an observation of native overwrite behavior. The host runtime must not silently adopt or overwrite an externally owned manager.']}
(S/'native_manager_null_probe.json').write_text(json.dumps(value,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'cases':len(cases),'instruction_addresses':len(addresses),'sha256':hashlib.sha256((S/'native_manager_null_probe.json').read_bytes()).hexdigest()}))
