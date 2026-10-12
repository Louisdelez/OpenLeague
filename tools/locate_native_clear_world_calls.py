from pathlib import Path
exec(Path(__file__).with_name('inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
import re
rows=[]
for sec in pe.sections:
 if not sec.Characteristics & 0x20000000:continue
 data=sec.get_data()
 for m in re.finditer(rb'\xff[\x50-\x53\x55-\x57]\x30',data):
  off=m.start();prefix=data[max(0,off-180):off]
  if struct.pack('<I',0x2d79078) not in prefix:continue
  start=max(0,off-180);pad=prefix.rfind(b'\xcc\xcc')
  if pad>=0:start+=pad+2
  ins=[{'address':hex(i.address),'instruction':i.mnemonic+' '+i.op_str} for i in md.disasm(data[start:off+10],base+sec.VirtualAddress+start)]
  rows.append({'address':hex(base+sec.VirtualAddress+off),'instructions':ins})
Path('E:/mapslol3v3/native_clear_world_calls.json').write_text(json.dumps(rows,indent=2),encoding='utf-8')
for row in rows:
 print('CALL',row['address'])
 for i in row['instructions'][-32:]:print(i['address'],i['instruction'])
