//! Legacy rectangle receiver selection (native 95B670 / 95B7F0).
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct Node {
    pub bounds: [f32; 6],
    pub first_object: usize,
    pub object_count: usize,
    pub first_child: usize,
    pub child_count: usize,
}
#[derive(Debug, Deserialize)]
pub struct Object {
    pub material_kind: i32,
    pub quality: i32,
}
#[derive(Debug, Deserialize)]
pub struct Receivers {
    pub nodes: Vec<Node>,
    pub objects: Vec<Object>,
}
impl Receivers {
    /// Returns native object indices in original traversal order.
    /// Caller supplies the active quality setting and native XZ rectangle.
    pub fn select(&self, rect: [f32; 4], quality: i32) -> Result<Vec<usize>, &'static str> {
        if !rect.iter().all(|v| v.is_finite()) || rect[0] > rect[2] || rect[1] > rect[3] {
            return Err("invalid projection rectangle");
        }
        let root = self.nodes.len().checked_sub(1).ok_or("missing receiver tree")?;
        let mut pending = vec![root];
        let mut visited = vec![false; self.nodes.len()];
        let mut selected = Vec::new();
        while let Some(index) = pending.pop() {
            let node = self.nodes.get(index).ok_or("invalid receiver child")?;
            if visited[index] { return Err("repeated receiver node"); }
            visited[index] = true;
            let mut union = 0u8;
            let mut common = 15u8;
            for x in [node.bounds[0], node.bounds[3]] {
                for z in [node.bounds[2], node.bounds[5]] {
                    let code = u8::from(x < rect[0]) | (u8::from(x > rect[2]) << 1)
                        | (u8::from(z > rect[3]) << 2) | (u8::from(z < rect[1]) << 3);
                    union |= code;
                    common &= code;
                }
            }
            if common != 0 { continue; }
            if union == 0 || node.child_count == 0 {
                let end = node.first_object.checked_add(node.object_count).ok_or("object range overflow")?;
                let objects = self.objects.get(node.first_object..end).ok_or("invalid receiver objects")?;
                for (offset, object) in objects.iter().enumerate() {
                    if matches!(object.material_kind, 0 | 2 | 3) && object.quality < quality {
                        selected.push(node.first_object + offset);
                    }
                }
            } else {
                let end = node.first_child.checked_add(node.child_count).ok_or("child range overflow")?;
                if end > self.nodes.len() { return Err("invalid receiver children"); }
                pending.extend((node.first_child..end).rev());
            }
        }
        Ok(selected)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn actual_map_tree_matches_native_195_cases() {
        let tree: Receivers = serde_json::from_str(include_str!("../../../data/4.20/map10_receiver_tree.json")).unwrap();
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/map10_receiver_tree_contract.json")).unwrap();
        let cases = proof["cases"].as_array().unwrap();
        assert_eq!(cases.len(), 195);
        for case in cases {
            let rect = std::array::from_fn(|i| case["rectangle"][i].as_f64().unwrap() as f32);
            let expected: Vec<usize> = serde_json::from_value(case["queued_meshes"].clone()).unwrap();
            assert_eq!(tree.select(rect, case["threshold"].as_i64().unwrap() as i32).unwrap(), expected);
        }
    }
}
