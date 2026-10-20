use super::*;

#[test]
fn three_base_groups_preserve_all334_fields_and_absence_is_not_zero() {
    let p=Profile::load().unwrap();assert!(!p.renderer_ready());
    assert_eq!(p.groups.map(|g|(g.slot,g.name,g.declared_type,g.fields.len())),
        [(1,"missile1",None,50),(3,"magicdust",Some("Simple"),36),(4,"dust",Some("Simple"),31)]);
    let p=Profile::load().unwrap();assert_eq!(p.unresolved_keys.len(),62);assert_eq!(decode(ORIGINAL).unwrap().len(),334);
    let missile=&p.groups[0].fields;assert!(!missile.contains_key("e-life"));assert!(!missile.contains_key("p-linger"));
    assert!(!missile.contains_key("p-trailmode"));assert_eq!(missile["e-linger"],"0");
    assert_eq!(missile["p-scaleXP3"],json!([0.5009999871253967,-1.]));
    assert_eq!(missile["p-bindtoemitter"],0.25);assert_eq!(missile["p-texdiv"],json!([3.,3.]));
    assert_eq!(p.groups[1].fields["p-lifeP3"],json!([1.,4.]));
    assert!(!p.groups[1].fields.contains_key("rendermode"));
    assert_eq!(p.groups[2].fields["p-type"],true);assert_eq!(p.groups[2].fields["p-simpleorient"],2);
}
#[test]
fn authored_field_or_binary_corruption_cannot_silently_become_a_default() {
    let original:Value=serde_json::from_str(SOURCE).unwrap();
    for mode in 0..7 {
        let mut doc=original.clone();let mut raw=ORIGINAL.to_vec();
        match mode {0=>doc["raw_fields"][0]["value"]=json!(100),
            1=>{doc["raw_fields"].as_array_mut().unwrap().pop();},
            2=>raw[77]=7,3=>raw[3]=0,4=>{raw.pop();},
            5=>{doc["groups"][0]["fields"].as_object_mut().unwrap().remove("p-bindtoemitter");},
            _=>doc["raw_fields"][0]["key_offset"]=json!(0)}
        assert!(Profile::parse(&doc.to_string(),&raw).is_err(),"mode{mode}");
    }
}
#[test]
fn wrong_group_variant_resource_alias_or_unknown_inventory_is_rejected() {
    let original:Value=serde_json::from_str(SOURCE).unwrap();
    for mode in 0..7 {
        let mut d=original.clone();match mode {
            0=>d["groups"][0]["name"]=json!("core_pulsefire"),
            1=>d["groups"][0]["declared_type"]=json!("Simple"),
            2=>d["groups"][0]["fields"]["p-life"]=json!(1),
            3=>d["resources"][0]["source_name"]=json!("glows.tga"),
            4=>{d["unresolved_keys"].as_array_mut().unwrap().pop();},
            5=>d["renderer_ready"]=json!(true),_=>d["source"]["sha256"]=json!("different")}
        assert!(Profile::parse(&d.to_string(),ORIGINAL).is_err(),"mode{mode}");
    }
    let p=Profile::load().unwrap();assert_eq!(p.resources.len(),5);
    assert_eq!(p.resources[0]["dds"]["levels"].as_array().unwrap().len(),10);
    assert_eq!(p.resources[3]["dds"]["height"],384);
}
