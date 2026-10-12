from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
p=r/'crates/font-raster/src/native_font_atlas_pixels.rs';s=p.read_text(encoding='utf-8');anchor='#[cfg(test)] mod tests {'
addition='''///8C0650 CPU pixel update. GPU lock/upload and secondary texture are not represented.
pub fn update(cells:&[(u16,Placement)],size:u32,extra:u32,shadow:bool,mut bitmap:impl FnMut(u16)->Result<Bitmap,Error>)->Result<Vec<u8>,Error> {
    if size==0 || size>512 || extra>size {return Err(Error("atlas update dimensions unqualified".into()))}
    let bytes=size as usize*size as usize*4;
    let mut destination=vec![0;bytes];for pixel in destination.chunks_exact_mut(4) {pixel[3]=255;}
    let mut temporary=vec![0;bytes];let base=extra+if shadow {8}else{0};
    for radius in 1..=extra {
        for dx in [-1i32,0,1] {for dy in [-1i32,0,1] {
            if dx==0 && dy==0 {continue}
            temporary.fill(0);
            let x=(base as i32+radius as i32*dy) as u32;let y=(base as i32+radius as i32*dx) as u32;
            copy_cells(cells,&mut temporary,size,x,y,&mut bitmap)?;
            max_byte0(&temporary,&mut destination,(size*size) as usize)?;
        }}
    }
    temporary.fill(0);copy_cells(cells,&mut temporary,size,base,base,&mut bitmap)?;
    split_byte0(&temporary,&mut destination,(size*size) as usize)?;
    Ok(destination)
}
'''
assert anchor in s and 'pub fn update(' not in s;s=s.replace(anchor,addition+anchor)
s+='''
#[cfg(test)] mod update_tests {
    use super::*;
    #[test] fn full_pixel_update_matches10_original_contexts() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_atlas_update_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],10);
        for case in proof["cases"].as_array().unwrap() {
            let size=case["page_size"].as_u64().unwrap() as u32;let extra=case["extra"].as_u64().unwrap() as u32;let shadow=case["shadow"].as_bool().unwrap();let mut calls=0;
            let actual=update(&[(65,Placement {x:3,y:2,uv:[0.;4]})],size,extra,shadow,|id| {assert_eq!(id,65);calls+=1;Ok(Bitmap {width:3,rows:2,ascender_26_6:12*64,bearing_y_26_6:9*64,coverage:vec![1,64,128,192,254,255]})}).unwrap();
            assert_eq!(calls,case["glyph_calls"].as_u64().unwrap());let mut expected=vec![0;size as usize*size as usize*4];for pixel in expected.chunks_exact_mut(4) {pixel[3]=255;}
            for change in case["changed_pixels"].as_array().unwrap() {let k=change[0].as_u64().unwrap() as usize*4;let values=change[1].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>();expected[k..k+4].copy_from_slice(&values);}
            assert_eq!(actual,expected);
        }
    }
}
'''
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_font_metrics.rs';s=p.read_text(encoding='utf-8');anchor='    /// Raw page copy only.'
addition='''    /// Full CPU page pixels with native expansion/offset; caller still owns GPU upload.
    pub fn update_atlas_for_text(&self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,page:usize)->Result<Vec<u8>,String> {
        if self.height!=sizes.height {return Err("atlas sizes are stale".into())}
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let bank=self.atlases.get(face).ok_or("source atlas missing")?;let cells=bank.page_cells(page).map_err(|e|e.to_string())?;
        let size=bank.pages.get(page).ok_or("source atlas page missing")?.size as u32;
        let descriptor=&sizes.descriptors.entries.get(face).ok_or("source font descriptor missing")?.descriptor;
        let cache=self.glyphs.get(face).ok_or("source glyph cache missing")?;
        openleague_font_raster::native_font_atlas_pixels::update(&cells,size,descriptor.extra,descriptor.flags&4!=0,|id|cache.get(&id).map(|g|g.bitmap.clone()).ok_or_else(||openleague_font_raster::Error("atlas glyph cache missing".into()))).map_err(|e|e.to_string())
    }

'''
assert anchor in s and 'pub fn update_atlas_for_text(' not in s;s=s.replace(anchor,addition+anchor)
anchor='let mut pixels=vec![0;256*256*4];faces.copy_atlas_for_text'
assert anchor in s;s=s.replace(anchor,'''let updated=faces.update_atlas_for_text(&sizes,text,0).unwrap();assert_eq!(updated.len(),256*256*4);assert!(updated.chunks_exact(4).all(|p|p[3]==255));assert!(updated.chunks_exact(4).any(|p|p[2]>0));
                let mut pixels=vec![0;256*256*4];faces.copy_atlas_for_text''')
p.write_text(s,encoding='utf-8')
for name in ['qualify_native_font_atlas_update.py','port_native_font_atlas_update.py','port_native_font_atlas_pixels.py']:
 shutil.copy2(stage/name,r/'tools'/name)
print('native full CPU atlas update installed; GPU/secondary path still open')
