use std::{fs,env};
use ktx2::{Header,Index,LevelIndex,Format,dfd::{Basic,Block}};
fn word(bytes:&[u8],offset:usize)->u32 {u32::from_le_bytes(bytes[offset..offset+4].try_into().unwrap())}
fn main() {
 let args:Vec<_>=env::args().collect();let dds=fs::read(&args[1]).unwrap();
 assert_eq!(&dds[..4],b"DDS ");assert_eq!(&dds[84..88],b"DXT1");
 let height=word(&dds,12);let width=word(&dds,16);let count=word(&dds,28);assert_eq!((width,height,count),(1024,1024,11));
 let mut offset=128;let mut levels=Vec::new();
 for i in 0..count {let w=(width>>i).max(1);let h=(height>>i).max(1);let size=(((w+3)/4)*((h+3)/4)*8) as usize;levels.push(dds[offset..offset+size].to_vec());offset+=size;}
 assert_eq!(offset,dds.len());
 let format=Format::BC1_RGBA_UNORM_BLOCK;let (basic,type_size)=Basic::from_format(format).unwrap();let dfd=Block::Basic(basic).to_vec();
 let dfd_offset=80+24*count;let dfd_length=4+dfd.len() as u32;
 let header=Header {format:Some(format),type_size,pixel_width:width,pixel_height:height,pixel_depth:0,layer_count:0,face_count:1,level_count:count,supercompression_scheme:None,index:Index {dfd_byte_offset:dfd_offset,dfd_byte_length:dfd_length,kvd_byte_offset:0,kvd_byte_length:0,sgd_byte_offset:0,sgd_byte_length:0}};
 let mut output=vec![0;(dfd_offset+dfd_length) as usize];output[..80].copy_from_slice(&header.as_bytes());output[dfd_offset as usize..dfd_offset as usize+4].copy_from_slice(&dfd_length.to_le_bytes());output[dfd_offset as usize+4..].copy_from_slice(&dfd);
 for i in (0..count as usize).rev() {
  while output.len()%8!=0 {output.push(0);}
  let index=LevelIndex {byte_offset:output.len() as u64,byte_length:levels[i].len() as u64,uncompressed_byte_length:levels[i].len() as u64};
  output[80+i*24..104+i*24].copy_from_slice(&index.as_bytes());output.extend_from_slice(&levels[i]);
 }
 let reader=ktx2::Reader::new(&output).unwrap();assert_eq!(reader.header().level_count,11);
 for (i,l) in reader.levels().enumerate(){assert_eq!(l.data,levels[i]);}
 let image=bevy_image::ktx2_buffer_to_image(&output,bevy_image::CompressedImageFormats::BC,false).unwrap();
 assert_eq!(image.texture_descriptor.mip_level_count,11);assert_eq!(image.texture_descriptor.size.width,1024);
 assert_eq!(image.data.as_ref().unwrap(),&levels.concat());
 fs::write(&args[2],output).unwrap();println!("original BC1 mip chain preserved:11levels; Bevy loader passed");
}
