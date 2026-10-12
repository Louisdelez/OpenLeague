from pathlib import Path
import json,itertools,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
raw_string=heap+0x2000;actor=heap+0x7000;table=heap+0x8000;getter=end+0x700;cache=actor+0xb4;custom_free=end+0x600;context=0x34567890;input_address=heap+0x5000;output_object=heap+0x4000
def pointer(address,wide=False):return read32(address) if read32(address+20)>=(8 if wide else 16) else address
def resize(address,amount,wide):
 global cursor
 width=2 if wide else 1;old=read32(address+16);capacity=read32(address+20);length=old+amount
 if length>capacity:
  destination=cursor;cursor+=(length*width+64)&~15
  previous=bytes(u.mem_read(pointer(address,wide),old*width));u.mem_write(destination,previous+b'\0'*((length-old+1)*width));write32(address,destination);write32(address+20,length)
 else:u.mem_write(pointer(address,wide)+old*width,b'\0'*((amount+1)*width))
 write32(address+16,length);allocations.append({'wide':wide,'requested_length':length,'capacity':read32(address+20)})
write32(actor,table);write32(table+16,getter)
def capture(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0x5fda30:
  assert ecx==output_object;address,n=read32(sp+4),read32(sp+8);outputs.append(bytes(u.mem_read(address,n)).hex());finish(8,output_object);return
 if a==getter:
  assert ecx==actor;getter_calls.append(raw_string);finish(eax=raw_string);return
 if a==0x564c20:
  global cursor
  address,n=read32(sp+4),read32(sp+8);value=bytes(u.mem_read(address,n));copied_inputs.append(value.hex())
  u.mem_write(ecx,b'\xcc'*16);write32(ecx+16,n);write32(ecx+20,n if n>=16 else 15)
  destination=cursor if n>=16 else ecx
  if n>=16:write32(ecx,destination);cursor+=(n+64)&~15
  u.mem_write(destination,value+b'\0'+(b'\xcc'*32 if n>=16 else b'\xcc'*(15-n)));finish(8,ecx);return
 if a==0x716d7b:conversion_results.append(bool(u.reg_read(UC_X86_REG_EAX)&255))
 if a in (0x5c0800,0x5f82a0):
  assert read32(sp+8)==0;resize(ecx,read32(sp+4),a==0x5c0800);finish(8,ecx);return
 if a==0x5f5f30:
  length=read32(sp+4);assert length<=read32(ecx+16);write32(ecx+16,length);u.mem_write(pointer(ecx,True)+length*2,b'\0\0');finish(4,ecx);return
 if a==0x5f9f40:finish(eax=pointer(ecx,True));return
 if a==0x564e50:finish(eax=pointer(ecx));return
 if a==0x5fa6b0:
  lhs,rhs,n=[read32(sp+i) for i in (4,8,12)];left=bytes(u.mem_read(lhs,n));right=bytes(u.mem_read(rhs,n));finish(eax=0 if left==right else (0xffffffff if left<right else 1));return
 if a in (custom_free,0xc98528):
  if a==custom_free:assert allocator=='custom';assert read32(sp+8)==context
  else:assert allocator=='standard'
  freed.append({'allocator':allocator,'pointer':read32(sp+4)});finish(eax=0);return
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 assert 0x400000<=a<0x1000000,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
decoder=json.loads((r/'data/4.20/audio_announcer_name_narrow_decoder_contract.json').read_text(encoding='utf-8'))
inputs=sorted(set(c['input_hex'] for c in decoder['cases']));cases=[]
for input_hex,previous,allocator,entry,input in itertools.product(inputs,['','PreviousCachedNameLongerThanInline'],['standard','custom'],[0x6d4a10,0x6d4dc0],[' name@',' NAME@',' unknown field@']):
 data=bytes.fromhex(input_hex);cursor=heap+0xa000;allocations=[];freed=[];getter_calls=[];copied_inputs=[];conversion_results=[];outputs=[]
 u.mem_write(raw_string,b'\0'*24);p=heap+0x6000 if len(data)>=16 else raw_string
 if len(data)>=16:write32(raw_string,p)
 u.mem_write(p,data+b'\0'+b'\xcc'*32);write32(raw_string+16,len(data));write32(raw_string+20,len(data) if len(data)>=16 else 15)
 # Inline raw strings have no caller padding after their16byte storage: their native header follows.
 put(cache,previous);write32(0x14bef40,custom_free if allocator=='custom' else 0);write32(0x14bef44,context)
 sp=stack+0xc000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);write32(sp+4,output_object);write32(actor+0x1c,0x1000);u.mem_write(input_address,input.encode()+b"\0");u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor)
 u.emu_start(entry,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert len(outputs)==1;assert len(getter_calls)==1;assert conversion_results==[True];assert copied_inputs==[data.split(b"\0")[0].hex()];result=conversion_results[0];length=read32(cache+16);output=bytes(u.mem_read(pointer(cache),length))
 cases.append({'entry':hex(entry),'input':input,'formatter_output_hex':outputs[0],'input_hex':input_hex,'previous_cache':previous,'allocator':allocator,'returned_success':bool(result),'output_hex':output.hex(),'length':length,'capacity':read32(cache+20),'string_resize_boundaries':list(allocations),'temporary_frees':len(freed),'getter_calls':len(getter_calls),'copied_inputs':list(copied_inputs),'returned_cache_offset':0xb4})
proof={'native_sha256':digest,'functions':['0x6D4A10','0x6D4DC0','0x6D3030','0x6D3090','0x716CE0','0x99AC80','0x99AD50','0x99AB40','0x99B230','0x99C1F0','0x99C030'],'passed':True,'complete':False,'input_count':len(inputs),'cases':cases,'limits':['Actual plain/localized named-token and exhausted fallback dispatchers execute original hero name provider and native conversion without result adapters.716CE0 provider executes virtual getter, first-NUL name copy, native complete conversion, temporary cleanup and borrowed actor+B4 return. Actual conversion executes narrow decoder, wide/narrow sizing and writing, and native reverse-NUL search. No encoding-result adapters.','Virtual raw-name getter, native-layout temporary copy/storage with explicitCCpadding, string growth/erase, base-pointer getter, byte comparison, security and free boundaries explicitly supplied; capacities use documented exact-size storage, not original allocator growth.','Malformed source lookahead may inspect native inline header bytes; raw inline object layout included, not replaced by invented trailing bytes.','Native exceptional/SEH paths, physical allocation, cache concurrency/ownership and normal client announcements remain unqualified.']}
(r/'data/4.20/audio_announcer_name_full_formatter_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_name_full_formatter.py'),r/'tools/qualify_announcer_name_full_formatter.py')
print(json.dumps({'native_full_name_formatter_inputs':len(inputs),'native_full_name_formatter_cases':len(cases)}))
