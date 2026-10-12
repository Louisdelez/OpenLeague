"""Static PE inspection only; never maps executable memory or invokes DLL code."""
from pathlib import Path
import hashlib,json,sys
sys.dont_write_bytecode=True
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
from capstone.x86 import X86_OP_IMM,X86_OP_MEM

OUT=Path(__file__).resolve().parent
SOURCE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/RiotRadsIO.dll')
EXPECTED='60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521'
raw=SOURCE.read_bytes(); digest=hashlib.sha256(raw).hexdigest(); assert digest==EXPECTED
pe=pefile.PE(data=raw); base=pe.OPTIONAL_HEADER.ImageBase
image=pe.get_memory_mapped_image()
md=Cs(CS_ARCH_X86,CS_MODE_32);md.detail=True
def read(a,n):
    offset=a-base; assert offset>=0 and offset+n<=len(image),(hex(a),n)
    return image[offset:offset+n]
def u32(a):return int.from_bytes(read(a,4),'little')
def ascii_at(a):
    if not base<=a<base+len(image):return None
    data=read(a,min(180,base+len(image)-a)).split(b'\0',1)[0]
    if len(data)>2 and all(32<=v<127 for v in data):return data.decode('ascii')
    return None
imports={i.address:desc.dll.decode()+'!'+(i.name.decode() if i.name else '#'+str(i.ordinal))
         for desc in pe.DIRECTORY_ENTRY_IMPORT for i in desc.imports}
exports={i.name.decode() if i.name else '#'+str(i.ordinal):base+i.address for i in pe.DIRECTORY_ENTRY_EXPORT.symbols}
executable=[(base+s.VirtualAddress,base+s.VirtualAddress+max(s.Misc_VirtualSize,s.SizeOfRawData))
            for s in pe.sections if s.Characteristics&0x20000000]
def is_code(a):return any(low<=a<high for low,high in executable)
def function(start,limit=3000):
    todo=[start];seen={};edges=[];calls=[];indirect=[];strings={}
    while todo:
        pc=todo.pop()
        if pc in seen:continue
        if not is_code(pc) or abs(pc-start)>0x18000:
            edges.append({'from':None,'to':hex(pc),'boundary':'outside bounded function window'});continue
        while pc not in seen:
            if len(seen)>=limit:raise RuntimeError(('instruction cap',hex(start)))
            ins=next(md.disasm(read(pc,15),pc,count=1),None)
            if ins is None:raise RuntimeError(('decode',hex(pc)))
            item={'address':hex(pc),'bytes':ins.bytes.hex(),'text':ins.mnemonic+' '+ins.op_str}
            seen[pc]=item
            for op in ins.operands:
                address=op.imm if op.type==X86_OP_IMM else op.mem.disp if op.type==X86_OP_MEM and not op.mem.base and not op.mem.index else 0
                text=ascii_at(address)
                if text:strings[hex(address)]=text
            target=None
            if ins.operands and ins.operands[0].type==X86_OP_IMM:target=ins.operands[0].imm&0xffffffff
            iat=None
            if ins.operands and ins.operands[0].type==X86_OP_MEM:
                op=ins.operands[0]
                if not op.mem.base and not op.mem.index:iat=imports.get(op.mem.disp)
            if ins.mnemonic=='call':
                calls.append({'pc':hex(pc),'target':hex(target) if target is not None else None,'import':iat,'text':ins.op_str})
            if ins.mnemonic.startswith('ret') or ins.mnemonic in ('int3','ud2','hlt'):break
            if ins.mnemonic.startswith('j'):
                if target is not None:
                    edges.append({'from':hex(pc),'to':hex(target)})
                    if abs(target-start)<=0x18000 and is_code(target):todo.append(target)
                    else:edges[-1]['boundary']='outside bounded function window'
                else:indirect.append({'pc':hex(pc),'import':iat,'text':ins.op_str})
                if ins.mnemonic=='jmp':break
            pc+=ins.size
    ordered=[seen[a] for a in sorted(seen)]
    return {'start':hex(start),'instruction_count':len(ordered),'instructions':ordered,'calls':calls,
            'branches':edges,'indirect_branches':indirect,'strings':strings,
            'ordered_instruction_bytes_sha256':hashlib.sha256(b''.join(bytes.fromhex(x['bytes']) for x in ordered)).hexdigest()}

addresses=[0x100f2ab0,0x100ff7ae,0x100ff3fc,0x100ff4af,0x100ff62b,0x100fb602,0x100fb8b6,0x100f612b,0x100faa18,0x100f3fa9,0x100f40d2,0x100f7add,0x100f421b,0x1003f750,0x1003f7a0,0x1005bee0,0x1005c050,0x1005d3c0,0x1005d270,0x1005d3f0,0x1005d4c0,0x1010b82f]
report={'source':str(SOURCE),'source_sha256':digest,'native_execution':False,'functions':{hex(a):function(a) for a in addresses}}
(OUT/'continuation_static.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
lines=[]
for a,f in report['functions'].items():
    lines.append('\nFUNCTION '+a)
    lines.extend(i['address']+' '+i['text'] for i in f['instructions'])
    lines.append('CALLS '+json.dumps(f['calls']))
(OUT/'continuation_disassembly.txt').write_text('\n'.join(lines)+'\n',encoding='utf-8')
print(json.dumps({a:{'instructions':f['instruction_count'],'calls':f['calls']} for a,f in report['functions'].items() if a in ['0x100f3fa9','0x100f40d2','0x100f3e2b','0x100f612b','0x100fb8b6']}))