from pathlib import Path
import hashlib,json
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');inputs={}
def read(p):
 data=(r/p).read_bytes();inputs[p]=hashlib.sha256(data).hexdigest();return data.decode('utf-8-sig').replace('\r\n','\n')
def put(name,text): (s/name).write_text(text,encoding='utf-8')
def replace(text,a,b):
 assert text.count(a)==1,(a,text.count(a));return text.replace(a,b)
name='audio_replay_windows_configuration.rs';t=read('crates/core/src/'+name)
t=replace(t,'audio_replay_transport_configuration as native','audio_replay_transport_configuration as native, audio_replay_stream_transport as derived')
t=replace(t,'#[derive(Debug, Clone, PartialEq, Eq, serde::Serialize)]\npub struct ConfigurationSnapshot', '''/// Source8F6EB0 configuration of the2328-byte implementation used by8F68D0.
pub struct StreamConfigurationRequest<'a> {
    pub transport: ConfigurationRequest<'a>,
    pub key: [u8;16],
    pub flag: u32,
    pub extra: u32,
}
#[derive(Debug, Clone, PartialEq, Eq, serde::Serialize)]
pub struct StreamConfigurationSnapshot {
    pub interface_pointer: u32,
    pub key_pointer: u32,
    pub flag: u8,
    pub extra: u32,
}
#[derive(Debug, Clone, PartialEq, Eq, serde::Serialize)]
pub struct ConfigurationSnapshot''')
t=replace(t,'    pub queue_count: u32,','    pub queue_count: u32,\n    pub stream: Option<StreamConfigurationSnapshot>,')
t=replace(t,'    code: Option<u32>,','    code: Option<u32>,\n    derived: bool,\n    attempted: bool,')
t=replace(t,"    pub fn configure(&self, request: ConfigurationRequest<'_>) -> Result<u32, String> {",'''    pub fn configure(&self, request: ConfigurationRequest<'_>) -> Result<u32, String> {
        self.configure_owned(request,None)
    }
    /// Fresh implementation only, matching the source parent's state1 gate.
    /// Frame delivery and the parent stream's shared ownership are not attached yet.
    pub fn configure_stream_transport(&self, request: StreamConfigurationRequest<'_>) -> Result<u32,String> {
        self.configure_owned(request.transport,Some((request.key,request.flag,request.extra)))
    }
    fn configure_owned(&self, request: ConfigurationRequest<'_>, stream: Option<([u8;16],u32,u32)>) -> Result<u32,String> {''')
anchor='        if owner.is_none() {'
t=replace(t,anchor,'''        let is_derived=stream.is_some();
        if let Some(record)=owner.as_ref() {
            if record.derived!=is_derived {return Err("configuration implementation kind cannot change within its lifetime".into());}
            if is_derived && record.attempted {return Err("stream transport configuration already attempted; source state1 opening is required".into());}
        }
        if is_derived {
            for(p,v)in [(derived::VTABLE,derived::CLOSE),(derived::VTABLE+4,derived::SCALAR_DELETE),(derived::INTERFACE_VTABLE+16,0x8f6eb0)] {
                if b.word(p).map_err(|e|format!("stream vtable: {e:?}"))?!=v{return Err("unrecognized stream configuration vtable".into());}
            }
        }
'''+anchor)
t=replace(t,'.allocate(224)','.allocate(if is_derived {derived::BYTES}else{224})')
t=replace(t,'            if let Err(error) = native::construct(&mut b, p) {','''            let construction=if is_derived {derived::construct(&mut b,p).map_err(|e|format!("{e:?}"))}else{native::construct(&mut b,p).map_err(|e|format!("{e:?}"))};
            if let Err(error) = construction {''')
t=replace(t,'                code: None,','                code: None,\n                derived:is_derived,\n                attempted:false,')
a=t.index('        let result = native::configure(');b=t.index('        owner.as_mut().unwrap().code',a)
t=t[:a]+'''        owner.as_mut().unwrap().attempted=true;
        let result=if let Some((key,flag,extra))=stream {
            derived::configure(&mut b,p+derived::INTERFACE,incoming,request.arguments,&key,request.host,request.port,flag,extra).map_err(|e|format!("{e:?}"))
        }else{
            native::configure(&mut b,p,incoming,request.arguments[0],request.arguments[1],request.host,request.port).map_err(|e|format!("{e:?}"))
        };
'''+t[b:]
t=replace(t,'            native::close(b, p).map_err(|e| format!("configuration close: {e:?}"))?;', '''            if record.derived {derived::close(b,p).map_err(|e|format!("stream close: {e:?}"))?;}
            else {native::close(b,p).map_err(|e|format!("configuration close: {e:?}"))?;}''')
t=replace(t,'        native::scalar_delete(b, p, 1).map_err(|e| format!("configuration destruction: {e:?}"))?;', '''        if record.derived {derived::scalar_delete(b,p,1).map_err(|e|format!("stream destruction: {e:?}"))?;}
        else {native::scalar_delete(b,p,1).map_err(|e|format!("configuration destruction: {e:?}"))?;}''')
t=replace(t,'            queue_count: word(&mut b, p + 0xb8)?,','''            queue_count: word(&mut b, p + 0xb8)?,
            stream:if record.derived {Some(StreamConfigurationSnapshot {
                interface_pointer:p+derived::INTERFACE,key_pointer:word(&mut b,p+0xec)?,
                flag:engine::Boundary::byte(&mut b,p+0x108).map_err(|e|format!("stream flag: {e}"))?,extra:word(&mut b,p+0xf4)?,
            })}else{None},''')
t=replace(t,"impl<N: startup::Network + Send + 'static> native::Boundary for Backend<N> {", """impl<N: startup::Network + Send + 'static> derived::Boundary for Backend<N> {}
impl<N: startup::Network + Send + 'static> native::Boundary for Backend<N> {
    fn close_derived_transport(&mut self,p:u32)->Result<(),&'static str>{derived::close(self,p).map_err(|e|self.failure(e,"derived configuration close failed"))}
""")
put(name,t)
name='audio_replay_windows_transport.rs';t=read('crates/core/src/'+name)
t=replace(t,'ConfigurationRequest,ConfigurationCallback,ConfigurationSnapshot','ConfigurationRequest,ConfigurationCallback,ConfigurationSnapshot,StreamConfigurationRequest,StreamConfigurationSnapshot')
t=replace(t,'        if f != thread::DISPOSE {','''        if f==crate::audio_replay_stream_transport::CONTROL_DISPOSE {
            return crate::audio_replay_stream_transport::dispose_control(self,p).map_err(|e|self.failure(e,"stream control disposal failed"));
        }
        if f != thread::DISPOSE {''');put(name,t)
name='audio_replay_runtime_image.rs';t=read('crates/core/src/'+name)
t=replace(t,'[(u32, u32, u32); 11]','[(u32, u32, u32); 15]')
t=replace(t,'    (1, 0x2d8dd58, 144),','''    (1, 0x2d8dd58, 144),
    (1, 0x10dd320, 4168),
    (1, 0x10d6040, 8),
    (1, 0x10d6254, 48),
    (1, 0x10d5fdc, 12),''')
t=replace(t,'        a.transport.write_word(0x2d78f04, 2).unwrap();','''        for(p,v)in[(0x10d6040,0x8f6fa0),(0x10d6044,0x8f6d90),(0x10d6264,0x8f6eb0),(0x10d5fdc,0x5d5fd0),(0x10dd320,0x243f6a88)]{assert_eq!(a.transport.word(p).unwrap(),v);}
        a.transport.write_word(0x2d78f04, 2).unwrap();''');put(name,t)
name='extract_replay_runtime_image.py';t=read('tools/'+name)
t=replace(t," ('transport_uid_and_validation_scratch',1,0x2d8dd58,144),", """ ('transport_uid_and_validation_scratch',1,0x2d8dd58,144),
 ('stream_key_initial_tables',1,0x10dd320,4168),
 ('stream_transport_primary_vtable',1,0x10d6040,8),
 ('stream_transport_interface_vtable',1,0x10d6254,48),
 ('stream_transport_control_vtable',1,0x10d5fdc,12),""");put(name,t)
name='lib.rs';t=read('crates/core/src/'+name);t+='\npub mod audio_replay_key;\npub mod audio_replay_stream_transport;\n';put('lib_replay_stream_transport.rs',t)
name='audio_replay_windows_configuration_tests.rs';t=read('crates/core/src/'+name);t+='\ninclude!("audio_replay_windows_stream_transport_tests.rs");\n';put(name,t)
put('replay_derived_windows_source_inputs.json',json.dumps(inputs,indent=2)+'\n')
print('Prepared derived Windows owner, lifecycle, dispatch, image and module registration')
