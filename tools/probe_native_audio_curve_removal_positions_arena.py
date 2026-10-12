from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');base_script=(r/'tools/probe_native_audio_curve_removal_subscription.py').read_text(encoding='utf-8');exec(compile(base_script.split('\nu.hook_add(')[0],'setup','exec'))
other=vector+0x4000;arena=vector+0xd000;regions.extend([('other_curves',other,104),('arena',arena,24)])
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[];layouts={'empty':[],'single':[33],'multiple':[33,44,55],'null_duplicate':[0,33,33]}
for pattern,position,layout,embedded,failure,initial_pending in itertools.product([0,165],['head','interior','tail','missing'],layouts,[False,True],[False,True],[False,True]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 u.mem_write(manager,bytes(0x950));u.mem_write(curve,bytes(52));u.mem_write(other,bytes(104));w(0x12100dc,19);w(manager+0x948,8);w(manager+0x92c,8)
 refs={'head':[curve,other,other+52],'interior':[other,curve,other+52],'tail':[other,other+52,curve],'missing':[other,other+52]}[position]
 for j,a in enumerate(refs):w(a,refs[j+1]if j+1<len(refs)else 0);w(a+4,7 if a==curve else 99+j)
 w(manager+0x938,refs[0]);w(manager+0x93c,refs[-1]);w(manager+0x94c,len(refs));w(curve+4,7);w(curve+8,0xabcdef01);w(curve+12,points);w(curve+16,2);w(curve+20,19);w(curve+40,0xffffffff)
 targets=layouts[layout];storage=arena if embedded else bound
 for j,t in enumerate(targets):a=storage+j*8;w(a,storage+(j+1)*8 if j+1<len(targets)else 0);w(a+4,t)
 w(curve+24,storage if targets else 0);w(curve+28,storage+(len(targets)-1)*8 if targets else 0);w(curve+44,len(targets))
 if embedded:w(curve+36,3);w(curve+48,arena)
 if initial_pending:w(manager+0x91c,pending);w(manager+0x920,pending);w(manager+0x930,1);w(pending,0);w(pending+4,33);w(pending+8,99)
 calls.clear();allocations.clear();freed.clear();index=0;before=snapshot();u.mem_write(stack-0x1000,bytes(0x1100));w(stack,end);w(stack+4,7);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb11f20,end,count=5000);terminal=u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'position':position,'layout':layout,'embedded':embedded,'failure':failure,'initial_pending':initial_pending,'terminal':terminal,'before':before,'after':snapshot(),'calls':list(calls),'allocations':list(allocations),'freed':list(freed),'stopped_pc':u.reg_read(UC_X86_REG_EIP)})
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':sum(x['terminal']for x in rows),'instruction_limited_case_count':sum(not x['terminal']for x in rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Actual B11F20/B131D0/B12870 execute; allocator/free ABI only. Three curve positions plus missing-key; NULL/duplicate recipient and real24byte arena cleanup; original snapshots and termination captured.','Rust replay not yet added. Allocator mutations, multiple-curves containing other bound targets and malformed tables remain separate.']}
(r/'data/4.20/audio_curve_removal_positions_arena_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_curve_removal_positions_arena.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'position/NULL/duplicate/arena removals;',p['terminal_case_count'],'terminal;',p['instruction_limited_case_count'],'limited')
