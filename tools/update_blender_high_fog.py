import bpy,json,struct,hashlib,datetime,shutil,sys
from pathlib import Path
from array import array
r=Path('E:/OpenLeague');settings=json.loads((r/'data/4.20/map_fog_settings.json').read_text(encoding='utf-8'));cloud=json.loads((r/'data/4.20/native_cloud_opacity_contract.json').read_text(encoding='utf-8'))
archive=r/'docs/plan_history'/('blender-high-fog-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
dds=r/'assets/maps/terrain_native/cloudOpacityMap.dds';shutil.copy2(cloud['texture_source'],dds)
d0=settings['fog_data0'];d1=settings['fog_data1'];extent=15398.671875
transform=json.loads((r/'data/4.20/terrain_transform_contract.json').read_text(encoding='utf-8'))['cases'][0]
c233=[struct.unpack('<f',struct.pack('<I',v))[0] for v in transform['uploaded_bits']]
def f(x):return struct.unpack('<f',struct.pack('<f',x))[0]
reports=[]
for filename in ['TwistedTreeline_OpenLeague.blend','TwistedTreeline_OpenLeague_Animated.blend']:
 path=r/'artwork/maps'/filename;shutil.copy2(path,archive/filename);bpy.ops.wm.open_mainfile(filepath=str(path),use_scripts=False)
 assert bpy.data.node_groups.get('Map10_Native_High_Fog') is None,'High fog already installed; rebuild baseline sources first to avoid stacking effects.'
 meshes=[o for o in bpy.data.objects if o.type=='MESH'];before_tri=sum(sum(len(p.vertices)-2 for p in o.data.polygons) for o in meshes)
 attributes=0
 for obj in meshes:
  if not any(m and m.name in settings['environment_materials'] for m in obj.data.materials):continue
  if obj.data.users>1:obj.data=obj.data.copy()
  m=obj.data;n=len(m.vertices);coords=array('f',[0.])*n*3;m.vertices.foreach_get('co',coords)
  top=array('f');far=array('f');fog_uv=array('f');cloud_uv=array('f');color_uv=array('f')
  matrix=obj.matrix_world
  for i in range(n):
   x,y,z=coords[i*3:i*3+3];p=matrix@__import__('mathutils').Vector((x,y,z));x,y,z=p
   # glTF Y-up -> Blender Z-up: native X=x, Y=z, Z=-y.
   h=max(0.,min(1.,z*d0[0]+d0[1]));top.append(f(1.-(d1[0]+(1.-d1[0])*h)));far.append(f(z*d1[1]+d1[2]))
   # Blender image V is bottom-up; invert the native shader V coordinate.
   fog_uv.extend((x/extent,-y/extent,0.));cloud_uv.extend((x/cloud['parameters']['Tile'],1.+y/cloud['parameters']['Tile'],0.))
   color_uv.extend((x*c233[0]+c233[2],1.-(-y*c233[1]+c233[3]),0.))
  for name,kind,values,field in [('OL_FogTop','FLOAT',top,'value'),('OL_FogFar','FLOAT',far,'value'),('OL_FogUV','FLOAT_VECTOR',fog_uv,'vector'),('OL_CloudUV','FLOAT_VECTOR',cloud_uv,'vector'),('OL_ColorUV','FLOAT_VECTOR',color_uv,'vector')]:
   if name in m.attributes:m.attributes.remove(m.attributes[name])
   a=m.attributes.new(name,kind,'POINT');a.data.foreach_set(field,values)
  attributes+=1
 group=bpy.data.node_groups.new('Map10_Native_High_Fog','ShaderNodeTree');group.interface.new_socket(name='Color',in_out='INPUT',socket_type='NodeSocketColor');group.interface.new_socket(name='Color',in_out='OUTPUT',socket_type='NodeSocketColor');nodes=group.nodes;links=group.links
 inside=nodes.new('NodeGroupInput');outside=nodes.new('NodeGroupOutput')
 old=(r/'tools/blender_native_fog.py').read_text(encoding='utf-8');exec(old[old.index('def link('):old.index('geometry=')])
 def attribute(name,output):
  n=nodes.new('ShaderNodeAttribute');n.attribute_name=name;return n.outputs[output]
 def texture(path,uv,tiled):
  im=bpy.data.images.load(str(path),check_existing=True);im.colorspace_settings.name='Non-Color'
  n=nodes.new('ShaderNodeTexImage');n.image=im;n.extension='REPEAT' if tiled else 'EXTEND';n.interpolation='Linear';links.new(uv,n.inputs['Vector']);return n
 def clamp(x):return math('MINIMUM',math('MAXIMUM',x,0),1)
 def mix(a,b,t):
  n=nodes.new('ShaderNodeMixRGB');n.blend_type='MIX';link(t,n.inputs[0]);link(a,n.inputs[1]);link(b,n.inputs[2]);return n.outputs[0]
 phase_u=nodes.new('ShaderNodeValue');phase_u.name='Native_Cloud_Phase_U';phase_v=nodes.new('ShaderNodeValue');phase_v.name='Native_Cloud_Phase_V'
 fps=bpy.context.scene.render.fps/bpy.context.scene.render.fps_base;u=v=0.;start=bpy.context.scene.frame_start;end=bpy.context.scene.frame_end
 for frame in range(start,end+1):
  if frame>start:
   u=f(u+f(1/fps)*cloud['parameters']['SpeedU']);v=f(v+f(1/fps)*cloud['parameters']['SpeedV'])
   if u>10:u=f(u-10)
   if v>10:v=f(v-10)
  for node,value in [(phase_u,u),(phase_v,-v)]:node.outputs[0].default_value=value;node.outputs[0].keyframe_insert('default_value',frame=frame)
 phase=nodes.new('ShaderNodeCombineXYZ');links.new(phase_u.outputs[0],phase.inputs['X']);links.new(phase_v.outputs[0],phase.inputs['Y'])
 add=nodes.new('ShaderNodeVectorMath');add.operation='ADD';links.new(attribute('OL_CloudUV','Vector'),add.inputs[0]);links.new(phase.outputs[0],add.inputs[1])
 fog=texture(r/'assets'/settings['fog_lighting'],attribute('OL_FogUV','Vector'),False)
 opacity=texture(dds,add.outputs[0],True);color=texture(r/'assets/maps/terrain_native/compositeColorMap.png',attribute('OL_ColorUV','Vector'),False)
 red=nodes.new('ShaderNodeSeparateColor');links.new(opacity.outputs['Color'],red.inputs['Color'])
 top=math('MULTIPLY',clamp(math('MULTIPLY',math('MULTIPLY',attribute('OL_FogTop','Fac'),color.outputs['Alpha']),2)),red.outputs['Red'])
 far=clamp(attribute('OL_FogFar','Fac'));amount=math('ADD',top,math('MULTIPLY',math('SUBTRACT',1,top),far))
 final=mix(transfer(inside.outputs['Color'],False),fog.outputs['Color'],amount);links.new(transfer(final,True),outside.inputs['Color'])
 group['limits']='Fully visible FoW preview only. POINT interpolants use native Map10 heights; Blender raster/mips/color management and original frame equivalence not qualified. Fixed-FPS baked native phase adapts runtime clock.'
 for i,n in enumerate(nodes):n.location=((i%12)*220,-(i//12)*240)
 count=0
 for name in settings['environment_materials']:
  mat=bpy.data.materials.get(name)
  if not mat:continue
  tree=mat.node_tree
  for emission in [n for n in tree.nodes if n.type=='EMISSION']:
   socket=emission.inputs['Color'];incoming=socket.links[0].from_socket if socket.links else None
   if incoming and incoming.node.type=='GROUP' and incoming.node.node_tree.name.startswith('Map10_Native_Opaque_Height_Fog'):
    low=incoming.node;incoming=low.inputs['Color'].links[0].from_socket;tree.nodes.remove(low)
   node=tree.nodes.new('ShaderNodeGroup');node.node_tree=group;node.label='Native high fog / Cloud2'
   if incoming:tree.links.new(incoming,node.inputs['Color'])
   tree.links.new(node.outputs['Color'],socket)
  mat['Native_fog_high_layer']=True;count+=1
 for im in bpy.data.images:
  if im.type=='IMAGE' and im.size[0]>0 and not im.packed_file:im.pack()
 cloud_image=opacity.image;assert bytes(cloud_image.packed_file.data)==dds.read_bytes()
 bpy.context.scene.frame_set(start);bpy.context.scene['Native_high_fog_limits']=group['limits'];bpy.ops.wm.save_as_mainfile(filepath=str(path),compress=True)
 bpy.ops.wm.open_mainfile(filepath=str(path),use_scripts=False);bpy.context.scene.frame_set(start)
 assert sum(bool(m.get('Native_fog_high_layer')) for m in bpy.data.materials)==count
 group=bpy.data.node_groups['Map10_Native_High_Fog'];assert abs(group.nodes['Native_Cloud_Phase_U'].outputs[0].default_value)<1e-7
 bpy.context.scene.frame_set(min(start+46,end));assert group.nodes['Native_Cloud_Phase_U'].outputs[0].default_value>0
 after_tri=sum(sum(len(p.vertices)-2 for p in o.data.polygons) for o in bpy.data.objects if o.type=='MESH');assert before_tri==after_tri
 reports.append(dict(file=str(path),sha256=hashlib.sha256(path.read_bytes()).hexdigest(),high_fog_materials=count,attributed_meshes=attributes,triangles_unchanged=True,cloud_dds_packed_byte_exact=True,phase_changes_after_reopen=True,fps=fps))
 print('BLENDER_HIGH_FOG_FILE',json.dumps(reports[-1]),flush=True)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,archive=str(archive),files=reports,limits=['Preview uses fully visible FoW; dynamic server visibility and complete material variant routing absent.','Attributes store native vertex top/far and texture mapping; screen radius term nonpositive for Map10. Blender interpolation and physical mip filtering require visual/numeric qualification.','Packed DDS retains original bytes; Blender mip selection is not proven to preserve source mip levels.','No GLB re-export or game executable changed. Animated ambient meshes and actions retained; full visual equivalence remains unqualified.'])
(r/'docs/blender_high_fog_progress.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('BLENDER_HIGH_FOG_DONE',flush=True)
