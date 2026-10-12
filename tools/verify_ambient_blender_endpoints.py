from pathlib import Path
import bpy,json,hashlib
r=Path(__file__).resolve().parents[1];p=r/'artwork/maps/TwistedTreeline_OpenLeague_Animated.blend';bpy.ops.wm.open_mainfile(filepath=str(p),use_scripts=False);checks=[]
for parent in bpy.data.objects:
 if parent.get('native_asset')!='TT_Shopkeeper':continue
 assert abs(parent['native_duration_seconds']-15.000000953674316)<1e-5
 rig=next(o for o in parent.children_recursive if o.type=='ARMATURE');tracks=[t for t in rig.animation_data.nla_tracks if not t.mute];assert len(tracks)==1
 strip=tracks[0].strips[0];start,end=strip.action.frame_range;assert abs((end-start)/bpy.context.scene.render.fps-15)<1e-5,(parent.name,start,end)
 checks.append({'id':parent.name,'duration_seconds':parent['native_duration_seconds'],'action_start_frame':start,'action_end_frame':end,'repeat':strip.repeat})
assert len(checks)==2
(r/'docs/map_ambient_blender_endpoint_validation.json').write_text(json.dumps({'blend_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'checks':checks,'passed':True,'complete':False},indent=2)+'\n');print('PASS Blender saved endpoint: two shopkeepers, 450 frame intervals / 15 seconds')
