//! Native90A4C0/90B7C0 empty resource-manager lifetime. No provider factory/UI.
//! Normal heap writes and frees follow the native routines. Retirement first
//! validates that every tree/node is exclusively owned and the caches are empty;
//! these extra reads and resumable phases are a host-error adaptation, not SEH.
use crate::audio_announcer_registry_init::Storage;
pub use crate::audio_loading_owned_string::Boundary;
pub use crate::audio_replay_metadata::Error;
use serde::Serialize;
#[path="audio_loading_resource_manager_index.rs"]
mod index;
pub const BYTES:u32=172;
pub const GLOBAL:u32=0x2d78f1c;
pub const VTABLE:u32=0x10d6450;
pub const SCALAR_DELETE:u32=0x90a760;
pub const HASH_GLOBALS:[u32;4]=[0x2d6edf0,0x2d6edf8,0x2d6edf4,0x2d6edfc];
pub const HASH_NAMES:[u32;4]=[0x10d666c,0x10bf2d4,0x10d6880,0x10d6b34];
const TREES:[(u32,u32);9]=[(4,44),(12,48),(20,24),(28,24),(44,48),(64,48),(84,48),(112,64),(136,48)];
#[derive(Debug,Clone,Copy,PartialEq,Eq,Serialize)]
pub enum Phase { Fresh,Building,Constructed,Published,Retiring,AwaitingGlobalClear,Retired }
#[derive(Debug,Clone,Copy,Serialize)]
pub struct Snapshot {
    pub pointer:u32,pub phase:Phase,pub owned_allocations:usize,
    pub constructed:bool,pub published:bool,pub backpointers:bool,pub retirement_step:usize,
}
#[derive(Debug,Clone,Copy,Default)]
struct Allocation { pointer:u32,bytes:u32,live:bool }
#[derive(Debug,Clone,Copy)]
enum Action { None,Word(u32,u32),Byte(u32,u8),Free(u32) }
#[derive(Debug)]
struct Retirement { actions:[Action;96],len:usize,next:usize }
impl Default for Retirement {fn default()->Self{Self{actions:[Action::None;96],len:0,next:0}}}
impl Retirement {
    fn add(&mut self,a:Action)->Result<(),Error>{
        if self.len==self.actions.len(){return Err(Error::Boundary("resource retirement plan capacity"));}
        self.actions[self.len]=a;self.len+=1;Ok(())
    }
    fn reset_tree(&mut self,tree:u32,head:u32)->Result<(),Error>{
        for off in [4,0,8]{self.add(Action::Word(add(head,off)?,head))?;}
        self.add(Action::Word(add(tree,4)?,0))
    }
}
/// Every successful allocation is recorded before any fallible initialization.
/// The caller must keep this record on Err; dropping it is not cleanup. No Drop
/// or Clone, and no adoption of arbitrary objects from the source global.
#[derive(Debug)]
#[must_use="Keep this record until retire_empty succeeds"]
pub struct Record {
    pointer:u32,phase:Phase,allocations:[Allocation;14],allocation_count:usize,
    constructed:bool,published:bool,publication_attempted:bool,backpointers:bool,
    retirement:Option<Retirement>,
}
impl Default for Record {
    fn default()->Self{Self{pointer:0,phase:Phase::Fresh,allocations:[Allocation::default();14],allocation_count:0,
        constructed:false,published:false,publication_attempted:false,backpointers:false,retirement:None}}
}
impl Record {
    pub fn pointer(&self)->u32{self.pointer}
    pub fn is_retired(&self)->bool{self.allocations.iter().all(|a|!a.live)&&!self.publication_attempted}
    pub fn snapshot(&self)->Snapshot{Snapshot{pointer:self.pointer,phase:self.phase,
        owned_allocations:self.allocations.iter().filter(|a|a.live).count(),constructed:self.constructed,
        published:self.published,backpointers:self.backpointers,
        retirement_step:self.retirement.as_ref().map_or(0,|r|r.next)}}
    fn owns(&self,p:u32,bytes:u32)->bool{self.allocations.iter().any(|a|a.live&&a.pointer==p&&a.bytes==bytes)}
    fn allocate(&mut self,b:&mut impl Boundary,n:u32)->Result<u32,Error>{
        if self.allocation_count==14{return Err(Error::Boundary("resource manager allocation inventory full"));}
        let p=b.allocate(n)?;
        if p!=0 {
            self.allocations[self.allocation_count]=Allocation{pointer:p,bytes:n,live:true};self.allocation_count+=1;
        }
        Ok(p)
    }
    fn release(&mut self,b:&mut impl Boundary,p:u32)->Result<(),Error>{
        let i=self.allocations.iter().position(|a|a.live&&a.pointer==p)
            .ok_or(Error::Boundary("resource manager refuses unowned allocation"))?;
        let route=b.deallocator()?;b.release_owned(p,route)?;
        self.allocations[i].live=false;Ok(())
    }
}
fn add(p:u32,n:u32)->Result<u32,Error>{p.checked_add(n).ok_or(Error::AddressOverflow)}
fn put(b:&mut impl Boundary,p:u32,n:u32,v:u32)->Result<(),Error>{Ok(Storage::write_word(b,add(p,n)?,v)?)}
fn byte(b:&mut impl Boundary,p:u32,n:u32,v:u8)->Result<(),Error>{Ok(b.write_byte(add(p,n)?,v)?)}
fn word(b:&mut impl Boundary,p:u32,n:u32)->Result<u32,Error>{Ok(b.word(add(p,n)?)?)}
fn mix(h:u32,c:u8)->u32{
    let c=if c.is_ascii_uppercase(){c+32}else{c};
    h.wrapping_mul(0x1003f).wrapping_add(c as i8 as i32 as u32)
}
///8E50F0 signed-byte hash, ASCII uppercase folding. Reads the terminator.
pub fn hash65599(b:&mut impl Boundary,mut p:u32)->Result<u32,Error>{
    if p==0{return Ok(0);}
    let mut h=0u32;
    loop{let c=b.read_byte(p)?;if c==0{return Ok(h);}h=mix(h,c);p=add(p,1)?;}
}
///531A50/531A90/531AD0/531B10. First '[' is an immediate AL value in
///these four specialized routines; unlike8E50F0, byte0 is not loaded.
pub fn initialize_hashes(b:&mut impl Boundary)->Result<(),Error>{
    for (name,global) in HASH_NAMES.into_iter().zip(HASH_GLOBALS){
        let mut h=mix(0,b'[');let mut p=add(name,1)?;
        loop{let c=b.read_byte(p)?;if c==0{break;}h=mix(h,c);p=add(p,1)?;}
        put(b,global,0,h)?;
    }
    Ok(())
}
fn sentinel(b:&mut impl Boundary,r:&mut Record,n:u32)->Result<u32,Error>{
    let p=r.allocate(b,n)?;if p==0{return Err(Error::AllocationFailed(n));}
    for off in [0,4,8]{put(b,p,off,p)?;}
    // Native word16 store0101 lowered into two fallible host byte writes.
    byte(b,p,12,1)?;byte(b,p,13,1)?;Ok(p)
}
fn tree(b:&mut impl Boundary,r:&mut Record,p:u32,n:u32)->Result<(),Error>{
    put(b,p,0,0)?;put(b,p,4,0)?;let head=sentinel(b,r,n)?;put(b,p,0,head)
}
fn embedded(b:&mut impl Boundary,r:&mut Record,p:u32,vt:u32)->Result<(),Error>{
    put(b,p,4,0)?;put(b,p,0,0x10d63b4)?;tree(b,r,add(p,8)?,48)?;
    put(b,p,16,0)?;put(b,p,0,vt)
}
fn provider_hash(b:&mut impl Boundary,p:u32)->Result<u32,Error>{
    let vt=word(b,p,0)?;let target=word(b,vt,0x24)?;
    let g=match target{0x901ef0=>0x2d6edf0,0x901ee0=>0x2d6edfc,0x901ed0=>0x2d6edf8,0x901e20=>0x2d6edf4,
        _=>return Err(Error::Boundary("unknown embedded provider hash method"))};
    Ok(b.word(g)?)
}
fn construct(b:&mut impl Boundary,r:&mut Record,scratch4:u32)->Result<(),Error>{
    let p=r.pointer;put(b,p,0,VTABLE)?;
    for (off,n) in [(4,44),(12,48),(20,24),(28,24)]{tree(b,r,add(p,off)?,n)?;}
    embedded(b,r,add(p,0x24)?,0x10d63e8)?;
    embedded(b,r,add(p,0x38)?,0x10d62fc)?;
    embedded(b,r,add(p,0x4c)?,0x10d641c)?;put(b,p,0x60,0)?;
    let q=add(p,0x68)?;put(b,q,4,0)?;put(b,q,0,0x10d6474)?;
    tree(b,r,add(q,8)?,64)?;put(b,q,16,0)?;put(b,q,20,0)?;
    embedded(b,r,add(p,0x80)?,0x10d62c8)?;
    put(b,p,0x98,0)?;put(b,p,0x94,0x10d6330)?;
    for off in [0x9c,0xa0,0xa4]{put(b,p,off,0)?;}
    byte(b,p,0xa8,0)?;
    for off in [0x24,0x38,0x80,0x94]{
        let provider=add(p,off)?;let key=provider_hash(b,provider)?;
        put(b,scratch4,0,key)?;
        let slot=index::value_slot(b,r,add(p,0x1c)?,scratch4)?;put(b,slot,0,provider)?;
    }
    r.constructed=true;r.phase=Phase::Constructed;Ok(())
}
///90B7C0. Host precondition: exclusive lease on GLOBAL and empty Record. An
///external nonzero global is rejected, never overwritten/adopted. scratch4 is
///borrowed only for this call; even failed construction retirement needs none.
///After Err, call retire_empty; do not repeat produce on the active Record.
pub fn produce(b:&mut impl Boundary,r:&mut Record,scratch4:u32)->Result<u32,Error>{
    if !r.is_retired()||!matches!(r.phase,Phase::Fresh|Phase::Retired){return Err(Error::Boundary("resource manager record already active"));}
    if b.word(GLOBAL)?!=0{return Err(Error::Boundary("external resource manager already published"));}
    *r=Record::default();r.phase=Phase::Building;
    let p=r.allocate(b,BYTES)?;r.pointer=p;
    if p!=0{construct(b,r,scratch4)?;}
    r.publication_attempted=true;put(b,GLOBAL,0,p)?;
    if p==0{r.publication_attempted=false;r.phase=Phase::Retired;}
    else{r.published=true;r.phase=Phase::Published;}
    Ok(p)
}
///Only592E49..592E6A. Does not stand in for complete game startup.
pub fn wire_backpointers(b:&mut impl Boundary,r:&mut Record)->Result<(),Error>{
    if !r.constructed||!r.published||r.retirement.is_some(){return Err(Error::Boundary("resource manager not available for backpointers"));}
    if b.word(GLOBAL)?!=r.pointer{return Err(Error::Boundary("resource manager global changed"));}
    for off in [0x28,0x3c,0x50,0x6c,0x84,0x98]{put(b,r.pointer,off,r.pointer)?;}
    byte(b,r.pointer,0xa8,1)?;r.backpointers=true;Ok(())
}
fn checked_head(b:&mut impl Boundary,r:&Record,offset:u32,bytes:u32,empty:bool)->Result<u32,Error>{
    let tree=add(r.pointer,offset)?;let head=word(b,tree,0)?;
    if !r.owns(head,bytes)||b.read_byte(add(head,13)?)?!=1{return Err(Error::InvalidTree);}
    if empty {
        if word(b,tree,4)?!=0 {return Err(Error::Boundary("resource manager retirement requires empty cache"));}
        for off in [0,4,8] {if word(b,head,off)?!=head {return Err(Error::Boundary("resource manager retirement requires empty cache"));}}
    }
    Ok(head)
}
fn plan_index(b:&mut impl Boundary,r:&Record,plan:&mut Retirement,head:u32,node:u32,seen:&mut [u32;4],used:&mut usize)->Result<(),Error>{
    if node==head{return Ok(());}
    if *used==4||seen[..*used].contains(&node)||!r.owns(node,24)||b.read_byte(add(node,13)?)?!=0{return Err(Error::InvalidTree);}
    seen[*used]=node;*used+=1;
    let right=word(b,node,8)?;let left=word(b,node,0)?;
    let v=word(b,node,20)?;
    if ![0x24,0x38,0x80,0x94].into_iter().any(|off|r.pointer.checked_add(off)==Some(v)){return Err(Error::InvalidTree);}
    plan_index(b,r,plan,head,right,seen,used)?;
    plan.add(Action::Free(node))?;
    plan_index(b,r,plan,head,left,seen,used)
}
fn prepare_retirement(b:&mut impl Boundary,r:&Record)->Result<Retirement,Error>{
    if !r.owns(r.pointer,BYTES)||word(b,r.pointer,0)?!=VTABLE{return Err(Error::Boundary("resource manager ownership mismatch"));}
    let mut heads=[0u32;9];
    for (i,(off,n)) in TREES.into_iter().enumerate(){
        let head=checked_head(b,r,off,n,off!=28)?;
        if heads[..i].contains(&head){return Err(Error::InvalidTree);}heads[i]=head;
    }
    // Empty lifetime cannot own vector elements, provider allocations or nodes
    // injected into a cache by another owner. Reject before any mutation.
    for off in [0x9c,0xa0,0xa4,0x34,0x48,0x5c,0x60,0x78,0x7c,0x90]{
        if word(b,r.pointer,off)?!=0{return Err(Error::Boundary("resource manager populated state is not a qualified empty lifetime"));}
    }
    let mut plan=Retirement::default();let p=r.pointer;
    plan.add(Action::Word(p,VTABLE))?;
    for i in [2,1,0]{plan.reset_tree(add(p,TREES[i].0)?,heads[i])?;}
    plan.add(Action::Byte(add(p,0xa8)?,0))?;
    plan.add(Action::Word(add(p,0x94)?,0x10d6294))?;
    for (i,base) in [(8,0x80),(7,0x68),(6,0x4c),(5,0x38),(4,0x24)]{
        plan.reset_tree(add(p,TREES[i].0)?,heads[i])?;
        plan.add(Action::Free(heads[i]))?;plan.add(Action::Word(add(p,base)?,0x10d6294))?;
    }
    let mut seen=[0;4];let mut used=0;let root=word(b,heads[3],4)?;
    plan_index(b,r,&mut plan,heads[3],root,&mut seen,&mut used)?;
    if used!=word(b,p,0x20)? as usize||r.snapshot().owned_allocations!=10+used{return Err(Error::InvalidTree);}
    for i in [3,2,1,0]{plan.reset_tree(add(p,TREES[i].0)?,heads[i])?;plan.add(Action::Free(heads[i]))?;}
    plan.add(Action::Word(p,0x1084ed4))?;plan.add(Action::Free(p))?;Ok(plan)
}
///90A760(flags1)/90A800 empty-cache writes/frees, followed by outer591058
///global clear. Phase cursor is advanced only after successful atomic release
///or completed write, so no free is repeated after a later host error.
///An incomplete constructor instead retires its tracked raw allocations in
///reverse order. This is explicitly host recovery, not native SEH emulation.
pub fn retire_empty(b:&mut impl Boundary,r:&mut Record)->Result<(),Error>{
    if r.is_retired(){r.phase=Phase::Retired;r.pointer=0;return Ok(());}
    if !r.published&&r.publication_attempted{put(b,GLOBAL,0,0)?;r.publication_attempted=false;}
    if !r.constructed{
        for i in (0..r.allocation_count).rev(){if r.allocations[i].live{r.release(b,r.allocations[i].pointer)?;}}
    }else{
        if r.retirement.is_none(){
            if r.published&&b.word(GLOBAL)?!=r.pointer{return Err(Error::Boundary("resource manager global changed before retirement"));}
            let plan=prepare_retirement(b,r)?;r.retirement=Some(plan);r.phase=Phase::Retiring;
        }
        loop{
            let plan=r.retirement.as_ref().unwrap();if plan.next==plan.len{break;}
            let action=plan.actions[plan.next];
            match action{Action::None=>{},Action::Word(p,v)=>put(b,p,0,v)?,Action::Byte(p,v)=>byte(b,p,0,v)?,Action::Free(p)=>r.release(b,p)?}
            r.retirement.as_mut().unwrap().next+=1;
        }
    }
    if r.publication_attempted{
        r.phase=Phase::AwaitingGlobalClear;
        // Keep the source global published through the entire native destructor.
        // Its late clear can fail: inventory is already retired, never freed twice.
        put(b,GLOBAL,0,0)?;r.publication_attempted=false;
    }
    r.pointer=0;r.published=false;r.constructed=false;r.backpointers=false;r.phase=Phase::Retired;Ok(())
}
#[cfg(test)]
#[path="audio_loading_resource_manager_tests.rs"]
mod tests;
