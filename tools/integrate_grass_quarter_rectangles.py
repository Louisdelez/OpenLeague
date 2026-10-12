from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_rectangle.rs';s=p.read_text(encoding='utf-8')
assert 'pub fn quarter_rectangle' not in s
s=s.replace('#[cfg(test)] mod tests {','''/// Original95BA70 retains even the invalid sentinel, duplicates and inverted bounds.
pub fn quarter_rectangle(rectangle: Rectangle) -> Rectangle {
    Rectangle(rectangle.0.map(|coordinate| truncate_screen(coordinate as f32 * 0.25)))
}

#[cfg(test)] mod tests {''')
s=s.replace('    #[test] fn cvtt_indefinite', '''    #[test] fn quarter_scaling_matches_all_native_ordered_lists_without_filtering() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/grass_quarter_rectangles_contract.json")).unwrap();
        assert_eq!(proof["passed"], true);
        let cases = proof["cases"].as_array().unwrap(); assert_eq!(cases.len(), 63);
        for c in cases {
            let actual: Vec<_> = c["input_rectangles"].as_array().unwrap().iter().map(|row| {
                quarter_rectangle(Rectangle(std::array::from_fn(|i| row[i].as_i64().unwrap() as i32))).0
            }).collect();
            let expected: Vec<[i32; 4]> = c["quarter_rectangles"].as_array().unwrap().iter().map(|row| std::array::from_fn(|i| row[i].as_i64().unwrap() as i32)).collect();
            assert_eq!(actual, expected);
        }
        assert_eq!(quarter_rectangle(Rectangle([-1, -1, 0, 0])), Rectangle([0, 0, 0, 0]));
    }
    #[test] fn cvtt_indefinite''')
p.write_text(s,encoding='utf-8');print('Installed native quarter-resolution rectangle scaling.')
