from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');inputs={}
def read(p):
 raw=(r/p).read_bytes();inputs[p]=hashlib.sha256(raw).hexdigest();return raw.decode('utf-8-sig').replace('\r\n','\n')
def put(p,t):(s/p).write_text(t,encoding='utf-8')
t=read('crates/core/src/audio_replay_shared_pair.rs');anchor='/// Native5BD4E0: consume source, publish destination, then release old control.';assert t.count(anchor)==1
t=t.replace(anchor,'''/// Native5BD470 copies into a fresh temporary, publishes destination, then
/// releases its former control. Unlike5CC070, callbacks observe the new pair.
pub fn copy_assign<B:Storage+Boundary>(b:&mut B,destination:u32,source:u32)->Result<u32,Error>{
 let control=b.word(add(source,4)?)?;let object=b.word(source)?;
 if control!=0{b.increment_reference(add(control,4)?).map_err(Error::Boundary)?;}
 let old=b.word(add(destination,4)?)?;
 b.write_word(add(destination,4)?,control)?;b.write_word(destination,object)?;
 release_control(b,old)?;Ok(destination)
}
'''+anchor);put('audio_replay_shared_pair.rs',t)
t=read('crates/core/src/audio_replay_pair_move_tests.rs');t+='''
#[test]
fn audio_replay_copy_assignment_matches576_native_publication_reference_and_mutating_disposal_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_pair_copy_assignment_probe.json")).unwrap();assert_eq!(p["passed"],true);let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),576);
 for c in cases{let mut b=backend(n(&c["strong"]),n(&c["weak"]),false);b.observing_move=Some(n(&c["mutation"])as u8);for w in c["before"].as_array().unwrap(){b.write_word(n(&w[0]),n(&w[1])).unwrap();}
  assert_eq!(copy_assign(&mut b,DEST,n(&c["source"])).unwrap(),n(&c["result"]));compare(&mut b,&c["after"]);assert_eq!(json!(b.events),c["events"]);
 }
}
''';put('audio_replay_pair_move_tests.rs',t)
t=read('crates/core/src/audio_replay_shared_pair_tests.rs');put('audio_replay_shared_pair_tests.rs',t)
t=read('crates/core/src/audio_replay_stream_transport_tests.rs');t=t.replace('        assert_eq!(f, derived::CONTROL_DISPOSE);\n        derived::dispose_control(self, p).map_err(|_| "derived disposal")','''        match f {
            derived::CONTROL_DISPOSE=>derived::dispose_control(self,p).map_err(|_|"derived disposal"),
            crate::audio_replay_manager_control::DISPOSE=>crate::audio_replay_manager_control::dispose(self,p).map_err(|_|"manager disposal"),
            control::DISPOSE=>{let object=self.word(p+12).map_err(|_|"control object")?;if object!=0{let vt=self.word(object).map_err(|_|"object vtable")?;let method=self.word(vt).map_err(|_|"object delete")?;if method!=crate::audio_replay_opening::NULL_DELETE{return Err("unexpected scalar object");}crate::audio_replay_opening::scalar_delete_null(self,object,1).map_err(|_|"null implementation deletion")?;}Ok(())},
            _=>Err("unknown opening control disposal")
        }''');assert 'unknown opening control disposal' in t;put('audio_replay_stream_transport_tests.rs',t)
t=read('crates/core/src/audio_replay_transport_configuration_tests.rs');t+='\ninclude!("audio_replay_opening_tests.rs");\n';put('audio_replay_transport_configuration_tests.rs',t)
h=(s/'replay-stream-transport-tests.rs').read_text();h=h.replace('E:/OpenLeague/crates/core/src/audio_replay_shared_pair.rs','E:/mapslol3v3/audio_replay_shared_pair.rs');h+='\n#[path="E:/mapslol3v3/audio_replay_opening.rs"]mod audio_replay_opening;\n';put('replay-opening-tests.rs',h)
put('replay_opening_source_inputs.json',json.dumps(inputs,indent=2)+'\n')
print('Prepared source opening and distinct copy assignment')
