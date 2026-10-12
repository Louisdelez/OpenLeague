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
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
path=r'E:\mapslol3v3\loading_rads_commandline_probe\declared root\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe'
p=ProcessProfile(u,path);expected=('"'+path+'"').encode('ascii')+b'\0'
pointer=p.get_command_line_a()
check('pointer fits32 bits',0<pointer<=0xffffffff)
check('exact quoted executable and single terminator',bytes(u.mem_read(pointer,len(expected)))==expected and expected.count(b'\0')==1)
check('repeated getter preserves pointer',all(p.get_command_line_a()==pointer for _ in range(5)))
check('declared no arguments profile has no suffix',p.command_line.endswith(b'.exe"\0'))
u.mem_map(0x3a000000,0x1000);u.mem_write(0x3a000000,b'unrelated owned memory');u.mem_unmap(0x3a000000,0x1000)
check('command line remains owned across unrelated allocations',p.snapshot()['memory_unchanged'])
regions=list(u.mem_regions());check('page is read only',any(a==pointer and prot==unicorn.UC_PROT_READ for a,b,prot in regions))
reject('second owner cannot map same page',lambda:ProcessProfile(u,path))
check('rejected collision preserves original bytes',bytes(u.mem_read(pointer,len(expected)))==expected)
for label,value in [('quote',path+'"'),('relative','League of Legends.exe'),('NUL',path+'\0'),('wrong executable',path.replace('League of Legends.exe','python.exe'))]:
    reject('invalid '+label+' rejected',lambda v=value:ProcessProfile(u,v,base=0x3b010000))
check('invalid profiles never acquire memory',list(u.mem_regions())==regions)
reject('entire environment reserve must fit32bits',lambda:ProcessProfile(u,path,base=0xffffe000))
before=p.snapshot();p.close_after_execution();check('process storage retired at explicit end',p.closed and not list(u.mem_regions()))
reject('getter refuses retired process',p.get_command_line_a)
p.close_after_execution();check('retirement idempotent',not list(u.mem_regions()))
result={'passed':True,'check_count':len(checks),'checks':checks,'native_execution':False,'profile':before,
 'source_hashes':{x.name:hashlib.sha256(x.read_bytes()).hexdigest() for x in [Path(__file__),OUT/'process_profile.py']}}
(OUT/'process_profile_tests.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'passed':True,'checks':len(checks)}))
