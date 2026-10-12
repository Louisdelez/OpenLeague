from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
voice=vector+0x4000;source=vector+0x5000;root=vector+0x6000;root_vtable=vector+0x7000;node=vector+0x8000;resource=vector+0x9000;secondary=vector+0xa000;calls=[];visited=set()
w(root_vtable,vector+0xf020);w(root_vtable+8,vector+0xf000);w(root_vtable+0x8c,vector+0xf010)
# Explicit downstream boundaries: outer cleanup bodies run; these services log
# arguments and do not claim implementations of their native callees.
callbacks={0xaecf10:('effect_stop',4),0xb00250:('remove_registration',8),0xb141f0:('remove_binding',8),0xaf5b90:('release_owner',8),0xaf5270:('release_query',8),0xaf5d80:('destroy_secondary',0),0xaf9530:('lookup_source_property',4),0xaef280:('apply_source_property',4),0xaeea00:('remove_source_voice',4),0xb02040:('release_input',0),0xafbfd0:('release_stream',4),0xb1ae80:('release_cache',0),0xb01d30:('destroy_input',0)}
def hook(uc,a,size,data):
 global initial_scratch
 if a==0xaecead:initial_scratch=bytes(u.mem_read(u.reg_read(UC_X86_REG_EBP)-24,24)).hex()
 if a in callbacks:
  kind,pop=callbacks[a];sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':kind,'receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4+i*4)for i in range(pop//4)]});
  if a in [0xb141f0,0xaf5b90]:return
  finish(0 if a==0xaf9530 else 1,pop);return
 if a in [vector+0xf000,vector+0xf010,vector+0xf020]:
  sp=u.reg_read(UC_X86_REG_ESP);event={'kind':'source_virtual08'if a==vector+0xf000 else'source_destructor'if a==vector+0xf020 else'source_virtual8c','receiver':u.reg_read(UC_X86_REG_ECX)}
  if a==vector+0xf010:event['payload']=bytes(u.mem_read(read(sp+4),24)).hex()
  calls.append(event);finish(1,4 if a!=vector+0xf000 else 0);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8),'voice_at_call':bytes(u.mem_read(voice,424)).hex(),'resource_at_call':bytes(u.mem_read(resource,112)).hex()});finish(1);return
 if a==0x5642d0:calls.append({'kind':'destroy_node','reference':u.reg_read(UC_X86_REG_ECX)})
 assert 0xb141f0<=a<0xb14261 or 0xb14180<=a<0xb141ed or 0xb1bca0<=a<0xb1bd0f or 0x5642d0<=a<0x5642d3 or 0xaf5b90<=a<0xaf5c55 or 0xaeef20<=a<=0xaef114 or 0xaece30<=a<=0xaecedf or 0xaf1a70<=a<0xaf1a8d,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,registered,effect,optional,node_kind in itertools.product([0,0xa5],[False,True],[False,True],[False,True],[0,1,2]):
 calls.clear();initial_scratch=None;u.mem_write(voice,bytes([pattern])*424);u.mem_write(root,bytes([pattern])*96);w(root,root_vtable);w(root+32,0);w(root+68,resource);u.mem_write(resource,bytes([pattern])*112);w(resource+64,123);w(resource+68,vector+0xd000);u.mem_write(secondary,bytes([pattern])*112);w(secondary+96,1)
 for o in [20,24,28,32,44,48,72,80,84,332,396,400,404,408,412]:w(voice+o,vector+0x10000+o if optional else 0)
 w(voice+48,source if optional else 0);w(voice+96,root);w(voice+100,resource);w(voice+104,secondary if optional else 0);w(voice+400,node if node_kind else 0);u.mem_write(node,bytes([pattern])*108);w(node+24,2 if node_kind==2 else 0);u.mem_write(voice+302,bytes([0 if registered else 0x10]));u.mem_write(voice+303,bytes([0x40 if effect else 0]));u.mem_write(resource+16,bytes([0x00,0x01 if optional else 0,0,0]));u.mem_write(source,bytes([pattern])*96);w(source,root_vtable);w(source+60,vector+0x1d000 if optional else 0);w(0x12100dc,19)

 manager=vector+0x1a000;table=vector+0x1b000;binding=vector+0x1c000;mask=vector+0x1d000;aux=vector+0x1e000
 u.mem_write(manager,bytes([pattern])*16);w(manager,table);w(manager+4,1);w(manager+8,4);w(manager+12,4);u.mem_write(table,bytes([pattern])*16);w(table,node);w(0x14a7a40,manager)
 w(node,1);w(node+8,mask);w(node+32,binding);w(node+36,1);w(node+40,4);u.mem_write(node+44,b'\x00\x01');w(node+104,aux);u.mem_write(binding,bytes([0x33])*16);w(binding,voice);u.mem_write(mask,bytes([0x5a])*4);u.mem_write(aux,bytes([0x77])*36)
 for j,offset in enumerate([80,84]):
  owner=vector+0x18000+j*256;owner_table=vector+0x19000+j*256;u.mem_write(owner,bytes([pattern])*54);w(owner+32,owner_table);w(owner+36,1);u.mem_write(owner+53,b'\x01');u.mem_write(owner_table,bytes([pattern])*16);w(owner_table,voice+8);w(voice+offset,owner if optional else 0)
 def snap():return {'voice':bytes(u.mem_read(voice,424)).hex(),'resource':bytes(u.mem_read(resource,112)).hex(),'secondary':bytes(u.mem_read(secondary,112)).hex(),'source':bytes(u.mem_read(source,96)).hex(),'root':bytes(u.mem_read(root,96)).hex(),'node':bytes(u.mem_read(node,108)).hex(),'manager':bytes(u.mem_read(manager,16)).hex(),'table':bytes(u.mem_read(table,16)).hex(),'binding':bytes(u.mem_read(binding,16)).hex(),'mask':bytes(u.mem_read(mask,4)).hex(),'auxiliary':bytes(u.mem_read(aux,36)).hex(),'owners':[{'reference':vector+0x18000+j*256,'raw':bytes(u.mem_read(vector+0x18000+j*256,54)).hex()}for j in range(2)],'owner_tables':[{'reference':vector+0x19000+j*256,'raw':bytes(u.mem_read(vector+0x19000+j*256,16)).hex()}for j in range(2)]}
 before=snap();w(stack,end);w(stack+4,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,voice);
 try:u.emu_start(0xaeef20,end,count=5000)
 except Exception:
  print('native failure',pattern,registered,effect,optional,node_kind,hex(u.reg_read(UC_X86_REG_EIP)),calls);raise
 assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'registered':registered,'effect':effect,'optional':optional,'node_kind':node_kind,'registration_scratch_initial':initial_scratch,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaeef20','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AEEF20 outer cleanup and AECE30 registration-release body execute, along with actual AF1A70 nearest resource state; full424-byte voice and resource/source/node/padding snapshots and ordered calls recorded. Native uninitialized registration scratch is captured before its first store; trailing two padding bytes are a borrowed input, not invented or normalized. Actual B141F0/B14180/B1BCA0 binding and last-node retirement plus actual AF5B90 owner removals execute. Manager/table/retired allocation snapshots and owner tables captured. Downstream registration table removal, query/cache/input/stream/source/resource operations and source virtual08/8C are explicit controlled adapters, not implementations. B141F0/AF5B90 are now composed with the actual cleanup body; allocation/free transports controlled. Source constructors, secondary destructor, canonical owners and actual producer lifetime must be integrated. Not full cleanup or audible output acceptance; Rust replay remains required.']}
(r/'data/4.20/audio_path_voice_cleanup_owned_binding_preparation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'actual outer cleanup/registration body cases with explicit downstream service boundaries')
