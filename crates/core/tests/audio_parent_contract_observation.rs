//! Parent dispatch, scratch lifetime and callback behavior compared with native V790.
//! Object/storage identities and playing ID replies are supplied test inputs.
//! Selection executes the real core Dispatcher; this test does not implement playback.
use openleague_core::{
    audio_action_dispatch::Dispatcher,
    audio_deferred_pool::{Allocation, Cleanup, Pool, ScratchSubsystem},
    audio_event_post::Callback,
    audio_launch_dispatcher::{dispatch, Command},
    audio_object_callbacks::{self, Kind},
    audio_random::NativeRandom,
    audio_selection::ambient_contract,
    audio_unbound_post::{Command as Unbound, Target},
};
use serde_json::{json, Value};
use std::cell::RefCell;
fn number(v: &Value) -> u32 { v.as_u64().unwrap().try_into().unwrap() }
struct Current {
    pool: RefCell<Pool<u32, u32>>,
    subsystem: RefCell<ScratchSubsystem>,
    backend: RefCell<Dispatcher>,
    rng: RefCell<NativeRandom>,
    calls: RefCell<Vec<Value>>,
}
impl Current {
    fn new() -> Self {
        Self { pool: RefCell::new(Pool::default()),
            subsystem: RefCell::new(ScratchSubsystem { initialized: true }),
            backend: RefCell::new(Dispatcher::new(ambient_contract().unwrap()).unwrap()),
            rng: RefCell::new(NativeRandom::seeded(0)), calls: RefCell::new(vec![]) }
    }
    fn launch(&self, case: &Value, event: &str, bound: bool, object: u32, token: u32, cookie: u32) -> (u32, Option<u32>) {
        let mut output = Some(0xfeedbeef);
        let answer = dispatch(event, bound.then_some(object), [0.; 3], cookie, 0., &mut output,
            |linked| {
                assert_eq!(linked, cookie);
                let allocation = self.pool.borrow_mut().allocate(&mut self.subsystem.borrow_mut(),
                    (cookie != 0).then_some(cookie), || Some(object),
                    || panic!("native subsystem was already initialized"), || Some(u64::from(token)));
                assert!(matches!(allocation, Allocation::Registered { token: actual } if actual == u64::from(token)));
                Some(Target { object_id: object, cookie: token, linked_present: cookie != 0 })
            },
            |command| match command {
                Command::BoundPost(p) | Command::Unbound(Unbound::Post(p)) => {
                    assert_eq!(p.object_id, object);
                    assert_eq!(p.flags, 5);
                    assert_eq!(p.callback, if bound { Callback::BoundVoice } else { Callback::UnboundScratch });
                    assert_eq!(p.cookie, if bound { cookie } else { token });
                    let id = openleague_core::audio_release::event_id(&p.event).unwrap();
                    let before = self.rng.borrow().state();
                    let result = self.backend.borrow_mut().post_immediate_event(id, u64::from(object), 0, &mut self.rng.borrow_mut());
                    if p.event == case["event"].as_str().unwrap() {
                        let result = result.unwrap();
                        let expected = case["actions"].as_array().unwrap();
                        assert_eq!(result.len(), expected.len());
                        for (a, b) in result.iter().zip(expected) {
                            assert_eq!(a.action, number(&b["action"]));
                            let selected = a.selection.as_ref().unwrap();
                            assert_eq!((selected.sound, selected.source), (number(&b["selection"]["sound"]), number(&b["selection"]["media"])));
                        }
                        self.calls.borrow_mut().push(json!({"kind":"selected", "object_id":object,"count":result.len()}));
                        // Native playing ID from the receipt; no physical backend is supplied here.
                        1
                    } else {
                        assert!(result.is_err()); assert_eq!(self.rng.borrow().state(), before);
                        self.calls.borrow_mut().push(json!({"kind":"missing", "object_id":object})); 0
                    }
                },
                Command::Unbound(Unbound::Position { target, position }) => {
                    assert_eq!(target.object_id, object); assert_eq!(position, [0.;3]); 0
                },
                Command::Unbound(Unbound::Retire(target)) => {
                    self.pool.borrow_mut().entries_mut().iter_mut().find(|e| e.token == u64::from(target.cookie)).unwrap().retired = 1; 0
                },
                Command::Diagnostic { event } => { self.calls.borrow_mut().push(json!({"kind":"diagnostic", "event":event})); 0 },
                other => panic!("unexpected command {other:?}"),
            }).unwrap();
        assert_eq!(self.backend.borrow().pending(), 0);
        (answer, output)
    }
}
#[test]
fn parent_and_cleanup_match_three_native_profiles() {
    let cases: Value = serde_json::from_str(r#"[{"route":"bound","event":"Play_sfx_Env_Map10_Emitter_brazierchain","event_id":1392698701,"object_id":2000001,"scratch":0,"callback_cookie":856507392,"actions":[{"action":1049381235,"target":6927,"probability_percent":50.0,"gate_seed":0,"selection":{"sound":407149979,"media":931355143},"native_action_object":1612819200},{"action":415219389,"target":191470420,"probability_percent":25.0,"gate_seed":3539360597,"selection":{"sound":900501484,"media":556739449},"native_action_object":1612819264}],"cleanup":[],"native_limit_cases":[],"callback_methods":[{"slot":4,"argument":null},{"slot":0,"argument":1}]},{"route":"unbound","event":"Play_sfx_Env_Map10_Emitter_brazierchain","event_id":1392698701,"object_id":3,"scratch":1612868960,"callback_cookie":856507392,"actions":[{"action":1049381235,"target":6927,"probability_percent":50.0,"gate_seed":0,"selection":{"sound":407149979,"media":931355143},"native_action_object":1612819200},{"action":415219389,"target":191470420,"probability_percent":25.0,"gate_seed":3539360597,"selection":{"sound":900501484,"media":556739449},"native_action_object":1612819264}],"cleanup":[{"kind":"dispose","object_id":3},{"kind":"destroy_linked","object_id":3},{"kind":"remove","object_id":3}],"native_limit_cases":[],"callback_methods":[{"slot":4,"argument":null},{"slot":0,"argument":1}]},{"route":"unbound","event":"Play_sfx_Env_Map10_Emitter_brazierchain","event_id":1392698701,"object_id":4,"scratch":1612869072,"callback_cookie":856507392,"actions":[{"action":1049381235,"target":6927,"probability_percent":50.0,"gate_seed":0,"selection":{"sound":407149979,"media":931355143},"native_action_object":1612819200},{"action":415219389,"target":191470420,"probability_percent":25.0,"gate_seed":3539360597,"selection":{"sound":900501484,"media":556739449},"native_action_object":1612819264}],"cleanup":[{"kind":"dispose","object_id":3},{"kind":"remove","object_id":3},{"kind":"dispose","object_id":4},{"kind":"destroy_linked","object_id":4},{"kind":"remove","object_id":4}],"native_limit_cases":[{"name":"empty_parent","bound":false,"answer":0,"output":0,"no_events":true,"registry_unchanged":true,"step_index":0},{"name":"empty_parent","bound":true,"answer":0,"output":0,"no_events":true,"registry_unchanged":true,"step_index":1},{"name":"missing_unbound_parent","answer":0,"event":"OpenLeague_missing_event","output":1612868880,"object_id":3,"scratch":1612868960,"scratch_raw":"106d2260000000600000000001000000","object_raw":"10f30a01030000000000000000000000000000000000000001000000000000000000000000000000","diagnostics":[{"entry":"0x5fa170","args":[0,5,0,17490888,856506624],"format":"AudioManager::PlaySoundEvent: Failed to play sound event %s.","event":"OpenLeague_missing_event","scope":"supplied diagnostic sink only; original parent and failed Post continue normally"}],"step_index":2}],"callback_methods":[{"slot":4,"argument":null},{"slot":0,"argument":1}]}]"#).unwrap();
    for case in cases.as_array().unwrap() {
        let current = Current::new();
        let limits = case["native_limit_cases"].as_array().unwrap();
        for limit in limits {
            if limit["name"] == "empty_parent" {
                let mut output = Some(0xfeedbeef);
                let result = dispatch("", limit["bound"].as_bool().unwrap().then_some(2000001), [0.;3], 0, 0., &mut output,
                    |_| panic!("empty input must not allocate"), |_| panic!("empty input must not consume")).unwrap();
                assert_eq!(result, 0); assert_eq!(output, None);
            } else {
                let object = number(&limit["object_id"]);
                let (result, output) = current.launch(case, limit["event"].as_str().unwrap(), false, object, number(&limit["scratch"]), 0);
                assert_eq!(result, 0); assert_eq!(output, Some(object));
                assert_eq!(current.pool.borrow().entries()[0].retired, 1);
                assert_eq!(current.calls.borrow().as_slice(), [json!({"kind":"missing","object_id":object}),json!({"kind":"diagnostic","event":limit["event"]})]);
            }
        }
        let bound = case["route"] == "bound";
        let object = number(&case["object_id"]); let token = number(&case["scratch"]); let cookie = number(&case["callback_cookie"]);
        let (answer, output) = current.launch(case, case["event"].as_str().unwrap(), bound, object, token, cookie);
        assert_eq!(answer, 1); assert_eq!(output, Some(object));
        assert_eq!(current.rng.borrow().state(), 773150046);
        let mut methods = vec![]; let mut cleanup = vec![];
        if bound {
            assert!(current.pool.borrow().entries().is_empty());
            let mut retired = 0;
            methods.extend(audio_object_callbacks::deliver(Kind::Bound, 1, true, false, &mut retired).into_iter().map(|c| json!({"slot":c.slot,"argument":c.argument})));
            assert_eq!(retired, 0);
        } else {
            let before = current.pool.borrow().entries().len();
            assert!(current.pool.borrow_mut().deliver_callback(u64::from(token), 1, |linked, c| {
                assert_eq!(*linked, cookie); methods.push(json!({"slot":c.slot,"argument":c.argument}));
            }));
            assert_eq!(current.pool.borrow().entries().len(), before);
            assert_eq!(current.pool.borrow().entries().last().unwrap().retired, 1);
            current.pool.borrow_mut().clear(|command| match command {
                Cleanup::DisposeObject(o) => cleanup.push(json!({"kind":"dispose","object_id":o})),
                Cleanup::DestroyLinked(linked) => {
                    assert_eq!(*linked, cookie); cleanup.push(json!({"kind":"destroy_linked","object_id":object}));
                    methods.push(json!({"slot":0,"argument":1}));
                },
                Cleanup::RemoveScratch(t) => {
                    let id = if t == u64::from(token) { object } else { number(&limits.last().unwrap()["object_id"]) };
                    cleanup.push(json!({"kind":"remove","object_id":id}));
                },
            });
            assert!(current.pool.borrow().entries().is_empty());
        }
        assert_eq!(json!(methods), case["callback_methods"]); assert_eq!(json!(cleanup), case["cleanup"]);
        println!("OBSERVATION {}", json!({"route":case["route"],"object_id":object,"selected":2,"native_limits":limits.len(),"callback_methods":methods,"cleanup":cleanup}));
    }
}
#[test]
fn invalid_local_inputs_leave_output_and_backend_untouched() {
    for (event, age) in [("é", 0.), ("event\0tail", 0.), ("event", f32::NAN)] {
        let mut output = Some(0xfeedbeef);
        assert!(dispatch(event, None, [0.;3], 0, age, &mut output,
            |_| panic!("invalid input must not allocate"), |_| panic!("invalid input must not consume")).is_err());
        assert_eq!(output, Some(0xfeedbeef));
    }
    println!("LOCAL_REFUSALS 3 PASS");
}
