from pathlib import Path
source=(Path(__file__).parent/'capture_native_hud_dx12.py').read_text(encoding='utf-8')
source=source.replace('-dx12','-vulkan-verified').replace('_dx12','_vulkan_verified').replace("WGPU_BACKEND='dx12'","WGPU_BACKEND='vulkan'").replace('Dx12','Vulkan').replace('DirectX12','Vulkan')
exec(compile(source,'owned Vulkan adapter verified HUD capture','exec'))
