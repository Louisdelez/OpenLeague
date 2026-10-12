//! Original938900 dispatcher; physical update bodies remain caller-owned.
#[derive(Debug,Copy,Clone)]
pub struct State {pub last_time:f32,pub initialized_particles:u32}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub enum Event {Movement {time_bits:u32,flag1:u8,flag2:u8},Surface {time_bits:u32,flag1:u8},Color {time_bits:u32},NewParticle {index:u32}}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub enum Error {CountOutOfRange}
/// Preserve native callback order and finish clock writes after callbacks. This
/// qualified path assumes callbacks do not change the particle count.
pub fn dispatch(time:f32,flags:u8,kind:i32,count:u32,state:&mut State,mut callback:impl FnMut(Event))->Result<bool,Error> {
    if count>i32::MAX as u32 || state.initialized_particles>i32::MAX as u32 {return Err(Error::CountOutOfRange);}
    if time==state.last_time {return Ok(false);}
    let flag1=(flags>>1)&1;
    let flag2=u8::from(flags&4!=0 && matches!(kind,1|3|11));
    callback(Event::Movement {time_bits:time.to_bits(),flag1,flag2});
    callback(Event::Surface {time_bits:time.to_bits(),flag1});
    callback(Event::Color {time_bits:time.to_bits()});
    for index in state.initialized_particles..count {callback(Event::NewParticle {index});}
    state.initialized_particles=count;state.last_time=time;
    Ok(true)
}
#[cfg(test)]
mod tests {
    use super::*;
    fn bits(v:&serde_json::Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn original_frame_skip_callback_arguments_order_and_state_match() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/complex_frame_dispatch_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),1920);
        for row in proof["cases"].as_array().unwrap() {
            let mut state=State {last_time:f32::from_bits(bits(&row["last"])),initialized_particles:row["old_count"].as_u64().unwrap() as u32};
            let mut events=Vec::new();
            dispatch(f32::from_bits(bits(&row["time"])),row["flags"].as_u64().unwrap() as u8,row["kind"].as_i64().unwrap() as i32,row["count"].as_u64().unwrap() as u32,&mut state,|event|events.push(match event {
                Event::Movement {time_bits,flag1,flag2}=>serde_json::json!({"kind":"movement","time":format!("{time_bits:#x}"),"flag1":flag1,"flag2":flag2}),
                Event::Surface {time_bits,flag1}=>serde_json::json!({"kind":"surface","time":format!("{time_bits:#x}"),"flag1":flag1}),
                Event::Color {time_bits}=>serde_json::json!({"kind":"color","time":format!("{time_bits:#x}")}),
                Event::NewParticle {index}=>serde_json::json!({"kind":"new","index":index}),
            })).unwrap();
            assert_eq!(events,row["events"].as_array().unwrap().to_vec(),"{row}");
            assert_eq!(state.last_time.to_bits(),bits(&row["new_time"]),"{row}");
            assert_eq!(state.initialized_particles,row["new_count"].as_u64().unwrap() as u32,"{row}");
        }
    }
}
