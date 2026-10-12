//! Registered audio-object source storage from B09FE0/AF6400/AEEDC0.
//! Registration, worker scheduling and heap implementation remain separate.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct RawSource { pub words:[u32;6] }
impl RawSource {
    pub fn position(self)->[f32;3] {
        [f32::from_bits(self.words[0]),f32::from_bits(self.words[1]),f32::from_bits(self.words[2])]
    }
    pub fn from_point(update:crate::audio_emitter_position::PositionUpdate,opaque_tail:[u32;3])->Self {
        Self {words:update.native_words(opaque_tail)}
    }
}
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct RegisteredSources {
    sources:Vec<RawSource>,
    pub mode_raw:u8,
    pub listener_mask:u8,
    pub dirty_flags:u32,
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Error {TooManySources}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Outcome {
    pub manager_result:u32,
    // Original manager ignores the storage error, but retain it diagnostically.
    pub storage_result:Option<u32>,
}
impl RegisteredSources {
    /// Explicit state restoration; this does not invent native constructor defaults.
    pub fn restore(sources:Vec<RawSource>,mode_raw:u8,listener_mask:u8,dirty_flags:u32)->Result<Self,Error> {
        if sources.len()>u16::MAX as usize {return Err(Error::TooManySources);}
        Ok(Self {sources,mode_raw,listener_mask,dirty_flags})
    }
    pub fn sources(&self)->&[RawSource] {&self.sources}
    pub fn positions(&self)->Vec<[f32;3]> {self.sources.iter().map(|s|s.position()).collect()}
    fn replace_with<F>(&mut self,input:&[RawSource],mode:u8,allocate:F)->Result<Outcome,Error>
    where F:FnOnce(usize)->Result<Vec<RawSource>,()> {
        if input.len()>u16::MAX as usize {return Err(Error::TooManySources);}
        let mut status=1;
        if self.sources.len()!=input.len() {
            // Native frees the old allocation before attempting the new one.
            self.sources=Vec::new();
            if !input.is_empty() {
                match allocate(input.len()) {
                    Ok(buffer)=>self.sources=buffer,
                    Err(())=>status=52,
                }
            }
        }
        if status==1 {
            if self.sources.len()==input.len() {self.sources.copy_from_slice(input);}
            else {self.sources.extend_from_slice(input);}
        }
        self.mode_raw=(self.mode_raw&0xf8)|(mode&7);
        self.dirty_flags|=0x40000000;
        Ok(Outcome {manager_result:1,storage_result:Some(status)})
    }
    pub fn nearest_distance(&self,listeners:&[crate::audio_distance::Listener;8])->Result<f32,crate::audio_distance::Error> {
        let positions=self.positions();
        crate::audio_distance::nearest(crate::audio_distance::Sources {positions:&positions,mode_raw:self.mode_raw},listeners,self.listener_mask)
    }
}
/// Existing object receives all six raw words per source. Missing object returns2.
/// No object creation or inferred source orientation occurs here.
pub fn apply_registered(object:Option<&mut RegisteredSources>,input:&[RawSource],mode:u8)->Result<Outcome,Error> {
    let Some(object)=object else {return Ok(Outcome {manager_result:2,storage_result:None});};
    object.replace_with(input,mode,|count| {
        let mut buffer=Vec::new();
        buffer.try_reserve_exact(count).map_err(|_|())?;
        Ok(buffer)
    })
}
#[cfg(test)]
mod tests {
    use super::*;
    #[derive(serde::Deserialize)]
    struct Case {
        found:bool,old_mode:u8,prior_dirty:u32,mode:u8,allocation_failure:bool,
        input_words:Vec<[u32;6]>,prior_words:Vec<[u32;6]>,stored_words:Vec<[u32;6]>,
        stored_count:usize,stored_mode:u8,stored_mask:u8,stored_dirty:u32,
        manager_result:u32,storage_result:Option<u32>,
    }
    #[derive(serde::Deserialize)]
    struct Contract {cases:Vec<Case>,queue13_cases:Vec<Case>}
    #[test]
    fn original_hash_lookup_storage_modes_and_allocation_failure_match() {
        let contract:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_source_storage_contract.json")).unwrap();
        assert_eq!(contract.cases.len(),720);assert_eq!(contract.queue13_cases.len(),48);
        for c in contract.cases.into_iter().chain(contract.queue13_cases) {
            let mut object=RegisteredSources::restore(c.prior_words.into_iter().map(|words|RawSource {words}).collect(),c.old_mode,0x81,c.prior_dirty).unwrap();
            let input:Vec<_>=c.input_words.into_iter().map(|words|RawSource {words}).collect();
            let result=if c.found {
                object.replace_with(&input,c.mode,|n| {
                    if c.allocation_failure {Err(())} else {Ok(Vec::with_capacity(n))}
                }).unwrap()
            } else {apply_registered(None,&input,c.mode).unwrap()};
            assert_eq!(result,Outcome {manager_result:c.manager_result,storage_result:c.storage_result});
            assert_eq!(object.sources.len(),c.stored_count);
            assert_eq!(object.sources.iter().map(|s|s.words).collect::<Vec<_>>(),c.stored_words);
            assert_eq!(object.mode_raw,c.stored_mode);assert_eq!(object.listener_mask,c.stored_mask);assert_eq!(object.dirty_flags,c.stored_dirty);
        }
    }
    #[test]
    fn point_producer_storage_and_native_distance_keep_opaque_tail_out_of_geometry() {
        let update=crate::audio_emitter_position::dispatch(
            Some(crate::audio_routing::VoiceRoute {object_id:123,actor_id:0}),true,[7400.,1500.,7700.]).unwrap().position_update.unwrap();
        let input=RawSource::from_point(update,[0x7fc00000,0xdeadbeef,0x80000000]);
        let mut object=RegisteredSources::restore(Vec::new(),0xa5,1,0x12345678).unwrap();
        assert_eq!(apply_registered(Some(&mut object),&[input],0).unwrap().manager_result,1);
        assert_eq!(object.mode_raw,0xa0);assert_eq!(object.sources()[0].words[3],0x7fc00000);
        let listeners=[crate::audio_distance::Listener {position:[7400.,500.,7700.],distance_scale:1.};8];
        assert_eq!(object.nearest_distance(&listeners).unwrap(),1000.);
        let before=object.clone();
        let huge=vec![input;65536];
        assert_eq!(apply_registered(Some(&mut object),&huge,7),Err(Error::TooManySources));
        assert_eq!(object,before);
    }
}