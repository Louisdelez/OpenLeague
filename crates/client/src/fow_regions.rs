//! Original6B2D80/6B2E60 source-counter and vertically flipped texture updates.
//! Region stencil generation and live GPU upload remain separate contracts.
pub struct StencilRegion {pub words:Vec<u32>,pub rect:[usize;4],pub applied:bool}
impl StencilRegion {
    fn validate(&self,dimension:usize,rect:[usize;4],counts:&[u8],pixels:&[u8])->Result<(),&'static str> {
        let size=dimension.checked_mul(dimension).ok_or("fog dimension overflow")?;
        if dimension==0 || counts.len()!=size || pixels.len()!=size || self.words.len()!=size.div_ceil(32) {return Err("fog region storage mismatch");}
        if rect[0]>rect[2] || rect[1]>rect[3] || rect[2]>dimension || rect[3]>dimension {return Err("fog region bounds invalid");}
        Ok(())
    }
    fn contains_bit(&self,index:usize)->bool {self.words[index/32]&(1u32<<(index%32))!=0}
    pub fn add_to(&mut self,dimension:usize,rect:[usize;4],counts:&mut [u8],pixels:&mut [u8])->Result<(),&'static str> {
        self.validate(dimension,rect,counts,pixels)?;self.rect=rect;
        for z in rect[1]..rect[3] {for x in rect[0]..rect[2] {
            let index=z*dimension+x;
            if self.contains_bit(index) {counts[index]=counts[index].saturating_add(1);pixels[(dimension-z-1)*dimension+x]=255;}
        }}
        self.applied=true;Ok(())
    }
    pub fn remove_from(&mut self,dimension:usize,counts:&mut [u8],pixels:&mut [u8])->Result<(),&'static str> {
        self.validate(dimension,self.rect,counts,pixels)?;
        for z in self.rect[1]..self.rect[3] {for x in self.rect[0]..self.rect[2] {
            let index=z*dimension+x;
            if self.contains_bit(index) {counts[index]=counts[index].saturating_sub(1);}
            // Original removal refreshes all pixels in the rectangle, even unset bits.
            pixels[(dimension-z-1)*dimension+x]=if counts[index]!=0 {255} else {0};
        }}
        self.applied=false;
        Ok(())
    }
    /// Original 6B3EF0: retiring an unapplied source has no count/texture effect.
    pub fn remove_if_applied(&mut self,dimension:usize,counts:&mut [u8],pixels:&mut [u8])->Result<bool,&'static str> {
        if !self.applied {return Ok(false);}
        self.remove_from(dimension,counts,pixels)?;
        Ok(true)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn compare(proof:&str,add:bool) {
        let p:serde_json::Value=serde_json::from_str(proof).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let dim=c["dimension"].as_u64().unwrap() as usize;let size=dim*dim;
            let rect:Vec<usize>=c["rect"].as_array().unwrap().iter().map(|n|n.as_u64().unwrap() as usize).collect();let rect:[usize;4]=rect.try_into().unwrap();
            let initial=c["initial_count"].as_u64().unwrap() as u8;let pattern=c["pattern"].as_u64().unwrap();let mut words=vec![0;size.div_ceil(32)];
            for i in 0..size {if pattern==1 || pattern==2 && i%2==0 {words[i/32]|=1<<(i%32);}}
            let mut region=StencilRegion {words,rect,applied:false};let mut counts=vec![initial;size];let mut pixels=vec![90;size];
            if add {region.rect=[0;4];region.add_to(dim,rect,&mut counts,&mut pixels).unwrap();assert!(region.applied);assert_eq!(region.rect,rect);}
            else {region.remove_from(dim,&mut counts,&mut pixels).unwrap();assert!(!region.applied);}
            for change in c["changes"].as_array().unwrap() {assert_eq!(counts[change["index"].as_u64().unwrap() as usize],change["count"].as_u64().unwrap() as u8);assert_eq!(pixels[change["texture_index"].as_u64().unwrap() as usize],change["visibility"].as_u64().unwrap() as u8);}
            for z in 0..dim {for x in 0..dim {if x<rect[0] || x>=rect[2] || z<rect[1] || z>=rect[3] {assert_eq!(counts[z*dim+x],initial);assert_eq!(pixels[(dim-z-1)*dim+x],90);}}}
            let old_counts=counts.clone();let old_pixels=pixels.clone();
            assert!(region.add_to(dim,[0,0,dim+1,dim],&mut counts,&mut pixels).is_err());assert_eq!(counts,old_counts);assert_eq!(pixels,old_pixels);
        }
    }
    #[test] fn native_add_preserves_unselected_pixels_and_saturates_overlap_counts() {compare(include_str!("../../../data/4.20/fow_add_region_contract.json"),true);}
    #[test] fn native_remove_refreshes_rect_pixels_and_never_underflows() {compare(include_str!("../../../data/4.20/fow_remove_region_contract.json"),false);}
}

/// One visibility layer. Team selection and native scheduling remain caller contracts.
pub struct CountedLayer {
    dimension:usize,
    pub counts:Vec<u8>,
    pub pixels:Vec<u8>,
    sources:std::collections::BTreeMap<u64,StencilRegion>,
}
impl CountedLayer {
    pub fn new(dimension:usize)->Result<Self,&'static str> {
        if dimension==0 || dimension>4096 {return Err("unsupported fog layer dimension");}
        let size=dimension.checked_mul(dimension).ok_or("fog layer size overflow")?;
        Ok(Self {dimension,counts:vec![0;size],pixels:vec![0;size],sources:Default::default()})
    }
    pub fn dimension(&self)->usize {self.dimension}
    /// Source-owned cache path: one applied flag stays with the actual source region.
    pub fn replace_external(&mut self,previous:Option<&mut StencilRegion>,replacement:&mut StencilRegion)->Result<(),&'static str> {
        if replacement.applied {return Err("fog replacement is already applied");}
        replacement.validate(self.dimension,replacement.rect,&self.counts,&self.pixels)?;
        if let Some(previous)=previous {previous.remove_if_applied(self.dimension,&mut self.counts,&mut self.pixels)?;}
        let rect=replacement.rect;replacement.add_to(self.dimension,rect,&mut self.counts,&mut self.pixels)
    }
    pub fn retire_external(&mut self,mask:&mut StencilRegion)->Result<bool,&'static str> {
        mask.remove_if_applied(self.dimension,&mut self.counts,&mut self.pixels)
    }
    pub fn install(&mut self,key:u64,mut mask:StencilRegion)->Result<(),&'static str> {
        if mask.applied {return Err("fog layer requires an unapplied replacement mask");}
        // Validate before retiring the prior contribution so failed input preserves it.
        mask.validate(self.dimension,mask.rect,&self.counts,&self.pixels)?;
        if let Some(previous)=self.sources.get_mut(&key) {previous.remove_if_applied(self.dimension,&mut self.counts,&mut self.pixels)?;}
        let rect=mask.rect;mask.add_to(self.dimension,rect,&mut self.counts,&mut self.pixels)?;
        self.sources.insert(key,mask);
        Ok(())
    }
    pub fn retire(&mut self,key:u64)->Result<bool,&'static str> {
        let Some(mask)=self.sources.get_mut(&key) else {return Ok(false);};
        mask.remove_if_applied(self.dimension,&mut self.counts,&mut self.pixels)?;
        self.sources.remove(&key);
        Ok(true)
    }
}
#[cfg(test)] mod retirement_tests {
    use super::*;
    #[test] fn source_retirement_matches_original_wrapper_and_repeated_calls() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_source_retirement_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),72);
        for c in proof["cases"].as_array().unwrap() {
            let n=c["dimension"].as_u64().unwrap() as usize;let size=n*n;
            let rect=std::array::from_fn(|i|c["rect"][i].as_u64().unwrap() as usize);
            let pattern=c["pattern"].as_u64().unwrap();let initial=c["initial_count"].as_u64().unwrap() as u8;
            let mut words=vec![0;size.div_ceil(32)];
            for i in 0..size {if pattern==1 || pattern==2 && i%2==0 {words[i/32]|=1<<(i%32);}}
            let mut mask=StencilRegion {words,rect,applied:c["initial_applied"].as_bool().unwrap()};
            let mut counts=vec![initial;size];let mut pixels=vec![90;size];
            for output in c["outputs"].as_array().unwrap() {
                mask.remove_if_applied(n,&mut counts,&mut pixels).unwrap();
                assert_eq!(mask.applied,output["applied"].as_bool().unwrap(),"source applied {c}");
                for cell in output["changes"].as_array().unwrap() {
                    assert_eq!(counts[cell["index"].as_u64().unwrap() as usize],cell["count"].as_u64().unwrap() as u8);
                    assert_eq!(pixels[cell["texture_index"].as_u64().unwrap() as usize],cell["visibility"].as_u64().unwrap() as u8);
                }
                for z in 0..n {for x in 0..n {if x<rect[0] || x>=rect[2] || z<rect[1] || z>=rect[3] {assert_eq!(counts[z*n+x],initial);assert_eq!(pixels[(n-z-1)*n+x],90);}}}
            }
        }
    }
    #[test] fn counted_layer_matches_original_map10_overlap_replacement_and_retirement() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_map10_counted_lifecycle_contract.json")).unwrap();
        let masks:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_map10_owned_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),6);
        for c in proof["cases"].as_array().unwrap() {
            let n=c["dimension"].as_u64().unwrap() as usize;let mut layer=CountedLayer::new(n).unwrap();
            let mask=|key:&str| {
                let data=&masks["cases"][c[key].as_u64().unwrap() as usize];
                StencilRegion {words:data["words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect(),rect:std::array::from_fn(|i|data["rect"][i].as_u64().unwrap() as usize),applied:false}
            };
            for output in c["outputs"].as_array().unwrap() {
                match output["action"].as_str().unwrap() {
                    "add_a"=>layer.install(1,mask("mask_a")).unwrap(),
                    "add_b"=>layer.install(2,mask("mask_b")).unwrap(),
                    "replace_a_with_b"=>layer.install(1,mask("mask_b")).unwrap(),
                    "remove_b"=>assert!(layer.retire(2).unwrap()),
                    "repeat_remove_b"=>assert!(!layer.retire(2).unwrap()),
                    "remove_a"=>assert!(layer.retire(1).unwrap()),
                    action=>panic!("unqualified counted lifecycle action {action}"),
                }
                let mut counts=vec![0;n*n];let mut pixels=vec![0;n*n];
                for pair in output["counts"].as_array().unwrap() {counts[pair[0].as_u64().unwrap() as usize]=pair[1].as_u64().unwrap() as u8;}
                for pair in output["pixels"].as_array().unwrap() {pixels[pair[0].as_u64().unwrap() as usize]=pair[1].as_u64().unwrap() as u8;}
                assert_eq!(layer.counts,counts,"Map10 counts {c}");assert_eq!(layer.pixels,pixels,"Map10 pixels {c}");
                for i in 0..2 {assert_eq!(layer.sources.contains_key(&(i as u64+1)),output["applied"][i].as_bool().unwrap());}
            }
        }
    }
}
