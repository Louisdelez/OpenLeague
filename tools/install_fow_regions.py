from pathlib import Path
import datetime,shutil
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3');b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod fow_regions;' not in s;shutil.copy2(p,b/'main.rs');s='#[allow(dead_code)]\nmod fow_regions;\n'+s;p.write_text(s,encoding='utf-8')
(r/'crates/client/src/fow_regions.rs').write_text('''//! Original6B2D80/6B2E60 source-counter and vertically flipped texture updates.
//! Region stencil generation and live GPU upload remain separate contracts.
pub struct StencilRegion {pub words:Vec<u32>,pub rect:[usize;4],pub dirty:bool}
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
        self.dirty=true;Ok(())
    }
    pub fn remove_from(&self,dimension:usize,counts:&mut [u8],pixels:&mut [u8])->Result<(),&'static str> {
        self.validate(dimension,self.rect,counts,pixels)?;
        for z in self.rect[1]..self.rect[3] {for x in self.rect[0]..self.rect[2] {
            let index=z*dimension+x;
            if self.contains_bit(index) {counts[index]=counts[index].saturating_sub(1);}
            // Original removal refreshes all pixels in the rectangle, even unset bits.
            pixels[(dimension-z-1)*dimension+x]=if counts[index]!=0 {255} else {0};
        }}
        Ok(())
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
            let mut region=StencilRegion {words,rect,dirty:false};let mut counts=vec![initial;size];let mut pixels=vec![90;size];
            if add {region.rect=[0;4];region.add_to(dim,rect,&mut counts,&mut pixels).unwrap();assert!(region.dirty);assert_eq!(region.rect,rect);}
            else {region.remove_from(dim,&mut counts,&mut pixels).unwrap();assert!(!region.dirty);}
            for change in c["changes"].as_array().unwrap() {assert_eq!(counts[change["index"].as_u64().unwrap() as usize],change["count"].as_u64().unwrap() as u8);assert_eq!(pixels[change["texture_index"].as_u64().unwrap() as usize],change["visibility"].as_u64().unwrap() as u8);}
            for z in 0..dim {for x in 0..dim {if x<rect[0] || x>=rect[2] || z<rect[1] || z>=rect[3] {assert_eq!(counts[z*dim+x],initial);assert_eq!(pixels[(dim-z-1)*dim+x],90);}}}
            let old_counts=counts.clone();let old_pixels=pixels.clone();
            assert!(region.add_to(dim,[0,0,dim+1,dim],&mut counts,&mut pixels).is_err());assert_eq!(counts,old_counts);assert_eq!(pixels,old_pixels);
        }
    }
    #[test] fn native_add_preserves_unselected_pixels_and_saturates_overlap_counts() {compare(include_str!("../../../data/4.20/fow_add_region_contract.json"),true);}
    #[test] fn native_remove_refreshes_rect_pixels_and_never_underflows() {compare(include_str!("../../../data/4.20/fow_remove_region_contract.json"),false);}
}
''',encoding='utf-8')
for name in ['probe_fow_add_region.py','probe_fow_remove_region.py','install_fow_regions.py','fix_fow_lookup_precision.py']:shutil.copy2(w/name,r/'tools'/name)
print('Native add/remove region updates ported; renderer stencil providers and upload still pending.')
