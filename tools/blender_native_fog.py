"""Editable low-height native fog group, matching the current Rust adapter."""
import bpy,json
from pathlib import Path
r=Path(__file__).resolve().parents[1];settings=json.loads((r/'data/4.20/map_fog_settings.json').read_text(encoding='utf-8'))
group=bpy.data.node_groups.new('Map10_Native_Opaque_Height_Fog','ShaderNodeTree');group.interface.new_socket(name='Color',in_out='INPUT',socket_type='NodeSocketColor');group.interface.new_socket(name='Color',in_out='OUTPUT',socket_type='NodeSocketColor');nodes=group.nodes;links=group.links
inside=nodes.new('NodeGroupInput');outside=nodes.new('NodeGroupOutput')
def link(v,s):
 if hasattr(v,'node'):links.new(v,s)
 else:s.default_value=v
def math(op,a,b=0):
 n=nodes.new('ShaderNodeMath');n.operation=op;link(a,n.inputs[0]);link(b,n.inputs[1]);return n.outputs[0]
def transfer(color,linear):
 split=nodes.new('ShaderNodeSeparateXYZ');links.new(color,split.inputs[0]);combine=nodes.new('ShaderNodeCombineXYZ')
 for axis in ['X','Y','Z']:
  c=split.outputs[axis]
  if linear:
   high=math('POWER',math('DIVIDE',math('ADD',c,.055),1.055),2.4);low=math('DIVIDE',c,12.92);condition=math('GREATER_THAN',c,.04045)
  else:
   high=math('SUBTRACT',math('MULTIPLY',math('POWER',math('MAXIMUM',c,0),1/2.4),1.055),.055);low=math('MULTIPLY',c,12.92);condition=math('GREATER_THAN',c,.0031308)
  x=math('ADD',math('MULTIPLY',high,condition),math('MULTIPLY',low,math('SUBTRACT',1,condition)));links.new(x,combine.inputs[axis])
 return combine.outputs[0]
geometry=nodes.new('ShaderNodeNewGeometry');split=nodes.new('ShaderNodeSeparateXYZ');links.new(geometry.outputs['Position'],split.inputs[0]);height=split.outputs['Z']
amount=math('MINIMUM',math('MAXIMUM',math('ADD',math('MULTIPLY',height,settings['fog_data1'][1]),settings['fog_data1'][2]),0),1)
uv=nodes.new('ShaderNodeCombineXYZ');links.new(math('DIVIDE',split.outputs['X'],settings['spatial_denominator']),uv.inputs['X']);links.new(math('DIVIDE',math('MULTIPLY',split.outputs['Y'],-1),settings['spatial_denominator']),uv.inputs['Y'])
im=bpy.data.images.load(str(r/'assets'/settings['fog_lighting']),check_existing=True);im.colorspace_settings.name='Non-Color';texture=nodes.new('ShaderNodeTexImage');texture.image=im;texture.extension='EXTEND';texture.interpolation='Linear';links.new(uv.outputs[0],texture.inputs['Vector'])
mix=nodes.new('ShaderNodeMixRGB');mix.blend_type='MIX';links.new(amount,mix.inputs[0]);links.new(transfer(inside.outputs['Color'],False),mix.inputs[1]);links.new(texture.outputs['Color'],mix.inputs[2]);links.new(transfer(mix.outputs[0],True),outside.inputs['Color'])
for i,n in enumerate(nodes):n.location=((i%12)*220,-(i//12)*240)
group['native_fog_data1']=settings['fog_data1'];group['limits']='Low opaque-height layer only; high top layer remains separate; it is not identically zero for Map10. Spatial UV/variant/gamma remain unqualified.'
count=0
for name in settings['environment_materials']:
 mat=bpy.data.materials.get(name)
 if mat is None:continue
 emissions=[n for n in mat.node_tree.nodes if n.type=='EMISSION'];assert emissions,name
 for emission in emissions:
  socket=emission.inputs['Color'];incoming=socket.links[0].from_socket if socket.links else None
  n=mat.node_tree.nodes.new('ShaderNodeGroup');n.node_tree=group;n.label='Native low-height fog';n.location=(emission.location.x-250,emission.location.y-300)
  if incoming:mat.node_tree.links.new(incoming,n.inputs['Color'])
  else:n.inputs['Color'].default_value=socket.default_value
  mat.node_tree.links.new(n.outputs['Color'],socket)
 mat['Native_fog_low_layer']=True;count+=1
print('BLENDER NATIVE LOW FOG MATERIALS',count,flush=True)
