//! Native8C0ED0 descriptor equality/order and8C0F50 cache lookup prefix.
//! Engine-owned descriptor bindings; native device allocation/lifetime remains separate.
use std::cmp::Ordering;
#[derive(Clone,Debug)]
pub struct Descriptor {pub name:Vec<u16>,pub size:u32,pub extra:u32,pub flags:u32}
fn fold(v:u16)->u16 {if (65..=90).contains(&v) {v+32}else{v}}
impl Descriptor {
    pub fn compare(&self,other:&Self)->Ordering {
        let names=match (self.name.is_empty(),other.name.is_empty()) {
            (true,false)=>Ordering::Less,(false,true)=>Ordering::Greater,(true,true)=>Ordering::Equal,
            (false,false)=> {
                let mut result=Ordering::Equal;
                for i in 0..=self.name.len().max(other.name.len()) {
                    let a=fold(*self.name.get(i).unwrap_or(&0));let b=fold(*other.name.get(i).unwrap_or(&0));
                    result=a.cmp(&b);if result!=Ordering::Equal || a==0 {break;}
                }
                result
            }
        };
        names.then(self.size.cmp(&other.size)).then(self.extra.cmp(&other.extra)).then(self.flags.cmp(&other.flags))
    }
    pub fn from_metadata(m:&crate::native_hud_font_creation::Metadata)->Result<Self,&'static str> {
        let name=std::str::from_utf8(&m.family).map_err(|_|"font family encoding unavailable")?.encode_utf16().collect();
        Ok(Self {name,size:m.scaled,extra:0,flags:m.flags})
    }
}
pub struct Entry {pub descriptor:Descriptor,pub references:u32}
#[derive(Default)]
pub struct Registry {pub entries:Vec<Entry>}
impl Registry {
    pub fn lookup(&mut self,descriptor:&Descriptor)->Option<usize> {
        let index=self.entries.iter().position(|e|e.descriptor.compare(descriptor)==Ordering::Equal)?;
        self.entries[index].references=self.entries[index].references.wrapping_add(1);Some(index)
    }
    pub fn bind(&mut self,descriptor:Descriptor)->usize {
        if let Some(index)=self.lookup(&descriptor) {return index}
        // Explicit OpenLeague owned insertion, not original font-device construction.
        let index=self.entries.len();self.entries.push(Entry {descriptor,references:1});index
    }
    pub fn source_bindings(texts:&[crate::native_hud_font_creation::Metadata])->Result<(Self,Vec<usize>),&'static str> {
        let mut registry=Self::default();let mut bindings=Vec::new();
        for text in texts {bindings.push(registry.bind(Descriptor::from_metadata(text)?));}
        Ok((registry,bindings))
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn descriptor_comparison_matches_2508_native_inline_heap_name_and_field_cases() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_descriptor_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],2508);
        for c in p["cases"].as_array().unwrap() {
            let descriptor=|side:&str| {
                let fields=c[format!("{side}_fields")].as_array().unwrap();Descriptor {name:c[format!("{side}_name")].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u16).collect(),size:fields[0].as_u64().unwrap() as u32,extra:fields[1].as_u64().unwrap() as u32,flags:fields[2].as_u64().unwrap() as u32}
            };
            let order=descriptor("left").compare(&descriptor("right"));let actual=match order {Ordering::Less=>-1,Ordering::Equal=>0,Ordering::Greater=>1};assert_eq!(actual,c["result"].as_i64().unwrap());
        }
    }
    #[test] fn native_cache_72_cases_preserve_first_equal_descriptor_and_wrapping_references() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_font_cache_lookup_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],72);
        for c in p["cases"].as_array().unwrap() {
            let descriptor=|row:&serde_json::Value|Descriptor {name:row["name"].as_str().unwrap().encode_utf16().collect(),size:row["size"].as_u64().unwrap() as u32,extra:row["extra"].as_u64().unwrap() as u32,flags:row["flags"].as_u64().unwrap() as u32};
            let mut registry=Registry {entries:c["entries"].as_array().unwrap().iter().map(|e|Entry {descriptor:descriptor(e),references:c["initial_references"].as_u64().unwrap() as u32}).collect()};
            let found=registry.lookup(&descriptor(&c["query"]));assert_eq!(found,c["found_index"].as_u64().map(|i|i as usize));assert_eq!(found.is_none(),c["creation_required"].as_bool().unwrap());
            assert_eq!(registry.entries.iter().map(|e|e.references).collect::<Vec<_>>(),c["references_after"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
        }
    }
}
