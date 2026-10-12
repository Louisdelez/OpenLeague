exec(open('E:/OpenLeague/tools/inspect_owner_end.py',encoding='utf-8').read().split('for start,end')[0])
m.skipdata=True;ins=list(m.disasm(img[0x93f000-base:0x93fa10-base],0x93f000));hits=[]
for n,i in enumerate(ins):
 dest=i.op_str.split(',')[0]
 if any(' + '+v+']' in dest for v in ['0x90','0x94','0x98']) and i.mnemonic in ['mov','movss','fstp']:
  hits.append({'address':hex(i.address),'context':[dict(address=hex(x.address),mnemonic=x.mnemonic,operands=x.op_str) for x in ins[max(0,n-9):n+8]]})
proof={'native_sha256':__import__('hashlib').sha256(source.read_bytes()).hexdigest(),'complete':False,'static_only':True,'hits':hits}
(r/'data/4.20/system_pose_producer_discovery.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(proof,indent=2))
