from pathlib import Path
p=Path('E:/OpenLeague/crates/core/src/audio_common_queue.rs');s=p.read_text(encoding='utf-8');pos=s.rfind('\n}')
test=r"""
    #[test]fn audio_common_consumer_frames_match160_native_stop_wrap_and_waiting_cases(){
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_common_queue_consumer_frames_contract.json")).unwrap();assert_eq!(proof["case_count"],160);
        for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
            let mut services=Physical{pattern:row["pattern"].as_u64().unwrap()as u8,next:0x3000c000,nth:0,failure:0,original:row["page_size"]==2048,calls:vec![],allocations:vec![],freed:BTreeMap::new()};
            let mut context=Context{raw:bytes(row["before"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0,raw:vec![]},pages:BTreeMap::new(),page_size:row["page_size"].as_u64().unwrap()as u32};
            for(j,v)in row["initial_allocations"].as_array().unwrap().iter().enumerate(){let m=Memory{reference:v["reference"].as_u64().unwrap()as u32,raw:bytes(v["raw"].as_str().unwrap())};services.allocations.push((m.reference,m.raw.len()as u32));if j==0{context.table=m;}else{context.pages.insert(m.reference,m);}}
            let mut processed=row["processed_start"].as_u64().unwrap()as u32;assert_eq!(context.consume(&mut processed,&mut services).unwrap()as u64,row["result"].as_u64().unwrap(),"status {i}");
            assert_eq!(processed as u64,row["processed"].as_u64().unwrap(),"processed {i}");assert_eq!(hex(&context.raw),row["context"].as_str().unwrap(),"whole context {i}");assert_eq!(json!(services.calls),row["calls"],"physical order {i}");
            let allocations:Vec<Value>=services.allocations.iter().map(|&(r,s)|{let m=if context.table.reference==r{&context.table}else{context.pages.get(&r).unwrap()};json!({"reference":r,"size":s,"freed":false,"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),row["allocations"],"all storage {i}");
        }
    }
"""
assert 'fn audio_common_consumer_frames_match160'not in s;p.write_text(s[:pos]+test+s[pos:],encoding='utf-8')
