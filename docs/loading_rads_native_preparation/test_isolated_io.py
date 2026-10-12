"""Real Windows bridge checks, including rejected junction and hardlink writes."""
from pathlib import Path
import sys,json,hashlib,ctypes,struct,uuid,os
sys.dont_write_bytecode=True
from isolated_io import *
OUT=Path(__file__).resolve().parent
tag=uuid.uuid4().hex[:10]
b=Bridge(OUT/('test_root_'+tag))
checks=[]
limitations=[]
def check(name,condition):
    assert condition,name
    checks.append(name)
def denied(name,fn):
    before=len(b.events)
    try:fn()
    except Rejected as error:check(name,len(b.events)==before);return str(error)
    raise AssertionError('not rejected: '+name)
q='DATA/Characters/Ahri/Skins/Base/AhriLoadScreen.dds'
source=SOURCE/DEPLOY_REL/q
before=source.read_bytes();source_hash=hashlib.sha256(before).hexdigest()
fail=None
try:
    check('actual source attributes',b.attributes(q)==K.GetFileAttributesW(extended(source)))
    check('case insensitive mapped path',b.attributes(q.swapcase())!=0xffffffff)
    check('dotdot contained',b.attributes('../configurationmanifest')!=0xffffffff)
    denied('dotdot escape',lambda:b.attributes('../../../../../../../escape'))
    denied('absolute source write rejected',lambda:b.open(str(source),WRITE,1,2))
    denied('virtual assets write rejected',lambda:b.open(q,WRITE,1,2))
    denied('prefix sibling escape',lambda:b.attributes(str(b.root)+'_other/Config/a'))
    denied('alternate stream rejected',lambda:b.attributes(q+':evil'))
    denied('DOS device rejected',lambda:b.attributes('NUL'))
    denied('trailing dot rejected',lambda:b.attributes('DATA.'))
    denied('UNC rejected',lambda:b.attributes('\\\\server\\share\\a'))
    denied('drive relative rejected',lambda:b.attributes('E:foo'))
    config=str(b.root/'Config')
    check('real CreateDirectory success',b.mkdir(config)==1 and (b.root/'Config').is_dir())
    check('real duplicate error183',b.mkdir(config)==0 and b.last_error==183)
    file=str(b.root/'Config'/'probe.bin');h=b.open(file,READ|WRITE,1,1)
    check('real scratch create',h!=0xffffffff)
    payload=b'isolated native IO\x00'+bytes(range(64))
    check('real WriteFile',b.write(h,payload)==(True,len(payload)))
    check('real CloseHandle',b.close(h)==1)
    h=b.open(file.swapcase());ok,data=b.read(h,4096);b.close(h)
    check('read after write uses scratch',ok and data==payload)
    check('no source counterpart',(SOURCE/'Config'/'probe.bin').exists()==False)
    missing='DATA/Characters/Ahri/missing_'+tag+'.dds'
    target=SOURCE/DEPLOY_REL/missing
    direct=K.GetFileAttributesW(extended(target));direct_error=ctypes.get_last_error()
    check('real missing attribute error',b.attributes(missing)==direct and b.last_error==direct_error and direct==0xffffffff)
    h=b.open(missing);check('real missing CreateFile error2',h==0xffffffff and b.last_error==2)
    h=b.open('DATA/Characters/missing_'+tag+'/file.dds')
    check('real missing parent CreateFile error3',h==0xffffffff and b.last_error==3)
    check('real missing parent CreateDirectory error3',b.mkdir(str(b.root/'Config'/'missing'/'child'))==0 and b.last_error==3)
    h=b.open(q);ok,data=b.read(h,128)
    check('real source bytes',ok and data==before[:128])
    denied('read only source handle cannot write',lambda:b.write(h,b'bad'));b.close(h)
    label,data=b.find_first('DATA/Characters/Ahri/Skins/Base/*LoadScreen*')
    check('actual FindFirst result',label!=0xffffffff and data[44:304].split(b'\0')[0]==b'AhriLoadScreen.dds')
    while True:
        ok,data=b.find_next(label)
        if not ok:break
    check('real enumeration end18',b.last_error==18);b.find_close(label)
    # Junction points outside the allowed bridge root but remains in scratch.
    junction=b.root/'Config'/'redirect';junction.mkdir()
    junction_target=OUT/('junction_target_'+tag);junction_target.mkdir()
    handle=K.CreateFileW(extended(junction),WRITE,0,None,3,0x02200000,None)
    check('junction fixture handle',handle!=INVALID)
    substitute=('\\??\\'+str(junction_target)).encode('utf-16-le');display=str(junction_target).encode('utf-16-le')
    names=substitute+b'\0\0'+display+b'\0\0'
    body=struct.pack('<HHHH',0,len(substitute),len(substitute)+2,len(display))+names
    buffer=struct.pack('<IHH',0xa0000003,len(body),0)+body
    sig('DeviceIoControl',[w.HANDLE,w.DWORD,ctypes.c_void_p,w.DWORD,ctypes.c_void_p,w.DWORD,ctypes.POINTER(w.DWORD),ctypes.c_void_p],w.BOOL)
    returned=w.DWORD();ok=K.DeviceIoControl(handle,0x900a4,buffer,len(buffer),None,0,ctypes.byref(returned),None)
    err=ctypes.get_last_error();K.CloseHandle(handle)
    if ok:
        check('real junction fixture created',True)
        denied('junction write rejected',lambda:b.open(str(junction/'escape.txt'),WRITE,1,2))
        denied('junction read rejected',lambda:b.attributes(str(junction/'RADS')))
        os.rmdir(junction) # removes the junction itself, never its target
    else:
        check('junction creation limitation recorded',err==5)
        limitations.append('FSCTL_SET_REPARSE_POINT fixture creation denied Win32 5; mapped writable junction injection not exercised.')
        actual_junction=Path('C:/Users/loicd/Application Data')
        check('real existing junction has reparse attribute',bool(actual_junction.lstat().st_file_attributes&0x400))
        denied('actual reparse ancestor guard rejects',lambda:inspect_chain(actual_junction/'probe-never-opened'))
        # No access to the junction target; lstat catches the ancestor first.
    # Hardlink truncation must be refused before changing the shared payload.
    external=OUT/('hardlink_sentinel_'+tag+'.bin');external.write_bytes(b'PRESERVE')
    linked=b.root/'Config'/'hardlink.bin'
    try:os.link(external,linked)
    except PermissionError:
        limitations.append('Hardlink fixture creation denied; write-side injection not exercised. Actual existing system hardlink metadata checked read-only.')
        real_hardlink=Path('C:/Windows/System32/kernel32.dll')
        h=K.CreateFileW(extended(real_hardlink),0x80,7,None,3,0x00200000,None)
        check('actual existing hardlink read handle',h!=INVALID)
        try:info=handle_info(h,real_hardlink)
        finally:K.CloseHandle(h)
        check('actual existing hardlink count',info.links>1)
        denied('actual hardlink guard rejects',lambda:require_exclusive_file(info))
    else:
        denied('hardlink truncate rejected',lambda:b.open(str(linked),WRITE,1,2))
        check('hardlink sentinel unchanged',external.read_bytes()==b'PRESERVE' and linked.read_bytes()==b'PRESERVE')
    check('source bytes unchanged',source.read_bytes()==before)
    check('all handles closed',not b.handles and not b.finds)
except Exception as e:
    fail=repr(e)
finally:
    b.cleanup()
    proof={'passed':fail is None,'complete':False,'checks':checks,'check_count':len(checks),'error':fail,
        'root':str(b.root),'source_file':str(source),'source_sha256_before':source_hash,
        'source_sha256_after':hashlib.sha256(source.read_bytes()).hexdigest(),'events':b.events,
        'open_handles':len(b.handles)+len(b.finds),'profile':'explicit empty scratch Config; other reads actual source',
        'limits':limitations+['Confinement assumes no concurrent external filesystem mutation. Hostile cross-process rename/link races are outside this probe.',
            'No INI/provider callbacks simulated. No native consumer executes in this bridge unit test.']}
    (OUT/'io_isolation_tests.json').write_text(json.dumps(proof,indent=2)+'\n')
    print(json.dumps({'passed':proof['passed'],'checks':len(checks),'error':fail,'root':str(b.root)}))
if fail:raise SystemExit(1)
