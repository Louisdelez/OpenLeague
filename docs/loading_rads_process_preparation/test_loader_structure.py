"""Read-only PE/Unicorn mapping checks: no emu_start, DllMain or OS DLL load."""
from pathlib import Path
import sys,json,hashlib,collections
sys.dont_write_bytecode=True
from pe_x86_loader import *
OUT=Path(__file__).resolve().parent;checks=[];error=None
def check(name,v):assert v,name;checks.append(name)
def reject(name,fn):
    try:fn()
    except Unsupported:checks.append(name);return
    raise AssertionError(name+' was accepted')
try:
    img=Image();check('pinned original PE32 image',img.sha256==SHA and img.base==0x10000000 and img.size==0x1ac000)
    check('all210 real imports retained',len(img.imports)==210)
    check('all13 exports and ordinals retained',len(img.exports)==26)
    check('TLS and delay imports absent',not hasattr(img.pe,'DIRECTORY_ENTRY_TLS') and not hasattr(img.pe,'DIRECTORY_ENTRY_DELAY_IMPORT'))
    check('all relocation entries validated',len(img.relocations)==30620)
    u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
    u.mem_map(0x400000,0x1000);u.mem_write(0x400000,b'preserved EXE sentinel')
    module=MappedModule(img)
    reject('handle unavailable before mapping',module.module_handle)
    reject('non-preferred base explicit rejection',lambda:module.map_into(u,0x11000000))
    check('rejected profile did not map DLL',len(list(u.mem_regions()))==1)
    module.map_into(u)
    check('mapping does not imply DLL attachment',module.state=='mapped')
    reject('mapped handle still unavailable',module.module_handle)
    check('EXE bank unchanged',bytes(u.mem_read(0x400000,22))==b'preserved EXE sentinel')
    actual=bytearray(u.mem_read(img.base,img.size));expected=bytearray(img.image)
    for target,item in module.bindings.items():
        expected[item['iat_rva']:item['iat_rva']+4]=struct.pack('<I',target)
    check('all image bytes match PE except declared IAT bindings',actual==expected)
    check('unique import stubs and module identities',len(module.bindings)==210 and all(v['module_base']==img.base for v in module.bindings.values()))
    check('entry bytes retain original source',bytes(u.mem_read(img.entry,32))==img.instruction_bytes(img.entry,32))
    check('data virtual tail really zero filled',all(bytes(u.mem_read(img.base+s['rva']+s['raw_size'],s['virtual_size']-s['raw_size']))==bytes(s['virtual_size']-s['raw_size']) for s in img.sections if s['virtual_size']>s['raw_size']))
    reject('duplicate mapping rejected',lambda:module.map_into(u))
    collision=MappedModule(img)
    before=list(u.mem_regions());reject('collision rejected before mutation',lambda:collision.map_into(u))
    check('collision left all mappings unchanged',list(u.mem_regions())==before)
    check('entry and export addresses lie in executable section',img.executable(img.entry,1) and all(img.executable(p,1) for p in img.exports.values()))
    entry,args=module.begin_attach()
    check('prepared native entry contract exact',entry==0x100f2c22 and args==(0x10000000,1,0))
    reject('no success fabricated for pending native entry',module.module_handle)
    # Do not complete attachment: no native instruction has executed.
except Exception as e:error=repr(e)
result={'passed':error is None,'checks':checks,'check_count':len(checks),'error':error,'native_execution':False,
        'limits':['Structural mapping only. No emu_start, DLL entry/export or OS loader execution.','Preferred base profile only; unsupported imports remain undefined boundaries.'],
        'source_hashes':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),OUT/'pe_x86_loader.py']}}
(OUT/'loader_structure_tests.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'passed':result['passed'],'checks':len(checks),'error':error}))
if error:raise SystemExit(1)
