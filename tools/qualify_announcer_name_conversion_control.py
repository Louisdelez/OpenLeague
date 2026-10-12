from pathlib import Path
import itertools,json,shutil,struct
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
raw=heap+0x2000;cache=heap+0x3000;custom_free=end+0x500;context=0x23456789
def set_wide(address,value,long_storage):
 global wide_pointer
 data=value.encode('utf-16-le')+b'\0\0';units=len(data)//2-1
 wide_pointer=heap+0xf000 if long_storage else address
 u.mem_write(address,b'\0'*24)
 if long_storage:write32(address,wide_pointer)
 u.mem_write(wide_pointer,data);write32(address+16,units);write32(address+20,8 if long_storage else 7)
def capture(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x99ad50:
  assert u.reg_read(UC_X86_REG_EDX)==raw;assert string(raw)==raw_value
  assert read32(cache+16)==0;assert cbytes(read32(cache) if read32(cache+20)>=16 else cache)==b''
  assert read32(cache+20)==cache_capacity
  trace.append('narrow_to_wide');dest=u.reg_read(UC_X86_REG_ECX);set_wide(dest,wide_value,long_storage);finish(eax=dest);return
 if a==0x99ab40:
  assert u.reg_read(UC_X86_REG_EDX)==cache;assert u.reg_read(UC_X86_REG_ECX)==wide_pointer
  expected=wide_value.encode('utf-16-le')+b'\0\0';assert bytes(u.mem_read(wide_pointer,len(expected)))==expected
  trace.append('wide_to_multibyte');dest=read32(cache) if read32(cache+20)>=16 else cache
  u.mem_write(dest,output+b'\0');write32(cache+16,len(output));finish(eax=int(success));return
 if a in (custom_free,0xc98528):
  assert long_storage;assert read32(sp+4)==wide_pointer
  if a==custom_free:assert allocator=='custom';assert read32(sp+8)==context
  else:assert allocator=='standard'
  trace.append('custom_wide_free' if a==custom_free else 'standard_wide_free');finish(eax=0);return
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 assert 0x99ac80<=a<0x99ad47,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture);cases=[]
for raw_value,previous,wide_value,long_storage,success,allocator,output in itertools.product(['','Garen'],['','PreviousCachedNameLongerThanInline'],['','Garen','É猫','😀'],[False,True],[False,True],['standard','custom'],[b'', 'É猫'.encode('utf-8')]):
 cursor=heap+0xc000;trace=[];put(raw,raw_value);put(cache,previous);cache_capacity=read32(cache+20)
 write32(0x14bef40,custom_free if allocator=='custom' else 0);write32(0x14bef44,context)
 sp=stack+0xc000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,raw);u.reg_write(UC_X86_REG_EDX,cache)
 u.emu_start(0x99ac80,end,count=50000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert u.reg_read(UC_X86_REG_EAX)&255==int(success);assert read32(cache+16)==len(output);assert read32(cache+20)==cache_capacity
 pointer=read32(cache) if cache_capacity>=16 else cache;assert cbytes(pointer)==output
 expected=['narrow_to_wide','wide_to_multibyte']+(['custom_wide_free' if allocator=='custom' else 'standard_wide_free'] if long_storage else [])
 assert trace==expected
 cases.append({'raw_name':raw_value,'previous_cache':previous,'cache_capacity':cache_capacity,'supplied_wide_value':wide_value,'wide_heap_storage':long_storage,'supplied_conversion_success':success,'allocator':allocator,'supplied_output_hex':output.hex(),'observed_output_hex':cbytes(pointer).hex(),'returned_success':bool(u.reg_read(UC_X86_REG_EAX)&255),'trace':list(trace)})
proof={'native_sha256':digest,'function':'0x99AC80','passed':True,'complete':False,'cases':cases,'limits':['Original cache clearing, inline/heap cache selection, inline/heap UTF16 temporary selection, conversion result preservation and both temporary cleanup branches executed.','99AD50 narrow-to-wide and99AB40 wide-to-multibyte conversion boundaries supplied; Unicode values verify byte transport and pointer selection only, not an encoding algorithm.','Security-check/free boundaries supplied. Native SEH/exception handlers, allocator bodies, malformed Unicode and real encoding/locale configuration remain unqualified.']}
p=r/'data/4.20/audio_announcer_name_conversion_control_contract.json';p.write_text(json.dumps(proof,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_name_conversion_control.py'),r/'tools/qualify_announcer_name_conversion_control.py')
print(json.dumps({'native_conversion_control_cases_prepared':len(cases)}))
