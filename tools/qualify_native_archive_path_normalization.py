from pathlib import Path
import itertools,json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');exec(compile((r/'tools/qualify_native_config_cache_policy.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native archive path prerequisites','exec'))
source_ptr=0x40010010;output_ptr=0x40012010;destination=output_ptr;underwrites=[]
def original_hook(uc,a,size,user):
 assert 0x8b68a0<=a<0x8b68fc,hex(a);visited.add(a)
def write_hook(uc,access,address,size,value,user):
 if destination-4<=address<destination:underwrites.append(address-destination)
u.hook_add(unicorn.UC_HOOK_CODE,original_hook);u.hook_add(unicorn.UC_HOOK_MEM_WRITE,write_hook)
paths=[a+b for a,b in itertools.product([b'',b'DATA/',b'DATA\\',b'//server///',b'\\\\server\\\\\\',b'a/\\b\\/'],[b'',b'Game.cfg',b' Game.cfg',b'Game.cfg ',b'Game.cfg  ',b'  ',b'Game\0ignored'])]+[b'UPPER/Case',b'\\'*5+b'Game.cfg',b'/'*5+b'Game.cfg',b'\xff/File',b'a'*240]
cases=[]
for data,alias,previous in itertools.product(list(dict.fromkeys(paths)),[False,True],[0,32]):
 u.mem_write(source_ptr-4,b'\0'*1024);u.mem_write(output_ptr-4,b'\0'*1024);u.mem_write(source_ptr,data+b'\0');destination=source_ptr if alias else output_ptr;u.mem_write(destination-1,bytes([previous]));underwrites.clear();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,destination);u.reg_write(UC_X86_REG_EDX,source_ptr);u.emu_start(0x8b68a0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 raw_path=data.split(b'\0',1)[0];expected=bytearray();index=0
 while index<len(raw_path):
  byte=raw_path[index]
  if byte==47:expected.append(92)
  elif byte==92 and raw_path[index:index+2]==b'\\\\':expected.append(92);index+=1
  else:expected.append(byte)
  index+=1
 expected=bytes(expected).rstrip(b' ');actual=cbytes(destination);assert actual==expected,(data,actual,expected)
 assert bool(underwrites)==(not expected and previous==32)
 cases.append(dict(input=list(data),alias=alias,preceding_byte=previous,output=list(actual),writes_before_output=underwrites.copy()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b68a0',case_count=len(cases),native_addresses=len(visited),native_sha256=hashlib.sha256(raw).hexdigest(),cases=cases,adapters=['Original byte copy, forward-slash conversion, paired-backslash collapse and trailing-space trimming execute unmodified native instructions. Source/destination buffers, preceding byte and alias relationship supplied.'],limits=['Normalization only; archive dictionary/comparison/loading, input length/stack limits, filesystem and encoding interpretation remain open.','Empty/space-only output with preceding space writes before the destination; observed native boundary defect, not a safe supported path contract.','Case preserved; forward slashes each become backslashes, while backslash pairs collapse once. Generic cache lowercase/slash normalization is a different routine.'])
(r/'data/4.20/native_archive_path_normalization_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),cases_with_underwrite=sum(bool(c['writes_before_output']) for c in cases))))
