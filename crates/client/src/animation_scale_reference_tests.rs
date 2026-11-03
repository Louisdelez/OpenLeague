//! Actual production request/AssetServer calls; no GPU or historical startup claim.
use super::*;
use bevy::asset::{AssetApp, AssetPlugin};
use serde_json::{json, Value};

fn fixture() -> Value {
    serde_json::from_str(include_str!("animation_scale_reference_cases.json")).unwrap()
}
fn asset_app() -> App {
    let mut app = App::new();
    let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
    app.add_plugins((MinimalPlugins, AssetPlugin {
        file_path: root.join("assets").to_str().unwrap().into(), ..default()
    })).init_asset::<Gltf>();
    app
}
fn hex(value: f32) -> String {
    value.to_bits().to_le_bytes().iter().map(|x|format!("{x:02x}")).collect()
}
fn native_value(row: &Value) -> f32 {
    let s = row["native_float32_hex"].as_str().unwrap();
    let mut bytes = [0u8;4];
    for (i, value) in bytes.iter_mut().enumerate() {
        *value = u8::from_str_radix(&s[i*2..i*2+2],16).unwrap();
    }
    f32::from_bits(u32::from_le_bytes(bytes))
}

#[test]
fn all_122_base_requests_measure_real_returned_scale_bits_against_native_reference() {
    let document = fixture();
    let cases = document["cases"].as_array().unwrap();
    assert_eq!(cases.len(),122);
    let app = asset_app();
    let catalog = Catalog::default();
    let server = app.world().resource::<AssetServer>();
    let mut rows = Vec::new();
    let mut differences = Vec::new();
    for (i, row) in cases.iter().enumerate() {
        let name = row["current_manifest_key"].as_str().unwrap();
        assert!(catalog.0.get(name).is_some(),"missing actual catalog entry {name}");
        let (request, scale) = super::request(10_000+i as u32,name,&catalog,server);
        assert_eq!(request.id,10_000+i as u32);
        assert_eq!(request.name,name);
        assert!(scale.is_finite());
        let path = server.get_path(request.model.id()).expect("real AssetServer registered request path");
        let observed = hex(scale);
        let matches = observed==row["native_float32_hex"].as_str().unwrap();
        if !matches {differences.push(row["champion"].as_str().unwrap().to_owned());}
        rows.push(json!({"champion":row["champion"],"skin_id":row["skin_id"],"catalog_key":name,
            "catalog_scale":catalog.0[name]["scale"],"actual_request_float32_hex":observed,
            "native_float32_hex":row["native_float32_hex"],"matches_native_reference":matches,
            "actual_asset_path":path.path().to_string_lossy(),"request_id":request.id}));
    }
    let result=json!({"schema":"openleague_actual_rust_scale_request/v1","rows":rows,
        "actual_test_binary":std::env::current_exe().unwrap().to_string_lossy(),
        "different_champions":differences,"production_request_called":true,
        "production_catalog_default_called":true,"real_bevy_asset_server_used":true,
        "gltf_payload_load_awaited":false,"gpu_observed":false,"historical_runtime_executed":false});
    println!("OPENLEAGUE_SCALE_REQUEST_ROWS={result}");
    // This is an inventory of real differences, not a fidelity acceptance gate.
    // Unexpected changes fail while retaining the observations above.
    assert_eq!(result["different_champions"],document["expected_different_champions"]);
}

#[test]
fn exact_native_values_survive_the_same_consumer_in_an_explicit_catalog_copy_control() {
    let document=fixture();
    let cases=document["cases"].as_array().unwrap();
    let app=asset_app();
    let server=app.world().resource::<AssetServer>();
    let mut control=Catalog::default();
    let baseline=Catalog::default();
    let mut modified=Vec::new();
    for row in cases {
        let name=row["current_manifest_key"].as_str().unwrap();
        let native=native_value(row);
        if hex(baseline.0[name]["scale"].as_f64().unwrap() as f32)!=hex(native) {
            modified.push(row["champion"].clone());
        }
        // Only this in-memory test control changes; packaged manifests stay intact.
        control.0[name]["scale"]=json!(native as f64);
        let (request,actual)=super::request(20_000,name,&control,server);
        assert_eq!(hex(actual),row["native_float32_hex"].as_str().unwrap(),"{name}");
        let selected=server.get_path(request.model.id()).unwrap();
        let (original_request, _) = super::request(30_000,name,&baseline,server);
        let original_path = server.get_path(original_request.model.id()).unwrap();
        assert_eq!(selected.path(),original_path.path(),"scale-only control preserves selected path for {name}");
    }
    println!("OPENLEAGUE_SCALE_CONTROL={}",json!({"cases":cases.len(),"all_native_bits_preserved":true,
        "different_baseline_champions":modified,"scope":"explicit in-memory native-value control",
        "packaged_manifest_changed":false,"ordinary_rendering_or_historical_mounting_qualified":false}));
    assert_eq!(modified,document["expected_different_champions"].as_array().unwrap().to_vec());
}
