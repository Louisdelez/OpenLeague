from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/probe_fow_frame_schedule.py').read_text(encoding='utf-8')
s=s.replace(" if a==0x62b380:adapters.append('entity_lookup_absent');finish(eax=0)\n elif a==0x6b439b:adapters.append('spectator_false');u.reg_write(UC_X86_REG_EAX,0);u.reg_write(UC_X86_REG_EIP,0x6b439d)", " if a in [0x6b41de,0x6b420a,0x6b439b]:adapters.append('spectator_false');u.reg_write(UC_X86_REG_EAX,0);u.reg_write(UC_X86_REG_EIP,a+2)")
s=s.replace('cases=[]\nfor delta,previous_delta,force,dirty,applied,now,radius in itertools.product([.01,.033,.2,1.,2.,3.],[0.,.033,.2],[False,True],[False,True],[False,True],[4.999,5.001],[200.,2000.]):', '''u.mem_map(0x71000000,0x10000)
cases=[]
for presence,actor_tag,flag_ad,flag_118,flag_24,flag_2c,applied in itertools.product(['absent_registration','absent_actor','actor'],[100,200,300],[False,True],[False,True],[False,True],[False,True],[False,True]):
 delta=3.;previous_delta=0.;force=False;dirty=True;now=5.001;radius=200.
 u.mem_write(0x71000000,bytes(0x10000))
 first=0x71000000;head=first+0x100;bucket=first+0x200;nodes=first+0x300;payloads=first+0x1000
 write32(0x2d789c0,first);write32(first+4,head);write32(first+0xc,bucket);write32(first+0x18,0);write32(first+0x1c,1)
 count=0 if presence=='absent_registration' else 3
 write32(head,nodes if count else head);write32(head+4,nodes+64 if count else head);write32(bucket,nodes if count else head);write32(bucket+4,nodes+64 if count else head)
 second=0x2110a10;head2=first+0x3000;bucket2=first+0x3100;nodes2=first+0x3200;actor_base=first+0x4000
 write32(second+4,head2);write32(second+8,3 if presence=='actor' else 0);write32(second+0xc,bucket2);write32(second+0x18,0);write32(second+0x1c,1)
 actor_count=3 if presence=='actor' else 0
 write32(head2,nodes2 if actor_count else head2);write32(head2+4,nodes2+64 if actor_count else head2);write32(bucket2,nodes2 if actor_count else head2);write32(bucket2+4,nodes2+64 if actor_count else head2)
 for i in range(count):
  node=nodes+32*i;payload=payloads+32*i
  for address,value in [(node,nodes+32*(i+1) if i<2 else head),(node+4,nodes+32*(i-1) if i else head),(node+8,55+i),(node+0xc,payload),(payload+8,0x12340000+i)]:write32(address,value)
 for i in range(actor_count):
  node=nodes2+32*i;actor=actor_base+0x400*i;descriptor=first+0x6000+0x100*i
  for address,value in [(node,nodes2+32*(i+1) if i<2 else head2),(node+4,nodes2+32*(i-1) if i else head2),(node+8,0x12340000+i),(node+0xc,actor),(actor+0x18,actor_tag),(actor+0x124,0x1090e60),(actor+0x17c,descriptor)]:write32(address,value)
  for address,value in [(actor+0xad,flag_ad),(actor+0x118,flag_118),(descriptor+0x24,flag_24),(descriptor+0x2c,flag_2c)]:u.mem_write(address,bytes([value]))
''')
s=s.replace(' write32(manager+4,entries);write32(manager+8,entries);write32(manager+0xc,entries+32)', ' write32(context,0x71007000)\n write32(manager+4,entries);write32(manager+8,entries);write32(manager+0xc,entries+32)')
s=s.replace('cases.append(dict(delta=delta,', "cases.append(dict(presence=presence,actor_tag=actor_tag,flag_ad=flag_ad,flag_118=flag_118,flag_24=flag_24,flag_2c=flag_2c,applied_after=[bool(u.mem_read(obj+0x44,1)[0]) for obj,_ in sources],counts_after=list(u.mem_read(counts,64)),delta=delta,")
s=s.replace("captures.append(dict(pending=pending_state(),pending_flags=", "captures.append(dict(counts=list(u.mem_read(counts,64)),applied_flags=[bool(u.mem_read(obj+0x44,1)[0]) for obj,_ in sources],pending=pending_state(),pending_flags=")
s=s.replace('fow_frame_schedule_contract.json','fow_registered_filter_contract.json')
s=s.replace("0x62b380,0x6b439b,", "0x6b41de,0x6b420a,0x6b439b,")
s=s.replace("'Entity lookup supplied absent, spectator query supplied false, QPC/clock initialization adapted, mask generation boundary records requests without generating/applying masks. All sources belong to local tag100; original view initialization and actual entities are not executed.'", "'Both original identity and handle lookups execute on supplied registries; actor virtual getters600830 and617360 execute. Local source tag100 and spectator false supplied at three virtual call sites; actor/descriptor flag producers and constructors remain unqualified. QPC/clock and mask generation boundaries adapted; no generated mask is applied.'")
(r/'tools/probe_fow_registered_filter_generated.py').write_text(s,encoding='utf-8')
exec(compile(s,'registered actor native filter','exec'))
