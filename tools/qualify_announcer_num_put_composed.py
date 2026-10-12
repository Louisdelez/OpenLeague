from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague')
bootstrap=(r/'tools/probe_native_audio_crt_fresh_thread_initialized_locks.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0]
exec(compile(bootstrap,'native_crt_setup','exec'))
heap=vector;read32=read;write32=w;crt_finish=finish
finish_native=lambda pop=0,eax=0:crt_finish(eax,pop)
digest=hashlib.sha256(raw).hexdigest()
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
  d=read32(sp+4);write32(d,0);finish_native(4,d);return
 if a==0x5fc1b0:finish_native(eax=ctype);return
 if a==0x5fc950:finish_native(eax=punct);return
 if a==widen:
  first,last,d=[read32(sp+i) for i in [4,8,12]];u.mem_write(d,bytes(u.mem_read(first,last-first)));ops.append({'op':'widen','bytes':last-first});finish_native(12,last);return
 if a==group_get:
  d=read32(sp+4);put_bytes(d,grouping);ops.append({'op':'grouping','bytes':grouping.hex()});finish_native(4,d);return
 if a==separator:ops.append({'op':'separator'});finish_native(eax=ord(','));return
 if a==0x5fcba0:
  position,count,ch=[read32(sp+i) for i in [4,8,12]];b=sso_bytes(ecx);assert position<=len(b);put_bytes(ecx,b[:position]+bytes([ch&255])*count+b[position:]);ops.append({'op':'insert','position':position,'count':count,'byte':ch&255});finish_native(12,ecx);return
 if a==0xca1d00:
  d,ch,count=[read32(sp+i) for i in [4,8,12]];u.mem_write(d,bytes([ch&255])*count);finish_native(eax=d);return
 if a==overflow:
  ch=read32(sp+4)&255;failed=failure_after is not None and len(emitted)>=failure_after
  ops.append({'op':'overflow','byte':ch,'failed':failed})
  if not failed:emitted.append(ch)
  finish_native(4,0xffffffff if failed else ch);return
 if a==0xc975f5:finish_native(eax=u.reg_read(UC_X86_REG_EAX));return
 hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,capture);baseline=bytes(u.mem_read(base,len(image)));cases=[]
for value,baseflags,adjust,width,grouping,storage,failure_after,cached in itertools.product([0,15,255,0x80000000,0xffffffff],[0x201,0x801,0x221,0x80d],[0,0x40,0x100],[0,16],[b'',b'\3'],['direct','overflow'],[None,0],[False,True]):
 u.mem_write(base,baseline);calls.clear();trail.clear();tls_record=0;failure='none';last_error=97;unsupported=None;u.mem_write(record,bytes(0x3bc));u.mem_write(stack-0x1000,bytes(0x1100));write32(0,0xffffffff)
 if cached:
  write32(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca91a9,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and tls_record==record;calls.clear();trail.clear();last_error=97
 cursor=heap+0x5000;ops=[];emitted=[];u.mem_write(heap,bytes(0x4000));write32(0,0xffffffff)
 write32(ios+0x14,baseflags|adjust);write32(ios+0x20,width);write32(ios+0x24,0)
 write32(buf,vt);write32(vt+12,overflow);write32(buf+0x20,current);write32(buf+0x30,remaining);write32(current,dest if storage=='direct' else 0);write32(remaining,256)
 write32(ctype,ctypevt);write32(ctypevt+0x1c,widen);write32(punct,punctvt);write32(punctvt+0x14,group_get);write32(punctvt+0x10,separator)
 facet=heap+0xc00;write32(facet,0x1042d1c)
 for i,v in enumerate([end,out,0,buf,ios,ord('_'),value]):write32(stack+i*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,facet);u.emu_start(0x5fd230,end,count=1000000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==out and unsupported is None,(hex(u.reg_read(UC_X86_REG_EIP)),hex(u.reg_read(UC_X86_REG_EAX)),hex(out),unsupported, [hex(a) for a in trail[-12:]])
 actual=bytes(u.mem_read(dest,read32(current)-dest)) if storage=='direct' else bytes(emitted)
 assert read32(ios+0x20)==0 and read32(ios+0x24)==0 and last_error==97
 cases.append({'value':value,'flags':baseflags|adjust,'width':width,'fill':ord('_'),'grouping_hex':grouping.hex(),'storage':storage,'failure_after':failure_after,'cached_tls':cached,'output_hex':actual.hex(),'result_failed':read32(out),'ops':ops.copy(),'crt_calls':calls.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual5FD230 virtual wrapper and original num_put vtable1042D1C dispatch to5FD1B0, original5FD120 format selector, C981A0 bounded printf and native CRT execute; grouping/padding/byte and fill writers execute in the same frame. No integer formatting, grouping-control or final-output result supplied.','Physical facets and SSO insertion/memset/security/virtual overflow remain explicit boundaries as in writer fixture. Actual fresh/cached CRT TLS/default PE locale initialized using supplied calloc and Windows imports.','Native ostream5FD260 sentry/locking/state/error propagation, physical facet lookup/lifetime and complete/custom-locale/exceptional runtime not qualified.']}
(r/'data/4.20/audio_announcer_num_put_composed_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_num_put_composed.py'),r/'tools/qualify_announcer_num_put_composed.py')
print(json.dumps({'native_num_put_composed_cases':len(cases)}))
