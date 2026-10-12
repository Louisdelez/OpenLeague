//! Native min-heap entries: source identity plus an opaque f32 priority.
//! Priority production and gameplay scheduling are not qualified here.
#[derive(Clone,Debug,PartialEq)]
pub struct Entry {pub source:usize,pub priority_bits:u32}
#[derive(Default)]
pub struct PendingSources {entries:Vec<Entry>}
impl PendingSources {
    pub fn entries(&self)->&[Entry] {&self.entries}
    fn insert_at_hole(&mut self,mut hole:usize,value:Entry) {
        while hole>0 {
            let parent=(hole-1)/2;
            // Native COMISS/JBE also stops on unordered (NaN) comparisons.
            if !(f32::from_bits(self.entries[parent].priority_bits)>f32::from_bits(value.priority_bits)) {break;}
            self.entries[hole]=self.entries[parent].clone();hole=parent;
        }
        self.entries[hole]=value;
    }
    pub fn push(&mut self,entry:Entry) {
        let hole=self.entries.len();self.entries.push(entry.clone());self.insert_at_hole(hole,entry);
    }
    pub fn pop(&mut self)->Option<Entry> {
        let first=self.entries.first()?.clone();let value=self.entries.pop().unwrap();let length=self.entries.len();
        if length==0 {return Some(first);}
        let mut hole=0;let mut child=2;
        while child<length {
            if f32::from_bits(self.entries[child].priority_bits)>f32::from_bits(self.entries[child-1].priority_bits) {child-=1;}
            self.entries[hole]=self.entries[child].clone();hole=child;child=hole*2+2;
        }
        if child==length {self.entries[hole]=self.entries[length-1].clone();hole=length-1;}
        self.insert_at_hole(hole,value);Some(first)
    }
    /// Native view callback drains and rebuilds; retaining array order differs on ties.
    pub fn retire(&mut self,source:usize) {
        let mut retained=Vec::with_capacity(self.entries.len());
        while let Some(entry)=self.pop() {if entry.source!=source {retained.push(entry);}}
        for entry in retained {self.push(entry);}
    }
}
#[cfg(test)] mod tests {
    use super::*;
    fn expected(value:&serde_json::Value)->Vec<Entry> {
        value.as_array().unwrap().iter().map(|v|Entry {source:v["identity"].as_u64().unwrap() as usize,priority_bits:v["priority_bits"].as_u64().unwrap() as u32}).collect()
    }
    #[test] fn pending_insertion_and_removal_match_original_heap_including_ties_and_nan() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_pending_release_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),192);
        for c in proof["cases"].as_array().unwrap() {
            let mut pending=PendingSources::default();
            for source in c["pattern"].as_array().unwrap() {
                let identity=source.as_u64().unwrap() as usize;
                pending.push(Entry {source:identity,priority_bits:c["priorities"][identity].as_u64().unwrap() as u32});
            }
            assert_eq!(pending.entries(),expected(&c["initial_pending"]),"initial {c}");
            for step in c["steps"].as_array().unwrap() {
                for _ in 0..c["observers"].as_u64().unwrap() {pending.retire(step["removed"].as_u64().unwrap() as usize);}
                assert_eq!(pending.entries(),expected(&step["pending"]),"retirement {c}");
            }
        }
    }
}
