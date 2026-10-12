exec(open('E:/mapslol3v3/inspect_grass_sampler.py',encoding='utf-8').read().split('for start,size')[0])
import json,hashlib
regions={}
for start,size in [(0x616540,0x170),(0x569210,0x18c),(0x9632e0,0xde),(0x9634a0,0x180),(0x960d40,0x152),(0x66c0b0,4)]:
 regions[hex(start)]=[dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str) for i in cs.disasm(data[start-base:start-base+size],start)]
rows=list(cs.disasm(data[0x963cd0-base:0x965180-base],0x963cd0));provider_assignments=[]
for k,i in enumerate(rows):
 if '[esi + 0xa4]' in i.op_str:
  provider_assignments.append([dict(address=hex(v.address),instruction=v.mnemonic+' '+v.op_str) for v in rows[max(0,k-12):k+5]])
proof=dict(qualified=False,notice='Static instruction trace only; native model/resource construction, getter and file layout still need execution qualification.',regions=regions,provider_assignments=provider_assignments,observations=['616648 copies descriptor+9E4 into actor+2068.','56933B writes return from9632E0 into descriptor+9E4.','9632E0 allocates1F0 bytes, calls9634A0 then963CD0 and returns model on successful loader.','9634A0 sets scale+4 to1 and pointer+A4 null; loader initializes actual bounds provider.','964197 calls960D40 and9641B8 stores its returned provider in model+A4.','960D40 writes provider vtable10D9D80; virtual+4 at10D9D84 is66C0B0, which returns provider+1C. Constructor initializes this six-float box to zero; dynamic pose-bound producer still requires qualification.'])
Path('E:/mapslol3v3/native-model-resource-chain.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(qualified=False,provider_assignments=provider_assignments)))
