from pathlib import Path
import bpy,json,math
from mathutils import Vector
r=Path('E:/OpenLeague');report=json.loads((r/'docs/map10_destroyed_asset_recovery.json').read_text());bpy.ops.object.select_all(action='SELECT');bpy.ops.object.delete(use_global=False);scene=bpy.context.scene;scene.render.engine='BLENDER_EEVEE_NEXT';scene.render.resolution_x=1400;scene.render.resolution_y=1100;scene.render.resolution_percentage=100;scene.world.color=(.22,.22,.22);scene.view_settings.view_transform='Standard';records=[]
names=sorted(report['models']);locations=[(-3.2,3.2),(3.2,3.2),(-3.2,-3.2),(3.2,-3.2)];labels=['Nexus détruit','Tour détruite','Inhibiteur rouge','Inhibiteur bleu']
for name,(x,y),label in zip(names,locations,labels):
 source=report['models'][name];before=set(bpy.data.objects);bpy.ops.import_scene.gltf(filepath=str(r/'assets'/source['asset']));created=set(bpy.data.objects)-before;group=bpy.data.objects.new(name,None);scene.collection.objects.link(group)
 for obj in created:
  if obj.parent not in created:obj.parent=group
 scale=1. if source['skin_scale'] is None else float(source['skin_scale']);group.scale=(.01*scale,)*3;bpy.context.view_layer.update();points=[obj.matrix_world@Vector(corner) for obj in created if obj.type=='MESH' for corner in obj.bound_box];assert points
 low=Vector(tuple(min(p[i] for p in points) for i in range(3)));high=Vector(tuple(max(p[i] for p in points) for i in range(3)));group.location=(x-(low.x+high.x)/2,y-(low.y+high.y)/2,-low.z);bpy.context.view_layer.update()
 text=bpy.data.curves.new(label,'FONT');text.body=label;text.align_x='CENTER';text.size=.32;text.extrude=.001;obj=bpy.data.objects.new(label,text);scene.collection.objects.link(obj);obj.location=(x,y-2.45,.025)
 records.append(dict(model=name,asset=source['asset'],native_scale=scale,imported_meshes=sum(obj.type=='MESH' for obj in created),embedded_images=source['embedded_images'],preview_bounds=[list(low),list(high)]))
bpy.ops.mesh.primitive_plane_add(size=24,location=(0,0,-.02));plane=bpy.context.object;mat=bpy.data.materials.new('Preview floor');mat.diffuse_color=(.20,.23,.27,1);plane.data.materials.append(mat)
for location,power,size in [((0,-4,12),2200,10),((-7,4,9),1600,8),((7,7,9),1200,8)]:
 light=bpy.data.lights.new('Preview area','AREA');light.energy=power;light.shape='DISK';light.size=size;obj=bpy.data.objects.new('Preview area',light);scene.collection.objects.link(obj);obj.location=location;obj.rotation_euler=(Vector((0,0,0))-obj.location).to_track_quat('-Z','Y').to_euler()
camera=bpy.data.cameras.new('Review camera');obj=bpy.data.objects.new('Review camera',camera);scene.collection.objects.link(obj);obj.location=(0,-14,14);obj.rotation_euler=(Vector((0,0,.6))-obj.location).to_track_quat('-Z','Y').to_euler();camera.type='ORTHO';camera.ortho_scale=16;scene.camera=obj
out=r/'docs/review';out.mkdir(parents=True,exist_ok=True);scene.render.filepath=str(out/'native_destroyed_models.png');bpy.ops.wm.save_as_mainfile(filepath=str(out/'native_destroyed_models.blend'));bpy.ops.render.render(write_still=True)
(out/'native_destroyed_models.json').write_text(json.dumps(dict(complete=False,models=records,limits=['Blender gallery of exported original mesh/rig/texture resources; does not validate in-game shader response, animations or destruction gameplay.']),indent=2)+'\n',encoding='utf-8')
