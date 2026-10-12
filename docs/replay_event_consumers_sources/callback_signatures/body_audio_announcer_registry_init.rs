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
