from pathlib import Path
import shutil,json
r=Path('E:/OpenLeague');stage=Path(__file__).parent
for name in ['native_zip_archive.rs','native_zip_provider.rs']:shutil.copy2(stage/name,r/'crates/client/src'/name)
p=r/'crates/client/Cargo.toml';text=p.read_text(encoding='utf-8')
if 'flate2 =' not in text:text=text.replace('[dev-dependencies]','flate2 = "=1.1.10"\n\n[dev-dependencies]')
p.write_text(text,encoding='utf-8')
p=r/'crates/client/src/native_user_settings.rs';text=p.read_text(encoding='utf-8')
old='pub fn load(root:&Path)->std::io::Result<Loaded> {\n let root=root.canonicalize()?;'
new='pub fn load(root:&Path)->std::io::Result<Loaded> {load_using(root,read_optional)}\npub fn load_using(root:&Path,mut read_optional:impl FnMut(&Path)->std::io::Result<Option<Vec<u8>>>)->std::io::Result<Loaded> {\n let root=root.canonicalize()?;'
assert old in text or 'pub fn load_using' in text;text=text.replace(old,new);p.write_text(text,encoding='utf-8')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
for name in ['native_zip_archive','native_zip_provider']:
 if f'mod {name};' not in text:text=f'mod {name};\n'+text
old='    let settings=native_user_settings::load(&root).expect("load native Game.cfg configuration");'
new='    let mut zip_resources=native_zip_provider::Provider::from_catalog(&root).expect("mount native ZIP resource catalog");\n    let native_hud=zip_resources.startup_hud(&root).expect("load original HUD ZIP configuration");\n    eprintln!("Native ZIP archives={} entries={} unique_names={} FastHUD_bytes={} Chat_bytes={}",zip_resources.archive_count(),zip_resources.entry_count,zip_resources.unique_names,native_hud.fast_hud.len(),native_hud.chat.len());\n    let settings=native_user_settings::load_using(&root,|path|zip_resources.read_optional(&root,path)).expect("load native Game.cfg configuration");'
assert old in text or 'let mut zip_resources=' in text;text=text.replace(old,new)
text=text.replace('    App::new()\n        .add_plugins(','    App::new()\n        .insert_resource(zip_resources)\n        .insert_resource(native_hud)\n        .add_plugins(')
p.write_text(text,encoding='utf-8')
proof=json.loads((r/'data/4.20/native_zip_central_directory_contract.json').read_text(encoding='utf-8'))
catalog=dict(complete=False,mount_order_scope='Explicit recovered archive list; historical process mount enumeration/alias registration not yet qualified.',archives=[dict(path='data/4.20/archives/'+a['path'].replace('\\','/').split('/deploy/DATA/',1)[1],sha256=a['sha256']) for a in proof['original_archives']])
(r/'data/4.20/native_zip_catalog.json').write_text(json.dumps(catalog,indent=2)+'\n',encoding='utf-8')
for name in ['native_zip_archive.rs','native_zip_provider.rs','port_native_zip_archive.py']:shutil.copy2(stage/name,r/'tools'/name)
print('ZIP reader/provider connected to startup HUD resources and Game.cfg archive-first lookup; UI layout/alias/fallback remain open.')
