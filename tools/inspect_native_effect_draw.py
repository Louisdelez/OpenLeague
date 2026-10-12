from pathlib import Path
exec(Path('E:/OpenLeague/tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for a,b in [(0xca633a,0xca63e0)]:
 print('RANGE',hex(a),hex(b))
 for i in md.disasm(image[a-base:b-base],a):
  print(hex(i.address),i.mnemonic,i.op_str)
  if i.mnemonic=='push' and i.op_str.startswith('0x'):
   v=int(i.op_str,16)
   if base<=v<base+len(image):
    s=image[v-base:v-base+80].split(b'\0')[0]
    if s and all(32<=x<=126 for x in s):print(' STRING',s.decode())
import zipfile
for archive in Path('E:/OpenLeague/data/4.20/archives/menu').glob('*.zip'):
 z=zipfile.ZipFile(archive)
 print('ARCHIVE',archive.name,[n for n in z.namelist() if any(x in n.lower() for x in ['effect','cooldown','shader'])][:40])
import json
for name,key in [('resume_checkpoint.json','last_verified'),('coverage.json','current_evidence')]:
 d=json.loads(Path('E:/OpenLeague/docs',name).read_text(encoding='utf-8-sig'));print(name,{k:v for k,v in d[key].items() if k in ['client_tests','core_tests','current_source_progress','ordinary_client_build_matches_current_source']})
