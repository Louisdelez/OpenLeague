from pathlib import Path
import json, struct, hashlib, datetime, collections
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0],'native setup','exec'))
prior=json.loads((r/'data/4.20/map10_shader_material_fields.json').read_text())
source=Path(prior['native_nvr']); data=source.read_bytes()
assert hashlib.sha256(data).hexdigest()==prior['native_nvr_sha256']
assert digest==prior['native_sha256']
count,vbc,ibc,mc,nc=struct.unpack_from('<5I',data,8)
material=heap+0x1e000; profiles=[]
for i in range(count):
 record=data[28+i*2988:28+(i+1)*2988]
 u.mem_write(material,record);write32(sp,end)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,material);u.reg_write(UC_X86_REG_EDX,5)
 u.emu_start(0x95b4d0,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 profiles.append(dict(index=i,name=record[:260].split(b'\0')[0].decode(),kind=struct.unpack_from('<i',record,260)[0],accepted=not bool(u.reg_read(UC_X86_REG_EAX)&255)))
offset=28+count*2988
for _ in range(vbc):offset+=4+struct.unpack_from('<I',data,offset)[0]
for _ in range(ibc):offset+=8+struct.unpack_from('<I',data,offset)[0]
meshes=[]
for i in range(mc):
 record=data[offset+i*100:offset+(i+1)*100];assert len(record)==100
 mid=struct.unpack_from('<I',record,48)[0];assert mid<count
 geometry=list(struct.unpack_from('<6I',record,76))
 meshes.append(dict(index=i,material=mid,material_accepted=profiles[mid]['accepted'],quality_field=struct.unpack_from('<i',record)[0],projection_geometry=geometry,index_count=geometry[-1]))
summary=dict(materials=count,materials_accepted=sum(p['accepted'] for p in profiles),meshes=mc,material_accepted_meshes=sum(m['material_accepted'] for m in meshes),accepted_nonempty_projection_meshes=sum(m['material_accepted'] and m['index_count']>0 for m in meshes),quality_fields=dict(collections.Counter(m['quality_field'] for m in meshes)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,nvr_sha256=prior['native_nvr_sha256'],material_loader_evidence='data/4.20/map10_shader_material_fields.json',entry='0x95b4d0',summary=summary,materials=profiles,meshes=meshes,limits=['Native material predicate executed on actual NVR material records; prior loader proof reused with matching hashes.','Object quality threshold, tree selection, buffer interpretation, GPU pixels and runtime integration remain unqualified. Counts are candidates, not final visible receivers.'])
(r/'data/4.20/map10_projected_receiver_inventory.json').write_text(json.dumps(proof,indent=2)+'\n')
next_action='Actual Map10 NVR material records executed through native projected material predicate; inventory data/4.20/map10_projected_receiver_inventory.json. Qualify object quality threshold and variant1 buffer geometry, then integrate actual legacy receiver selection instead of height-blend-only selection. Preserve full plan.'
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','goal_plan_revision.json']:
 path=r/'docs'/name;doc=json.loads(path.read_text(encoding='utf-8-sig'));doc['map10_projected_receiver_inventory']='data/4.20/map10_projected_receiver_inventory.json';doc['next_action']=next_action;path.write_text(json.dumps(doc,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps(summary))
