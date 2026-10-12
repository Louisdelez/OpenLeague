//! Native replay stream8F6700/8F6800 and hierarchical state machine8FB9A0.
//! Worker waiting and concrete stream-resource I/O require runtime implementations.
use crate::audio_announcer_object_lookup as read;
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::{self as removal,Deallocator};
use crate::audio_announcer_owner_metadata as callback;
use crate::audio_replay_object_manager as manager;
use crate::audio_replay_shared_pair as pair;
use std::collections::BTreeSet;

pub const VTABLE:u32=0x10d5f34;
pub const MACHINE_VTABLE:u32=0x10d607c;
pub const NO_OP_ACTION:u32=0x56ff60;
const INVOKE:u32=0x5cce30;
#[derive(Debug,PartialEq,Eq)]
pub enum Error{Read(read::Error),Write(init::Error),Free(removal::Error),Callback(callback::Error),Pair(pair::Error),Boundary(&'static str),UnknownCallback(u32),AddressOverflow,AllocationFailed,InvalidHierarchy,CapacityExceeded}
impl From<read::Error> for Error{fn from(e:read::Error)->Self{Self::Read(e)}}
impl From<init::Error> for Error{fn from(e:init::Error)->Self{Self::Write(e)}}
impl From<removal::Error> for Error{fn from(e:removal::Error)->Self{Self::Free(e)}}
impl From<callback::Error> for Error{fn from(e:callback::Error)->Self{Self::Callback(e)}}
impl From<pair::Error> for Error{fn from(e:pair::Error)->Self{Self::Pair(e)}}

#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Action{pub handler:u32,pub member:u32,pub object:u32,pub method:u32,pub args:[u32;2]}
pub trait Boundary:manager::Boundary+callback::Boundaries{
    /// Native56FF60 is a void no-op taking two arguments. Other virtual actions
    /// need a concrete implementation, rather than a fabricated success value.
    fn state_action(&mut self,action:Action)->Result<(),&'static str>{no_op_action(action.method)}
    /// Read-only instrumentation hook; no native event result is supplied here.
    fn observe_event_callback(&mut self,_handler:u32,_owner:u32,_member:u32,_event:u32){}
    fn join_worker(&mut self,_worker:u32,_timeout:u32)->Result<(),&'static str>{Err("replay worker wait8A8C50 is not connected")}
    fn close_resource(&mut self,_resource:u32)->Result<(),&'static str>{Err("replay resource close8F8F90 is not connected")}
    fn stop_implementation(&mut self,_object:u32,_method:u32)->Result<(),&'static str>{Err("replay implementation stop is not connected")}
}
pub fn no_op_action(method:u32)->Result<(),&'static str>{if method==NO_OP_ACTION{Ok(())}else{Err("unknown replay state virtual action")}}
fn add(a:u32,b:u32)->Result<u32,Error>{a.checked_add(b).ok_or(Error::AddressOverflow)}
fn word(b:&mut impl Boundary,p:u32,offset:u32)->Result<u32,Error>{Ok(b.word(add(p,offset)?)?)}
fn put(b:&mut impl Boundary,p:u32,offset:u32,v:u32)->Result<(),Error>{Ok(Storage::write_word(b,add(p,offset)?,v)?)}
fn byte(b:&mut impl Boundary,p:u32,offset:u32,v:u8)->Result<(),Error>{Ok(b.write_byte(add(p,offset)?,v)?)}
fn free(b:&mut impl Boundary,p:u32)->Result<(),Error>{let route=b.deallocator()?;Ok(b.free(p,route)?)}
fn delete_callback(b:&mut impl Boundary,p:u32)->Result<(),Error>{
    if p!=0{let vt=b.word(p)?;let method=b.word(vt)?;if method!=callback::HANDLER_DELETE{return Err(Error::UnknownCallback(method));}callback::scalar_delete_callback(b,p,1)?;}Ok(())
}
fn handler(b:&mut impl Boundary,p:u32)->Result<(u32,u32),Error>{
    let vt=b.word(p)?;let invoke=word(b,vt,8)?;if invoke!=INVOKE{return Err(Error::UnknownCallback(invoke));}
    Ok((word(b,p,4)?,word(b,p,8)?))
}
fn invoke_action(b:&mut impl Boundary,p:u32,args:[u32;2])->Result<(),Error>{
    let (object,member)=handler(b,p)?;
    let slot=match member{0x66a0ff=>8,0x66a41d=>12,0x5b5e90=>16,0x669de0=>20,0x66a138=>24,0x66a470=>28,0x5ecc60=>32,0x669e50=>36,_=>return Err(Error::UnknownCallback(member))};
    let vt=b.word(object)?;let method=word(b,vt,slot)?;
    b.state_action(Action{handler:p,member,object,method,args}).map_err(Error::Boundary)
}
fn install_callback(b:&mut impl Boundary,machine:u32,node:u32,offset:u32,member:u32)->Result<(),Error>{
    let temporary=b.allocate(12)?;
    if temporary!=0{for (off,value) in [(0,callback::HANDLER_VTABLE),(4,machine),(8,member)]{put(b,temporary,off,value)?;}}
    let cloned=if temporary==0{0}else{
        let vt=b.word(temporary)?;let method=word(b,vt,4)?;
        if method!=callback::HANDLER_CLONE{return Err(Error::UnknownCallback(method));}
        let result=callback::clone_callback(b,temporary);
        if result.is_err(){delete_callback(b,temporary)?;}
        result?
    };
    let old=word(b,node,offset)?;put(b,node,offset,0)?;put(b,node,offset,cloned)?;
    delete_callback(b,old)?;delete_callback(b,temporary)
}
/// Native8FB9A0. The initial state1 entry runs before states2/3/4 are created.
fn initialize_machine(b:&mut impl Boundary,machine:u32)->Result<(),Error>{
    for id in 0..5{
        let node=b.allocate(20)?;if node==0{return Err(Error::AllocationFailed);}
        for off in [0,4,8]{put(b,node,off,0)?;}
        put(b,machine,0x10+id*4,node)?;put(b,node,12,id)?;
        let parent=match id{0=>0,1|2=>word(b,machine,0x10)?,_=>word(b,machine,0x18)?};put(b,node,16,parent)?;
        let methods=match id{0=>[0,0,0x573fa0],1=>[0x66a0ff,0x66a41d,0x8fc0a0],2=>[0x5b5e90,0x669de0,0x8fc0c0],3=>[0x66a138,0x66a470,0x564530],_=>[0x5ecc60,0x669e50,0x564530]};
        for (i,member) in methods.into_iter().enumerate(){if member!=0{install_callback(b,machine,node,i as u32*4,member)?;}}
        if id==1{put(b,machine,4,node)?;let parent=word(b,machine,0x10)?;let action=b.word(node)?;invoke_action(b,action,[parent,node])?;}
    }
    Ok(())
}
pub fn construct(b:&mut impl Boundary,stream:u32)->Result<u32,Error>{
    put(b,stream,0,0x10d5f90)?;byte(b,stream,4,1)?;byte(b,stream,5,0)?;byte(b,stream,6,0)?;
    put(b,stream,8,0)?;put(b,stream,12,0)?;
    let mutex=add(stream,0x10)?;byte(b,mutex,0,0)?;put(b,mutex,4,0)?;b.initialize_lock(mutex).map_err(Error::Boundary)?;
    for off in [0x30,0x34,0x38,0x3c]{put(b,stream,off,0)?;}
    let machine=add(stream,0x40)?;put(b,machine,4,0)?;byte(b,machine,8,0)?;put(b,machine,12,0)?;put(b,machine,0,0x10d6054)?;
    for off in [0x10,0x14,0x18,0x1c,0x20]{put(b,machine,off,0)?;}
    put(b,stream,0,VTABLE)?;put(b,machine,0,MACHINE_VTABLE)?;
    for off in [0x64,0x68,0x6c,0x70]{put(b,stream,off,0)?;}byte(b,stream,0x74,0)?;
    initialize_machine(b,machine)?;Ok(stream)
}

/// Temporary pointer vector used by990BB0/994520 (front insertion only).
#[derive(Default)]
struct PathVector{pointer:u32,length:u32,capacity:u32}
impl PathVector{
    fn prepend(&mut self,b:&mut impl Boundary,value:u32)->Result<(),Error>{
        if self.length==0x3fffffff{return Err(Error::CapacityExceeded);}
        if self.capacity==self.length{
            let half=self.capacity/2;
            let grown=if self.capacity>0x3fffffff-half{0}else{self.capacity+half};
            let capacity=grown.max(self.length+1);let pointer=b.allocate(capacity*4)?;if pointer==0{return Err(Error::AllocationFailed);}
            put(b,pointer,0,value)?;
            for i in 0..self.length{let v=word(b,self.pointer,i*4)?;put(b,pointer,(i+1)*4,v)?;}
            if self.pointer!=0{free(b,self.pointer)?;}
            self.pointer=pointer;self.capacity=capacity;
        }else{
            for i in (0..self.length).rev(){let v=word(b,self.pointer,i*4)?;put(b,self.pointer,(i+1)*4,v)?;}
            put(b,self.pointer,0,value)?;
        }
        self.length+=1;Ok(())
    }
    fn remove_first(&mut self,b:&mut impl Boundary)->Result<(),Error>{
        for i in 1..self.length{let v=word(b,self.pointer,i*4)?;put(b,self.pointer,(i-1)*4,v)?;}
        self.length-=1;Ok(())
    }
    fn build(&mut self,b:&mut impl Boundary,mut node:u32)->Result<(),Error>{
        let mut visited=BTreeSet::new();
        while node!=0{if !visited.insert(node){return Err(Error::InvalidHierarchy);}self.prepend(b,node)?;node=word(b,node,16)?;}
        Ok(())
    }
}
fn release_paths(b:&mut impl Boundary,old:&PathVector,new:&PathVector)->Result<(),Error>{
    let mut route=b.deallocator()?;
    if new.pointer!=0{
        b.free(new.pointer,route)?;
        // Native reloads the route after a custom first free, not after standard free.
        if matches!(route,Deallocator::Custom{..}){route=b.deallocator()?;}
    }
    if old.pointer!=0{b.free(old.pointer,route)?;}Ok(())
}
/// Native990BB0 publishes the destination before exit callbacks. Each callback
/// receives freshly read current state as its first argument, even after mutation.
pub fn transition(b:&mut impl Boundary,machine:u32,target:u32)->Result<(),Error>{
    if target==0{return Ok(());}let current=word(b,machine,4)?;if current==0||target==current{return Ok(());}
    let mut old=PathVector::default();let mut new=PathVector::default();
    let result=(||{
        old.build(b,current)?;new.build(b,target)?;
        if old.length==0||new.length==0||b.word(old.pointer)?!=b.word(new.pointer)?{return Ok(());}
        while old.length!=0&&new.length!=0&&b.word(old.pointer)?==b.word(new.pointer)?{old.remove_first(b)?;new.remove_first(b)?;}
        put(b,machine,4,target)?;
        for i in (0..old.length).rev(){let node=word(b,old.pointer,i*4)?;let action=word(b,node,4)?;let current=word(b,machine,4)?;invoke_action(b,action,[current,target])?;}
        for i in 0..new.length{let node=word(b,new.pointer,i*4)?;let action=b.word(node)?;let current=word(b,machine,4)?;invoke_action(b,action,[current,target])?;}
        Ok(())
    })();
    let cleanup=release_paths(b,&old,&new);match result{Err(e)=>Err(e),Ok(())=>cleanup}
}
fn invoke_event(b:&mut impl Boundary,p:u32,event:u32)->Result<bool,Error>{
    let (machine,member)=handler(b,p)?;b.observe_event_callback(p,machine,member,event);
    match member{
        0x573fa0=>Ok(true),0x564530=>Ok(false),
        0x8fc0a0 if event==0=>{let target=word(b,machine,0x1c)?;transition(b,machine,target)?;Ok(true)},
        0x8fc0a0=>Ok(false),
        0x8fc0c0 if event==1||event==2=>{let target=word(b,machine,if event==1{0x20}else{0x1c})?;transition(b,machine,target)?;Ok(true)},
        0x8fc0c0=>Ok(false),_=>Err(Error::UnknownCallback(member))
    }
}
/// Native990DC0 walks parents only when the current event callback returns AL=0.
pub fn dispatch_event(b:&mut impl Boundary,machine:u32,event:u32)->Result<(),Error>{
    let mut node=word(b,machine,4)?;let mut visited=BTreeSet::new();
    while node!=0{
        if !visited.insert(node){return Err(Error::InvalidHierarchy);}
        let callback=word(b,node,8)?;if invoke_event(b,callback,event)?{break;}node=word(b,node,16)?;
    }
    Ok(())
}
fn base_stop(b:&mut impl Boundary,stream:u32)->Result<(),Error>{
    if b.read_byte(add(stream,4)?)?==0{
        byte(b,stream,5,0)?;let worker=word(b,stream,8)?;
        b.join_worker(worker,9000).map_err(Error::Boundary)?;byte(b,stream,4,1)?;
    }
    Ok(())
}
/// Native8F6BC0 only stops when an ancestor of the current state has ID4.
pub fn stop(b:&mut impl Boundary,stream:u32)->Result<(),Error>{
    let mut node=word(b,stream,0x44)?;let mut visited=BTreeSet::new();
    while node!=0{
        if !visited.insert(node){return Err(Error::InvalidHierarchy);}
        if word(b,node,12)?==4{
            base_stop(b,stream)?;let implementation=word(b,stream,0x64)?;
            if implementation!=0{let vt=b.word(implementation)?;let method=word(b,vt,0x1c)?;b.stop_implementation(implementation,method).map_err(Error::Boundary)?;}
            return dispatch_event(b,add(stream,0x40)?,2);
        }
        node=word(b,node,16)?;
    }
    Ok(())
}
fn destroy_node(b:&mut impl Boundary,node:u32)->Result<(),Error>{
    for off in [8,4,0]{let action=word(b,node,off)?;delete_callback(b,action)?;}free(b,node)
}
fn destroy_machine(b:&mut impl Boundary,machine:u32)->Result<(),Error>{
    put(b,machine,0,0x10d6054)?;
    for off in [0x10,0x14,0x18,0x1c,0x20]{let node=word(b,machine,off)?;if node!=0{destroy_node(b,node)?;put(b,machine,off,0)?;}}
    put(b,machine,0,0x1084ed4)
}
pub fn destroy(b:&mut impl Boundary,stream:u32)->Result<(),Error>{
    put(b,stream,0,VTABLE)?;put(b,stream,0x40,MACHINE_VTABLE)?;stop(b,stream)?;
    pair::destroy(b,add(stream,0x6c)?)?;pair::destroy(b,add(stream,0x64)?)?;
    destroy_machine(b,add(stream,0x40)?)?;
    put(b,stream,0,0x10d5f90)?;base_stop(b,stream)?;
    let resource=word(b,stream,0x30)?;if resource!=0{b.close_resource(resource).map_err(Error::Boundary)?;}
    pair::destroy(b,add(stream,0x38)?)?;pair::destroy(b,add(stream,0x30)?)?;
    b.destroy_lock(add(stream,0x10)?).map_err(Error::Boundary)?;
    pair::destroy(b,add(stream,8)?)?;Ok(())
}
pub fn scalar_delete(b:&mut impl Boundary,stream:u32,flags:u32)->Result<u32,Error>{
    destroy(b,stream)?;if flags&1!=0{free(b,stream)?;}Ok(stream)
}
