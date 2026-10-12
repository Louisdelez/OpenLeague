from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
obj=heap+0x1f300;desc=heap+0x1f500;calls=[];cases=[]
def leaf(uc,address,size,user):
 if address==0x6b09e0:
  top=uc.reg_read(UC_X86_REG_ESP)
  delta=list(struct.unpack('<2f',uc.mem_read(top+4,8)));origin=list(struct.unpack('<2f',uc.mem_read(top+16,8)))
  assert read32(top+24)==desc
  calls.append({'origin':origin,'delta':delta});finish(24)
u.hook_add(unicorn.UC_HOOK_CODE,leaf)
for dim in [8,128]:
 write32(desc+8,dim);n=float(dim);mid=n/2
 segments=[([mid,mid],[n-2,mid]),([mid,mid],[mid,mid]),([0.,mid],[n,mid]),([n+1,mid],[mid,mid]),([mid,mid],[n+1,mid]),([-1.,-1.],[n,n]),([n,n],[-1.,-1.]),([-2.,mid],[-1.,mid]),([mid,-2.],[mid,-1.]),([mid,n+1],[mid,n+2]),([n+1,mid],[n+2,mid]),([1.,1.],[n-1,n-1]),([0.,0.],[0.,n]),([mid,0.],[mid,n]),([mid,n],[mid,0.]),([0.,n],[n,0.]),([0.,mid],[mid,0.]),([mid,mid],[mid+0.000001,mid]),([n+2,n+1],[mid,mid]),([mid,mid],[n+2,n+1])]
 for origin,end_point in segments:
  calls.clear();write32(sp,end);u.mem_write(sp+4,struct.pack('<4f',*origin,*end_point));write32(sp+20,0);write32(sp+24,desc)
  u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj)
  u.emu_start(0x6b0db0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;assert len(calls)<=1
  cases.append({'dimension':dim,'origin':origin,'end':end_point,'clipped':calls[0] if calls else None})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b0db0','epsilon':floats(0x1138a58,1)[0],'cases':cases,'original_instruction_addresses':len(visited),'runtime_adapters':[{'address':'0x6b09e0','purpose':'Record clipped segment arguments at terrain tracing boundary; skip actual terrain traversal, return with original stack convention.'}],'limits':['Original full clipping math executed; downstream terrain tracing deliberately skipped and not qualified.','Terrain flags, height source and complete occluded mask generation remain open.']}
(r/'data/4.20/fow_ray_clip_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'epsilon':proof['epsilon'],'native_addresses':len(visited),'sample':cases[:5]}))
