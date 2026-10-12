from pathlib import Path
import sys,json,hashlib
sys.dont_write_bytecode=True
from process_profile import *
OUT=Path(__file__).resolve().parent;checks=[]
def check(n,v):assert v,n;checks.append(n)
def reject(n,f):
    try:f()
    except ProfileError:checks.append(n);return
    raise AssertionError(n)
path=r'E:\explicit scratch\League of Legends.exe'
for label,entries in [('empty',()),('controlled',(('OL_PROFILE','resource_probe'),('OL_VALUE','caf\u00e9'),('OL_EMPTY','')))]:
    u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);p=ProcessProfile(u,path,environment=entries)
    a=p.get_environment_strings_w();b=p.get_environment_strings_w()
    expected=('\0'.join(k+'='+v for k,v in entries)+'\0\0').encode('utf-16le')
    check(label+' exact UTF16 block and double terminator',bytes(u.mem_read(a,len(expected)))==expected and expected.endswith(b'\0\0\0\0'))
    check(label+' each call owns distinct allocation',a!=b and len(p.environment_blocks)==2)
    check(label+' fresh allocation identical controlled content',bytes(u.mem_read(b,len(expected)))==expected)
    check(label+' actual mappings are readonly',all(prot==unicorn.UC_PROT_READ for x,y,prot in u.mem_regions()))
    reject(label+' command line cannot be freed as environment',lambda:p.free_environment_strings_w(p.base))
    reject(label+' interior pointer cannot be freed',lambda:p.free_environment_strings_w(a+2))
    check(label+' invalid frees preserve owned blocks',len(p.environment_blocks)==2)
    check(label+' first matching free succeeds',p.free_environment_strings_w(a)==1)
    reject(label+' double free rejected',lambda:p.free_environment_strings_w(a))
    check(label+' remaining block survives sibling free',bytes(u.mem_read(b,len(expected)))==expected)
    check(label+' command line remains stable',p.snapshot()['memory_unchanged'])
    check(label+' second matching free succeeds',p.free_environment_strings_w(b)==1)
    c=p.get_environment_strings_w();check(label+' released addresses are not reused',c not in (a,b))
    p.close_after_execution();check(label+' final owner retires abandoned block and commandline',not p.environment_blocks and not list(u.mem_regions()))
    reject(label+' get after end rejected',p.get_environment_strings_w)
    reject(label+' free after end rejected',lambda:p.free_environment_strings_w(c))
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
for name,entries in [('equals',( ('A=B','C'),)),('NUL',( ('A','B\0C'),)),('case duplicate',( ('A','B'),('a','C')))]:
    reject('invalid declared '+name+' rejected before allocation',lambda e=entries:ProcessProfile(u,path,environment=e))
check('bad environment never maps memory',not list(u.mem_regions()))
result={'passed':True,'checks':checks,'check_count':len(checks),'native_execution':False,
 'profile':'explicit empty and nonsecret controlled blocks; no host environment imported',
 'source_hashes':{x.name:hashlib.sha256(x.read_bytes()).hexdigest() for x in [Path(__file__),OUT/'process_profile.py']}}
(OUT/'environment_profile_tests.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'passed':True,'checks':len(checks)}))
