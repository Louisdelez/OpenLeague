//! Native bank-v88 curve arithmetic, qualified against emulated 4.20 machine code.
//! This module supplies controls; voice routing and spatial listener rules are separate.
use serde::Deserialize;
#[derive(Debug, Clone, Deserialize)]
pub struct Point {
    pub from: f32,
    pub to: f32,
    pub interp: u32,
}
#[derive(Debug, Clone, Deserialize)]
pub struct Curve {
    pub scaling: u32,
    pub points: Vec<Point>,
}
#[derive(Debug, PartialEq)]
pub enum Error {
    Empty,
    InvalidPoint,
    InvalidInput,
    UnsupportedScaling(u32),
    UnsupportedInterpolation(u32),
}
impl Curve {
    pub fn validate(&self) -> Result<(), Error> {
        if self.points.is_empty() {
            return Err(Error::Empty);
        }
        if !matches!(self.scaling, 0 | 2) {
            return Err(Error::UnsupportedScaling(self.scaling));
        }
        let mut previous = None;
        for p in &self.points {
            if !p.from.is_finite() || !p.to.is_finite() || previous.is_some_and(|v| v >= p.from) {
                return Err(Error::InvalidPoint);
            }
            if !matches!(p.interp, 0 | 4 | 9) {
                return Err(Error::UnsupportedInterpolation(p.interp));
            }
            previous = Some(p.from);
        }
        Ok(())
    }
    /// Returns raw values (scaling 0) or the original approximate dB result (scaling 2).
    pub fn evaluate(&self, x: f32) -> Result<f32, Error> {
        self.validate()?;
        let raw = self.interpolate(x)?;
        Ok(if self.scaling == 2 {
            normalized_db(raw)
        } else {
            raw
        })
    }
    /// Native bus optimization at 0xb148b0 adds one to each control point before
    /// interpolation, then changes scaling 2 to 0. The result is an amplitude gain.
    /// Keeping this order preserves original float rounding at curve boundaries.
    pub fn bus_gain(&self, x: f32) -> Result<f32, Error> {
        self.validate()?;
        if self.scaling != 2 {
            return Err(Error::UnsupportedScaling(self.scaling));
        }
        let curve = Curve {
            scaling: 0,
            points: self
                .points
                .iter()
                .map(|p| Point {
                    from: p.from,
                    to: p.to + 1.0,
                    interp: p.interp,
                })
                .collect(),
        };
        curve.evaluate(x)
    }
    fn interpolate(&self, x: f32) -> Result<f32, Error> {
        if !x.is_finite() {
            return Err(Error::InvalidInput);
        }
        for (i, p) in self.points.iter().enumerate() {
            if p.from >= x || i + 1 == self.points.len() {
                return Ok(p.to);
            }
            let next = &self.points[i + 1];
            if next.from > x {
                let t = (x - p.from) / (next.from - p.from);
                let value = match p.interp {
                    4 => (next.to - p.to) * t + p.to,
                    9 => p.to,
                    // Original Log3 uses x87 intermediates after the SSE float ratio.
                    0 => {
                        let r = 1.0 - t as f64;
                        (r * r * r * (p.to as f64 - next.to as f64) + next.to as f64) as f32
                    }
                    _ => return Err(Error::UnsupportedInterpolation(p.interp)),
                };
                return if value.is_finite() {
                    Ok(value)
                } else {
                    Err(Error::InvalidPoint)
                };
            }
        }
        Err(Error::Empty)
    }
}
/// The original scaling-2 branch uses a mantissa polynomial for log and normalized
/// +/-1 endpoints mapped to +/-4096 dB. These sentinels differ from authoring limits.
fn normalized_db(v: f32) -> f32 {
    if v <= -1.0 {
        return -4096.0;
    }
    if v >= 1.0 {
        return 4096.0;
    }
    let (a, sign) = if v < 0.0 {
        (v + 1.0, 1.0)
    } else {
        (1.0 - v, -1.0)
    };
    let bits = a.to_bits();
    let mantissa = f32::from_bits((bits & 0x7fffff) + 0x3f800000) as f64;
    let exponent = ((bits >> 23) & 0xff) as f64 - 127.0;
    let z = (mantissa - 1.0) / (mantissa + 1.0);
    let natural = 2.0 * z * (1.0 + z * z * (f32::from_bits(0x3eaaaaab) as f64))
        + exponent * (f32::from_bits(0x3f317218) as f64);
    (natural * (f32::from_bits(0x3ede5bd9) as f64) * sign * 20.0) as f32
}
#[cfg(test)]
mod tests {
    use super::*;
    fn curve(scaling: u32, points: &[(f32, f32, u32)]) -> Curve {
        Curve {
            scaling,
            points: points
                .iter()
                .map(|(from, to, interp)| Point {
                    from: *from,
                    to: *to,
                    interp: *interp,
                })
                .collect(),
        }
    }
    #[test]
    fn original_x86_emulation_matches_all_native_curves_and_boundaries() {
        #[derive(Deserialize)]
        struct Named {
            id: String,
            #[serde(flatten)]
            curve: Curve,
        }
        #[derive(Deserialize)]
        struct Sample {
            curve: String,
            input: f32,
            native_output: f32,
            bus_gain: bool,
        }
        #[derive(Deserialize)]
        struct Fixture {
            curves: Vec<Named>,
            cases: Vec<Sample>,
        }
        let fixture: Fixture =
            serde_json::from_str(include_str!("../../../data/4.20/audio_curve_contract.json"))
                .unwrap();
        assert_eq!(fixture.cases.len(), 223);
        for s in fixture.cases {
            let c = &fixture
                .curves
                .iter()
                .find(|c| c.id == s.curve)
                .unwrap()
                .curve;
            let actual = if s.bus_gain {
                c.bus_gain(s.input)
            } else {
                c.evaluate(s.input)
            }
            .unwrap();
            assert!(
                (actual - s.native_output).abs() <= 0.00001,
                "{} input {}: Rust {} native {}",
                s.curve,
                s.input,
                actual,
                s.native_output
            );
        }
    }
    #[test]
    fn normalized_volume_is_not_a_db_offset() {
        let c = curve(2, &[(0.0, -1.0, 4), (100.0, 0.0, 4)]);
        assert_eq!(c.evaluate(0.0), Ok(-4096.0));
        assert!((c.evaluate(50.0).unwrap() + 6.0205998).abs() < 0.000001);
        assert_eq!(c.bus_gain(0.0), Ok(0.0));
        assert_eq!(c.bus_gain(50.0), Ok(0.5));
        assert_eq!(c.bus_gain(100.0), Ok(1.0));
    }
    #[test]
    fn constant_segment_clamps_and_exact_next_point_is_inclusive() {
        let c = curve(0, &[(0.0, 8.0, 9), (5.0, 3.0, 4), (10.0, 1.0, 4)]);
        assert_eq!(c.evaluate(-1.0), Ok(8.0));
        assert_eq!(c.evaluate(4.999), Ok(8.0));
        assert_eq!(c.evaluate(5.0), Ok(3.0));
        assert_eq!(c.evaluate(20.0), Ok(1.0));
    }
    #[test]
    fn log3_native_midpoint_uses_cubic_remainder() {
        let c = curve(0, &[(0.0, 0.0, 0), (1.0, -1.0, 4)]);
        assert_eq!(c.evaluate(0.5), Ok(-0.875));
    }
    #[test]
    fn unsupported_or_invalid_curves_fail_explicitly() {
        assert_eq!(
            curve(1, &[(0.0, 0.0, 4)]).evaluate(0.0),
            Err(Error::UnsupportedScaling(1))
        );
        assert_eq!(
            curve(0, &[(0.0, 0.0, 1)]).evaluate(0.0),
            Err(Error::UnsupportedInterpolation(1))
        );
        assert_eq!(
            curve(0, &[(0.0, 0.0, 4), (0.0, 1.0, 4)]).evaluate(0.0),
            Err(Error::InvalidPoint)
        );
        assert_eq!(
            curve(0, &[(0.0, 0.0, 4)]).evaluate(f32::NAN),
            Err(Error::InvalidInput)
        );
        assert_eq!(curve(0, &[]).evaluate(0.0), Err(Error::Empty));
    }
}
