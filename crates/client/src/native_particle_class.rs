//! Original 8B0630/8B01C0 default and 9190F3 class selection.
use serde_json::Value;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum EmitterClass {
    Simple,
    Complex,
}

impl EmitterClass {
    pub fn from_type_text(authored: Option<&str>) -> Self {
        // Original caller supplies "Complex" for a missing field. Empty strings
        // remain empty. The selector compares exactly six case-sensitive bytes.
        match authored.unwrap_or("Complex") {
            "Simple" => Self::Simple,
            _ => Self::Complex,
        }
    }

    pub fn from_system(system: &Value, slot: usize) -> Result<Self, String> {
        let field = format!("GroupPart{slot}Type");
        match system.get(&field) {
            None => Ok(Self::from_type_text(None)),
            Some(Value::String(text)) => Ok(Self::from_type_text(Some(text))),
            Some(_) => Err(format!("native {field}: non-string type conversion is unqualified")),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn reader_and_selector_match_original_instruction_cases() {
        let selection: Value = serde_json::from_str(include_str!("../../../data/4.20/map_particle_type_selection_contract.json")).unwrap();
        let reader: Value = serde_json::from_str(include_str!("../../../data/4.20/map_particle_type_reader_contract.json")).unwrap();
        for row in selection["cases"].as_array().unwrap() {
            let expected = match row["selection"].as_str().unwrap() {
                "Simple" => EmitterClass::Simple,
                "Complex" => EmitterClass::Complex,
                _ => panic!("unqualified captured class"),
            };
            assert_eq!(EmitterClass::from_type_text(row["input"].as_str()), expected);
        }
        for row in reader["cases"].as_array().unwrap() {
            let captured_output = row["output"].as_str().unwrap();
            let captured_selection = selection["cases"].as_array().unwrap().iter().find(|v| v["input"].as_str() == Some(captured_output)).unwrap();
            let expected = if captured_selection["selection"] == "Simple" { EmitterClass::Simple } else { EmitterClass::Complex };
            assert_eq!(EmitterClass::from_type_text(row["authored"].as_str()), expected);
        }
    }

    #[test]
    fn map_groups_use_native_class_bindings_without_enabling_orphans() {
        let bindings: Value = serde_json::from_str(include_str!("../../../data/4.20/map_particle_class_bindings.json")).unwrap();
        let catalog: Value = serde_json::from_str(include_str!("../../../data/4.20/map10_particle_catalog.json")).unwrap();
        let mut checked = 0;
        for definition in catalog["definitions"].as_array().unwrap() {
            for group in definition["groups"].as_array().unwrap() {
                let row = bindings["groups"].as_array().unwrap().iter().find(|row| row["reference"] == definition["reference"] && row["slot"] == group["slot"]).unwrap();
                let mut system = serde_json::Map::new();
                if !group["declared_type"].is_null() {
                    system.insert(format!("GroupPart{}Type", group["slot"].as_u64().unwrap()), group["declared_type"].clone());
                }
                let actual = EmitterClass::from_system(&Value::Object(system), group["slot"].as_u64().unwrap() as usize).unwrap();
                let expected = if row["class"] == "Simple" { EmitterClass::Simple } else { EmitterClass::Complex };
                assert_eq!(actual, expected);
                checked += 1;
            }
        }
        assert_eq!(checked, 52);
        assert_eq!(bindings["groups"].as_array().unwrap().len(), checked);
        assert!(EmitterClass::from_system(&serde_json::json!({"GroupPart1Type": 1}), 1).is_err());
    }
}
