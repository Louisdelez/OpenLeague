"""Build a separate editable map with full native ambient loops; preserve static source."""
from pathlib import Path
import bpy,json,hashlib,datetime
from mathutils import Matrix
r=Path(__file__).resolve().parents[1];source=r/'artwork/maps/TwistedTreeline_OpenLeague.blend';out=r/'artwork/maps/TwistedTreeline_OpenLeague_Animated.blend'
manifest=json.loads((r/'data/4.20/map_ambient_manifest.json').read_text());props={p['placement_parent']:p for p in json.loads((r/'docs/map_blender_prop_sources.json').read_text())['props']}
bpy.ops.wm.open_mainfile(filepath=str(source),use_scripts=False);scene=bpy.context.scene;scene.render.fps=30
hidden=[]
for name in manifest['hidden_embedded_roots']:
 obj=bpy.data.objects.get(name);assert obj is not None,name
 for child in [obj,*obj.children_recursive]:child.hide_render=True;child.hide_set(True)
 hidden.append(name)
collection=bpy.data.collections.new('OpenLeague_Full_Native_Ambient');scene.collection.children.link(collection);report=[]
for p in manifest['placements']:
 before=set(bpy.data.objects);asset=manifest['assets'][p['native_asset']]
 bpy.ops.import_scene.gltf(filepath=str(r/'assets'/asset['asset']))
 imported=set(bpy.data.objects)-before;roots=[o for o in imported if o.parent is None]
 parent=bpy.data.objects.new('OpenLeagueAmbient::'+p['id'],None);collection.objects.link(parent);parent.matrix_world=Matrix(props[p['id']]['parent_matrix_world']);parent['native_asset']=p['native_asset'];parent['primary_native_clip']=asset['primary_name'];parent['native_duration_seconds']=asset['duration']
 bound=0;clip_names=[]
 for obj in imported:
  for c in list(obj.users_collection):c.objects.unlink(obj)
  collection.objects.link(obj)
  if obj in roots:obj.parent=parent
  if obj.animation_data:
   obj.animation_data.action=None
   selected=[]
   for track in obj.animation_data.nla_tracks:
    is_primary=track.name==asset['primary_name']
    if not is_primary:
     is_primary=any(strip.action and strip.action.name.split('.')[0]==asset['primary_name'] for strip in track.strips)
    track.mute=not is_primary
    if is_primary:
     selected.append(track)
     for strip in track.strips:
      clip_names.append(strip.action.name);strip.repeat=1000;strip.extrapolation='NOTHING';bound+=1
   assert len(selected)==1,(p['id'],obj.name,[t.name for t in obj.animation_data.nla_tracks])
 assert bound==1,(p['id'],bound)
 report.append({'id':p['id'],'native_asset':p['native_asset'],'primary_native_clip':asset['primary_name'],'duration_seconds':asset['duration'],'bound_strips':bound,'actions':clip_names,'objects':len(imported)})
scene.frame_start=1;scene.frame_end=800;scene.frame_set(1)
scene['OpenLeague_ambient_manifest_sha256']=hashlib.sha256((r/'data/4.20/map_ambient_manifest.json').read_bytes()).hexdigest();scene['Fidelity_limits']='Full native primary ambient loops; blend transitions, event particles/audio and native visual fidelity incomplete. Gameplay actors and state-driven altars remain separate Rust assets.'
for image in bpy.data.images:
 if image.type=='IMAGE' and image.size[0]>0 and not image.packed_file:image.pack()
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
# Reopen to verify persistent tracks and pose changes, not just import success.
bpy.ops.wm.open_mainfile(filepath=str(out),use_scripts=False);bpy.context.scene.frame_set(1);initial={}
for p in manifest['placements']:
 parent=bpy.data.objects['OpenLeagueAmbient::'+p['id']];rigs=[o for o in parent.children_recursive if o.type=='ARMATURE'];assert len(rigs)==1
 rig=rigs[0];initial[p['id']]={bone.name:bone.matrix.copy() for bone in rig.pose.bones}
bpy.context.scene.frame_set(47);moving=[]
for p in manifest['placements']:
 rig=next(o for o in bpy.data.objects['OpenLeagueAmbient::'+p['id']].children_recursive if o.type=='ARMATURE');changed=0;delta=0
 for bone in rig.pose.bones:
  before=initial[p['id']][bone.name];error=max(abs(bone.matrix[i][j]-before[i][j]) for i in range(4) for j in range(4));delta=max(delta,error);changed+=error>1e-5
 assert changed>0,p['id'];moving.append({'id':p['id'],'moving_pose_bones':changed,'maximum_pose_matrix_delta':delta})
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_blend':str(source),'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'blend_file':str(out),'blend_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'blender_version':bpy.app.version_string,'fps':30,'ambient_instances':report,'moving_after_reopen':moving,'suppressed_embedded_roots':hidden,'passed':True,'complete':False,'limits':['Primary full native loops saved/reopened and actual bones changed; event/blend graph/FX/audio remain incomplete.','Source static Blender file and installed map GLB preserved.','Independent state-driven gameplay actors and altars excluded from this decorative source.','Visual equivalence to original client remains unqualified.']}
(r/'docs/map_ambient_blender_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS EDITABLE FULL NATIVE AMBIENT',len(moving),str(out),flush=True)
