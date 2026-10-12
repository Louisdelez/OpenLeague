"""Create an editable Blender environment source from the exact installed repaired GLB."""
import bpy,datetime,hashlib,json
from pathlib import Path
r=Path(__file__).resolve().parents[1];source=r/'assets/maps/twisted_treeline.glb';out=r/'artwork/maps/TwistedTreeline_OpenLeague.blend';out.parent.mkdir(parents=True,exist_ok=True)
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.gltf(filepath=str(source))
import runpy
runpy.run_path(str(r/'tools/blender_native_terrain.py'))
runpy.run_path(str(r/'tools/blender_native_vertex_lighting.py'))
runpy.run_path(str(r/'tools/blender_native_fog.py'))
settings=json.loads((r/'data/4.20/map_visual_settings.json').read_text(encoding='utf-8'));scene=bpy.context.scene
scene['OpenLeague_environment_source']=str(source);scene['OpenLeague_environment_sha256']=hashlib.sha256(source.read_bytes()).hexdigest();scene['Native_fog_rgb']=settings['native_fog_rgb'];scene['Fidelity_limits']='Editable environment only; runtime structures/champions/NPCs remain independent assets. Native height-blend shader nodes included; spatial transform, lighting, fog/shadows and visual acceptance incomplete.'
scene.world=bpy.data.worlds.new('Map10_NativeFog_Background');scene.world.use_nodes=True
rgb=[x/255 for x in settings['native_fog_rgb']];linear=[x/12.92 if x<=.04045 else ((x+.055)/1.055)**2.4 for x in rgb];scene.world.node_tree.nodes['Background'].inputs['Color'].default_value=(*linear,1.)
packed=0
for image in bpy.data.images:
 if image.type=='IMAGE' and image.size[0]>0:
  if not image.packed_file:image.pack()
  packed+=bool(image.packed_file)
meshes=[o for o in bpy.data.objects if o.type=='MESH'];triangles=sum(sum(len(p.vertices)-2 for p in o.data.polygons) for o in meshes)
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
proof={'passed':True,'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'blender_version':bpy.app.version_string,'source_glb':str(source),'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'blend_file':str(out),'blend_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'mesh_objects':len(meshes),'triangles':triangles,'packed_images':packed,'materials':len(bpy.data.materials),'limits':['Editable imported decorative environment source only; all Rust-spawned gameplay assets are separate.','Creation/import/save and counts do not prove complete map or original runtime/visual fidelity.','Old Blender projects preserved; no re-export changed the installed GLB.']}
(r/'docs/map_blender_source_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('OPENLEAGUE EDITABLE BLENDER SOURCE',json.dumps(proof),flush=True)
