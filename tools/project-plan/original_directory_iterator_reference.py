"""Original directory iterator and scans over declared readonly Windows leaves.

This is a reference experiment. The one-context outer alias container, selected
character/skin and DATA root are explicit inputs, not a historical package build.
"""
import ctypes,hashlib,pathlib,re,struct
from original_unpacked_filesystem_reference import OriginalUnpackedFilesystem
from unicorn.x86_const import *

class OriginalPhysicalDirectoryScanner(OriginalUnpackedFilesystem):
 def __init__(self,*args):
  self.native_iterator_mode=False
  super().__init__(*args)
 def start(self,locale=None):
  for item in getattr(self,"game_find_iats",[]):self.dll_import_markers.pop(int(item["marker"],16))
  result=super().start(locale);self.game_find_iats=[];self.native_iterator_mode=False
  wanted={"FindFirstFileA","FindFirstFileExA","FindNextFileA","FindClose"}
  for lib in self.pe.DIRECTORY_ENTRY_IMPORT:
   for item in lib.imports:
    name=item.name.decode() if item.name else ""
    if name not in wanted:continue
    marker=self.work+0x5e400+16*len(self.game_find_iats)
    assert marker not in self.dll_import_markers and marker not in self.bootstrap_imports
    self.dll_import_markers[marker]=(lib.dll.decode(),name,None)
    self.w(item.address,marker);self.game_find_iats.append({"name":name,"iat":hex(item.address),"marker":hex(marker)})
  if {x["name"] for x in self.game_find_iats}!=wanted:raise ValueError("Exact game readonly find import set required")
  return result
 def hook(self,u,address,size,unused):
  if self.native_iterator_mode and address==0x8b4830:
   self.visited.add(address);self.case_visited.add(address)
   return
  if self.cache_mode and address in self.dll_import_markers:
   lib,name,_=self.dll_import_markers[address];sp=self.u.reg_read(UC_X86_REG_ESP)
   if name=="FindFirstFileExA" and self.rd(sp+16)==1:
    logical=self.cstring(self.rd(sp+4))
    level,out,search,filter_ptr,flags=[self.rd(sp+i) for i in [8,12,16,20,24]]
    p=pathlib.PureWindowsPath(logical);pattern=p.name
    if not re.fullmatch("[A-Za-z0-9_.*? -]{1,260}",pattern) or level not in [0,1] or search!=1 or filter_ptr or flags&~2:raise ValueError("Unqualified readonly directory-hint request")
    directory=self.observed_path(str(p.parent));full=str(directory/pattern);buffer=ctypes.create_string_buffer(320)
    host=self.find_kernel.FindFirstFileExA(full.encode("ascii"),level,buffer,search,None,flags)
    self.dll_calls.append({"import":name,"library":lib,"return_site":hex(self.rd(sp)),"directory_search_hint_admitted":True,"actual_host_API_used":True})
    self.dll_file_operations.append({"operation":"find_first","pattern":full,"info_level":level,"search":search,"flags":flags,"current_host_observation":True,"filter_is_advisory_no_Python_filtering":True})
    if host==ctypes.c_void_p(-1).value:
     self.dll_last_error=ctypes.get_last_error();self.leave(0xffffffff,24);return
    if struct.unpack_from("<I",buffer.raw)[0]&0x400:
     self.find_kernel.FindClose(host);raise ValueError("Directory-search reparse entry refused")
    h=self.next_handle;self.next_handle+=16
    self.dll_handles[h]={"kind":"find","host":host,"wide":False,"entries":1,"pattern":full}
    self.u.mem_write(out,buffer.raw)
    self.dll_file_operations.append({"operation":"find_entry","handle":hex(h),"bytes":320,"sha256":hashlib.sha256(buffer.raw).hexdigest()})
    self.dll_last_error=0;self.leave(h,24);return
  super().hook(u,address,size,unused)
 def prepare_native_alias_container(self):
  # This one-context outer container is still a declared input. Do not claim
  # the full historical package constructor from native scans into this map.
  self.profiles=[{"context":"reference-DATA","local":{},"base":{}}]
  self.configure()
  for section in self.dll_pe.sections:
   if section.Characteristics&0x20000000:
    self.allowed.append((self.dll_base+section.VirtualAddress,self.dll_base+section.VirtualAddress+section.Misc_VirtualSize))
  head=self.rd(self.work+0x1008);self.inner=self.rd(head+4)+0x28
  self.native_registration_mode=True
  self.w(self.inner,self.invoke(0x6542a0));self.w(self.inner+4,0)
  self.scan_mode=True;self.native_iterator_mode=True;self.enumerations=[]
 def scan_files(self,directory,pattern="*"):
  if not isinstance(directory,str) or not re.fullmatch(r"DATA/[A-Za-z0-9_/]+",directory) or ".." in directory or len(directory)>250:raise ValueError("Explicit bounded DATA scan required")
  if pattern!="*" and not re.fullmatch(r"Skin[0-9]{2}\*",pattern):raise ValueError("Unsupported native scan wildcard")
  self.observed_path(directory)
  self.assign(self.work+0x3000,directory);self.assign(self.work+0x3500,pattern)
  self.invoke(0x905620,[self.inner],self.work+0x3000,self.work+0x3500)
  result=self.finish_scan("native_iterator_files")
  result["original_host_iterator_factory_executed"]=0x8b4830 in self.case_visited
  result["outer_container_still_declared_input"]=True
  return result
 def discover_non_base(self,champion,number):
  self.inputs(champion,number)
  if number==0:raise ValueError("Original non-base scanner requires skin1..99")
  self.prepare_native_alias_container()
  self.assign(self.work+0x3000,f"{number:02}")
  self.assign(self.work+0x3500,"DATA/Characters/"+champion)
  self.invoke(0x902ad0,[0,self.inner],self.work+0x3000,self.work+0x3500)
  result=self.finish_scan("native_non_base_skin")
  result["original_host_iterator_factory_executed"]=0x8b4830 in self.case_visited
  result["original_physical_iterator_factory_executed"]=0x8b9e30 in self.case_visited
  result["outer_package_context_still_declared_input"]=True
  return result
 def open_iterator(self,query,mode=0):
  if isinstance(mode,bool) or mode not in [0,4]:raise ValueError("Only iterator modes0/4 are qualified")
  if not isinstance(query,str) or not query.isascii() or "\0" in query or not 0<len(query)<300:raise ValueError("Bounded ASCII query required")
  self.observed_path(str(pathlib.PureWindowsPath(query).parent))
  self.u.mem_write(self.work+0x3100,query.encode("ascii")+b"\0")
  self.invoke(0x8b4830,[mode],ecx=self.work+0x3500,edx=self.work+0x3100)
  obj=self.rd(self.work+0x3500)
  if obj==self.iterator:raise ValueError("Supplied virtual iterator must not be used")
  return obj,self.rd(obj)
 def collect_iterator(self,obj,table,limit=512):
  if not isinstance(limit,int) or not 1<=limit<=8192:raise ValueError("Bounded native iterator observation required")
  result=[]
  for i in range(limit):
   if not self.invoke(self.rd(table),ecx=obj):break
   name=self.cstring(self.invoke(self.rd(table+8),ecx=obj))
   is_directory=bool(self.invoke(self.rd(table+12),ecx=obj)&255)
   result.append({"name":name,"is_directory":is_directory})
   self.invoke(self.rd(table+4),ecx=obj)
  else:raise ValueError("Native iterator observation bound exceeded")
  return result
 def evidence(self):
  d=super().evidence()
  d["parent_profile_notes"]={"adapters":d["adapters"],"scope":"Parent experiments retain their earlier supplied-iterator and package/discovery caveats."}
  d["adapters"]=["Original game and mappedDLL/bootstrap from the preserved V13 helper; no host originalDLL load.",
   "Only exact game FindFirst(A/ExA)/FindNextA/FindClose imports expose real readonly currentWindows records, with bounds/reparse/root guards. Native factory and virtual methods execute.",
   "FindFirstFileExA directory hint1 is passed to the real API unchanged; no Python filtering substitutes for original native attribute interpretation.",
   "One-context outer alias container and character/skin/DATA path inputs remain supplied. The original sound path literal formatter and inherited allocation/SSO/thread/FP/runtime leaves remain explicit."]
  d["native_directory_entries"]={"factory":"0x8b4830","physical_provider":"0x8b6380","physical_iterator_factory":"0x8b9e30","files":"0x905620","directories":"0x905a00","non_base":"0x902ad0"}
  d["original_host_iterator_factory_executed"]=0x8b4830 in self.case_visited
  d["original_physical_iterator_factory_executed"]=0x8b9e30 in self.case_visited
  d["game_find_IATs"]=self.game_find_iats
  d["limits"]=["CurrentWindows directory record metadata/order and declared runtime/NLS/FP are not historicalOS state.",
   "Outer package/base/legacy/fallback/overlay construction and actual current Rust non-base dispatch remain open.",
   "Native scan/alias/query/cache/getter components do not establish complete skins,render,audio,gameplay or human acceptance."]
  return d
