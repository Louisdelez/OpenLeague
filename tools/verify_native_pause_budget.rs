#[path="../crates/core/src/native_game_clock.rs"] mod native_game_clock;
use native_game_clock::{GameClock,PauseControl};
fn main(){
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case0");assert_eq!(control.marker,0);assert_eq!(control.paused,false);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case1");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case2");assert_eq!(control.marker,0);assert_eq!(control.paused,false);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case3");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case4");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case5");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case6");assert_eq!(control.marker,0);assert_eq!(control.paused,false);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case7");assert_eq!(control.marker,0);assert_eq!(control.paused,false);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case8");assert_eq!(control.marker,0);assert_eq!(control.paused,false);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case9");assert_eq!(control.marker,0);assert_eq!(control.paused,false);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case10");assert_eq!(control.marker,0);assert_eq!(control.paused,false);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case11");assert_eq!(control.marker,0);assert_eq!(control.paused,false);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case12");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case13");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case14");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case15");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case16");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case17");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case18");assert_eq!(control.marker,0);assert_eq!(control.paused,false);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case19");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case20");assert_eq!(control.marker,0);assert_eq!(control.paused,false);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case21");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case22");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case23");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case24");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case25");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case26");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case27");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case28");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case29");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case30");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case31");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case32");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case33");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case34");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:1.,..Default::default()};let mut control=PauseControl{paused:false,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,Some(0x12345678),"case35");assert_eq!(control.marker,0x78);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case36");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case37");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case38");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case39");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case40");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case41");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case42");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case43");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case44");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case45");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case46");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,0.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case47");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case48");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case49");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case50");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case51");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case52");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case53");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case54");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case55");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case56");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case57");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case58");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,1.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case59");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case60");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case61");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case62");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case63");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case64");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:0.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case65");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case66");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,-0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case67");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case68");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.0,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case69");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.0,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case70");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
{let mut game=GameClock{scale:0.,..Default::default()};let mut control=PauseControl{paused:true,pause_start:1.,elapsed:1.0,excluded:0.25,..Default::default()};
let notify=control.request_pause(&mut game,2.0,0.125,0x12345678,[15000000;2],0,10000000).unwrap();assert_eq!(notify,None,"case71");assert_eq!(control.marker,0);assert_eq!(control.paused,true);}
println!("72 native pause budget/notification cases match Rust");}
