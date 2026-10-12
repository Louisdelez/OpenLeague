import bpy
bpy.ops.wm.open_mainfile(filepath=r'E:\OpenLeague\artwork\maps\TwistedTreeline_OpenLeague.blend')
for name in ['NVRMaterial_Ground1','NVRMaterial_Structure_Backdrop_tex','NVRMaterial_TT_Jungle1','NVRMaterial_Nature_Brush1']:
 mat=bpy.data.materials.get(name);print('MATERIAL_NODES',name,[(x.name,x.type) for x in mat.node_tree.nodes])
