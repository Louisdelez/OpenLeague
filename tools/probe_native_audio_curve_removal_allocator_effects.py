from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');base_script=(r/'tools/probe_native_audio_curve_removal_subscription.py').read_text(encoding='utf-8');exec(compile(base_script.split('\nu.hook_add(')[0],'setup','exec'))
original_hook=hook;mode='none';applied=False
# These are explicit supplied allocator/free effects, not recovered game allocator behavior.
def mutation_hook(uc,a,z,user):
 global applied
 if a not in [0xada670,0xada3e0]:return original_hook(uc,a,z,user)
 sp=u.reg_read(UC_X86_REG_ESP);ref=read(sp+8)if a==0xada3e0 else None;original_hook(uc,a,z,user);effects=[]
 if not applied:
  if a==0xada670 and mode=='allocate_free_head':w(manager+0x924,pending_free);effects=[{'reference':manager+0x924,'raw':bytes(u.mem_read(manager+0x924,4)).hex()}]
  if a==0xada670 and mode=='allocate_tail':w(manager+0x91c,pending);w(manager+0x920,pending);w(manager+0x930,1);effects=[{'reference':manager+off,'raw':bytes(u.mem_read(manager+off,4)).hex()}for off in[0x91c,0x920,0x930]]
  if a==0xada3e0 and ref==points and mode=='free_points_scribble':u.mem_write(points,bytes([0x5a])*24);effects=[{'reference':points,'raw':bytes(u.mem_read(points,24)).hex()}]
  if effects:applied=True
 calls[-1]['supplied_effects']=effects
u.hook_add(unicorn.UC_HOOK_CODE,mutation_hook);rows=[];layouts={'empty':[],'single':[33],'multiple':[33,44,55],'duplicate':[33,33,44]}
for pattern,layout,mode,failure in itertools.product([0,165],layouts,['none','allocate_free_head','allocate_tail','free_points_scribble'],[False,True]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 u.mem_write(manager,bytes(0x950));u.mem_write(curve,bytes(52));w(0x12100dc,19);w(manager+0x948,8);w(manager+0x92c,8);w(manager+0x938,curve);w(manager+0x93c,curve);w(manager+0x94c,1);w(curve+4,7);w(curve+8,0xabcdef01);w(curve+12,points);w(curve+16,2);w(curve+20,19);w(curve+40,0xffffffff)
 targets=layouts[layout]
 for j,t in enumerate(targets):a=bound+j*8;w(a,bound+(j+1)*8 if j+1<len(targets)else 0);w(a+4,t)
 w(curve+24,bound if targets else 0);w(curve+28,bound+(len(targets)-1)*8 if targets else 0);w(curve+44,len(targets));w(pending,0);w(pending+4,99);w(pending+8,99);w(pending_free,0);w(pending_free+4,77);w(pending_free+8,99)
 calls.clear();allocations.clear();freed.clear();index=0;applied=False;before=snapshot();u.mem_write(stack-0x1000,bytes(0x1100));w(stack,end);w(stack+4,7);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb11f20,end,count=5000);terminal=u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'layout':layout,'mode':mode,'failure':failure,'effect_applied':applied,'terminal':terminal,'before':before,'after':snapshot(),'calls':list(calls),'allocations':list(allocations),'freed':list(freed),'stopped_pc':u.reg_read(UC_X86_REG_EIP)})
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':sum(x['terminal']for x in rows),'instruction_limited_case_count':sum(not x['terminal']for x in rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Original B11F20/B131D0/B12870 with explicitly controlled allocator/free effects: changed pending free head or tail at allocation, scribble released point bytes. Each supplied effect logged. These stress contracts do not prove real game allocator mutation behavior.','Rust replay pending; all canonical before/after banks and entry calls retained; no runtime/global startup or physical audio claim.']}
(r/'data/4.20/audio_curve_removal_allocator_effects_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_curve_removal_allocator_effects.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'explicit allocator/free-effect cases;',p['terminal_case_count'],'terminal;',p['instruction_limited_case_count'],'limited')
