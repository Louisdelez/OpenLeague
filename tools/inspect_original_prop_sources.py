import bpy,json,datetime
from pathlib import Path
r=Path('E:/OpenLeague');source=Path('E:/mapslol3v3/output/TwistedTreeline_Animated_v3/TwistedTreeline_Animated_v3.blend');bpy.ops.wm.open_mainfile(filepath=str(source),use_scripts=False)
c=bpy.data.collections['08_Original_Animated_Level_Props'];rows=[]
for o in c.all_objects:
 if o.type!='ARMATURE':continue
 parent=o
 while parent.parent is not None and not parent.get('source_asset'):parent=parent.parent
 meshes=[x for x in c.all_objects if x.type=='MESH' and any(m.type=='ARMATURE' and m.object==o for m in x.modifiers)]
 ad=o.animation_data
 rows.append({'armature':o.name,'mesh_objects':[x.name for x in meshes],'bone_count':len(o.data.bones),'native_asset':parent.get('source_asset'),'placement_parent':parent.name,'placement_source':parent.get('placement_source'),'parent_matrix_world':[list(x) for x in parent.matrix_world],'active_action':ad.action.name if ad and ad.action else None,'nla_actions':[st.action.name for tr in ad.nla_tracks for st in tr.strips] if ad else [],'root_parent':parent.name})
report={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_blend':str(source),'scene_fps':bpy.context.scene.render.fps,'props':rows};(r/'docs/map_blender_prop_sources.json').write_text(json.dumps(report,indent=2)+'\n');print('SOURCE MAP PROP ARMATURES',json.dumps(rows),flush=True)
