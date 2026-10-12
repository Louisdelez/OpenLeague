exec(open('E:/mapslol3v3/inspect_grass_sampler.py',encoding='utf-8').read().split('for start,size')[0])
from pathlib import Path
import json
rows=[dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str) for i in cs.disasm(data[0x95ff10-base:0x95ff10-base+1400],0x95ff10)]
Path('E:/mapslol3v3/native-grass-parent-inspection.json').write_text(json.dumps(dict(qualified=False,entry='0x95ff10',instructions=rows),indent=2)+'\n',encoding='utf-8')
for row in rows[:115]:print(row['address'],row['instruction'])
