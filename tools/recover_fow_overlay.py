from pathlib import Path
import json,hashlib,datetime,sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');d=json.loads((r/'docs/native_projection_discovery.json').read_text());deploy=Path(d['source']).parent
source=deploy/'DATA/Shaders/TEXTURE/DefaultFogOfWarOverlay.dds';target=r/'assets/maps/terrain_native/DefaultFogOfWarOverlay.png'
im=Image.open(source).convert('RGBA');im.save(target);converted=Image.open(target).convert('RGBA');assert converted.tobytes()==im.tobytes()
p={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'selected_for_map10':False,'source':str(source),'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'asset':str(target.relative_to(r)),'asset_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),'size':im.size,'rgba_extrema':im.getextrema(),'pixel_equal':True,'native_selection':{'property_key':'FOWTexture','fallback_string':'0x10A0338','fallback_path':'DefaultFogOfWarOverlay.dds','reader_virtual_call':'0x6B308A','fallback_branch':'0x6B30A4','load_call':'0x6B30B2','stored_handle':'0x2D78A38'},'limits':['Default asset recovered and fallback instruction path located. Map10 property reader result and native path resolver remain unqualified; asset not selected arbitrarily.','Source conversion verified byte-for-byte decoded RGBA; native compression filtering not emulated.']}
(r/'docs/fow_overlay_recovery.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'size':im.size,'rgba_extrema':im.getextrema(),'pixels_equal':True,'map10_selected':False}))
