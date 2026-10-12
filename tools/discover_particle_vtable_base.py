exec(open('E:/OpenLeague/tools/discover_stop_setter_callers.py',encoding='utf-8').read().split('target=')[0])
hits=[]
for value in range(0x10d6d00,0x10d6d80,4):
 at=0
 while True:
  at=img.find(struct.pack('<I',value),at)
  if at<0:break
  a=base+at;at+=4
  if not any(sec.Characteristics&0x20000000 and base+sec.VirtualAddress<=a<base+sec.VirtualAddress+sec.Misc_VirtualSize for sec in p.sections):continue
  hits.append({'address':hex(a),'value':hex(value),'bytes':img[at-12:at+16].hex()})
print(json.dumps(hits,indent=2))
