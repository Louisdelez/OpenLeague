exec(open('E:/mapslol3v3/inspect_owner_end.py',encoding='utf-8').read().split('for start,end')[0])
hits=[];pattern=bytes.fromhex('4401000000040000');offset=0
while True:
 offset=img.find(pattern,offset)
 if offset<0:break
 start=offset-2;offset+=1
 if img[start]!=0x81:continue
 ins=list(m.disasm(img[start:start+40],base+start))
 if not ins or ins[0].mnemonic!='or':continue
 hits.append({'address':hex(base+start),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
out={'complete':False,'static_only':True,'hits':hits}
(r/'data/4.20/particle_stop_request_setters.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
