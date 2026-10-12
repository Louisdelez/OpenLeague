//! Original non-occluded, unowned circular source rasterization at 6B14E0.
use crate::fow_regions::StencilRegion;
pub struct Circle {pub center:[f32;2],pub radius:f32,pub scale:f32,pub bias:f32}
impl Circle {
    pub fn bounds(&self,dimension:usize,extent:f32)->Result<[usize;4],&'static str> {
        if dimension==0 || dimension>4096 || !extent.is_finite() || extent<=0.
            || self.center.iter().any(|v|!v.is_finite()) || !self.radius.is_finite() || self.radius<0.
            || !self.scale.is_finite() || !self.bias.is_finite() {return Err("invalid fog circle inputs");}
        let reciprocal=1./extent;let n=dimension as f32;
        // The radius virtual method keeps its result on x87 until dimension is
        // added. Predicate radius instead uses SSE scalar multiplies/adds.
        let padded=((self.radius as f64)*(self.scale as f64)+(self.bias as f64)+(n as f64)) as f32;
        let radius=self.radius*self.scale+self.bias;
        if !reciprocal.is_finite() || !padded.is_finite() || !radius.is_finite() || radius<0. {return Err("unsupported fog circle radius");}
        let mut rect=[0usize;4];
        for axis in 0..2 {
            let low=((self.center[axis]-padded)*reciprocal)*n;
            let high=((self.center[axis]+padded)*reciprocal)*n;
            if !low.is_finite() || !high.is_finite() || low.abs()>2147483000. || high.abs()>2147483000. {return Err("fog circle bounds overflow");}
            rect[axis]=(low.round_ties_even() as i64-1).clamp(0,dimension as i64) as usize;
            rect[axis+2]=(high.round_ties_even() as i64+1).clamp(0,dimension as i64) as usize;
        }
        if rect[0]>rect[2] || rect[1]>rect[3] {return Err("invalid fog circle rectangle");}
        Ok(rect)
    }
    pub fn stencil(&self,dimension:usize,extent:f32)->Result<StencilRegion,&'static str> {
        let rect=self.bounds(dimension,extent)?;
        let n=dimension as f32;let radius=self.radius*self.scale+self.bias;
        let cells=dimension.checked_mul(dimension).ok_or("fog circle grid overflow")?;
        let mut words=vec![0u32;cells.div_ceil(32)];
        let inverse_dimension=1./n;
        for x in rect[0]..rect[2] {for z in rect[1]..rect[3] {
            let world_x=(x as f32*extent)*inverse_dimension;let world_z=(z as f32*extent)*inverse_dimension;
            let dx=self.center[0]-world_x;let dz=self.center[1]-world_z;
            if radius*radius>dz*dz+dx*dx {let index=z*dimension+x;words[index/32]|=1<<(index%32);}
        }}
        Ok(StencilRegion {words,rect,applied:false})
    }
}

pub struct Cone {pub circle:Circle,pub direction:[f32;2],pub threshold:f32}
impl Cone {
    pub fn direction_contains(&self,point:[f32;2])->Result<bool,&'static str> {
            let mut dx=point[0]-self.circle.center[0];
            let mut dz=point[1]-self.circle.center[1];
            let sum=dz*dz+dx*dx;
            if !sum.is_finite() {return Err("fog cone distance overflow");}
            let bits=0x5f3759dfi32.wrapping_sub((sum.to_bits() as i32)>>1);
            let guess=f32::from_bits(bits as u32);
            let mut half=sum*0.5;half*=guess;half*=guess;
            let inverse=(1.5-half)*guess;
            if inverse>0. {dx*=inverse;dz*=inverse;}
            let dot=self.direction[1]*dz+self.direction[0]*dx;

            Ok(dot>=self.threshold)
    }
    pub fn stencil(&self,dimension:usize,extent:f32)->Result<StencilRegion,&'static str> {
        if self.direction.iter().any(|v|!v.is_finite()) || !self.threshold.is_finite() {return Err("invalid fog cone direction");}
        let mut region=self.circle.stencil(dimension,extent)?;
        let inv=1./dimension as f32;
        for x in region.rect[0]..region.rect[2] {for z in region.rect[1]..region.rect[3] {
            let index=z*dimension+x;let bit=1u32<<(index%32);
            if region.words[index/32]&bit==0 {continue;}
            if !self.direction_contains([(x as f32*extent)*inv,(z as f32*extent)*inv])? {region.words[index/32]&=!bit;}
        }}
        Ok(region)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test] fn nonoccluded_circle_stencil_matches_full_original_generator() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_circle_stencil_contract.json")).unwrap();
        for c in proof["cases"].as_array().unwrap() {
            let dim=c["dimension"].as_u64().unwrap() as usize;
            let circle=Circle {center:[c["center"][0].as_f64().unwrap() as f32,c["center"][1].as_f64().unwrap() as f32],radius:c["radius"].as_f64().unwrap() as f32,scale:c["scale"].as_f64().unwrap() as f32,bias:c["bias"].as_f64().unwrap() as f32};
            let actual=circle.stencil(dim,c["extent"].as_f64().unwrap() as f32).unwrap();
            let expected:Vec<u32>=c["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(actual.words,expected);
            for i in 0..4 {assert_eq!(actual.rect[i],c["rect"][i].as_u64().unwrap() as usize);}
            assert_eq!(actual.words.iter().map(|w|w.count_ones() as u64).sum::<u64>(),c["selected_cells"].as_u64().unwrap());
        }
    }

    #[test] fn cone_stencils_match_original_approximate_direction_predicate() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_cone_stencil_contract.json")).unwrap();
        for c in proof["cases"].as_array().unwrap() {
            let n=c["dimension"].as_u64().unwrap() as usize;
            let circle=Circle {center:[c["center"][0].as_f64().unwrap() as f32,c["center"][1].as_f64().unwrap() as f32],radius:c["radius"].as_f64().unwrap() as f32,scale:1.,bias:0.};
            let cone=Cone {circle,direction:[c["direction"][0].as_f64().unwrap() as f32,c["direction"][1].as_f64().unwrap() as f32],threshold:c["threshold"].as_f64().unwrap() as f32};
            let actual=cone.stencil(n,c["extent"].as_f64().unwrap() as f32).unwrap();
            let expected:Vec<u32>=c["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(actual.words,expected);
            for i in 0..4 {assert_eq!(actual.rect[i],c["rect"][i].as_u64().unwrap() as usize);}
        }
    }
    #[test] fn circle_radius_edge_is_strict_and_bad_inputs_are_explicit() {
        let c=Circle {center:[128.,128.],radius:32.,scale:1.,bias:0.};let mask=c.stencil(8,256.).unwrap();
        assert_eq!(mask.words.iter().map(|w|w.count_ones()).sum::<u32>(),1);
        assert!(c.stencil(0,256.).is_err());assert!(c.stencil(128,f32::NAN).is_err());
    }
}
