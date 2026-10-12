exec(open('E:/OpenLeague/tools/inspect_owner_end.py',encoding='utf-8').read().split('for start,end')[0])
keys={}
for key in ['p-scale','p-rot','p-rotvel','p-life','e-rate']:
 at=img.find(key.encode()+b'\0')
 if at>=0:keys[hex(base+at)]=key
m.skipdata=True;ins=list(m.disasm(img[0x91c0c0-base:0x91f000-base],0x91c0c0));hits=[]
for n,i in enumerate(ins):
 if i.mnemonic=='push' and i.op_str in keys:
  hits.append({'key':keys[i.op_str],'address':hex(i.address),'context':[dict(address=hex(x.address),mnemonic=x.mnemonic,operands=x.op_str) for x in ins[max(0,n-6):n+17]]})
proof={'native_sha256':__import__('hashlib').sha256(source.read_bytes()).hexdigest(),'complete':False,'static_only':True,'keys':keys,'hits':hits}
(r/'data/4.20/simple_size_rotation_readers.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(proof,indent=2))
