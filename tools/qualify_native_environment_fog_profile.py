from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0]
exec(compile(prefix,'native fog profile dispatcher','exec'))
callbacks=[];lod=[];subscriber_array=vector+0x6000;callback=end+0x100
for i in range(2):
 obj=vector+0x7000+i*0x100;vtable=obj+0x40;w(subscriber_array+i*4,obj);w(obj,vtable);w(vtable+8,callback)
def fog_profile_hook(uc,a,size,user):
 visited.add(a);sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x572c90:lod.append(uc.reg_read(UC_X86_REG_ECX));finish(0);return
 if a==callback:
  callbacks.append(dict(this=uc.reg_read(UC_X86_REG_ECX),enabled=read(sp+4)));finish(0,4);return
 assert 0x8376cc<=a<0x837729 or 0x987600<=a<0x987639,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,fog_profile_hook)
cases=[]
for value,previous,previous_fog,enabled,count,revision in itertools.product([-2147483648,-16,-1,0,1,2,3,4,5,16,2147483647],[-1,0,3,4],[0,1,2,3],[False,True],[0,2],[0,0xffffffff]):
 w(0x12258d8,previous);w(0x1225904,previous_fog);w(0x2d78fa8,revision);u.mem_write(0x14be79f,bytes([enabled]));u.mem_write(0x1224dd8,bytes([int(value<2)]))
 w(0x2d744b0,subscriber_array);w(0x2d744b4,subscriber_array+count*4)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ESI,value&0xffffffff);callbacks.clear();lod.clear()
 u.emu_start(0x8376cc,0x837729,count=2000);assert u.reg_read(UC_X86_REG_EIP)==0x837729
 quality=max(0,min(4,value));fog=1 if value<=1 else 2;new_revision=(revision+int(quality!=previous))&0xffffffff
 assert read(0x12258d8)==quality and read(0x1225904)==fog and read(0x2d78fa8)==new_revision
 assert bool(u.mem_read(0x1224dd8,1)[0])==(value>=2)
 expected_callbacks=[dict(this=vector+0x7000+i*0x100,enabled=int(enabled)) for i in range(count)] if fog!=previous_fog else []
 assert callbacks==expected_callbacks and lod==[value&0xffffffff]
 cases.append(dict(input=value,previous_environment=previous,previous_fog=previous_fog,initial_revision=revision,enabled=enabled,subscribers=count,environment_quality=quality,fog_quality=fog,clouds_enabled=value>=2,revision=new_revision,notifications=list(callbacks)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x8376cc',stop='0x837729',fog_setter='0x987600',cases=cases,case_count=len(cases),native_addresses=len(visited),
 findings=['Environment setting <=1 chooses single-layer fog1 and disables clouds; >=2 chooses dual-layer fog2 and enables clouds. No environment setting chooses vertex fog0 here.',
 'Environment value clamps0..4, while fog quality caps at2. Clouds predicate uses the original signed input, not a clamped dependent value.',
 'Original fog setter notifies each registered subscriber only when fog quality changes; notification carries current fog-enabled boolean, not cloud-enabled state. Revision only changes when environment quality changes.'],
 adapters=['Setting supplied in ESI; preceding option retrieval835080 and surrounding dispatcher body not executed.',
 'LOD setting572C90 boundary captures input; original dependent producer not executed.',
 'Subscriber objects/list supplied, original notification loop executes, callbacks observe enabled bool and return. No dependent shader rebuild executed.'],
 limits=['Original option identity, configuration retrieval, defaults, complete initialization order and final live user-selected profile remain open.',
 'Callback bodies, dependent shader rebuilds, LOD producer and full renderer/frame not qualified.',
 'Current runtime profile3/Fog2/clouds-on is consistent with this suffix, but evidence does not prove complete option integration.'])
(r/'data/4.20/native_environment_fog_profile_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),fog_low=1,fog_high=2,clouds_threshold=2)))
