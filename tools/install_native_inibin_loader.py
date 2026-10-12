from pathlib import Path
import json,hashlib,shutil
r=Path('E:/OpenLeague');p=json.loads((r/'data/4.20/native_map10_inibin_loader_contract.json').read_text());assert p['passed'] and len(p['native_decoded'])==53
source=Path(p['source']);assert hashlib.sha256(source.read_bytes()).hexdigest()==p['source_sha256'];shutil.copy2(source,r/'data/4.20/map10_terrain.inibin')
shutil.copy2('E:/mapslol3v3/map10_native_config.rs',r/'crates/client/src/map10_native_config.rs')
path=r/'crates/client/src/main.rs';s=path.read_text(encoding='utf-8');assert 'mod map10_native_config;' not in s;s='mod map10_native_config;\n'+s;path.write_text(s,encoding='utf-8')
path=r/'crates/client/src/fow_settings.rs';s=path.read_text(encoding='utf-8');begin=s.index('        let floats:serde_json::Value=');end=s.index('        result\n',begin)
s=s[:begin]+'''        let config=crate::map10_native_config::Config::map10().expect("qualified original Map10 INIBIN");
        let mut result=Self::native_initial();
        result.apply(&Values {upscale:config.boolean("FoW","upscale"),fade_start:config.float("FoW","fadeStart"),fade_finish:config.float("FoW","fadeFinish"),edge_enhancement:config.float("FoW","edgeEnhancement"),edge_tint_point:config.float("FoW","edgeTintPoint"),blur_kernel_sigma:config.float("FoW","blurKernelSigma")});
'''+s[end:];path.write_text(s,encoding='utf-8')
path=r/'crates/client/src/fow_visibility_texture.rs';s=path.read_text(encoding='utf-8').replace('"configuration_profile":"recovered_map10_no_launch_override",','"configuration_profile":"native_map10_inibin_no_launch_override","logical_configuration":crate::map10_native_config::LOGICAL_PATH,"binary_configuration":crate::map10_native_config::PHYSICAL_PATH,');path.write_text(s,encoding='utf-8')
for name in ['probe_native_inibin_loader.py','install_native_inibin_loader.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print('Map10 settings now decode the actual original binary file;53 native fields qualified.')
