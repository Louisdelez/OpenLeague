from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
p=r/'crates/client/src/fow_settings.rs';s=p.read_text(encoding='utf-8')
s=s.replace('pub struct Values {','pub struct Values {pub upscale:Option<bool>,')
s=s.replace('pub struct Settings {','pub struct Settings {pub upscale:bool,')
s=s.replace('Self {fade_start:proof', 'Self {upscale:true,fade_start:proof')
s=s.replace('    pub fn apply(&mut self,values:&Values) {','''    /// The secondary configuration wins when its query finds a value, including false.
    /// Missing values fall through to the primary, then the native true default.
    pub fn resolve_upscale(primary:Option<bool>,secondary:Option<bool>)->bool {
        secondary.or(primary).unwrap_or(true)
    }
    pub fn map10()->Self {
        let floats:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_settings_defaults_contract.json")).expect("native Map10 fog values");
        let boolean:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_upscale_config_contract.json")).expect("native Map10 upscale query");
        let input=&floats["map10_authored"];let value=|key:&str|input[key].as_f64().map(|f|f as f32);
        let mut result=Self::native_initial();
        result.apply(&Values {upscale:boolean["map10_authored"].as_bool(),fade_start:value("fadeStart"),fade_finish:value("fadeFinish"),edge_enhancement:value("edgeEnhancement"),edge_tint_point:value("edgeTintPoint"),blur_kernel_sigma:value("blurKernelSigma")});
        result
    }
    pub fn apply(&mut self,values:&Values) {
        self.upscale=Self::resolve_upscale(values.upscale,None);''')
s=s.replace('state.apply(&Values {fade_start:', 'state.apply(&Values {upscale:None,fade_start:')
s=s.replace('    #[test] fn defaults_overrides', '''    #[test] fn upscale_layers_match_original_map_initializer() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_upscale_config_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["layer_cases"].as_array().unwrap() {
            let primary=c["primary"].as_bool();let secondary=if c["secondary_present"].as_bool().unwrap() {c["secondary"].as_bool()} else {None};
            assert_eq!(Settings::resolve_upscale(primary,secondary),c["result"].as_bool().unwrap(),"{}",c["name"]);
        }
        assert_eq!(Settings::map10().upscale,p["cases"][0]["result"].as_bool().unwrap());
    }
    #[test] fn defaults_overrides''')
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/fow_visibility_texture.rs';s=p.read_text(encoding='utf-8')
s=s.replace('pub struct VisibilityTexture {pub image:Handle<Image>,','pub struct VisibilityTexture {pub image:Handle<Image>,pub settings:crate::fow_settings::Settings,')
s=s.replace('    let mut image=Image::new(','''    let settings=crate::fow_settings::Settings::map10();
    // This qualified Map10 pipeline requires the native default upscale choice.
    // A different map/configuration must construct its own texture dimensions.
    assert!(settings.upscale,"Map10 recovered configuration requires native upscale");
    let mut image=Image::new(''')
s=s.replace('VisibilityTexture {image:images.add(image),staging:', 'VisibilityTexture {image:images.add(image),settings,staging:')
s=s.replace('"format":"R8Unorm",','"format":"R8Unorm","native_upscale":texture.settings.upscale,"native_blur_sigma":texture.settings.blur_kernel_sigma,"configuration_profile":"recovered_map10_no_launch_override",')
p.write_text(s,encoding='utf-8')
shutil.copy2('E:/mapslol3v3/probe_fow_upscale_config.py',r/'tools/probe_fow_upscale_config.py')
shutil.copy2('E:/mapslol3v3/install_fow_upscale_config.py',r/'tools/install_fow_upscale_config.py')
print('Native Map10 upscale configuration connected to texture setup; normal blur/fog remains open.')
