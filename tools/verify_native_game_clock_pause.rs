#[path="../crates/core/src/native_game_clock.rs"] mod native_game_clock;
use native_game_clock::{GameClock,PauseControl};
fn check(g:&GameClock,p:&PauseControl,e:[u64;10],label:&str){assert_eq!([g.scale.to_bits(),p.pending_scale.to_bits() as u64,g.time.to_bits() as u64,g.delta.to_bits() as u64,p.drift.to_bits() as u64,p.paused as u64,p.resume_pending as u64,p.remaining.to_bits() as u64,p.elapsed.to_bits() as u64,p.excluded.to_bits() as u64],e,"{label}");}
fn main(){
{let mut g=GameClock{time:5.,delta:0.,scale:0.5};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4602678819172646912u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case0:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1056964608u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case0:pause");
p.set_scale(&mut g,0.25).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case0:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case0:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4598175219545276416u64,1048576000u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case0:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084293120u64,1023410176u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case0:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:0.5};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4602678819172646912u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case1:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1056964608u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case1:pause");
p.set_scale(&mut g,0.25).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case1:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case1:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case1:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case1:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case1:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084293120u64,1023410176u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case1:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:0.5};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4602678819172646912u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case2:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1056964608u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case2:pause");
p.set_scale(&mut g,1.0).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case2:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case2:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4607182418800017408u64,1065353216u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case2:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084489728u64,1040187392u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case2:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:0.5};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4602678819172646912u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case3:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1056964608u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case3:pause");
p.set_scale(&mut g,1.0).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case3:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case3:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case3:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case3:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case3:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084489728u64,1040187392u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case3:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:0.5};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4602678819172646912u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case4:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1056964608u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case4:pause");
p.set_scale(&mut g,1.23456789).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case4:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case4:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4608238818619817984u64,1067320914u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case4:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084551219u64,1042155090u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case4:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:0.5};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4602678819172646912u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case5:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1056964608u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case5:pause");
p.set_scale(&mut g,1.23456789).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case5:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case5:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case5:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case5:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case5:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084551219u64,1042155090u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case5:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607182418800017408u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case6:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case6:pause");
p.set_scale(&mut g,0.25).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case6:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case6:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4598175219545276416u64,1048576000u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case6:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084293120u64,1023410176u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case6:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607182418800017408u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case7:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case7:pause");
p.set_scale(&mut g,0.25).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case7:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case7:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case7:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case7:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case7:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084293120u64,1023410176u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case7:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607182418800017408u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case8:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case8:pause");
p.set_scale(&mut g,1.0).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case8:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case8:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4607182418800017408u64,1065353216u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case8:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084489728u64,1040187392u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case8:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607182418800017408u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case9:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case9:pause");
p.set_scale(&mut g,1.0).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case9:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case9:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case9:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case9:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case9:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084489728u64,1040187392u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case9:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607182418800017408u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case10:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case10:pause");
p.set_scale(&mut g,1.23456789).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case10:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case10:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4608238818619817984u64,1067320914u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case10:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084551219u64,1042155090u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case10:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607182418800017408u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case11:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case11:pause");
p.set_scale(&mut g,1.23456789).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case11:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case11:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case11:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case11:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case11:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084551219u64,1042155090u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case11:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.123456789};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607738418748954166u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case12:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1066388847u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case12:pause");
p.set_scale(&mut g,0.25).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case12:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case12:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4598175219545276416u64,1048576000u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case12:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084293120u64,1023410176u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case12:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.123456789};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607738418748954166u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case13:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1066388847u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case13:pause");
p.set_scale(&mut g,0.25).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case13:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case13:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case13:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case13:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case13:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084293120u64,1023410176u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case13:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.123456789};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607738418748954166u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case14:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1066388847u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case14:pause");
p.set_scale(&mut g,1.0).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case14:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case14:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4607182418800017408u64,1065353216u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case14:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084489728u64,1040187392u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case14:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.123456789};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607738418748954166u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case15:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1066388847u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case15:pause");
p.set_scale(&mut g,1.0).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case15:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case15:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case15:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case15:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case15:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084489728u64,1040187392u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case15:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.123456789};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607738418748954166u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case16:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1066388847u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case16:pause");
p.set_scale(&mut g,1.23456789).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case16:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case16:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4608238818619817984u64,1067320914u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case16:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084551219u64,1042155090u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case16:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:1.123456789};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4607738418748954166u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case17:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1066388847u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case17:pause");
p.set_scale(&mut g,1.23456789).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case17:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case17:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case17:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case17:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case17:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084551219u64,1042155090u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case17:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:2.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4611686018427387904u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case18:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1073741824u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case18:pause");
p.set_scale(&mut g,0.25).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case18:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case18:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4598175219545276416u64,1048576000u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case18:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084293120u64,1023410176u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case18:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:2.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4611686018427387904u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case19:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1073741824u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case19:pause");
p.set_scale(&mut g,0.25).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case19:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case19:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case19:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1048576000u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case19:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case19:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4598175219545276416u64,1048576000u64,1084293120u64,1023410176u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case19:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:2.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4611686018427387904u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case20:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1073741824u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case20:pause");
p.set_scale(&mut g,1.0).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case20:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case20:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4607182418800017408u64,1065353216u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case20:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084489728u64,1040187392u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case20:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:2.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4611686018427387904u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case21:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1073741824u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case21:pause");
p.set_scale(&mut g,1.0).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case21:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case21:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case21:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1065353216u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case21:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case21:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4607182418800017408u64,1065353216u64,1084489728u64,1040187392u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case21:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:2.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4611686018427387904u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case22:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1073741824u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case22:pause");
p.set_scale(&mut g,1.23456789).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case22:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case22:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,None,[counter;2],0,10000000).unwrap());
check(&g,&p,[4608238818619817984u64,1067320914u64,1084227584u64,0u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case22:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084551219u64,1042155090u64,3227516928u64,0u64,0u64,0u64,1056964608u64,0u64],"case22:resumed_frame");
}
{let mut g=GameClock{time:5.,delta:0.,scale:2.0};let mut p=PauseControl::default();let mut counter=10000000u64;
check(&g,&p,[4611686018427387904u64,0u64,1084227584u64,0u64,0u64,0u64,0u64,0u64,0u64,0u64],"case23:initial");
assert!(p.pause(&mut g,counter,0,10000000).unwrap());assert!(!p.pause(&mut g,counter,0,10000000).unwrap());
check(&g,&p,[0u64,1073741824u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case23:pause");
p.set_scale(&mut g,1.23456789).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case23:set_scale_while_paused");
for _ in 0..3{counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();}
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,0u64,0u64,0u64,0u64],"case23:paused_frames");
counter+=1250000;assert!(p.request_resume(&mut g,Some(0.25),[counter;2],0,10000000).unwrap());
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,1u64,1048576000u64,0u64,0u64],"case23:request_resume");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[0u64,1067320914u64,1084227584u64,0u64,0u64,1u64,1u64,1040187392u64,0u64,0u64],"case23:countdown_0");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084227584u64,0u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case23:countdown_1");
counter+=1250000;p.advance(&mut g,0.125,[counter;2],0,10000000).unwrap();
check(&g,&p,[4608238818619817984u64,1067320914u64,1084551219u64,1042155090u64,3226468352u64,0u64,0u64,0u64,1061158912u64,0u64],"case23:resumed_frame");
}
println!("24 native pause/scale/immediate+delayed resume sequences match physical Rust");}
