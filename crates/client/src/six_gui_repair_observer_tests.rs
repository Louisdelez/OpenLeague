use super::*;
fn camera_owner_fixture()->crate::camera_lock::Owner {crate::camera_lock::Owner{pid:std::process::id(),session:7,player:21,epoch:None,primary_window:Entity::PLACEHOLDER}}
#[test]fn six_gui_camera_typed_request_cannot_assign_focus_or_bypass_CAS() {
    let accepted=Owner{session:7,player:21,epoch:None};
    let request=|operation:&str|format!(r#"{{"schema":1,"client_pid":42,"ordinal":1,"owner":{{"session":7,"player":21,"epoch":null}},"source_tick":300,"operation":{operation}}}"#).into_bytes();
    assert!(validate(&request(r#"{"kind":"camera_lock","expected_revision":4,"expected_locked":false}"#),42,1,accepted,300).is_ok());
    for invalid in [r#"{"kind":"camera_lock","expected_revision":4}"#,r#"{"kind":"camera_lock","expected_revision":4,"expected_locked":false,"focused":true}"#,
        r#"{"kind":"camera_lock","expected_revision":4.5,"expected_locked":false}"#,r#"{"kind":"camera_focus","x":0,"z":0}"#] {
        assert!(validate(&request(invalid),42,1,accepted,300).is_err());
    }
}
#[test]fn six_gui_camera_ack_alone_and_foreign_revision_cannot_qualify_normal_follow() {
    let owner=camera_owner_fixture();let target=Vec3::new(1.,2.,3.);
    let mut sample=FollowSample{serial:8,owner:Some(owner),revision:Some(4),source_tick:Some(300),followed:false,target:Some(target),focus:Some(target)};
    assert!(!follow_matches(owner,4,&sample));sample.followed=true;assert!(follow_matches(owner,4,&sample));
    assert!(!follow_matches(owner,5,&sample));assert!(!follow_matches(crate::camera_lock::Owner{epoch:Some(1),..owner},4,&sample));
    sample.focus=Some(Vec3::ZERO);assert!(!follow_matches(owner,4,&sample));sample.focus=Some(target);sample.serial=0;assert!(!follow_matches(owner,4,&sample));
}
#[test]fn six_gui_callback_resource_tokens_require_same_real_scope_and_do_not_claim_pixels() {
    let a=serde_json::json!({"scope":{"owner":{"pid":42,"session":7,"player":21},"camera":8,"map_instance":"A","model_instance":"B"}});
    let newer=serde_json::json!({"scope":a["scope"],"CPU_serial":999});assert!(same_capture_scope(Some(&a),Some(&newer)));
    let foreign=serde_json::json!({"scope":{"owner":{"pid":43,"session":7,"player":21},"camera":8,"map_instance":"A","model_instance":"B"}});
    assert!(!same_capture_scope(Some(&a),Some(&foreign)));assert!(!same_capture_scope(Some(&a),None));
    let new_scene=serde_json::json!({"scope":{"owner":{"pid":42,"session":7,"player":21},"camera":8,"map_instance":"C","model_instance":"B"}});
    assert!(!same_capture_scope(Some(&a),Some(&new_scene)));assert!(!same_capture_scope(Some(&serde_json::json!({})),Some(&serde_json::json!({}))));
}
#[test]fn six_gui_camera_normal_readiness_rejections_do_not_relax_foreign_owner_or_lease() {
    use crate::camera_lock::Rejection::*;
    for ordinary in [Unavailable,NotReady,Terminal,HumanGate,StaleSerial,StaleRevision,StaleState]{assert!(camera_recoverable(ordinary));}
    for fatal in [ForeignOwner,InvalidLease,Exhausted]{assert!(!camera_recoverable(fatal));}
}
