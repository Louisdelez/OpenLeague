use super::*;
fn c(value:&serde_json::Value)->CString {CString::new(value.as_str().unwrap()).unwrap()}
#[test] fn original_60_namespace_lookup_cases_match(){
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/namespace_lookup_contract.json")).unwrap();assert_eq!(proof["passed"],true);
 let table=Namespace::new(proof["entries"].as_array().unwrap().iter().map(|row|(c(&row[0]),c(&row[1]))).collect()).unwrap();
 assert_eq!(proof["cases"].as_array().unwrap().len(),60);
 for row in proof["cases"].as_array().unwrap(){let key=c(&row["requested"]);let parent=if row["parent"].is_null(){None}else{Some(c(&row["parent"]))};let result=table.lookup(&key,parent.as_deref());assert_eq!(result.value.to_bytes(),row["value"].as_str().unwrap().as_bytes());assert_eq!(format!("{:?}",result.origin).to_lowercase(),row["origin"].as_str().unwrap());}
}
#[test] fn original_38_namespace_insert_if_absent_cases_match(){
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/namespace_insert_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),38);let mut table=Namespace::empty();
 for row in proof["cases"].as_array().unwrap(){let key=c(&row["key"]);let value=c(&row["value"]);assert_eq!(table.register_if_absent(&key,&value),row["inserted"].as_bool().unwrap());assert_eq!(table.len(),row["entry_count"].as_u64().unwrap() as usize);assert_eq!(table.lookup(&key,None).value.to_bytes(),row["after"].as_str().unwrap().as_bytes());}
}
#[test] fn original_45_tga_over_dds_precedence_cases_match(){
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/tga_precedence_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),45);
 for row in proof["cases"].as_array().unwrap(){let key=c(&row["key"]);let mut table=if row["previous"].is_null(){Namespace::empty()}else{Namespace::new(vec![(key.clone(),c(&row["previous"]))]).unwrap()};table.register_tga(&key,&c(&row["incoming_tga"]));assert_eq!(table.len(),1);assert_eq!(table.lookup(&key,None).value.to_bytes(),row["result"].as_str().unwrap().as_bytes());}
}

#[test] fn original_scb_alias_and_physical_replacement_cases_match() {
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/scb_precedence_contract.json")).unwrap();
 assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),8);
 for row in proof["cases"].as_array().unwrap() {
  let mut entries=Vec::new();
  for (key,prior) in [("logical_key","previous"),("physical_key","physical_previous")] {
   if !row[prior].is_null() {entries.push((c(&row[key]),c(&row[prior])));}
  }
  let mut table=Namespace::new(entries).unwrap();table.register_scb(&CString::new("Saucer8").unwrap(),&c(&row["physical_key"]),&c(&row["result"]));
  assert_eq!(table.len(),2);
  for (key,result) in [("logical_key","result"),("physical_key","physical_result")] {assert_eq!(table.lookup(&c(&row[key]),None).value.to_bytes(),row[result].as_str().unwrap().as_bytes());}
 }
}
