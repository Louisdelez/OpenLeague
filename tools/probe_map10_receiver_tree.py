from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_map10_receiver_enqueue.py').read_text().split('cases=[]')[0],'native enqueue setup','exec'))
node_offset=offset+mc*100
assert node_offset+nc*40==len(data),(node_offset,nc,len(data))
nodes=arena+0x90000;rectangle=arena+0xf0000
u.mem_write(nodes,data[node_offset:]);write32(owner+0x4c,nodes)
decoded=[struct.unpack_from('<6f4I',data,node_offset+i*40) for i in range(nc)]
for node in decoded:
 assert node[6]+node[7]<=mc and (node[9]==0 or node[8]+node[9]<=nc)
def selection(index,bounds,seen=None):
 seen=set() if seen is None else seen
 assert index not in seen;seen.add(index)
 node=decoded[index];xmin,zmin,xmax,zmax=bounds
 if node[3]<xmin or node[0]>xmax or node[5]<zmin or node[2]>zmax:return []
 inside=node[0]>=xmin and node[3]<=xmax and node[2]>=zmin and node[5]<=zmax
 if inside or node[9]==0:return list(range(node[6],node[6]+node[7]))
 result=[]
 for child in range(node[8],node[8]+node[9]):result+=selection(child,bounds,seen)
 return result
root=decoded[-1];rectangles=[[-100000,-100000,100000,100000],[-10000,-10000,-9000,-9000],[root[0],root[2],root[3],root[5]]]
for x in [0,3000,6000,9000,12000,15000]:
 for z in [0,3000,6000,9000,12000,15000]:rectangles.append([x-500,z-500,x+500,z+500])
cases=[]
for rect in rectangles:
 for threshold in [0,1,2,3,4]:
  packets.clear();write32(0x12258d8,threshold);u.mem_write(rectangle,struct.pack('<4f',*rect))
  u.mem_write(sp,struct.pack('<6I',end,nc-1,owner,1,0,rectangle));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,renderer)
  u.emu_start(0x95b670,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
  selected=selection(nc-1,rect);expected=[];accepted=[]
  for i in selected:
   mesh=inventory['meshes'][i]
   if not mesh['material_accepted'] or mesh['quality_field']>=threshold:continue
   record=data[offset+i*100:offset+(i+1)*100];g=mesh['projection_geometry'];depth=struct.unpack_from('<f',record,44)[0]-17.5
   expected.append([0xffffffff,g[0],g[3],g[1],g[2],g[4],g[5]//3,1,struct.unpack('<I',struct.pack('<f',depth))[0]]);accepted.append(i)
  assert packets==expected,(rect,threshold,len(packets),len(expected))
  cases.append(dict(rectangle=rect,threshold=threshold,selected_meshes=selected,queued_meshes=accepted,packets_sha256=hashlib.sha256(json.dumps(packets).encode()).hexdigest()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,passed=True,native_sha256=digest,nvr_sha256=inventory['nvr_sha256'],entry='0x95b670',node_count=nc,root_node=nc-1,cases=cases,findings=['Original recursive rectangle traversal, material predicate and object enqueue execute together against actual Map10 tree and records.','Fully enclosed nodes enqueue their complete object range; intersecting nodes recurse until leaves; touching edges are included. No per-object rectangle check in this route.'],adapters=['Queue insertion captures initialized packet words; security cookie bypass only. Rectangle and quality threshold supplied.'],limits=['Original caller rectangle generation, buffer declaration, GPU and Rust integration remain separate qualification steps.','Supplied quality profiles0..4; actual user setting not recovered.'])
(r/'data/4.20/map10_receiver_tree_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
next_action='Native rectangle tree traversal95B670 and object enqueue95B7F0 jointly verified on actual Map10 tree across195 rectangle/quality cases. Integrate node-range receiver selection and native variant1 geometry, preserving inclusive edges and whole leaf ranges; qualify native buffer declaration and GPU output. Full scope preserved.'
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;doc=json.loads(path.read_text(encoding='utf-8-sig'));doc['map10_receiver_tree_contract']='data/4.20/map10_receiver_tree_contract.json';doc['next_action']=next_action;path.write_text(json.dumps(doc,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps(dict(nodes=nc,cases=len(cases),passed=True)))
