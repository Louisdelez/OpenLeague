from pathlib import Path
import sys,json,struct,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');source=json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8-sig'));raw=Path(source['source']).read_bytes();assert hashlib.sha256(raw).hexdigest()==source['sha256']
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);image=pe.get_memory_mapped_image();rows=[]
for sec in pe.sections:
 if not sec.Characteristics&0x20000000:continue
 data=sec.get_data()
 for register in [250,251]:
  pattern=b'\x68'+struct.pack('<I',register);cursor=0
  while True:
   at=data.find(pattern,cursor)
   if at<0:break
   cursor=at+5;va=base+sec.VirtualAddress+at
   # Start at exact candidate instruction. Prior raw bytes separately retained.
   instructions=[{'address':hex(i.address),'text':i.mnemonic+' '+i.op_str} for i in md.disasm(image[va-base:va-base+110],va)]
   rows.append({'register_candidate':register,'va':hex(va),'prior_bytes':image[va-base-40:va-base].hex(),'instructions':instructions})
proof={'complete':False,'native_sha256':source['sha256'],'candidates':rows,'limits':['Immediate push values are candidates only, not qualified shader-register uploads; function boundaries and call targets must be inspected.']}
(r/'docs/fow_register_upload_discovery.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
for row in rows:
 print(row['register_candidate'],row['va'])
 for i in row['instructions'][:14]:print(i['address'],i['text'])
