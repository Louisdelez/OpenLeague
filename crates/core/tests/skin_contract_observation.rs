//! Observe current local protocol boundaries, not historical skin support.
use openleague_core::{ClientPacket,session_transport::{JoinRequest,RequestNonce,Secret32,VERSION}};
#[test]
fn authenticated_join_refuses_unimplemented_skin_field() {
    let request=JoinRequest{version:VERSION,champion:"garen".into(),summoners:[None,None],recovery_key:Secret32::from_bytes([1;32]).unwrap(),request_nonce:RequestNonce([2;16])};
    let mut value=serde_json::to_value(request).unwrap();
    assert!(serde_json::from_value::<JoinRequest>(value.clone()).is_ok());
    value["skin_num"]=serde_json::json!(1);
    let error=serde_json::from_value::<JoinRequest>(value).unwrap_err().to_string();
    assert!(error.contains("unknown field") && error.contains("skin_num"));
}
#[test]
fn legacy_join_currently_discards_unimplemented_skin_field() {
    let value=serde_json::json!({"Join":{"champion":"garen","summoners":[null,null],"skin_num":1}});
    let packet:ClientPacket=serde_json::from_value(value).unwrap();
    let serialized=serde_json::to_value(packet).unwrap();
    assert_eq!(serialized["Join"]["champion"],"garen");
    assert!(serialized["Join"].get("skin_num").is_none());
}
