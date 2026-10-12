"""Execute original num_put grouping/padding and streambuf writers.

Locale facets, physical SSO operations and virtual overflow are explicit
boundaries. No supplied final formatting, grouping or writer output.
"""
from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague')
__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
bootstrap=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(bootstrap,__file__,'exec'))
ios=heap+0x100;buf=heap+0x300;vt=heap+0x400;ctype=heap+0x500;ctypevt=heap+0x600;punct=heap+0x700;punctvt=heap+0x900
current=heap+0xa00;remaining=heap+0xa04;dest=heap+0x1000;out=heap+0x2000;number=heap+0x3000
widen=end+0x400;group_get=end+0x410;separator=end+0x420;overflow=end+0x430
ops=[];emitted=[];grouping=b'';failure_after=None
def sso_bytes(a):return bytes(u.mem_read(read32(a) if read32(a+20)>=16 else a,read32(a+16)))
def put_bytes(a,b):
 global cursor
 u.mem_write(a,bytes(24));write32(a+16,len(b))
 if len(b)<16:u.mem_write(a,b+b'\0');write32(a+20,15)
 else:write32(a,cursor);u.mem_write(cursor,b+b'\0');cursor+=(len(b)+32)&~15;write32(a+20,len(b))
def capture(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0x5fca80:
  d=read32(sp+4);write32(d,0);finish(4,d);return
 if a==0x5fc1b0:finish(eax=ctype);return
 if a==0x5fc950:finish(eax=punct);return
 if a==widen:
  first,last,d=[read32(sp+i) for i in [4,8,12]];u.mem_write(d,bytes(u.mem_read(first,last-first)));ops.append({'op':'widen','bytes':last-first});finish(12,last);return
 if a==group_get:
  d=read32(sp+4);put_bytes(d,grouping);ops.append({'op':'grouping','bytes':grouping.hex()});finish(4,d);return
 if a==separator:ops.append({'op':'separator'});finish(eax=ord(','));return
 if a==0x5fcba0:
  position,count,ch=[read32(sp+i) for i in [4,8,12]];b=sso_bytes(ecx);assert position<=len(b);put_bytes(ecx,b[:position]+bytes([ch&255])*count+b[position:]);ops.append({'op':'insert','position':position,'count':count,'byte':ch&255});finish(12,ecx);return
 if a==0xca1d00:
  d,ch,count=[read32(sp+i) for i in [4,8,12]];u.mem_write(d,bytes([ch&255])*count);finish(eax=d);return
 if a==overflow:
  ch=read32(sp+4)&255;failed=failure_after is not None and len(emitted)>=failure_after
  ops.append({'op':'overflow','byte':ch,'failed':failed})
  if not failed:emitted.append(ch)
  finish(4,0xffffffff if failed else ch);return
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 assert 0x5fcd40<=a<=0x5fd11e or 0x5fcc60<=a<=0x5fcd35 or 0x5fc2d0<=a<=0x5fc382 or 0x5fcb20<=a<=0x5fcb39,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
cases=[]
for text,baseflags,adjust,width,grouping,storage,failure_after,initial_failed in itertools.product(
 ['0','15','255','-2147483648','+123456789','0x1234','-0X1234'],[0x201,0x801],[0,0x40,0x100,0x140],[0,5,16],[b'',b'\3',b'\3\2',b'\3\x7f',b'\x80'],['direct','overflow','null'],[None,0,3],[0,0x12345678]):
 cursor=heap+0x5000;ops=[];emitted=[];u.mem_write(heap,bytes(0x4000));write32(0,0xffffffff)
 write32(ios+0x14,baseflags|adjust);write32(ios+0x20,width);write32(ios+0x24,0)
 write32(buf,vt);write32(vt+12,overflow);write32(buf+0x20,current);write32(buf+0x30,remaining)
 write32(current,dest if storage=='direct' else 0);write32(remaining,256)
 write32(ctype,ctypevt);write32(ctypevt+0x1c,widen);write32(punct,punctvt);write32(punctvt+0x14,group_get);write32(punctvt+0x10,separator)
 u.mem_write(number,text.encode()+b'\0');sp=stack+0xc000
 args=[end,0,out,initial_failed,0 if storage=='null' else buf,ios,ord('_'),number,len(text)]
 for i,v in enumerate(args):write32(sp+4*i,v)
 u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x5fcd40,end,count=100000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==out
 actual=bytes(u.mem_read(dest,read32(current)-dest)) if storage=='direct' else bytes(emitted)
 assert read32(ios+0x20)==0 and read32(ios+0x24)==0
 assert read32(out+4)==(0 if storage=='null' else buf)
 cases.append({'text':text,'flags':baseflags|adjust,'width':width,'fill':ord('_'),'grouping_hex':grouping.hex(),'storage':storage,'failure_after':failure_after,'initial_failed':initial_failed,'output_hex':actual.hex(),'result_failed':read32(out),'ops':ops.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original5FCD40 grouping/padding/sign-prefix handling,5FCC60 byte writer,5FCCD0 fill writer and5FC2D0 SSO resize execute. Original5FCB20 virtual grouping getter executes. No final-output or grouping-control adapter.','Locale getter/ctype range widen/numpunct grouping/separator, physical SSO insertion, memset, security cookie and virtual overflow explicitly supplied. Prefix and digits are inputs; original integer printf/insertion chain not composed here. Physical allocations, native locales and exception propagation remain incomplete.','Width high DWORD zero; small finite width, short integer inputs; direct buffer with256 capacity, virtual overflow and null buffer. Overflow supplied deterministically.']}
(r/'data/4.20/audio_announcer_num_put_writer_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_num_put_writer.py'),r/'tools/qualify_announcer_num_put_writer.py')
print(json.dumps({'native_num_put_writer_cases':len(cases)}))

