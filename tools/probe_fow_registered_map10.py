from pathlib import Path
r=Path('E:/OpenLeague')
registered=(r/'tools/probe_fow_registered_filter_generated.py').read_text(encoding='utf-8')
setup=registered.split(' u.mem_write(0x71000000,bytes(0x10000))')[1].split(' allocation_cursor=')[0]
setup=' u.mem_write(0x71000000,bytes(0x10000))'+setup
s=(r/'tools/probe_fow_map10_frames.py').read_text(encoding='utf-8')
s=s.replace('probe_fow_frame_schedule.py','probe_fow_registered_filter_generated.py')
s=s.replace('for radius,force,initial_applied,delta in itertools.product([200.,800.],[False,True],[False,True],[.01,3.]):', "for presence,radius,force,initial_applied,delta in itertools.product(['actor','absent_actor'],[200.,800.],[False,True],[False,True],[.01,3.]):\n actor_tag=100;flag_ad=True;flag_118=False;flag_24=True;flag_2c=False\n"+setup)
s=s.replace(" u.mem_write(0x2d7c078,bytes([1]));", " write32(context,0x71007000)\n u.mem_write(0x2d7c078,bytes([1]));")
needle='  frame_force=force or step>=2;'
change='''  actor_states=[]
  for i in range(3):
   actor=actor_base+0x400*i;descriptor=first+0x6000+0x100*i
   tag=300 if i==1 and step<2 else (200 if i==2 and step<3 else 100)
   ad=not (i==0 and step in [1,2]);disabled=i==2 and step==2;d24=True;d2c=step==3
   write32(actor+0x18,tag)
   for address,value in [(actor+0xad,ad),(actor+0x118,disabled),(descriptor+0x24,d24),(descriptor+0x2c,d2c)]:u.mem_write(address,bytes([value]))
   actor_states.append(dict(team_tag=tag,flag_ad=ad,flag_118=disabled,descriptor_24=d24,descriptor_2c=d2c))
'''
assert needle in s;s=s.replace(needle,change+needle)
s=s.replace('frames.append(dict(step=step,','frames.append(dict(actor_states=actor_states,step=step,')
s=s.replace('cases.append(dict(radius=radius,','cases.append(dict(presence=presence,radius=radius,')
s=s.replace('fow_map10_frames_contract.json','fow_registered_map10_contract.json')
s=s.replace('0x62b380,0x6b439b,','0x6b41de,0x6b420a,0x6b439b,')
s=s.replace('Entity lookup supplied absent, spectator false, QPC/clock initialization and allocator boundaries adapted.', 'Original identity and actor registries execute with supplied nodes/actors. Actor flags and neutral tags change between frames; spectator false, QPC/clock and allocator boundaries adapted.')
(r/'tools/probe_fow_registered_map10_generated.py').write_text(s,encoding='utf-8')
exec(compile(s,'registered actors complete Map10 frames','exec'))
