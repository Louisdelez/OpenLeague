from pathlib import Path
import json,itertools,struct
root=Path('E:/OpenLeague')
source=(root/'tools/probe_whole_announcer_startup.py').read_text().split('\npoison=165;cursor=arena;')[0]
exec(compile(source,'native configuration boundaries','exec'))
poison=165;cursor=arena;fail=False;write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1')
call(0xc9a0b9,0,[]);write32(0x2da5308,read32(0x1222ed0));assert call(0xcb0378,0,[])==1
obj=heap+0x9000;head=heap+0xa000;buckets=heap+0xa100;node=heap+0xa200;string_data=heap+0xa400;output=heap+0xa800;key=123
def index(key):
 x=key^0xdeadbeef;x=x if x<0x80000000 else x-0x100000000
 q=abs(x)//127773*(-1 if x<0 else 1);rem=x-q*127773;state=(rem*16807-q*2836)&0xffffffff
 if state&0x80000000:state=(state+0x7fffffff)&0xffffffff
 return state&7
def sso(p,data):
 u.mem_write(p,bytes(24));write32(p+16,len(data));write32(p+20,15 if len(data)<16 else len(data)+16)
 if len(data)<16:u.mem_write(p,data+b'\0')
 else:write32(p,string_data);u.mem_write(string_data,data+b'\0')
def prepare(text,flags):
 global cursor
 cursor=arena+0x40000;allocations.clear();freed.clear();u.mem_write(obj,bytes([0xa5])*0x150)
 for offset,value in [(4,head),(8,int(text is not None)),(12,buckets),(16,buckets+64),(20,buckets+64),(24,7),(28,8)]:write32(obj+offset,value)
 write32(head,node if text is not None else head);write32(head+4,node if text is not None else head)
 for i in range(16):write32(buckets+i*4,head)
 if text is not None:
  for off,val in [(0,head),(4,head),(8,key)]:write32(node+off,val)
  sso(node+12,text);write32(buckets+index(key)*8,node);write32(buckets+index(key)*8+4,node)
 sso(obj+0x5d,b'');u.mem_write(obj+0x148,bytes(flags));write32(output,0xa5a5a5a5);write32(heap+0xb008,123)
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
texts=[None,b'',b'0',b'1',b'2',b'-1',b'true',b'TRUE',b'True',b'false',b'FALSE',b'1tail',b'0.5',b'.5',b'-.5',b'  +4.25tail',b'1e2',b'1e',b'1e+',b'1e-2',b'0x10',b'nan',b'NaN',b'inf',b'Infinity',b'None',b'none',b'NONE',b'1.#INF',b'1.#QNAN',b'-0',b'1e400',b'1e-400',b'3.4028235e38',b'1.40129846e-45',b'2.2250738585072014e-308',b'1.000000059604644775390625',b'2147483648',b'12\0-7']
texts += [b'$##$',b'$##$\0tail',b'TRUE\0tail',b' false',b'false ',b'-',b'-.',b'-nonsense',b'-1e-400',b'-1e400',b'1e999999999999999999999',b'0e999999999999999999999']
texts += [bytes([b])+b'1.5' for b in range(256)]
texts=list(dict.fromkeys(texts))
cases=[]
for kind,entry,defaults in [('float',0x8afb10,[0,0x3f800000,0x3fa66666,0x80000000]),('bool',0x8afc30,[0,1,255])]:
 for text,default in itertools.product(texts,defaults):
  prepare(text,[0,0,1]);call(entry,obj,[output,0,0,key,default])
  cases.append({'kind':kind,'text_hex':None if text is None else text.hex(),'default':default,'result':read32(output) if kind=='float' else u.mem_read(output,1)[0],'found':bool(u.reg_read(UC_X86_REG_EAX)&255),'errno_after':read32(heap+0xb008)})
for kind,entry,default in [('float',0x8afb10,0x3fa66666),('bool',0x8afc30,255)]:
 prepare(None,[0,0,0]);call(entry,obj,[output,0,0,key,default]);cases.append({'kind':kind,'text_hex':None,'text_enabled':False,'default':default,'result':read32(output) if kind=='float' else u.mem_read(output,1)[0],'found':bool(u.reg_read(UC_X86_REG_EAX)&255),'errno_after':read32(heap+0xb008)})

# Execute complete top-level getters with supplied file-cache pairs. Inner text
# lookup and numeric conversion remain the real native bodies above.
u.mem_map(0x36000000,0x10000);pair0=0x36008000;pair1=pair0+8;paths=[]
def cache_pairs(uc,address,size,user):
 if address!=0x8acef0:return
 sp=u.reg_read(UC_X86_REG_ESP);path=cbytes(read32(sp+4)).decode();flag=read32(sp+8)
 assert flag==0 and path in ['DATA/CFG/defaults/Game.cfg','Game.cfg'];paths.append(path)
 finish(eax=pair0 if path=='DATA/CFG/defaults/Game.cfg' else pair1,pop=8)
u.hook_add(unicorn.UC_HOOK_CODE,cache_pairs)
layers=[]
for kind,entry,key_name,default in [('float',0x8b20f0,b'FastForwardSpeed',0x42c80000),('bool',0x8b1910,b'UseLookAhead',1),('integer',0x8b1c20,b'PingTimeForReconnectMessage',5000)]:
 section=b'Reconnect' if kind=='integer' else b'Replay';key=0
 for byte in section.lower()+b'*'+key_name.lower():key=(key*65599+byte)&0xffffffff
 name_slot=heap+0xa900;u.mem_write(name_slot,section+b'\0'+key_name+b'\0');key_slot=name_slot+len(section)+1
 for baseline,overlay0,user_value,overlay1 in itertools.product([None,b'$##$',b'2.5'],['absent',None,b'0'],[None,b'$##$',b'true'],['absent',None,b'1.5']):
  for i,value in enumerate([baseline,overlay0,user_value,overlay1]):
   if value=='absent':continue
   obj=0x36000000+i*0x1000;head=obj+0x300;buckets=obj+0x400;node=obj+0x500;string_data=obj+0x600
   prepare(value,[0,0,1])
  write32(pair0,0x36000000);write32(pair0+4,0 if overlay0=='absent' else 0x36001000);write32(pair1,0x36002000);write32(pair1+4,0 if overlay1=='absent' else 0x36003000)
  write32(0x2d83fb8,1);write32(0x2d8a9dc,1);u.mem_write(0x2d8a9c0,bytes(24));u.mem_write(0x2d8a9c0,b'Game.cfg\0');write32(0x2d8a9d4,15)
  paths.clear();u.reg_write(UC_X86_REG_EDX,key_slot)
  if kind=='float':
   # Actual wrapper stores the returned x87 value at a real m32 boundary.
   wrapper=end+0x6000;code=b'\x6a\x00\x68'+struct.pack('<I',default)+b'\xb9'+struct.pack('<I',name_slot)+b'\xba'+struct.pack('<I',key_slot)+b'\xb8'+struct.pack('<I',entry)+b'\xff\xd0\x83\xc4\x08\xd9\x1d'+struct.pack('<I',output)+b'\xc3';u.mem_write(wrapper,code)
   call(wrapper,0,[]);result=read32(output)
  else:result=call(entry,name_slot,[default,0]);result=result&255 if kind=='bool' else result
  assert paths==['DATA/CFG/defaults/Game.cfg','Game.cfg']
  encode=lambda value:'absent' if value=='absent' else None if value is None else value.hex()
  layers.append({'kind':kind,'section':section.decode(),'key':key_name.decode(),'default':default,'baseline':encode(baseline),'baseline_overlay':encode(overlay0),'user':encode(user_value),'user_overlay':encode(overlay1),'result':result})
proof={'passed':True,'complete':False,'native_sha256':digest,'float_absent_marker_hex':cbytes(0x10c9a80).hex(),'bool_true_hex':cbytes(0x1085b28).hex(),'bool_false_hex':cbytes(0x1085b20).hex(),'cases':cases,'limits':['Actual8AFB10/8AFC30,8AE0E0 map lookup, string helpers and CRT atof/atoi/case comparison execute. Valid eight-bucket map populated as explicit read-only input; no text lookup or numeric helper-result adapter.','Text-only configuration object profile; typed INIBIN and top-level baseline/user layering are not covered here. Explicit C locale/static locks/TLS/allocator setup and primitive Windows/memory boundaries supplied.']}
proof['layer_cases']=layers
proof['limits'][1]='Complete8B20F0/8B1910/8B1C20 route actual text readers across supplied baseline/user and optional overlay cache pairs. Native string path and hash code execute. Cache file-pair resolution is a supplied boundary; typed INIBIN, actual resource population, alternate locales and runtime reload remain open. Explicit C locale/static locks/TLS/allocator setup and primitive Windows/memory boundaries supplied.'
(root/'data/4.20/replay_config_values_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'layer_cases':len(layers),'marker':proof['float_absent_marker_hex'],'passed':True}))
