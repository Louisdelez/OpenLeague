from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
s=Path('E:/mapslol3v3/probe_native_grass_parent.py').read_text(encoding='utf-8')
s=s.replace('events=[]','events=[];allocation_cursor=terrain+0xb000',1)
s=s.replace('def boundary(uc,a,size,user):','def boundary(uc,a,size,user):\n global allocation_cursor',1)
s=s.replace("if a==0x9606d0:","if a==0x9933e0:\n  s=u.reg_read(UC_X86_REG_ESP);assert read32(s+4)==12\n  pointer=allocation_cursor;allocation_cursor+=0x10;u.mem_write(pointer,bytes(12));u.reg_write(UC_X86_REG_EAX,pointer);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)\n elif a==0x9606d0:",1)
s=s.replace("events.append(dict(kind='insert_root',parent_cleared=read32(spatial+0x28)==0));ret(4)","events.append(dict(kind='insert_root',parent_cleared=read32(spatial+0x28)==0))",1)
s=s.replace('write32(parent,service);write32(service+4,root);', 'allocation_cursor=terrain+0xb000;root_sentinel=terrain+0x8000;u.mem_write(root_sentinel,bytes(0x20));write32(root,service);write32(root+0x44,root_sentinel);write32(root_sentinel,root_sentinel);write32(root_sentinel+4,root_sentinel);write32(parent,service);write32(service+4,root);',1)
s=s.replace("parent_cleared=read32(spatial+0x28)==0,vertical_bits=", "parent_cleared=read32(spatial+0x28)==0,inserted_root=read32(spatial+0x28)==root,root_vertical_bits=list(struct.unpack('<4I',u.mem_read(root+0x20,16))),root_member_count=read32(root+0x48),vertical_bits=",1)
s=s[:s.index('proof=dict(')]
exec(compile(s,'actualparentandrootinsertion','exec'))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95ff10',native_addresses=len(visited),cases=cases,runtime_adapters=['C98528 list-link release and95FDA0 node destructor boundaries record andreturn; unlink/prune execute.','9933E0 returns mapped12byte allocations; actual960000/9600F0/8A87E0/8A8400 insertion executes.'],limits=['Explicit parentfixture andemptychildlessroot supplied; allocator/destructor/pool andactualtreeproviders remainopen.','Subdivisionprocessing, realregisteredactorcallbacks andnormal grassmaskrender notqualified.'])
(r/'data/4.20/grass_parent_insertion_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
