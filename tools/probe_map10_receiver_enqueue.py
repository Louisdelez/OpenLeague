from pathlib import Path
import json,struct,hashlib,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0],'native setup','exec'))
inventory=json.loads((r/'data/4.20/map10_projected_receiver_inventory.json').read_text())
prior=json.loads((r/'data/4.20/map10_shader_material_fields.json').read_text())
data=Path(prior['native_nvr']).read_bytes();assert hashlib.sha256(data).hexdigest()==inventory['nvr_sha256'];assert digest==inventory['native_sha256']
count,vbc,ibc,mc,nc=struct.unpack_from('<5I',data,8)
offset=28+count*2988
for _ in range(vbc):offset+=4+struct.unpack_from('<I',data,offset)[0]
for _ in range(ibc):offset+=8+struct.unpack_from('<I',data,offset)[0]
arena=heap+0x30000;u.mem_map(arena,0x100000)
renderer=arena;owner=arena+0x100;table=arena+0x200;materials=arena+0x1000;records=arena+0x50000
u.mem_write(records,data[offset:offset+mc*100])
for i in range(count):
 address=materials+i*0xc00;u.mem_write(address,data[28+i*2988:28+(i+1)*2988]);write32(table+4*i,address)
write32(owner+0x40,records);write32(owner+0x1c,table);write32(renderer+0x54,5);f(renderer+0x48,17.5)
packets=[]
def adapter(uc,a,size,user):
 if a==0xc975f5:finish();return
 if a==0x969940:
  assert u.reg_read(UC_X86_REG_ECX)==renderer+0x34
  ptr=read32(u.reg_read(UC_X86_REG_ESP)+4)
  packets.append(list(struct.unpack('<9I',u.mem_read(ptr,36))))
  finish(4)
u.hook_add(unicorn.UC_HOOK_CODE,adapter)
cases=[]
for threshold in [-100,-1,0,1,2,3]:
 for bind in [0,1]:
  packets.clear();write32(0x12258d8,threshold&0xffffffff)
  args=[end,owner,1,bind,0,mc]
  u.mem_write(sp,struct.pack('<6I',*args));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,renderer)
  u.emu_start(0x95b7f0,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
  expected=[];indices=[]
  for mesh in inventory['meshes']:
   if not mesh['material_accepted'] or mesh['quality_field']>=threshold:continue
   i=mesh['index'];record=data[offset+i*100:offset+(i+1)*100];g=mesh['projection_geometry']
   depth=struct.unpack_from('<f',record,44)[0]-17.5
   expected.append([mesh['material'] if bind else 0xffffffff,g[0],g[3],g[1],g[2],g[4],g[5]//3,1,struct.unpack('<I',struct.pack('<f',depth))[0]])
   indices.append(i)
  assert packets==expected,(threshold,bind,len(packets),len(expected))
  cases.append(dict(threshold=threshold,bind_material=bool(bind),queued=len(packets),mesh_indices=indices,packets_sha256=hashlib.sha256(json.dumps(packets).encode()).hexdigest()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,nvr_sha256=inventory['nvr_sha256'],entry='0x95b7f0',cases=cases,findings=['Original object loop and material predicate execute on all actual Map10 mesh records. Signed object field must be strictly below supplied global threshold.','Variant1 packet preserves NVR offsets4C,58,50,54,5C; triangle count is unsigned index count divided by3; material binding optional.'],adapters=['969940 queue insertion records first nine initialized packet words; allocator and renderer not executed.','C975F5 security cookie return adapted.'],limits=['Threshold values supplied; native configuration producer/default not yet qualified.','Full object range supplied; native rectangle/tree selection not executed.','Tenth packet word not initialized by this routine and deliberately excluded.','Buffer interpretation, clipping, GPU output and Rust integration remain pending.'])
(r/'data/4.20/map10_receiver_enqueue_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
next_action='Native95B7F0 object enqueue qualified against every actual Map10 mesh in12 threshold/material-binding combinations. Next resolve12258D8 producer/default and variant1 vertex/index buffers; integrate faithful receiver selection. Full plan preserved.'
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;doc=json.loads(path.read_text(encoding='utf-8-sig'));doc['map10_receiver_enqueue_contract']='data/4.20/map10_receiver_enqueue_contract.json';doc['next_action']=next_action;path.write_text(json.dumps(doc,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps([{'threshold':c['threshold'],'binding':c['bind_material'],'queued':c['queued']} for c in cases]))
