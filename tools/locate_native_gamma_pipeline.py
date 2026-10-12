from pathlib import Path
import sys,re,json,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');import pefile,capstone
r=Path('E:/OpenLeague');source=json.loads((r/'data/4.20/native_endgame_default_timing.json').read_text())['source'];raw=Path(source).read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;memory=pe.get_memory_mapped_image();md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
strings=[]
for match in re.finditer(rb'[\x20-\x7e]{4,180}\x00',memory):
 s=match.group()[:-1].decode()
 if 'gamma' not in s.lower():continue
 address=base+match.start();references=[];needle=address.to_bytes(4,'little')
 for section in pe.sections:
  if not section.Characteristics&0x20000000:continue
  code=section.get_data();pos=0
  while True:
   off=code.find(needle,pos)
   if off<0:break
   pos=off+1;start=max(0,off-70);pad=code[start:off].rfind(b'\xcc\xcc')
   if pad>=0:start+=pad+2
   instructions=[dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str) for i in md.disasm(code[start:off+55],base+section.VirtualAddress+start)]
   references.append(dict(address=hex(base+section.VirtualAddress+off),instructions=instructions))
 strings.append(dict(address=hex(address),text=s,references=references))
(r/'data/4.20/native_gamma_pipeline_candidates.json').write_text(json.dumps(dict(source=source,sha256=hashlib.sha256(raw).hexdigest(),complete=False,qualified=False,strings=strings),indent=2)+'\n',encoding='utf-8')
print(json.dumps([dict(address=x['address'],text=x['text'],references=[y['address'] for y in x['references']]) for x in strings]))
