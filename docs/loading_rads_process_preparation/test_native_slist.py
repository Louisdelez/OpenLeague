from pathlib import Path
import sys,json,hashlib,struct
sys.dont_write_bytecode=True
from native_slist import *
from unicorn.x86_const import *
OUT=Path(__file__).resolve().parent;checks=[];cases=[]
def check(n,v):assert v,n;checks.append(n)
source=NativeSList();check('exact Windows x86 source19bytes',source.code==CODE and len(CODE)==19)
for fill in [0,0xa5,0xff]:
    u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(0x30000000,4096);u.mem_map(0x31000000,4096)
    leaf=NativeSList();header=0x30000100;sp=0x31000800;end=0x31000000
    u.mem_write(header-8,bytes([0xcd])*24);u.mem_write(header,bytes([fill])*8)
    u.mem_write(sp,struct.pack('<II',end,header));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,0x12121212)
    leaf.dispatch(u,header);visited=[]
    def observe(uc,pc,size,user):
        assert bytes(uc.mem_read(pc,size))==leaf.instruction_bytes(pc,size);visited.append(pc)
    u.hook_add(unicorn.UC_HOOK_CODE,observe);u.emu_start(leaf.entry,end,count=20)
    check('actual source zeroes header '+str(fill),bytes(u.mem_read(header,8))==bytes(8))
    check('actual writes preserve both guards '+str(fill),bytes(u.mem_read(header-8,8))+bytes(u.mem_read(header+8,8))==bytes([0xcd])*16)
    check('actual ret4 preserves frame '+str(fill),u.reg_read(UC_X86_REG_ESP)==sp+8 and u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EBP)==0x12121212)
    check('exact eight instructions executed '+str(fill),len(visited)==8)
    cases.append({'fill':fill,'visited':visited,'events':leaf.events})
result={'passed':True,'native_pe_execution':True,'host_x86_dll_execution':False,'checks':checks,'check_count':len(checks),
 'source':source.provenance,'cases':cases,'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'native_slist.py']}}
(OUT/'native_slist_tests.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'passed':True,'checks':len(checks)}))
