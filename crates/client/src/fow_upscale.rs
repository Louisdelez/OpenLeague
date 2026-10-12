//! Native 6B5080 CPU fourfold visibility expansion, including boundary copy order.
include!("fow_upscale_table.rs");

/// The destination already exists in the native renderer; corner bytes and pitch
/// padding are preserved. Threshold is strictly >128, not >=128.
pub fn expand_native(source: &[u8], dimension: usize, destination: &mut [u8], pitch: usize) -> Result<(), &'static str> {
    if dimension < 2 { return Err("native fog expansion requires at least two cells"); }
    let width = dimension.checked_mul(4).ok_or("fog dimension overflow")?;
    let cells = dimension.checked_mul(dimension).ok_or("fog cell count overflow")?;
    let size = pitch.checked_mul(width).ok_or("fog buffer overflow")?;
    if pitch < width || source.len() != cells || destination.len() != size { return Err("invalid native fog expansion buffers"); }
    for y in 0..dimension-1 {
        for x in 0..dimension-1 {
            let a=y*dimension+x;
            let code=usize::from(source[a]>128) | (usize::from(source[a+1]>128)<<1)
                | (usize::from(source[a+dimension]>128)<<2) | (usize::from(source[a+dimension+1]>128)<<3);
            for row in 0..4 {
                let offset=(2+y*4+row)*pitch+2+x*4;
                destination[offset..offset+4].copy_from_slice(&NATIVE_TILES[code*16+row*4..code*16+row*4+4]);
            }
        }
    }
    // Original row copies happen before the column fixup. This preserves corners.
    for (row, source_row) in [(0,2),(1,2),(width-2,width-3),(width-1,width-3)] {
        destination.copy_within(source_row*pitch..source_row*pitch+width,row*pitch);
    }
    for y in 2..width-2 {
        let row=y*pitch;
        destination[row]=destination[row+2]; destination[row+1]=destination[row+2];
        destination[row+width-2]=destination[row+width-3]; destination[row+width-1]=destination[row+width-3];
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn native_complete_tiles_rows_columns_threshold_and_padding_match() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_upscale_complete_contract.json")).unwrap();
        let bytes=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u8).collect::<Vec<_>>();
        assert_eq!(NATIVE_TILES.as_slice(),bytes(&proof["lookup_table"]));
        for c in proof["cases"].as_array().unwrap() {
            let dim=c["dimension"].as_u64().unwrap() as usize; let pitch=c["pitch"].as_u64().unwrap() as usize;
            let mut output=vec![90;pitch*dim*4]; expand_native(&bytes(&c["source"]),dim,&mut output,pitch).unwrap();
            assert_eq!(output,bytes(&c["output"]),"dim {dim}, pattern {}",c["pattern"]);
        }
    }

    #[test]
    fn full128_cell_native_expansion_matches_every_byte_of512_pixel_texture() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_upscale_production_contract.json")).unwrap();
        for c in proof["cases"].as_array().unwrap() {
            let n=c["dimension"].as_u64().unwrap() as usize;assert_eq!(n,128);
            let pattern=c["pattern"].as_u64().unwrap();let pitch=c["pitch"].as_u64().unwrap() as usize;
            let source:Vec<u8>=(0..n*n).map(|i|if pattern==1 || pattern==2 && i%2==0 || pattern==3 && i/n%2==0 {255}else{0}).collect();
            let mut actual=vec![90;pitch*n*4];expand_native(&source,n,&mut actual,pitch).unwrap();
            let mut expected=Vec::new();
            for run in c["output_runs"].as_array().unwrap() {
                expected.extend(std::iter::repeat_n(run[0].as_u64().unwrap() as u8,run[1].as_u64().unwrap() as usize));
            }
            assert_eq!(actual.len(),expected.len());
            assert!(actual.iter().zip(&expected).all(|(a,b)|a==b),"native128 pattern {pattern}");
        }
    }
    #[test]
    fn invalid_expansion_is_rejected_before_mutation() {
        for (dim,src,pitch,len) in [(1,1,4,16),(2,3,8,64),(2,4,7,56),(2,4,8,63),(usize::MAX,0,0,1)] {
            let mut output=vec![71;len]; let original=output.clone();
            assert!(expand_native(&vec![0;src],dim,&mut output,pitch).is_err()); assert_eq!(output,original);
        }
    }
}
