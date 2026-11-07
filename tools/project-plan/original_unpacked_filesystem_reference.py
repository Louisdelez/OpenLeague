"""Keep native physical provider/wrapper; adapt only read-only CRT FILE leaves."""
import hashlib,os,struct
from original_filesystem_bootstrap_reference import OriginalGameFilesystemBootstrap
from unicorn import UC_HOOK_MEM_READ
from unicorn.x86_const import *

class OriginalUnpackedFilesystem(OriginalGameFilesystemBootstrap):
 def __init__(self,*args):
  self.crt_files={};super().__init__(*args)
  self.u.mem_map(0x60000000,0x10000)
  def reject_struct_read(u,access,address,size,value,user):
   if address<0x60010000 and address+size>0x60000000:raise ValueError('Unqualified direct CRT FILE layout read')
  self.file_layout_guard=self.u.hook_add(UC_HOOK_MEM_READ,reject_struct_read)
 def start(self,locale=None):
  for f in self.crt_files.values():
   if not f['stream'].closed:f['stream'].close()
  result=super().start(locale);self.crt_files={};self.crt_next=0x60000100;self.crt_events=[]
  return result
 def file(self,p):
  if p not in self.crt_files or self.crt_files[p]['stream'].closed:raise ValueError('Unknown/closed readonly CRT FILE')
  return self.crt_files[p]
 def hook(self,uc,address,size,unused):
  if self.cache_mode:
   sp=self.u.reg_read(UC_X86_REG_ESP)
   if address==0xc99533:
    out,name,mode=self.rd(sp+4),self.cstring(self.rd(sp+8)),self.cstring(self.rd(sp+12))
    if mode not in ['r','rb']:raise ValueError('CRT write/create mode refused before host access')
    p=self.observed_path(name);self.w(out,0)
    if not p.exists():self.crt_events.append({'operation':'open_missing','logical':name,'physical':str(p),'mode':mode});self.leave(2);return
    if not p.is_file() or p.stat().st_size>65536:raise ValueError('Only bounded regular readonly config FILE leaves qualified')
    stream=p.open('rb');raw=stream.read();stream.seek(0)
    ptr=self.crt_next;self.crt_next+=128
    if self.crt_next>=0x60010000:stream.close();raise ValueError('Bounded virtual CRT FILE table exhausted')
    record={'stream':stream,'raw':raw,'position':0,'closed':False,'reads':[],'logical':name,'physical':str(p),'eof':False}
    self.crt_files[ptr]=record;self.stream=record
    self.opened.append({'logical':name,'physical':str(p),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest(),'mode':mode,'native_provider_and_wrapper_executed':True})
    self.w(out,ptr);self.crt_events.append({'operation':'open','FILE':hex(ptr),'logical':name,'bytes':len(raw)});self.leave(0);return
   if address==0xc9f6c9 and self.rd(sp+8) in [0,4]:
    name=self.cstring(self.rd(sp+4));mode=self.rd(sp+8);p=self.observed_path(name)
    exists=p.exists() and (mode==0 or os.access(p,os.R_OK))
    self.crt_events.append({'operation':'access','logical':name,'mode':mode,'exists':exists});self.leave(0 if exists else 0xffffffff);return
   if address==0xc9b375:
    ptr,buffer,mode,count=[self.rd(sp+i) for i in [4,8,12,16]];self.file(ptr)
    if buffer or mode!=0 or count!=0xfa00:raise ValueError('Unqualified native wrapper setvbuf request')
    self.crt_events.append({'operation':'setvbuf_policy_leaf','FILE':hex(ptr),'bytes':count,'FILE_layout_not_synthesized':True});self.leave(0);return
   if address==0xc9cd17:
    f=self.file(self.rd(sp+4));self.leave(f['stream'].tell());return
   if address==0xc9ce75:
    ptr,offset,origin=[self.rd(sp+i) for i in [4,8,12]];f=self.file(ptr);offset=struct.unpack('<i',struct.pack('<I',offset))[0]
    if origin not in [0,1,2]:raise ValueError('Unqualified CRT seek origin')
    target=offset+([0,f['stream'].tell(),len(f['raw'])][origin])
    if not 0<=target<0x80000000:raise ValueError('CRT seek outside declared bounds')
    f['stream'].seek(target);f['position']=target;f['eof']=False
    self.crt_events.append({'operation':'seek','FILE':hex(ptr),'position':target,'origin':origin});self.leave(0);return
   if address==0xc9973d:
    out,width,count,ptr=[self.rd(sp+i) for i in [4,8,12,16]];f=self.file(ptr);amount=width*count
    if not amount:self.leave(0);return
    if amount>65536:raise ValueError('CRT fread bound exceeded')
    start=f['stream'].tell();data=f['stream'].read(amount)
    if data!=f['raw'][start:start+amount]:raise ValueError('Source changed during readonly native wrapper reads')
    if data:self.u.mem_write(out,data)
    f['position']=f['stream'].tell();f['eof']=len(data)<amount
    record={'offset':start,'item_size':width,'count':count,'bytes':len(data)};f['reads'].append(record)
    self.crt_events.append({'operation':'read','FILE':hex(ptr),**record});self.leave(len(data)//width if width else 0);return
   if address==0xc99bab:
    f=self.file(self.rd(sp+4));self.leave(int(f['eof']));return
   if address==0xc99855:
    ptr=self.rd(sp+4);f=self.file(ptr);f['stream'].close();f['closed']=True
    self.read_streams.append({k:v for k,v in f.items() if k not in ['stream','raw']})
    self.crt_events.append({'operation':'close','FILE':hex(ptr),'final_position':f['position']});self.leave(0);return
   if address==0xc9acf0:raise ValueError('CRT fwrite refused before host access')
  super().hook(uc,address,size,unused)
 def close_all_read_handles(self):
  count=self.close_read_handles()
  for f in self.crt_files.values():
   if not f['stream'].closed:f['stream'].close();count+=1
  return count

 def evidence(self):
  result=super().evidence()
  result['original_game_filesystem_bootstrap_executed']=0x58f880 in self.case_visited
  result['original_physical_provider_wrapper_executed']=all(pc in self.case_visited for pc in [0x8b6280,0x8b5f90])
  result['provider_state']={'count':self.rd(0x2d6e4b0),'first':hex(self.rd(0x2d78da8)),'physical':hex(self.rd(0x2d78da4))}
  result['isolated_floating_state']={'mxcsr':hex(self.u.reg_read(UC_X86_REG_MXCSR)),'x87_control_word':hex(self.u.reg_read(UC_X86_REG_FPCW)),'historical_thread_overrides_qualified':False}
  result['limits']=['Provider construction/order/dedup now executes via original58f880; earlier inherited supplied-backend notes describe the parent experiment, not this qualified profile.',
   'OriginalDLL entry runs separately before a declared preloaded module adapter; actual PE exports are resolved and executed in Unicorn. Host loader, full historical process and successful archive mount are not qualified.',
   'File/section arguments for the skin corpus remain conditional prior selections. Outer/base/fallback package discovery/dispatch and historical overlays/generation remain open.',
   'CRT FILE calls expose bounded actual readonly host bytes; direct FILE layout access and every write/create/mutation are refused. Guest page padding, runtime/NLS/thread/FP state are explicit.']
  return result
