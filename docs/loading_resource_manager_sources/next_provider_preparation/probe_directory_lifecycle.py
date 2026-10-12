"""Real PE directory32 lookup/create/destroy, context-list-null profile only.

This does not construct provider56 or claim file-resolution availability.
The frozen harness prefix supplies only allocation/free/memory primitives.
"""
from pathlib import Path
import sys, importlib.util, hashlib, json
sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parent
FROZEN = Path('E:/OpenLeague/docs/loading_standard_resource_preparation')
spec = importlib.util.spec_from_file_location('source', FROZEN/'extract_resource.py')
src = importlib.util.module_from_spec(spec)
spec.loader.exec_module(src)
source = (FROZEN/'probe_resource.py').read_text().split('\ncases=[]')[0]
source = source.replace('from extract_resource import EXE, raw, digest, pe, image, BASE, OUT, read',
    'EXE, raw, digest, pe, image, BASE, read = src.EXE, src.raw, src.digest, src.pe, src.image, src.BASE, src.read\nOUT = ROOT')
exec(compile(source, str(FROZEN/'probe_resource.py')+'::prefix', 'exec'))
cases=[]
try:
    for fill in [0,165]:
        for name in [b'Ahri',b'Annie']:
            poison=fill;cursor=ARENA;live.clear();allocations.clear();frees.clear();events.clear()
            write32(0,0);write32(0x14bef40,0);write32(0x14bef58,0)
            u.mem_write(0x2d77b20,b'\1');write32(0x2d78f1c,0);write32(0x2d78f20,0)
            phase='static_hashes'
            for address in [0x531a50,0x531a90,0x531ad0,0x531b10]:call(address)
            phase='manager_producer';call(0x90b7c0);manager=read32(0x2d78f1c)
            phase='bounded_caller_fragment';u.reg_write(UC_X86_REG_EAX,manager)
            u.emu_start(0x592e49,0x592e6a,count=1000)
            assert u.reg_read(UC_X86_REG_EIP)==0x592e6a
            phase='input';query=H+0x100;make_string(query,name);before=snap()
            phase='directory_create';na=len(allocations);nf=len(frees)
            pointer=call(0x90b4a0,manager,[query,0])
            assert pointer in live and live[pointer]==32
            assert bytes.fromhex(string(pointer)['bytes_hex'])==name
            assert read32(pointer+28)==0
            sentinel=read32(pointer+24);assert live[sentinel]==48
            assert read32(sentinel)==read32(sentinel+4)==read32(sentinel+8)==sentinel
            assert u.mem_read(sentinel+13,1)==b'\1'
            fresh=list(allocations[na:]);released=list(frees[nf:]);created=snap()
            phase='directory_hit';na=len(allocations);nf=len(frees)
            assert call(0x90b4a0,manager,[query,0])==pointer
            assert snap()==created and len(allocations)==na and len(frees)==nf
            phase='input_retirement';call(0x564900,query)
            phase='manager_destructor';result=call(0x90a760,manager,[1])
            assert result==manager and not live,live
            assert read32(0x2d78f1c)==manager
            # Caller lifecycle, separate from the scalar destructor.
            write32(0x2d78f1c,0)
            cases.append({'fill':fill,'name_hex':name.hex(),'manager':manager,'directory':pointer,
                'context_global':0,'before':before,'created':created,'fresh_directory_allocations':fresh,
                'fresh_directory_frees':released,'hit_same_pointer_no_allocation':True,
                'allocations':list(allocations),'frees':list(frees),'all_owned_allocations_freed':True,
                'global_clear_is_explicit_caller_action':True})
    result={'passed':True,'complete':False,'cases':cases,'source':str(EXE),'source_sha256':digest,
        'primitive_hooks':sorted(PRIMITIVES),'executed_instruction_addresses':sorted(visited),
        'limits':['Context global2D78F20 is explicitly null. There is no search context, file lookup, archive mount or INI result.',
            'Native90B4A0/90B360/903030/9030C0 construct and cache directory32. Provider56 is not constructed.',
            'No Rust port, Windows runtime connection, normal startup, allocation failures or SEH unwind qualified.']}
except Exception as error:
    result={'passed':False,'complete':False,'error':repr(error),'phase':phase,'pc':hex(u.reg_read(UC_X86_REG_EIP)),
        'cases':cases,'live':live,'trail':list(trail),'source':str(EXE),'source_sha256':digest}
(ROOT/'directory_lifecycle_oracle.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'passed':result['passed'],'lifetimes':len(cases),'error':result.get('error'),'phase':phase}))
if not result['passed']:raise SystemExit(1)
