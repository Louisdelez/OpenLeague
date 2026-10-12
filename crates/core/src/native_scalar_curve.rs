//! Scalar knot interpolation (94EC10) and baking (94D080), not runtime table lookup.
#[derive(Clone, Debug)]
pub struct ScalarKnots {
    times: Vec<f32>,
    values: Vec<f32>,
}

#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Empty,
    LengthMismatch,
    NonFinite,
    Unsorted,
    FieldLimit,
}

/// 94CB60 field control flow after the raw getter/CRT numeric conversion.
/// This API deliberately takes decoded numeric fields: it does not claim native
/// string lexical conversion or INIBIN cache parity. Unsupported data is explicit.
pub fn read_scalar_fields(
    key: &str,
    default: f32,
    mut lookup: impl FnMut(&str) -> Option<Vec<f32>>,
) -> Result<Option<ScalarKnots>, Error> {
    if !default.is_finite() { return Err(Error::NonFinite); }
    let authored = lookup(key);
    let mut base = default;
    if let Some(numbers) = &authored {
        let Some(first) = numbers.first() else { return Ok(None); };
        base = *first;
        if key == "e-rgba" { base *= f32::from_bits(0x3b808081); }
    }
    if !base.is_finite() { return Err(Error::NonFinite); }
    let mut times = Vec::new();
    let mut values = Vec::new();
    for index in 1..=4096 {
        let field = lookup(&format!("{key}{index}"));
        let Some(numbers) = field.filter(|numbers| numbers.len() >= 2) else {
            if times.is_empty() {
                if authored.is_none() { return Ok(None); }
                times.push(0.);
                values.push(base);
            }
            return ScalarKnots::new(times, values).map(Some);
        };
        times.push(numbers[0]);
        // Native mulss scales each numbered value by the base/default.
        values.push(numbers[1] * base);
    }
    Err(Error::FieldLimit)
}

impl ScalarKnots {
    pub fn maximum(&self) -> f32 {
        self.values.iter().copied().fold(f32::MIN, f32::max)
    }
    pub fn new(times: Vec<f32>, values: Vec<f32>) -> Result<Self, Error> {
        if times.is_empty() { return Err(Error::Empty); }
        if times.len() != values.len() { return Err(Error::LengthMismatch); }
        if times.iter().chain(values.iter()).any(|v| !v.is_finite()) { return Err(Error::NonFinite); }
        if times.windows(2).any(|p| p[0] > p[1]) { return Err(Error::Unsorted); }
        Ok(Self { times, values })
    }

    pub fn sample_knots(&self, time: f32) -> f32 {
        // Native lower_bound takes the first key >= time, including duplicate keys.
        let upper = self.times.partition_point(|key| *key < time);
        if upper == 0 { return self.values[0]; }
        if upper == self.times.len() { return *self.values.last().unwrap(); }
        let lower = upper - 1;
        // Original scalar interpolation retains x87 intermediates before the f32
        // store. f64 reproduces the captured finite cases; exhaustive x87 parity
        // across all possible IEEE inputs is not claimed.
        let t0 = self.times[lower] as f64;
        let v0 = self.values[lower] as f64;
        let weight = (time as f64 - t0) / (self.times[upper] as f64 - t0);
        (v0 + weight * (self.values[upper] as f64 - v0)) as f32
    }

    pub fn bake(&self, requested_count: u32) -> Vec<f32> {
        let count = if self.times.len() == 1 { 1 } else { requested_count };
        if count == 0 { return Vec::new(); }
        let reciprocal = 1.0f32 / count as f32;
        (0..count).map(|index| self.sample_knots(index as f32 * reciprocal)).collect()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn contract() -> serde_json::Value {
        serde_json::from_str(include_str!("../../../data/4.20/scalar_curve_bake_contract.json")).unwrap()
    }
    fn floats(row: &serde_json::Value, key: &str) -> Vec<f32> {
        row[key].as_array().unwrap().iter().map(|v| v.as_f64().unwrap() as f32).collect()
    }
    fn bits(value: &serde_json::Value) -> u32 {
        u32::from_str_radix(value.as_str().unwrap().trim_start_matches("0x"), 16).unwrap()
    }
    #[test]
    fn scalar_sampling_matches_original_x87_stores() {
        let data = contract();
        for row in data["samples"].as_array().unwrap() {
            let curve = ScalarKnots::new(floats(row,"times"), floats(row,"values")).unwrap();
            assert_eq!(curve.sample_knots(row["time"].as_f64().unwrap() as f32).to_bits(), bits(&row["output_f32_bits"]), "{row}");
        }
    }
    #[test]
    fn table_baking_matches_original_output_bits() {
        let data = contract();
        let extra: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/scalar_curve_extra_counts_contract.json")).unwrap();
        for row in data["cases"].as_array().unwrap().iter().chain(extra["cases"].as_array().unwrap().iter()) {
            let curve = ScalarKnots::new(floats(row,"times"), floats(row,"values")).unwrap();
            let actual = curve.bake(row["requested_count"].as_u64().unwrap() as u32);
            assert_eq!(actual.len(), row["actual_count"].as_u64().unwrap() as usize);
            let expected = row["output_f32_bits"].as_array().unwrap();
            for (index,value) in actual.iter().enumerate() {
                assert_eq!(value.to_bits(), bits(&expected[index]), "{} count{} index{}",row["name"],row["requested_count"],index);
            }
        }
    }
    #[test]
    fn parsed_field_control_flow_matches_original_reader_and_map_groups() {
        let data: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/scalar_field_reader_contract.json")).unwrap();
        for row in data["cases"].as_array().unwrap() {
            let actual = read_scalar_fields(row["key"].as_str().unwrap(), row["default"].as_f64().unwrap() as f32, |key| {
                row["fields"][key].as_str().filter(|s| !s.is_empty()).map(|s| {
                    s.split_whitespace().map(|v| v.parse::<f32>().unwrap()).collect()
                })
            }).unwrap();
            assert_eq!(actual.is_some(), row["returned"].as_bool().unwrap(), "{}", row["name"]);
            if let Some(curve) = actual {
                assert_eq!(curve.times.iter().map(|v|v.to_bits()).collect::<Vec<_>>(), floats(row,"times").iter().map(|v|v.to_bits()).collect::<Vec<_>>(), "{} times",row["name"]);
                assert_eq!(curve.values.iter().map(|v|v.to_bits()).collect::<Vec<_>>(), floats(row,"values").iter().map(|v|v.to_bits()).collect::<Vec<_>>(), "{} values",row["name"]);
            }
        }
    }
}
