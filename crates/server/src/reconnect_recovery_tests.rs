use super::*;
fn nonce(v:u8)->RequestNonce { RequestNonce([v;16]) }
fn key(v:u8)->Secret32 { Secret32::from_bytes([v;32]).unwrap() }
fn peer(v:u16)->SocketAddr { SocketAddr::from(([127,0,0,1],10000+v)) }
fn seconds(v:u64)->Duration { Duration::from_secs(v) }
struct Keys(u8); // Deterministic injection only.
impl Entropy for Keys { fn access_key(&mut self)->Result<Secret32,EntropyUnavailable>{self.0+=1;Ok(key(self.0))} }
fn started()->(Registry,Welcome,Keys) {
    let mut r=Registry::new(77,Limits::default()).unwrap();let mut e=Keys(10);
    let request=JoinRequest{version:wire::VERSION,champion:"garen".into(),summoners:[None,None],recovery_key:key(1),request_nonce:nonce(2)};
    let w=match r.prepare_join(peer(1),&request,Duration::ZERO,&mut e).unwrap(){
        JoinPreparation::New(p)=>p.commit(21,ClockBootstrap::Running).unwrap(),_=>panic!("new")};
    (r,w,e)
}
fn query(n:u8)->wire::ContextRequest { wire::ContextRequest{version:wire::VERSION,expected_session:Some(77),recovery_key:key(1),request_nonce:nonce(n)} }

#[test] fn context_queries_authenticate_before_disclosure_and_never_refresh_activity() {
    let (mut r,w,_)=started();let before=r.view();
    let mut wrong=query(3);wrong.recovery_key=key(99);
    assert!(matches!(r.query_context(&wrong,seconds(29)),Err(Error::UnknownLease)));
    wrong=query(3);wrong.expected_session=Some(78);
    assert!(matches!(r.query_context(&wrong,seconds(29)),Err(Error::Unauthorized)));
    let info=r.query_context(&query(3),seconds(30)).unwrap();
    assert_eq!(info.context,w.context);assert_eq!(info.availability,wire::Availability::Busy);
    assert_eq!(r.view(),before);
    let info=r.query_context(&query(3),seconds(31)).unwrap();assert_eq!(info.availability,wire::Availability::Detached);
    assert_eq!(r.view(),before);assert_eq!(r.poll(seconds(31)).unwrap().len(),1);
}
#[test] fn lost_committed_welcome_can_recover_context_and_resume_same_player_on_new_socket() {
    let (mut r,w,mut e)=started();
    let request=ResumeRequest{version:wire::VERSION,expected:w.context,recovery_key:key(1),request_nonce:nonce(3)};
    let unseen=match r.prepare_resume(peer(2),&request,seconds(31),&mut e).unwrap(){
        ResumePreparation::New(p)=>p.commit(ClockBootstrap::Running).unwrap().welcome,_=>panic!("new")};
    // Explicit fault model: the welcome is dropped and that endpoint crashes.
    let recovered=r.query_context(&query(4),seconds(62)).unwrap();
    assert_eq!(recovered.context,unseen.context);assert_eq!(recovered.availability,wire::Availability::Detached);
    let request=ResumeRequest{expected:recovered.context,request_nonce:nonce(5),..request};
    let attached=match r.prepare_resume(peer(3),&request,seconds(62),&mut e).unwrap(){
        ResumePreparation::New(p)=>p.commit(ClockBootstrap::Running).unwrap(),_=>panic!("new")};
    assert_eq!(attached.welcome.context,Context{epoch:3,..w.context});assert_eq!(r.live_players(),1);
    assert_eq!(r.view().leases.len(),1);assert_eq!(r.view().leases[0].context.player,21);
    assert_eq!(attached.previous.unwrap().peer,peer(2));
    let old=SessionInput{version:wire::VERSION,context:unseen.context,access_key:unseen.access_key,sequence:1,input:Input::Leave};
    assert!(matches!(r.prepare_input(peer(2),&old,seconds(63)),Err(Error::Unauthorized)));
}
#[test] fn queries_report_retirement_and_drain_without_reopening_registration() {
    let (mut r,w,_)=started();r.begin_drain(seconds(1)).unwrap();
    assert_eq!(r.query_context(&query(4),seconds(2)).unwrap().availability,wire::Availability::Closing);
    r.abandon(w.context.player,seconds(3)).unwrap();let before=r.view();
    assert_eq!(r.query_context(&query(4),seconds(4)).unwrap().availability,wire::Availability::Retired);
    assert_eq!(r.view(),before);
    let q=wire::ClientMessage::ContextQuery(query(4));let log=q.public_log().to_string();
    assert!(!log.contains("recovery_key"));assert!(!format!("{q:?}").contains("[1, 1"));
}
