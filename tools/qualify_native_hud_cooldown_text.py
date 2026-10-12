from pathlib import Path
import json,struct,math,itertools,datetime,hashlib
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
buffer=vector+0x8000;mode=1;calls=[];visited=set()
w(0x2da52e8,1);w(0x14ae660,1);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x37f)
def hook(uc,a,n,unused):
 if a==0x5c7c50:
  sp=u.reg_read(UC_X86_REG_ESP);assert read(sp+4)==37;finish(vector+0x9000,4);return
 if a==0x835080:finish(mode);return
 if a==0xc9811c:
  sp=u.reg_read(UC_X86_REG_ESP);out=read(sp+4);fmt_addr=read(sp+8);fmt=bytes(u.mem_read(fmt_addr,20)).split(b'\0')[0].decode('ascii')
  if fmt=='%0.1f':args=[struct.unpack('<d',u.mem_read(sp+12,8))[0]];text=fmt%args[0]
  elif fmt=='%d:%.2d':args=[read(sp+12),read(sp+16)];text=f'{args[0]}:{args[1]:02d}'
  else:assert fmt in ['%d','%dm'];args=[read(sp+12)];text=fmt%args[0]
  calls.append(dict(format=fmt,arguments=args));u.mem_write(out,text.encode('ascii')+b'\0');finish(len(text));return
 assert 0x7d7940<=a<=0x7d7a2c or 0xca5f30<=a<=0xca604c or 0xca1e40<=a<=0xca1e5b,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for mode,value in itertools.product([0,1,2,3,4,-1],[.001,.05,.1,.65,.699999,.7,1.001,12.5,59.1,59.999,60.0,60.01,61.,3601.]):
 v=struct.unpack('<f',struct.pack('<f',value))[0];calls.clear();u.mem_write(buffer,b'old\0');w(stack,end);u.mem_write(stack+4,struct.pack('<f',v));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,buffer)
 u.emu_start(0x7d7940,end,count=500);assert u.reg_read(UC_X86_REG_EIP)==end
 text=bytes(u.mem_read(buffer,64)).split(b'\0')[0].decode();integer=math.ceil(v)
 expected='' if mode==0 else f'{integer//60}:{integer%60:02d}' if v>=60. and mode==2 else f'{integer//60}m' if v>=60. and mode==3 else f'{v:.1f}' if v<struct.unpack('<f',struct.pack('<f',.7))[0] else str(integer)
 assert text==expected,(mode,v,text,expected)
 cases.append(dict(mode=mode,input_f32=v,text=text,format_call=calls[0] if calls else None))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),formatter='0x7d7940',setting_id=37,setting_name='NumericCooldownFormat',case_count=len(cases),native_addresses=len(visited),cases=cases,findings=['Original formatter branches and CRT ceil/signed conversion execute. Mode0 hides; below0.7showsone decimal; otherwiseceilseconds, mode2minutes:seconds and mode3minutes above raw60seconds. Other nonzero mode values use integerseconds.'],limits=['Original option lookup and integer getter adapted to supplied setting. C9811C printf output adapted; exact original printf/localization decimal bytes are not qualified. Native format strings and numeric varargs are recorded.','Positive finite ordinary cooldown values only. Authoritative time-to-deadline transport, smoothing, effects, UI callbacks and actual glyph pixels require integration and observation.'])
(r/'data/4.20/native_hud_cooldown_text_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'passed':True}))
