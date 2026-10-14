use super::*;

#[test]
fn pipeline_ready_without_dispatch_never_counts_as_a_material_draw(){
 let mut state=DispatchState::default();
 state.begin(23,vec![serde_json::json!({"session":11,"group":0,"ready":true})]);
 assert_eq!(state.readiness[0]["ready"],true);
 assert_eq!(state.counts()["material_success"],0);
 // A successful Draw::draw return can be a tuple Skip. It must not be
 // transformed into evidence of successful material command encoding.
 state.push(serde_json::json!({"stage":"delegated"}));
 state.push(serde_json::json!({"stage":"material_skip"}));
 state.push(serde_json::json!({"stage":"returned_ok"}));
 assert_eq!(state.counts()["returned_ok"],1);
 assert_eq!(state.counts()["material_skip"],1);
 assert_eq!(state.counts()["material_success"],0);
}

#[test]
fn rejected_guards_are_not_successful_delegations(){
 let mut state=DispatchState::default();state.begin(5,vec![]);
 state.push(serde_json::json!({"stage":"guard_attempt","session":1,"group":2}));
 state.push(serde_json::json!({"stage":"guard_rejected","reason":"pickup current FoW not encoded","session":1,"group":2}));
 assert_eq!(state.counts()["guard_attempt"],1);
 assert_eq!(state.counts()["guard_rejected"],1);
 for stage in ["delegated","material_success","material_skip","returned_ok"]{assert_eq!(state.counts()[stage],0);}
 assert_eq!(state.commands[1]["reason"],"pickup current FoW not encoded");
}

#[test]
fn new_render_frame_discards_previous_command_results(){
 let mut state=DispatchState::default();state.begin(41,vec![]);
 for group in 0..4{state.push(serde_json::json!({"stage":"material_success","session":7,"pickup_tick":12,"picker":21,"group":group}));}
 state.phase_members.push(serde_json::json!({"session":7}));state.dropped=1;
 assert_eq!(state.counts()["material_success"],4);
 state.begin(42,vec![serde_json::json!({"session":8,"ready":false})]);
 assert_eq!(state.frame,2);assert_eq!(state.published_frames,42);
 assert!(state.commands.is_empty());assert!(state.phase_members.is_empty());assert_eq!(state.dropped,0);
 assert_eq!(state.counts()["material_success"],0);assert_eq!(state.readiness[0]["session"],8);
}
