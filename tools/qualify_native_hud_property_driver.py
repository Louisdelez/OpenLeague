from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD property driver prerequisites','exec'))
owner=vector+0x6000;cursor=vector+0xe000;node=vector+0xf000;sentinel=node+0x100;callback=vector+0x5010
events=[];diagnostics=0;callback_results={};w(owner+0x1c4,sentinel);w(node+0x20,callback)
def cbytes(ptr):return bytes(u.mem_read(ptr,1100)).split(b'\0')[0]
def driver_hook(uc,a,size,user):
 global diagnostics
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x564c20:
  # Supplied string adapter only; original tokenizer preceding this boundary executes.
  target=uc.reg_read(UC_X86_REG_ECX);source=read(sp+4);length=read(sp+8)
  assert length<=1023
  u.mem_write(target,b'\0'*24)
  if length<16:u.mem_write(target,bytes(u.mem_read(source,length))+b'\0');w(target+20,15)
  else:w(target,source);w(target+20,length)
  w(target+16,length);finish(target,8);return
 if a==0x6e8d90:
  out=read(sp+4);key=read(sp+8);length=read(key+16);ptr=read(key) if read(key+20)>=16 else key
  name=bytes(u.mem_read(ptr,length));events.append(dict(key=name.decode('ascii'),found=name in callback_results))
  w(out,node if name in callback_results else sentinel);finish(out,8);return
 if a==0xc98528:finish(0);return # supplied string cleanup, not native lifetime
 if a==callback:
  element=read(sp+4);value=read(sp+8);source_cursor=read(sp+12)
  assert element==obj and source_cursor==cursor
  name=events[-1]['key'].encode('ascii');events[-1].update(value=cbytes(value).decode('ascii'),callback_result=callback_results[name])
  finish(callback_results[name]);return
 if a==0x5642d0:diagnostics+=1
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,driver_hook)
required={1:0x7e,2:0x79e,3:0x381e}
def reference(data,kind,results):
 position=0;accum=0;last=0;events=[];warnings=0
 while position<len(data):
  start=position;line=bytearray()
  while position<len(data) and len(line)<1023:
   c=data[position];position+=1
   if c==10:break
   if c!=13:line.append(c)
  line=bytes(line).split(b'\0')[0]
  # Original strtok_s skips leading ':' but its returned token pointer is ignored.
  first=next((i for i,c in enumerate(line) if c!=58),len(line))
  delimiter=line.find(b':',first)
  key=line[:delimiter] if delimiter!=-1 else line
  value=line[delimiter+1:] if delimiter!=-1 else b''
  events.append(dict(key=key.decode('ascii'),found=key in results))
  if key in results:
   last=results[key];events[-1].update(value=value.decode('ascii'),callback_result=last)
   if last!=1:accum|=last
   if last:continue
  elif line.startswith(b'/'):
   if last:continue
  else:
   if key!=b'Type':warnings+=1
  position=start;break
 return (accum&required[kind])==required[kind],position,events,warnings
cases=[]
for kind in [1,2,3]:
 mask=required[kind]
 for result in [0,1,mask,mask^(mask&-mask),mask|0x80000000,0xffffffff]:
  results={b'Mask':result,b'One':1,b'Fail':0}
  for data in [b'Mask: value\n',b'Mask: value\nType: Icon\n',b'One: x\nMask: value\n//comment\nType: Icon\n',b'Mask: value\nUnknown: x\n',b'Mask: value\n\n',b'Mask: value\nFail: x\nOne: y\n',b'//initial\nMask: value\n',b'Mask: value\r\nOne: a:b\n',b' Mask: x\n',b'Mask:value',b':Mask: value\n',b'Mask\n']:
   callback_results=results;events.clear();diagnostics=0;u.mem_write(obj,b'\0'*0x400);w(obj+0x40,kind)
   u.mem_write(text,data+b'\0'*64);w(cursor,text);w(cursor+4,len(data));w(stack,end);w(stack+4,cursor);w(stack+8,obj);w(stack+12,origin);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.reg_write(UC_X86_REG_EFLAGS,2)
   u.emu_start(0x9a1a60,end,count=250000);assert u.reg_read(UC_X86_REG_EIP)==end
   actual=(bool(u.reg_read(UC_X86_REG_EAX)&255),read(cursor)-text,list(events),diagnostics)
   assert actual==reference(data,kind,results),(kind,result,data,actual,reference(data,kind,results))
   cases.append(dict(kind=kind,input_hex=data.hex(),callback_results={k.decode():v for k,v in results.items()},accepted=actual[0],consumed=actual[1],events=actual[2],diagnostics=diagnostics))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x9a1a60',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,required_masks=required,findings=['Original line collection, CRT strtok_s tokenization, callback invocation/order, flag accumulation, validation and boundary cursor rewind execute.','Return1 continues without contributing required mask; return0 stops and rewinds current line. Other nonzero returns accumulate flags.','Unknown Type boundary rewinds without warning; other unknown keys warn. Comments before any successful callback stop; later comments continue.'],runtime_adapters=['String construction/cleanup and lookup use supplied exact ASCII key mapping; original string allocation/hash-map implementation not executed.','Property callbacks return supplied masks and do not modify element fields; registry and actual native callback associations/outputs remain open.','Cookie and logger adapted; original CRT tokenizer executes.'],limits=['Property driver control flow only; not a complete structural parser or actual widget property application.','Supplied known key mapping and callback returns; no claim about native property registration or gameplay state binding.','UI display and full game remain incomplete.'])
(r/'data/4.20/native_hud_property_driver_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
