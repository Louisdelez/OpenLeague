"""Native719930 position and719C50 owner-matrix fallback; lookup endpoints adapted."""
from pathlib import Path
import json,itertools,struct
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/probe_native_actor_effect_orientation.py').read_text().split('u.hook_add(unicorn.UC_HOOK_CODE,hook_owner)')[0]
exec(compile(setup,'orientation harness','exec'))
u.mem_map(0,0x10000) # explicit SEH chain storage for original prologues
actor_wrapper=vector+0xc000;actor_vt=vector+0xc100;matrix_ptr=vector+0xd000;getter=end+0x400
rows=[]
position=[123.5,-24.,9876.25];bone_position=[41.,52.,63.]
identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
matrices=[identity,[0.,0.,-2.,0.,0.,3.,0.,0.,4.,0.,0.,0.,123.,456.,789.,2.],[.25,0.,0.,0.,0.,-5.,0.,0.,0.,0.,99.,0.,0.,0.,0.,1.]]
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x886df0:
  assert read(sp+4)==hash_value
  if found:u.mem_write(read(sp+8),struct.pack('<3f',*bone_position))
  finish(int(found),8);return
 if a==0x719a90:
  if found:u.mem_write(read(sp+4),struct.pack('<16f',*identity))
  finish(int(found),4);return
 if a==getter:
  assert u.reg_read(UC_X86_REG_ECX)==actor_wrapper;finish(matrix_ptr);return
 hook_owner(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def invalid(uc,access,address,size,value,user):
 print("invalid",hex(uc.reg_read(UC_X86_REG_EIP)),hex(address));return False
u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid)
w(provider,vt);w(vt+0x24,0x718dd0);w(provider+4,handle);w(provider+8,control);w(handle,actor)
w(provider+0x24,actor_wrapper);w(actor_wrapper,actor_vt);w(actor_vt+0x20,getter)
u.mem_write(actor+0x60,struct.pack('<3f',*position))
try:
 for live,hash_value,model,found in itertools.product([False,True],[0,123],[False,True],[False,True]):
  w(control+4,2 if live else 0);w(control+8,2);w(provider+0x1c,actor if model else 0);w(provider+0x20,hash_value)
  u.mem_write(output,b'\xa5'*64);w(stack,end);w(stack+4,output);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,provider);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x719930,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
  ok=u.reg_read(UC_X86_REG_EAX)&255;words=list(struct.unpack('<3I',u.mem_read(output,12)))
  source='unavailable' if not live else ('owner' if hash_value==0 or (model and not found) else 'bone' if model else 'unchanged')
  expected=list(struct.unpack('<3I',struct.pack('<3f',*(position if source=='owner' else bone_position)))) if source in ['owner','bone'] else [0xa5a5a5a5]*3
  assert bool(ok)==live and words==expected,(source,words,expected)
  rows.append(dict(live=live,hash=hash_value,model=model,found=found,source=source,ok=ok,words=words))
 orientation=[]
 for live,found,matrix in itertools.product([False,True],[False,True],matrices):
  w(control+4,2 if live else 0);w(control+8,2);u.mem_write(matrix_ptr,struct.pack('<16f',*matrix));u.mem_write(output,b'\xa5'*64)
  w(stack,end);w(stack+4,output);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,provider);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x719c50,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
  ok=u.reg_read(UC_X86_REG_EAX)&255;words=list(struct.unpack('<16I',u.mem_read(output,64)))
  assert bool(ok)==live
  if not live or found:assert words==list(struct.unpack('<16I',struct.pack('<16f',*identity)))
  orientation.append(dict(live=live,found=found,input=matrix,ok=ok,words=words))
finally:k.VirtualFree(machine,0,0x8000)
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),position=rows,orientation=orientation,position_value=position,bone_position=bone_position,entries=['719930','719C50','718DD0','8DE500','718F70','716810'],cpu_rsqrt_operations=cpu_operations,adapters=['Original weak-owner functions execute with supplied control fields.','886DF0 bone lookup returns supplied success and XYZ;719A90 bone matrix getter returns supplied success and identity.','Actor virtual20 returns supplied matrix pointer; real copy and normalization execute, hardware RSQRTSS adapter reused.'],limits=['Skeleton name/hash lookup body not executed; absent Chain4-3 established separately by source inventory.','Full animation creation/caller binding and scene root mapping still need integration tests.','Missing model with nonzero hash leaves position output unchanged while returning success; do not conflate it with lookup failure.'])
(r/'data/4.20/animation_owner_fallback_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('PASS',len(rows),'position cases',len(orientation),'orientation cases',cpu_operations,'CPU rsqrt operations')
