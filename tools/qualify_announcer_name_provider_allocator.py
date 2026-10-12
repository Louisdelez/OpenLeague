from pathlib import Path
import json,struct,itertools,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x7000;table=heap+0x8000;getter=end+0x300;custom_free=end+0x400;free_context=0x12345678;objects=[heap+0x2000+i*0x100 for i in range(4)]
write32(actor,table);write32(table+16,getter);write32(0x14bef40,0)
trace=[];virtual_calls=0;copied='';conversion_inputs=[];diagnostics=[];frees=[]
def capture(uc,a,size,user):
 global virtual_calls,copied
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==getter:
  assert ecx==actor;assert virtual_calls<4;trace.append('virtual_name');value=objects[virtual_calls];virtual_calls+=1;finish(eax=value);return
 if a==0x564c20:
  src,n=read32(sp+4),read32(sp+8);copied=bytes(u.mem_read(src,n)).decode('ascii');trace.append('temporary_copy');put(ecx,copied);finish(8,ecx);return
 if a==0x99ac80:
  assert u.reg_read(UC_X86_REG_EDX)==actor+0xb4;conversion_inputs.append(string(ecx));trace.append('conversion');put(actor+0xb4,converted);finish(eax=int(success));return
 if a==custom_free:
  assert allocator=='custom';assert read32(sp+8)==free_context;frees.append(read32(sp+4));trace.append('custom_temporary_free');finish(eax=0);return
 if a==0xc98528:frees.append(read32(sp+4));trace.append('temporary_free');finish(eax=0);return
 if a==0x5642d0:
  fmt,value=cbytes(read32(sp+4)).decode('ascii'),cbytes(read32(sp+8)).decode('ascii');diagnostics.append({'function':hex(a),'format':fmt,'name':value});trace.append('diagnostic');finish(eax=0);return
 if a==0x5fa170:
  args=[read32(sp+i) for i in (4,8,12,16,20)];assert args[:3]==[2,1,0];diagnostics.append({'function':hex(a),'flags':args[:3],'format':cbytes(args[3]).decode('ascii'),'name':cbytes(args[4]).decode('ascii')});trace.append('diagnostic');finish(eax=0);return
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 assert 0x716ce0<=a<0x716e50,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture);cases=[]
for first,success,converted,allocator in itertools.product(['','Garen','ProvidedNameLongerThanNativeSmallStringCapacity'],[False,True],['','ConvertedName','ConvertedNameLongerThanSmallStringCapacity'],['standard','custom']):
 trace=[];virtual_calls=0;copied='';conversion_inputs=[];diagnostics=[];frees=[];cursor=heap+0xc000
 write32(0x14bef40,custom_free if allocator=='custom' else 0);write32(0x14bef44,free_context)
 sequence=[first,'SecondDiagnosticName','ThirdDiagnosticName','FourthDiagnosticName']
 for address,value in zip(objects,sequence):put(address,value)
 put(actor+0xb4,'PreviousCachedName');sp=stack+0xc000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.emu_start(0x716ce0,end,count=50000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);assert result==actor+0xb4;assert string(result)==converted;assert conversion_inputs==[first];assert virtual_calls==(1 if success else 4);assert len(frees)==int(len(first)>=16)
 assert len(diagnostics)==(0 if success else 3)
 cases.append({'allocator':allocator,'custom_free_context':free_context if allocator=='custom' else None,'raw_sequence':sequence,'conversion_success':success,'provided_conversion_result':converted,'returned_actor_cache_offset':result-actor,'output':string(result),'virtual_calls':virtual_calls,'conversion_inputs':list(conversion_inputs),'diagnostics':list(diagnostics),'temporary_frees':len(frees),'trace':list(trace)})
proof={'native_sha256':digest,'function':'0x716CE0','passed':True,'complete':False,'cases':cases,'limits':['Original provider control flow, borrowed actor+B4 return, both standard/custom temporary destructor branches with exact callback context and repeated diagnostic getter calls executed.','Virtual raw-name getter, temporary string storage,99AC80 conversion, free and diagnostic output boundaries explicitly supplied. Conversion algorithm/allocator internals not qualified.','Conversion failure does not become an invented name or an exception here: original returns provided actor-cache result after diagnostics. Actual conversion failures/exceptions remain work.','No actor lifetime, concurrent cache mutation or normal client playback claim.']}
(r/'data/4.20/audio_announcer_name_provider_allocator_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_name_provider_allocator.py'),r/'tools/qualify_announcer_name_provider_allocator.py');print(json.dumps({'native_provider_cases_prepared':len(cases)}))
