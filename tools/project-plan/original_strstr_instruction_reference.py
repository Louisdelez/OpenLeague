"""Correct only source-pinned PCMPISTRI0C instructions in original strstr.

All other original instructions execute. Memory reads use explicitly mapped guest pages only, never host mirrors.
Historical heap padding and runtime state are not inferred. Only ECX/arithmetic flags/EIP are changed by this transport.
"""
import hashlib,struct,json
from pathlib import Path
import pefile,unicorn
from unicorn.x86_const import *
DLL=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\RiotRadsIO.dll')
DLL_SHA='60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521'
class Rejected(ValueError):pass
from pcmpistri_ordered_0c import compare

ENTRY=0x100ecd00;END_CODE=0x100ecf63
INSTRUCTIONS={0x100ece7f:(UC_X86_REG_XMM0,UC_X86_REG_EAX,bytes.fromhex('660f3a6340f00c')),0x100ecebb:(UC_X86_REG_XMM1,UC_X86_REG_ESI,bytes.fromhex('660f3a634ef00c'))}
class NativeStrstrPcmp:
    def __init__(self,arena,qualified_returns=None):
        raw=DLL.read_bytes()
        if hashlib.sha256(raw).hexdigest()!=DLL_SHA:raise Rejected('strstr source identity changed')
        pe=pefile.PE(data=raw);self.pe=pe;self.base=pe.OPTIONAL_HEADER.ImageBase;self.code=pe.get_data(ENTRY-self.base,END_CODE-ENTRY)
        if hashlib.sha256(self.code).hexdigest()!='a45238a7a1d03106eccd5df32048d82fda5f7304e1023c314d302bbad7879307':raise Rejected('strstr function changed')
        proof=Path('E:/mapslol3v3/loading_rads_pcmpistri_hardware/instruction_qualification.json');raw_proof=proof.read_bytes()
        if hashlib.sha256(raw_proof).hexdigest()!='cf0b9d66ef5ade3853475d7a412f12713d9be45207ac03a8495b874463aa89d9':raise Rejected('Preserved CPU proof identity changed')
        q=json.loads(raw_proof)
        if not q['passed'] or q['case_count']!=2123:raise Rejected('PCMPISTRI candidate lacks actual CPU qualification')
        candidate=Path(__file__).parent/'pcmpistri_ordered_0c.py'
        if hashlib.sha256(candidate.read_bytes()).hexdigest()!=q['candidate']['sha256']:raise Rejected('PCMPISTRI candidate changed')
        self.arena=arena;self.u=arena.u;self.events=[];self.stack=[];self.closed=False;self.next_id=0
        self.returns=frozenset(qualified_returns) if qualified_returns is not None else None;self.execution_suspended=lambda:False
        self.hook=self.u.hook_add(unicorn.UC_HOOK_CODE,self.observe)
        self.provenance=dict(source_path=str(DLL),source_sha256=DLL_SHA,function_sha256=hashlib.sha256(self.code).hexdigest(),instruction_qualification={'path':str(proof),'sha256':hashlib.sha256(proof.read_bytes()).hexdigest()},scope='Two exact original PCMPISTRI imm0C sites, complete original search body retained.')
    def read(self,address,n):
        if address<=0 or address+n>0x100000000:raise Rejected('PCMPISTRI invalid x86 memory range')
        cursor=address;end=address+n
        for lo,hi,flags in sorted(self.u.mem_regions()):
            if hi<cursor:continue
            if lo>cursor or not flags&unicorn.UC_PROT_READ:break
            cursor=min(end,hi+1)
            if cursor==end:return bytes(self.arena.guarded.mem_read(address,n))
        raise Rejected('PCMPISTRI unreadable memory')
    def observe_return(self):
        if self.closed or self.execution_suspended() or not self.stack:return
        c=self.stack[-1]
        if self.u.reg_read(UC_X86_REG_EIP)==c['return'] and self.u.reg_read(UC_X86_REG_ESP)==c['sp']+4:self.stack.pop()
    def observe(self,u,pc,size,user):
        if self.closed or self.execution_suspended():return
        self.observe_return()
        if pc==ENTRY:
            if bytes(u.mem_read(ENTRY,len(self.code)))!=self.code:raise Rejected('strstr source bytes changed')
            sp=u.reg_read(UC_X86_REG_ESP);frame=self.read(sp,12);ret,hay,needle=struct.unpack('<III',frame)
            if self.returns is not None:
                if ret not in self.returns:return
            else:
                rva=ret-5-self.base;section=self.pe.get_section_by_rva(rva)
                if not section or not section.Characteristics&0x20000000:return
                call=self.pe.get_data(rva,5)
                if call!=b'\xe8'+struct.pack('<i',ENTRY-ret) or self.read(ret-5,5)!=call:return
            saved=[u.reg_read(r) for r in [UC_X86_REG_ESI,UC_X86_REG_EBX,UC_X86_REG_EDI]]
            self.stack.append(dict(id=self.next_id,sp=sp,return_=ret,frame=frame,saved=saved));self.stack[-1]['return']=self.stack[-1].pop('return_');self.next_id+=1
            return
        if pc not in INSTRUCTIONS or not self.stack:return
        c=self.stack[-1];xmm,reg,code=INSTRUCTIONS[pc]
        if u.reg_read(UC_X86_REG_ESP)!=c['sp']-12 or self.read(c['sp'],12)!=c['frame'] or self.read(c['sp']-12,12)!=struct.pack('<III',*c['saved']):raise Rejected('PCMPISTRI original frame changed')
        if bytes(u.mem_read(pc,len(code)))!=code:raise Rejected('PCMPISTRI source instruction changed')
        address=u.reg_read(reg)-16;right=self.read(address,16);left=u.reg_read(xmm).to_bytes(16,'little');before=u.reg_read(UC_X86_REG_EFLAGS)
        result=compare(left,right,before)
        self.events.append(dict(invocation=c['id'],pc=pc,address=address,left_hex=left.hex(),right_hex=right.hex(),flags_before=before,index=result['ecx'],flags_after=result['eflags']))
        u.reg_write(UC_X86_REG_ECX,result['ecx']);u.reg_write(UC_X86_REG_EFLAGS,result['eflags']);u.reg_write(UC_X86_REG_EIP,pc+len(code))
    def abandon(self,reason):self.stack.clear();self.events.append(dict(kind='abandoned',reason=reason))
    def close(self):self.abandon('instruction transport closed');self.closed=True;self.u.hook_del(self.hook)
