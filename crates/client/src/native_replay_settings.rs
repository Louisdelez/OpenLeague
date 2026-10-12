//! Native text configuration conversions and baseline/overlay/user routing.
//! Binary INIBIN values and runtime cache reload are separate providers.
use crate::{native_game_cfg_text as text, native_graphics_options as integer};
use openleague_core::audio_game_service_lifecycle::Settings;

#[derive(Clone)]
pub struct Table { pub parsed: text::Parsed, pub text_enabled: bool }
#[derive(Clone)]
pub struct Pair { pub primary: Table, pub overlay: Option<Table> }
#[derive(Clone)]
pub struct Configuration { pub baseline: Pair, pub user: Pair }

impl Table {
    pub fn from_bytes(bytes: Option<&[u8]>) -> Result<Self, &'static str> {
        let file = text::load_text_files(bytes, None);
        if let Some(error) = file.parsed.error { return Err(error); }
        Ok(Self { parsed: file.parsed, text_enabled: file.loaded })
    }
    fn value(&self, section: &str, key: &str) -> Option<&[u8]> {
        self.parsed.value(section.as_bytes(), key.as_bytes())
    }
}
impl Configuration {
    pub fn from_files(baseline: Option<&[u8]>, user: Option<&[u8]>) -> Result<Self, &'static str> {
        Ok(Self { baseline: Pair { primary: Table::from_bytes(baseline)?, overlay: None },
            user: Pair { primary: Table::from_bytes(user)?, overlay: None } })
    }
    fn resolve<T: Copy>(&self, default: T, mut read: impl FnMut(&Table, T) -> Result<(T, bool), &'static str>) -> Result<T, &'static str> {
        let mut value = default;
        for pair in [&self.baseline, &self.user] {
            if let Some(overlay) = &pair.overlay {
                let (overlaid, found) = read(overlay, value)?;
                if found { value = overlaid; continue; }
            }
            value = read(&pair.primary, value)?.0;
        }
        Ok(value)
    }
}
fn cbytes(bytes: &[u8]) -> &[u8] {
    &bytes[..bytes.iter().position(|&b| b == 0).unwrap_or(bytes.len())]
}
/// Original C-locale atof accepts a decimal prefix. It does not parse Rust's
/// nan/inf literals or hexadecimal floats. Conversion rounds through f64 to f32.
fn decimal_float_bits(bytes: &[u8]) -> Result<u32, &'static str> {
    let bytes = cbytes(bytes);
    let mut cursor = 0;
    while bytes.get(cursor).is_some_and(|b| matches!(*b, 9..=13 | 32)) { cursor += 1; }
    let start = cursor;
    if bytes.get(cursor).is_some_and(|b| matches!(*b, b'+' | b'-')) { cursor += 1; }
    let mut digits = 0;
    while bytes.get(cursor).is_some_and(u8::is_ascii_digit) { cursor += 1; digits += 1; }
    if bytes.get(cursor) == Some(&b'.') {
        cursor += 1;
        while bytes.get(cursor).is_some_and(u8::is_ascii_digit) { cursor += 1; digits += 1; }
    }
    if digits == 0 { return Ok(0); }
    if bytes.get(cursor).is_some_and(|b| matches!(*b, b'e' | b'E')) {
        let exponent = cursor;
        cursor += 1;
        if bytes.get(cursor).is_some_and(|b| matches!(*b, b'+' | b'-')) { cursor += 1; }
        let first_digit = cursor;
        while bytes.get(cursor).is_some_and(u8::is_ascii_digit) { cursor += 1; }
        if cursor == first_digit { cursor = exponent; }
    }
    let decimal = std::str::from_utf8(&bytes[start..cursor]).map_err(|_| "invalid decimal prefix")?;
    let value = decimal.parse::<f64>().map_err(|_| "decimal conversion failed")?;
    Ok((value as f32).to_bits())
}
fn float_value(table: &Table, section: &str, key: &str, default: u32) -> Result<(u32, bool), &'static str> {
    if let Some(error) = table.parsed.error { return Err(error); }
    if !table.text_enabled { return Ok((default, false)); }
    match table.value(section, key) {
        Some(b"$##$") => Ok((default, true)),
        Some(value) => Ok((decimal_float_bits(value)?, true)),
        None => Ok((default, false)),
    }
}
fn bool_value(table: &Table, section: &str, key: &str, default: u8) -> Result<(u8, bool), &'static str> {
    if let Some(error) = table.parsed.error { return Err(error); }
    if !table.text_enabled { return Ok((default, false)); }
    let Some(value) = table.value(section, key) else { return Ok((u8::from(default != 0), false)); };
    let value = cbytes(value);
    let boolean = if value.eq_ignore_ascii_case(b"true") { true }
        else if value.eq_ignore_ascii_case(b"false") { false }
        else { integer::parse_integer_prefix(value).value != 0 };
    Ok((u8::from(boolean), true))
}
fn integer_value(table: &Table, section: &str, key: &str, default: u32) -> Result<(u32, bool), &'static str> {
    if let Some(error) = table.parsed.error { return Err(error); }
    let value = table.value(section, key).map(cbytes);
    let result = integer::read_integer_value(default as i32, integer::ValueSources {
        binary_enabled: false, typed_enabled: false, text_enabled: table.text_enabled, typed: None, text: value,
    }, |_| {});
    Ok((result.value as u32, result.found))
}
impl Settings for Configuration {
    fn float_bits(&mut self, section: &str, key: &str, default: u32) -> Result<u32, &'static str> {
        self.resolve(default, |table, value| float_value(table, section, key, value))
    }
    fn bool_value(&mut self, section: &str, key: &str, default: u8) -> Result<u8, &'static str> {
        self.resolve(default, |table, value| bool_value(table, section, key, value))
    }
    fn integer(&mut self, section: &str, key: &str, default: u32) -> Result<u32, &'static str> {
        self.resolve(default, |table, value| integer_value(table, section, key, value))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn bytes(v: &serde_json::Value) -> Option<Vec<u8>> {
        v.as_str().map(|s| (0..s.len()).step_by(2).map(|i| u8::from_str_radix(&s[i..i+2],16).unwrap()).collect())
    }
    fn table(value: &serde_json::Value, section: &str, key: &str) -> Table {
        Table { text_enabled: true, parsed: text::Parsed { entries: bytes(value).map(|value| vec![text::Entry {
            hash: text::key_hash(section.as_bytes(),key.as_bytes()), section: section.as_bytes().to_vec(),key: key.as_bytes().to_vec(),value,
        }]).unwrap_or_default(), warnings: 0, error: None } }
    }
    #[test]
    fn native_replay_text_float_bool_conversion_matches_original_readers() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/replay_config_values_contract.json")).unwrap();
        assert!(p["passed"].as_bool().unwrap());
        for c in p["cases"].as_array().unwrap() {
            let mut t = table(&c["text_hex"],"Replay","Probe");
            t.text_enabled = c["text_enabled"].as_bool().unwrap_or(true);
            let default = c["default"].as_u64().unwrap() as u32;
            let (value,found) = if c["kind"]=="float" {float_value(&t,"Replay","Probe",default).unwrap()}
                else {let (value,found)=bool_value(&t,"Replay","Probe",default as u8).unwrap();(u32::from(value),found)};
            assert_eq!(value,c["result"].as_u64().unwrap() as u32,"{c}");
            assert_eq!(found,c["found"].as_bool().unwrap(),"{c}");
        }
    }
    #[test]
    fn native_replay_configuration_layers_match_complete_original_getters() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/replay_config_values_contract.json")).unwrap();
        assert_eq!(p["layer_cases"].as_array().unwrap().len(),243);
        for c in p["layer_cases"].as_array().unwrap() {
            let section=c["section"].as_str().unwrap();let key=c["key"].as_str().unwrap();
            let overlay=|v:&serde_json::Value|if v=="absent" {None}else{Some(table(v,section,key))};
            let mut cfg=Configuration { baseline:Pair {primary:table(&c["baseline"],section,key),overlay:overlay(&c["baseline_overlay"])},
                user:Pair {primary:table(&c["user"],section,key),overlay:overlay(&c["user_overlay"])} };
            let default=c["default"].as_u64().unwrap() as u32;
            let result=match c["kind"].as_str().unwrap() {"float"=>cfg.float_bits(section,key,default).unwrap(),"bool"=>u32::from(cfg.bool_value(section,key,default as u8).unwrap()),"integer"=>cfg.integer(section,key,default).unwrap(),_=>panic!("unknown native getter")};
            assert_eq!(result,c["result"].as_u64().unwrap() as u32,"{c}");
        }
    }
}
