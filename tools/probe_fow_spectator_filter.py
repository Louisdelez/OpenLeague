from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/probe_fow_team_filter_generated.py').read_text(encoding='utf-8')
s=s.replace('[0x6b4175,0x6b418f,0x6b41de,0x6b420a,0x6b439b]', '[0x6b3fe7,0x6b4175,0x6b418f,0x6b41de,0x6b420a,0x6b439b,0x6b2c41]')
s=s.replace("adapters.append('spectator_false');u.reg_write(UC_X86_REG_EAX,0)", "adapters.append('spectator_true');u.reg_write(UC_X86_REG_EAX,1)")
old="for source_tag,presence,actor_tag,flag_ad,flag_118,flag_24,flag_2c,applied in itertools.product([100,200,300],['absent_registration','absent_actor','actor'],[100,200,300],[False,True],[False,True],[False,True],[False,True],[False,True]):"
new="for mode,visibility_bits,source_tag,presence,actor_tag,flag_24,flag_2c,applied in itertools.product([-2,-1,0,1],[0,1,2,3],[100,200,300],['absent_registration','absent_actor','actor'],[100,300],[False,True],[False,True],[False,True]):\n flag_ad=True;flag_118=False;write32(0x1223ebc,mode & 0xffffffff)"
assert old in s;s=s.replace(old,new)
s=s.replace('(0x2d77f48,player)','(0x2d77f48,0)')
s=s.replace('for address,value in [(actor+0xad,flag_ad)', 'write32(descriptor+0x28,visibility_bits)\n  for address,value in [(actor+0xad,flag_ad)')
s=s.replace('cases.append(dict(source_tag=source_tag,', 'cases.append(dict(mode=mode,visibility_bits=visibility_bits,source_tag=source_tag,')
s=s.replace('fow_team_filter_contract.json','fow_spectator_filter_contract.json')
s=s.replace('0x6b4175,0x6b418f,0x6b41de,0x6b420a,0x6b439b,0x993d0f', '0x6b3fe7,0x6b4175,0x6b418f,0x6b41de,0x6b420a,0x6b439b,0x6b2c41,0x993d0f')
s=s.replace('Source tags100/200/300 with local tag100 and spectator false supplied at five virtual call sites;', 'Source tags100/200/300 with player absent; original mode-to-team conversion executes for -2/-1/0/1. Spectator true supplied at seven virtual call sites. Original6B2C30 descriptor28 visibility-bit query and6B3EF0 neutral-source withdrawal execute;')
(r/'tools/probe_fow_spectator_filter_generated.py').write_text(s,encoding='utf-8')
exec(compile(s,'native spectator filter','exec'))
