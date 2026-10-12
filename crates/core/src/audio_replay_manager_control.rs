//! Native9019A0/901B40/901B00 ownership for the replay object manager.
use crate::audio_announcer_object_lookup as read;
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove as removal;
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use crate::audio_announcer_owner_control as control;
use crate::audio_replay_object_manager::{self as manager,Boundary};

pub const VTABLE:u32=0x10d6030;
pub const DISPOSE:u32=0x901b40;

#[derive(Debug,PartialEq,Eq)]
pub enum Error {Read(read::Error),Manager(manager::Error),Free(removal::Error),AddressOverflow}
impl From<read::Error> for Error{fn from(e:read::Error)->Self{Self::Read(e)}}
impl From<manager::Error> for Error{fn from(e:manager::Error)->Self{Self::Manager(e)}}
impl From<removal::Error> for Error{fn from(e:removal::Error)->Self{Self::Free(e)}}

/// This control owns an8F8810 manager; its first word is not a virtual table.
/// Allocation/replacement order and null allocation follow native9019A0.
pub fn replace_pair<B:Storage+ControlBoundary>(b:&mut B,pair:u32,object:u32)->Result<(),control::Error>{
    control::replace_pair_with_vtable(b,pair,object,VTABLE)
}

/// Native901B00 destroys both trees and the mutex, then unconditionally frees.
/// The native stack argument is ignored; this is not a flags-based scalar delete.
pub fn delete_manager<B:Boundary>(b:&mut B,object:u32,_native_argument:u32)->Result<u32,Error>{
    manager::destroy(b,object)?;
    let route=b.deallocator()?;
    b.free(object,route)?;
    Ok(object)
}

/// Native901B40 directly destroys the manager, without a virtual-object dispatch.
pub fn dispose<B:Boundary>(b:&mut B,shared_control:u32)->Result<(),Error>{
    let object=b.word(shared_control.checked_add(12).ok_or(Error::AddressOverflow)?)?;
    if object!=0{delete_manager(b,object,object)?;}
    Ok(())
}
