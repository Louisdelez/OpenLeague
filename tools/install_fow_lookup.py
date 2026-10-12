from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3');p=r/'crates/client/src/native_fow.rs';b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True);shutil.copy2(p,b/'native_fow.rs')
s=p.read_text(encoding='utf-8');assert 'pub fn raw_mask_is_zero' not in s
s+='''
/// Native6B3F20 raw-byte query. This does not convert the mask into a shader channel.
/// Original code assumes valid coordinates; the port rejects invalid metadata/positions.
pub fn raw_mask_is_zero(native_xz:Vec2,extent:f32,dimension:usize,mask:&[u8])->Result<bool,&'static str> {
    FogParams::from_native_extent(extent)?;
    if dimension==0 || dimension.checked_mul(dimension)!=Some(mask.len()) {return Err("invalid raw fog mask dimensions");}
    if !native_xz.is_finite() || native_xz.x<0. || native_xz.y<0. || native_xz.x>=extent || native_xz.y>=extent {return Err("fog query outside native extent");}
    // Original uses x87 reciprocal and then X/Z multiplication before truncation.
    // Wider intermediates avoid using the f32 vertex-shader reciprocal for CPU indexing.
    let reciprocal=1./extent as f64;
    let x=(native_xz.x as f64*reciprocal*dimension as f64).trunc() as usize;
    let z=(native_xz.y as f64*reciprocal*dimension as f64).trunc() as usize;
    if x>=dimension || z>=dimension {return Err("fog query rounded outside mask");}
    Ok(mask[z*dimension+x]==0)
}
#[cfg(test)]
mod raw_lookup_tests {
    use super::*;
    #[test]
    fn original_x87_point_queries_and_zero_byte_results_match() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_lookup_contract.json")).unwrap();
        assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let d=c["dimension"].as_u64().unwrap() as usize;
            let at=c["sample_index"].as_u64().unwrap() as usize;
            let byte=c["mask_byte"].as_u64().unwrap() as u8;
            let mut mask=vec![if byte==0 {255} else {0};d*d];mask[at]=byte;
            let point=Vec2::new(c["native_x"].as_f64().unwrap() as f32,c["native_z"].as_f64().unwrap() as f32);
            assert_eq!(raw_mask_is_zero(point,c["extent"].as_f64().unwrap() as f32,d,&mask).unwrap(),c["returns_zero"].as_bool().unwrap());
        }
        for point in [Vec2::new(-1.,0.),Vec2::new(0.,-1.),Vec2::new(128.,0.),Vec2::new(0.,128.),Vec2::new(f32::NAN,0.)] {assert!(raw_mask_is_zero(point,128.,128,&vec![0;128*128]).is_err());}
        assert!(raw_mask_is_zero(Vec2::ZERO,128.,128,&[0;128]).is_err());
        assert!(raw_mask_is_zero(Vec2::ZERO,128.,usize::MAX,&[]).is_err());
    }
}
''';p.write_text(s,encoding='utf-8');shutil.copy2(w/'probe_native_fow_lookup.py',r/'tools/probe_native_fow_lookup.py');shutil.copy2(w/'install_fow_lookup.py',r/'tools/install_fow_lookup.py')
print('Native raw mask query ported with guarded metadata and coordinates; GPU channel conversion separate.')
