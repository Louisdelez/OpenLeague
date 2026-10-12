from pathlib import Path
import json,struct,hashlib,datetime
exec(Path('E:/mapslol3v3/qualify_structure_native_pose.py').read_text().split('reports=[]')[0])
periods=json.loads((r/'data/4.20/structure_clip_period_contract.json').read_text());periods={m['model']:m for m in periods['models']}
u.mem_map(0,0x1000);write32(0,0xffffffff);u.mem_map(0x50000000,0x10000);allocation=0x50000000;boundaries=[]
runtime=terrain+0x5000;node=terrain+0x6000;manager=terrain+0x8000;vtable=terrain+0x8100;getter=0x400300
write32(manager,vtable);write32(vtable+0x10,getter)
def boundary(uc,address,size,user):
 global allocation
 if address not in [0x9933e0,getter]:return
 esp=uc.reg_read(UC_X86_REG_ESP);size=read32(esp+4);assert 0<size<128,(hex(address),size)
 pointer=allocation;allocation+=(size+15)&~15;assert allocation<0x50010000;u.mem_write(pointer,bytes((size+15)&~15))
 boundaries.append(dict(entry=hex(address),size=size,pointer=pointer))
 uc.reg_write(UC_X86_REG_EAX,pointer);uc.reg_write(UC_X86_REG_EIP,read32(esp));uc.reg_write(UC_X86_REG_ESP,esp+(12 if address==getter else 4))
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
def invalid(uc,access,address,size,value,user):
 print('unmapped',hex(uc.reg_read(UC_X86_REG_EIP)),hex(address),flush=True);return False
u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid)
records=[]
for m in sources:
 raw=Path(m['clip']).read_bytes();resource,hashes,frames,step,adapter=parsed_resource(raw);u.mem_write(clip,resource)
 g,b=glb(r/'assets'/m['asset']);names=[g['nodes'][j]['name'] for j in g['skins'][0]['joints']]
 # Native skeleton descriptor ABI, with exact exported rig joint names/hashes.
 u.mem_write(skeleton,bytes(0x1000));u.mem_write(skeleton+0xe,struct.pack('<H',len(names)));write32(skeleton+0x14,0x200);write32(skeleton+0x18,0x80)
 for order,(h,index) in enumerate(sorted((elf(name),i) for i,name in enumerate(names))):u.mem_write(skeleton+0x80+order*8,struct.pack('<HHI',index,0,h))
 for i,name in enumerate(names):write32(skeleton+0x200+100*i+8,elf(name))
 model=periods[m['alias']];blend=Path(model['blend']).read_bytes();assert hashlib.sha256(blend).hexdigest()==model['blend_sha256'];u.mem_write(node,blend)
 for state in model['states']:
  u.mem_write(runtime,bytes(0x80));payload=node+state['payload_offset'];write32(payload+0x10,clip)
  write32(sp,end)
  for i,value in enumerate([manager,skeleton,node+state['node_offset'],0]):write32(sp+4+i*4,value)
  u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,runtime);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
  u.emu_start(0x888d30,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
  assert read32(runtime)==0x10c8918 and read32(runtime+0x2c)==payload and read32(runtime+0x30)==0
  mapping_pointer=read32(runtime+0x38);indices=[read32(mapping_pointer+4*i) for i in range(len(names))];expected=[hashes.index(elf(name)) for name in names];assert indices==expected,(m['alias'],indices,expected)
  assert read32(runtime+0x3c)==0xbf800000 and read32(runtime+0xc)==0 and read32(runtime+0x10)==0x3f800000
  records.append(dict(model=m['alias'],state=state['name'],joint_mapping=indices,joint_names=names,native_vtable=hex(read32(runtime)),event_controller=read32(runtime+0x30),initial_elapsed_bits=read32(runtime+0xc),initial_speed_bits=read32(runtime+0x10),anm_adapter=adapter))
 print(m['alias'],flush=True)
report=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,native_constructor='0x888d30',native_joint_binding='0x893bc0',native_joint_lookup='0x894730',native_addresses=len(visited-{getter}),states=records,boundaries=dict(allocator_calls=sum(b['entry']=='0x9933e0' for b in boundaries),resource_buffer_calls=sum(b['entry']==hex(getter) for b in boundaries)),limits=['Full original simple-node derived constructor and original joint binding/lookup executed for48actual BLND states.','Allocator and resource buffer manager replaced by isolated memory adapters; native file/resource loader and memory manager not executed.','Skeleton descriptor explicitly supplied from exported rig names and source hashes. Native skeleton loader remains open.','Actual serialized atomic animation index resolved to supplied ANM evaluator resource by adapter.14legacy resources repacked;2original v4 resources used directly.','All authored state event references are zero. Nonzero event constructors and full state selection/blends remain open.'])
Path('E:/mapslol3v3/structure_native_construction_contract.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(dict(passed=True,states=len(records),native_addresses=report['native_addresses'],boundaries=report['boundaries'])))
