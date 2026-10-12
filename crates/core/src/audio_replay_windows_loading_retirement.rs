//! Standard-loading String24 leases. No UI or normal-recipient factory.
//! Slots and their bank keepalive exist before the consumer runs. Errors never
//! discard remaining ownership or recycle a descriptor still needed by it.
use super::*;
use crate::{audio_loading_owned_string as owned,audio_loading_screen_packet::ReceiveFailure,
            audio_replay_metadata::Error};

const BYTES:u32=64; // Name24 + prefix pair8 + normalized key28 + padding4.
struct Lease { address:u32, bytes:u32 }
struct Record<N> {
    lease:Lease, active:bool, failure:Option<ReceiveFailure>,
    retry_error:Option<Error>, scratch_error:Option<init::Error>,
    group_retry_errors:[Option<Error>;2],
    // Deliberate lifetime retention on unresolved cleanup. Retirement drops
    // this Arc; a vacant slot MUST NOT retain the Shared bank.
    _keepalive:Arc<Shared<N>>,
}
enum Slot<N> { Vacant, Reserved, Live(Record<N>) }
pub(super) struct Ledger<N> { slots:Vec<Slot<N>> }
impl<N> Default for Ledger<N> {fn default()->Self {Self{slots:Vec::new()}}}

impl<N:startup::Network+Send+'static> owned::Boundary for Backend<N> {
    fn release_owned(&mut self,p:u32,route:remove::Deallocator)->Result<(),remove::Error> {
        if !matches!(route,remove::Deallocator::Standard) {
            return Err(remove::Error::Owned(init::Error::Backend("custom atomic deallocator is not attached")));
        }
        if p==0{return Ok(());}
        let mut bank=self.shared.bank.lock().map_err(|_|remove::Error::Owned(init::Error::Backend("engine bank poisoned")))?;
        if !bank.owned.contains(&p) {
            return Err(remove::Error::Owned(init::Error::Backend("engine does not own allocation")));
        }
        // Reserve logging capacity while the block is still fully owned.
        bank.memory.released_labels.try_reserve(1)
            .map_err(|_|remove::Error::Owned(init::Error::Backend("release log reservation failed")))?;
        bank.memory.release(p).map_err(remove::Error::Owned)?;
        bank.owned.remove(&p);
        Ok(())
    }
}

impl<N:startup::Network+Send+'static> Backend<N> {
    fn acquire_loading_lease(&mut self)->Result<Lease,&'static str> {
        let mut bank=self.shared.bank.lock().map_err(|_|"event bank poisoned")?;
        let reused=bank.event_scratch.get_mut(&BYTES).and_then(Vec::pop);
        let p=reused.unwrap_or(bank.next_scratch);
        let next=if reused.is_none(){Some(p.checked_add(BYTES).and_then(|v|v.checked_add(63))
            .map(|v|v&!63).ok_or("event scratch address exhausted")?)}else{None};
        if bank.memory.reserve_at(p,BYTES).is_err(){
            // Popping reserved vector capacity guarantees this push cannot grow.
            if reused.is_some(){bank.event_scratch.get_mut(&BYTES).unwrap().push(p);}
            return Err("event scratch reservation failed");
        }
        if let Some(next)=next{bank.next_scratch=next;}
        Ok(Lease{address:p,bytes:BYTES})
    }
    fn release_loading_lease(&mut self,lease:&Lease)->Result<(),init::Error> {
        let mut bank=self.shared.bank.lock().map_err(|_|init::Error::Backend("event bank poisoned"))?;
        // Pool/log capacity is reserved BEFORE release. Any returned Err keeps
        // the entire lease alive; no post-release allocation can lose its label.
        bank.event_scratch.entry(lease.bytes).or_default().try_reserve(1)
            .map_err(|_|init::Error::Backend("event pool reservation failed"))?;
        bank.memory.released_labels.try_reserve(1)
            .map_err(|_|init::Error::Backend("event release log reservation failed"))?;
        bank.memory.release(lease.address)?;
        assert_eq!(bank.memory.released_labels.pop(),Some(lease.address));
        bank.event_scratch.get_mut(&lease.bytes).unwrap().push(lease.address);
        Ok(())
    }
    /// Only standard receive uses this lease. A failed provider before guard
    /// creation still owns its existing rollback contract, unchanged here.
    pub(super) fn loading_name_temporary(
        &mut self,f:impl FnOnce(&mut Self,u32)->Result<(),ReceiveFailure>,
    )->Result<(),&'static str> {
        let shared=self.shared.clone();
        let index={
            let mut ledger=shared.loading_retirements.lock().map_err(|_|"loading retirement ledger poisoned")?;
            if let Some(index)=ledger.slots.iter().position(|s|matches!(s,Slot::Vacant)) {
                ledger.slots[index]=Slot::Reserved;index
            }else{
                ledger.slots.try_reserve(1).map_err(|_|"loading retirement slot reservation failed")?;
                let index=ledger.slots.len();ledger.slots.push(Slot::Reserved);index
            }
        };
        let lease=match self.acquire_loading_lease(){
            Ok(lease)=>lease,
            Err(e)=>{
                shared.loading_retirements.lock().unwrap_or_else(|p|p.into_inner()).slots[index]=Slot::Vacant;
                return Err(e);
            }
        };
        let address=lease.address;
        shared.loading_retirements.lock().unwrap_or_else(|p|p.into_inner()).slots[index]=Slot::Live(Record {
            lease,active:true,failure:None,retry_error:None,scratch_error:None,
            group_retry_errors:[None,None],_keepalive:shared.clone(),
        });
        let result=f(self,address);
        {
            // Poison recovery here preserves ownership; it is not a claim that
            // an arbitrary panic inside a consumer is recoverable.
            let mut ledger=shared.loading_retirements.lock().unwrap_or_else(|p|p.into_inner());
            let Slot::Live(record)=&mut ledger.slots[index] else {unreachable!("reserved loading lease disappeared")};
            record.failure=result.err();record.active=false;
        }
        match self.settle_loading_slot(index,false) {
            Ok(None)=>Ok(()),
            Ok(Some(error))=>Err(self.failure(error,"native loading-screen packet consumer failed")),
            Err(e)=>{
                // The error is borrowed AFTER its owner is installed in the
                // reserved slot. Formatting never consumes Failure.remaining.
                let ledger=shared.loading_retirements.lock().unwrap_or_else(|p|p.into_inner());
                if let Slot::Live(r)=&ledger.slots[index] {
                    self.failure((&r.failure,&r.retry_error,&r.group_retry_errors,&r.scratch_error),e);
                }
                Err(e)
            }
        }
    }
    fn settle_loading_slot(&mut self,index:usize,retry:bool)->Result<Option<ReceiveFailure>,&'static str> {
        let shared=self.shared.clone();
        let mut ledger=shared.loading_retirements.lock().unwrap_or_else(|p|p.into_inner());
        let record=match &mut ledger.slots[index] {
            Slot::Vacant=>return Ok(None),
            Slot::Reserved=>return Err("loading retirement slot is reserved by an active consumer"),
            Slot::Live(record)=>record,
        };
        if record.active {return Err("loading name consumer is still active");}
        if let Some(ReceiveFailure::Owned(failure))=&mut record.failure {
            if let Some(owner)=&mut failure.remaining {
                if !retry{return Err("loading name cleanup deferred with owned scratch");}
                if let Err(e)=owner.retire(self){record.retry_error=Some(e);return Err("loading name cleanup remains unresolved");}
                failure.remaining=None;record.retry_error=None;
            }
        }
        if let Some(ReceiveFailure::OwnedGroup(failure))=&mut record.failure {
            if failure.remaining.remaining_count()!=0 {
                if !retry{return Err("loading group cleanup deferred with owned scratch");}
                // Try every remaining owner, including the caller name when
                // key cleanup fails. A reset-only guard also retains the lease.
                record.group_retry_errors=failure.remaining.retire(self);
                if record.group_retry_errors.iter().any(Option::is_some)
                    || failure.remaining.remaining_count()!=0 {
                    return Err("loading group cleanup remains unresolved");
                }
            }
        }
        if let Err(e)=self.release_loading_lease(&record.lease){
            record.scratch_error=Some(e);return Err("loading name scratch cleanup remains unresolved");
        }
        let Slot::Live(record)=std::mem::replace(&mut ledger.slots[index],Slot::Vacant) else {unreachable!()};
        // Remaining is proven absent above; dropping the keepalive now permits
        // final Shared/CRT retirement once other real owners leave.
        Ok(record.failure)
    }
    pub(super) fn retire_loading_temporaries(&mut self)->Result<(),&'static str> {
        let count=self.shared.loading_retirements.lock().unwrap_or_else(|p|p.into_inner()).slots.len();
        for index in 0..count {
            // Prior primary/cleanup failure stays in runtime.errors after its
            // owners retire. Only an unresolved owner prevents shutdown.
            match self.settle_loading_slot(index,true) {
                Ok(retired_error)=>drop(retired_error), // remaining is absent
                Err(e)=>{
                    // Record each retry cause before a later successful retry
                    // clears it. Borrow the record; never consume its owner.
                    let shared=self.shared.clone();
                    let ledger=shared.loading_retirements.lock().unwrap_or_else(|p|p.into_inner());
                    if let Slot::Live(r)=&ledger.slots[index] {
                        self.failure(("original_failure",&r.failure,"retry_cleanup",&r.retry_error,
                            "group_retry_cleanup",&r.group_retry_errors,
                            "scratch_cleanup",&r.scratch_error),e);
                    }
                    return Err(e);
                }
            }
        }
        Ok(())
    }
}

impl<N:startup::Network+Send+'static> Runtime<N> {
    pub fn loading_retirement_snapshot(&self)->serde_json::Value {
        let ledger=self.shared.loading_retirements.lock().unwrap_or_else(|p|p.into_inner());
        let mut active=0;let mut pending=0;let mut descriptors=0;let mut retained_bytes=0;
        for slot in &ledger.slots {match slot {
            Slot::Vacant=>{},Slot::Reserved=>active+=1,
            Slot::Live(r)=>{if r.active{active+=1;}else{pending+=1;}retained_bytes+=u64::from(r.lease.bytes);
                match &r.failure {
                    Some(ReceiveFailure::Owned(f))=>descriptors+=usize::from(f.remaining.is_some()),
                    Some(ReceiveFailure::OwnedGroup(f))=>descriptors+=f.remaining.remaining_count(),
                    _=>{},
                }}
        }}
        serde_json::json!({"active":active,"pending":pending,"owned_string_guards":descriptors,
            "retained_scratch_bytes":retained_bytes,"ledger_poisoned":self.shared.loading_retirements.is_poisoned()})
    }
}
