//! Original 6B0DB0 grid clipping before terrain tracing at 6B09E0.
//! Keeps sequential native clipping and its epsilon, not a generic line algorithm.
pub struct ClippedRay {pub origin:[f32;2],pub delta:[f32;2]}
pub fn clip(dimension:usize,origin:[f32;2],end:[f32;2])->Result<Option<ClippedRay>,&'static str> {
    if dimension<3 || dimension>4096 || origin.into_iter().chain(end).any(|v|!v.is_finite()) {return Err("invalid fog ray clipping input");}
    let limit=dimension as f32-1.;let epsilon=0.01f32;
    let(mut sx,mut sz)=(origin[0],origin[1]);let(ex,ez)=(end[0],end[1]);
    let(mut dx,mut dz)=(ex-sx,ez-sz);
    if !dx.is_finite() || !dz.is_finite() {return Err("fog ray delta overflow");}
    if sx>limit {
        if ex>limit {return Ok(None);}
        dx=-dx;let t=(limit-ex)/(dx+epsilon);
        sz=ez-t*dz;sx=ex+t*dx;dz=ez-sz;dx=ex-sx;
    }
    if sx<=1. {
        if ex<=1. {return Ok(None);}
        let t=(ex-1.)/(dx+epsilon);
        sz=ez-t*dz;sx=ex-t*dx;dz=ez-sz;dx=ex-sx;
    }
    if sz>limit {
        if ez>limit {return Ok(None);}
        dz=-dz;let t=(limit-ez)/(dz+epsilon);
        sz=ez+t*dz;sx=ex-t*dx;dz=ez-sz;dx=ex-sx;
    }
    if sz<=1. {
        if ez<=1. {return Ok(None);}
        let t=(ez-1.)/(dz+epsilon);
        sz=ez-t*dz;sx=ex-t*dx;dz=ez-sz;dx=ex-sx;
    }
    let(mut tx,mut tz)=(ex,ez);
    if tx>limit {
        if sx>limit {return Ok(None);}
        let t=(limit-sx)/(dx+epsilon);tz=sz+t*dz;tx=sx+t*dx;dz=tz-sz;dx=tx-sx;
    }
    if tx<=1. {
        if sx<=1. {return Ok(None);}
        let t=(sx-1.)/(epsilon-dx);tz=sz+t*dz;tx=sx+t*dx;dz=tz-sz;dx=tx-sx;
    }
    if tz>limit {
        if sz>limit {return Ok(None);}
        let t=(limit-sz)/(dz+epsilon);tz=sz+t*dz;tx=sx+t*dx;dz=tz-sz;dx=tx-sx;
    }
    if tz<=1. {
        if sz<=1. {return Ok(None);}
        let t=(sz-1.)/(epsilon-dz);tz=sz+t*dz;tx=sx+t*dx;dz=tz-sz;dx=tx-sx;
    }
    if dx.abs()<=epsilon && dz.abs()<=epsilon {return Ok(None);}
    if !sx.is_finite() || !sz.is_finite() || !dx.is_finite() || !dz.is_finite() {return Err("unsupported fog ray clipping arithmetic");}
    Ok(Some(ClippedRay {origin:[sx,sz],delta:[dx,dz]}))
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn clipped_segments_match_original_before_terrain_trace() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_ray_clip_contract.json")).unwrap();
        let pair=|v:&serde_json::Value|[v[0].as_f64().unwrap() as f32,v[1].as_f64().unwrap() as f32];
        for c in p["cases"].as_array().unwrap() {
            let actual=clip(c["dimension"].as_u64().unwrap() as usize,pair(&c["origin"]),pair(&c["end"])).unwrap();let expected=&c["clipped"];
            assert_eq!(actual.is_none(),expected.is_null());
            if let Some(actual)=actual {
                for i in 0..2 {assert_eq!(actual.origin[i].to_bits(),pair(&expected["origin"])[i].to_bits(),"origin {}",c);assert_eq!(actual.delta[i].to_bits(),pair(&expected["delta"])[i].to_bits(),"delta {}",c);}
            }
        }
    }
    #[test] fn invalid_and_degenerate_rays_are_explicit() {
        assert!(clip(128,[f32::NAN,2.],[3.,4.]).is_err());assert!(clip(0,[2.,2.],[3.,3.]).is_err());
        assert!(clip(128,[4.,4.],[4.,4.]).unwrap().is_none());
    }
}
