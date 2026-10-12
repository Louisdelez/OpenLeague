//! Native ZIP opening8B9510, central directory8B97F0 and payload8B9750.
//! Raw DEFLATE uses flate2; outputs are compared to the original native inflater.
use crate::native_zip_local_header::Entry;
use std::io;
fn invalid(s:&'static str)->io::Error {io::Error::new(io::ErrorKind::InvalidData,s)}
fn unsupported(s:&'static str)->io::Error {io::Error::new(io::ErrorKind::Unsupported,s)}
fn u16_at(b:&[u8],p:usize)->u32 {u16::from_le_bytes([b[p],b[p+1]]) as u32}
fn u32_at(b:&[u8],p:usize)->u32 {u32::from_le_bytes([b[p],b[p+1],b[p+2],b[p+3]])}
#[derive(Debug)] pub struct Record {pub name:Vec<u8>,pub metadata:Entry}
pub struct Archive {bytes:Vec<u8>,pub entries:Vec<Record>}
pub struct Decoded {pub bytes:Vec<u8>,pub returned_bytes:u32}
/// Native8B9A10 fallback. The original local-offset word is uninitialized;
/// initialized cached data offsets bypass it, so the safe port stores zero.
pub fn local_entries(bytes:&[u8])->io::Result<Vec<Record>> {
    let mut position=0usize;let mut rows=Vec::new();
    loop {
        let signature=bytes.get(position..position+4).ok_or_else(||unsupported("native fallback short signature read is unqualified"))?;
        if signature!=b"PK\x03\x04" {break;}
        let header=bytes.get(position..position+30).ok_or_else(||unsupported("native fallback short header read is unqualified"))?;
        let name_len=u16_at(header,26) as usize;
        if name_len>=256 {return Err(unsupported("native fallback long-name stack behavior is unqualified"));}
        let name_start=position+30;
        let name=bytes.get(name_start..name_start+name_len).ok_or_else(||unsupported("native fallback short name read is unqualified"))?;
        let name=&name[..name.iter().position(|&b|b==0).unwrap_or(name.len())];
        let cached_data_offset=u32::try_from(name_start+name_len+u16_at(header,28) as usize).map_err(|_|unsupported("native fallback offset exceeds32-bit range"))?;
        let compressed_size=u32_at(header,18);
        rows.push(Record {name:name.to_vec(),metadata:Entry {local_offset:0,cached_data_offset,method:u16_at(header,8),compressed_size,uncompressed_size:u32_at(header,22),crc:u32_at(header,14)}});
        position=(cached_data_offset as usize).checked_add(compressed_size as usize).ok_or_else(||unsupported("native fallback offset overflow"))?;
    }
    Ok(rows)
}
pub fn central_entries(bytes:&[u8],offset:u32,count:u32)->io::Result<Vec<Record>> {
    let mut position=offset as usize;let mut rows=Vec::new();
    rows.try_reserve_exact(count as usize).map_err(io::Error::other)?;
    for _ in 0..count {
        let signature=bytes.get(position..position+4).ok_or_else(||invalid("truncated ZIP central signature"))?;
        if signature!=b"PK\x01\x02" {break;}
        let header=bytes.get(position..position+46).ok_or_else(||invalid("truncated ZIP central header"))?;
        let name_len=u16_at(header,28) as usize;
        if name_len>=256 {return Err(unsupported("native ZIP long-name stack behavior is unqualified"));}
        let name_start=position+46;
        let name=bytes.get(name_start..name_start+name_len).ok_or_else(||invalid("truncated ZIP name"))?;
        let name=&name[..name.iter().position(|&b|b==0).unwrap_or(name.len())];
        rows.push(Record {name:name.to_vec(),metadata:Entry {
            local_offset:u32_at(header,42),cached_data_offset:0,method:u16_at(header,10),
            compressed_size:u32_at(header,20),uncompressed_size:u32_at(header,24),crc:u32_at(header,16),
        }});
        position=name_start+name_len+u16_at(header,30) as usize+u16_at(header,32) as usize;
    }
    Ok(rows)
}
impl Archive {
    pub fn open(bytes:Option<Vec<u8>>)->io::Result<Option<Self>> {
        let Some(bytes)=bytes else {return Ok(None)};
        if bytes.len()<2 {return Err(unsupported("native short ZIP signature read is unqualified"));}
        if &bytes[..2]!=b"PK" {return Ok(None);}
        if bytes.len()<399 {return Err(unsupported("native short ZIP tail-read behavior is unqualified"));}
        let end=(bytes.len()-399..=bytes.len()-22).rev().find(|&p|&bytes[p..p+4]==b"PK\x05\x06");
        let entries=match end {
            Some(end) if u16_at(&bytes,end+4)!=9999=>central_entries(&bytes,u32_at(&bytes,end+16),u16_at(&bytes,end+10))?,
            _=>local_entries(&bytes)?,
        };
        Ok(Some(Self {bytes,entries}))
    }
    pub fn read(&mut self,index:usize)->io::Result<Decoded> {
        let record=self.entries.get_mut(index).ok_or_else(||unsupported("native ZIP index>=count boundary is unqualified"))?;
        let m=&mut record.metadata;let header=self.bytes.get(m.local_offset as usize..).map(|b|&b[..b.len().min(30)]);
        let start=m.data_offset(header).map_err(invalid)? as usize;
        if start==0 {return Err(unsupported("native invalid local-header payload behavior is unqualified"));}
        let mut output=Vec::new();output.try_reserve_exact(m.uncompressed_size as usize).map_err(io::Error::other)?;
        output.resize(m.uncompressed_size as usize,0);
        let input=self.bytes.get(start..).ok_or_else(||invalid("ZIP data offset beyond stream"))?;
        let returned_bytes=match m.method {
            0=>{let available=input.len().min(output.len());output[..available].copy_from_slice(&input[..available]);available as u32},
            8=>{
                let input=input.get(..m.compressed_size as usize).ok_or_else(||unsupported("native short compressed read is unqualified"))?;
                let mut codec=flate2::Decompress::new(false);
                let status=codec.decompress(input,&mut output,flate2::FlushDecompress::Finish)
                    .map_err(|_|unsupported("native malformed DEFLATE output is unqualified"))?;
                if matches!(status,flate2::Status::Ok|flate2::Status::StreamEnd) && codec.total_out()==m.uncompressed_size as u64 {m.uncompressed_size}else{0}
            },
            _=>0,
        };
        Ok(Decoded {bytes:output,returned_bytes})
    }
}
#[cfg(test)] mod tests {
    use super::*;
    fn root()->std::path::PathBuf {std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..")}
    fn original_bytes(source:&serde_json::Value)->Vec<u8> {
        let native=source["path"].as_str().unwrap().replace('\\',"/");
        let relative=native.split("/deploy/DATA/").nth(1).unwrap();
        std::fs::read(root().join("data/4.20/archives").join(relative)).unwrap()
    }
    #[test] fn central_reader_and_signature_truncation_match_native_archives() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_zip_central_directory_contract.json")).unwrap();
        assert_eq!(p["passed"],true);assert_eq!(p["case_count"],20);
        for c in p["cases"].as_array().unwrap() {
            let s=&p["original_archives"][c["source"].as_u64().unwrap() as usize];let mut b=original_bytes(s);
            let offset=s["central_offset"].as_u64().unwrap() as u32;let count=s["entry_count"].as_u64().unwrap() as u32;
            if let Some(index)=c["invalid_signature_at"].as_u64() {
                let mut cursor=offset as usize;
                for _ in 0..index {cursor+=46+u16_at(&b,cursor+28) as usize+u16_at(&b,cursor+30) as usize+u16_at(&b,cursor+32) as usize;}
                b[cursor]=0;
            }
            let actual=central_entries(&b,offset,count).unwrap();let expected=c["entries"].as_array().unwrap();assert_eq!(actual.len(),expected.len());
            for (row,want) in actual.iter().zip(expected) {
                assert_eq!(row.name,want["name"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>());
                for (key,value) in [("local_offset",row.metadata.local_offset),("cached_data_offset",row.metadata.cached_data_offset),("method",row.metadata.method),("compressed_size",row.metadata.compressed_size),("uncompressed_size",row.metadata.uncompressed_size),("crc",row.metadata.crc)] {assert_eq!(value,want[key].as_u64().unwrap() as u32);}
            }
        }
    }
    #[test] fn native_tail_scan_and_qualified_fallback_match_open_trace() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_zip_open_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],25);
        let f:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_zip_fallback_contract.json")).unwrap();assert_eq!(f["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let mut b=original_bytes(&p["archives"][c["archive"].as_u64().unwrap() as usize]);
            let end=b.windows(4).rposition(|w|w==b"PK\x05\x06").unwrap();
            let scenario=c["scenario"].as_str().unwrap();
            match scenario {"bad_start_signature"=>b[0]=0,"missing_end_signature"=>b[end]=0,"disk_9999"=>b[end+4..end+6].copy_from_slice(&9999u16.to_le_bytes()),_=>{}}
            let actual=Archive::open(if scenario=="open_failed" {None}else{Some(b)});
            let actual=actual.unwrap();assert_eq!(actual.is_some(),c["success"].as_bool().unwrap());
            if let Some(a)=actual {
                let expected=if c["fallback"].as_bool().unwrap() {f["cases"].as_array().unwrap().iter().find(|v|v["archive"]==c["archive"] && v["invalid_signature_at"].is_null()).unwrap()["entry_count"].as_u64().unwrap()}else{c["entry_count"].as_u64().unwrap()};
                assert_eq!(a.entries.len(),expected as usize);
            }
        }
    }
    #[test] fn fallback_metadata_and_signature_stop_match_original_scanner() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_zip_fallback_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],20);
        for c in p["cases"].as_array().unwrap() {
            let mut b=original_bytes(&p["archives"][c["archive"].as_u64().unwrap() as usize]);
            if let Some(stop)=c["invalid_signature_at"].as_u64() {
                let mut position=0;
                for _ in 0..stop {position+=30+u16_at(&b,position+26) as usize+u16_at(&b,position+28) as usize+u32_at(&b,position+18) as usize;}
                b[position]=0;
            }
            let actual=local_entries(&b).unwrap();let expected=c["entries"].as_array().unwrap();assert_eq!(actual.len(),expected.len());
            for (row,want) in actual.iter().zip(expected) {
                assert_eq!(row.name,want["name"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>());
                assert_eq!(row.metadata.local_offset,0); // Safe substitute for original undefined word.
                for (key,value) in [("cached_data_offset",row.metadata.cached_data_offset),("method",row.metadata.method),("compressed_size",row.metadata.compressed_size),("uncompressed_size",row.metadata.uncompressed_size),("crc",row.metadata.crc)] {assert_eq!(value,want[key].as_u64().unwrap() as u32);}
            }
        }
    }
    #[test] fn all_original_stored_and_deflated_payloads_match_native_bytes() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_zip_payload_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],1066);
        let golden=std::fs::read(root().join(p["golden"]["path"].as_str().unwrap())).unwrap();assert_eq!(golden.len(),p["golden"]["bytes"].as_u64().unwrap() as usize);
        let mut archives:Vec<_>=p["archives"].as_array().unwrap().iter().map(|a|Archive::open(Some(std::fs::read(root().join(a["path"].as_str().unwrap())).unwrap())).unwrap().unwrap()).collect();
        let mut fallback_archives:Vec<_>=p["archives"].as_array().unwrap().iter().map(|a| {let bytes=std::fs::read(root().join(a["path"].as_str().unwrap())).unwrap();let entries=local_entries(&bytes).unwrap();Archive {bytes,entries}}).collect();
        let mut next=vec![0usize;archives.len()];
        for c in p["cases"].as_array().unwrap() {
            let id=c["archive"].as_u64().unwrap() as usize;let index=next[id];next[id]+=1;
            assert_eq!(archives[id].entries[index].name,c["name"].as_str().unwrap().as_bytes());
            let actual=archives[id].read(index).unwrap();let start=c["golden_offset"].as_u64().unwrap() as usize;let len=c["uncompressed_size"].as_u64().unwrap() as usize;
            assert_eq!(actual.bytes,golden[start..start+len],"{}",c["name"]);assert_eq!(actual.returned_bytes,c["returned_bytes"].as_u64().unwrap() as u32);
            assert_eq!(archives[id].entries[index].metadata.cached_data_offset,c["data_offset"].as_u64().unwrap() as u32);
            let fallback=fallback_archives[id].read(index).unwrap();assert_eq!(fallback.bytes,actual.bytes);assert_eq!(fallback.returned_bytes,actual.returned_bytes);
        }
    }
}
