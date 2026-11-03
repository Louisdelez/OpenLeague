"""Original compiled INIBIN opening/parser/getters with a bounded byte stream."""
import pathlib,struct,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from original_skin_provider_reference import OriginalSkinProvider
from reference_inibin import hashkey
from unicorn.x86_const import *

class OriginalConfigReader(OriginalSkinProvider):
 def __init__(self,binary):
  self.config_mode=False;self.stream=None;self.opened=[]
  super().__init__(binary)
  self.thread_marker=self.work+0x54000;self.read_marker=self.work+0x54020;self.close_marker=self.work+0x54040
 def hook(self,uc,address,size,unused):
  if self.config_mode:
   sp=self.u.reg_read(UC_X86_REG_ESP)
   if address==self.thread_marker:self.leave(1);return
   if address==0xca9191:
    thread=self.work+0x1c00;self.u.mem_write(thread,bytes(0x200))
    self.w(thread+0x6c,self.rd(0x122323c));self.w(thread+0x68,self.rd(0x1222dd4))
    self.calls.append({'adapter':'CRT_thread_data_embedded_initial_locale','locale_pointer':hex(self.rd(0x122323c)),'multibyte_pointer':hex(self.rd(0x1222dd4))});self.leave(thread);return
   if address in [0x5642d0,0x5fa170]:
    self.calls.append({'adapter':'diagnostic_logging_boundary','entry':hex(address),'format':self.cstring(self.rd(sp+4)) if address==0x5642d0 else None});self.leave();return
   if address==0x8b4ef0:
    name,mode=self.cstring(self.rd(sp+4)),self.cstring(self.rd(sp+8))
    if mode!='rb':raise ValueError('Original parser requested non-read-only file access')
    self.opened.append({'requested_name':name,'mode':mode,'supplied':name in self.supplied_files})
    if name not in self.supplied_files:self.leave(0,8);return
    self.stream={'raw':self.supplied_files[name],'position':0,'closed':False,'reads':[]}
    file=self.work+0x1800;table=self.work+0x1900;self.w(file,table);self.w(table,self.close_marker);self.w(table+0x24,self.read_marker)
    self.leave(file,8);return
   if address==self.read_marker:
    if self.u.reg_read(UC_X86_REG_ECX)!=self.work+0x1800 or self.stream is None or self.stream['closed']:raise ValueError('Unqualified compiled stream identity/lifetime')
    out,item_size,count=[self.rd(sp+i) for i in [4,8,12]];amount=item_size*count;start=self.stream['position']
    if amount>0x10000 or start+amount>len(self.stream['raw']):raise ValueError('Truncated compiled reference stream refused at original read')
    if amount:self.u.mem_write(out,self.stream['raw'][start:start+amount])
    self.stream['position']+=amount;self.stream['reads'].append({'offset':start,'item_size':item_size,'count':count,'bytes':amount});self.leave(count,12);return
   if address==self.close_marker:
    if self.stream is None or self.stream['closed']:raise ValueError('Invalid compiled stream close')
    self.stream['closed']=True;self.leave(self.work+0x1800,4);return
  super().hook(uc,address,size,unused)
 def parse(self,logical_name,physical_path):
  physical=pathlib.Path(physical_path);raw=physical.read_bytes()
  if not isinstance(logical_name,str) or not logical_name or not logical_name.isascii() or '\0' in logical_name or len(logical_name)>512:raise ValueError('Invalid explicit logical config path')
  if len(raw)>0x10000:raise ValueError('Oversized compiled reference input refused')
  self.reset();self.node_heap=self.work+0x6000;self.allowed=list(self.original_ranges)
  self.stream=None;self.opened=[];self.supplied_files={logical_name+'bin':raw}
  self.native_registration_mode=True;self.config_mode=True
  self.w(0xfa4378,self.thread_marker);self.w(0x2d78db4,self.work+0x1a00)
  obj=self.work+0x4000;self.u.mem_write(obj,bytes(0x180));self.assign(obj+0x24,logical_name);self.assign(obj+0x5d,'')
  self.obj=obj
  try:
   self.invoke(0x8b9f20,[0],obj+0x7c)
   name=self.work+0x3800;self.u.mem_write(name,logical_name.encode('ascii')+b'\0')
   result=bool(self.invoke(0x8b0380,[name],obj)&255)
   # Original caller's post-parse byte store. The remaining constructor/cache
   # is not executed; EDI/AL are the explicit boundary from this parser result.
   self.u.reg_write(UC_X86_REG_EDI,obj);self.u.reg_write(UC_X86_REG_EAX,int(result))
   self.u.emu_start(0x8ad901,0x8ad907,count=10)
   if not result:raise ValueError('Original compiled parser refused source')
   if self.stream is None or not self.stream['closed'] or self.stream['position']!=len(raw):raise ValueError('Original compiled parser did not consume/close complete source')
   return {'passed':True,'logical_name':logical_name,'physical_path':str(physical),'bytes':len(raw),
    'opened':list(self.opened),'reads':list(self.stream['reads']),'bytes_consumed':self.stream['position'],
    'original_parser_executed':True,'original_host_file_provider_executed':False,
    'original_addresses_exercised':len(self.case_visited)}
  except BaseException:
   self.config_mode=False;self.native_registration_mode=False;raise
 def field_hash(self,section,field):
  if any(not isinstance(x,str) or not x or not x.isascii() or '\0' in x or len(x)>100 for x in [section,field]):raise ValueError('Invalid explicit section/field')
  a,b=self.work+0x3000,self.work+0x3200;self.u.mem_write(a,section.encode()+b'\0');self.u.mem_write(b,field.encode()+b'\0')
  actual=self.invoke(0x8e51a0,[b],a)
  if actual!=int(hashkey(section,field)):raise ValueError('Original section/field hash differs from maintained reader')
  return actual
 def string_field(self,section,field):
  if not self.config_mode or self.stream is None or not self.stream['closed']:raise ValueError('Parse original compiled input before getters')
  key=self.field_hash(section,field);out=self.work+0x3500;self.assign(out,'')
  found=bool(self.invoke(0x8af290,[key,out],self.obj)&255)
  return {'section':section,'field':field,'hash':key,'found':found,'value':self.string(out) if found else None,'original_typed_getter_executed':True}
 def float_field(self,section,field):
  if not self.config_mode or self.stream is None or not self.stream['closed']:raise ValueError('Parse original compiled input before getters')
  key=self.field_hash(section,field);out=self.work+0x3600;self.u.mem_write(out,b'\xff'*4)
  found=bool(self.invoke(0x8af470,[key,out],self.obj)&255)
  return {'section':section,'field':field,'hash':key,'found':found,'value':struct.unpack('<f',self.u.mem_read(out,4))[0] if found else None,
          'float32_hex':bytes(self.u.mem_read(out,4)).hex() if found else None,'original_typed_getter_executed':True}
 def integer_field(self,section,field):
  if not self.config_mode or self.stream is None or not self.stream['closed']:raise ValueError('Parse original compiled input before getters')
  key=self.field_hash(section,field);out=self.work+0x3600;self.u.mem_write(out,b'\xff'*8)
  found=bool(self.invoke(0x8af330,[key,out],self.obj)&255)
  return {'section':section,'field':field,'hash':key,'found':found,'value':struct.unpack('<q',self.u.mem_read(out,8))[0] if found else None,'original_typed_getter_executed':True}
 def identity_field(self,section,field='ChampionSkinID'):
  text=self.string_field(section,field)
  if text['found']:return dict(text,storage='string')
  return dict(self.integer_field(section,field),storage='integer')
 def numeric_field(self,section,field):
  if not self.config_mode or self.stream is None or not self.stream['closed']:raise ValueError('Parse original compiled input before getters')
  key=self.field_hash(section,field);out=self.work+0x3600;self.u.mem_write(out,b'\xff'*4)
  found=bool(self.invoke(0x8ae180,[key,out],self.obj)&255)
  return {'section':section,'field':field,'hash':key,'found':found,'value':struct.unpack('<f',self.u.mem_read(out,4))[0] if found else None,
          'float32_hex':bytes(self.u.mem_read(out,4)).hex() if found else None,'original_general_numeric_getter_executed':True}
 def scalar_lookup(self,section,field,default):
  if not self.config_mode or self.stream is None or not self.stream['closed']:raise ValueError('Parse original compiled input before scalar lookup')
  key=self.field_hash(section,field);out=self.work+0x3600;self.u.mem_write(out,b'\xff'*4);default_bits=struct.unpack('<I',struct.pack('<f',float(default)))[0]
  found=bool(self.invoke(0x8afb10,[out,0,0,key,default_bits],self.obj)&255)
  return {'section':section,'field':field,'hash':key,'found':found,'value':struct.unpack('<f',self.u.mem_read(out,4))[0],
          'float32_hex':bytes(self.u.mem_read(out,4)).hex(),'original_scalar_lookup_default':float(default),'original_scalar_lookup_executed':True}
 def evidence(self):
  d=super().evidence();d.update(original_compiled_parser_executed=0x8b0380 in self.visited,
   original_typed_string_float_getters_executed=all(x in self.visited for x in [0x8af290,0x8af470]),
   original_section_field_hash_executed=0x8e51a0 in self.visited,original_config_cache_manager_executed=False,
   original_full_config_object_constructor_executed=False,original_host_file_provider_executed=False)
  d['native_compiled_entries']={'open_append_bin_and_parse':'0x8b0380','typed_string':'0x8af290','typed_float':'0x8af470','typed_integer':'0x8af330','general_numeric':'0x8ae180','scalar_lookup_default':'0x8afb10','post_parse_valid_flag_store':'0x8ad901..0x8ad907','section_field_hash':'0x8e51a0','key_vectors_initialize':'0x8b9f20'}
  d['isolated_floating_context']={'mxcsr':hex(self.u.reg_read(UC_X86_REG_MXCSR)),'x87_control_word':hex(self.u.reg_read(UC_X86_REG_FPCW)),'initialization':'FNINIT; isolated emulator default SIMD context','historical_thread_overrides_qualified':False}
  d['adapters']+=['FileOpen0x8b4ef0 is read-only and accepts exactly the logical path with the original appended bin suffix. Virtual Read/Close consume the actual supplied INIBIN bytes, refusing reads beyond EOF; no Python decoder populates native keys/values.',
    'GetCurrentThreadId returns a fixed isolated thread identity. Diagnostic logging is captured without OS/UI output. Native vector allocation and raw byte copy use the documented arena/copy boundaries.']
  d['limits']+=['The original cache manager/defaults/override publication, actual host file-provider bootstrap and complete historical process are not executed. Typed getters preserve storage kind; general numeric conversion, if exercised for strings, uses the original embedded initial CRT locale with explicit isolated thread-data acquisition, not a proved historical later locale.']
  return d
