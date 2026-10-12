exec(open('E:/mapslol3v3/inspect_grass_sampler.py',encoding='utf-8').read().split('for start,size')[0])
import json,struct
targets={0x95f230:'spatial_object_constructor',0x95ea20:'service_constructor',0x95f1d0:'spatial_object_unregister',0x960000:'tree_insert'};refs={hex(k):[] for k in targets}
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 low=section.VirtualAddress;high=low+section.Misc_VirtualSize;cursor=low
 while True:
  at=data.find(b'\xe8',cursor,high)
  if at<0 or at+5>high:break
  cursor=at+1;dest=base+at+5+struct.unpack('<i',data[at+1:at+5])[0]
  if dest not in targets:continue
  # Padding is a candidate boundary only; callers still require instruction qualification.
  pad=data.rfind(b'\xcc\xcc\xcc',max(low,at-4096),at);start=pad+3 if pad>=0 else at-32
  while start<at and data[start]==0xcc:start+=1
  rows=[dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str) for i in cs.disasm(data[start:at+10],base+start)]
  refs[hex(dest)].append(dict(call=hex(base+at),candidate_start=hex(base+start),instructions=rows))
Path('E:/mapslol3v3/native-grass-registration-callers.json').write_text(json.dumps(dict(qualified=False,notice='Direct-call bytepattern references andpadding-derived boundaries; identity/provider linkage andexecution requirequalification.',references=refs),indent=2)+'\n',encoding='utf-8')
print(json.dumps({targets[k]:[v['call'] for v in refs[hex(k)]] for k in targets}))
