from pathlib import Path
import json,datetime,shutil,hashlib
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');backup=r/'docs/plan_history'/now;backup.mkdir(parents=True,exist_ok=True)
for name in ['tools/probe_native_simple_cycle.py','data/4.20/simple_cycle_contract.json','data/4.20/simple_owner_pose_contract.json']:
 p=r/name
 if p.is_file():shutil.copyfile(p,backup/p.name)
p=r/'tools/probe_native_simple_cycle.py';s=p.read_text(encoding='utf-8')
assert '(0x108,500.)' in s
s=s.replace('(0x108,500.)','(0xd8,500.),(0x108,0.)')
s=s.replace('rate1/life2/scale500','rate1/life2/scale500(d8)/rotationVelocity0(108)')
p.write_text(s,encoding='utf-8')
shutil.copyfile(p,Path('E:/mapslol3v3/probe_native_simple_cycle.py'))
doc={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'backup':str(backup),'correction':'Earlier full-cycle/owner fixtures patched definition108with500 and mislabeled it as particle scale. Native91E490/49C identifies108as p-rotvel; native91E3C3/3CF identifiesD8as p-scale. Earlier fixtures prove their recorded pose/life behavior only, not authored Annie scale500. New cycle fixture usesD8=500/108=0.','prior_position_lifetime_results_not_invalidated':True,'original_group_scale_is_500':True,'normal_render_bound':False}
(r/'docs/simple_scale_fixture_correction.json').write_text(json.dumps(doc,indent=2)+'\n')
for n in ['correct_simple_scale_fixture.py','probe_native_simple_owner_pose.py','discover_simple_size_rotation_readers.py','discover_system_pose_producer.py']:
 s=(Path('E:/mapslol3v3')/n).read_text(encoding='utf-8').replace('E:/OpenLeague/tools/inspect_owner_end.py','E:/OpenLeague/tools/inspect_owner_end.py')
 (r/'tools'/n).write_text(s,encoding='utf-8')
print(json.dumps(doc))
