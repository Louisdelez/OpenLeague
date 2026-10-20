//! Exact known fields of original Troy group1. Runtime phase and absent fields
//! are selected by LocalPolicy, never represented as recovered native defaults.
use openleague_core::{native_scalar_parameter::ScalarParameter,
    native_vector_parameter::VectorParameter};
pub const POLICY: &str = "ezreal_r_visible_sparks_local_v1";
pub const TROY: &str = "ef031f67d12c46e03f3073063b3fdd13ac83d46dd097002141e94f8bb27ed319";
pub const SOURCE: &str = include_str!("../../../data/4.20/particles/ezreal/r_sparks_profile.json");
pub const IMAGE: &str = "particles/ezreal/r_sparks/flare-sun.dds";
pub const COLOR: &str = "particles/ezreal/r_sparks/color-shockwaveyellow.dds";
#[derive(Clone, Debug)]
pub struct Profile {
    pub rate: ScalarParameter, pub life: ScalarParameter, pub scale: ScalarParameter,
    pub xscale: ScalarParameter, pub rotation: ScalarParameter,
    pub offset: VectorParameter, pub velocity: VectorParameter,
    pub emitter_life: f32, pub particle_linger: f32, pub bind: [f32; 2],
}
fn numeric(value: &serde_json::Value) -> Option<Vec<f32>> {
    value.as_array()?.iter().map(|v| {
        let n = v.as_f64()? as f32; n.is_finite().then_some(n)
    }).collect()
}
impl Profile {
    pub fn load() -> Result<Self, &'static str> { Self::parse(SOURCE) }
    fn parse(text: &str) -> Result<Self, &'static str> {
        let doc: serde_json::Value = serde_json::from_str(text).map_err(|_| "invalid R sparks JSON")?;
        let fields = doc["fields"].as_object().ok_or("R sparks fields absent")?;
        if doc["schema"] != "OpenLeague_R_sparks_authored/v1" || doc["troy_sha256"] != TROY
            || doc["slot"] != 1 || doc["group"] != "sparks" || doc["class"] != "Simple"
            || fields.len() != 31 { return Err("R sparks source identity changed"); }
        let get = |key: &str| fields.get(key).and_then(numeric);
        // Exact finite subset; an unsupported field does not silently become a
        // parameter default. In particular scale3 and scaleP2 are separate keys.
        let expected: &[(&str, &[f32])] = &[
            ("e-life", &[10.]), ("e-rate", &[2000.]), ("p-life", &[1.]), ("p-linger", &[1.]),
            ("p-scale", &[20.]), ("p-scale1", &[0.,0.]), ("p-scale2", &[0.01,2.]),
            ("p-scale3", &[1.,1.]), ("p-scaleP1", &[0.,0.5]), ("p-scaleP2", &[1.,1.]),
            ("p-lifeP1", &[0.,0.1]), ("p-lifeP2", &[0.9,0.2]), ("p-lifeP3", &[1.,1.]),
            ("p-offset", &[0.,130.,0.]), ("p-offsetXP1", &[0.,-240.]), ("p-offsetXP2", &[1.,240.]),
            ("p-vel", &[1.,-1.,0.]), ("p-velYP1", &[0.,1.]), ("p-velYP2", &[1.,1.]),
            ("e-rotation1", &[1.]), ("e-rotation1-axis", &[0.,0.,1.]),
            ("e-rotation1P1", &[0.,-80.]), ("e-rotation1P2", &[1.,80.]),
            ("p-bindtoemitter", &[0.8,0.]), ("p-colortype", &[1.,3.]),
            ("p-xscale", &[1.]), ("p-xscale1", &[0.,1.]), ("p-xscale2", &[1.,0.]),
        ];
        for (key, values) in expected {
            if get(key).as_deref() != Some(*values) { return Err("unsupported R sparks numeric field"); }
        }
        for (key, value) in [("p-texture", "flare-sun.dds"), ("p-rgba", "color-shockwaveyellow.tga"),
            ("KeywordsExcluded", "CyberEzreal Cyber1Ezreal Cyber2Ezreal Cyber3Ezreal")] {
            if fields.get(key).and_then(|v| v.as_str()) != Some(value) { return Err("unsupported R sparks text field"); }
        }
        let scalar = |key: &str| ScalarParameter::read_numeric(key, 0., get)
            .map_err(|_| "R sparks scalar rejected")?.ok_or("R sparks scalar absent");
        let vector = |key: &str| VectorParameter::read_nonrotation(key, [0.;3], 256, get)
            .map_err(|_| "R sparks vector rejected")?.ok_or("R sparks vector absent");
        Ok(Self { rate: scalar("e-rate")?, life: scalar("p-life")?, scale: scalar("p-scale")?,
            xscale: scalar("p-xscale")?, rotation: scalar("e-rotation1")?,
            offset: vector("p-offset")?, velocity: vector("p-vel")?,
            emitter_life: 10., particle_linger: 1., bind: [0.8,0.] })
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn all31_bound_fields_equal_the_original_troy_wire_values() {
        let raw=include_bytes!("../../../data/4.20/particles/ezreal/Ezreal_TrueShot_mis.troybin");
        assert_eq!(raw.len(),4141);
        let document:serde_json::Value=serde_json::from_str(SOURCE).unwrap();
        // Exact key/value offsets from the immutable original4141-byte Troy,
        // not from the intermediate typed export that conflated scale families.
        let rows=&[("p-texture",12,1113,2345),("p-vel",12,1201,2389),
            ("e-rotation1P1",12,1277,2427),("e-rotation1P2",12,1281,2429),
            ("p-linger",12,1413,2495),("p-offset",12,1461,2519),
            ("p-scaleP1",12,1605,2591),("p-scaleP2",8,479,657),
            ("p-life",12,1741,2659),("p-scale",12,1757,2667),
            ("p-xscale1",12,1773,2675),("p-xscale2",12,1777,2677),
            ("e-life",12,1833,2705),("p-rgba",12,1881,2729),
            ("e-rotation1",12,1909,2743),("e-rate",12,1913,2745),
            ("p-colortype",8,535,685),("p-offsetXP1",12,2001,2789),
            ("p-offsetXP2",12,2005,2791),("KeywordsExcluded",12,2009,2793),
            ("p-velYP1",12,2029,2803),("p-velYP2",8,547,691),
            ("p-lifeP1",12,2121,2849),("p-lifeP2",8,559,697),("p-lifeP3",8,563,699),
            ("e-rotation1-axis",12,2177,2877),("p-bindtoemitter",12,2201,2889),
            ("p-scale1",12,2245,2911),("p-scale2",9,779,899),("p-scale3",8,595,715),
            ("p-xscale",12,2261,2919)];
        for &(name,kind,key,value) in rows {
            let hash=format!("sparks*{name}").to_ascii_lowercase().bytes()
                .fold(0u32,|h,b|h.wrapping_mul(65599).wrapping_add(u32::from(b)));
            assert_eq!(u32::from_le_bytes(raw[key..key+4].try_into().unwrap()),hash,"{name}");
            let expected=&document["fields"][name];
            let decoded=match kind {
                8=>vec![raw[value] as f32/10.,raw[value+1] as f32/10.],
                9=>(0..2).map(|j|f32::from_le_bytes(raw[value+j*4..value+j*4+4].try_into().unwrap())).collect(),
                12=> {
                    let begin=2933+u16::from_le_bytes(raw[value..value+2].try_into().unwrap()) as usize;
                    let end=begin+raw[begin..].iter().position(|b|*b==0).unwrap();
                    let text=std::str::from_utf8(&raw[begin..end]).unwrap();
                    if let Some(expected)=expected.as_str() {assert_eq!(text,expected,"{name}");continue;}
                    text.split_whitespace().map(|n|n.parse::<f32>().unwrap()).collect()
                }
                _=>panic!("unsupported source field type"),
            };
            assert_eq!(numeric(expected),Some(decoded),"{name}");
        }
        assert_eq!(rows.len(),document["fields"].as_object().unwrap().len());
    }
    #[test]
    fn authored_scale_and_probability_families_remain_independent() {
        let p = Profile::load().unwrap();
        assert_eq!(p.scale.maximum, 40.); assert_eq!(p.scale.table.len(), 256);
        assert_eq!(p.scale.table[0], 0.); assert!(p.scale.table[3] > 39.);
        assert!(p.scale.probability.fast); assert_eq!(p.scale.probability.begin, 0.5);
        assert_eq!(p.scale.probability.difference, 0.5);
        assert_eq!(p.life.probability.times, vec![0.,0.9,1.]);
        assert_eq!(p.life.probability.values, vec![0.1,0.2,1.]);
        assert_eq!(p.offset.table, vec![[0.,130.,0.]]);
        assert_eq!(p.offset.probabilities[0].begin, -240.);
        assert_eq!(p.rotation.probability.begin, -80.);
        assert_eq!(p.xscale.table[0], 1.); assert!(p.xscale.table[255] < 0.004);
    }
    #[test]
    fn unknown_fields_missing_curves_and_cyber_profile_are_rejected() {
        let original: serde_json::Value = serde_json::from_str(SOURCE).unwrap();
        for case in 0..4 {
            let mut changed = original.clone();
            match case { 0 => { changed["fields"]["p-type"] = serde_json::json!([0]); },
                1 => { changed["fields"].as_object_mut().unwrap().remove("p-scale3"); },
                2 => changed["fields"]["KeywordsExcluded"] = serde_json::json!(""),
                _ => changed["fields"]["p-life"] = serde_json::json!([2.]) }
            assert!(Profile::parse(&changed.to_string()).is_err());
        }
    }
}
