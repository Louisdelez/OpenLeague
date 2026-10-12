from pathlib import Path
import sys, json, hashlib
sys.path.insert(0, 'E:/OpenLeague/tools/pythonlibs')
import pefile, capstone
OUT=Path(__file__).resolve().parent
EXE=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=EXE.read_bytes(); digest=hashlib.sha256(raw).hexdigest()
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw); image=pe.get_memory_mapped_image(); BASE=pe.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32);md.detail=True
def read(a,n):
    data=image[a-BASE:a-BASE+n];assert len(data)==n;return data
def walk(role,start,budget):
    todo=[start];seen={};calls=[];edges=[]
    while todo:
        pc=todo.pop()
        while pc not in seen:
            if not start<=pc<start+budget:edges.append({'outside':pc});break
            ins=next(md.disasm(read(pc,15),pc,count=1),None)
            assert ins is not None
            seen[pc]=ins; nxt=pc+ins.size
            immediate=ins.operands and ins.operands[0].type==capstone.x86.X86_OP_IMM
            if ins.mnemonic=='call':calls.append({'address':pc,'target':ins.operands[0].imm if immediate else None,'operand':ins.op_str})
            if ins.mnemonic.startswith('ret') or ins.mnemonic in ('int3','ud2'):break
            if ins.group(capstone.CS_GRP_JUMP):
                if immediate:todo.append(ins.operands[0].imm)
                else:edges.append({'indirect':pc,'operand':ins.op_str})
                if ins.mnemonic=='jmp':break
            pc=nxt
    end=max(a+i.size for a,i in seen.items());data=read(start,end-start)
    return {'role':role,'address':start,'size':len(data),'sha256':hashlib.sha256(data).hexdigest(),'hex':data.hex(),'instructions':len(seen),'calls':calls,'edges':edges}, '\n'.join([f'FUNCTION {role} {start:08x} size={len(data):x}']+[f'{a:08x} {i.mnemonic} {i.op_str}' for a,i in sorted(seen.items())]+['EDGES '+json.dumps(edges)])
ENTRIES=[('provider_lookup',0x90ad00,0x400),('provider_miss',0x90b520,0x400),('manager_path_lookup',0x90b4a0,0x80),('provider_ctor',0x9034d0,0x100),('provider_skin_init',0x903590,0x300),('provider_refresh',0x903880,0x240),('provider_resolve',0x903ee0,0x230),('provider_exists',0x9041e0,0x110),('provider_parent_set',0x905000,0x100),('provider_path_resolve',0x905ca0,0x800),('provider_cache_slot',0x90cef0,0x300),('resource_hash',0x8e50f0,0x100),('resource_hash_combine',0x8e50b0,0x100)]
DEPENDENCIES=[('manager_global_producer',0x90b7c0,0x80),('manager_ctor',0x90a4c0,0x300),('manager_scalar_delete',0x90a760,0x40),('manager_dtor',0x90a800,0x2b0),('manager_clear_owned',0x90aab0,0x250),('character_directory_miss',0x90b360,0x140),('character_directory_ctor',0x903030,0x90),('character_directory_init',0x9030c0,0x410),('normalized_key_copy',0x99a310,0x70),('lowercase_copy',0x5fa650,0x60),('crt_tolower',0xc98719,0x30),('hash_static_configuration',0x531a50,0x40),('hash_static_shared',0x531a90,0x40),('hash_static_forwarding',0x531ad0,0x40),('hash_static_interface',0x531b10,0x40),('cache_node_ctor',0x90e0c0,0x100),('cache_insert',0x90e190,0x500),('context_ctor',0x9062a0,0x120),('context_startup',0x9063e0,0x360),('context_data_root_join',0x906920,0x100),('context_source_root_join',0x906a20,0x100),('record_table_publish',0x57c930,0x70),('rank_compare_c_locale',0xc9cef8,0x39)]
if __name__=='__main__':
    regions=[];texts=[]
    for e in ENTRIES:
        r,t=walk(*e);regions.append(r);texts.append(t)
    (OUT/'resource_functions.txt').write_text('\n\n'.join(texts)+'\n')
    dependency_regions=[];dependency_texts=[]
    for e in DEPENDENCIES:
        r,t=walk(*e);dependency_regions.append(r);dependency_texts.append(t)
    (OUT/'resource_dependencies.txt').write_text('\n\n'.join(dependency_texts)+'\n')
    (OUT/'source_dependency_regions.json').write_text(json.dumps({'source_sha256':digest,'regions':dependency_regions},indent=2)+'\n')
    data_regions=[]
    def add_region(role,address,size):
        data=read(address,size);data_regions.append({'role':role,'address':address,'size':size,'hex':data.hex(),'sha256':hashlib.sha256(data).hexdigest()})
    for role,a,n in [('manager_caller_publish_backpointers',0x592e30,0x49),('manager_shutdown_outer',0x591038,0x2a),('record_table_packet_caller',0x58a500,0x8b),('record_after_provider_select',0x57d77a,0x5a),('static_hash_initializer_table',0xfa6b74,16),('provider_vtable',0x10d64a8,0x34),('manager_vtable',0x10d6450,8)]:add_region(role,a,n)
    strings={}
    for a in [0x10867f8,0x10d69dc,0x10d6624,0x108783c,0x10d66d8,0x10d66c4,0x10d666c,0x10bf2d4,0x10d6880,0x10d6b34,0x107f3fc,0x10d6630,0x1086380,0x1089828]:
        value=read(a,512).split(b'\0')[0];strings[f'{a:08x}']=value.decode('latin1');add_region('string',a,len(value)+1)
    (OUT/'source_data_regions.json').write_text(json.dumps({'source_sha256':digest,'regions':data_regions,'strings':strings},indent=2)+'\n')
    xrefs={}
    for address in (0x2d78f1c,0x2d78f20,0x14c7630,0x14c76c7):
        hits=[];needle=address.to_bytes(4,'little')
        for s in pe.sections:
            if not s.Characteristics&0x20000000:continue
            data=s.get_data();start=0
            while True:
                at=data.find(needle,start)
                if at<0:break
                va=BASE+s.VirtualAddress+at;lo=va-24
                # Candidate windows only; instruction-boundary review follows.
                hits.append({'operand_address':va,'window_start':lo,'window_hex':read(lo,64).hex(),'disasm_candidate':'\n'.join(f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in md.disasm(read(lo,64),lo))});start=at+1
        xrefs[f'{address:08x}']=hits
    (OUT/'resource_xrefs_candidates.json').write_text(json.dumps(xrefs,indent=2)+'\n')
    (OUT/'source_regions.json').write_text(json.dumps({'source':str(EXE),'source_sha256':digest,'regions':regions},indent=2)+'\n')
    print(json.dumps({'function_regions':len(regions),'dependency_regions':len(dependency_regions),'data_regions':len(data_regions),'unresolved':[(r['role'],r['edges']) for r in regions+dependency_regions if r['edges']],'xrefs':{k:len(v) for k,v in xrefs.items()}}))
