from pathlib import Path
import sys,json,hashlib,shutil
from datetime import datetime,timezone
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
path=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');raw=path.read_bytes();p=pefile.PE(data=raw);img=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase;m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);m.detail=True;ins=[]
for i in m.disasm(img[0x910eb0-base:0x919000-base],0x910eb0):
 ins.append(i)
 if i.mnemonic=='ret':break
assert ins[-1].mnemonic=='ret';rows=[]
for index,i in enumerate(ins):
 if i.mnemonic!='push' or not i.operands or i.operands[0].type!=capstone.x86.X86_OP_IMM:continue
 addr=i.operands[0].imm
 if not base<=addr<base+len(img):continue
 end=img.find(b'\0',addr-base);text=img[addr-base:end]
 if 0<len(text)<80 and all(32<=c<127 for c in text):
  try:s=text.decode('ascii')
  except Exception:continue
  if s.startswith(('p-','e-','Particle','Emitter','single','rendermode','field','fluid')):rows.append({'field':s,'string_address':hex(addr),'reference':hex(i.address),'instructions':[{'address':hex(v.address),'mnemonic':v.mnemonic,'operands':v.op_str,'bytes':v.bytes.hex()} for v in ins[max(0,index-5):index+20]]})
proof={'updated_utc':datetime.now(timezone.utc).isoformat(),'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x910eb0','last_instruction':hex(ins[-1].address),'string_references':rows,'limits':['Original field-name references and nearby reader instructions recovered statically. Full field-reader execution and curve semantics remain unqualified.']};(r/'docs/native_complex_field_readers.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'fields':len(rows),'end':hex(ins[-1].address),'life_rate_color':[(v['field'],v['reference']) for v in rows if any(k in v['field'] for k in ('life','rate','rgba','scale','linger'))]}))
for row in rows:
 if row['field'] in ('p-life','e-life','e-rate','p-xrgba','p-scale','single-particle'):
  print(row['field']);print('\n'.join(v['address']+' '+v['mnemonic']+' '+v['operands'] for v in row['instructions']))
