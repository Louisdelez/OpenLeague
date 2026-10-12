//! Original Simple type0 packet92F160, UV92EF10 and rounded ARGB90F2B0.
//! Selected p-local-orient=false and type0 (height adjustment=false) only.
//! This helper does not compute camera axes or interpret shader/atlas channels.
//! Candidate only: Rust compilation and target-platform equivalence remain to run.

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Input {
    pub center: [f32; 3],
    /// Already scaled vectors supplied by the original caller's basis policy.
    pub axis_a: [f32; 3],
    pub axis_b: [f32; 3],
    /// Already prepared RGBA (including any caller premultiplication).
    pub rgba: [f32; 4],
    pub channel0_origin: [f32; 2],
    pub channel0_z: f32,
    pub channel1_origin: [f32; 2],
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Error { NonFinite, ColorOutsideQualifiedDomain, ArithmeticOverflow }

/// Exact native layout per vertex: position.xyz, ARGB8, channel0.xyzw,
/// channel1.xy, channel2.xy. Each row is 48 bytes when serialized little-endian.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct Quad { pub words: [[u32; 12]; 4] }

impl Quad {
    pub fn bytes(self) -> [u8; 192] {
        let mut bytes = [0; 192];
        for (i, word) in self.words.into_iter().flatten().enumerate() {
            bytes[i * 4..i * 4 + 4].copy_from_slice(&word.to_le_bytes());
        }
        bytes
    }
}

pub fn pack(input: Input) -> Result<Quad, Error> {
    if input.center.into_iter().chain(input.axis_a).chain(input.axis_b)
        .chain(input.rgba).chain(input.channel0_origin).chain([input.channel0_z])
        .chain(input.channel1_origin).any(|v| !v.is_finite()) { return Err(Error::NonFinite); }
    if input.rgba.iter().any(|v| !(0.0..=1.0).contains(v)) { return Err(Error::ColorOutsideQualifiedDomain); }
    //90F2B0 clamps 0..1 and rounds positive x87 value*255+.5 before truncation.
    // Domain is finite0..1, retaining exact f32 input promoted to f64.
    let c = input.rgba.map(|v| (f64::from(v) * 255.0 + 0.5).trunc() as u32);
    let argb = (c[3] << 24) | (c[0] << 16) | (c[1] << 8) | c[2];
    let p = input.center; let a = input.axis_a; let b = input.axis_b;
    let positions = [
        std::array::from_fn::<_, 3, _>(|i| (p[i] + a[i]) - b[i]),
        std::array::from_fn(|i| (p[i] + a[i]) + b[i]),
        std::array::from_fn(|i| (p[i] - a[i]) + b[i]),
        std::array::from_fn(|i| (p[i] - a[i]) - b[i]),
    ];
    let corners = [[0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]];
    let mut quad = Quad { words: [[0; 12]; 4] };
    for i in 0..4 {
        let [x, y] = corners[i];
        // The original uses load/store at zero corners, not add(+0). Preserve
        // signed zero and exact input bits on those edges.
        let u = if x == 0.0 { input.channel0_origin[0] } else { input.channel0_origin[0] + x };
        let v = if y == 0.0 { input.channel0_origin[1] } else { input.channel0_origin[1] + y };
        let s = input.channel1_origin[0];
        let t = input.channel1_origin[1];
        let fields = [positions[i][0], positions[i][1], positions[i][2], u, v,
            input.channel0_z, 0.0, s, t, x, y];
        if fields.iter().any(|v| !v.is_finite()) { return Err(Error::ArithmeticOverflow); }
        quad.words[i] = [fields[0].to_bits(), fields[1].to_bits(), fields[2].to_bits(), argb,
            fields[3].to_bits(), fields[4].to_bits(), fields[5].to_bits(), fields[6].to_bits(),
            fields[7].to_bits(), fields[8].to_bits(), fields[9].to_bits(), fields[10].to_bits()];
    }
    Ok(quad)
}

///92B210 transposes the original LH view;92E570 uses cross(up,right).
///Only table entry0 is admitted: absent p-quadrot/rotvel in the two actual profiles.
#[derive(Clone,Copy,Debug)]
pub struct Axes {pub a:[f32;3],pub b:[f32;3]}
fn neg(v:f32)->f32{f32::from_bits(v.to_bits()^0x8000_0000)}
pub fn axes_zero(view:[f32;16])->Result<Axes,Error>{
    if view.iter().any(|v|!v.is_finite()){return Err(Error::NonFinite);}
    let up=[view[1],view[5],view[9]];let right=[view[0],view[4],view[8]];
    let x=right[1]*up[2]-right[2]*up[1];let y=up[0]*right[2]-right[0]*up[2];
    let z=neg(right[0]*up[1]-up[0]*right[1]);
    let (xx,yy,zz)=(x*x,y*y,z*z);let (xy,zx,zy)=(x*y,z*x,z*y);
    // Original PE sine[0]=0 and sine[900]=1, verified by the native fixture.
    let (s,c)=(0f32,1f32);let t=1.-c;
    let (zs,ys,xs)=(z*s,y*s,s*x);let (txy,txz,tyz)=(t*xy,zx*t,zy*t);
    let (r00,r11,r22)=((1.-xx)*c+xx,(1.-yy)*c+yy,(1.-zz)*c+zz);
    let vector=|v:[f32;3]|[
        ((zs+txy)*v[1]+r00*v[0])-(txz-ys)*v[2],
        ((txy-zs)*v[0]+r11*v[1])-(xs+tyz)*v[2],
        neg(((tyz-xs)*v[1]+(ys+txz)*v[0])-r22*v[2])];
    let a=vector(up);let b=vector(right);
    if a.into_iter().chain(b).any(|v|!v.is_finite()){return Err(Error::ArithmeticOverflow);}Ok(Axes{a,b})
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn simple_angle_zero_matches16_native_camera_prefix_and_table_outputs(){
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_glow_axes_vectors.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),16);
        for c in cases {let a=axes_zero(std::array::from_fn(|i|f32::from_bits(c["view_bits"][i].as_u64().unwrap() as u32))).unwrap();
            assert_eq!(a.a.into_iter().chain(a.b).map(f32::to_bits).collect::<Vec<_>>(),c["angle0_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());}
        assert!(axes_zero([f32::NAN;16]).is_err());
    }
    #[test]
    fn simple_quad_matches_all192_bytes_from14_whole_native_returns() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_glow_quad_vectors.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),14);
        for c in cases {
            let v=&c["input"];let a=|key:&str,i:usize|v[key][i].as_f64().unwrap() as f32;
            let out=pack(Input{center:std::array::from_fn(|i|a("center",i)),axis_a:std::array::from_fn(|i|a("axis_a",i)),
                axis_b:std::array::from_fn(|i|a("axis_b",i)),rgba:std::array::from_fn(|i|a("rgba",i)),
                channel0_origin:std::array::from_fn(|i|a("channel0_origin",i)),channel0_z:v["channel0_z"].as_f64().unwrap() as f32,
                channel1_origin:std::array::from_fn(|i|a("channel1_origin",i))}).unwrap();
            assert_eq!(out.words.into_iter().flatten().collect::<Vec<_>>(),c["output_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
        }
        //Simple rounds 0.5 to128; the separate Complex packer truncates to127.
        assert_eq!((pack(Input{center:[0.;3],axis_a:[0.;3],axis_b:[0.;3],rgba:[0.5;4],channel0_origin:[0.;2],
            channel0_z:0.,channel1_origin:[0.;2]}).unwrap().words[0][3]>>24)&255,128);
    }
}
