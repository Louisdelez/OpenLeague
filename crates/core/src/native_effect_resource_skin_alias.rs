//! Resource alias selection from native 7522B0. ASCII names and nonnegative skin IDs.
//! Package availability must be supplied by the resource backend; never assume existence.
#[derive(Debug, Clone, Copy)]
pub enum Owner { Absent, Other, Avatar { skin: u32 } }
#[derive(Debug, PartialEq, Eq)]
pub struct Resolution { pub name: String, pub source_package_selected: bool }
pub fn resolve(name: &str, enabled: bool, owner: Owner,
    mut package_contains: impl FnMut(&str) -> bool) -> Result<Resolution, &'static str> {
    if !name.is_ascii() || name.as_bytes().contains(&0) { return Err("unqualified resource name"); }
    let original = || Resolution { name: name.into(), source_package_selected: false };
    let skin = match owner { Owner::Avatar { skin } if enabled && skin != 0 => skin, _ => return Ok(original()) };
    if skin > i32::MAX as u32 { return Err("unqualified skin ID"); }
    let lower = name.to_ascii_lowercase();
    let (index, remove) = if let Some(i) = lower.find("_base") { (i, 5) }
        else if let Some(i) = lower.find(".troy") { (i, 0) }
        else { return Ok(original()); };
    let mut candidate = name.to_owned();
    candidate.replace_range(index..index + remove, &format!("_Skin{skin:02}"));
    Ok(if package_contains(&candidate) { Resolution { name: candidate, source_package_selected: true } }
        else { original() })
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches360_original_alias_executions() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/effect_resource_skin_alias_contract.json")).unwrap();
        let cases = p["cases"].as_array().unwrap(); assert_eq!(cases.len(), 360);
        for (n, c) in cases.iter().enumerate() {
            let owner = match c["owner_kind"].as_str().unwrap() {
                "absent" => Owner::Absent, "other" => Owner::Other,
                "avatar" => Owner::Avatar { skin: c["skin"].as_u64().unwrap() as u32 }, _ => panic!() };
            let mut queries = Vec::<String>::new();
            let actual = resolve(c["name"].as_str().unwrap(), c["enabled"].as_bool().unwrap(), owner,
                |candidate| { queries.push(candidate.into()); c["available"].as_bool().unwrap() }).unwrap();
            assert_eq!(actual.name, c["resolved_name"].as_str().unwrap(), "case {n} name");
            assert_eq!(actual.source_package_selected, c["source_package_selected"].as_bool().unwrap(), "case {n} package");
            assert_eq!(serde_json::json!(queries), c["queries"], "case {n} queries");
        }
    }
}
