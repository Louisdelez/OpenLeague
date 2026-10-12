//! Native 661410/664E50 normal-return registry construction with owned byte storage.
//! Native uninitialized constructor byte is supplied explicitly, never given semantics.
use crate::audio_announcer_object_lookup::{self as lookup, Memory};
use std::collections::BTreeMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub struct State { pub manager: u32, pub initialization_flag: u8, pub shutdown_flag: u8 }
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Error { Backend(&'static str), AddressOverflow, NullNestedAllocation(u32), Lookup(lookup::Error) }
pub trait Storage: Memory {
    fn allocate(&mut self, bytes: u32) -> Result<u32, Error>;
    fn write_word(&mut self, address: u32, value: u32) -> Result<(), Error>;
    fn write_byte(&mut self, address: u32, value: u8) -> Result<(), Error>;
    fn register_shutdown(&mut self, callback: u32) -> Result<(), Error>;
}
fn add(base:u32,offset:u32)->Result<u32,Error> {base.checked_add(offset).ok_or(Error::AddressOverflow)}
/// Flags change before allocation, and a null top allocation still reaches registration.
/// Nested null/throwing allocations are explicit errors; no successful registry is fabricated.
pub fn initialize(state:&mut State, constructor_byte:u8, memory:&mut impl Storage)->Result<(),Error> {
    if state.manager!=0 {return Ok(());}
    if state.initialization_flag!=0 {state.initialization_flag=0;state.shutdown_flag=1;}
    let manager=memory.allocate(36)?;
    if manager!=0 {
        construct_at(memory,manager,constructor_byte)?;
    }
    state.manager=manager;
    if state.shutdown_flag==0 {memory.register_shutdown(0x6653b0)?;}
    Ok(())
}
/// Original664E50 constructor at caller-owned storage.
pub fn construct_at(memory:&mut impl Storage,manager:u32,constructor_byte:u8)->Result<(),Error> {
        memory.write_byte(manager,constructor_byte)?;
        memory.write_word(add(manager,4)?,0)?;
        memory.write_word(add(manager,8)?,0)?;
        let sentinel=memory.allocate(16)?;
        if sentinel==0 {return Err(Error::NullNestedAllocation(16));}
        memory.write_word(sentinel,sentinel)?;
        memory.write_word(add(sentinel,4)?,sentinel)?;
        memory.write_word(add(manager,4)?,sentinel)?;
        for offset in [12,16,20] {memory.write_word(add(manager,offset)?,0)?;}
        memory.write_word(add(manager,32)?,0x40800000)?;
        let buckets=memory.allocate(64)?;
        if buckets==0 {return Err(Error::NullNestedAllocation(64));}
        for offset in (0..64).step_by(4) {memory.write_word(add(buckets,offset)?,sentinel)?;}
        memory.write_word(add(manager,12)?,buckets)?;
        memory.write_word(add(manager,20)?,add(buckets,64)?)?;
        memory.write_word(add(manager,16)?,add(buckets,64)?)?;
        memory.write_word(add(manager,24)?,7)?;
        memory.write_word(add(manager,28)?,8)?;
    Ok(())
}
pub fn lookup_live(state:&mut State,constructor_byte:u8,key:u32,memory:&mut impl Storage)->Result<u32,Error> {
    initialize(state,constructor_byte,memory)?;
    lookup::lookup_initialized(memory,state.manager,key).map_err(Error::Lookup)
}

/// Owned allocations use canonical 32-bit labels, without host pointer casts.
/// Fill bytes are deterministic physical storage, not inferred native padding semantics.
pub struct OwnedMemory {
    blocks:BTreeMap<u32,Vec<u8>>, cursor:u32, fill:u8,
    pub allocations:Vec<(u32,u32)>, pub shutdown_callbacks:Vec<u32>, pub released_labels:Vec<u32>,
}
impl OwnedMemory {
    pub fn new(first_label:u32,fill:u8)->Self {Self {blocks:BTreeMap::new(),cursor:first_label,fill,allocations:vec![],shutdown_callbacks:vec![],released_labels:vec![]}}
    /// Caller-owned actor, metadata or global bytes at explicit canonical labels.
    /// Does not consume allocator labels or masquerade as an engine allocation.
    pub fn reserve_at(&mut self,label:u32,bytes:u32)->Result<(),Error> {
        self.ensure_free_range(label,bytes)?;
        let mut block=Vec::new();block.try_reserve_exact(bytes as usize).map_err(|_|Error::Backend("owned allocation failed"))?;block.resize(bytes as usize,self.fill);
        self.blocks.insert(label,block);Ok(())
    }
    fn ensure_free_range(&self,label:u32,bytes:u32)->Result<(),Error> {
        if label==0 || bytes==0 {return Err(Error::Backend("empty canonical storage range"));}
        let end=add(label,bytes)?;
        if let Some((&start,block))=self.blocks.range(..=label).next_back() {
            if add(start,u32::try_from(block.len()).map_err(|_|Error::AddressOverflow)?)?>label {return Err(Error::Backend("overlapping owned storage range"));}
        }
        if let Some((&start,_))=self.blocks.range(label..).next() {if start<end {return Err(Error::Backend("overlapping owned storage range"));}}
        Ok(())
    }
    pub fn release(&mut self,label:u32)->Result<(),Error> {self.blocks.remove(&label).ok_or(Error::Backend("owned allocation unavailable for release"))?;self.released_labels.push(label);Ok(())}
    pub fn read_byte(&self,address:u32)->Result<u8,lookup::Error> {Ok(self.read(address,1)?[0])}
    fn read(&self,address:u32,len:usize)->Result<&[u8],lookup::Error> {
        let (&start,block)=self.blocks.range(..=address).next_back().ok_or(lookup::Error::MissingWord(address))?;
        let offset=(address-start) as usize;
        block.get(offset..offset.checked_add(len).ok_or(lookup::Error::InvalidLayout)?).ok_or(lookup::Error::MissingWord(address))
    }
    fn write(&mut self,address:u32,bytes:&[u8])->Result<(),Error> {
        let (&start,block)=self.blocks.range_mut(..=address).next_back().ok_or(Error::Backend("owned storage unavailable"))?;
        let offset=(address-start) as usize;let end=offset.checked_add(bytes.len()).ok_or(Error::AddressOverflow)?;
        block.get_mut(offset..end).ok_or(Error::Backend("owned storage range unavailable"))?.copy_from_slice(bytes);Ok(())
    }
}
impl Memory for OwnedMemory {
    fn word(&mut self,address:u32)->Result<u32,lookup::Error> {Ok(u32::from_le_bytes(self.read(address,4)?.try_into().unwrap()))}
}
impl Storage for OwnedMemory {
    fn allocate(&mut self,bytes:u32)->Result<u32,Error> {
        if self.cursor==0 {return Err(Error::Backend("zero canonical allocation label"));}
        self.ensure_free_range(self.cursor,bytes)?;
        let step=bytes.checked_add(31).ok_or(Error::AddressOverflow)? & !15;
        let next=add(self.cursor,step)?;let mut block=Vec::new();
        block.try_reserve_exact(bytes as usize).map_err(|_|Error::Backend("owned allocation failed"))?;block.resize(bytes as usize,self.fill);
        let label=self.cursor;self.blocks.insert(label,block);self.cursor=next;self.allocations.push((bytes,label));Ok(label)
    }
    fn write_word(&mut self,address:u32,value:u32)->Result<(),Error> {self.write(address,&value.to_le_bytes())}
    fn write_byte(&mut self,address:u32,value:u8)->Result<(),Error> {self.write(address,&[value])}
    fn register_shutdown(&mut self,callback:u32)->Result<(),Error> {self.shutdown_callbacks.push(callback);Ok(())}
}
#[cfg(test)] mod tests {
    use super::*;
    struct FaultMemory {owned:OwnedMemory,fail_size:Option<u32>}
    impl Memory for FaultMemory {fn word(&mut self,a:u32)->Result<u32,lookup::Error> {self.owned.word(a)}}
    impl Storage for FaultMemory {
        fn allocate(&mut self,size:u32)->Result<u32,Error> {if self.fail_size==Some(size) {self.owned.allocations.push((size,0));Ok(0)} else {self.owned.allocate(size)}}
        fn write_word(&mut self,a:u32,v:u32)->Result<(),Error> {self.owned.write_word(a,v)}
        fn write_byte(&mut self,a:u32,v:u8)->Result<(),Error> {self.owned.write_byte(a,v)}
        fn register_shutdown(&mut self,c:u32)->Result<(),Error> {self.owned.register_shutdown(c)}
    }
    #[test] fn audio_registry_initialization_matches128_native_sequences256_calls_and_empty_lookups() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_registry_initialization_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),128);
        let mut lookups=0;
        for case in cases {
            let poison=case["poison"].as_u64().unwrap() as u8;
            let mut memory=FaultMemory {owned:OwnedMemory::new(0x34000000,poison),fail_size:case["fail_top"].as_bool().unwrap().then_some(36)};
            let mut state=State {manager:if case["cached"].as_bool().unwrap() {0x30008000} else {0},initialization_flag:case["flag"].as_u64().unwrap() as u8,shutdown_flag:case["shutdown"].as_u64().unwrap() as u8};
            for step in case["steps"].as_array().unwrap() {
                memory.owned.allocations.clear();memory.owned.shutdown_callbacks.clear();initialize(&mut state,poison,&mut memory).unwrap();
                assert_eq!(state.manager,step["manager"].as_u64().unwrap() as u32,"{case}");assert_eq!(state.initialization_flag,step["initialization_flag"].as_u64().unwrap() as u8);assert_eq!(state.shutdown_flag,step["shutdown_flag"].as_u64().unwrap() as u8);
                let allocations:Vec<_>=memory.owned.allocations.iter().map(|&(bytes,pointer)|serde_json::json!({"bytes":bytes,"pointer":pointer})).collect();assert_eq!(serde_json::json!(allocations),step["allocations"]);assert_eq!(serde_json::json!(memory.owned.shutdown_callbacks),step["atexit_registrations"]);
                for word in step["words"].as_array().unwrap() {assert_eq!(memory.word(word[0].as_u64().unwrap() as u32).unwrap(),word[1].as_u64().unwrap() as u32,"{case}");}
                for call in step["empty_lookups"].as_array().unwrap() {assert_eq!(lookup::lookup_initialized(&mut memory,state.manager,call["key"].as_u64().unwrap() as u32).unwrap(),0);lookups+=1;}
            }
        }
        assert_eq!(lookups,256);
    }
    #[test] fn audio_live_lookup_initializes_once_and_keeps_owned_storage() {
        let mut state=State::default();let mut memory=OwnedMemory::new(0x36000000,0);
        for key in [0,42,999,u32::MAX] {assert_eq!(lookup_live(&mut state,0,key,&mut memory).unwrap(),0);}
        assert_eq!(memory.allocations.len(),3);assert_eq!(memory.shutdown_callbacks,vec![0x6653b0]);
        assert_eq!(state.manager,0x36000000);
    }
    #[test] fn audio_registry_allocation_errors_do_not_fabricate_empty_actor_results() {
        for size in [16,64] {
            let mut state=State {initialization_flag:255,..State::default()};let mut memory=FaultMemory {owned:OwnedMemory::new(0x34000000,0),fail_size:Some(size)};
            assert_eq!(initialize(&mut state,0,&mut memory),Err(Error::NullNestedAllocation(size)));assert_eq!(state.manager,0);assert_eq!(state.initialization_flag,0);assert_eq!(state.shutdown_flag,1);assert!(memory.owned.shutdown_callbacks.is_empty());
        }
        let mut state=State::default();let mut memory=FaultMemory {owned:OwnedMemory::new(0x34000000,0),fail_size:Some(36)};
        assert_eq!(lookup_live(&mut state,0,42,&mut memory),Err(Error::Lookup(lookup::Error::UninitializedRegistry)));
    }
}
