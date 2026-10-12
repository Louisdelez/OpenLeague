from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_shared_fls.rs';s=p.read_text()
s=s.replace('struct Data<S>{context:', '/// Optional production cleanup, run only after successful source destruction.\n/// Diagnostic mode retains snapshots by leaving this policy unset.\npub type Retirement<S>=fn(&mut Context<S>)->Result<(),crate::audio_bus_bank::Error>;\nstruct Data<S>{retirement:Option<Retirement<S>>,context:')
s=s.replace('state.bound.remove(&data.record);result.map_err', 'state.bound.remove(&data.record);\n   let result=result.and_then(|()|match data.retirement{Some(retire)=>retire(&mut state.context),None=>Ok(())});result.map_err')
s=s.replace('struct Inner<S>{context:', 'struct Inner<S>{retirement:Option<Retirement<S>>,context:')
old=' pub fn new()->Result<Self,Failure>{let index='
new=''' pub fn new()->Result<Self,Failure>{Self::new_policy(None)}
 /// Production policy runs under serialized state access after the destructor
 /// succeeds, on both thread exit and slot close. Cleanup errors are sticky
 /// callback failures; diagnostic clients can continue to use new().
 pub fn new_with_retirement(retire:Retirement<S>)->Result<Self,Failure>{Self::new_policy(Some(retire))}
 fn new_policy(retirement:Option<Retirement<S>>)->Result<Self,Failure>{let index='''
assert old in s;s=s.replace(old,new)
s=s.replace('Inner{context:Mutex', 'Inner{retirement,context:Mutex')
s=s.replace('Data{context:Arc::clone(&context)', 'Data{retirement:self.inner.retirement,context:Arc::clone(&context)')
s=s.replace("struct CurrentProvider<'a,S>{services:", "struct CurrentProvider<'a,S>{retirement:Option<Retirement<S>>,services:")
s=s.replace('Data{context:self.context.clone()', 'Data{retirement:self.retirement,context:self.context.clone()')
s=s.replace('CurrentProvider{services,context:', 'CurrentProvider{retirement:self.inner.retirement,services,context:')
p.write_text(s,encoding='utf-8')
(r/'tools/implement_audio_fls_retirement_policy.py').write_text(Path(__file__).read_text(),encoding='utf-8')
print('Implemented opt-in serialized post-destructor FLS retirement policy')
