//! Verified B09360/B094B0 factories and registered Meter creators/parameters.
//! Native addresses identify historical implementations; they are never executed.
//! Allocation, registration production, DSP and device acceptance remain separate.
use crate::audio_bus_bank::Error;

pub const METER_ID: u32 = 0x0081_0003;
pub const METER_EFFECT_CREATOR: u32 = 0xb3e260;
pub const METER_PARAMETER_CREATOR: u32 = 0xb3df60;
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Kind { Effect, Parameter }
#[derive(Debug, Clone, Copy)]
pub struct Registration { pub id: u32, pub effect: u32, pub parameter: u32 }
#[derive(Debug, Default)]
pub struct Registry { pub entries: Vec<Registration> }
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Created { pub status: u32, pub reference: u32 }
pub trait Creator {
    fn create(&mut self, creator: u32, allocator: u32) -> Result<u32, Error>;
}
impl Registry {
    /// Ordered native lookup: the first match wins, even with a null parameter creator.
    pub fn create(&self, kind: Kind, id: u32, allocator: u32,
                  backend: &mut impl Creator) -> Result<Created, Error> {
        let Some(entry) = self.entries.iter().find(|e| e.id == id) else {
            return Ok(Created { status: 2, reference: 0 });
        };
        let creator = match kind { Kind::Effect => entry.effect, Kind::Parameter => entry.parameter };
        if creator == 0 {
            return if kind == Kind::Parameter { Ok(Created { status: 1, reference: 0 }) }
                else { Err(Error::Backend("native effect registration has null creator")) };
        }
        let reference = backend.create(creator, allocator)?;
        Ok(Created { status: if reference == 0 { 2 } else { 1 }, reference })
    }
}
#[derive(Debug, Clone)]
pub struct Memory { pub reference: u32, pub raw: Vec<u8> }
pub trait Allocator {
    fn allocate(&mut self, allocator: u32, size: u32) -> Result<Option<Memory>, Error>;
}
fn allocate(backend: &mut impl Allocator, allocator: u32, size: usize)
    -> Result<Option<Memory>, Error> {
    let allocation = backend.allocate(allocator, size as u32)?;
    if let Some(memory) = &allocation {
        if memory.reference == 0 || memory.raw.len() != size { return Err(Error::InvalidAllocation); }
    }
    Ok(allocation)
}
fn write(raw: &mut [u8], offset: usize, bits: u32) {
    raw[offset..offset + 4].copy_from_slice(&bits.to_le_bytes());
}
/// B3E260 modifies only the vtable, five words and byte 0x50 in an 84-byte allocation.
pub fn create_meter_effect(allocator: u32, backend: &mut impl Allocator)
    -> Result<Option<Memory>, Error> {
    let Some(mut object) = allocate(backend, allocator, 84)? else { return Ok(None); };
    write(&mut object.raw, 0, 0xff36d4);
    for offset in [8, 12, 16, 20] { write(&mut object.raw, offset, 0); }
    object.raw[0x50] = 0;
    Ok(Some(object))
}
/// B3DF60 leaves all seven parameter words untouched until initialization.
pub fn create_meter_parameter(allocator: u32, backend: &mut impl Allocator)
    -> Result<Option<Memory>, Error> {
    let Some(mut object) = allocate(backend, allocator, 32)? else { return Ok(None); };
    write(&mut object.raw, 0, 0xff36a4);
    Ok(Some(object))
}
/// B3E3E0 leaves output bytes 6 and 7 untouched.
pub fn meter_info(output: &mut [u8; 8]) -> u32 {
    write(output, 0, 3);
    output[4..6].copy_from_slice(&1u16.to_le_bytes());
    1
}
fn parameter(raw: &[u8]) -> Result<(), Error> {
    if raw.len() != 32 { return Err(Error::InvalidAllocation); }
    if raw[..4] != 0xff36a4u32.to_le_bytes() {
        return Err(Error::Backend("unqualified parameter class"));
    }
    Ok(())
}
/// B3E0B0 consumes 25 backing bytes independently of the declared length.
/// Invalid physical buffers return an explicit error instead of native out-of-bounds reads.
pub fn meter_set_block(object: &mut Memory, backing: &[u8], _declared_length: u32)
    -> Result<u32, Error> {
    parameter(&object.raw)?;
    if backing.len() < 25 { return Err(Error::Truncated); }
    object.raw[4..24].copy_from_slice(&backing[..20]);
    write(&mut object.raw, 24, u32::from(backing[20]));
    object.raw[28..32].copy_from_slice(&backing[21..25]);
    Ok(1)
}
/// B3E040 uses native bit patterns when length is zero; otherwise calls SetBlock.
pub fn meter_init_parameter(object: &mut Memory, backing: &[u8], length: u32)
    -> Result<u32, Error> {
    parameter(&object.raw)?;
    if length != 0 { return meter_set_block(object, backing, length); }
    for (i, value) in [0, 0x3dcccccd, 0xc2400000, 0x40c00000, 0, 0, 0].into_iter().enumerate() {
        write(&mut object.raw, 4 + 4 * i, value);
    }
    Ok(1)
}
/// B3DFE0 copies all opaque parameter words without interpreting float payloads.
pub fn meter_clone_parameter(object: &Memory, allocator: u32, backend: &mut impl Allocator)
    -> Result<Option<Memory>, Error> {
    parameter(&object.raw)?;
    let Some(mut clone) = allocate(backend, allocator, 32)? else { return Ok(None); };
    write(&mut clone.raw, 0, 0xff36a4);
    clone.raw[4..32].copy_from_slice(&object.raw[4..32]);
    Ok(Some(clone))
}

/// Concrete verified creators usable by the ordered registry. Unknown creators fail
/// explicitly; no arbitrary plugin is substituted with Meter.
pub struct MeterCreators<'a, A> {
    pub allocator: &'a mut A,
    pub objects: &'a mut std::collections::BTreeMap<u32, Memory>,
}
impl<A: Allocator> Creator for MeterCreators<'_, A> {
    fn create(&mut self, creator: u32, allocator: u32) -> Result<u32, Error> {
        let object = match creator {
            METER_EFFECT_CREATOR => create_meter_effect(allocator, self.allocator)?,
            METER_PARAMETER_CREATOR => create_meter_parameter(allocator, self.allocator)?,
            _ => return Err(Error::Backend("unqualified plugin creator")),
        };
        let Some(object) = object else { return Ok(0); };
        let reference = object.reference;
        if self.objects.contains_key(&reference) { return Err(Error::InvalidAllocation); }
        self.objects.insert(reference, object);
        Ok(reference)
    }
}

#[cfg(test)] mod tests {
    use super::*;
    use serde_json::{Value, json};
    struct Factory { returned: u32, calls: Vec<Value> }
    impl Creator for Factory {
        fn create(&mut self, creator: u32, allocator: u32) -> Result<u32, Error> {
            self.calls.push(json!({"kind":"create", "creator":creator,"allocator":allocator}));
            Ok(self.returned)
        }
    }
    #[test] fn audio_plugin_factory_matches216_native_ordered_lookup_and_status_cases() {
        let proof: Value = serde_json::from_str(include_str!("../../../data/4.20/audio_plugin_factory_contract.json")).unwrap();
        assert_eq!(proof["case_count"], 216);
        for (i, row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let registry = Registry { entries: row["entries"].as_array().unwrap().iter().map(|e| Registration {
                id:e["id"].as_u64().unwrap() as u32, effect:e["create"].as_u64().unwrap() as u32,
                parameter:e["parameters"].as_u64().unwrap() as u32 }).collect() };
            let mut creator = Factory { returned:row["returned"].as_u64().unwrap() as u32,calls:vec![] };
            let result = registry.create(if row["kind"] == "plugin" { Kind::Effect } else { Kind::Parameter },
                row["id"].as_u64().unwrap() as u32, 0x121023c, &mut creator).unwrap();
            assert_eq!(u64::from(result.status),row["result"].as_u64().unwrap(),"status {i}");
            assert_eq!(u64::from(result.reference),row["output"].as_u64().unwrap(),"output {i}");
            assert_eq!(json!(creator.calls),row["calls"],"creator order {i}");
        }
    }
    struct Heap { pattern:u8, failure:bool, clone:bool, calls:Vec<Value> }
    impl Allocator for Heap {
        fn allocate(&mut self, _:u32, size:u32) -> Result<Option<Memory>,Error> {
            self.calls.push(json!({"kind":"allocate","size":size,"phase":if self.clone {"clone"} else {"create"}}));
            Ok(if self.failure {None} else {Some(Memory {reference:if self.clone {0x30007000} else {0x30006000},raw:vec![self.pattern;size as usize]})})
        }
    }
    #[test] fn audio_meter_creators_and_info_match12_native_raw_memory_cases() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_meter_plugin_contract.json")).unwrap();
        assert_eq!(p["creator_case_count"],12);
        for (i,row) in p["creator_cases"].as_array().unwrap().iter().enumerate() {
            let mut heap=Heap {pattern:row["pattern"].as_u64().unwrap() as u8,failure:row["failure"].as_bool().unwrap(),clone:false,calls:vec![]};
            let effect=row["kind"]=="effect";
            let registry=Registry {entries:vec![Registration {id:METER_ID,effect:METER_EFFECT_CREATOR,parameter:METER_PARAMETER_CREATOR}]};
            let mut objects=std::collections::BTreeMap::new();
            let created=registry.create(if effect {Kind::Effect} else {Kind::Parameter},METER_ID,0,
                &mut MeterCreators {allocator:&mut heap,objects:&mut objects}).unwrap();
            assert_eq!(u64::from(created.status),row["result"].as_u64().unwrap(),"status {i}");
            let result=objects.remove(&created.reference);
            assert_eq!(u64::from(result.as_ref().map_or(0,|v|v.reference)),row["pointer"].as_u64().unwrap(),"pointer {i}");
            let raw=result.as_ref().map_or_else(||vec![heap.pattern;if effect {84} else {32}],|v|v.raw.clone());
            assert_eq!(raw,bytes(row["raw"].as_str().unwrap()),"memory {i}");
            if effect && result.is_some() {let mut info=[heap.pattern;8];assert_eq!(meter_info(&mut info),1);assert_eq!(info.to_vec(),bytes(row["info"].as_str().unwrap()),"info {i}");}
            assert_eq!(json!(heap.calls),row["calls"],"allocation {i}");
        }
    }
    #[test] fn audio_meter_parameters_match24_native_init_and_clone_cases() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_meter_plugin_contract.json")).unwrap();
        assert_eq!(p["parameter_case_count"],24);
        for (i,row) in p["parameter_cases"].as_array().unwrap().iter().enumerate() {
            let mut heap=Heap {pattern:row["pattern"].as_u64().unwrap() as u8,failure:false,clone:false,calls:vec![]};
            let mut object=create_meter_parameter(0,&mut heap).unwrap().unwrap();
            let blob=bytes(row["payload"].as_str().unwrap());
            assert_eq!(meter_init_parameter(&mut object,&blob,row["length"].as_u64().unwrap() as u32).unwrap(),1);
            assert_eq!(object.raw,bytes(row["before_clone"].as_str().unwrap()),"init {i}");
            heap.clone=true;heap.failure=row["clone_failure"].as_bool().unwrap();
            let clone=meter_clone_parameter(&object,0,&mut heap).unwrap();
            assert_eq!(u64::from(clone.as_ref().map_or(0,|v|v.reference)),row["clone_pointer"].as_u64().unwrap(),"clone {i}");
            let raw=clone.map_or_else(||vec![heap.pattern;32],|v|v.raw);
            assert_eq!(raw,bytes(row["clone_raw"].as_str().unwrap()),"clone memory {i}");
            assert_eq!(object.raw,bytes(row["source_after"].as_str().unwrap()),"source {i}");
            assert_eq!(json!(heap.calls),row["calls"],"allocation {i}");
        }
    }
    fn bytes(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
    #[test] fn audio_meter_truncated_physical_block_is_explicit_and_preserves_parameter() {
        let mut heap=Heap {pattern:0xa5,failure:false,clone:false,calls:vec![]};
        let mut p=create_meter_parameter(0,&mut heap).unwrap().unwrap();let before=p.raw.clone();
        assert_eq!(meter_init_parameter(&mut p,&[0;24],1),Err(Error::Truncated));assert_eq!(p.raw,before);
        assert_eq!(meter_init_parameter(&mut p,&[],0),Ok(1));
    }
}
