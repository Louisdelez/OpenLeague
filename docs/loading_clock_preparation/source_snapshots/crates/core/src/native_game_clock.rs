//! Native99C410/99C5E0 clock source arithmetic, callback absent.
//! Source scheduling and platform-counter acquisition remain separate producers.
#[derive(Clone,Copy,Debug)]
pub struct GameClock { pub time:f32, pub delta:f32, pub scale:f64 }
impl Default for GameClock {fn default()->Self{Self{time:0.,delta:0.,scale:1.}}}
impl GameClock {
 /// Native resync branch with a supplied wall-time sample; returns true when
 /// accumulated time is corrected, false when the drift reference is reset.
 pub fn advance_resync(&mut self,source_delta:f64,wall:f64,drift:&mut f32)->Result<bool,&'static str>{
  if !wall.is_finite() || !drift.is_finite(){return Err("nonfinite game clock resync input is unqualified");}
  let mut next=*self;next.advance_normal(source_delta)?;
  #[cfg(any(target_arch="x86",target_arch="x86_64"))]
  {
   let control=0x037fu16;let mut saved=0u16;let mut observed=0f32;let mut error=0f32;
   unsafe{core::arch::asm!(
    "fnstcw word ptr [{saved}]","fldcw word ptr [{control}]",
    "fld qword ptr [{wall}]","fsub dword ptr [{time}]","fst dword ptr [{observed}]",
    "fsub dword ptr [{drift}]","fstp dword ptr [{error}]","fldcw word ptr [{saved}]",
    saved=in(reg)&mut saved,control=in(reg)&control,wall=in(reg)&wall,time=in(reg)&next.time,
    observed=in(reg)&mut observed,drift=in(reg)&*drift,error=in(reg)&mut error,out("st(0)") _,options(nostack));}
   if !observed.is_finite() || !error.is_finite(){return Err("game clock resync overflow is unqualified");}
   // Native upper comparison retains f64 scale; lower comparison uses f32.
   let corrected=next.scale<=f32::from_bits(0x3f800008) as f64 && next.scale as f32>=f32::from_bits(0x3f7fffef) && error>=0.;
   if corrected {next.time+=error;}
   if !next.time.is_finite(){return Err("game clock resync result overflow is unqualified");}
   if !corrected {*drift=observed;}*self=next;Ok(corrected)
  }
  #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
  {Err("native game clock resync is unqualified on this architecture")}
 }
 /// Native993CE0 counter conversion composed with resync, without a f64 wall-time store.
 pub fn advance_counter(&mut self,source_delta:f64,counter:u64,origin:u64,frequency:u64,drift:&mut f32)->Result<bool,&'static str>{
  if frequency==0 || !drift.is_finite(){return Err("nonfinite game clock resync input is unqualified");}
  let mut next=*self;next.advance_normal(source_delta)?;
  #[cfg(any(target_arch="x86",target_arch="x86_64"))]
  {
   let elapsed=counter.wrapping_sub(origin);
   let integers=[(elapsed&0x7fff_ffff_ffff_ffff) as i64,(elapsed&0x8000_0000_0000_0000) as i64,(frequency&0x7fff_ffff_ffff_ffff) as i64,(frequency&0x8000_0000_0000_0000) as i64];
   let control=0x037fu16;let mut saved=0u16;let mut observed=0f32;let mut error=0f32;
   unsafe{core::arch::asm!(
    "fnstcw word ptr [{saved}]","fldcw word ptr [{control}]",
    "fild qword ptr [{integers}]","fild qword ptr [{integers}+8]","fchs","faddp st(1), st(0)",
    "fild qword ptr [{integers}+16]","fild qword ptr [{integers}+24]","fchs","faddp st(1), st(0)",
    "fdivp st(1), st(0)","fsub dword ptr [{time}]","fst dword ptr [{observed}]",
    "fsub dword ptr [{drift}]","fstp dword ptr [{error}]","fldcw word ptr [{saved}]",
    saved=in(reg)&mut saved,control=in(reg)&control,integers=in(reg)integers.as_ptr(),time=in(reg)&next.time,
    observed=in(reg)&mut observed,drift=in(reg)&*drift,error=in(reg)&mut error,out("st(0)") _,out("st(1)") _,out("st(2)") _,options(nostack));}
   if !observed.is_finite() || !error.is_finite(){return Err("game clock resync overflow is unqualified");}
   // Native upper comparison retains f64 scale; lower comparison uses f32.
   let corrected=next.scale<=f32::from_bits(0x3f800008) as f64 && next.scale as f32>=f32::from_bits(0x3f7fffef) && error>=0.;
   if corrected {next.time+=error;}
   if !next.time.is_finite(){return Err("game clock resync result overflow is unqualified");}
   if !corrected {*drift=observed;}*self=next;Ok(corrected)
  }
  #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
  {Err("native game clock resync is unqualified on this architecture")}
 }
 pub fn sample(&self)->f64{self.time as f64}
 pub fn delta(&self)->f64{self.delta as f64}
 pub fn advance_normal(&mut self,source_delta:f64)->Result<(),&'static str>{
  if !source_delta.is_finite() || !self.scale.is_finite() || !self.time.is_finite(){return Err("nonfinite game clock input is unqualified");}
  #[cfg(any(target_arch="x86",target_arch="x86_64"))]
  {
   let control=0x037fu16;let mut saved=0u16;let mut delta=0f32;let mut time=0f32;
   // Keep the scaled delta extended for the addition; storing delta does not pop.
   unsafe{core::arch::asm!(
    "fnstcw word ptr [{saved}]","fldcw word ptr [{control}]",
    "fld qword ptr [{input}]","fmul qword ptr [{scale}]","fst dword ptr [{delta}]",
    "fadd dword ptr [{previous}]","fstp dword ptr [{time}]","fldcw word ptr [{saved}]",
    saved=in(reg)&mut saved,control=in(reg)&control,input=in(reg)&source_delta,scale=in(reg)&self.scale,
    delta=in(reg)&mut delta,previous=in(reg)&self.time,time=in(reg)&mut time,out("st(0)") _,options(nostack));}
   if !time.is_finite() || !delta.is_finite(){return Err("game clock overflow is unqualified");}
   self.time=time;self.delta=delta;Ok(())
  }
  #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
  {Err("native game clock arithmetic is unqualified on this architecture")}
 }
}

/// Native586350 normal frame delta. `frame_start` is the f32 wall sample
/// written by58D550 before frame work, not necessarily the previous update.
/// Platform acquisition, limiter and frame scheduling are caller responsibilities.
pub fn frame_delta(counter:u64,origin:u64,frequency:u64,frame_start:f32)->Result<f64,&'static str>{
 Ok(counter_difference(counter,origin,frequency,frame_start)?.max(f32::from_bits(0x3983126f)) as f64)
}
/// Native wall counter stored to f32 at the frame boundary.
pub fn wall_sample(counter:u64,origin:u64,frequency:u64)->Result<f32,&'static str>{
 counter_difference(counter,origin,frequency,0.)
}
fn counter_difference(counter:u64,origin:u64,frequency:u64,frame_start:f32)->Result<f32,&'static str>{
 counter_difference_two(counter,origin,frequency,frame_start,0.)
}
fn counter_difference_two(counter:u64,origin:u64,frequency:u64,frame_start:f32,excluded:f32)->Result<f32,&'static str>{
 if frequency==0 || !frame_start.is_finite() || !excluded.is_finite(){return Err("invalid native frame source");}
 #[cfg(any(target_arch="x86",target_arch="x86_64"))]
 {
  let elapsed=counter.wrapping_sub(origin);
  let integers=[(elapsed&0x7fff_ffff_ffff_ffff) as i64,(elapsed&0x8000_0000_0000_0000) as i64,(frequency&0x7fff_ffff_ffff_ffff) as i64,(frequency&0x8000_0000_0000_0000) as i64];
  let control=0x037fu16;let mut saved=0u16;let mut delta=0f32;
  unsafe{core::arch::asm!(
   "fnstcw word ptr [{saved}]","fldcw word ptr [{control}]",
   "fild qword ptr [{integers}]","fild qword ptr [{integers}+8]","fchs","faddp st(1), st(0)",
   "fild qword ptr [{integers}+16]","fild qword ptr [{integers}+24]","fchs","faddp st(1), st(0)",
   "fdivp st(1), st(0)","fsub dword ptr [{start}]","fsub dword ptr [{excluded}]","fstp dword ptr [{delta}]","fldcw word ptr [{saved}]",
   saved=in(reg)&mut saved,control=in(reg)&control,integers=in(reg)integers.as_ptr(),start=in(reg)&frame_start,excluded=in(reg)&excluded,
   delta=in(reg)&mut delta,out("st(0)") _,out("st(1)") _,out("st(2)") _,options(nostack));}
  if !delta.is_finite(){return Err("native frame delta overflow");}
  Ok(delta)
 }
 #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
 {Err("native frame arithmetic is unqualified on this architecture")}
}

/// Native99C940/99CA20/99CA80/99CAE0 finite controller state.
/// UI authorization and external notification callbacks belong to the caller.
#[derive(Clone,Copy,Debug,Default)]
pub struct PauseControl {
 pub paused:bool,pub resume_pending:bool,pub remaining:f32,
 pub pending_scale:f32,pub pause_start:f32,pub excluded:f32,
 pub elapsed:f32,pub drift:f32,pub marker:u8,
}
impl PauseControl {
 /// Native99CB70: translate authoritative remaining seconds into the
 /// controller budget adjustment. Do not treat this as request authorization.
 pub fn adjustment_for_remaining(&self,total:f32,remaining:f32,counter:u64,origin:u64,frequency:u64)->Result<f32,&'static str>{
  if !total.is_finite() || !remaining.is_finite() || !self.elapsed.is_finite(){return Err("invalid authoritative pause budget");}
  let used=if self.paused {counter_difference_two(counter,origin,frequency,self.pause_start,-self.elapsed)?} else {self.elapsed};
  let adjustment=remaining-(total-used);
  if !adjustment.is_finite(){return Err("authoritative pause budget overflow");}Ok(adjustment)
 }
 /// Native99C990 budget arithmetic. Total/adjustment are supplied config/state,
 /// not hardcoded authorization. Ongoing pause cost retains x87 until f32 store.
 pub fn remaining_budget(&self,total:f32,adjustment:f32,counter:u64,origin:u64,frequency:u64)->Result<f32,&'static str>{
  if !total.is_finite() || !adjustment.is_finite() || !self.elapsed.is_finite() || !self.excluded.is_finite(){return Err("invalid pause budget");}
  let used=if self.paused {counter_difference_two(counter,origin,frequency,self.pause_start,-self.elapsed)?} else {self.elapsed};
  let remaining=((total-used)+adjustment)+self.excluded;
  if !remaining.is_finite(){return Err("pause budget overflow");}Ok(remaining)
 }
 /// Native99C990 request gate. Some(value) is the full32-bit notification
 /// argument; the stored marker uses only its low byte. None emits no callback.
 /// Caller must separately enforce game-mode/player authorization.
 pub fn request_pause(&mut self,clock:&mut GameClock,total:f32,adjustment:f32,marker:u32,counters:[u64;2],origin:u64,frequency:u64)->Result<Option<u32>,&'static str>{
  if self.remaining_budget(total,adjustment,counters[0],origin,frequency)?<=0. {return Ok(None);}
  if !self.pause(clock,counters[1],origin,frequency)? {return Ok(None);}
  self.marker=marker as u8;Ok(Some(marker))
 }
 /// Native99C4F0. Return value is the f32 argument for the scale notification.
 pub fn set_scale(&mut self,clock:&mut GameClock,value:f64)->Result<f32,&'static str>{
  let rounded=value as f32;
  if !value.is_finite() || !rounded.is_finite() || !clock.scale.is_finite(){return Err("invalid clock scale transition");}
  if clock.scale==0. {self.pending_scale=rounded;} else {clock.scale=value;}
  Ok(rounded)
 }
 pub fn pause(&mut self,clock:&mut GameClock,counter:u64,origin:u64,frequency:u64)->Result<bool,&'static str>{
  if self.paused{return Ok(false);}
  let start=wall_sample(counter,origin,frequency)?;
  let pending=clock.scale as f32;
  if !pending.is_finite(){return Err("invalid pause scale");}
  self.pause_start=start;self.paused=true;self.resume_pending=false;
  if clock.scale!=0. {self.pending_scale=pending;clock.scale=0.;}
  Ok(true)
 }
 /// `counters` supplies the two native QPC reads separately: accounting, drift.
 pub fn resume(&mut self,clock:&mut GameClock,counters:[u64;2],origin:u64,frequency:u64)->Result<(),&'static str>{
  let interval=counter_difference_two(counters[0],origin,frequency,self.pause_start,self.excluded)?;
  let elapsed=self.elapsed+interval.max(0.);
  if !elapsed.is_finite() || !self.pending_scale.is_finite(){return Err("invalid pause accounting");}
  let drift=if clock.scale==0. {counter_difference(counters[1],origin,frequency,clock.time)?} else {self.drift};
  self.paused=false;self.resume_pending=false;self.remaining=0.;self.excluded=0.;self.elapsed=elapsed;self.marker=0;
  if clock.scale==0. {clock.scale=self.pending_scale as f64;self.drift=drift;}
  Ok(())
 }
 /// None resumes immediately; Some(duration) requests the native countdown.
 pub fn request_resume(&mut self,clock:&mut GameClock,delay:Option<f32>,counters:[u64;2],origin:u64,frequency:u64)->Result<bool,&'static str>{
  if !self.paused{return Ok(false);}
  if let Some(duration)=delay {
   if !duration.is_finite(){return Err("invalid resume duration");}
   if self.remaining<=0. {self.remaining=duration;}
   self.resume_pending=true;
  } else {self.resume(clock,counters,origin,frequency)?;}
  Ok(true)
 }
 /// Compose99C5E0 with its zero-scale callback99CA80. Countdown uses unscaled dt.
 pub fn advance(&mut self,clock:&mut GameClock,delta:f64,counters:[u64;2],origin:u64,frequency:u64)->Result<(),&'static str>{
  let mut next=*self;let mut game=*clock;game.advance_normal(delta)?;
  if game.scale==0. && next.paused && next.resume_pending {
   let rounded=delta as f32;if !rounded.is_finite(){return Err("invalid pause delta");}
   if next.remaining>0. {next.remaining-=rounded;}
   if next.remaining<=0. {next.resume(&mut game,counters,origin,frequency)?;}
  }
  *self=next;*clock=game;Ok(())
 }
}
