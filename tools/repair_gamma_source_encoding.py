from pathlib import Path
import shutil,json
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
archived=r/'docs/plan_history/native-gamma-integration-20261005T191731211367Z/main.rs'
s=archived.read_text(encoding='utf-8')
s='mod native_gamma;\n'+s
s=s.replace('.add_plugins(fow_gpu::Plugin)', '.add_plugins(fow_gpu::Plugin)\n        .add_plugins(bevy::core_pipeline::fullscreen_material::FullscreenMaterialPlugin::<native_gamma::Map10Gamma>::default())')
s=s.replace('        Tonemapping::None,\n','        Tonemapping::None,\n        native_gamma::Map10Gamma::native_map10(),\n')
assert 'déplacement / attaque' in s and 'dÃ©placement' not in s
current=r/'crates/client/src/main.rs';shutil.copy2(current,archived.parent/'main.before_utf8_repair.rs')
current.write_text(s,encoding='utf-8')
for name in ['install_native_gamma.py','repair_gamma_source_encoding.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps(dict(utf8_restored=True,gamma_integration_retained=True)))
