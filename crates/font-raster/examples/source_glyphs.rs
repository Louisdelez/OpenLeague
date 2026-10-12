use openleague_font_raster::Face;
fn main()->Result<(),Box<dyn std::error::Error>> {
    let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let output=std::env::args().nth(1).ok_or("glyph receipt output missing")?;let mut rows=Vec::new();
    for (file,character) in [("GillSansMTPro-Medium.otf",'é'),("GillSansMTProCyr-Medium.otf",'Ж'),("GillSansMTProGrk-Medium.otf",'Ω'),("ARIALUNI.TTF",'中'),("UttumDotum.ttf",'가')] {
        let path=format!("assets/fonts/native4.20/{file}");let mut face=Face::new(std::fs::read(root.join(&path))?)?;
        let adjusted=face.fit(48,0x10,96,96,10000)?;let metrics=face.metrics()?;let mut glyphs=Vec::new();
        for character in ['A',character] {let glyph=face.glyph(character,0,0)?;glyphs.push(serde_json::json!({"character":character.to_string(),"codepoint":character as u32,"index":glyph.index,"width":glyph.width,"height":glyph.height,"left":glyph.left,"top":glyph.top,"advance_x_26_6":glyph.advance_x_26_6,"pixels_hex":glyph.pixels.iter().map(|b|format!("{b:02x}")).collect::<String>()}));}
        rows.push(serde_json::json!({"path":path,"version":face.version(),"dpi":[96,96],"requested_metric_height":48,"character_height_26_6":adjusted.height_26_6,"metric_height":adjusted.metric_height,"adjustment_calls":adjusted.calls.len(),"ascender_26_6":metrics.ascender_26_6,"descender_26_6":metrics.descender_26_6,"glyphs":glyphs}));
    }
    std::fs::write(output,serde_json::to_vec_pretty(&serde_json::json!({"complete":false,"cpu_probe":true,"native_glyph_load_flags_qualified":false,"load_flags":0,"render_mode":0,"rows":rows}))?)?;println!("5 source families and10glyph bitmaps exported; CPU diagnostic only");Ok(())
}
