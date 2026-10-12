from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/probe_native_grass_spatial_extents.py').read_text(encoding='utf-8')
old="profiles=[[-5.,-7.,-9.,5.,7.,9.],[-1.,-2.,-2.,1.,2.,2.],[0.]*6,[5.,7.,9.,-5.,-7.,-9.]]"
assert old in s
s=s.replace(old,old[:-1]+",[-.1,-.2,-.3,.4,.5,.6],[1.,2.,3.,5.,9.,15.]]")
s=s.replace('grass_spatial_extents_contract.json','grass_spatial_extents_precise_contract.json')
exec(compile(s,'native asymmetric/repeated extents','exec'))
