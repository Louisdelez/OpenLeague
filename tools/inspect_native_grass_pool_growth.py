exec(open('E:/mapslol3v3/inspect_grass_sampler.py',encoding='utf-8').read().split('for start,size')[0])
import json
rows=[]
for i in cs.disasm(data[0x96af60-base:0x96af60-base+0x160],0x96af60):
 if i.mnemonic=='int3':break
 rows.append(dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str))
Path('E:/mapslol3v3/native-grass-pool-growth-inspection.json').write_text(json.dumps(dict(qualified=False,entry='0x96af60',instructions=rows),indent=2)+'\n',encoding='utf-8')
for row in rows:print(row['address'],row['instruction'])
