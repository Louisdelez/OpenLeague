from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'HUD registry prerequisites','exec'))
target=0x9a1336;pad=image.rfind(b'\xcc\xcc',target-base-0x1000,target-base);start=base+pad+2
while image[start-base]==0xcc:start+=1
key=None;rows=[];head=[]
for i in md.disasm(image[start-base:0x9a1a60-base],start):
 if len(head)<18:head.append(dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str))
 if i.mnemonic=='mov' and i.op_str.startswith('dword ptr [ebp - 8], 0x'):
  ptr=int(i.op_str.rsplit(' ',1)[1],16);offset=ptr-base
  if 0<=offset<len(image):key=(image[offset:offset+80].split(b'\0')[0].decode('ascii',errors='backslashreplace'),ptr,i.address)
 if key and i.mnemonic=='mov' and i.op_str.startswith('dword ptr [ebp - 4], 0x'):
  callback=int(i.op_str.rsplit(' ',1)[1],16)
  if 0x9a1e00<=callback<0x9a3080:rows.append(dict(name=key[0],string_address=hex(key[1]),key_instruction=hex(key[2]),callback=hex(callback),callback_instruction=hex(i.address)))
  key=None
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),qualified=False,complete=False,native_sha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),entry_candidate=hex(start),head=head,registration_candidates=rows,limits=['Static registration instruction pairs only; execution and actual map registration need qualification.'])
(r/'data/4.20/native_hud_property_registry_candidates.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(entry=hex(start),head=head,properties=rows)))
