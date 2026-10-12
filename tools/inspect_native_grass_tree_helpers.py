exec(open('E:/mapslol3v3/inspect_grass_sampler.py',encoding='utf-8').read().split('for start,size')[0])
import json,struct
out={}
for start,size in [(0x9606d0,0x100),(0x960350,0x280),(0x8a7c40,0x90),(0x960000,0x270)]:
 rows=[dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str) for i in cs.disasm(data[start-base:start-base+size],start)];out[hex(start)]=rows
 print('FUNCTION',hex(start))
 for row in rows:print(row['address'],row['instruction'])
out['margin_bits']=struct.unpack('<I',data[0x1138b40-base:0x1138b44-base])[0]
Path('E:/mapslol3v3/native-grass-tree-helpers.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print('MARGIN',out['margin_bits'])
