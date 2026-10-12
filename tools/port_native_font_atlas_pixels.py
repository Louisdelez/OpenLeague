from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
shutil.copy2(stage/'native_font_atlas_pixels.rs',r/'crates/font-raster/src/native_font_atlas_pixels.rs')
p=r/'crates/font-raster/src/lib.rs';s=p.read_text(encoding="utf-8");line='pub mod native_font_atlas_pixels;'
if line not in s:s+='\n'+line+'\n'
p.write_text(s,encoding='utf-8')
p=r/'crates/font-raster/src/native_font_atlas.rs';s=p.read_text(encoding="utf-8");anchor='    /// CPU logical pages; GPU texture creation may still fail and is not represented here.'
addition='''    pub fn page_cells(&self,index:usize)->Result<Vec<(u16,Placement)>,Error> {
        let page=self.pages.get(index).ok_or_else(||Error("font atlas page missing".into()))?;
        page.rows.iter().flatten().map(|cell| {
            let id=u16::try_from(cell.id).map_err(|_|Error("font atlas UTF16 cell invalid".into()))?;
            let binding=self.bindings.get(&id).ok_or_else(||Error("font atlas binding missing".into()))?;
            if binding.page!=index {return Err(Error("font atlas page binding mismatch".into()))}
            Ok((id,binding.placement.clone()))
        }).collect()
    }
'''
if addition not in s:assert anchor in s;s=s.replace(anchor,addition+anchor)
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_font_metrics.rs';s=p.read_text(encoding="utf-8");anchor='    pub fn measure_for_text('
addition='''    /// Raw page copy only. Shadow/outline update and GPU upload remain separate.
    pub fn copy_atlas_for_text(&self,sizes:&crate::native_hud_font_creation::Sizes,text:usize,page:usize,destination:&mut [u8],stride_pixels:u32,x:u32,y:u32)->Result<(),String> {
        if self.height!=sizes.height {return Err("atlas sizes are stale".into())}
        let face=*sizes.descriptor_bindings.get(text).ok_or("source Text binding missing")?;
        let cells=self.atlases.get(face).ok_or("source atlas missing")?.page_cells(page).map_err(|e|e.to_string())?;
        let cache=self.glyphs.get(face).ok_or("source glyph cache missing")?;
        openleague_font_raster::native_font_atlas_pixels::copy_cells(&cells,destination,stride_pixels,x,y,|id|cache.get(&id).map(|g|g.bitmap.clone()).ok_or_else(||openleague_font_raster::Error("atlas glyph cache missing".into()))).map_err(|e|e.to_string())
    }

'''
if addition not in s:assert anchor in s;s=s.replace(anchor,addition+anchor)
# Extend existing source atlas test rather than duplicating source loading scaffolding.
anchor='let a=faces.atlas_cell_for_text(&sizes,text,65).unwrap();let repeated='
assert anchor in s
s=s.replace(anchor,'''let mut pixels=vec![0;256*256*4];faces.copy_atlas_for_text(&sizes,text,0,&mut pixels,256,0,0).unwrap();assert!(pixels.iter().any(|v|*v>0));
                let a=faces.atlas_cell_for_text(&sizes,text,65).unwrap();let repeated=''')
p.write_text(s,encoding='utf-8')
for name in ['qualify_native_font_atlas_pixels.py','port_native_font_atlas_pixels.py','qualify_native_font_atlas_packing.py','port_native_font_atlas_client.py']:
 shutil.copy2(stage/name,r/'tools'/name)
print('native atlas pixel port and source binding installed; GPU upload/shadow/outline remain open')
