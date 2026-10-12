//! Native 4.20 particle sound request gates (93ed60 / 93ee30).
//! This layer requests audio; it does not implement the audio backend or mixer.
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy)]
pub struct Context {
    pub clock: f32,
    pub birth: f32,
    pub position: [f32; 3],
}
impl Context {
    fn age(self) -> Result<f32, &'static str> {
        let age = self.clock - self.birth;
        if !self.clock.is_finite() || !self.birth.is_finite() || !age.is_finite()
            || self.position.iter().any(|v| !v.is_finite()) {
            return Err("invalid sound request context");
        }
        Ok(age)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Request {
    /// Native particle manager virtual slot, not a Wwise event ID.
    pub slot: u32,
    pub event: String,
    pub position: [f32; 3],
    pub age: f32,
}

/// Native cleanup/reset fragments release every reference except the -1 sentinel,
/// then reset it. Event-end marking alone must not invoke this operation.
pub fn release_logical_reference(handle: &mut i32, post: &mut impl FnMut(i32)) {
    if *handle != -1 { post(*handle); *handle = -1; }
}
#[derive(Debug, Clone)]
pub struct Emitter {
    create: String,
    persistent: String,
    creation_checked: bool,
    /// Native -1 sentinel; zero is a retained logical handle.
    handle: i32,
}
impl Emitter {
    pub fn new(create: String, persistent: String) -> Self {
        Self { create, persistent, creation_checked: false, handle: -1 }
    }
    /// Call only when particle cleanup/reset actually releases its persistent sound.
    /// Native callback queues release; this is not synchronous voice destruction.
    pub fn release_persistent(&mut self, mut post: impl FnMut(i32)) {
        release_logical_reference(&mut self.handle, &mut post);
    }
    pub fn logical_handle(&self) -> i32 { self.handle }
    pub fn creation_checked(&self) -> bool { self.creation_checked }

    /// At first eligible update, creation is attempted only while age < 1.
    /// A late first update consumes the gate without posting. Negative ages
    /// satisfy the original comparison and must not be clamped to zero.
    pub fn creation_request(&mut self, context: Context) -> Result<Option<Request>, &'static str> {
        if self.creation_checked { return Ok(None); }
        let age = context.age()?;
        self.creation_checked = true;
        Ok((age < 1.0 && !self.create.is_empty()).then(|| Request {
            slot: 0x18, event: self.create.clone(), position: context.position, age,
        }))
    }

    /// The callback allocates a logical backend reference, not a playing ID.
    /// No age gate applies; -1 retries, all other values are retained.
    /// A naturally ended voice cannot reset this reference on its own.
    pub fn ensure_persistent(&mut self, context: Context, mut post: impl FnMut(Request) -> i32)
        -> Result<(), &'static str> {
        if self.handle != -1 || self.persistent.is_empty() { return Ok(()); }
        let age = context.age()?;
        self.handle = post(Request { slot: 0x10, event: self.persistent.clone(), position: context.position, age });
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn context(age: f32) -> Context { Context { clock: age, birth: 0.0, position: [1.0, 2.0, 3.0] } }

    #[test]
    fn cleanup_and_reset_match_32_native_release_fragment_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_particle_release_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),32);
        for case in cases {
            let mut handles=[case["primary"].as_i64().unwrap() as i32,case["secondary"].as_i64().unwrap() as i32];
            let mut calls=vec![];
            for _ in 0..case["repeats"].as_u64().unwrap() {
                for handle in &mut handles {release_logical_reference(handle,&mut |h|calls.push(h as u32));}
            }
            let expected:Vec<u32>=case["release_calls"].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect();
            assert_eq!(calls,expected);assert_eq!(handles,[-1,-1]);
        }
    }
    #[test]
    fn persistent_cleanup_queues_native_key_once_without_destroying_pending_entry() {
        let mut manager=crate::audio_logical_registration::Manager::default();
        let mut e=Emitter::new("create".into(),"persistent".into());
        assert!(e.creation_request(context(0.)).unwrap().is_some());
        e.ensure_persistent(context(0.),|r|manager.register(&r).unwrap()).unwrap();assert_eq!(e.logical_handle(),1);
        e.release_persistent(|h|manager.queue_release(h));e.release_persistent(|h|manager.queue_release(h));
        assert_eq!(manager.release_keys(),&[1]);assert_eq!(e.logical_handle(),-1);
        assert!(manager.entry(1).is_some());assert!(e.creation_checked());
        e.ensure_persistent(context(2.),|r|manager.register(&r).unwrap()).unwrap();assert_eq!(e.logical_handle(),2);
        assert_eq!(manager.pending_key_calls(),&[1,2]);
    }
    #[test]
    fn matches_original_emulated_request_sequences() {
        #[derive(Deserialize)] struct Particle { asset: String, create: String, persistent: String }
        #[derive(Deserialize)] struct Step { method: String, clock: f32, birth: f32, position: [f32;3] }
        #[derive(Deserialize)] struct Case { asset: String, returned_handle: i32, steps: Vec<Step>, calls: Vec<Request>, final_handle: i32, creation_checked: bool }
        #[derive(Deserialize)] struct Contract { particles: Vec<Particle>, cases: Vec<Case> }
        let data: Contract = serde_json::from_str(include_str!("../../../data/4.20/audio_request_contract.json")).unwrap();
        assert_eq!(data.particles.len(),5);
        assert_eq!(data.cases.len(),75);
        let mut steps=0;
        for case in data.cases {
            let p=data.particles.iter().find(|p| p.asset==case.asset).unwrap();
            let mut emitter=Emitter::new(p.create.clone(),p.persistent.clone());
            let mut calls=vec![];
            for s in case.steps {
                steps+=1;
                let c=Context { clock:s.clock,birth:s.birth,position:s.position };
                match s.method.as_str() {
                    "create" => { if let Some(request)=emitter.creation_request(c).unwrap() { calls.push(request); } },
                    "persistent" => emitter.ensure_persistent(c,|r| {calls.push(r);case.returned_handle}).unwrap(),
                    _ => panic!("unknown native sample method"),
                }
            }
            assert_eq!(calls,case.calls,"{}",case.asset);
            assert_eq!(emitter.logical_handle(),case.final_handle);
            assert_eq!(emitter.creation_checked(),case.creation_checked);
        }
        assert_eq!(steps,195);
    }

    #[test]
    fn late_creation_is_consumed_even_when_time_goes_back() {
        let mut e=Emitter::new("create".into(),String::new());
        assert!(e.creation_request(context(1.0)).unwrap().is_none());
        assert!(e.creation_request(context(0.0)).unwrap().is_none());
        assert!(e.creation_checked());
    }

    #[test]
    fn zero_handle_is_retained_and_minus_one_retries() {
        for returned in [0,-1] {
            let mut e=Emitter::new(String::new(),"persistent".into());
            let mut calls=0;
            for age in [0.0,20.0] { e.ensure_persistent(context(age), |_| {calls+=1;returned}).unwrap(); }
            assert_eq!(calls,if returned == -1 {2} else {1});
        }
    }

    #[test]
    fn create_and_persistent_have_independent_gates() {
        let mut e=Emitter::new("one".into(),"two".into());
        assert_eq!(e.creation_request(context(-0.5)).unwrap().unwrap().age,-0.5);
        let mut calls=vec![];
        e.ensure_persistent(context(5.0),|r| {calls.push(r);9}).unwrap();
        assert_eq!(calls[0].age,5.0);
        assert_eq!(calls[0].slot,0x10);
        assert!(e.creation_request(context(0.0)).unwrap().is_none());
    }

    #[test]
    fn invalid_context_does_not_consume_pending_requests() {
        let mut e=Emitter::new("one".into(),"two".into());
        for bad in [context(f32::NAN), Context {birth:-f32::MAX,..context(f32::MAX)},Context {position:[f32::INFINITY,0.0,0.0],..context(0.0)}] {
            assert!(e.creation_request(bad).is_err());
            assert!(e.ensure_persistent(bad, |_| panic!("must not post invalid data")).is_err());
            assert!(!e.creation_checked());
            assert_eq!(e.logical_handle(),-1);
        }
        assert!(e.creation_request(context(0.0)).unwrap().is_some());
    }
}
