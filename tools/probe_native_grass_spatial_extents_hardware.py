from pathlib import Path
import json
r=Path('E:/OpenLeague')
s=(r/'tools/probe_native_grass_spatial_extents.py').read_text(encoding='utf-8')
old="profiles=[[-5.,-7.,-9.,5.,7.,9.],[-1.,-2.,-2.,1.,2.,2.],[0.]*6,[5.,7.,9.,-5.,-7.,-9.]]";assert old in s
hardware='''estimates=dict(tuple(map(int,line.split())) for line in Path('E:/mapslol3v3/rsqrt-hardware-estimates.txt').read_text(encoding='utf-8-sig').splitlines())
def hardware_rsqrt(uc,a,size,user):
 if a==0x5fa7dd:
  value=uc.reg_read(UC_X86_REG_XMM3)&0xffffffff
  assert value in estimates,hex(value)
  current=uc.reg_read(UC_X86_REG_XMM1)
  uc.reg_write(UC_X86_REG_XMM1,(current&~0xffffffff)|estimates[value])
u.hook_add(unicorn.UC_HOOK_CODE,hardware_rsqrt)
'''
s=s.replace(old,hardware+old[:-1]+",[-.1,-.2,-.3,.4,.5,.6],[1.,2.,3.,5.,9.,15.]]")
s=s.replace('grass_spatial_extents_contract.json','grass_spatial_extents_hardware_contract.json')
exec(compile(s,'original extents with actualCPU rsqrt estimates','exec'))
p=r/'data/4.20/grass_spatial_extents_hardware_contract.json';d=json.loads(p.read_text(encoding='utf-8'))
d['rsqrt_estimates']=[dict(input_bits=k,estimate_bits=v) for k,v in sorted(estimates.items())]
d['runtime_adapters'].append('RSQRTSS result at5FA7DD supplied from same-PC x86_64 actual hardware intrinsic; remaining original refinement/math execute. No exactsqrt substitution.')
d['limits'].append('Qualification tied to captured same-PC RSQRTSS estimates/defaultcontrol modes; otherCPU estimates and hardwarex87 rounding boundaries require separate qualification.')
p.write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8')
