from pathlib import Path
import json
root=Path('E:/OpenLeague');source=(root/'tools/qualify_active_service_lifetimes.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_active_service_lifetimes.py'),'exec'))
imports={};last_error=97;windows_calls=[];file_handles={};handle_files={};virtual_files={};virtual_directories=set();find_handles={};std_types={};debug_messages=[];initialized_locks=set();process_heap=0x71000000;pointer_key=0x13572468
write32(0x14ae87c,process_heap)
write32(0x2da5308,read32(0x1222ed0));write32(0x12230cc,5);u.mem_write(heap+0xb000,bytes(0x3bc))
for entry in pefile.PE(data=raw).DIRECTORY_ENTRY_IMPORT:
 for item in entry.imports:
  slot=end+0x4000+len(imports)*4;imports[slot]=(entry.dll.decode(),item.name.decode() if item.name else str(item.ordinal));write32(item.address,slot)
def wide_string(reference):
 value=bytearray()
 for i in range(4097):
  word=bytes(u.mem_read(reference+i*2,2))
  if word==b'\0\0':return value.decode('utf-16le')
  value.extend(word)
 raise RuntimeError('unbounded wide filename')

def windows(uc,address,size,user):
 global last_error,cursor
 if address not in imports:return
 dll,name=imports[address];sp=u.reg_read(UC_X86_REG_ESP);windows_calls.append({"dll":dll,"function":name})
 if name=='HeapAlloc':
  handle,flags,count=read32(sp+4),read32(sp+8),read32(sp+12);assert handle==process_heap and flags in [0,8];pointer=cursor;cursor+=(count+31)&~15;assert cursor<=arena+0x100000;u.mem_write(pointer,bytes([0 if flags&8 else poison])*count);allocations.append({'bytes':count,'pointer':pointer,'allocator':'windows_heap_alloc'});finish(eax=pointer,pop=12);return
 if name=='HeapFree':
  handle,flags,pointer=read32(sp+4),read32(sp+8),read32(sp+12);assert handle==process_heap and flags==0;freed.append(pointer);finish(eax=1,pop=12);return
 if name in ['GetStartupInfoA','GetStartupInfoW']:
  reference=read32(sp+4);u.mem_write(reference,bytes(68));write32(reference,68);finish(pop=4);return
 if name=='GetStdHandle':
  kind=read32(sp+4);assert kind in [0xfffffff6,0xfffffff5,0xfffffff4];handle=0x70001000+(0xfffffff6-kind)+1;file_handles.setdefault(handle,[b'',0])
  import ctypes
  kernel=ctypes.windll.kernel32;kernel.GetStdHandle.argtypes=[ctypes.c_uint32];kernel.GetStdHandle.restype=ctypes.c_void_p;kernel.GetFileType.argtypes=[ctypes.c_void_p];kernel.GetFileType.restype=ctypes.c_uint32;std_types[handle]=kernel.GetFileType(kernel.GetStdHandle(kind));windows_calls[-1]['observed_host_type']=std_types[handle];finish(eax=handle,pop=4);return
 if name=='GetFileType':
  handle=read32(sp+4);assert handle in file_handles;finish(eax=std_types.get(handle,1),pop=4);return
 if name=='GetConsoleMode':
  handle,mode=read32(sp+4),read32(sp+8);assert std_types.get(handle)==3;last_error=6;finish(eax=0,pop=8);return
 if name=='WriteFile':
  handle,buffer,count,number,overlapped=[read32(sp+i) for i in range(4,24,4)];assert overlapped==0 and handle in file_handles;part=bytes(u.mem_read(buffer,count));data,offset=file_handles[handle];data=data+bytes(max(0,offset-len(data)));file_handles[handle][0]=data[:offset]+part+data[offset+count:];file_handles[handle][1]+=count
  if handle in handle_files:
   key,access=handle_files[handle];assert access&0x40000000;virtual_files[key]=file_handles[handle][0]
  if number:write32(number,count)
  windows_calls[-1]['bytes']=count;finish(eax=1,pop=20);return
 if name=='OutputDebugStringA':
  message=cbytes(read32(sp+4));debug_messages.append(message.hex());finish(pop=4);return
 if name=='CreateDirectoryA':
  target=root/Path(cbytes(read32(sp+4)).decode('ascii'));key=str(target);windows_calls[-1]['path']=key
  if target.exists() or key in virtual_directories:last_error=183;finish(eax=0,pop=8);return
  if not target.parent.is_dir() and str(target.parent) not in virtual_directories:last_error=3;finish(eax=0,pop=8);return
  virtual_directories.add(key);finish(eax=1,pop=8);return
 if name in ['EncodePointer','DecodePointer']:
  value=read32(sp+4);finish(eax=value^pointer_key,pop=4);return
 if name=='GetModuleHandleW':
  reference=read32(sp+4);value=bytearray()
  for i in range(128):
   word=bytes(u.mem_read(reference+i*2,2))
   if word==b'\0\0':break
   value.extend(word)
  module=value.decode('utf-16le');assert module.lower()=='kernel32.dll';windows_calls[-1]['module_name']=module;finish(eax=0x71001000,pop=4);return
 if name=='GetProcAddress':
  module,reference=read32(sp+4),read32(sp+8);assert module==0x71001000;function=cbytes(reference).decode('ascii');windows_calls[-1].update({'export':function,'supplied_result':0});finish(eax=0,pop=8);return
 if name=='AreFileApisANSI':
  import ctypes
  result=ctypes.windll.kernel32.AreFileApisANSI();windows_calls[-1]['observed_result']=result;finish(eax=result);return
 if name=='MultiByteToWideChar':
  import ctypes
  codepage,flags,source,count,destination,capacity=[read32(sp+i) for i in range(4,28,4)];count=count if count<0x80000000 else count-0x100000000;input_bytes=cbytes(source)+b'\0' if count==-1 else bytes(u.mem_read(source,count));assert count==-1 or count>=0
  result_buffer=(ctypes.c_uint16*capacity)() if capacity else None;fn=ctypes.windll.kernel32.MultiByteToWideChar;fn.argtypes=[ctypes.c_uint32,ctypes.c_uint32,ctypes.c_char_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_int];fn.restype=ctypes.c_int;result=fn(codepage,flags,input_bytes,count,result_buffer,capacity);last_error=ctypes.windll.kernel32.GetLastError()
  if result and capacity:u.mem_write(destination,bytes(result_buffer)[:result*2])
  windows_calls[-1].update({'codepage':codepage,'flags':flags,'count':count,'capacity':capacity,'observed_result':result});finish(eax=result,pop=24);return
 if name=='GetFileAttributesExW':
  import ctypes
  source,level,destination=read32(sp+4),read32(sp+8),read32(sp+12);assert level==0;target=root/Path(wide_string(source));key=str(target);words=(ctypes.c_uint32*9)()
  if key in virtual_files or key in virtual_directories:words[0]=16 if key in virtual_directories else 32;words[8]=len(virtual_files.get(key,b''));result=1
  else:
   fn=ctypes.windll.kernel32.GetFileAttributesExW;fn.argtypes=[ctypes.c_wchar_p,ctypes.c_int,ctypes.c_void_p];fn.restype=ctypes.c_int;result=fn(key,level,ctypes.byref(words));last_error=ctypes.windll.kernel32.GetLastError()
  if result:u.mem_write(destination,bytes(words))
  windows_calls[-1].update({'path':key,'result':result,'words':list(words)});finish(eax=result,pop=12);return
 if name=='GetCurrentDirectoryW':
  count,buffer=read32(sp+4),read32(sp+8);value=str(root).encode('utf-16le');assert len(value)//2+1<=count;u.mem_write(buffer,value+b'\0\0');finish(eax=len(value)//2,pop=8);return
 if name=='GetFullPathNameW':
  import ctypes
  source,capacity,destination,file_part=[read32(sp+i) for i in range(4,20,4)];value=str(root/Path(wide_string(source)));buffer=(ctypes.c_uint16*capacity)() if capacity else None;part=ctypes.c_void_p();fn=ctypes.windll.kernel32.GetFullPathNameW;fn.argtypes=[ctypes.c_wchar_p,ctypes.c_uint32,ctypes.c_void_p,ctypes.POINTER(ctypes.c_void_p)];fn.restype=ctypes.c_uint32;result=fn(value,capacity,buffer,ctypes.byref(part));last_error=ctypes.windll.kernel32.GetLastError()
  if result and result<capacity:
   u.mem_write(destination,bytes(buffer)[:(result+1)*2])
   if file_part:write32(file_part,destination+(part.value-ctypes.addressof(buffer)) if part.value else 0)
  finish(eax=result,pop=16);return
 if name=='FindFirstFileExW':
  import ctypes
  source,level,destination,search,filter_pointer,flags=[read32(sp+i) for i in range(4,28,4)];assert filter_pointer==0;target=root/Path(wide_string(source));buffer=(ctypes.c_ubyte*592)();fn=ctypes.windll.kernel32.FindFirstFileExW;fn.argtypes=[ctypes.c_wchar_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_uint32];fn.restype=ctypes.c_void_p;actual=fn(str(target),level,ctypes.byref(buffer),search,None,flags);last_error=ctypes.windll.kernel32.GetLastError();windows_calls[-1].update({'path':str(target),'level':level,'search':search,'flags':flags,'found':actual!=ctypes.c_void_p(-1).value})
  if actual==ctypes.c_void_p(-1).value:finish(eax=0xffffffff,pop=24);return
  handle=0x72000000+len(find_handles)+1;find_handles[handle]=actual;u.mem_write(destination,bytes(buffer));finish(eax=handle,pop=24);return
 if name=='FindClose':
  import ctypes
  handle=read32(sp+4);actual=find_handles.pop(handle);fn=ctypes.windll.kernel32.FindClose;fn.argtypes=[ctypes.c_void_p];fn.restype=ctypes.c_int;result=fn(actual);finish(eax=result,pop=4);return
 if name=='FindNextFileW':
  import ctypes
  handle,destination=read32(sp+4),read32(sp+8);buffer=(ctypes.c_ubyte*592)();fn=ctypes.windll.kernel32.FindNextFileW;fn.argtypes=[ctypes.c_void_p,ctypes.c_void_p];fn.restype=ctypes.c_int;result=fn(find_handles[handle],ctypes.byref(buffer));last_error=ctypes.windll.kernel32.GetLastError()
  if result:u.mem_write(destination,bytes(buffer))
  finish(eax=result,pop=8);return
 if name in ['FileTimeToSystemTime','FileTimeToLocalFileTime','SystemTimeToFileTime']:
  import ctypes
  source,destination=read32(sp+4),read32(sp+8);input_size=16 if name=='SystemTimeToFileTime' else 8;output_size=16 if name=='FileTimeToSystemTime' else 8;input_buffer=(ctypes.c_ubyte*input_size).from_buffer_copy(bytes(u.mem_read(source,input_size)));output_buffer=(ctypes.c_ubyte*output_size)();fn=getattr(ctypes.windll.kernel32,name);fn.argtypes=[ctypes.c_void_p,ctypes.c_void_p];fn.restype=ctypes.c_int;result=fn(ctypes.byref(input_buffer),ctypes.byref(output_buffer));last_error=ctypes.windll.kernel32.GetLastError()
  if result:u.mem_write(destination,bytes(output_buffer))
  windows_calls[-1]['observed_result']=result;finish(eax=result,pop=8);return
 if name=='GetTimeZoneInformation':
  import ctypes
  buffer=(ctypes.c_ubyte*172)();fn=ctypes.windll.kernel32.GetTimeZoneInformation;fn.argtypes=[ctypes.c_void_p];fn.restype=ctypes.c_uint32;result=fn(ctypes.byref(buffer));u.mem_write(read32(sp+4),bytes(buffer));windows_calls[-1]['observed_result']=result;finish(eax=result,pop=4);return
 if name=='SystemTimeToTzSpecificLocalTime':
  import ctypes
  zone,source,destination=read32(sp+4),read32(sp+8),read32(sp+12);zone_buffer=(ctypes.c_ubyte*172).from_buffer_copy(bytes(u.mem_read(zone,172))) if zone else None;input_buffer=(ctypes.c_ubyte*16).from_buffer_copy(bytes(u.mem_read(source,16)));output_buffer=(ctypes.c_ubyte*16)();fn=ctypes.windll.kernel32.SystemTimeToTzSpecificLocalTime;fn.argtypes=[ctypes.c_void_p,ctypes.c_void_p,ctypes.c_void_p];fn.restype=ctypes.c_int;result=fn(zone_buffer,ctypes.byref(input_buffer),ctypes.byref(output_buffer));last_error=ctypes.windll.kernel32.GetLastError()
  if result:u.mem_write(destination,bytes(output_buffer))
  windows_calls[-1]['observed_result']=result;finish(eax=result,pop=12);return
 if name=='WideCharToMultiByte':
  import ctypes
  codepage,flags,source,count,destination,capacity,default_pointer,used_pointer=[read32(sp+i) for i in range(4,36,4)];count=count if count<0x80000000 else count-0x100000000;input_bytes=(wide_string(source)+'\0').encode('utf-16le') if count==-1 else bytes(u.mem_read(source,count*2));input_buffer=(ctypes.c_ubyte*len(input_bytes)).from_buffer_copy(input_bytes);output_buffer=(ctypes.c_ubyte*capacity)() if capacity else None;default_bytes=cbytes(default_pointer) if default_pointer else None;used=ctypes.c_int(read32(used_pointer)) if used_pointer else None;fn=ctypes.windll.kernel32.WideCharToMultiByte;fn.argtypes=[ctypes.c_uint32,ctypes.c_uint32,ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p,ctypes.c_int,ctypes.c_char_p,ctypes.c_void_p];fn.restype=ctypes.c_int;result=fn(codepage,flags,ctypes.byref(input_buffer),count,output_buffer,capacity,default_bytes,ctypes.byref(used) if used is not None else None);last_error=ctypes.windll.kernel32.GetLastError()
  if result and capacity:u.mem_write(destination,bytes(output_buffer)[:result])
  if used is not None:write32(used_pointer,used.value&0xffffffff)
  windows_calls[-1].update({'codepage':codepage,'flags':flags,'count':count,'capacity':capacity,'observed_result':result});finish(eax=result,pop=32);return
 if name=='GetLocalTime':
  import ctypes
  result=(ctypes.c_uint16*8)();ctypes.windll.kernel32.GetLocalTime(ctypes.byref(result));u.mem_write(read32(sp+4),bytes(result));windows_calls[-1]['system_time_words']=list(result);finish(pop=4);return
 if name=='GetModuleFileNameA':
  module,buffer,count=read32(sp+4),read32(sp+8),read32(sp+12);assert module in [0,0x400000];value=str(e).encode('ascii');assert len(value)+1<=count;u.mem_write(buffer,value+b'\0');finish(eax=len(value),pop=12);return
 if name=='GetCurrentThreadId':finish(eax=1);return
 if name=='GetCurrentDirectoryA':
  count,buffer=read32(sp+4),read32(sp+8);value=str(root).encode('ascii');assert len(value)+1<=count;u.mem_write(buffer,value+b'\0');finish(eax=len(value),pop=8);return
 if name=='InitializeCriticalSection':
  reference=read32(sp+4);assert arena<=reference<arena+0x100000 or 0x14ae988<=reference<0x14ae988+36*24;u.mem_write(reference,bytes(24));initialized_locks.add(reference);finish(pop=4);return
 if name=='DeleteCriticalSection':
  reference=read32(sp+4);assert reference in initialized_locks;initialized_locks.remove(reference);finish(pop=4);return
 if name=='InitializeCriticalSectionAndSpinCount':
  reference,spin=read32(sp+4),read32(sp+8);assert spin==4000 and (0x14ae988<=reference<0x14ae988+36*24 or arena<=reference<arena+0x100000);u.mem_write(reference,bytes(24));initialized_locks.add(reference);finish(eax=1,pop=8);return
 if name in ['EnterCriticalSection','LeaveCriticalSection']:
  reference=read32(sp+4);assert reference in initialized_locks;finish(pop=4);return
 if name=='GetLastError':finish(eax=last_error);return
 if name=='SetLastError':last_error=read32(sp+4);finish(pop=4);return
 if name=='TlsGetValue':
  assert read32(sp+4)==5;last_error=0;finish(eax=heap+0xb000,pop=4);return
 if name=='CreateFileA':
  path,access,share,security,creation,flags,template=[read32(sp+i) for i in range(4,32,4)];target=root/Path(cbytes(path).decode('ascii'));key=str(target);windows_calls[-1].update({'path':key,'access':access,'creation':creation,'flags':flags});assert access in [0x80000000,0x40000000,0xc0000000] and creation in [1,2,3,4,5] and template==0
  exists=key in virtual_files or target.is_file()
  if (creation in [3,5] and not exists) or (creation==1 and exists):last_error=2 if not exists else 80;finish(eax=0xffffffff,pop=28);return
  data=virtual_files.get(key,target.read_bytes() if target.is_file() else b'')
  if creation in [1,2,5]:data=b''
  if access&0x40000000:virtual_files[key]=data
  handle=0x70000000+len(file_handles)+1;file_handles[handle]=[data,0];handle_files[handle]=(key,access);finish(eax=handle,pop=28);return
 if name=='ReadFile':
  handle,buffer,count,number,overlapped=[read32(sp+i) for i in range(4,24,4)];assert overlapped==0;data,offset=file_handles[handle];part=data[offset:offset+count]
  if part:u.mem_write(buffer,part)
  file_handles[handle][1]+=len(part)
  if number:write32(number,len(part))
  finish(eax=1,pop=20);return
 if name=='GetFileSize':
  handle,high=read32(sp+4),read32(sp+8)
  if high:write32(high,0)
  finish(eax=len(file_handles[handle][0]),pop=8);return
 if name=='SetFilePointer':
  handle,distance,high,method=[read32(sp+i) for i in range(4,20,4)];assert high==0;distance=distance if distance<0x80000000 else distance-0x100000000
  origin=[0,file_handles[handle][1],len(file_handles[handle][0])][method];position=origin+distance;assert position>=0;file_handles[handle][1]=position;finish(eax=position,pop=16);return
 if name=='CloseHandle':
  handle=read32(sp+4);assert handle in file_handles;del file_handles[handle];finish(eax=1,pop=4);return
 if name=='GetFileAttributesA':
  import ctypes
  path=cbytes(read32(sp+4));fn=ctypes.windll.kernel32.GetFileAttributesA;fn.argtypes=[ctypes.c_char_p];fn.restype=ctypes.c_uint32;attributes=16 if str(root/Path(path.decode('ascii'))) in virtual_directories else (32 if str(root/Path(path.decode('ascii'))) in virtual_files else fn(str(root/Path(path.decode('ascii'))).encode('ascii')));last_error=ctypes.windll.kernel32.GetLastError();print(json.dumps({'file_attributes_path':path.decode('ascii'),'attributes':attributes}));finish(eax=attributes,pop=4);return
 raise RuntimeError('unprovided import '+dll+'!'+name)
u.hook_add(unicorn.UC_HOOK_CODE,windows)
trace=[];native_diagnostics=[];call_trail=[]
def track(uc,address,size,user):
 if 0x400000<=address<0x400000+len(img):
  op=bytes(u.mem_read(address,5))
  if op[0]==0xe8:
   target=(address+5+int.from_bytes(op[1:5],'little',signed=True))&0xffffffff;call_trail.append([hex(address),hex(target)])
   if len(call_trail)>40:call_trail.pop(0)
 if address==0xcb0483:
  pointer=u.reg_read(UC_X86_REG_EDI);message=bytearray()
  for i in range(200):
   word=bytes(u.mem_read(pointer+i*2,2))
   if word==b'\0\0':break
   message.extend(word)
  native_diagnostics.append({'code':u.reg_read(UC_X86_REG_ESI),'message':message.decode('utf-16le',errors='replace')})
 trace.append(address)
 if len(trace)>24:trace.pop(0)
u.hook_add(unicorn.UC_HOOK_CODE,track)
poison=165;cursor=arena;fail=False;write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');u.mem_write(service,bytes([poison])*0x188);allocations.clear();freed.clear()
try:
 call(0xc9a0b9,0,[]);write32(0x2da5308,read32(0x1222ed0));assert call(0xcb0378,0,[])==1;assert call(0xcaff53,0,[])==0;result=call(0x72a3b0,service,[]);probe_result=({'result':hex(result),'allocations':allocations,'service_words':[[hex(service+i),hex(read32(service+i))] for i in range(0,0x188,4)],'freed':list(freed)})
except Exception as problem:probe_result=({'error':type(problem).__name__+': '+str(problem),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'trace':[hex(x) for x in trace],'allocations':allocations})

scalar_teardown=None
if 'error' not in probe_result:
 constructor_allocations=list(allocations);constructor_frees=list(freed);allocations.clear();freed.clear()
 try:
  scalar_result=call(0x72a530,service,[0]);assert scalar_result==service
  scalar_teardown={'passed':True,'flags':0,'result':hex(scalar_result),'allocations':list(allocations),'freed':list(freed),'caller_owned_service_words':[[hex(service+i),hex(read32(service+i))] for i in range(0,0x188,4)]}
 except Exception as problem:scalar_teardown={'passed':False,'error':type(problem).__name__+': '+str(problem),'pc':hex(u.reg_read(UC_X86_REG_EIP))}
 probe_result['allocations']=constructor_allocations;probe_result['freed']=constructor_frees

import ctypes
for actual in find_handles.values():
 fn=ctypes.windll.kernel32.FindClose;fn.argtypes=[ctypes.c_void_p];fn(actual)
find_handles.clear()
native_cfg=e.parent/'data/cfg/defaults/game.cfg';copied_cfg=root/'data/4.20/configuration/defaults/Game.cfg'
proof={'passed':'error' not in probe_result,'complete':False,'native_sha256':digest,'entry':'0x72a3b0','probe':probe_result,'native_scalar_teardown':scalar_teardown,'native_config_bytes_read_via_windows':any(c['function']=='ReadFile' for c in windows_calls),'windows_calls':windows_calls,'native_diagnostics':native_diagnostics,'call_trail':call_trail,'debug_messages_hex':debug_messages,'virtual_directories':sorted(virtual_directories),'virtual_files':{key:{'bytes':len(value),'sha256':hashlib.sha256(value).hexdigest()} for key,value in virtual_files.items()},'captured_std_output':{hex(h):{'bytes':len(v[0]),'sha256':hashlib.sha256(v[0]).hexdigest()} for h,v in file_handles.items() if h in std_types},'native_cfg_sha256':hashlib.sha256(native_cfg.read_bytes()).hexdigest(),'copied_cfg_sha256':hashlib.sha256(copied_cfg.read_bytes()).hexdigest(),'native_setting_names':{'bool':['Hacks','DisableFM'],'integer':['Reconnect','PingTimeForReconnectMessage']},'limits':['One actual72A3B0 constructor reaches normal return in the missing-RADS-DLL/no-optional-export fallback profile; whole Rust startup implementation remains open. No resource bytes were read through Windows ReadFile in this profile; native default getter paths are retained, not evidence of successful normal resource loading. Existing initialized zero3BC CRT thread record, TLSslot5 and allocator startup supplied. GetCurrentDirectory returns OpenLeague root; relative configuration file is provisioned byte-for-byte from the supplied native default configuration. GetFileAttributes uses real read-only Windows API against root-relative path.','Known Windows import ABI adapters only; module filename supplied as verified source executable path; native settings/default parsing and nested callback/performance/history helpers execute. Actual CB0378 static-lock initializer supplied with explicit zero opaque critical-section storage and normal-return Windows lock ABI boundaries; single-thread emulation only. Actual C9A0B9 encoded-default/dispatch initialization supplied with XOR pointer-encoding key and explicit no-optional-export resolver profile. Actual CAFF53 low-I/O initialization uses explicit no-inherited-handle startup info, virtual standard handles whose file type is measured on the real host, captured output buffers and in-memory writable files with no host file writes, canonical zeroed HeapAlloc storage and Win32 file-type boundaries. Remaining filesystem/configuration/CRT diagnostics and actual native startup globals must be investigated.']}
(root/'data/4.20/audio_announcer_whole_startup_preparation.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'scalar_teardown_passed':bool(scalar_teardown and scalar_teardown['passed']),'passed':proof['passed'],'error':probe_result.get('error'),'native_cfg_copy_matches':proof['native_cfg_sha256']==proof['copied_cfg_sha256']}))


