exec(open('E:/OpenLeague/tools/discover_stop_setter_callers.py',encoding='utf-8').read().split('target=')[0])
hits=[]
for sec in p.sections:
 if not sec.Characteristics&0x20000000:continue
 start=sec.VirtualAddress;stop=start+sec.Misc_VirtualSize;at=start
 while True:
  at=img.find(bytes.fromhex('a0000000'),at,stop)
  if at<0:break
  op=at-2;at+=4
  if not ((img[op]==0xff and 0x90<=img[op+1]<=0x97) or (img[op]==0x8b and img[op+1]&0xc0==0x80 and img[op+1]&7!=4)):continue
  first=max(start,op-200);sentinel=img.rfind(b'\xcc',first,op)
  first=sentinel+1 if sentinel>=0 else op
  instructions=list(m.disasm(img[first:op+45],base+first))
  hits.append({'address':hex(base+op),'function_candidate':hex(base+first),'context':[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in instructions if base+op-45<=i.address<=base+op+30]})
out={'native_sha256':hashlib.sha256(raw).hexdigest(),'complete':False,'static_only':True,'vtable_base':'0x10d6db4','vtable_constructor':'0x93fd9a','stop_method_offset':'0xa0','hits':hits}
(r/'data/4.20/particle_stop_virtual_calls.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({'count':len(hits),'addresses':[h['address'] for h in hits]}))
