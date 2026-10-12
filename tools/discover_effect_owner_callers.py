exec(open('E:/OpenLeague/tools/discover_stop_setter_callers.py',encoding='utf-8').read().split('target=')[0])
out=[]
for target in [0x7557e0,0x7558c0]:
 calls=[]
 for sec in p.sections:
  if not sec.Characteristics&0x20000000:continue
  start=sec.VirtualAddress;stop=start+sec.Misc_VirtualSize;at=start
  while True:
   at=img.find(b'\xe8',at,stop)
   if at<0:break
   if at+5<=stop and base+at+5+struct.unpack_from('<i',img,at+1)[0]==target:
    first=img.rfind(b'\xcc',max(start,at-220),at)+1
    if first<max(start,at-220):first=at
    ins=list(m.disasm(img[first:at+35],base+first))
    calls.append({'address':hex(base+at),'context':[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in ins if base+at-50<=i.address<=base+at+25]})
   at+=1
 out.append({'target':hex(target),'calls':calls})
proof={'native_sha256':hashlib.sha256(raw).hexdigest(),'complete':False,'static_only':True,'targets':out}
(r/'data/4.20/effect_owner_callers_discovery.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(proof,indent=2))
