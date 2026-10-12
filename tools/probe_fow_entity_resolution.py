from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/probe_fow_entity_lookup.py').read_text()
s=s.replace('for keys in [[],[55],[55,56,57],[0,1,0x7fffffff,0x80000000,0xfffffffe,0xffffffff]]:', 'for keys,omit_last in __import__("itertools").product([[],[55],[55,56,57],[0,1,0x7fffffff,0x80000000,0xfffffffe,0xffffffff]],[False,True]):')
needle=' for query in sorted(set(keys+'
extra=''' second=0x2110a10;head2=registry+0x3000;bucket2=registry+0x3100;nodes2=registry+0x3200;actor_base=registry+0x4000
 u.mem_write(second,bytes(32));u.mem_write(head2,bytes(0x1000));count=len(keys)-int(omit_last and bool(keys));write32(second+4,head2);write32(second+8,count);write32(second+0xc,bucket2);write32(second+0x18,0);write32(second+0x1c,1)
 write32(head2,nodes2 if count else head2);write32(head2+4,nodes2+32*(count-1) if count else head2);write32(bucket2,nodes2 if count else head2);write32(bucket2+4,nodes2+32*(count-1) if count else head2)
 for i in range(count):
  node=nodes2+32*i;write32(node,nodes2+32*(i+1) if i+1<count else head2);write32(node+4,nodes2+32*(i-1) if i else head2);write32(node+8,0x12340000+i);write32(node+0xc,actor_base+256*i)
'''
assert needle in s;s=s.replace(needle,extra+needle)
s=s.replace("cases.append(dict(keys=keys,query=query,found=bool(result),result_handle=read32(result+8) if result else None))", "handle=read32(result+8) if result else None;actor_index=None\n  if handle is not None:\n   invoke(0x5bdd80,0,struct.pack('<I',handle));resolved=u.reg_read(UC_X86_REG_EAX);expected_index=keys.index(query);assert resolved==(actor_base+256*expected_index if expected_index<count else 0);actor_index=expected_index if resolved else None\n  cases.append(dict(keys=keys,omit_last=omit_last,query=query,found=bool(result),result_handle=handle,result_actor_index=actor_index))")
s=s.replace('fow_entity_lookup_contract.json','fow_entity_resolution_contract.json').replace("lookup='0x5c6830',", "lookup='0x5c6830',handle_resolver='0x5bdd80',")
s=s.replace('Return is a registration payload whose+8 contains a handle; native frame next resolves this handle via5BDD80. Actor eligibility and full frame lookup integration remain unqualified.', 'Original5BDD80/5C3160 handle lookup executes on a separately supplied registry, including missing actor entry. Actor payloads are supplied addresses; eligibility and full-frame integration remain unqualified.')
(r/'tools/probe_fow_entity_resolution_generated.py').write_text(s,encoding='utf-8')
exec(compile(s,'native two-stage entity resolution','exec'))
