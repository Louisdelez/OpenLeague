// Included in loading_packets::tests to reuse actual Backend/provider helpers.
#[test]
fn audio_replay_windows_loading_standard_prefix_uses_real_name_skin_and_owned_override_at_both_stops() {
    for name in [b"Ahri".as_slice(), b"Original real metadata name longer than fifteen".as_slice()] {
        for skin in [7u32,u32::MAX] {
            let mut app=Application::new().unwrap();
            let r=app.transport().unwrap();let service=r.configure_service(Defaults).unwrap();
            r.initialize_game_manager().unwrap();let parent=r.game_manager_snapshot().unwrap().unwrap();
            let mut b=Backend::new(r.shared.clone());let index=initialize_index(&mut b,parent.pointer);
            prepare_name(&mut b,parent.metadata[0],Some(42),123,456,Some(name));
            b.event_temporary(256,|b,s| {
                for(i,v)in name.iter().copied().chain(std::iter::once(0)).enumerate(){Storage::write_byte(b,s+96+i as u32,v).unwrap();}
                b.event_reference(s+64,s+96)?;b.event_reference(s+80,name.len() as u32)?;b.event_reference(s+84,63)?;
                text::put_string_extra(b,parent.metadata[0],123,456,s+64,skin,s+192)
                    .map_err(|e|b.failure(e,"prefix test real skin producer failed"))
            }).unwrap();
            query_name(&mut b,42,name);
            let service_pointer=service.diagnostic().unwrap()["pointer"].as_u64().unwrap() as u32;
            let binding=DiagnosticServiceGlobal::bind(&mut b,service_pointer);
            let recipient=Recipient::create(&mut b,Kind::Standard);
            let override_name=b"Long override name requiring growth beyond both original capacities and SSO";
            let capacity=(override_name.len() as u32)|15;
            let raw=b.allocate(capacity+1).unwrap();
            for(i,v)in override_name.iter().copied().chain(std::iter::once(0)).enumerate(){Storage::write_byte(&mut b,raw+i as u32,v).unwrap();}
            write(&mut b,recipient.p+0x1a8,raw);write(&mut b,recipient.p+0x1b8,override_name.len() as u32);
            write(&mut b,recipient.p+0x1bc,capacity);write(&mut b,recipient.p+0x1a0,13);
            assert_eq!(b.word(standard_prefix::PACKAGE_GLOBAL).unwrap(),0);
            let local=b.word(crate::audio_replay_service_receive::LOCAL_OWNER).unwrap();
            let record=recipient.record(&mut b,42);let payload=packet(local,42,1,false);
            let before=r.snapshot().unwrap().engine_allocations;
            let frees=r.shared.bank.lock().unwrap().memory.released_labels.len();
            assert!(r.receive_game_event(0,3,2,1,&payload).is_err());
            let stop=if skin==u32::MAX{"diagnostic991E60"}else{"resource provider90AD00"};
            assert!(r.errors().iter().any(|e|e.contains(stop)),"{:?}",r.errors());
            assert_eq!(r.snapshot().unwrap().engine_allocations,before);
            assert_eq!(r.shared.bank.lock().unwrap().memory.released_labels.len(),frees+if name.len()>=16{2}else{1});
            assert_eq!(b.word(record+0x40).unwrap(),0,"no UI continuation completed");
            assert_eq!(read_bytes(&mut b,raw,override_name.len() as u32),override_name);
            assert_eq!([b.word(parent.metadata[1]+4).unwrap(),b.word(index[1]+4).unwrap()],[1,1]);
            assert_eq!(r.loading_retirement_snapshot(),serde_json::json!({"active":0,"pending":0,"owned_string_guards":0,
                "retained_scratch_bytes":0,"ledger_poisoned":false}));
            assert_eq!(r.process_clock_snapshot().unwrap().qpc_calls,0);
            remove::Backend::free(&mut b,raw,remove::Deallocator::Standard).unwrap();
            recipient.destroy(&mut b);binding.restore(&mut b);r.close_game_manager().unwrap();service.close().unwrap();
            assert_eq!(r.snapshot().unwrap().engine_allocations,0);drop(b);app.close().unwrap();
        }
    }
}

#[test]
fn audio_replay_windows_loading_deferred_descriptor_survives_nested_lease_and_failed_close_then_retry_releases_keepalive() {
    let mut app=Application::new().unwrap();let r=app.transport().unwrap();
    let shared=r.shared.clone();let mut b=Backend::new(shared.clone());
    let baseline=Arc::strong_count(&shared);let mut scratch=0;let mut raw=0;
    let result=b.loading_name_temporary(|b,s| {
        scratch=s;raw=b.allocate(32).unwrap();
        write(b,s,raw);write(b,s+16,20);write(b,s+20,31);
        b.write_byte(raw,42).unwrap();
        let frees=b.shared.bank.lock().unwrap().memory.released_labels.len();
        assert!(owned::Boundary::release_owned(b,raw,remove::Deallocator::Custom{callback:1,context:2}).is_err());
        assert!(b.shared.bank.lock().unwrap().owned.contains(&raw));
        assert_eq!(metadata::Boundary::read_byte(b,raw).unwrap(),42);
        assert_eq!(b.shared.bank.lock().unwrap().memory.released_labels.len(),frees);
        // Test-only atomic release failure: physical block survives but the
        // allocation's ownership entry is withheld until the explicit repair.
        assert!(b.shared.bank.lock().unwrap().owned.remove(&raw));
        let failure=owned::finish(b,owned::Temporary::new(s),Err::<(),_>(owned::Error::Boundary("test primary failure"))).unwrap_err();
        assert!(failure.remaining.is_some());
        Err(loading::ReceiveFailure::Owned(failure))
    });
    assert!(result.is_err());assert_eq!(b.word(scratch).unwrap(),raw);
    assert_eq!(Arc::strong_count(&shared),baseline+1);
    assert_eq!(r.loading_retirement_snapshot()["pending"],1);
    assert_eq!(r.loading_retirement_snapshot()["owned_string_guards"],1);
    assert_eq!(r.loading_retirement_snapshot()["retained_scratch_bytes"],64);
    assert!(r.errors().iter().any(|e|e.contains("test primary failure")&&e.contains("engine does not own allocation")));
    b.loading_name_temporary(|_,other|{assert_ne!(other,scratch);Ok(())}).unwrap();
    assert_eq!(Arc::strong_count(&shared),baseline+1);
    assert_eq!(b.word(scratch).unwrap(),raw);
    let errors_before_retry=shared.errors.lock().unwrap().len();
    assert!(app.close().unwrap_err().contains("loading name cleanup remains unresolved"));
    assert_eq!(shared.errors.lock().unwrap().len(),errors_before_retry+1);
    assert!(shared.errors.lock().unwrap().last().unwrap().contains("engine does not own allocation"));
    assert_eq!(app.diagnostic().unwrap()["closed"],false);
    assert!(app.transport().is_ok());
    assert!(shared.bank.lock().unwrap().memory.read_byte(raw).is_ok());
    assert!(shared.bank.lock().unwrap().owned.insert(raw));
    b.retire_loading_temporaries().unwrap();
    assert_eq!(Arc::strong_count(&shared),baseline);
    assert!(b.word(scratch).is_err());assert!(shared.bank.lock().unwrap().memory.read_byte(raw).is_err());
    assert_eq!(shared.bank.lock().unwrap().memory.released_labels.iter().filter(|&&p|p==raw).count(),1);
    assert_eq!(app.transport().unwrap().loading_retirement_snapshot()["pending"],0);
    drop(b);drop(shared);app.close().unwrap();assert_eq!(app.diagnostic().unwrap()["closed"],true);
}

#[test]
fn audio_replay_windows_loading_nested_slots_do_not_reuse_active_descriptors_or_retain_successful_keepalives() {
    let mut app=Application::new().unwrap();let r=app.transport().unwrap();
    let shared=r.shared.clone();let mut b=Backend::new(shared.clone());let before=Arc::strong_count(&shared);
    b.loading_name_temporary(|b,outer| {
        assert_eq!(r.loading_retirement_snapshot()["active"],1);
        b.loading_name_temporary(|_,inner|{assert_ne!(outer,inner);Ok(())})
            .map_err(|e|loading::ReceiveFailure::Operation(owned::Error::Boundary(e)))?;
        assert_eq!(r.loading_retirement_snapshot()["active"],1);Ok(())
    }).unwrap();
    assert_eq!(Arc::strong_count(&shared),before);
    assert_eq!(r.loading_retirement_snapshot()["active"],0);assert_eq!(r.loading_retirement_snapshot()["pending"],0);
    assert_eq!(r.snapshot().unwrap().engine_allocations,0);drop(b);drop(shared);app.close().unwrap();
}

#[test]
fn audio_replay_windows_loading_group_retains_both_descriptors_until_independent_retries_complete() {
    let mut app=Application::new().unwrap();let r=app.transport().unwrap();
    let shared=r.shared.clone();let mut b=Backend::new(shared.clone());let baseline=Arc::strong_count(&shared);
    let mut scratch=0;let mut raw=[0,0];
    let result=b.loading_name_temporary(|b,s| {
        scratch=s;
        for index in 0..2 {
            raw[index]=b.allocate(32).unwrap();let p=s+index as u32*32;
            write(b,p,raw[index]);write(b,p+16,20);write(b,p+20,31);
            assert!(b.shared.bank.lock().unwrap().owned.remove(&raw[index]));
        }
        let group=owned::Group::new([Some(owned::Temporary::new(s)),Some(owned::Temporary::new_reset(s+32))]);
        let failure=owned::finish_group(b,group,Err::<(),_>(owned::Error::Boundary("both-owner primary failure"))).unwrap_err();
        assert!(failure.cleanup.iter().all(Option::is_some));assert_eq!(failure.remaining.remaining_count(),2);
        Err(loading::ReceiveFailure::OwnedGroup(failure))
    });
    assert!(result.is_err());assert_eq!(Arc::strong_count(&shared),baseline+1);
    assert_eq!(r.loading_retirement_snapshot()["owned_string_guards"],2);
    assert_eq!(r.loading_retirement_snapshot()["retained_scratch_bytes"],64);
    b.loading_name_temporary(|_,other|{assert_ne!(other,scratch);Ok(())}).unwrap();
    // Name may retire although the key still refuses release. The whole lease
    // stays retained, and a nested packet cannot reuse either descriptor.
    assert!(shared.bank.lock().unwrap().owned.insert(raw[0]));
    assert!(app.close().unwrap_err().contains("loading group cleanup remains unresolved"));
    let r=app.transport().unwrap();
    assert_eq!(app.diagnostic().unwrap()["closed"],false);
    assert_eq!(r.loading_retirement_snapshot()["owned_string_guards"],1);
    assert_eq!(r.loading_retirement_snapshot()["retained_scratch_bytes"],64);
    assert!(shared.bank.lock().unwrap().memory.read_byte(raw[0]).is_err());
    assert!(shared.bank.lock().unwrap().memory.read_byte(raw[1]).is_ok());
    assert_eq!(b.word(scratch+32).unwrap(),raw[1]);assert_eq!(Arc::strong_count(&shared),baseline+1);
    assert!(r.errors().iter().any(|e|e.contains("both-owner primary failure")&&e.contains("group_retry_cleanup")));
    assert!(shared.bank.lock().unwrap().owned.insert(raw[1]));b.retire_loading_temporaries().unwrap();
    assert_eq!(Arc::strong_count(&shared),baseline);assert!(b.word(scratch).is_err());
    assert_eq!(r.loading_retirement_snapshot()["pending"],0);
    let bank=shared.bank.lock().unwrap();
    for raw in raw {assert_eq!(bank.memory.released_labels.iter().filter(|&&p|p==raw).count(),1);}
    drop(bank);drop(b);drop(shared);app.close().unwrap();
}

struct ResetWriteFault<'a,N> {backend:&'a mut Backend<N>,address:u32,failed:bool}
impl<N:startup::Network+Send+'static> Memory for ResetWriteFault<'_,N> {
    fn word(&mut self,p:u32)->Result<u32,read::Error>{self.backend.word(p)}
}
impl<N:startup::Network+Send+'static> Storage for ResetWriteFault<'_,N> {
    fn allocate(&mut self,n:u32)->Result<u32,init::Error>{self.backend.allocate(n)}
    fn write_word(&mut self,p:u32,v:u32)->Result<(),init::Error>{
        if p==self.address&&!self.failed {self.failed=true;return Err(init::Error::Backend("injected key reset write failure"));}
        Storage::write_word(self.backend,p,v)
    }
    fn write_byte(&mut self,p:u32,v:u8)->Result<(),init::Error>{Storage::write_byte(self.backend,p,v)}
    fn register_shutdown(&mut self,p:u32)->Result<(),init::Error>{self.backend.register_shutdown(p)}
}
impl<N:startup::Network+Send+'static> remove::Backend for ResetWriteFault<'_,N> {
    fn write_word(&mut self,p:u32,v:u32)->Result<(),remove::Error>{Storage::write_word(self,p,v).map_err(remove::Error::Owned)}
    fn deallocator(&mut self)->Result<remove::Deallocator,remove::Error>{remove::Backend::deallocator(self.backend)}
    fn free(&mut self,p:u32,r:remove::Deallocator)->Result<(),remove::Error>{remove::Backend::free(self.backend,p,r)}
}
impl<N:startup::Network+Send+'static> metadata::Boundary for ResetWriteFault<'_,N> {
    fn read_byte(&mut self,p:u32)->Result<u8,read::Error>{metadata::Boundary::read_byte(self.backend,p)}
    fn initialize_lock(&mut self,p:u32)->Result<(),&'static str>{metadata::Boundary::initialize_lock(self.backend,p)}
    fn destroy_lock(&mut self,p:u32)->Result<(),&'static str>{metadata::Boundary::destroy_lock(self.backend,p)}
    fn enter_lock(&mut self,p:u32)->Result<(),&'static str>{metadata::Boundary::enter_lock(self.backend,p)}
    fn leave_lock(&mut self,p:u32)->Result<(),&'static str>{metadata::Boundary::leave_lock(self.backend,p)}
}
impl<N:startup::Network+Send+'static> owned::Boundary for ResetWriteFault<'_,N> {
    fn release_owned(&mut self,p:u32,r:remove::Deallocator)->Result<(),remove::Error>{owned::Boundary::release_owned(self.backend,p,r)}
}
#[test]
fn audio_replay_windows_loading_group_retains_reset_only_lease_after_all_heap_buffers_are_released() {
    let mut app=Application::new().unwrap();let r=app.transport().unwrap();
    let shared=r.shared.clone();let mut b=Backend::new(shared.clone());let baseline=Arc::strong_count(&shared);
    let mut scratch=0;let mut raw=[0,0];
    let result=b.loading_name_temporary(|b,s| {
        scratch=s;
        for index in 0..2 {raw[index]=b.allocate(32).unwrap();let p=s+index as u32*32;
            write(b,p,raw[index]);write(b,p+16,20);write(b,p+20,31);}
        let group=owned::Group::new([Some(owned::Temporary::new(s)),Some(owned::Temporary::new_reset(s+32))]);
        let mut fault=ResetWriteFault {backend:b,address:s+32+16,failed:false};
        let failure=owned::finish_group(&mut fault,group,Err::<(),_>(owned::Error::Boundary("reset-only primary failure"))).unwrap_err();
        assert!(fault.failed);assert_eq!(failure.cleanup[0],None);assert!(failure.cleanup[1].is_some());
        let key=failure.remaining.get(1).unwrap();assert_eq!(key.authority(),owned::Authority::None);
        assert_eq!(key.reset(),owned::Reset::Length);assert_eq!(failure.remaining.remaining_count(),1);
        Err(loading::ReceiveFailure::OwnedGroup(failure))
    });
    assert!(result.is_err());assert_eq!(r.snapshot().unwrap().engine_allocations,0);
    assert_eq!(r.loading_retirement_snapshot()["owned_string_guards"],1);
    assert_eq!(r.loading_retirement_snapshot()["retained_scratch_bytes"],64);
    assert_eq!(Arc::strong_count(&shared),baseline+1);assert_eq!(b.word(scratch+32+20).unwrap(),15);
    b.loading_name_temporary(|_,other|{assert_ne!(other,scratch);Ok(())}).unwrap();
    b.retire_loading_temporaries().unwrap();assert_eq!(Arc::strong_count(&shared),baseline);
    assert_eq!(r.loading_retirement_snapshot()["pending"],0);assert!(b.word(scratch).is_err());
    let bank=shared.bank.lock().unwrap();
    for raw in raw {assert_eq!(bank.memory.released_labels.iter().filter(|&&p|p==raw).count(),1);}
    drop(bank);drop(b);drop(shared);app.close().unwrap();
}

#[test]
fn audio_replay_windows_loading_standard_packet_uses_real_resource_manager_and_retires_normalized_key_on_factory_boundary() {
    for name in [b"AhRi".as_slice(),b"OriginalRealMetadataLongerThanFifteen".as_slice()] {
        let mut app=Application::new().unwrap();let r=app.transport().unwrap();
        let service=r.configure_service(Defaults).unwrap();
        let manager=r.initialize_loading_resources().unwrap();r.initialize_game_manager().unwrap();
        let parent=r.game_manager_snapshot().unwrap().unwrap();let mut b=Backend::new(r.shared.clone());
        initialize_index(&mut b,parent.pointer);
        prepare_name(&mut b,parent.metadata[0],Some(42),123,456,Some(name));
        let service_pointer=service.diagnostic().unwrap()["pointer"].as_u64().unwrap() as u32;
        let binding=DiagnosticServiceGlobal::bind(&mut b,service_pointer);
        let recipient=Recipient::create(&mut b,Kind::Standard);write(&mut b,recipient.p+0x1a0,13);
        let record=recipient.record(&mut b,42);let local=b.word(crate::audio_replay_service_receive::LOCAL_OWNER).unwrap();
        let packet_bytes=packet(local,42,1,false);
        // Keep the first query cold:728410 may grow its persistent metadata
        // String24, independently of the two loading stack temporaries.
        let cached=parent.metadata[0]+0x1b0;
        assert_eq!([b.word(cached+16).unwrap(),b.word(cached+20).unwrap()],[0,15]);
        let before_owned=r.shared.bank.lock().unwrap().owned.clone();
        let frees=r.shared.bank.lock().unwrap().memory.released_labels.len();
        assert_eq!(b.word(standard_prefix::PACKAGE_GLOBAL).unwrap(),manager);
        assert!(r.receive_game_event(0,3,2,1,&packet_bytes).is_err());
        assert!(r.errors().iter().any(|e|e.contains("loading resource factory90B520 is unavailable")));
        let capacity=b.word(cached+20).unwrap();
        assert_eq!(b.word(cached+16).unwrap(),name.len() as u32);
        let cached_heap=if name.len()>=16 {
            assert_eq!(capacity,(name.len() as u32)|15);
            let raw=b.word(cached).unwrap();assert!(!before_owned.contains(&raw));Some(raw)
        }else{assert_eq!(capacity,15);None};
        let cached_data=cached_heap.unwrap_or(cached);
        assert_eq!(read_bytes(&mut b,cached_data,name.len() as u32),name);
        assert_eq!(metadata::Boundary::read_byte(&mut b,cached_data+name.len() as u32).unwrap(),0);
        let mut expected_owned=before_owned.clone();
        if let Some(raw)=cached_heap {assert!(expected_owned.insert(raw));}
        // Exactly the cache buffer may persist. No missing old owner, unnamed
        // new allocation or leaked name/key is hidden by an aggregate count.
        assert_eq!(r.shared.bank.lock().unwrap().owned,expected_owned);
        assert_eq!(r.snapshot().unwrap().engine_allocations,expected_owned.len());
        assert_eq!(r.shared.bank.lock().unwrap().memory.released_labels.len(),frees+if name.len()>=16{2}else{0});
        assert_eq!(b.word(record+0x40).unwrap(),0);assert_eq!(r.loading_retirement_snapshot()["pending"],0);
        query_name(&mut b,42,name);
        // Inspect the actual Windows hook while both descriptors still live.
        // The packet path above uses this same hook but retires its stack data
        // before returning; no test-only provider or packet observer is added.
        b.event_temporary(25,|b,payload| {
            b.event_reference(payload,42)?;
            let result=b.loading_name_temporary(|b,s| {
                names::service_name(b,s,42,s+24).map_err(loading::ReceiveFailure::Operation)?;
                let mut owners=owned::Group::new([Some(owned::Temporary::new(s)),None]);
                let primary=loading::Boundary::initialize_standard_record_owned(b,recipient.p,record,payload,service_pointer,&mut owners);
                assert_eq!(primary,Err(owned::Error::Boundary("loading resource factory90B520 is unavailable")));
                let key=owners.get(1).unwrap().address();assert_eq!(key,s+32);
                assert_eq!(b.word(key+24).unwrap(),13);assert_eq!(b.word(key+16).unwrap(),name.len() as u32);
                let key_data=if name.len()>=16 {b.word(key).unwrap()}else{key};
                let name_data=if name.len()>=16 {b.word(s).unwrap()}else{s};
                assert_eq!(read_bytes(b,key_data,name.len() as u32),name.iter().map(u8::to_ascii_lowercase).collect::<Vec<_>>());
                assert_eq!(read_bytes(b,name_data,name.len() as u32),name);
                owned::finish_group(b,owners,primary).map_err(loading::ReceiveFailure::OwnedGroup)
            });
            assert!(result.is_err());Ok(())
        }).unwrap();
        assert_eq!(r.shared.bank.lock().unwrap().owned,expected_owned);
        assert_eq!(r.snapshot().unwrap().engine_allocations,expected_owned.len());
        assert_eq!(r.loading_retirement_snapshot()["pending"],0);
        assert_eq!(r.process_clock_snapshot().unwrap().qpc_calls,0);query_name(&mut b,42,name);
        if let Some(raw)=cached_heap {
            let bank=r.shared.bank.lock().unwrap();
            assert!(bank.owned.contains(&raw));
            assert_eq!(bank.memory.released_labels.iter().filter(|&&p|p==raw).count(),0);
        }
        recipient.destroy(&mut b);binding.restore(&mut b);r.close_game_manager().unwrap();
        // Metadata destruction owns this cached buffer; verify retirement
        // without reading the already destroyed metadata descriptor.
        if let Some(raw)=cached_heap {
            let bank=r.shared.bank.lock().unwrap();
            assert!(!bank.owned.contains(&raw));assert!(bank.memory.word(raw).is_err());
            assert_eq!(bank.memory.released_labels.iter().filter(|&&p|p==raw).count(),1);
        }
        service.close().unwrap();
        drop(b);app.close().unwrap();assert_eq!(app.diagnostic().unwrap()["closed"],true);
    }
}
