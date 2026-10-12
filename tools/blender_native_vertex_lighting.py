"""Restore native non-lightmapped vertex controls in editable Blender materials."""
import bpy,json
from pathlib import Path
r=Path(__file__).resolve().parents[1]
factors=json.loads((r/'data/4.20/environment_lighting.json').read_text())['material_factors']
count=0
for name,factor in factors.items():
 mat=bpy.data.materials.get(name);assert mat is not None,name
 nodes=mat.node_tree.nodes;links=mat.node_tree.links
 textures=[n for n in nodes if n.type=='TEX_IMAGE'];assert len(textures)==1,(name,len(textures))
 emissions=[n for n in nodes if n.type=='EMISSION'];assert emissions,name
 users=[o for o in bpy.data.objects if o.type=='MESH' and any(m==mat for m in o.data.materials)]
 layers={o.data.color_attributes[0].name for o in users if o.data.color_attributes};assert len(layers)==1,(name,layers)
 color=nodes.new('ShaderNodeVertexColor');color.layer_name=next(iter(layers));color.label='Native primary times secondary control'
 def link(value,socket):
  if hasattr(value,'node'):links.new(value,socket)
  else:socket.default_value=value
 def math(op,a,b=0):
  n=nodes.new('ShaderNodeMath');n.operation=op;link(a,n.inputs[0]);link(b,n.inputs[1]);return n.outputs[0]
 def transfer(socket,linear):
  split=nodes.new('ShaderNodeSeparateXYZ');links.new(socket,split.inputs[0]);out=nodes.new('ShaderNodeCombineXYZ')
  for axis in ['X','Y','Z']:
   c=split.outputs[axis]
   if linear:
    hi=math('POWER',math('DIVIDE',math('ADD',c,.055),1.055),2.4);lo=math('DIVIDE',c,12.92);cond=math('GREATER_THAN',c,.04045)
   else:
    hi=math('SUBTRACT',math('MULTIPLY',math('POWER',math('MAXIMUM',c,0),1/2.4),1.055),.055);lo=math('MULTIPLY',c,12.92);cond=math('GREATER_THAN',c,.0031308)
   links.new(math('ADD',math('MULTIPLY',hi,cond),math('MULTIPLY',lo,math('SUBTRACT',1,cond))),out.inputs[axis])
  return out.outputs[0]
 # Retain the imported sRGB texture sampler, matching Rust linear filtering.
 display=transfer(textures[0].outputs['Color'],False)
 mul=nodes.new('ShaderNodeMixRGB');mul.blend_type='MULTIPLY';mul.inputs[0].default_value=1;links.new(display,mul.inputs[1]);links.new(color.outputs['Color'],mul.inputs[2])
 gain=nodes.new('ShaderNodeMixRGB');gain.blend_type='MULTIPLY';gain.inputs[0].default_value=1;gain.inputs[2].default_value=(factor,factor,factor,1);gain.use_clamp=True;links.new(mul.outputs[0],gain.inputs[1]);result=transfer(gain.outputs[0],True)
 for emission in emissions:links.new(result,emission.inputs['Color'])
 mat['Native_vertex_lighting_factor']=factor;mat['Native_vertex_control_layer']=color.layer_name
 count+=1
assert count==70,count
print('BLENDER NATIVE VERTEX LIGHTING MATERIALS',count,flush=True)
