//! Original announcer event plans. Alternative sets do not imply selection/playback.
use serde::Deserialize;
use std::collections::BTreeSet;
use crate::audio_selection::{Event,Container,Sound};
#[derive(Debug,Deserialize)]
pub struct Source {
    #[serde(flatten)] pub sound:Sound,
    pub plugin_id:u32,
    pub stream_type:u32,
}
#[derive(Debug,Deserialize)]
pub struct Bank {
    pub bank:String,
    pub events:Vec<Event>,
    pub containers:Vec<Container>,
    pub sounds:Vec<Source>,
}
#[derive(Debug,Deserialize)]
pub struct Catalog {pub banks:Vec<Bank>}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {InvalidGraph,UnknownBank,UnknownEvent(u32),UnknownSource(u32)}
#[derive(Debug)]
pub struct ActionPlan<'a> {
    pub action:&'a crate::audio_selection::Action,
    pub container:&'a Container,
    /// Preserve native playlist order and weights; no flat random substitute.
    pub alternatives:Vec<&'a Source>,
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum SourceKind {RecordedMedia(u32),GeneratedSilence {source:u32}}
impl Source {
    pub fn kind(&self)->Result<SourceKind,Error> {match self.plugin_id {
        262145=>Ok(SourceKind::RecordedMedia(self.sound.source)),
        6619138=>Ok(SourceKind::GeneratedSilence {source:self.sound.source}),
        _=>Err(Error::UnknownSource(self.sound.source)),
    }}
}
pub fn original_catalog()->Result<Catalog,Error> {
    let catalog:Catalog=serde_json::from_str(include_str!("../../../data/4.20/announcer_audio_graph.json")).map_err(|_|Error::InvalidGraph)?;
    for bank in &catalog.banks {
        fn unique(ids:impl Iterator<Item=u32>)->bool {let mut seen=BTreeSet::new();ids.into_iter().all(|id|seen.insert(id))}
        if !unique(bank.events.iter().map(|e|e.id))||!unique(bank.containers.iter().map(|c|c.id))||!unique(bank.sounds.iter().map(|s|s.sound.id)) {return Err(Error::InvalidGraph);}
        for event in &bank.events {catalog.plan(&bank.bank,event.id)?;}
        for source in &bank.sounds {source.kind()?;}
    }
    Ok(catalog)
}
impl Catalog {
    pub fn plan(&self,bank_path:&str,event_id:u32)->Result<Vec<ActionPlan<'_>>,Error> {
        let bank=self.banks.iter().find(|b|b.bank==bank_path).ok_or(Error::UnknownBank)?;
        let event=bank.events.iter().find(|e|e.id==event_id).ok_or(Error::UnknownEvent(event_id))?;
        event.actions.iter().map(|action| {
            let container=bank.containers.iter().find(|c|c.id==action.target).ok_or(Error::InvalidGraph)?;
            let alternatives=container.playlist.iter().map(|entry|bank.sounds.iter().find(|s|s.sound.id==entry.sound&&s.sound.parent==container.id).ok_or(Error::InvalidGraph)).collect::<Result<Vec<_>,_>>()?;
            if alternatives.is_empty() {return Err(Error::InvalidGraph);}
            Ok(ActionPlan {action,container,alternatives})
        }).collect()
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn every_native_event_resolves_to_its_original_playlist_and_recovered_or_generated_sources() {
        let catalog=original_catalog().unwrap();assert_eq!(catalog.banks.len(),4);
        let media:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/announcer_audio_manifest.json")).unwrap();
        let recovered:BTreeSet<_>=media["media"].as_array().unwrap().iter().map(|x|x["id"].as_u64().unwrap() as u32).collect();assert_eq!(recovered.len(),467);
        let(mut events,mut alternatives,mut generated)=(0,0,0);
        for bank in &catalog.banks {
            for event in &bank.events {
                events+=1;
                for plan in catalog.plan(&bank.bank,event.id).unwrap() {
                    for (entry,source) in plan.container.playlist.iter().zip(plan.alternatives) {
                        alternatives+=1;assert_eq!(entry.sound,source.sound.id);
                        match source.kind().unwrap() {SourceKind::RecordedMedia(id)=>assert!(recovered.contains(&id)),SourceKind::GeneratedSilence {source}=>{generated+=1;assert_eq!(source,950217071);assert!(!recovered.contains(&source));}}
                    }
                }
            }
        }
        assert_eq!((events,alternatives,generated),(470,545,1));
    }
    #[test]
    fn plans_retain_unsupported_shuffle_settings_instead_of_silently_normalizing() {
        let catalog=original_catalog().unwrap();
        let one_entry=catalog.banks.iter().flat_map(|b|&b.containers).filter(|c|c.random_mode==1&&c.avoid_repeat==1&&c.playlist.len()==1&&c.reset_each_play_raw).count();assert_eq!(one_entry,389);
        assert!(matches!(catalog.plan("missing",0),Err(Error::UnknownBank)));
        assert!(matches!(catalog.plan(&catalog.banks[0].bank,u32::MAX),Err(Error::UnknownEvent(u32::MAX))));
    }
}
