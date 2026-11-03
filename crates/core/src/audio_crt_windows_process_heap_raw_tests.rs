//! Actual self-process observations; no deterministic value is assigned to malloc bytes.
use super::*;

fn initialized() -> (Heap, BTreeMap<u32,Memory>, BTreeSet<u32>) {
    let mut memory = BTreeMap::from([(0x14ae87c,Memory{reference:0x14ae87c,raw:vec![0;4]})]);
    let dead = BTreeSet::new();
    let mut heap = Heap::new(0x71000000,0x58000000).unwrap();
    assert_eq!(heap.initialize(&mut memory,&dead).unwrap(),1);
    (heap,memory,dead)
}

#[test]
fn raw_and_zero_modes_preserve_actual_self_process_bytes_and_owned_lifetimes() {
    let (mut heap,mut memory,mut dead)=initialized();
    let report=heap.report();
    for flags in [0,8] {
        for size in [0,1,8,140,956,8192] {
            let reference=heap.allocate(0x71000000,flags,size,&mut memory,&mut dead).unwrap();
            assert_ne!(reference,0);
            let pointer=heap.blocks[&reference].pointer.unwrap();
            let physical=observe_owned_bytes(pointer,size as usize).unwrap();
            assert_eq!(memory[&reference].raw,physical);
            assert_eq!(heap.physical_bytes(reference).unwrap(),physical);
            if flags==8 {assert_eq!(physical,vec![0;size as usize]);}
            memory.get_mut(&reference).unwrap().raw.iter_mut().enumerate().for_each(|(i,b)|*b=(i%251)as u8);
            heap.synchronize(reference,&memory).unwrap();
            assert_eq!(observe_owned_bytes(pointer,size as usize).unwrap(),memory[&reference].raw);
            heap.free(0x71000000,0,reference,&memory,&mut dead).unwrap();
        }
    }
    assert_eq!((report.allocations(),report.frees(),report.raw_snapshots()),(12,12,5));
    assert_eq!(heap.retire_mirrors(&mut memory,&mut dead).unwrap(),12);
    assert_eq!(memory.len(),1);
    assert!(report.failures().is_empty());
}

#[test]
fn failed_or_partial_snapshot_drops_the_real_owned_block_before_publication() {
    let host=unsafe{GetProcessHeap()}as usize;
    assert_ne!(host,0);
    let report=Arc::new(Report::default());
    let error=Block::new_observed(host,140,0,report.clone(),|pointer,size|{
        assert_ne!(pointer,0);assert_eq!(size,140);Err(Failure::Windows{operation:"injected snapshot failure",code:5})
    });
    assert!(matches!(error,Err(Failure::Windows{operation:"injected snapshot failure",code:5})));
    assert_eq!((report.allocations(),report.frees()),(1,1));
    let error=Block::new_observed(host,140,0,report.clone(),|_,_|Ok(vec![0;139]));
    assert!(matches!(error,Err(Failure::WrongSize)));
    assert_eq!((report.allocations(),report.frees(),report.raw_snapshots()),(2,2,0));
    let zero=Block::new_observed(host,140,8,report.clone(),|_,_|panic!("zero mode must not read a raw snapshot")).unwrap().unwrap();
    assert_eq!(zero.bytes(),vec![0;140]);drop(zero);
    assert_eq!((report.allocations(),report.frees(),report.raw_snapshots()),(3,3,0));
    assert!(report.failures().is_empty());
}

#[test]
fn unreadable_self_process_input_is_rejected_before_forming_any_Rust_slice() {
    unsafe{SetLastError(97)};
    assert!(matches!(observe_owned_bytes(0,4),Err(Failure::Windows{operation:"ReadProcessMemory",..})));
    assert_eq!(unsafe{GetLastError()},97);
    assert_eq!(observe_owned_bytes(0,0).unwrap(),Vec::<u8>::new());
}

#[test]
fn other_flags_and_wrong_heap_remain_refused_without_allocating_or_observing() {
    let (mut heap,mut memory,mut dead)=initialized();let report=heap.report();
    for flags in [1,4,9,u32::MAX] {
        assert_eq!(heap.allocate(0x71000000,flags,140,&mut memory,&mut dead),Err(Failure::UnsupportedFlags));
    }
    assert_eq!(heap.allocate(1,0,140,&mut memory,&mut dead),Err(Failure::InvalidReference));
    assert_eq!((report.allocations(),report.frees(),report.raw_snapshots()),(0,0,0));
    assert_eq!(memory.len(),1);
}
