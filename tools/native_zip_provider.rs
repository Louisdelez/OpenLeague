//! Read-only archive-first resource provider, native primary-name index.
//! Manifest mount order is explicit; native alias registration remains open.
use std::{io,path::Path,collections::HashMap};
use crate::{native_archive_index::{Entry,Index},native_zip_archive::Archive};
fn merged_rows(rows:Vec<Entry>)->Vec<Entry> {
    let mut positions:HashMap<Vec<u8>,usize>=HashMap::new();let mut merged:Vec<Entry>=Vec::new();
    for row in rows {
        let key:Vec<u8>=row.key.iter().take_while(|&&b|b!=0).map(|b|b.to_ascii_lowercase()).collect();
        if let Some(&i)=positions.get(&key) {merged[i].packed_id=row.packed_id;}
        else {positions.insert(key,merged.len());merged.push(row);}
    }
    merged
}
#[derive(bevy::prelude::Resource)]
pub struct Provider {archives:Vec<Archive>,index:Index,pub entry_count:usize,pub unique_names:usize}
#[derive(bevy::prelude::Resource)]
pub struct StartupHud {pub fast_hud:Vec<u8>,pub chat:Vec<u8>}
impl Provider {
    pub fn from_catalog(root:&Path)->io::Result<Self> {
        let manifest:serde_json::Value=serde_json::from_slice(&std::fs::read(root.join("data/4.20/native_zip_catalog.json"))?).map_err(io::Error::other)?;
        let paths=manifest["archives"].as_array().ok_or_else(||io::Error::other("invalid native ZIP catalog"))?;
        let mut archives=Vec::new();let mut rows=Vec::new();let mut entry_count=0;
        for (i,p) in paths.iter().enumerate() {
            if i>65535 {return Err(io::Error::other("native archive index exceeds16-bit range"));}
            let path=p["path"].as_str().ok_or_else(||io::Error::other("native ZIP catalog path missing"))?;
            let archive=Archive::open(crate::native_filesystem_provider::read(&root.join(path))?)?
                .ok_or_else(||io::Error::other(format!("native archive unavailable: {path}")))?;
            if archive.entries.len()>65536 {return Err(io::Error::other("native archive entry count exceeds16-bit range"));}
            for (j,entry) in archive.entries.iter().enumerate() {rows.push(Entry {key:entry.name.clone(),packed_id:((i as u32)<<16)|(j as u32)});}
            entry_count+=archive.entries.len();archives.push(archive);
        }
        let rows=merged_rows(rows);let unique_names=rows.len();let capacity=unique_names.max(2).checked_next_power_of_two().ok_or_else(||io::Error::other("archive index capacity overflow"))?;
        let mask=u32::try_from(capacity-1).map_err(io::Error::other)?;
        let index=Index::from_rows(rows,mask,capacity).map_err(io::Error::other)?;
        Ok(Self {archives,index,entry_count,unique_names})
    }
    pub fn archive_count(&self)->usize {self.archives.len()}
    pub fn read_optional(&mut self,root:&Path,path:&Path)->io::Result<Option<Vec<u8>>> {
        let query=path.to_str().ok_or_else(||io::Error::other("invalid resource path"))?.as_bytes();
        let found=self.index.lookup(Some(query),true,|_|{}).map_err(io::Error::other)?;
        if found.is_some() {
            // Native dispatcher queries predicate, then archive open performs its own lookup.
            let id=self.index.lookup(Some(query),true,|_|{}).map_err(io::Error::other)?.ok_or_else(||io::Error::other("archive index changed during open"))?;
            let archive=self.archives.get_mut((id>>16) as usize).ok_or_else(||io::Error::other("invalid native archive ID"))?;
            let result=archive.read((id&65535) as usize)?;
            if result.returned_bytes as usize!=result.bytes.len() {return Err(io::Error::new(io::ErrorKind::Unsupported,"native incomplete ZIP file-wrapper behavior is unqualified"));}
            return Ok(Some(result.bytes));
        }
        crate::native_filesystem_provider::read(&root.join(path))
    }
    pub fn startup_hud(&mut self,root:&Path)->io::Result<StartupHud> {
        let required=|p:Option<Vec<u8>>|p.ok_or_else(||io::Error::other("native HUD archive resource missing"));
        Ok(StartupHud {fast_hud:required(self.read_optional(root,Path::new("HUD/defaults/FastHUD.ini"))?)?,chat:required(self.read_optional(root,Path::new("HUD/defaults/Chat.ini"))?)?})
    }
}
#[cfg(all(test,windows))] mod tests {
    use super::*;
    #[test] fn duplicate_primary_names_preserve_first_key_and_last_id_like_native_mount_prefix() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_zip_duplicate_index_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],72);
        for c in p["cases"].as_array().unwrap() {
            let bytes=|key:&str|c[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>();
            let original=bytes("existing");let id=((c["archive_count"].as_u64().unwrap() as u32)<<16)|(c["entry_ordinal"].as_u64().unwrap() as u32);
            let rows=merged_rows(vec![Entry {key:original.clone(),packed_id:0x12345678},Entry {key:bytes("requested"),packed_id:id}]);
            assert_eq!(rows[0].key,original);assert_eq!(rows[0].packed_id,c["packed_id_after"].as_u64().unwrap() as u32);
            assert_eq!(rows.len(),if c["matched"].as_bool().unwrap() {1}else{2});
        }
    }
    #[test] fn mounted_provider_resolves_every_original_payload_and_filesystem_defaults() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=Provider::from_catalog(&root).unwrap();assert_eq!(provider.archive_count(),5);assert_eq!(provider.entry_count,1066);
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_zip_payload_contract.json")).unwrap();let golden=std::fs::read(root.join(p["golden"]["path"].as_str().unwrap())).unwrap();
        for c in p["cases"].as_array().unwrap() {
            let path=c["name"].as_str().unwrap();let start=c["golden_offset"].as_u64().unwrap() as usize;let len=c["uncompressed_size"].as_u64().unwrap() as usize;
            // The duplicate names in these archives are empty directory records.
            assert_eq!(provider.read_optional(&root,Path::new(path)).unwrap().unwrap(),golden[start..start+len],"{path}");
        }
        let hud=provider.startup_hud(&root).unwrap();assert_eq!(hud.fast_hud.len(),1607);assert_eq!(hud.chat.len(),1773);
        assert_eq!(provider.read_optional(&root,Path::new("hud/defaults/FASTHUD.INI")).unwrap().unwrap(),hud.fast_hud);
        assert_eq!(provider.read_optional(&root,Path::new("data/4.20/configuration/defaults/Game.cfg")).unwrap().unwrap(),include_bytes!("../../../data/4.20/configuration/defaults/Game.cfg"));
        assert!(provider.read_optional(&root,Path::new("missing-native-resource-test")).unwrap().is_none());
    }
}
