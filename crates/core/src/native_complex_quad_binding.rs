//! Original Complex type0 camera tables and raw 937120 draw-channel binding.
//! This is not an emitter or complete renderer. Direction alignment, screen UV,
//! distance stretch, center offsets and optional shader variants remain explicit.
use crate::native_complex_particle_storage::Record;

pub type Error = &'static str;
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Axes { pub a:[f32;3], pub b:[f32;3] }
fn neg(v:f32)->f32 {f32::from_bits(v.to_bits()^0x8000_0000)}

/// 923450 DL=0 truncates the angle before signed modulo360. The matrix is the
/// original row-major view, not Bevy's view and not the view-projection matrix.
/// 9235D0 transposes it and builds tables using the original PE sine table.
pub fn axes(view:[f32;16],angle:f32)->Result<Axes,Error> {
    if view.iter().any(|v|!v.is_finite()) || !angle.is_finite()
        || !(-2147483648.0..2147483648.0).contains(&angle) {return Err("unsupported quad view/angle");}
    let index=(angle.trunc() as i32).rem_euclid(360);
    let [s,c]=crate::camera_rotation::coefficients(-(index as f32));
    let (x,y,z)=(view[2],view[6],neg(view[10]));
    let (xx,yy,zz)=(x*x,y*y,z*z);
    let (xy,zx,zy)=(x*y,z*x,z*y);
    let t=1.0-c;
    let (zs,ys,xs)=(z*s,y*s,s*x);
    let (txy,txz,tyz)=(t*xy,(z*x)*t,(z*y)*t);
    let r00=(1.0-xx)*c+xx;
    let r11=(1.0-yy)*c+yy;
    let r22=(1.0-zz)*c+zz;
    let a=[
        ((zs+txy)*view[5]+r00*view[1])-(txz-ys)*view[9],
        ((txy-zs)*view[1]+r11*view[5])-(xs+tyz)*view[9],
        neg(((tyz-xs)*view[5]+(ys+txz)*view[1])-r22*view[9]),
    ];
    // The B branch recomputes t*zx/t*zy in this order (923ACD/923AFB).
    let (tzx,tzy)=(t*zx,t*zy);
    let b=[
        ((zs+txy)*view[4]+r00*view[0])-(tzx-ys)*view[8],
        ((txy-zs)*view[0]+r11*view[4])-(tzy+xs)*view[8],
        neg(((tzy-xs)*view[4]+(tzx+ys)*view[0])-r22*view[8]),
    ];
    if a.into_iter().chain(b).any(|v|!v.is_finite()) {return Err("quad basis overflow");}
    Ok(Axes {a,b})
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct DrawFields {
    pub matrix_center:[f32;3],pub rgba:[f32;4],pub scale:[f32;3],
    pub rotation:[f32;3], pub quad_angle:f32,
    pub uv_scroll:[f32;2],pub second_uv_scroll:[f32;2],
    pub lookup:[f32;2],pub atlas_frame:f32,
}
impl DrawFields {
    /// Real937120/938820 branch config+478=0. Do not call on screen-projected UV
    /// records. No reinterpretation of lookup as age is made here.
    pub fn from_record(record:&Record,screen_uv_enabled:bool)->Result<Self,Error> {
        if screen_uv_enabled {return Err("screen-projected UV getter is not qualified");}
        let result=Self {
            matrix_center:std::array::from_fn(|i|f32::from_bits(record.surface[28+i])),
            rgba:std::array::from_fn(|i|f32::from_bits(record.color[4+i])),
            scale:std::array::from_fn(|i|f32::from_bits(record.scale[3+i])),
            rotation:record.field_70.map(f32::from_bits),quad_angle:f32::from_bits(record.motion[52]),
            uv_scroll:[record.uv[10],record.uv[11]].map(f32::from_bits),
            second_uv_scroll:[record.uv[12],record.uv[13]].map(f32::from_bits),
            lookup:record.field_64.map(f32::from_bits),atlas_frame:f32::from_bits(record.atlas[1]),
        };
        if result.matrix_center.into_iter().chain(result.rgba).chain(result.scale).chain(result.rotation)
            .chain([result.quad_angle,result.atlas_frame]).chain(result.uv_scroll).chain(result.second_uv_scroll)
            .chain(result.lookup).any(|v|!v.is_finite()) {return Err("nonfinite quad draw field");}
        Ok(result)
    }
}

/// Original common.hls CalculateTexDivUV; c235=(cols,1/cols,1/rows,0).
/// Inputs are the raw packed channel0, before any host mesh UV interpretation.
pub fn atlas_uv(raw:[f32;2],frame:f32,division:[u16;2])->Result<[f32;2],Error> {
    if division.contains(&0) || !frame.is_finite() || raw.iter().any(|v|!v.is_finite()) {
        return Err("invalid atlas input");
    }
    let cols=division[0] as f32;let inverse_cols=1.0/cols;let inverse_rows=1.0/(division[1] as f32);
    let n=frame.floor();let row=(n*inverse_cols).floor();let col=n-row*cols;
    let out=[(raw[0]+col)*inverse_cols,(raw[1]+row)*inverse_rows];
    if out.iter().any(|v|!v.is_finite()) {return Err("atlas overflow");} Ok(out)
}

/// Original93A07C..93A163. Common config+340 modes0/1; caller939B10 supplies
/// normalized lifetime age. Modes2/3 require other producer inputs and are refused.
pub fn lookup_uv(age:f32,modes:[u32;2],scale:[f32;2],offset:[f32;2])->Result<[f32;2],Error> {
    if !age.is_finite() || scale.into_iter().chain(offset).any(|v|!v.is_finite())
        || modes.iter().any(|&mode|mode>1) {return Err("unsupported lookup coordinate inputs");}
    let result=std::array::from_fn(|i|if modes[i]==0 {scale[i]} else {age*scale[i]+offset[i]});
    if result.iter().any(|v|!v.is_finite()) {return Err("lookup coordinate overflow");} Ok(result)
}

#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/complex_quad_binding_vectors.json")).unwrap()}
    #[test]
    fn original_camera_tables_and_selector_match_recorded_finite_views() {
        let p=proof();let cases=p["basis"]["cases"].as_array().unwrap();assert_eq!(cases.len(),16);
        for c in cases {
            let view=std::array::from_fn(|i|c["view"][i].as_f64().unwrap() as f32);
            for index in 0..360 {
                let got=axes(view,index as f32).unwrap();
                for (name,out) in [("a",got.a),("b",got.b)] {for i in 0..3 {
                    assert_eq!(out[i].to_bits(),c[format!("table_{name}_words")][index*3+i].as_u64().unwrap() as u32);
                }}
            }
        }
        let selectors=p["basis"]["selector_cases"].as_array().unwrap();assert_eq!(selectors.len(),176);
        for c in selectors {
            let source=&cases[c["case_index"].as_u64().unwrap() as usize];
            let view=std::array::from_fn(|i|source["view"][i].as_f64().unwrap() as f32);
            let got=axes(view,f32::from_bits(c["angle_bits"].as_u64().unwrap() as u32)).unwrap();
            assert_eq!(got.a.into_iter().chain(got.b).map(f32::to_bits).collect::<Vec<_>>(),
                c["output_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
        }
    }
    #[test]
    fn packet_uv_lookup_frame_and_angle_have_distinct_original_sources() {
        let p=proof();let cases=p["packet"]["cases"].as_array().unwrap();assert_eq!(cases.len(),4);
        for c in cases {
            let i=c["index"].as_u64().unwrap() as usize;
            let at=|offset:usize|c["buffers"][offset.to_string()]["words"][i].as_array().unwrap().iter()
                .map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();
            let record=Record {life:[0;2],motion:at(0x10).try_into().unwrap(),surface:at(0x1c).try_into().unwrap(),
                color:at(0x28).try_into().unwrap(),scale:at(0x34).try_into().unwrap(),uv:at(0x40).try_into().unwrap(),
                atlas:at(0x4c).try_into().unwrap(),field_58:[0],field_64:at(0x64).try_into().unwrap(),
                field_70:at(0x70).try_into().unwrap(),field_7c:at(0x7c).try_into().unwrap(),
                field_88:at(0x88).try_into().unwrap(),trail_slots:Vec::new()};
            let got=DrawFields::from_record(&record,false).unwrap();
            for (name,out) in [("center",got.matrix_center.to_vec()),("rgba",got.rgba.to_vec()),("scale",got.scale.to_vec()),
                ("rotation",got.rotation.to_vec()),("uv_scroll",got.uv_scroll.to_vec()),("second_uv_scroll",got.second_uv_scroll.to_vec()),("lookup",got.lookup.to_vec())] {
                assert_eq!(out.into_iter().map(f32::to_bits).collect::<Vec<_>>(),c["draw_fields"][name].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
            }
            assert_eq!(got.atlas_frame.to_bits(),c["draw_fields"]["atlas_frame"].as_u64().unwrap() as u32);
            assert_eq!(got.quad_angle.to_bits(),c["output_words"][52].as_u64().unwrap() as u32);
            assert!(DrawFields::from_record(&record,true).is_err());
        }
    }
    #[test]
    fn atlas_uses_floor_and_separate_reciprocals_with_no_hidden_uv_flip() {
        assert_eq!(atlas_uv([0.,0.],3.,[2,2]).unwrap(),[0.5,0.5]);
        assert_eq!(atlas_uv([1.,1.],3.,[2,2]).unwrap(),[1.,1.]);
        assert_eq!(atlas_uv([0.,0.],-0.1,[2,2]).unwrap(),[0.5,-0.5]);
        assert_eq!(atlas_uv([0.25,0.75],0.,[1,1]).unwrap(),[0.25,0.75]);
        assert!(atlas_uv([0.,0.],0.,[0,2]).is_err());
        assert!(axes([0.;16],f32::INFINITY).is_err());
    }
    #[test]
    fn original_lookup_modes_keep_constant_offset_ignored_and_age_channels_distinct() {
        let p=proof();let cases=p["lookup"]["cases"].as_array().unwrap();assert_eq!(cases.len(),24);
        for c in cases {
            let out=lookup_uv(c["age"].as_f64().unwrap() as f32,
                std::array::from_fn(|i|c["modes"][i].as_u64().unwrap() as u32),
                std::array::from_fn(|i|c["scale"][i].as_f64().unwrap() as f32),
                std::array::from_fn(|i|c["offset"][i].as_f64().unwrap() as f32)).unwrap();
            for i in 0..2 {assert_eq!(out[i].to_bits(),c["output_words"][i].as_u64().unwrap() as u32);}
        }
        assert_eq!(lookup_uv(0.375,[1,0],[1.,1.],[0.,0.]).unwrap(),[0.375,1.]);
        assert!(lookup_uv(0.,[2,0],[1.,1.],[0.,0.]).is_err());
    }
}
