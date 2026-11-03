"""Original game filesystem bootstrap under explicit mapped-DLL loader leaves."""
import hashlib,pathlib,struct
from original_rads_runtime_reference import OriginalMappedRadsRuntime
from unicorn.x86_const import *

class OriginalGameFilesystemBootstrap(OriginalMappedRadsRuntime):
 def __init__(self,*args):
  self.bootstrap_active=False
  super().__init__(*args)
 def start(self,locale=None):
  result=super().start(locale)
  self.bootstrap_events=[];self.bootstrap_imports={};self.bootstrap_active=True;self.pending_original_rads_calls=[]
  wanted={'LoadLibraryA','GetProcAddress','FreeLibrary','GetLastError'}
  for lib in self.pe.DIRECTORY_ENTRY_IMPORT:
   for item in lib.imports:
    name=item.name.decode() if item.name else ''
    if name not in wanted:continue
    marker=self.work+0x5f000+16*len(self.bootstrap_imports)
    self.bootstrap_imports[marker]=name;self.w(item.address,marker)
  if set(self.bootstrap_imports.values())!=wanted:raise ValueError('Exact game loader import set absent')
  self.export_addresses={e.name.decode():self.dll_base+e.address for e in self.dll_pe.DIRECTORY_ENTRY_EXPORT.symbols if e.name and not e.forwarder}
  # Remove the V10 supplied provider list and fake initialization sentinel.
  # The upcoming original58f880 body must construct/order/deduplicate providers.
  self.u.mem_write(0x2d6e4a0,bytes(16));self.w(0x2d6e4b0,0);self.w(0x2d78db4,0)
  self.w(0x2d78da4,0);self.w(0x2d78da8,0)
  return result
 def hook(self,uc,address,size,unused):
  if self.bootstrap_active:
   sp=self.u.reg_read(UC_X86_REG_ESP)
   if self.pending_original_rads_calls and address==self.pending_original_rads_calls[-1]['return_site']:
    call=self.pending_original_rads_calls.pop()
    self.bootstrap_events.append({'original_export_return':'RadsInitialize','return_site':hex(address),'return_value':hex(self.u.reg_read(UC_X86_REG_EAX)),'stack_after':hex(sp),'original_call':call})
   if address==self.dll_base+0x3e3d0:
    self.pending_original_rads_calls.append({'return_site':self.rd(sp),'stack_before':hex(sp),'argument_words':[self.rd(sp+i) for i in [4,8,12,16]]})
  if self.bootstrap_active and address in self.bootstrap_imports:
   name=self.bootstrap_imports[address];sp=self.u.reg_read(UC_X86_REG_ESP)
   if name=='LoadLibraryA':
    logical=self.cstring(self.rd(sp+4));path=self.observed_path(logical)
    if path.resolve()!=self.dll_path.resolve() or hashlib.sha256(path.read_bytes()).hexdigest()!='60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521':raise ValueError('Unqualified game DLL load target')
    if not self.dll_attached:raise ValueError('Mapped DLL original entry must be separately exercised before loader-adapter admission')
    self.bootstrap_events.append({'adapter':'mapped_pre_attached_original_DLL_module','logical':logical,'source':str(path),'returned_module':hex(self.dll_base),'host_original_DLL_loaded':False})
    self.leave(self.dll_base,4);return
   if name=='GetProcAddress':
    module,pointer=self.rd(sp+4),self.rd(sp+8)
    if module!=self.dll_base or pointer<65536:raise ValueError('Unqualified module or ordinal export request')
    export=self.cstring(pointer);value=self.export_addresses.get(export,0)
    self.bootstrap_events.append({'adapter':'actual_PE_export_table_lookup','export':export,'returned_address':hex(value)})
    self.leave(value,8);return
   if name=='FreeLibrary':
    if self.rd(sp+4)!=self.dll_base:raise ValueError('Unqualified module release')
    # Model one game-acquired reference, with the declared preload retained.
    self.bootstrap_events.append({'adapter':'release_game_module_reference_preload_retained','host_unload':False})
    self.leave(1,4);return
   if name=='GetLastError':self.leave(self.dll_last_error);return
  super().hook(uc,address,size,unused)
 def bootstrap(self):
  result=self.invoke(0x58f880)
  return {'return_eax':hex(result),'provider_count':self.rd(0x2d6e4b0),
   'provider_slots':[{'object':hex(self.rd(0x2d6e4a0+4*i)),'vtable':hex(self.rd(self.rd(0x2d6e4a0+4*i))) if self.rd(0x2d6e4a0+4*i) else None} for i in range(4)],
   'native_provider_globals':{'first':hex(self.rd(0x2d78da8)),'physical':hex(self.rd(0x2d78da4))},
   'RADS_manager':hex(self.rd(0x1019846c)),'game_module':hex(self.rd(0x2d7118c)),
   'game_RADS_initialized_flag':self.rd(0x2d778b8)}
