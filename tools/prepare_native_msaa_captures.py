from pathlib import Path
r=Path('E:/OpenLeague')
src=(r/'tools/capture_projected_core_cycle_v11_pair_dx12.py').read_text(encoding='utf-8')
for version,port,backend in [('v14_native_dx12',10501,'dx12'),('v15_native_vulkan',10502,'vulkan')]:
 out=src.replace('v11_pair_dx12',version).replace('v11-pair-dx12',version.replace('_','-')).replace('10498',str(port)).replace("WGPU_BACKEND='dx12'","WGPU_BACKEND='"+backend+"'").replace('Current DX12 framebuffer','Current '+backend+' framebuffer')
 (r/'tools'/('capture_projected_core_cycle_'+version+'.py')).write_text(out,encoding='utf-8')
print('Two captures prepared for the forthcoming native-MSAA client build.')
