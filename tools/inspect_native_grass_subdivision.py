exec(open('E:/mapslol3v3/inspect_grass_sampler.py',encoding='utf-8').read().split('for start,size')[0])
import json,struct
out={}
for start,size in [(0x9605e0,0xf0),(0x95fc70,0x130)]:
 rows=[]
 for i in cs.disasm(data[start-base:start-base+size],start):
  if i.mnemonic=='int3':break
  rows.append(dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str))
 out[hex(start)]=rows
refs=[]
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 start=section.VirtualAddress;end=start+section.Misc_VirtualSize;cursor=start
 while True:
  at=data.find(b'\xe8',cursor,end)
  if at<0 or at+5>end:break
  cursor=at+1
  destination=base+at+5+struct.unpack('<i',data[at+1:at+5])[0]
  if destination==0x9603c0:
   refs.append(dict(candidate_call=hex(base+at),context=[dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str) for i in cs.disasm(data[at-64:at+32],base+at-64)]))
Path('E:/mapslol3v3/native-grass-subdivision-inspection.json').write_text(json.dumps(dict(qualified=False,helpers=out,candidate_callers=refs),indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(candidate_callers=[v['candidate_call'] for v in refs],helper_instructions={k:len(v) for k,v in out.items()},qualified=False)))
