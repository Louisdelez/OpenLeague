from pathlib import Path
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
t=(r/'crates/core/src/audio_replay_logger_tests.rs').read_text(encoding='utf-8')
t=t.replace("    output: Result<u8, &'static str>,","    output: Result<u8, &'static str>,\n    file_events: Vec<Value>,\n    file_profile: u32,\n    write_result: i32,\n    close_result: i32,\n    held: BTreeSet<u32>,")
t=t.replace('            output: Ok(0),','            output: Ok(0),\n            file_events: vec![], file_profile: 0, write_result: 0, close_result: 0, held: BTreeSet::new(),')
t=t.replace('        self.calls.push((owner, member, p));\n        self.output', '''        if member == crate::audio_replay_recording_resource::MEMBER {
            return crate::audio_replay_recording_resource::message(self,owner,p).map_err(|_|"resource message failed");
        }
        self.calls.push((owner, member, p));
        if member==0x32008a00 {return self.word(owner).map(|v|v as u8).map_err(|_|"missing supplied callback return");}
        self.output''')
t+='\n#[path="audio_replay_recording_resource_tests.rs"]\nmod recording_tests;\n'
(s/'audio_replay_logger_tests.rs').write_text(t,encoding='utf-8')
t=(s/'replay-running-tests.rs').read_text(encoding='utf-8')
# Previous standalone redirects are replaced by current production sources.
import re
t=re.sub(r'E:/mapslol3v3/(audio_[\w]+\.rs)',r'E:/OpenLeague/crates/core/src/\1',t)
t=t.replace('fn audio_test_fixture(relative:&str)->String','fn prior_audio_test_fixture(relative:&str)->String')
t+='\nfn audio_test_fixture(relative:&str)->String {std::fs::read_to_string(if relative.ends_with("replay_logger_composite_probe.json")||relative.ends_with("replay_recording_file_probe.json"){std::path::Path::new("E:/mapslol3v3").join(std::path::Path::new(relative).file_name().unwrap())}else{std::path::Path::new("E:/OpenLeague").join(relative)}).unwrap()}\n'
t=t.replace('E:/OpenLeague/crates/core/src/audio_replay_logger.rs','E:/mapslol3v3/audio_replay_logger.rs')
t+='\n#[path="E:/mapslol3v3/audio_replay_recording_resource.rs"] mod audio_replay_recording_resource;\n'
(s/'replay-recording-tests.rs').write_text(t,encoding='utf-8')
print('Prepared native composite/resource test adapters')
