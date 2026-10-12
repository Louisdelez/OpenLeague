from pathlib import Path
import sys,struct,json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'native PE prerequisites','exec'))
candidates=[]
for token in [b'.dds\0',b'.tga\0']:
 start=0
 while True:
  p=image.find(token,start)
  if p<0:break
  start=p+1
  if p and image[p-1]!=0:continue
  address=base+p;refs=[]
  for section in pe.sections:
   if not section.Characteristics&0x20000000:continue
   code=section.get_data();cursor=0;needle=struct.pack('<I',address)
   while True:
    off=code.find(needle,cursor)
    if off<0:break
    cursor=off+1;lo=max(0,off-75);hi=min(len(code),off+50)
    rows=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(code[lo:hi],base+section.VirtualAddress+lo)]
    refs.append(dict(reference=hex(base+section.VirtualAddress+off),instructions=rows))
  candidates.append(dict(extension=token[:-1].decode('ascii'),string_address=hex(address),references=refs))
out=dict(complete=False,qualified=False,native_sha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),candidates=candidates,limits=['Literal/address candidates only; disassembly may begin mid-instruction. No extension routing behavior is proved.'])
(r/'data/4.20/native_texture_extension_candidates.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print(json.dumps([dict(extension=c['extension'],address=c['string_address'],references=[p['reference'] for p in c['references']]) for c in candidates]))
