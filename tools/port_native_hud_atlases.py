from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
for name in ['native_texture_filename.rs','native_hud_atlases.rs']:shutil.copy2(stage/name,r/'crates/client/src'/name)
p=r/'crates/client/Cargo.toml';text=p.read_text(encoding='utf-8');text=text.replace('features = ["wav"]','features = ["wav", "dds"]');p.write_text(text,encoding='utf-8')
p=r/'crates/client/src/native_zip_provider.rs';text=p.read_text(encoding='utf-8');text=text.replace('pub struct StartupHud {pub fast_hud:Vec<u8>,pub chat:Vec<u8>}','pub struct StartupHud {pub fast_hud:Vec<u8>,pub chat:Vec<u8>,pub shadow_isles_atlases:Vec<HudAtlas>}\npub struct HudAtlas {pub request:String,pub normalized:String,pub bytes:Vec<u8>}')
old='        Ok(StartupHud {fast_hud:required(self.read_optional(root,Path::new("HUD/defaults/FastHUD.ini"))?)?,chat:required(self.read_optional(root,Path::new("HUD/defaults/Chat.ini"))?)?})'
new='''        let fast_hud=required(self.read_optional(root,Path::new("HUD/defaults/FastHUD.ini"))?)?;
        let chat=required(self.read_optional(root,Path::new("HUD/defaults/Chat.ini"))?)?;
        let parsed=crate::native_game_cfg_text::parse(&fast_hud,0);
        if let Some(e)=parsed.error {return Err(io::Error::other(e));}
        let count=parsed.value(b"ShadowIsles",b"NumAtlasTextures").ok_or_else(||io::Error::other("HUD atlas count missing"))?;
        let count=std::str::from_utf8(count).map_err(io::Error::other)?.parse::<usize>().map_err(io::Error::other)?;
        let mut shadow_isles_atlases=Vec::new();
        for index in 1..=count {
            let key=format!("AtlasTexture{index}");let name=parsed.value(b"ShadowIsles",key.as_bytes()).ok_or_else(||io::Error::other("HUD atlas filename missing"))?;
            let request=format!("Textures/{}",std::str::from_utf8(name).map_err(io::Error::other)?);
            let normalized=String::from_utf8(crate::native_texture_filename::normalize(request.as_bytes())).map_err(io::Error::other)?;
            let bytes=required(self.read_optional(root,Path::new(&normalized))?)?;
            shadow_isles_atlases.push(HudAtlas {request,normalized,bytes});
        }
        Ok(StartupHud {fast_hud,chat,shadow_isles_atlases})'''
assert old in text or 'let parsed=crate::native_game_cfg_text::parse(&fast_hud,0);' in text;text=text.replace(old,new)
p.write_text(text,encoding='utf-8')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
for name in ['native_texture_filename','native_hud_atlases']:
 if f'mod {name};' not in text:text=f'mod {name};\n'+text
if '.add_plugins(native_hud_atlases::Plugin)' not in text:text=text.replace('        .add_plugins(fow_gpu::Plugin)','        .add_plugins(fow_gpu::Plugin)\n        .add_plugins(native_hud_atlases::Plugin)')
p.write_text(text,encoding='utf-8')
for name in ['native_texture_filename.rs','native_hud_atlases.rs','port_native_hud_atlases.py']:shutil.copy2(stage/name,r/'tools'/name)
print('Native filename conversion and original ShadowIsles HUD atlas GPU preparation connected; widget layout remains open.')
