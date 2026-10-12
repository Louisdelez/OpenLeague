#[path="../crates/core/src/native_game_clock.rs"] mod native_game_clock;
use native_game_clock::{GameClock,PauseControl};
fn main(){
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,-1i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1796.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,0&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,false);
control.request_resume(&mut clock,None,[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,-1i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1796.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,1&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,false);
control.request_resume(&mut clock,Some(5.),[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,-1i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1796.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,2&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,false);
control.request_resume(&mut clock,None,[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,-1i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1796.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,3&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,false);
control.request_resume(&mut clock,Some(5.),[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,0i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1795.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,0&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,false);
control.request_resume(&mut clock,None,[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,0i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1795.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,1&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,false);
control.request_resume(&mut clock,Some(5.),[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,0i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1795.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,2&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,false);
control.request_resume(&mut clock,None,[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,0i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1795.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,3&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,false);
control.request_resume(&mut clock,Some(5.),[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,1i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1794.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,0&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,true);
control.request_resume(&mut clock,None,[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,1i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1794.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,1&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,true);
control.request_resume(&mut clock,Some(5.),[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,true);assert_eq!(control.remaining.to_bits(),1084227584);assert_eq!(clock.scale.to_bits(),0u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,1i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1794.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,2&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,true);
control.request_resume(&mut clock,None,[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,1i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,-1794.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,3&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,true);
control.request_resume(&mut clock,Some(5.),[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,true);assert_eq!(control.remaining.to_bits(),1084227584);assert_eq!(clock.scale.to_bits(),0u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,1800i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,5.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,0&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,true);
control.request_resume(&mut clock,None,[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,1800i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,5.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,1&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,true);
control.request_resume(&mut clock,Some(5.),[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,true);assert_eq!(control.remaining.to_bits(),1084227584);assert_eq!(clock.scale.to_bits(),0u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,1800i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,5.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,2&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,true);
control.request_resume(&mut clock,None,[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,false);assert_eq!(control.remaining.to_bits(),0);assert_eq!(clock.scale.to_bits(),4607182418800017408u64);}
{let mut clock=GameClock::default();let mut control=PauseControl{elapsed:5.,..Default::default()};
let adjustment=control.adjustment_for_remaining(1800.,1800i32 as f32,10000000,0,10000000).unwrap();assert_eq!(adjustment,5.0f32);
let accepted=control.request_pause(&mut clock,1800.,adjustment,3&1,[10000000;2],0,10000000).unwrap().is_some();assert_eq!(accepted,true);
control.request_resume(&mut clock,Some(5.),[15000000;2],0,10000000).unwrap();assert_eq!(control.paused,true);assert_eq!(control.remaining.to_bits(),1084227584);assert_eq!(clock.scale.to_bits(),0u64);}
println!("16 incoming pause/resume native sequences match Rust controller budget and transitions");}
