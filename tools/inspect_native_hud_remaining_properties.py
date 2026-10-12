from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'HUD remaining callbacks prerequisites','exec'))
ranges=[('LeftAnchor',0x9a2070,0x9a2180),('Color',0x9a2370,0x9a23f0),('PerPixelUVsX',0x9a2500,0x9a2590),('MinUV',0x9a2720,0x9a29d0),('EffectParams0',0x9a2a40,0x9a2ac0),('EffectColor0',0x9a2ac0,0x9a2b70),('EffectColor1',0x9a2b70,0x9a2c20),('Align',0x9a2df0,0x9a2f00)]
rows=[];formats={}
for name,start,end in ranges:
 instructions=[]
 for i in md.disasm(image[start-base:end-base],start):
  instructions.append(dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str))
  if i.mnemonic=='push' and i.op_str.startswith('0x'):
   ptr=int(i.op_str,16)
   if 0x1000000<=ptr<base+len(image):
    data=image[ptr-base:ptr-base+180].split(b'\0')[0]
    if data and all(c in [9,10,13] or 32<=c<=126 for c in data):formats[hex(ptr)]=data.decode('ascii')
 rows.append(dict(property=name,entry=hex(start),instructions=instructions))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),qualified=False,complete=False,native_sha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),callbacks=rows,literals=formats,limits=['Disassembly of8registered callbacks only; next native execution and port required.','Formats/references are candidates until callback execution verifies output and failure behavior.'])
(r/'data/4.20/native_hud_remaining_properties_candidates.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(properties=8,qualified=False,literals=formats)))
