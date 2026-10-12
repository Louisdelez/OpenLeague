exec(open('E:/mapslol3v3/inspect_grass_sampler.py',encoding='utf-8').read().split('for start,size')[0])
import json,struct
patterns=[(b'\x8d\x81',7),(b'\x8d\x41',4),(b'\x8b\x81',7),(b'\x8b\x41',4)]
candidates=[]
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 start=section.VirtualAddress;end=start+section.Misc_VirtualSize
 for pattern,length in patterns:
  cursor=start
  while True:
   at=data.find(pattern,cursor,end)
   if at<0:break
   cursor=at+1
   if data[at+length-1:at+length]!=b'\xc3':continue
   instructions=list(cs.disasm(data[at:at+length],base+at));
   if len(instructions)!=2 or instructions[-1].mnemonic!='ret':continue
   address=base+at;needle=struct.pack('<I',address);references=[]
   for readable in pe.sections:
    if readable.Characteristics&0x20000000 or not readable.Characteristics&0x40000000:continue
    low=readable.VirtualAddress;high=low+readable.Misc_VirtualSize;offset=low
    while True:
     ref=data.find(needle,offset,high)
     if ref<0:break
     offset=ref+1
     if ref%4 or ref<4:continue
     prior=struct.unpack('<I',data[ref-4:ref])[0]
     if any(base+x.VirtualAddress<=prior<base+x.VirtualAddress+x.Misc_VirtualSize for x in pe.sections if x.Characteristics&0x20000000):references.append(dict(possible_vtable=hex(base+ref-4),preceding_code=hex(prior)))
   if references:candidates.append(dict(accessor=hex(address),instruction=instructions[0].mnemonic+' '+instructions[0].op_str,possible_virtual4=references))
Path('E:/mapslol3v3/native-model-bound-accessor-candidates.json').write_text(json.dumps(dict(qualified=False,notice='Tiny accessor byte patterns with possible virtual+4 references only. Function boundaries, class identity, return layout andactualmodel linkage require qualification.',candidates=candidates),indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(qualified=False,candidate_accessors=len(candidates),preview=candidates[:5])))
