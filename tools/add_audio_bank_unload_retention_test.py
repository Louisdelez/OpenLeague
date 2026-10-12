from pathlib import Path
p=Path('E:/OpenLeague/crates/core/src/audio_bank_memory_reader.rs');s=p.read_text(encoding='utf-8')
start=s.index('    #[test]fn audio_bank_deferred_unload_matches24_native_cache_effect_queue_frame_holder_callback_and_cleanup_sequences()')
end=s.index('    #[test]fn audio_bank_normal_worker_unload_matches48',start)
body=s[start:end]
head_end=body.index('        for(i,row)')
body='    fn replay_deferred_unload(proof:&Value,retention:bool){\n'+body[head_end:]
needle='set(&mut manager.raw,0x494+36,123);'
body=body.replace(needle,needle+'if retention{let r=*manager.banks.keys().next().unwrap();let bank=manager.banks.get_mut(&r).unwrap();set(&mut bank.memory.raw,64,row["holder_refs"].as_u64().unwrap()as u32);set(&mut bank.memory.raw,68,row["holder_total"].as_u64().unwrap()as u32);}')
body=body.replace('3=>{let mut context=', '3=>{if retention{if let Some(r)=manager.banks.keys().next().copied(){set(&mut manager.banks.get_mut(&r).unwrap().memory.raw,68,0);while manager.banks.contains_key(&r){manager.destroy_empty_holder(r,true,&mut native).unwrap();}}}let mut context=')
body+=r"""
    #[test]fn audio_bank_deferred_unload_matches24_native_cache_effect_queue_frame_holder_callback_and_cleanup_sequences(){let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_deferred_unload_contract.json")).unwrap();assert_eq!(proof["case_count"],24);replay_deferred_unload(&proof,false);}
    #[test]fn audio_bank_deferred_retention_matches24_native_owned_counters_and_callback_timing_cases(){let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bank_deferred_unload_retention_contract.json")).unwrap();assert_eq!(proof["case_count"],24);replay_deferred_unload(&proof,true);}
"""
s=s[:start]+body+s[end:];p.write_text(s,encoding='utf-8');print('Applied24 retained-owner replay;no fabricated native owner release claim')
