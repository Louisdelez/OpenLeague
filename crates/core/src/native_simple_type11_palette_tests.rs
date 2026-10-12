use super::*;
use serde_json::Value;
fn contract()->Value {serde_json::from_str(include_str!("../../../data/4.20/garen_type11_palette_contract.json")).unwrap()}
fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|w|u32::from_str_radix(w.as_str().unwrap(),16).unwrap()).collect()}
fn joints(v:&Value)->Vec<Joint>{words(v).chunks_exact(10).map(|w|Transform(w.try_into().unwrap()).to_joint()).collect()}

#[test]
fn type11_garen_palette_matches48_original_hierarchy_and_inverse_bind_lifetimes_bit_exactly(){
    let p=contract();assert_eq!(p["passed"],true);assert_eq!(p["joint_count"],68);
    assert_eq!(p["samples"].as_array().unwrap().len(),8);assert!(p["primitive_adapters"].as_array().unwrap().is_empty());
    let parents:Vec<i16>=p["parents"].as_array().unwrap().iter().map(|v|v.as_i64().unwrap() as i16).collect();
    let inverse=joints(&p["inverse_bind_words"]);let inverse_before=inverse.clone();
    let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),48);
    for (index,row) in cases.iter().enumerate(){
        let local=joints(&row["local_words"]);let before=local.clone();
        let owner=Transform(words(&row["owner_words"]).try_into().unwrap());
        let palette=build_palette(&local,&parents,&inverse,owner).unwrap();
        assert_eq!(palette,joints(&row["palette_words"]),"native palette case{index}: {} / {}",row["sample"],row["owner_profile"]);
        assert_eq!(local,before);assert_eq!(inverse,inverse_before);
    }
}

#[test]
fn type11_garen_native_compose_matches_all68_intermediate_global_trs_before_inverse_bind(){
    let p=contract();let parents:Vec<i16>=p["parents"].as_array().unwrap().iter().map(|v|v.as_i64().unwrap() as i16).collect();
    //This real Garen rig orders parents before children. The general builder's
    //out-of-order/cycle handling is tested separately with diagnostic data.
    assert!(parents.iter().enumerate().all(|(i,&parent)|parent<0 || (parent as usize)<i));
    let mut comparisons=0;
    for row in p["cases"].as_array().unwrap(){
        let local=joints(&row["local_words"]);let expected=joints(&row["world_words"]);
        let owner=Transform(words(&row["owner_words"]).try_into().unwrap());let mut globals:Vec<Transform>=Vec::new();
        for i in 0..68{
            let parent=if parents[i]<0 {owner}else{globals[parents[i] as usize]};
            let global=compose(Transform::from_joint(&local[i]),parent).unwrap();
            assert_eq!(global.to_joint(),expected[i],"native worldjoint{i}: {} / {}",row["sample"],row["owner_profile"]);
            globals.push(global);comparisons+=1;
        }
    }
    assert_eq!(comparisons,48*68);
}
