from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_source_release.py').read_text().split('\ncases=[]')[0],'native lookup prerequisites','exec'))
u.mem_map(0x71000000,0x10000);registry=0x71000000;sentinel=registry+0x100;bucket=registry+0x200;node_base=registry+0x300;payload_base=registry+0x1000
write32(0x2d789c0,registry)
cases=[]
for keys in [[],[55],[55,56,57],[0,1,0x7fffffff,0x80000000,0xfffffffe,0xffffffff]]:
 u.mem_write(registry,bytes(0x2000));write32(registry+4,sentinel);write32(registry+0xc,bucket);write32(registry+0x18,0);write32(registry+0x1c,1)
 nodes=[node_base+32*i for i in range(len(keys))]
 write32(sentinel,nodes[0] if nodes else sentinel);write32(sentinel+4,nodes[-1] if nodes else sentinel)
 write32(bucket,nodes[0] if nodes else sentinel);write32(bucket+4,nodes[-1] if nodes else sentinel)
 for i,key in enumerate(keys):
  node=nodes[i];payload=payload_base+32*i
  for address,value in [(node,nodes[i+1] if i+1<len(nodes) else sentinel),(node+4,nodes[i-1] if i else sentinel),(node+8,key),(node+0xc,payload),(payload+8,0x12340000+i)]:write32(address,value)
 for query in sorted(set(keys+[0,1,2,54,55,56,57,58,12345,0x7ffffffe,0x80000001,0xffffffff])):
  #62B380 receives an opaque u32 identifier by value, not an actor pointer.
  invoke(0x62b380,0,struct.pack('<I',query));result=u.reg_read(UC_X86_REG_EAX)
  expected=payload_base+32*keys.index(query) if query in keys else 0;assert result==expected
  cases.append(dict(keys=keys,query=query,found=bool(result),result_handle=read32(result+8) if result else None))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x62b380',lookup='0x5c6830',native_addresses=len(visited),runtime_adapters=[],cases=cases,limits=['Original lookup/hash/division/list traversal executes without adapters. Registry and a single collision bucket plus sorted node/payload storage supplied, not registered through original insertion/constructor.','Return is a registration payload whose+8 contains a handle; native frame next resolves this handle via5BDD80. Actor eligibility and full frame lookup integration remain unqualified.','Not qualification of registry growth/multiple buckets, registration lifetime or ordinary entities.'])
(r/'data/4.20/fow_entity_lookup_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],adapters=proof['runtime_adapters'])))
