from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
sources=vector+0x1000;owners=vector+0x3000;wrappers=vector+0x4000;calls=[];visited=set();freed=[]
regions=[('sources',sources,800),('owners',owners,320),('wrappers',wrappers,32)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,size,data):
 if a==0xafe5b0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'input_virtual9c','receiver':u.reg_read(UC_X86_REG_ECX),'selector':read(sp+4),'at_call':snap()});return
 if a==0xb01360:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'remove_parent_source','parent':u.reg_read(UC_X86_REG_ECX),'source':read(sp+4)});return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);reference=read(sp+8);assert reference not in freed;freed.append(reference);calls.append({'kind':'free','pool':read(sp+4),'reference':reference,'at_call':snap()});finish(1);return
 assert 0xafe5b0<=a<0xafe64e or 0xafe9c0<=a<0xafea21 or 0xafde90<=a<0xafdf1b or 0xb01360<=a<0xb013a2,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x12100dc,19);rows=[]
for pattern,root_count,parent_count,leaf_count,selector,route,duplicate in itertools.product([0,0xa5],[1,2],[1,2],[1,2],[0,1,3,0xffffffff],range(4),[False,True]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 for i in range(5):
  source=sources+i*160;owner=owners+i*64;w(source,0xff1cd8);w(source+28,owner);w(source+32,0);w(source+36,0);w(source+56,0)
  for pointer in [0,16,36]:w(owner+pointer,0)
  w(owner+4,0);w(owner+12,0);w(owner+40,0);u.mem_write(owner+48,bytes(8));u.mem_write(owner+50,(root_count if i==0 else leaf_count if i==4 else parent_count).to_bytes(2,'little'))
 for i in [1,2,3]:w(sources+i*160+32,sources+4*160)
 w(sources+32,sources+(1 if duplicate else 3)*160)
 if route in [1,3]:w(sources+36,sources+160)
 if route in [2,3]:w(sources+56,wrappers);w(wrappers,sources+(1 if duplicate else 2)*160)
 before=snap();calls.clear();freed.clear();w(stack,end);w(stack+4,selector);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,sources);u.emu_start(0xafe5b0,end,count=6000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'root_count':root_count,'parent_count':parent_count,'leaf_count':leaf_count,'selector':selector,'route':route,'duplicate':duplicate,'before':before,'after':snap(),'calls':list(calls),'freed':sorted(freed)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual SourceFF1CD8 AFE5B0 recursively executes five-node parent graph, including shared leaf and duplicate primary/secondary/wrapper parent references. Actual AFE9C0/B01360/AFDE90 owner retirement executes; parent calls are not controlled adapters.','Source classes, parent links and counter inputs supplied; producer constructor provenance remains unqualified. Parent child-tables and owner buffers are null; separate648 property-query cases qualify three-buffer destruction. Free ABI transport is controlled and captures physical snapshots. Cycles, other classes, malformed pointers, frame integration and physical playback remain open.']}
(r/'data/4.20/audio_path_source_input9c_recursive_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual recursive input9C source parent chains, shared-leaf and duplicate-parent retirement')
