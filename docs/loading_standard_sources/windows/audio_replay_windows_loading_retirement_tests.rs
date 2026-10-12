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
    assert_eq!(r.loading_retirement_snapshot()["retained_scratch_bytes"],32);
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
