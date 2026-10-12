//! Original7184B0 sorted inactive identity queue. Non-owning: no voice disposal.
#[derive(Debug,Default,Clone)]
pub struct InactiveQueue {identities:Vec<u32>}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Change {Inserted,Removed,Unchanged}
impl InactiveQueue {
    /// Original queue may contain duplicates. Reject unsorted source state.
    pub fn from_sorted(identities:Vec<u32>)->Result<Self,&'static str> {
        if identities.windows(2).any(|w|w[0]>w[1]) {return Err("unsorted inactive identity queue");}
        Ok(Self {identities})
    }
    pub fn identities(&self)->&[u32] {&self.identities}
    /// Active removes one occurrence. Inactive inserts only if none exists.
    /// Keep all other duplicates and original unsigned identity ordering.
    pub fn update(&mut self,identity:u32,active_raw:u8)->Change {
        let position=self.identities.partition_point(|id|*id<identity);
        let found=self.identities.get(position)==Some(&identity);
        if active_raw!=0 {
            if found {self.identities.remove(position);Change::Removed} else {Change::Unchanged}
        } else if found {Change::Unchanged}
        else {self.identities.insert(position,identity);Change::Inserted}
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_105_original_queue_cases_including_duplicates_and_repeated_transitions() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_inactive_queue_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),105);
        for c in cases {
            let initial=c["initial"].as_array().unwrap().iter().map(|id|id.as_u64().unwrap() as u32).collect();let mut queue=InactiveQueue::from_sorted(initial).unwrap();
            for output in c["outputs"].as_array().unwrap() {
                queue.update(c["identity"].as_u64().unwrap() as u32,c["active_raw"].as_u64().unwrap() as u8);
                let expected:Vec<_>=output.as_array().unwrap().iter().map(|id|id.as_u64().unwrap() as u32).collect();assert_eq!(queue.identities(),expected);
            }
        }
    }
    #[test]
    fn unsigned_id_boundaries_and_activity_do_not_dispose_owners() {
        assert!(InactiveQueue::from_sorted(vec![2,1]).is_err());
        let mut queue=InactiveQueue::from_sorted(vec![0,0x80000000,u32::MAX,u32::MAX]).unwrap();
        assert_eq!(queue.update(u32::MAX,255),Change::Removed);assert_eq!(queue.identities(),[0,0x80000000,u32::MAX]);
        assert_eq!(queue.update(1,0),Change::Inserted);assert_eq!(queue.update(1,0),Change::Unchanged);assert_eq!(queue.identities(),[0,1,0x80000000,u32::MAX]);
        let mut emitter=crate::audio_requests::Emitter::new(String::new(),"persistent".into());emitter.ensure_persistent(crate::audio_requests::Context {clock:0.,birth:0.,position:[1.,2.,3.]},|_|42).unwrap();
        queue.update(42,0);assert_eq!(emitter.logical_handle(),42);
    }
}
