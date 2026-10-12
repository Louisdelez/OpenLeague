from pathlib import Path
import sys,json,hashlib,collections
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
OUT=Path(__file__).resolve().parent
EXE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=EXE.read_bytes();sha=hashlib.sha256(raw).hexdigest();assert sha=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);image=p.get_memory_mapped_image();BASE=p.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);md.detail=True
def read(a,n):
    result=image[a-BASE:a-BASE+n];assert len(result)==n;return result
def region(role,a,n):
    data=read(a,n);return dict(role=role,address=a,size=n,hex=data.hex(),sha256=hashlib.sha256(data).hexdigest())
entries=[('standard_consumer',0x57d650,0x6bc),('resource_provider',0x90ad00,0x800),('resource_string',0x57c590,0x400),('texture_acquire',0x98a7f0,0x1000),('resource_index_lookup',0x72e390,0x800),('resource_by_index',0x815cf0,0x400),('resource_singleton',0x5ce3a0,0x400),('string_context_singleton',0x98f2f0,0x400),('string_context_lookup',0x9879d0,0x600),('resource_provider_missing',0x90b520,0x1000),('resource_provider_lower_bound',0x90d220,0x400),('resource_provider_key_compare',0x901f00,0x400),('resource_singleton_ctor',0x5d5bf0,0x400),('resource_singleton_shutdown',0x5d6cc0,0x400),('resource_singleton_destroy',0x5d7820,0x400),('string_context_ctor',0x9878c0,0x400),('string_context_item_ctor',0x987bc0,0x400),('string_context_shutdown',0x98f4b0,0x400),('texture_scalar_delete',0x98aa70,0x400),('standard_slot0c',0x57f560,0x1000),('resource_provider_ctor',0x9034d0,0x800),('resource_index_destructor',0x815bc0,0x400),('standard_scalar_delete',0x578600,0x400)]
regions=[];functions=[];lines=[]
for role,start,budget in entries:
    todo=[start];seen={};edges=[];calls=[]
    while todo:
        pc=todo.pop()
        while pc not in seen:
            if not start<=pc<start+budget:edges.append(dict(kind='outside_window',target=pc));break
            ins=next(md.disasm(read(pc,15),pc,count=1),None)
            if ins is None:edges.append(dict(kind='undecoded',target=pc));break
            seen[pc]=ins;nextpc=pc+ins.size
            if ins.mnemonic=='call':calls.append(dict(address=pc,target=ins.operands[0].imm if ins.operands[0].type==capstone.x86.X86_OP_IMM else None,operand=ins.op_str))
            if ins.mnemonic.startswith('ret') or ins.mnemonic in ('int3','ud2'):break
            if ins.group(capstone.CS_GRP_JUMP):
                target=ins.operands[0].imm if ins.operands[0].type==capstone.x86.X86_OP_IMM else None
                if target is not None:todo.append(target)
                else:edges.append(dict(kind='indirect_jump',address=pc,operand=ins.op_str))
                if ins.mnemonic=='jmp':break
            pc=nextpc
    end=max(a+i.size for a,i in seen.items());regions.append(region(role,start,end-start))
    functions.append(dict(role=role,address=start,reachable_instructions=len(seen),span=end-start,calls=calls,unresolved_edges=edges))
    lines.append(f'FUNCTION {role} {start:08x} span={end-start:x} reachable={len(seen)}')
    for pc,ins in sorted(seen.items()):lines.append(f'{pc:08x} {ins.mnemonic} {ins.op_str}')
    lines.append('EDGES '+json.dumps(edges))
(OUT/'functions.txt').write_text('\n'.join(lines)+'\n')
(OUT/'call_contracts.json').write_text(json.dumps(functions,indent=2)+'\n')
constant_addresses=[0x1085b2d,0x10899b4,0x10899d8,0x10899e4,0x10867e4,0x1089a00,0x1089a34,0x1086794,0x1087114,0x1089a5c,0x1089a70,0x1089a88,0x1089a9c,0x108980c,0x108981c,0x1089d0c,0x10bef60,0x10dd14c,0x10dd128,0x10806c8,0x1086538,0x10dccbc,0x10dcd54]
strings=[]
for a in constant_addresses:
    s=read(a,512).split(b'\0',1)[0];regions.append(region('caller_string',a,len(s)+1));strings.append(dict(address=a,hex=s.hex(),text=s.decode('latin1')))
for role,a,n in [('record_table12x181',0x14c7630,0xb5*12),('service_global',0x2d787b8,4),('resource_provider_global',0x2d78f1c,4),('resource_index_global',0x2d7855c,4),('string_context_global',0x2d79050,4),('resource_provider_vtable',0x10d64a8,0x30),('byte_compare_primitive',0x5fa6b0,0x70),('crt_string_compare_entry_only',0xc9cf31,0x10)]:regions.append(region(role,a,n))
records=[]
for i in range(12):
    a=0x14c7630+i*0xb5;data=read(a,0xb5)
    records.append(dict(index=i,address=a,key_words=[int.from_bytes(data[j:j+4],'little') for j in [0,4]],field8=int.from_bytes(data[8:10],'little'),fieldA=int.from_bytes(data[10:14],'little'),fieldE=int.from_bytes(data[14:18],'little'),flags12=data[18],hex=data.hex()))
(OUT/'constants.json').write_text(json.dumps(dict(strings=strings,table=records,provider_vtable={str(i):int.from_bytes(read(0x10d64a8+i,4),'little') for i in range(0,0x30,4)}),indent=2)+'\n')
# Operand byte occurrences only: these are candidates, not decoded instruction
# xrefs until reviewed. Never infer a writer from an unaligned byte occurrence.
xrefs={}
for a in [0x14c7630,0x14c7eac,0x2d78f1c,0x2d7855c,0x2d79050]:
    found=[];needle=a.to_bytes(4,'little')
    for sec in p.sections:
        if sec.Characteristics&0x20000000:
            buf=sec.get_data();offset=0
            while True:
                i=buf.find(needle,offset)
                if i<0:break
                at=BASE+sec.VirtualAddress+i;found.append(dict(operand_address=at,window_start=at-16,window_hex=read(at-16,40).hex()));offset=i+1
    xrefs[f'{a:08x}']=found
(OUT/'operand_candidates.json').write_text(json.dumps(xrefs,indent=2)+'\n')
(OUT/'source_regions.json').write_text(json.dumps(dict(native_executable=str(EXE),native_sha256=sha,static_only=True,regions=regions),indent=2)+'\n')
print(json.dumps(dict(functions=[dict(role=f['role'],span=f['span'],instructions=f['reachable_instructions'],edges=f['unresolved_edges']) for f in functions],regions=len(regions),bytes=sum(r['size'] for r in regions),operand_candidates={k:len(v) for k,v in xrefs.items()})))
