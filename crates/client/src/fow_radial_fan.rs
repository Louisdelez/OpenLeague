//! Original 6B1140 radial dispatch, including ordered duplicate rays.
pub struct Ray {pub origin:[f32;2],pub end:[f32;2]}
pub const RADIUS_MULTIPLIER:f32=1.1313709020614624;
pub fn rays(center:[f32;2],radius:f32)->Result<Vec<Ray>,&'static str> {
    if center.iter().any(|v|!v.is_finite()) || !radius.is_finite() || radius<0. || radius>4096. {return Err("invalid native fog radial fan");}
    let radius=radius*RADIUS_MULTIPLIER;
    let mut out=Vec::new();let mut emit=|x:f32,z:f32|out.push(Ray {origin:center,end:[x,z]});
    emit(center[0],center[1]+radius);emit(center[0],center[1]-radius);
    emit(center[0]+radius,center[1]);emit(center[0]-radius,center[1]);
    let mut y=(radius*4.).trunc() as i32;let mut error=1-y;let mut x=0;let mut increment=1;
    if y>0 {loop {
        increment+=2;x+=1;
        if error<0 {error+=increment;} else {y-=1;}
        let yf=y as f32*0.25;let xf=x as f32*0.25;
        let(right,left,top,bottom)=(center[0]+yf,center[0]-yf,center[1]+yf,center[1]-yf);
        let(xright,xleft,xtop,xbottom)=(center[0]+xf,center[0]-xf,center[1]+xf,center[1]-xf);
        emit(xright,top);emit(xleft,top);emit(xright,bottom);emit(xleft,bottom);
        if xf!=yf {emit(right,xtop);emit(left,xtop);emit(right,xbottom);emit(left,xbottom);}
        if x>=y {break;}
    }}
    Ok(out)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn ordered_radial_rays_match_original_dispatch() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_radial_fan_contract.json")).unwrap();
        assert_eq!(RADIUS_MULTIPLIER.to_bits(),(p["radius_multiplier"].as_f64().unwrap() as f32).to_bits());
        for c in p["cases"].as_array().unwrap() {
            let center=[c["center"][0].as_f64().unwrap() as f32,c["center"][1].as_f64().unwrap() as f32];let rays=rays(center,c["radius"].as_f64().unwrap() as f32).unwrap();let expected=c["rays"].as_array().unwrap();
            assert_eq!(rays.len(),expected.len());
            for(a,b) in rays.iter().zip(expected) {for i in 0..2 {assert_eq!(a.origin[i].to_bits(),(b["origin"][i].as_f64().unwrap() as f32).to_bits());assert_eq!(a.end[i].to_bits(),(b["end"][i].as_f64().unwrap() as f32).to_bits());}}
        }
    }
}
