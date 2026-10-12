from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s='#[allow(dead_code)] // Native settings reader consumer qualified; path selection/GPU binding pending.\nmod fow_settings;\n'+s;p.write_text(s,encoding='utf-8')
source=r'''//! Native6B32D1..6B33A9 configuration consumer plus6B343E sigma fallback.
//! fadeStart/Finish are original fog thresholds, not temporal fade speeds.
#[derive(Default)]
pub struct Values {pub fade_start:Option<f32>,pub fade_finish:Option<f32>,pub edge_enhancement:Option<f32>,pub edge_tint_point:Option<f32>,pub blur_kernel_sigma:Option<f32>}
pub struct Settings {pub fade_start:f32,pub fade_finish:f32,pub edge_enhancement:f32,pub one_over_tint_point:f32,pub blur_kernel_sigma:f32}
impl Settings {
    pub fn native_initial()->Self {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_settings_defaults_contract.json")).expect("qualified native settings defaults");
        Self {fade_start:proof["defaults"]["fadeStart"].as_f64().unwrap() as f32,fade_finish:proof["defaults"]["fadeFinish"].as_f64().unwrap() as f32,edge_enhancement:0.,one_over_tint_point:0.,blur_kernel_sigma:proof["defaults"]["blurKernelSigma"].as_f64().unwrap() as f32}
    }
    pub fn apply(&mut self,values:&Values) {
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
    #[test] fn defaults_overrides_and_retained_tint_match_original_settings_consumer() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_settings_defaults_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        for c in proof["cases"].as_array().unwrap() {
            let input=&c["authored"];let value=|key:&str|input[key].as_f64().map(|f|f as f32);
            let mut state=Settings::native_initial();state.one_over_tint_point=c["previous_tint"].as_f64().unwrap() as f32;
            state.apply(&Values {fade_start:value("fadeStart"),fade_finish:value("fadeFinish"),edge_enhancement:value("edgeEnhancement"),edge_tint_point:value("edgeTintPoint"),blur_kernel_sigma:value("blurKernelSigma")});
            let result=[state.fade_start,state.fade_finish,state.edge_enhancement,state.one_over_tint_point,state.blur_kernel_sigma].map(f32::to_bits);
            let expected:Vec<_>=c["result_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(result.as_slice(),expected.as_slice(),"{}",c["name"]);
        }
    }
}
'''
(r/'crates/client/src/fow_settings.rs').write_text(source,encoding='utf-8');print('Native settings consumer installed; production configuration resolver remains pending.')
