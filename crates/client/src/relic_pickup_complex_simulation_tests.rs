use crate::relic_pickup_seven_host::{Owner,Sources as _};
use crate::relic_pickup_complex_sources as source;
use crate::relic_pickup_complex_simulation as simulation;
use openleague_core::{native_random::Rng55,native_complex_particle_storage::GlobalVectors};
use serde_json::Value;
fn word(v:&Value)->u32{v.as_u64().unwrap() as u32}
fn words<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|i|word(&v[i]))}
fn vector<const N:usize>(v:&Value)->[f32;N]{std::array::from_fn(|i|v[i].as_f64().unwrap() as f32)}
fn fingerprint(r:&Rng55)->(u32,u32,[u32;55]){(r.first,r.second,r.words)}
fn native_rng(v:&Value)->(u32,u32,[u32;55]){(word(&v["first"]),word(&v["second"]),words(&v["words"]))}
fn owner(v:&Value)->Owner{Owner {root_token:10,model_token:20,matrix:vector::<16>(&v["matrix"]).map(f32::to_bits),position:vector::<3>(&v["position"]).map(f32::to_bits)}}
fn policy()->source::LocalPolicy{source::LocalPolicy {life_owner_scale:1.,actor_rate_scale:1.,scale_owner:1.,owner_flags:0,
    owner_extra:[0.;3],motion_scratch:[0;3],globals:GlobalVectors {unit:[0;3],scale:[1f32.to_bits();3],anchor:[0;3]}}}
#[test]
fn original_whole_frames_match_selected_owner_lifecycle_rng_and_all_buffers(){
    let native:Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/pickup_complex_numeric_factory_contract.json")).unwrap();
    let corpus:Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/pickup_complex_whole_frame_contract.json")).unwrap();assert_eq!(corpus["passed"],true);
    assert_eq!(corpus["sequences"].as_array().unwrap().len(),12);
    let mut failures=Vec::new();let mut frames=0;let mut records=0;
    for sequence in corpus["sequences"].as_array().unwrap(){
        let group=crate::relic_pickup_complex_profiles::GROUPS.iter().position(|s|*s==sequence["group"].as_str().unwrap()).unwrap();
        let source=source::Sources::new(&native,[sequence["provider_capability"].as_bool().unwrap();3],policy()).unwrap();
        let mut rng=Rng55::seeded(42);let initial=owner(&sequence["initial_owner"]);let mut created=source.create(group,initial,0.,&mut rng).unwrap();
        assert_eq!(fingerprint(&rng),native_rng(&sequence["initial_rng"]));
        let profile=crate::relic_pickup_complex_profiles::Profile::load(group).unwrap();let mut host=simulation::Host::new(0.,initial.position.map(f32::from_bits));
        for row in sequence["frames"].as_array().unwrap(){
            let ordinal=word(&row["ordinal"]) as u64;let time=f32::from_bits(word(&row["time_word"]));
            let previous=owner(&row["previous_owner"]);let current=owner(&row["current_owner"]);
            if fingerprint(&rng)!=native_rng(&row["rng_before"]){failures.push(serde_json::json!({"group":profile.group,"tag":sequence["tag"],"frame":ordinal,"rng_before":true}));}
            let frame=source.frame(group,&mut created.context,created.instance,previous,current,time,&mut rng).unwrap();created.instance=frame.instance;
            let planned=host.planned_frame(ordinal,&profile,time,current.position.map(f32::from_bits),frame.instance,frame.particles,&rng,
                |sample,ordinal,rng|source.prepare_birth(group,&mut created.context,created.instance,current,sample,ordinal,rng)).unwrap().unwrap();
            host=planned.0;rng=planned.1;
            let native_count=word(&row["live_count"]) as usize;
            if host.storage.particles.len()!=native_count {failures.push(serde_json::json!({"group":profile.group,"tag":sequence["tag"],"frame":ordinal,"count_native":native_count,"count_rust":host.storage.particles.len()}));}
            for (index,record) in host.storage.particles.iter().take(native_count).enumerate(){
                for offset in [4,0x10,0x1c,0x28,0x34,0x40,0x4c,0x58,0x64,0x70,0x7c,0x88]{
                    let actual=record.native_words(offset).unwrap();let expected=row["particles"][index][format!("0x{offset:x}")].as_array().unwrap().iter().map(word).collect::<Vec<_>>();
                    let differences=actual.iter().zip(&expected).enumerate().filter(|(_, (a,b))|a!=b).map(|(i,(a,b))|serde_json::json!({"word":i,"native":b,"rust":a})).collect::<Vec<_>>();
                    if !differences.is_empty(){failures.push(serde_json::json!({"group":profile.group,"tag":sequence["tag"],"frame":ordinal,"index":index,"buffer":offset,"differences":differences}));}
                }
                records+=1;
            }
            if fingerprint(&rng)!=native_rng(&row["rng_after"]){failures.push(serde_json::json!({"group":profile.group,"tag":sequence["tag"],"frame":ordinal,"rng_after":true}));}
            for (actual,key) in [(host.last_update.to_bits(),"0x80"),(host.last_birth.to_bits(),"0x78"),(host.distance_anchor.to_bits(),"0x108"),(host.emitted as u32,"0x118")]{
                let expected=word(&row["instance_fields"][key]);if actual!=expected{failures.push(serde_json::json!({"group":profile.group,"tag":sequence["tag"],"frame":ordinal,"instance_field":key,"native":expected,"rust":actual}));}
            }
            if host.frame.last_time.to_bits()!=word(&row["storage_last_time"]) || host.frame.initialized_particles!=word(&row["storage_initialized"]){
                failures.push(serde_json::json!({"group":profile.group,"tag":sequence["tag"],"frame":ordinal,"dispatcher_state":true}));
            }
            frames+=1;
        }
        assert!(host.storage.particles.is_empty());
    }
    println!("{}",serde_json::json!({"frames":frames,"records":records,"failure_count":failures.len(),"failures":failures,"gpu_qualified":false,"historical_trigger_qualified":false}));
    assert_eq!((frames,records),(120,336));
    assert!(failures.is_empty(),"native whole-frame differences: {failures:?}");
}
