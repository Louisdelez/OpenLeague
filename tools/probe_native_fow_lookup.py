from pathlib import Path
import json,datetime,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
fog=heap+0x1f300;point=heap+0x1f800;buffer=heap+0x12000;dimension=128
write32(0x2d78a40,fog);write32(fog+0x10,dimension);write32(fog+0x14,buffer)
reads=[]
def read_mask(uc,access,address,size,value,user):
 if buffer<=address<buffer+dimension*dimension:reads.append((address-buffer,size))
u.hook_add(unicorn.UC_HOOK_MEM_READ,read_mask)
cases=[]
for extent in [256.,10000.,15398.671875]:
 u.mem_write(fog+0xc,struct.pack('<f',extent))
 for fx,fz in [(0.,0.),(0.125,0.25),(0.499999,0.5),(0.5,0.499999),(0.99999,0.99999),(0.008,0.008)]:
  x,z=struct.unpack('<2f',struct.pack('<2f',fx*extent,fz*extent));u.mem_write(point,struct.pack('<3f',x,0.,z))
  for mask in [0,1,128,255]:
   u.mem_write(buffer,bytes([mask])*(dimension*dimension));reads.clear();write32(sp,end);write32(sp+4,point);u.reg_write(UC_X86_REG_ESP,sp)
   u.emu_start(0x6b3f20,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
   expected=int(z/extent*dimension)*dimension+int(x/extent*dimension)
   assert reads==[(expected,1)],(reads,expected);result=u.reg_read(UC_X86_REG_EAX);assert result==int(mask==0)
   cases.append({'extent':extent,'dimension':dimension,'native_x':x,'native_z':z,'sample_index':expected,'mask_byte':mask,'returns_zero':bool(result)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b3f20','cases':cases,'original_instruction_addresses':len(visited),'runtime_adapters':[],'findings':['Original raw-buffer query truncates native positive X/Z scaled by dimension/extent. Row order uses positive native Z; shader c230 flips texture V separately.','Returns true exactly when the sampled mask byte is zero; this is a raw-mask query, not proof of GPU visibility-channel conversion.'],'limits':['Valid map bounds only; native lookup has no range guard. Client port must reject out-of-range inputs.','Raw-buffer meaning, server visibility generation, texture upload and blur/fade remain to qualify.']}
(r/'data/4.20/fow_lookup_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
