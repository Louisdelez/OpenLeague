from pathlib import Path
import struct,json,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'HUD PE prerequisites','exec'))
rows=[]
for token in [b'KeepMaxScale',b'BaseOffset',b'Anchor',b'Rect',b'UV',b'Layer',b'AtlasTexture%d',b'NumAtlasTextures']:
 cursor=0
 while True:
  offset=image.find(token+b'\0',cursor)
  if offset<0:break
  cursor=offset+1
  if offset and image[offset-1]!=0:continue
  address=base+offset;references=[]
  for section in pe.sections:
   if not section.Characteristics&0x20000000:continue
   data=section.get_data();pos=0;needle=struct.pack('<I',address)
   while True:
    found=data.find(needle,pos)
    if found<0:break
    pos=found+1;begin=max(0,found-512);pad=data[begin:found].rfind(b'\xcc\xcc')
    if pad>=0:begin+=pad+2
    instructions=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(data[begin:min(len(data),found+60)],base+section.VirtualAddress+begin)]
    references.append(dict(reference=hex(base+section.VirtualAddress+found),candidate_start=hex(base+section.VirtualAddress+begin),instructions=instructions))
  rows.append(dict(token=token.decode('ascii'),string_address=hex(address),references=references))
out=dict(complete=False,qualified=False,native_sha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),tokens=rows,limits=['Candidate references only; instruction alignment/function starts must be verified before qualification.','No HUD parser/coordinate/rendering behavior is proved by this search.'])
(r/'data/4.20/native_hud_layout_parser_candidates.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps([dict(token=p['token'],references=[v['reference'] for v in p['references']]) for p in rows]))
