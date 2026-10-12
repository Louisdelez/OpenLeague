from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
actor=terrain+0x2000;model=terrain+0x5000;provider=terrain+0x6000;table=terrain+0x7000;bounds=terrain+0x8000;bounds_api=0xc9f3a8
samples=[];calls=[]
def boundary(uc,a,size,user):
 if a==bounds_api:
  assert u.reg_read(UC_X86_REG_ECX)==provider
  sample=samples[min(len(calls),len(samples)-1)];calls.append(sample)
  u.mem_write(bounds,struct.pack('<6f',*sample));s=u.reg_read(UC_X86_REG_ESP)
  u.reg_write(UC_X86_REG_EAX,bounds);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
profiles=[None,[[-20.,-5.,-10.,40.,65.,50.]],[[-20.,-5.,-10.,40.,65.,50.],[1.,2.,3.,101.,122.,143.],[-2.,-8.,-4.,6.,17.,16.],[3.,-11.,5.,19.,23.,29.]]]
cases=[]
for profile,position,model_scale,actor_scale in itertools.product(range(3),[[0.,0.,0.],[7684.,123.,6934.],[-30.,-17.,90.],[10000000.,-10000000.,10000000.]],[0.,.5,1.,2.],[-1.,0.,.75,2.]):
 u.mem_write(actor,bytes(0x2100));u.mem_write(model,bytes(0xb0))
 u.mem_write(actor+0x60,struct.pack('<3f',*position));f(actor+0x740,actor_scale)
 write32(actor+0x2068,model if profile else 0);write32(model+0xa4,provider);f(model+4,model_scale)
 write32(provider,table);write32(table+4,bounds_api)
 samples=profiles[profile] or [];calls.clear();u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 u.emu_start(0x6151a0,0x6152f8,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x6152f8
 cases.append(dict(profile=profile,position=position,model_scale=model_scale,actor_scale=actor_scale,bounds_calls=list(calls),aabb_bits=list(struct.unpack('<6I',u.mem_read(actor+0x95,24)))))
copy_cases=[]
for values in [[0,0x80000000,0x3f800000,0xbf800000,0x7f800000,0xff800000],[0x7fc12345,0xffc12345,0x7f812345,0xff812345,1,0x807fffff],[0x42c80000,0xc2c80000,0x3eaaaaab,0x4b800000,0x7f7fffff,0xff7fffff]]:
 u.mem_write(bounds,struct.pack('<6I',*values));write32(sp,end);write32(sp+4,bounds)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x716f60,0x716f9c,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x716f9c
 copy_cases.append(dict(input_bits=values,aabb_bits=list(struct.unpack('<6I',u.mem_read(actor+0x95,24)))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6151a0',stop='0x6152f8',copy_entry='0x716f60',copy_stop='0x716f9c',native_addresses=len(visited),profiles=profiles,cases=cases,copy_cases=copy_cases,runtime_adapters=['Model bounds provider virtual+4 returns explicit stable/changing sixfloat arrays; original method calls4times.'],limits=['Native AABB calculation prefix and sixfield copy execute through actual writes at actor+95..A9. Stop before71A5B0 spatial propagation and later metric updates.','Model/provider constructors, original model bounds getter/producers, actual actor calls, camera and live grass render integration remain open.'])
(r/'data/4.20/grass_actor_aabb_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),copy_cases=len(copy_cases),native_addresses=len(visited),copy_special=copy_cases[1])))
