from pathlib import Path
import json,datetime,struct,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
source_object=heap+0x1f900;region=source_object+0x40;manager=heap+0x1fb00;counts=heap+0x12000;pixels=heap+0x8000;bits=heap+0x1a000
cases=[]
for shape,initial,pattern,applied in itertools.product([(8,[0,0,8,8]),(8,[1,2,5,6]),(128,[20,31,24,35])],[0,1,2,255],[0,1,2],[False,True]):
 dim,rect=shape;u.mem_write(source_object,bytes(0x80));u.mem_write(manager,bytes(0x40));write32(region,bits);write32(manager+0x10,dim);write32(manager+0x14,counts);write32(manager+0x18,pixels)
 mask=[0]*((dim*dim+31)//32)
 for index in range(dim*dim):
  if pattern==1 or pattern==2 and index%2==0:mask[index//32]|=1<<(index%32)
 u.mem_write(bits,struct.pack('<'+'I'*len(mask),*mask));u.mem_write(counts,bytes([initial])*dim*dim);u.mem_write(pixels,bytes([90])*dim*dim);u.mem_write(region+4,bytes([applied]))
 x0,z0,x1,z1=rect
 for offset,value in [(0xc,x0),(0x10,x1),(0x14,z0),(0x18,z1)]:write32(region+offset,value)
 outputs=[]
 for call in range(2):
  write32(sp,end);write32(sp+4,source_object);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager)
  u.emu_start(0x6b3ef0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
  c=bytes(u.mem_read(counts,dim*dim));v=bytes(u.mem_read(pixels,dim*dim));changes=[]
  for z in range(dim):
   for x in range(dim):
    at=z*dim+x;out=(dim-z-1)*dim+x;inside=x0<=x<x1 and z0<=z<z1;selected=pattern==1 or pattern==2 and at%2==0
    expected=max(0,initial-1) if applied and inside and selected else initial
    assert c[at]==expected and v[out]==((255 if expected else 0) if applied and inside else 90)
    if inside:changes.append(dict(index=at,texture_index=out,count=c[at],visibility=v[out]))
  outputs.append(dict(applied=bool(u.mem_read(region+4,1)[0]),changes=changes,outside_preserved=True))
 assert outputs[0]==outputs[1]
 cases.append(dict(dimension=dim,rect=rect,initial_count=initial,pattern=pattern,initial_applied=applied,outputs=outputs))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b3ef0',region_remove='0x6b2e60',native_addresses=len(visited),runtime_adapters=[],cases=cases,findings=['Original source retirement wrapper gates removal on source+44 and clears applied flag through original region removal.','Two calls per case remove contribution once only, preserve other overlapping counts and refresh all rectangle pixels on first applied removal.','Source+44 means applied region; source+45 is the separate generation invalidation flag.'],limits=['This qualifies source-wrapper counter rollback with supplied masks/manager arrays, not original removal queue/allocator/destructor.','Map10 source creation/team/activation, count scheduling and GPU integration remain open.'])
(r/'data/4.20/fow_source_retirement_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
