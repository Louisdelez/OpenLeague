//!93FB10 logical system-attribute lookup; native population and allocation pending.
use std::collections::BTreeMap;
#[derive(Clone,Debug,PartialEq,Eq)]
pub struct Attributes {values:BTreeMap<u32,u32>}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {NonFiniteValue,DuplicateKey}
impl Attributes {
    /// Supplied logical snapshot with unique keys. This does not synthesize the
    /// native hash-container insertion, rehash, allocation or population policy.
    pub fn from_snapshot(entries:impl IntoIterator<Item=(u32,u32)>)->Result<Self,Error> {
        let mut values=BTreeMap::new();
        for (key,value) in entries {
            if !f32::from_bits(value).is_finite(){return Err(Error::NonFiniteValue);}
            if values.insert(key,value).is_some(){return Err(Error::DuplicateKey);}
        }
        Ok(Self {values})
    }
    ///93FB10 returns positive zero for missing keys, preserving finite value bits.
    pub fn read(&self,key:u32)->u32 {self.values.get(&key).copied().unwrap_or(0)}
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    #[test]
    fn finite_snapshots_match132_whole_native_lookup_returns() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/particle_attributes_contract.json")).unwrap();
        let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),132);assert!(proof["adapters"].as_array().unwrap().is_empty());
        for (index,row) in rows.iter().enumerate() {
            let entries=row["entries"].as_array().unwrap().iter().map(|v|(v[0].as_u64().unwrap() as u32,v[1].as_u64().unwrap() as u32));
            let attributes=Attributes::from_snapshot(entries).unwrap();
            assert_eq!(attributes.read(row["key"].as_u64().unwrap() as u32) as u64,row["cpu"]["value"].as_u64().unwrap(),"case{index}");
        }
        assert_eq!(Attributes::from_snapshot([(7,0),(7,1)]),Err(Error::DuplicateKey));
        assert_eq!(Attributes::from_snapshot([(7,f32::INFINITY.to_bits())]),Err(Error::NonFiniteValue));
    }
}
