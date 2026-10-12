//! Original8C01E0 logical rows/placement and normalized UV arithmetic.
//! GPU allocation/upload, page refresh and blur/outline are separate.
use crate::{Error,native_text_measure::Node};
use std::collections::BTreeMap;
#[derive(Clone,Debug)] pub struct Cell {pub id:u32,pub width:i32,pub height:i32}
#[derive(Clone,Debug,PartialEq)] pub struct Placement {pub x:u32,pub y:u32,pub uv:[f32;4]}
pub fn uv(x:i32,y:i32,width:i32,height:i32,texture_width:u32,texture_height:u32)->Result<[f32;4],Error> {
    if texture_width==0 || texture_height==0 || texture_width>i32::MAX as u32 || texture_height>i32::MAX as u32 {return Err(Error("font atlas texture dimensions unqualified".into()))}
    let inverse_x=1f32/(texture_width as f32);let inverse_y=1f32/(texture_height as f32);
    Ok([(x as f32)*inverse_x,(y as f32)*inverse_y,((x.wrapping_add(width) as f32)-0.5)*inverse_x,(y.wrapping_add(height) as f32)*inverse_y])
}
#[derive(Clone,Debug)] pub struct Page {pub size:i32,pub texture_dimensions:[u32;2],rows:Vec<Vec<Cell>>,pub dirty:bool}
impl Page {
    pub fn new(size:u32,texture_dimensions:[u32;2])->Result<Self,Error> {
        if ![256,512].contains(&size) {return Err(Error("font atlas page size unqualified".into()))}
        uv(0,0,1,1,texture_dimensions[0],texture_dimensions[1])?;
        Ok(Self {size:size as i32,texture_dimensions,rows:Vec::new(),dirty:false})
    }
    pub fn row_ids(&self)->Vec<Vec<u32>> {self.rows.iter().map(|r|r.iter().map(|c|c.id).collect()).collect()}
    pub fn insert(&mut self,cell:Cell)->Result<Option<Placement>,Error> {
        if cell.width<0 || cell.height<0 {return Err(Error("negative font atlas cell dimensions unqualified".into()))}
        if cell.width>self.size || cell.height>self.size {return Ok(None)}
        let mut remaining_height=self.size;
        for row in &mut self.rows {
            if remaining_height<cell.height {break}
            let mut remaining_width=self.size;let mut maximum_height=0;
            // Original stops this scan as soon as the next candidate no longer fits.
            for old in row.iter() {
                if remaining_width<cell.width {break}
                maximum_height=maximum_height.max(old.height);remaining_width=remaining_width.wrapping_sub(old.width);
            }
            if remaining_width>=cell.width {
                let x=self.size-remaining_width;let y=self.size-remaining_height;
                let uv=uv(x,y,cell.width,cell.height,self.texture_dimensions[0],self.texture_dimensions[1])?;
                row.push(cell);self.dirty=true;return Ok(Some(Placement {x:x as u32,y:y as u32,uv}))
            }
            remaining_height=remaining_height.wrapping_sub(maximum_height);
        }
        if remaining_height<cell.height {return Ok(None)}
        let y=self.size-remaining_height;
        let uv=uv(0,y,cell.width,cell.height,self.texture_dimensions[0],self.texture_dimensions[1])?;
        self.rows.push(vec![cell]);self.dirty=true;Ok(Some(Placement {x:0,y:y as u32,uv}))
    }
}
#[derive(Clone,Debug,PartialEq)] pub struct Binding {pub page:usize,pub placement:Placement}
#[derive(Default)] pub struct Bank {pub pages:Vec<Page>,pub bindings:BTreeMap<u16,Binding>}
impl Bank {
    pub fn page_cells(&self,index:usize)->Result<Vec<(u16,Placement)>,Error> {
        let page=self.pages.get(index).ok_or_else(||Error("font atlas page missing".into()))?;
        page.rows.iter().flatten().map(|cell| {
            let id=u16::try_from(cell.id).map_err(|_|Error("font atlas UTF16 cell invalid".into()))?;
            let binding=self.bindings.get(&id).ok_or_else(||Error("font atlas binding missing".into()))?;
            if binding.page!=index {return Err(Error("font atlas page binding mismatch".into()))}
            Ok((id,binding.placement.clone()))
        }).collect()
    }
    /// CPU logical pages; GPU texture creation may still fail and is not represented here.
    pub fn request(&mut self,node:&Node)->Result<Binding,Error> {
        if let Some(binding)=self.bindings.get(&node.character_utf16) {return Ok(binding.clone())}
        let cell=Cell {id:node.character_utf16 as u32,width:node.width,height:node.height};
        for (index,page) in self.pages.iter_mut().enumerate() {
            if let Some(placement)=page.insert(cell.clone())? {let binding=Binding {page:index,placement};self.bindings.insert(node.character_utf16,binding.clone());return Ok(binding)}
        }
        for size in [256,512] {
            let mut page=Page::new(size,[size,size])?;
            if let Some(placement)=page.insert(cell.clone())? {let binding=Binding {page:self.pages.len(),placement};self.pages.push(page);self.bindings.insert(node.character_utf16,binding.clone());return Ok(binding)}
        }
        Err(Error("font atlas glyph does not fit native256/512 pages".into()))
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn uv_bits_match216_original_assignment_suffix_cases() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_atlas_uv_contract.json")).unwrap();assert_eq!(p["case_count"],216);assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let value=|key:&str|c[key].as_i64().unwrap() as i32;
            let actual=uv(value("x"),value("y"),value("cell_width"),value("cell_height"),c["texture_dimensions"][0].as_u64().unwrap() as u32,c["texture_dimensions"][1].as_u64().unwrap() as u32).unwrap();
            assert_eq!(actual.map(f32::to_bits).to_vec(),c["uv_bits"].as_array().unwrap().iter().map(|n|n.as_u64().unwrap() as u32).collect::<Vec<_>>());
        }
    }
    #[test] fn full_native108_insertions_match_rows_positions_uv_and_rejections() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_atlas_packing_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["insertion_steps"],108);
        for c in p["cases"].as_array().unwrap() {
            let size=c["size"].as_u64().unwrap() as u32;let mut page=Page::new(size,[size,size]).unwrap();
            let cell=|id:u32|Cell {id,width:c["dimensions"][id as usize][0].as_i64().unwrap() as i32,height:c["dimensions"][id as usize][1].as_i64().unwrap() as i32};
            page.rows=c["initial_rows"].as_array().unwrap().iter().map(|row|row.as_array().unwrap().iter().map(|n|cell(n.as_u64().unwrap() as u32)).collect()).collect();
            for step in c["steps"].as_array().unwrap() {
                let placement=page.insert(cell(step["node_index"].as_u64().unwrap() as u32)).unwrap();assert_eq!(placement.is_some(),step["success"].as_bool().unwrap());
                if let Some(actual)=placement {
                    assert_eq!([actual.x,actual.y],[step["position"][0].as_u64().unwrap() as u32,step["position"][1].as_u64().unwrap() as u32]);
                    assert_eq!(actual.uv.map(f32::to_bits).to_vec(),step["uv_bits"].as_array().unwrap().iter().map(|n|n.as_u64().unwrap() as u32).collect::<Vec<_>>());assert!(page.dirty);
                }
                let expected=step["rows_after"].as_array().unwrap().iter().map(|row|row.as_array().unwrap().iter().map(|n|n.as_u64().unwrap() as u32).collect::<Vec<_>>()).collect::<Vec<_>>();assert_eq!(page.row_ids(),expected);
            }
        }
    }
    #[test] fn bank_reuses_cells_and_attempts256_before512() {
        let mut bank=Bank::default();let first=Node {character_utf16:65,width:20,height:30,advance:15};let a=bank.request(&first).unwrap();assert_eq!(bank.pages[0].size,256);assert_eq!(bank.request(&first).unwrap(),a);assert_eq!(bank.bindings.len(),1);
        let large=Node {character_utf16:86,width:300,height:40,advance:295};let b=bank.request(&large).unwrap();assert_eq!(b.page,1);assert_eq!(bank.pages[1].size,512);
        let count=bank.pages.len();assert!(bank.request(&Node {character_utf16:233,width:513,height:20,advance:510}).is_err());assert_eq!(bank.pages.len(),count);assert!(!bank.bindings.contains_key(&233));
    }
}
