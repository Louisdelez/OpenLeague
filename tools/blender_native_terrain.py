"""Build editable equivalents of the Rust native height-blend material nodes."""
import bpy,json
from pathlib import Path
r=Path(__file__).resolve().parents[1]
settings=json.loads((r/'data/4.20/terrain_materials.json').read_text(encoding='utf-8'))
for entry in settings['terrain_materials']:
 mat=bpy.data.materials.get(entry['name']);assert mat is not None
 obj=next(o for o in bpy.data.objects if o.type=='MESH' and any(m==mat for m in o.data.materials));uv_names=[x.name for x in obj.data.uv_layers];assert len(uv_names)>=2
 mat.use_nodes=True;tree=mat.node_tree;tree.nodes.clear();nodes=tree.nodes;links=tree.links
 def node(kind,label):
  x=nodes.new(kind);x.label=label;return x
 def link(value,socket):
  if hasattr(value,'node'):links.new(value,socket)
  else:socket.default_value=value
 def math(op,a,b=0,label=''):
  x=node('ShaderNodeMath',label or op);x.operation=op;link(a,x.inputs[0]);link(b,x.inputs[1]);return x.outputs[0]
 def vec(op,a,b=None,scale=None):
  x=node('ShaderNodeVectorMath',op);x.operation=op;link(a,x.inputs[0])
  if b is not None:link(b,x.inputs[1])
  if scale is not None:link(scale,x.inputs[3])
  return x.outputs[0]
 def clamp(a):return math('MINIMUM',math('MAXIMUM',a,0),1)
 uv0=node('ShaderNodeUVMap','Native tile UV');uv0.uv_map=uv_names[0]
 uv1=node('ShaderNodeUVMap','Spatial UV: reconstructed xz/15360');uv1.uv_map=uv_names[1]
 def texture(path,uv,tile):
  im=bpy.data.images.load(str(r/'assets'/path),check_existing=True);im.colorspace_settings.name='Non-Color';x=node('ShaderNodeTexImage',Path(path).stem);x.image=im;x.extension='REPEAT' if tile else 'EXTEND';x.interpolation='Linear';links.new(uv.outputs['UV'],x.inputs['Vector']);return x
 layers=[texture(p,uv0,True) for p in entry['layers']];height_map=texture(settings['height_map'],uv1,False);color_map=texture(settings['colormap'],uv1,False)
 separate=node('ShaderNodeSeparateColor','RGBA height scale');links.new(height_map.outputs['Color'],separate.inputs['Color']);channels=[separate.outputs['Red'],separate.outputs['Green'],separate.outputs['Blue'],height_map.outputs['Alpha']]
 heights=[math('MULTIPLY',math('MULTIPLY',t.outputs['Alpha'],c),s,'Native layer height') for t,c,s in zip(layers,channels,settings['layer_scales'])]
 maximum=math('MAXIMUM',math('MAXIMUM',heights[0],heights[1]),math('MAXIMUM',heights[2],heights[3]))
 weights=[math('MULTIPLY',clamp(math('ADD',math('SUBTRACT',h,maximum),settings['half_blend_area'])),clamp(math('MULTIPLY',h,32)),'Native raw weight') for h in heights]
 total=math('ADD',math('ADD',weights[0],weights[1]),math('ADD',weights[2],weights[3]));valid=math('GREATER_THAN',total,.000001);denom=math('MAXIMUM',total,.000001)
 normalized=[math('MULTIPLY',math('DIVIDE',w,denom),valid) for w in weights];normalized[0]=math('ADD',normalized[0],math('SUBTRACT',1,valid))
 terms=[vec('SCALE',t.outputs['Color'],scale=w) for t,w in zip(layers,normalized)];detail=vec('ADD',vec('ADD',terms[0],terms[1]),vec('ADD',terms[2],terms[3]));rgb=vec('MULTIPLY',detail,vec('SCALE',color_map.outputs['Color'],scale=4))
 # Exact display RGB -> linear transfer, matching the current Rust adapter.
 split=node('ShaderNodeSeparateXYZ','Clamp display RGB');links.new(rgb,split.inputs[0]);combine=node('ShaderNodeCombineXYZ','Linear output')
 for axis in ['X','Y','Z']:
  c=clamp(split.outputs[axis]);use_high=math('GREATER_THAN',c,.04045);low=math('DIVIDE',c,12.92);high=math('POWER',math('DIVIDE',math('ADD',c,.055),1.055),2.4);result=math('ADD',math('MULTIPLY',high,use_high),math('MULTIPLY',low,math('SUBTRACT',1,use_high)));links.new(result,combine.inputs[axis])
 emission=node('ShaderNodeEmission','Native terrain adapter');links.new(combine.outputs[0],emission.inputs['Color']);output=node('ShaderNodeOutputMaterial','Terrain output');links.new(emission.outputs[0],output.inputs['Surface'])
 for i,x in enumerate(nodes):x.location=((i%12)*220,-(i//12)*240)
 mat['Native_height_blend_shader']='HeightBlending.hls';mat['Native_layer_scales']=settings['layer_scales'];mat['Native_half_blend_area']=settings['half_blend_area'];mat['Fidelity_limits']=settings['spatial_uv_policy']+' '+settings['lighting_policy']
print('OPENLEAGUE NATIVE TERRAIN NODES: 2 materials',flush=True)
