use openleague_font_raster::{Face,native_glyph::{compose,Target}};
fn main()->Result<(),Box<dyn std::error::Error>> {
    let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let output=std::env::args().nth(1).ok_or("probe output missing")?;let mut rows=Vec::new();
    for (file,character) in [("GillSansMTPro-Medium.otf",0x00e9),("GillSansMTProCyr-Medium.otf",0x0416),("GillSansMTProGrk-Medium.otf",0x03a9),("ARIALUNI.TTF",0x4e2d),("UttumDotum.ttf",0xac00)] {
        let path=format!("assets/fonts/native4.20/{file}");let mut face=Face::new(std::fs::read(root.join(&path))?)?;face.fit(48,0x10,96,96,10000)?;
        let glyph=face.native_glyph(character)?;let mut panels=Vec::new();
        for (x,y) in [(12,4),(-8,-9)] {
            let mut pixels=vec![85;96*64*4];compose(&glyph,&mut Target {pixels:&mut pixels,width:96,height:64,channels:4,stride_bytes:384},x,y)?;
            panels.push(serde_json::json!({"x":x,"y":y,"rgba_hex":pixels.iter().map(|b|format!("{b:02x}")).collect::<String>()}));
        }
        let a=face.native_glyph(65)?;let v=face.native_glyph(86)?;let kerning=face.native_kerning(a.index,v.index)?;
        rows.push(serde_json::json!({"path":path,"version":face.version(),"character_utf16":character,"glyph_index":glyph.index,"load_flags":[0,4],"metric_pixels":[glyph.metrics.advance,glyph.metrics.bearing_x,glyph.metrics.width,glyph.metrics.bottom],"a_v_kerning_pixels":kerning,"panels":panels}));
    }
    std::fs::write(output,serde_json::to_vec_pretty(&serde_json::json!({"complete":false,"cpu_probe":true,"dpi":[96,96],"metric_height":48,"panel_width":96,"panel_height":64,"panel_channels":4,"background_channel":85,"rows":rows}))?)?;
    println!("Five source families, native flags0/4, normal/clipped coverage composition exported; GPU drawing unqualified");Ok(())
}
