"""Inspect actual framebuffer exports; no claim of full visual acceptance."""
from pathlib import Path
from datetime import datetime, timezone
import json, hashlib, struct
root = Path(__file__).resolve().parents[1]
frames=[]
for suffix in ['', '-resized', '-fullscreen', '-restored']:
    path=root/'logs'/('render-qualified'+suffix+'.png')
    if not path.is_file():
        frames.append({'path':str(path.relative_to(root)),'present':False})
        continue
    data=path.read_bytes()
    valid=data[:8]==b'\x89PNG\r\n\x1a\n'
    width,height=struct.unpack('>II',data[16:24]) if valid else (0,0)
    frames.append({'path':str(path.relative_to(root)),'present':True,'png_header_valid':valid,'width':width,'height':height,'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()})
err=(root/'logs/client.err.log').read_text(encoding='utf-8',errors='replace')
report={'generated_utc':datetime.now(timezone.utc).isoformat(),'backend':'vulkan','client_sha256':hashlib.sha256((root/'target/debug/openleague-client.exe').read_bytes()).hexdigest(),'frames':frames,'fatal_surface_error_in_log':any(s in err for s in ['Invalid surface','Quitting the application','panicked at','ResizeBuffers failed']),'external_vulkan_layer_warning':'MediaSDKVulkanLayer64.json' in err,'limits':['Framebuffer exports do not prove the application was foreground on the user desktop.','Full visual/audio/gameplay fidelity and long-term GPU compatibility remain unqualified.','External Vulkan layer warning retained; no global driver or TikTok setting changed.']}
report['surface_lifecycle_exports_complete']=all(f.get('png_header_valid',False) for f in frames) and not report['fatal_surface_error_in_log']
(root/'docs/render_validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(report,ensure_ascii=False))
raise SystemExit(not report['surface_lifecycle_exports_complete'])
