//! Two original base groups only. Native numeric parameter readers are reused;
//! absent caller defaults and resource selection are a named LOCAL policy.
use openleague_core::{native_scalar_parameter::ScalarParameter,native_vector_parameter::VectorParameter};
pub const POLICY:&str="ezreal_w_core_hoop_ground_local_v1";
pub const SOURCE:&str=include_str!("../../../data/4.20/ezreal_w_base_missile.json");
pub const IMAGE:&str="particles/ezreal/w_missile/glows.dds";
pub const COLORS:[&str;2]=["particles/ezreal/w_missile/color-hotsparks.dds","particles/ezreal/w_missile/color-summonerdot.dds"];
const EXPECTED_CORE:&str=r#"{"p-life":0.5,"p-numframes":true,"e-local-orient":true,"e-life":true,"e-rate":true,"single-particle":true,"p-offset":[0.0,-10.0,0.0],"p-bindtoemitter":[1.0,1.0],"p-colortype":[0.0,1.0],"p-colorscale":[0.7,1.0],"p-texdiv":[2.0,2.0],"p-coloroffset":[0.0,0.0],"p-type":"0","p-startframe":"0","p-texture":"glows.tga","e-linger":"0","p-linger":"0","KeywordsExcluded":"CyberEzreal","p-rgba":"color-hotsparks.tga","p-frameRate":"0","p-scale":"100","rendermode":"0"}"#;
const EXPECTED_HOOP:&str=r#"{"e-life":0.5,"p-linger":-1,"p-numframes":4,"p-life":true,"p-startframe":true,"e-local-orient":true,"e-rotation1":true,"p-vel":[100.0,-100.0,0.0],"p-offset":[40.0,30.0,0.0],"p-scaleP1":[0.0,0.5],"p-scaleP2":[1.0,1.5],"p-bindtoemitter":[0.5,0.0],"p-texdiv":[2.0,2.0],"p-xscale1":[0.0,1.0],"p-xscale2":[1.0,0.0],"p-velYP1":[0.0,1.0],"p-velYP2":[1.0,2.0],"p-colorscale":[1.0,0.5],"p-lifeP2":[0.9,0.3],"p-lifeP3":[1.0,1.0],"e-rotation1P1":[0.0,0.0],"p-scale2":[0.1,1.0],"p-scale3":[1.0,1.0],"p-coloroffset":[0.0,0.5],"p-colortype":[1.0,3.0],"e-rotation1P2":[1.0,360.0],"KeywordsExcluded":"CyberEzreal","p-scale":"10","p-rgba":"color-summonerdot.tga","e-rate":"2000","p-lifeP1":"0.0 0.1","p-scale1":"0.0 0","p-type":"0","field-drag-1":"Drag","rendermode":"0","p-texture":"glows.tga","e-linger":"0","p-frameRate":"0"}"#;
#[derive(Clone,Debug)]
pub struct Group {
    pub rate:ScalarParameter,pub life:ScalarParameter,pub scale:ScalarParameter,pub xscale:ScalarParameter,
    pub rotation:Option<ScalarParameter>,pub offset:VectorParameter,pub velocity:VectorParameter,
    pub emitter_life:f32,pub max_particle_life:f32,pub single:bool,pub bind:[f32;2],
    pub color_mode:[i32;2],pub color_scale:[f32;2],pub color_offset:[f32;2],pub start_frame:u32,pub drag:bool,
}
#[derive(Clone,Debug)]
pub struct Profile {pub groups:[Group;2],pub drag:f32,pub radius:f32}
fn numeric(v:&serde_json::Value)->Option<Vec<f32>> {
    let out=match v {
        serde_json::Value::Bool(v)=>vec![if *v {1.}else{0.}],
        serde_json::Value::Number(n)=>vec![n.as_f64()? as f32],
        serde_json::Value::String(s)=>s.split_whitespace().map(str::parse::<f32>).collect::<Result<Vec<_>,_>>().ok()?,
        serde_json::Value::Array(a)=>a.iter().map(|n|n.as_f64().map(|n|n as f32)).collect::<Option<Vec<_>>>()?,
        _=>return None,
    };(!out.is_empty()&&out.iter().all(|v|v.is_finite())).then_some(out)
}
impl Profile {
    pub fn load()->Result<Self,&'static str>{Self::parse(SOURCE)}
    fn parse(text:&str)->Result<Self,&'static str>{
        let d:serde_json::Value=serde_json::from_str(text).map_err(|_|"W profile JSON invalid")?;
        if d["schema"]!="OpenLeague_W_base_missile_local_profile/v1"
            || d["policy"]!=openleague_core::ezreal_w_projectile_view::POLICY
            || d["source"]["sha256"]!="87faceb5d93377d2f82467d55f3eed61874e36152d624fce2dd09612004144c1"
            || d["source"]["bytes"]!=2080 || d["groups"].as_array().map(Vec::len)!=Some(2)
            || d["Drag"]!=serde_json::json!({"f-drag":2,"f-pos":[0.,0.,0.],"f-radius":"2000"}) {
            return Err("W authored identity/force changed");
        }
        let mut groups=Vec::new();
        for (i,expected) in [EXPECTED_CORE,EXPECTED_HOOP].into_iter().enumerate() {
            let row=&d["groups"][i];let expected:serde_json::Value=serde_json::from_str(expected).unwrap();
            if row["fields"]!=expected || row["slot"]!=i+1 || row["name"]!=["core","hoop"][i] {
                return Err("W original base fields changed");
            }
            let f=row["fields"].as_object().ok_or("W fields absent")?;
            let get=|key:&str|f.get(key).and_then(numeric);
            let scalar=|key:&str,default:f32|ScalarParameter::read_numeric(key,default,get)
                .map_err(|_|"W scalar rejected")?.ok_or("W required scalar missing");
            // Absent core p-xscale is explicit local multiplier1; hoop has a
            // numbered curve with caller base1. This is not an inferred native default.
            let xscale=if i==0 {ScalarParameter::read_numeric("local",1.,|k|(k=="local").then_some(vec![1.]))
                .map_err(|_|"W constant scale invalid")?.unwrap()}else{scalar("p-xscale",1.)?};
            let vector=|key:&str|VectorParameter::read_nonrotation(key,[0.;3],256,get)
                .map_err(|_|"W vector rejected")?.ok_or("W required vector missing");
            // Core has no p-vel. Local stationary birth velocity is explicit.
            let velocity=if i==0 {VectorParameter::read_nonrotation("local",[0.;3],256,
                |k|(k=="local").then_some(vec![0.;3])).map_err(|_|"W local velocity invalid")?.unwrap()}
                else{vector("p-vel")?};
            groups.push(Group {rate:scalar("e-rate",1.)?,life:scalar("p-life",1.)?,scale:scalar("p-scale",1.)?,xscale,
                rotation:if i==0 {None}else{Some(scalar("e-rotation1",1.)?)},offset:vector("p-offset")?,velocity,
                emitter_life:[1.,0.5][i],max_particle_life:[0.5,1.][i],single:i==0,
                bind:if i==0 {[1.,1.]}else{[0.5,0.]},color_mode:if i==0 {[0,1]}else{[1,3]},
                color_scale:if i==0 {[0.7,1.]}else{[1.,0.5]},color_offset:if i==0 {[0.,0.]}else{[0.,0.5]},
                start_frame:i as u32,drag:i==1});
        }
        Ok(Self{groups:groups.try_into().map_err(|_|"W group count invalid")?,drag:2.,radius:2000.})
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn base_groups_keep_separate_birth_probability_lifetime_atlas_and_drag_fields(){
        let p=Profile::load().unwrap();let [core,hoop]=p.groups;
        assert_eq!((core.rate.maximum,core.life.maximum,core.scale.maximum,core.single),(1.,0.5,100.,true));
        assert_eq!(core.xscale.table,vec![1.]);assert!(core.rotation.is_none());
        assert_eq!((hoop.rate.maximum,hoop.scale.maximum,hoop.single),(2000.,10.,false));
        assert_eq!(hoop.life.probability.times,vec![0.,0.9,1.]);
        assert_eq!(hoop.life.probability.values,vec![0.1,0.3,1.]);
        assert_eq!(hoop.scale.probability.begin,0.5);assert_eq!(hoop.scale.probability.difference,1.);
        assert_eq!(hoop.rotation.unwrap().probability.difference,360.);
        assert_eq!((core.start_frame,hoop.start_frame),(0,1));
        assert_eq!((p.drag,p.radius),(2.,2000.));assert!(hoop.drag&&!core.drag);
    }
    #[test]
    fn changed_fields_cyber_selection_bad_force_and_wrong_source_disable_the_profile(){
        let d:serde_json::Value=serde_json::from_str(SOURCE).unwrap();
        for case in 0..5 {let mut v=d.clone();match case {
            0=>v["groups"][1]["fields"]["e-rate"]=serde_json::json!(100),
            1=>v["groups"][0]["fields"].as_object_mut().unwrap().remove("p-scale").map(|_|()).unwrap(),
            2=>v["groups"][0]["fields"]["KeywordsExcluded"]=serde_json::json!(""),
            3=>v["Drag"]["f-radius"]=serde_json::json!("NaN"),
            _=>v["source"]["sha256"]=serde_json::json!("changed")}
            assert!(Profile::parse(&v.to_string()).is_err());}
    }
    #[test]
    fn all60_authored_fields_match_original_2080_byte_troy_values(){
        let raw=include_bytes!("../../../data/4.20/particles/ezreal/Ezreal_essenceflux_mis.troybin");
        assert_eq!(raw.len(),2080);let d:serde_json::Value=serde_json::from_str(SOURCE).unwrap();
        let rows:&[(usize,&str,u8,usize,usize,u8)]=&[
            (1,"e-life",2,7,27,0),
            (0,"p-life",2,15,29,0),
            (1,"p-linger",3,42,54,0),
            (1,"p-numframes",4,68,90,0),
            (0,"p-numframes",5,97,213,0),
            (1,"p-life",5,101,213,1),
            (0,"e-local-orient",5,129,214,0),
            (1,"p-startframe",5,149,214,5),
            (1,"e-local-orient",5,153,214,6),
            (0,"e-life",5,157,214,7),
            (0,"e-rate",5,177,215,4),
            (0,"single-particle",5,189,215,7),
            (1,"e-rotation1",5,197,216,1),
            (0,"p-offset",7,280,384,0),
            (1,"p-vel",7,292,420,0),
            (1,"p-offset",7,300,444,0),
            (1,"p-scaleP1",8,522,806,0),
            (1,"p-scaleP2",8,526,808,0),
            (1,"p-bindtoemitter",8,538,814,0),
            (1,"p-texdiv",8,554,822,0),
            (1,"p-xscale1",8,562,826,0),
            (1,"p-xscale2",8,566,828,0),
            (1,"p-velYP1",8,570,830,0),
            (1,"p-velYP2",8,574,832,0),
            (1,"p-colorscale",8,590,840,0),
            (1,"p-lifeP2",8,610,850,0),
            (1,"p-lifeP3",8,614,852,0),
            (1,"e-rotation1P1",8,630,860,0),
            (0,"p-bindtoemitter",8,658,874,0),
            (1,"p-scale2",8,674,882,0),
            (1,"p-scale3",8,678,884,0),
            (0,"p-colortype",8,690,890,0),
            (1,"p-coloroffset",8,714,902,0),
            (1,"p-colortype",8,734,912,0),
            (0,"p-colorscale",8,754,922,0),
            (0,"p-texdiv",8,770,930,0),
            (0,"p-coloroffset",8,782,936,0),
            (1,"e-rotation1P2",9,952,992,0),
            (0,"p-type",12,1112,1462,0),
            (0,"p-startframe",12,1128,1470,0),
            (1,"KeywordsExcluded",12,1184,1498,0),
            (1,"p-scale",12,1196,1504,0),
            (1,"p-rgba",12,1200,1506,0),
            (1,"e-rate",12,1208,1510,0),
            (0,"p-texture",12,1248,1530,0),
            (1,"p-lifeP1",12,1272,1542,0),
            (0,"e-linger",12,1288,1550,0),
            (0,"p-linger",12,1292,1552,0),
            (0,"KeywordsExcluded",12,1304,1558,0),
            (1,"p-scale1",12,1308,1560,0),
            (1,"p-type",12,1316,1564,0),
            (0,"p-rgba",12,1336,1574,0),
            (1,"field-drag-1",12,1356,1584,0),
            (0,"p-frameRate",12,1368,1590,0),
            (1,"rendermode",12,1372,1592,0),
            (1,"p-texture",12,1384,1598,0),
            (0,"p-scale",12,1396,1604,0),
            (1,"e-linger",12,1400,1606,0),
            (1,"p-frameRate",12,1424,1618,0),
            (0,"rendermode",12,1452,1632,0)];
        for &(group,name,kind,key,value,bit) in rows {
            let hash=format!("{}*{name}",["core","hoop"][group]).to_ascii_lowercase().bytes()
                .fold(0u32,|h,b|h.wrapping_mul(65599).wrapping_add(u32::from(b)));
            assert_eq!(u32::from_le_bytes(raw[key..key+4].try_into().unwrap()),hash,"{name}");
            let expected=&d["groups"][group]["fields"][name];
            let values=match kind {
                2=>vec![raw[value] as f32/10.],
                3=>vec![i16::from_le_bytes(raw[value..value+2].try_into().unwrap()) as f32],
                4=>vec![raw[value] as f32],
                5=>vec![f32::from((raw[value]>>bit)&1)],
                7=>(0..3).map(|i|f32::from_le_bytes(raw[value+i*4..value+i*4+4].try_into().unwrap())).collect(),
                8=>vec![raw[value] as f32/10.,raw[value+1] as f32/10.],
                9=>(0..2).map(|i|f32::from_le_bytes(raw[value+i*4..value+i*4+4].try_into().unwrap())).collect(),
                12=>{let start=1636+u16::from_le_bytes(raw[value..value+2].try_into().unwrap()) as usize;
                    let end=start+raw[start..].iter().position(|b|*b==0).unwrap();
                    let text=std::str::from_utf8(&raw[start..end]).unwrap();
                    if let Some(s)=expected.as_str(){assert_eq!(text,s,"{name}");continue;}
                    text.split_whitespace().map(|v|v.parse::<f32>().unwrap()).collect()},
                _=>panic!("unexpected original field type"),
            };
            assert_eq!(numeric(expected),Some(values),"{name}");
        }
        assert_eq!(rows.len(),60);
    }

}
