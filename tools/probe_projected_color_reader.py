from pathlib import Path
import json,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0],'native setup','exec'))
values={};calls=[]
def string(a):return bytes(u.mem_read(a,80)).split(b'\0')[0].decode()
def hook(uc,a,size,user):
 if a not in [0x8b0630,0xc98a11,0x8b24d0]:return
 top=u.reg_read(UC_X86_REG_ESP)
 if a==0x8b0630:
  key=string(u.reg_read(UC_X86_REG_EDX));v=values.get(key,string(read32(top+4)));u.mem_write(read32(top+8),v.encode()+b'\0');calls.append(key)
 elif a==0xc98a11:
  v=[int(x) for x in string(read32(top+4)).split()];assert len(v)==2
  write32(read32(top+12),v[0]);write32(read32(top+16),v[1]);u.reg_write(UC_X86_REG_EAX,2)
 else:
  key=string(read32(top+8));v=values.get(key,floats(read32(top+12),2));dest=u.reg_read(UC_X86_REG_ECX);u.mem_write(dest,struct.pack('<2f',*v));u.reg_write(UC_X86_REG_EAX,dest);calls.append(key)
 u.reg_write(UC_X86_REG_EIP,read32(top));u.reg_write(UC_X86_REG_ESP,top+4)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for values in [{},{'p-colortype':'3 2','p-colorscale':[2.,-1.],'p-coloroffset':[.25,-.5]}]:
 for previous in [0,0xa5a5a5a5]:
  for o in range(0x1e4,0x1fc,4):write32(definition+o,previous)
  calls.clear();u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBX,definition);u.reg_write(UC_X86_REG_ESI,0);u.reg_write(UC_X86_REG_EDI,0)
  u.emu_start(0x91ec5b,0x91ed2e,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x91ed2e
  modes=[read32(definition+o) for o in [0x1e4,0x1e8]];coeff=floats(definition+0x1ec,4)
  assert modes==[int(x) for x in values.get('p-colortype','1 0').split()]
  assert coeff==values.get('p-colorscale',[1.,1.])+values.get('p-coloroffset',[0.,0.])
  rows.append(dict(authored=values,modes=modes,coefficients=coeff,previous=previous))
p=dict(passed=True,complete=False,native_sha256=digest,cases=rows,entry='91EC5B',stop='91ED2E',adapters=['String lookup, sscanf and Vec2 resource lookup adapted. Native caller defaults, argument transport and storage writes executed.'],limits=['Full parser and texture upload not executed.'])
(r/'data/4.20/projected_color_reader_contract.json').write_text(json.dumps(p,indent=2)+'\n');print('PASS',len(rows))
