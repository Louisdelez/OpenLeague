//! Original8C0510 row-ordered bitmap copies and8C05A0/8C05F0 byte masks.
//! Full8C0650 update, outline expansion and GPU channel mapping remain separate.
use crate::{Error,native_font_atlas::Placement,native_glyph::{Bitmap,copy_rgba}};
pub fn copy_cells(cells:&[(u16,Placement)],destination:&mut [u8],stride_pixels:u32,x:u32,y:u32,mut bitmap:impl FnMut(u16)->Result<Bitmap,Error>)->Result<(),Error> {
    for (id,position) in cells {
        let left=position.x.checked_add(x).ok_or_else(||Error("atlas copy x overflow".into()))?;
        let top=position.y.checked_add(y).ok_or_else(||Error("atlas copy y overflow".into()))?;
        copy_rgba(&bitmap(*id)?,destination,stride_pixels,left,top)?;
    }
    Ok(())
}
fn extent(source:&[u8],destination:&[u8],count:usize)->Result<usize,Error> {
    let bytes=count.checked_mul(4).ok_or_else(||Error("atlas mask size overflow".into()))?;
    if source.len()<bytes || destination.len()<bytes {return Err(Error("atlas mask buffer unavailable".into()))}
    Ok(bytes)
}
pub fn max_byte0(source:&[u8],destination:&mut [u8],count:usize)->Result<(),Error> {
    let bytes=extent(source,destination,count)?;
    for offset in (0..bytes).step_by(4) {destination[offset]=destination[offset].max(source[offset]);}
    Ok(())
}
pub fn split_byte0(source:&[u8],destination:&mut [u8],count:usize)->Result<(),Error> {
    let bytes=extent(source,destination,count)?;
    for offset in (0..bytes).step_by(4) {destination[offset]=(255-source[offset]).min(destination[offset]);destination[offset+2]=source[offset];}
    Ok(())
}
///8C0650 CPU pixel update. GPU lock/upload and secondary texture are not represented.
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
#[cfg(test)] mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/native_font_atlas_pixels_contract.json")).unwrap()}
    #[test] fn copy_order_and_pixels_match30_original_routes() {
        let p=proof();assert_eq!(p["passed"],true);assert_eq!(p["route_cases"],30);
        for case in p["routed"].as_array().unwrap() {
            let cells=case["rows"].as_array().unwrap().iter().flat_map(|row|row.as_array().unwrap().iter()).map(|value| {
                let id=value.as_u64().unwrap() as u16;let position=&case["positions"][id as usize];
                (id,Placement {x:position[0].as_u64().unwrap() as u32,y:position[1].as_u64().unwrap() as u32,uv:[0.;4]})
            }).collect::<Vec<_>>();
            let stride=case["stride_pixels"].as_u64().unwrap() as u32;let mut actual=vec![0xa5;stride as usize*32*4];let offset=case["offset"].as_u64().unwrap() as u32;let mut ids=Vec::new();
            copy_cells(&cells,&mut actual,stride,offset,offset,|id| {ids.push(id);Ok(Bitmap {width:3,rows:2,ascender_26_6:12*64,bearing_y_26_6:9*64,coverage:vec![id as u8+1,64,128,192,254,255]})}).unwrap();
            assert_eq!(ids,case["load_indices"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u16).collect::<Vec<_>>());
            let hex=case["destination_hex"].as_str().unwrap();let expected=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();assert_eq!(actual,expected);
        }
    }
    #[test] fn masks_match2566_original_executions() {
        let p=proof();assert_eq!(p["mask_cases"],2566);
        for case in p["masks"].as_array().unwrap() {
            let bytes=|key:&str|case[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>();
            let source=bytes("source");let mut destination=bytes("destination_before");let count=case["pixel_count"].as_u64().unwrap_or(1) as usize;
            if case["entry"]=="0x8c05a0" {max_byte0(&source,&mut destination,count)}else {split_byte0(&source,&mut destination,count)}.unwrap();assert_eq!(destination,bytes("destination_after"));
        }
    }
    #[test] fn mask_bounds_fail_before_mutation() {
        let mut destination=vec![0xa5;8];assert!(max_byte0(&[0;4],&mut destination,2).is_err());assert_eq!(destination,vec![0xa5;8]);assert!(split_byte0(&[0;8],&mut destination,3).is_err());assert_eq!(destination,vec![0xa5;8]);
    }
}

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
