import bpy,json,datetime,hashlib
from pathlib import Path
from mathutils import Vector
r=Path('E:/OpenLeague');source=r/'artwork/maps/TwistedTreeline_OpenLeague.blend';bpy.ops.wm.open_mainfile(filepath=str(source),use_scripts=False)
scene=bpy.context.scene;scene.frame_set(scene.frame_start);scene.render.engine='BLENDER_EEVEE_NEXT';scene.render.resolution_x=640;scene.render.resolution_y=480;scene.render.resolution_percentage=100
scene.render.image_settings.file_format='PNG';scene.view_settings.view_transform='Standard';scene.view_settings.look='None';scene.view_settings.exposure=0;scene.view_settings.gamma=1
focus=Vector((12379.54296875,-8108.73095703125,0.));position=focus+Vector((1800.,-2600.,3600.));camera=bpy.data.cameras.new('HighFog_Diagnostic_Camera');obj=bpy.data.objects.new('HighFog_Diagnostic_Camera',camera);scene.collection.objects.link(obj);obj.location=position;obj.rotation_euler=(focus-position).to_track_quat('-Z','Y').to_euler();camera.lens=45;camera.clip_start=1;camera.clip_end=100000;scene.camera=obj
out=r/'logs/blender-high-fog-preview.png';scene.render.filepath=str(out);bpy.ops.render.render(write_still=True)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,source_blend=str(source),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),capture=str(out),capture_sha256=hashlib.sha256(out.read_bytes()).hexdigest(),camera_focus=list(focus),camera_position=list(position),resolution=[640,480],visual_inspected=False,limits=['Diagnostic Blender camera and fully visible FoW preview, not original runtime camera/state.','No save changed the verified source .blend; visual comparison and numeric renderer equivalence remain unqualified.'])
(r/'docs/blender_high_fog_preview.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('BLENDER_HIGH_FOG_PREVIEW',json.dumps(proof),flush=True)
