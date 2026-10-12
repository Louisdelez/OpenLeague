from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague')
bootstrap=(r/'tools/probe_native_audio_crt_fresh_thread_initialized_locks.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0]
exec(compile(bootstrap,'native_crt_setup','exec'))
heap=vector;read32=read;write32=w;crt_finish=finish
finish_native=lambda pop=0,eax=0:crt_finish(eax,pop)
digest=hashlib.sha256(raw).hexdigest()
stream=heap+0xd00;stream_vb=heap+0xe00;ios=stream+0x58;buf=heap+0x300;vt=heap+0x400;ctype=heap+0x500;ctypevt=heap+0x600;punct=heap+0x700;punctvt=heap+0x900
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
 if a==0x5fbdc0:ops.append({'op':'num_put_facet'});finish_native(eax=facet);return
 if a in [end+0x440,end+0x450]:ops.append({'op':'lock' if a==end+0x440 else 'unlock'});finish_native();return
 if a==0xce0c84:ops.append({'op':'uncaught_exception','raw':uncaught_raw});finish_native(eax=uncaught_raw);return
 if a==end+0x460:ops.append({'op':'sync','result':sync_result});finish_native(eax=sync_result & 0xffffffff);return
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
for value,flags,initial_state,storage,failure_after,uncaught_raw,sync_result,tied in itertools.product([0,255,0xffffffff],[0x201,0x801,0x203,0x803],[0,1,4],['direct','overflow','null'],[None,0,2],[0,1,256,257],[0,-1],['none','self']):
 u.mem_write(base,baseline);calls.clear();trail.clear();tls_record=0;failure='none';last_error=97;unsupported=None;u.mem_write(record,bytes(0x3bc));u.mem_write(stack-0x1000,bytes(0x1100));write32(0,0xffffffff)
 cursor=heap+0x5000;ops=[];emitted=[];grouping=b'';u.mem_write(heap,bytes(0x4000));write32(0,0xffffffff)
 write32(stream,stream_vb);write32(stream_vb+4,0x58)
 write32(ios+0x14,flags);write32(ios+0xc,initial_state);write32(ios+0x38,0 if storage=='null' else buf);write32(ios+0x40,ord(' '));write32(ios+0x3c,stream if tied=='self' else 0)
 write32(buf,vt);write32(vt+4,end+0x440);write32(vt+8,end+0x450);write32(vt+12,overflow);write32(vt+0x34,end+0x460)
 write32(buf+0x20,current);write32(buf+0x30,remaining);write32(current,dest if storage=='direct' else 0);write32(remaining,256)
 write32(ctype,ctypevt);write32(ctypevt+0x1c,widen);write32(punct,punctvt);write32(punctvt+0x14,group_get);write32(punctvt+0x10,separator)
 facet=heap+0xc00;write32(facet,0x1042d1c);write32(stack,end);write32(stack+4,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,stream);u.emu_start(0x5fd260,end,count=1000000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==stream and unsupported is None,(hex(u.reg_read(UC_X86_REG_EIP)),unsupported)
 actual=bytes(u.mem_read(dest,read32(current)-dest)) if storage=='direct' else bytes(emitted)
 assert last_error==97
 cases.append({'value':value,'flags':flags,'initial_state':initial_state,'storage':storage,'failure_after':failure_after,'uncaught_raw':uncaught_raw,'sync_result':sync_result,'tied':tied,'output_hex':actual.hex(),'result_state':read32(ios+0xc),'ops':ops.copy(),'crt_calls':calls.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original5FD260 ostream insertion,5FD230 virtual dispatch,5FD1B0 num_put,5FD120 selection,C981A0 actual CRT,5FCD40 grouping/padding,5FCC60/5FCCD0 writers,5FDFB0 state setter and5FD800 unitbuf sentry postaction execute in one native call. No supplied integer-format or final state/output result.','Lock/unlock, facet provider, uncaught_exception low-byte result, pubsync and virtual overflow supplied. Native C++ exception propagation and external tied-stream flush excluded; only no/self ties tested.','Native CRT fresh TLS/default PE locale executes with supplied calloc/Windows imports; ctype/numpunct physical facets and SSO insertion/memset/security remain explicit. Default zero width/empty grouping. Physical runtime allocator/facet ownership and live registry/playback still incomplete.']}
(r/'data/4.20/audio_announcer_ostream_integer_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_ostream_integer.py'),r/'tools/qualify_announcer_ostream_integer.py')
print(json.dumps({'native_ostream_integer_cases':len(cases)}))
