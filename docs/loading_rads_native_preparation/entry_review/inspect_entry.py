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

entry=base+pe.OPTIONAL_HEADER.AddressOfEntryPoint
roots={'entrypoint':entry,**{name:address for name,address in exports.items() if name in ('RadsInitialize','RadsSetLogger','RadsUninitialize','RadsShutdown')}}
tls=None
if hasattr(pe,'DIRECTORY_ENTRY_TLS'):
    st=pe.DIRECTORY_ENTRY_TLS.struct;callbacks=[];cursor=st.AddressOfCallBacks
    if cursor:
        while u32(cursor):callbacks.append(hex(u32(cursor)));cursor+=4;assert len(callbacks)<64
    tls={key:hex(getattr(st,key)) for key in ['StartAddressOfRawData','EndAddressOfRawData','AddressOfIndex','AddressOfCallBacks','SizeOfZeroFill','Characteristics']}
    tls['callbacks']=callbacks
    for i,a in enumerate(callbacks):roots['tls_'+str(i)]=int(a,16)
report={'source':str(SOURCE),'source_sha256':digest,'bytes':len(raw),'image_base':hex(base),'entrypoint':hex(entry),
        'machine':hex(pe.FILE_HEADER.Machine),'dll_characteristics':hex(pe.OPTIONAL_HEADER.DllCharacteristics),
        'directories':{d.name:{'rva':hex(d.VirtualAddress),'bytes':d.Size} for d in pe.OPTIONAL_HEADER.DATA_DIRECTORY},
        'sections':[{'name':s.Name.rstrip(b'\0').decode(),'rva':hex(s.VirtualAddress),'virtual_size':s.Misc_VirtualSize,'raw_size':s.SizeOfRawData,'characteristics':hex(s.Characteristics)} for s in pe.sections],
        'tls':tls,'delay_imports':[{ 'dll':d.dll.decode(),'imports':[i.name.decode() if i.name else '#'+str(i.ordinal) for i in d.imports]} for d in getattr(pe,'DIRECTORY_ENTRY_DELAY_IMPORT',[])],
        'imports':{hex(k):v for k,v in imports.items()},'exports':{k:hex(v) for k,v in exports.items()},'roots':{k:hex(v) for k,v in roots.items()}}
report['initializer_tables']={name:{'begin':hex(low),'end_exclusive':hex(high),'bytes_hex':read(low,high-low).hex(),
    'sha256':hashlib.sha256(read(low,high-low)).hexdigest(),
    'entries':[{'slot':hex(a),'target':hex(u32(a))} for a in range(low,high,4)]}
    for name,low,high in [('c_error_initializers',0x1013147c,0x10131494),('cpp_initializers',0x10131364,0x10131478)]}
report['initial_cells']={hex(a):hex(u32(a)) for a in [0x10166bb0,0x10166be0,0x10199aa4,0x10198420,0x10198424,0x10198448,0x1019844c,0x10198450,0x1019846c,0x10198470,0x101998e0,0x101998e4]}
report['static_utf16']={hex(a):read(a,80).decode('utf-16le').split('\0',1)[0] for a in [0x10179954]}
addresses=list(roots.values())
if len(sys.argv)>1:addresses.extend(int(x,16) for x in sys.argv[1:])
addresses.extend(int(entry['target'],16) for table in report['initializer_tables'].values() for entry in table['entries'] if entry['target']!='0x0')
report['command_arguments']=sys.argv[1:]
report['functions']={hex(a):function(a) for a in dict.fromkeys(addresses)}
OUT.mkdir(exist_ok=True,parents=True)
(OUT/'entry_static.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
lines=[]
for a,fn in report['functions'].items():
    lines.append('\nFUNCTION '+a)
    lines.extend(i['address']+' '+i['text'] for i in fn['instructions'])
    lines.append('CALLS '+json.dumps(fn['calls']))
    lines.append('STRINGS '+json.dumps(fn['strings']))
(OUT/'entry_disassembly.txt').write_text('\n'.join(lines)+'\n',encoding='utf-8')
print(json.dumps({key:report[key] for key in ['entrypoint','tls','delay_imports','exports','roots']}))
print(json.dumps({a:{'instructions':f['instruction_count'],'calls':len(f['calls']),'imports':[x['import'] for x in f['calls'] if x['import']],'indirect':f['indirect_branches']} for a,f in report['functions'].items()}))
