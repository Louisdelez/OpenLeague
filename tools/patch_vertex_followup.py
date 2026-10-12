from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'tools/create_map_blender_source.py';s=p.read_text(encoding='utf-8-sig');s=s.replace("runpy.run_path(str(r/'tools/blender_native_fog.py'))", "runpy.run_path(str(r/'tools/blender_native_vertex_lighting.py'))\nrunpy.run_path(str(r/'tools/blender_native_fog.py'))");p.write_text(s,encoding='utf-8')
p=r/'tools/verify_map_blender_source.py';s=p.read_text(encoding='utf-8-sig');s+='''
factors=json.loads((r/'data/4.20/environment_lighting.json').read_text())['material_factors']
for name,factor in factors.items():
 mat=bpy.data.materials.get(name);assert mat is not None
 assert mat['Native_vertex_lighting_factor']==factor
 assert any(n.type=='VERTEX_COLOR' and n.layer_name==mat['Native_vertex_control_layer'] for n in mat.node_tree.nodes)
assert proof['imported_render_triangles']==1013104,proof['imported_render_triangles']
proof['native_vertex_lighting_materials_verified']=len(factors)
(r/'docs/map_blender_source_validation.json').write_text(json.dumps(proof,indent=2)+'\\n',encoding='utf-8')
print('BLENDER NATIVE VERTEX LIGHTING VERIFIED',len(factors),flush=True)
''';p.write_text(s,encoding='utf-8')
p=r/'tools/verify_native_fog_render.py';s=p.read_text(encoding='utf-8-sig');s=s.replace('triangles=[];uvs=[];uvs1=[];', 'controls=[];triangles=[];uvs=[];uvs1=[];');s=s.replace('triangles.append(points[indices]);', "controls.append(accessor(p['attributes']['COLOR_0'])[indices] if 'COLOR_0' in p['attributes'] else np.ones((len(indices),3,4)));triangles.append(points[indices]);");s=s.replace('triangles=np.concatenate(triangles);','controls=np.concatenate(controls);triangles=np.concatenate(triangles);');s=s.replace("'mesh':names[i]", "'vertex_control':(controls[i,0]*(1-u[i]-v[i])+controls[i,1]*u[i]+controls[i,2]*v[i]).tolist(),'mesh':names[i]");s=s.replace('checks=[];excluded=[]', "factors=json.loads((r/'data/4.20/environment_lighting.json').read_text())['material_factors']\nchecks=[];excluded=[]");s=s.replace("pred=np.array(visible['png_bilinear_rgba'][:3])*(1-amount)+fog*amount", "base=np.array(visible['png_bilinear_rgba'][:3]);factor=factors.get(visible['material'],0);base=np.clip(base*np.array(visible['vertex_control'][:3])*factor,0,255) if factor else base;pred=base*(1-amount)+fog*amount");p.write_text(s,encoding='utf-8')
