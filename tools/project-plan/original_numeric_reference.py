"""Original numeric-conversion instructions under embedded initial CRT locale.

No replacement numeric parser. Only CRT thread-data acquisition is adapted;
the selected initial locale tables, parser, arithmetic and x87 return are native.
This does not establish a historical process's later locale/config overrides.
"""
import argparse,collections,hashlib,json,math,pathlib,struct,sys
BINARY_SHA='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
R=pathlib.Path('E:/OpenLeague')
sys.path.insert(0,str(R/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
class OriginalNumeric:
 def __init__(self,binary):
  binary=pathlib.Path(binary);raw=binary.read_bytes()
  if hashlib.sha256(raw).hexdigest()!=BINARY_SHA:raise ValueError('Original converter binary identity mismatch')
  pe=pefile.PE(data=raw);self.image=pe.get_memory_mapped_image();self.base=pe.OPTIONAL_HEADER.ImageBase
  self.code_ranges=[(self.base+s.VirtualAddress,self.base+s.VirtualAddress+max(s.Misc_VirtualSize,s.SizeOfRawData)) for s in pe.sections if s.Characteristics&0x20000000]
  if self.base!=0x400000:raise ValueError('Original converter image layout mismatch')
  self.binary=binary;self.u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);self.u.mem_map(self.base,(len(self.image)+4095)&~4095);self.u.mem_write(self.base,self.image)
  self.workspace=0x40000000;self.u.mem_map(self.workspace,0x50000);self.thread=self.workspace+0x10000;self.input=self.workspace+0x2000;self.output=self.workspace+0x4000;self.stack=self.workspace+0x40000;self.finish=self.workspace+0x45000;self.init=self.finish+0x100
  self.u.mem_write(self.finish,b'\xdd\x1d'+struct.pack('<I',self.output));self.u.mem_write(self.init,b'\xdb\xe3')
  self.locale=self.image_u32(0x122323c);self.multibyte=self.image_u32(0x1222dd4)
  if self.locale!=0x1223240 or self.multibyte!=0x1222bb0 or self.image_u32(self.locale+0x74)!=1:raise ValueError('Embedded initial CRT locale layout mismatch')
  self.visited=set();self.case_visited=set();self.provider_calls=[];self.recent=collections.deque(maxlen=20);self.u.hook_add(unicorn.UC_HOOK_CODE,self.hook)
 def image_u32(self,a):return struct.unpack_from('<I',self.image,a-self.base)[0]
 def w(self,a,v):self.u.mem_write(a,struct.pack('<I',v&0xffffffff))
 def rd(self,a):return struct.unpack('<I',self.u.mem_read(a,4))[0]
 def leave(self,value):
  sp=self.u.reg_read(UC_X86_REG_ESP);self.u.reg_write(UC_X86_REG_EAX,value);self.u.reg_write(UC_X86_REG_EIP,self.rd(sp));self.u.reg_write(UC_X86_REG_ESP,sp+4)
 def hook(self,uc,address,size,unused):
  self.recent.append(hex(address))
  if address==0xca9191:
   self.provider_calls.append({'address':hex(address),'adapter':'CRT thread-data acquisition','locale_pointer':hex(self.locale),'multibyte_pointer':hex(self.multibyte)})
   self.leave(self.thread);return
  if any(start<=address<stop for start,stop in self.code_ranges):self.visited.add(address);self.case_visited.add(address)
  elif not(self.finish<=address<self.finish+6 or self.init<=address<self.init+2):raise ValueError('Unqualified external/nonexecutable converter code '+hex(address))
 def convert(self,text):
  if not isinstance(text,str):raise ValueError('Original converter requires an explicit string')
  try:encoded=text.encode('ascii')
  except UnicodeEncodeError as e:raise ValueError('Non-ASCII conversion input not qualified') from e
  if b'\0' in encoded or len(encoded)>1023:raise ValueError('Embedded NUL or oversized numeric input refused')
  self.case_visited=set();self.provider_calls=[];self.u.mem_write(self.thread,bytes(0x200));self.w(self.thread+0x6c,self.locale);self.w(self.thread+0x68,self.multibyte)
  self.u.mem_write(self.input,encoded+b'\0');self.u.mem_write(self.output,b'\xff'*8)
  for reg in [UC_X86_REG_EAX,UC_X86_REG_EBX,UC_X86_REG_ECX,UC_X86_REG_EDX,UC_X86_REG_ESI,UC_X86_REG_EDI,UC_X86_REG_EBP]:self.u.reg_write(reg,0)
  self.w(self.stack,self.finish);self.w(self.stack+4,self.input);self.u.reg_write(UC_X86_REG_ESP,self.stack)
  self.u.emu_start(self.init,self.init+2,count=10);self.u.emu_start(0xc99987,self.finish+6,count=1000000)
  if self.u.reg_read(UC_X86_REG_EIP)!=self.finish+6:raise ValueError('Original numeric converter did not return within instruction bound')
  value=struct.unpack('<d',self.u.mem_read(self.output,8))[0]
  if not math.isfinite(value):raise ValueError('Original numeric result is nonfinite; comparison not qualified')
  if len(self.provider_calls)!=1 or self.rd(self.thread+0x70)!=0:raise ValueError('Original locale thread-state contract changed')
  return {'input':text,'value':value,'original_addresses_exercised':len(self.case_visited),'thread_provider_adapter_calls':list(self.provider_calls),'returned_double_hex':bytes(self.u.mem_read(self.output,8)).hex()}
 def evidence(self):
  return {'binary':{'path':str(self.binary),'sha256':BINARY_SHA},'original_entry':'0xc99987','original_inner_entry':'0xc998e9','initial_locale':{'pointer_global':'0x122323c','locale_pointer':hex(self.locale),'multibyte_global':'0x1222dd4','multibyte_pointer':hex(self.multibyte),'mb_cur_max':self.image_u32(self.locale+0x74)},
   'original_unique_addresses':len([a for a in self.visited if self.base<=a<self.base+len(self.image)]),
   'original_instructions_executed_in_isolated_memory':True,'historical_game_process_launched':False,
   'adapters':['CRT thread-data acquisition0xca9191 returns an isolated synthetic thread structure pointing at the unmodified initial locale/multibyte tables embedded in this exact PE.','x87 initialized with FNINIT; a separate FSTP capture stub stores the actual original function return. No Python numeric text parsing is used.'],
   'limits':['The historical effective thread locale after later initialization/overrides is not proved. This experiment qualifies the embedded initial default locale only.','No original config cache/overlay, complete game process, original server or current Karma gameplay is qualified.']}

def resolve_karma_numeric(row,source_sha,receipt):
 if row.get('family')!='champion_spell' or row.get('subject')!='Karma:0' or row.get('field') not in ['cooldown:2','cooldown:4']:return None
 if receipt.get('passed') is not True or receipt.get('converter',{}).get('binary',{}).get('sha256')!=BINARY_SHA or receipt['converter'].get('original_entry')!='0xc99987':return None
 if not receipt['converter'].get('original_instructions_executed_in_isolated_memory') or receipt['converter'].get('historical_game_process_launched') is not False:return None
 source=receipt.get('native_source',{})
 if source.get('sha256')!=source_sha or pathlib.PureWindowsPath(source.get('path',''))!=pathlib.PureWindowsPath(row['native_path']):return None
 rank=int(row['field'].rsplit(':',1)[1]);cases=[x for x in receipt.get('actual_karma_fields',[]) if x['field']=='Cooldown'+str(rank) and x['input']==row['native']]
 cooldowns=receipt.get('actual_rank_constructor',{}).get('cooldowns',[])
 if len(cases)!=1 or len(cooldowns)<rank or cases[0]['value']!=row['catalogue'] or cooldowns[rank-1]!=cases[0]['value']:return None
 return {'status':'resolved_original_numeric_initial_locale','selected':'Exact original numeric converter and original rank constructor store the catalogue value from this malformed native text under the embedded initial locale. Raw text retained.',
  'raw_native_text':row['native'],'value':cases[0]['value'],'binary_sha256':BINARY_SHA,'original_numeric_entry':'0xc99987','original_rank_fragment':['0x767a86','0x767c49'],
  'mechanical_adoption_qualified':False,'scope':'Original parser/arithmetic/default-locale tables exercised; only CRT thread-data acquisition and lookup/sprintf/scalar setup are adapted. Historical locale/config overrides and complete gameplay remain unqualified.'}

def verify_recorded_numeric_resolutions(document,root):
 from reference_inibin import read,hashkey
 expected=document['original_numeric_evidence'];path=pathlib.Path(root)/expected['path'];raw=path.read_bytes()
 if hashlib.sha256(raw).hexdigest()!=expected['sha256']:raise ValueError('Original numeric receipt identity changed')
 receipt=json.loads(raw);source=pathlib.Path(receipt['native_source']['path']);source_raw=source.read_bytes()
 if hashlib.sha256(source_raw).hexdigest()!=receipt['native_source']['sha256']:raise ValueError('Original Karma numeric source changed')
 values=read(source);verified=0
 for row in document['rows']:
  if row['resolution']['status']!='resolved_original_numeric_initial_locale':continue
  if row['native']!=values.get(hashkey('SpellData',row['native_key'])):raise ValueError('Native numeric text binding changed')
  actual=resolve_karma_numeric(row,receipt['native_source']['sha256'],receipt)
  if actual!={k:v for k,v in row['resolution'].items() if k!='evidence_source_ids'}:raise ValueError('Recorded original numeric resolution does not reproduce')
  verified+=1
 if verified!=document['resolution_counts'].get('resolved_original_numeric_initial_locale'):raise ValueError('Original numeric count changed')
 return {'verified':True,'verified_resolution_rows':verified,'remaining_open_numeric_rows':len(document['open_question_rows']),'historical_effective_locale_overrides_qualified':False,'gameplay_accepted':False}

def main():
 p=argparse.ArgumentParser();p.add_argument('--root',default=str(R));a=p.parse_args()
 try:r=verify_recorded_numeric_resolutions(json.loads((pathlib.Path(a.root)/'docs/fidelity_catalogue_comparison_4_20.json').read_bytes()),a.root)
 except (ValueError,OSError,KeyError) as e:print(json.dumps({'verified':False,'error':str(e)},ensure_ascii=False));return 1
 print(json.dumps(r,ensure_ascii=False,indent=2));return 0
if __name__=='__main__':raise SystemExit(main())
