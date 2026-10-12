exec(open('E:/mapslol3v3/inspect_grass_sampler.py',encoding='utf-8').read().split('for start,size')[0])
import json
out={}
for start,size in [(0x8a87e0,0xa0),(0x95eda0,0x190),(0x95fda0,0x170)]:
 rows=[]
 for i in cs.disasm(data[start-base:start-base+size],start):
  if i.mnemonic=='int3':break
  rows.append(dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str))
 out[hex(start)]=rows
 print('FUNCTION',hex(start))
 for row in rows:print(row['address'],row['instruction'])
Path('E:/mapslol3v3/native-grass-insertion-dependencies.json').write_text(json.dumps(dict(qualified=False,instructions=out),indent=2)+'\n',encoding='utf-8')
