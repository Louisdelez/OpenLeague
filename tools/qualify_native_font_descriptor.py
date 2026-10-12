from pathlib import Path
import json,datetime,hashlib,itertools,shutil,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text().split('\nu.hook_add(')[0],'native descriptor prerequisites','exec'))
left=vector+0x6000;right=vector+0x7000;left_name=vector+0x8000;right_name=vector+0x9000
u.hook_add(unicorn.UC_HOOK_CODE,scanner_hook);assert read(0x14ae870)==0
def setup(address,name_address,name,fields,heap):
 u.mem_write(address,b'\xa5'*0x24);data=struct.pack('<'+'H'*(len(name)+1),*name,0)
 if heap:w(address,name_address);u.mem_write(name_address,data)
 else:u.mem_write(address,data)
 w(address+0x10,len(name));w(address+0x14,16 if heap else 7)
 for offset,value in zip([0x18,0x1c,0x20],fields):w(address+offset,value)
names=[[],[65],[97],list('Gill Sans MT Pro Medium'.encode()),list('GILL SANS MT PRO MEDIUM'.encode()),[0xc9],[0xe9],[0xd83d,0xde00],[0]]
fields=[(0,0,0),(16,0,0x10),(16,0,0x14),(17,0,0x10),(16,1,0x10),(0xffffffff,0,0x10)]
cases=[]
for a,b in itertools.product(names,names):
 for fa,fb in [(fields[1],fields[1])]+[(fields[1],f) for f in fields if f!=fields[1]]+[(f,fields[1]) for f in fields if f!=fields[1]]:
  for heap_left,heap_right in [(True,True)]+([(False,False),(False,True),(True,False)] if len(a)<=7 and len(b)<=7 else []):
   setup(left,left_name,a,fa,heap_left);setup(right,right_name,b,fb,heap_right);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,left);u.reg_write(UC_X86_REG_EDX,right)
   u.emu_start(0x8c0ed0,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
   result=u.reg_read(UC_X86_REG_EAX);result=result if result<0x80000000 else result-0x100000000;assert result in [-1,0,1]
   cases.append(dict(left_name=a,right_name=b,left_fields=fa,right_fields=fb,left_heap=heap_left,right_heap=heap_right,result=result))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x8c0ed0',string_comparison='0xc9e8a7',crt_locale_global=0,case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original descriptor comparator and wide character CRT comparison execute for supplied inline/heap UTF16 strings and unsigned size/extra/flags fields.','Default CRT locale branch qualified; alternative locale tables/producer not qualified. ASCII A-Z folded, other UTF16 code units unchanged in this branch.','Descriptor family empty-length branch is distinct from a nonempty string starting with NUL; no Unicode normalization invented.','Does not qualify native cache allocation/refcount/device lifetime or GPU glyph rasterization.'])
(r/'data/4.20/native_font_descriptor_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
