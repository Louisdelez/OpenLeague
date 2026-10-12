//! Native6B32D1..6B33A9 configuration consumer plus6B343E sigma fallback.
//! fadeStart/Finish are original fog thresholds, not temporal fade speeds.
#[derive(Default)]
pub struct Values {pub upscale:Option<bool>,pub fade_start:Option<f32>,pub fade_finish:Option<f32>,pub edge_enhancement:Option<f32>,pub edge_tint_point:Option<f32>,pub blur_kernel_sigma:Option<f32>}
pub struct Settings {pub upscale:bool,pub fade_start:f32,pub fade_finish:f32,pub edge_enhancement:f32,pub one_over_tint_point:f32,pub blur_kernel_sigma:f32}
#[derive(Clone,Copy)]
pub struct ShaderParameters {pub coordinates:[f32;4],pub height:[f32;4],pub edge:[f32;4]}
impl Settings {
    pub fn shader_parameters(&self,extent:f32)->Result<ShaderParameters,&'static str> {
        let coordinates=crate::native_fow::FogParams::from_native_extent(extent)?.params().to_array();
        // Preserve the native SSE ordering and singular edge result (infinity).
        let height_scale=1./(self.fade_finish-self.fade_start);
        let height_shift=-(height_scale*self.fade_start);
        let edge_scale=1./(1.-self.edge_enhancement);
        Ok(ShaderParameters {coordinates,height:[height_scale,height_shift,0.,0.],edge:[edge_scale,1.-edge_scale,self.one_over_tint_point,0.]})
    }

    pub fn native_initial()->Self {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_settings_defaults_contract.json")).expect("qualified native settings defaults");
        Self {upscale:true,fade_start:proof["defaults"]["fadeStart"].as_f64().unwrap() as f32,fade_finish:proof["defaults"]["fadeFinish"].as_f64().unwrap() as f32,edge_enhancement:0.,one_over_tint_point:0.,blur_kernel_sigma:proof["defaults"]["blurKernelSigma"].as_f64().unwrap() as f32}
    }
    /// The secondary configuration wins when its query finds a value, including false.
    /// Missing values fall through to the primary, then the native true default.
    pub fn resolve_upscale(primary:Option<bool>,secondary:Option<bool>)->bool {
        secondary.or(primary).unwrap_or(true)
    }
    pub fn map10()->Self {
        let config=crate::map10_native_config::Config::map10().expect("qualified original Map10 INIBIN");
        let mut result=Self::native_initial();
        result.apply(&Values {upscale:config.boolean("FoW","upscale"),fade_start:config.float("FoW","fadeStart"),fade_finish:config.float("FoW","fadeFinish"),edge_enhancement:config.float("FoW","edgeEnhancement"),edge_tint_point:config.float("FoW","edgeTintPoint"),blur_kernel_sigma:config.float("FoW","blurKernelSigma")});
        result
    }
    pub fn apply(&mut self,values:&Values) {
        self.upscale=Self::resolve_upscale(values.upscale,None);
        // The defaults for these two reads are the prior global values, not fixed literals.
        self.fade_start=values.fade_start.unwrap_or(self.fade_start);
        self.fade_finish=values.fade_finish.unwrap_or(self.fade_finish);
        self.edge_enhancement=values.edge_enhancement.unwrap_or(0.);
        let tint=values.edge_tint_point.unwrap_or(0.);
        // Native unordered/<=0 branch does not write the prior reciprocal.
        if tint>0. {self.one_over_tint_point=1./tint;}
        self.blur_kernel_sigma=values.blur_kernel_sigma.unwrap_or(-1.);
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn all_shader_uniform_bits_match_original_initializer_stores() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_shader_parameters_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let mut s=Settings::native_initial();let field=|name:&str|c[name].as_f64().unwrap() as f32;
            s.fade_start=field("fade_start");s.fade_finish=field("fade_finish");s.edge_enhancement=field("edge_enhancement");s.one_over_tint_point=field("one_over_tint_point");
            let v=s.shader_parameters(field("extent")).unwrap();
            for (name,actual) in [("FOG_OF_WAR_PARAMS",v.coordinates),("FOW_HEIGHT_FADE",v.height),("FOW_EDGE_CONTROL",v.edge)] {
                let expected:Vec<u32>=c["result_bits"][name].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(actual.map(f32::to_bits).as_slice(),expected.as_slice(),"{} {name}",c["name"]);
            }
        }
    }
    #[test] fn upscale_layers_match_original_map_initializer() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_upscale_config_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["layer_cases"].as_array().unwrap() {
            let primary=c["primary"].as_bool();let secondary=if c["secondary_present"].as_bool().unwrap() {c["secondary"].as_bool()} else {None};
            assert_eq!(Settings::resolve_upscale(primary,secondary),c["result"].as_bool().unwrap(),"{}",c["name"]);
        }
        assert_eq!(Settings::map10().upscale,p["cases"][0]["result"].as_bool().unwrap());
    }
    #[test] fn defaults_overrides_and_retained_tint_match_original_settings_consumer() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_settings_defaults_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        for c in proof["cases"].as_array().unwrap() {
            let input=&c["authored"];let value=|key:&str|input[key].as_f64().map(|f|f as f32);
            let mut state=Settings::native_initial();state.one_over_tint_point=c["previous_tint"].as_f64().unwrap() as f32;
            state.apply(&Values {upscale:None,fade_start:value("fadeStart"),fade_finish:value("fadeFinish"),edge_enhancement:value("edgeEnhancement"),edge_tint_point:value("edgeTintPoint"),blur_kernel_sigma:value("blurKernelSigma")});
            let result=[state.fade_start,state.fade_finish,state.edge_enhancement,state.one_over_tint_point,state.blur_kernel_sigma].map(f32::to_bits);
            let expected:Vec<_>=c["result_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(result.as_slice(),expected.as_slice(),"{}",c["name"]);
        }
    }
}
