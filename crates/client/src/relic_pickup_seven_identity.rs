//! Transport identity preserves the authored global group order and emitter class.
#[derive(Debug,Clone,Copy,PartialEq,Eq,Hash)]pub enum Class {Simple,Complex}
#[derive(Debug,Clone,Copy,PartialEq,Eq,Hash)]
pub enum Group {HealStarTrail,HealMesh,HealBolts1,HealBolts2,HealLittleRay,ManaStarSwirl,ManaShafts}
pub const GROUPS:[Group;7]=[Group::HealStarTrail,Group::HealMesh,Group::HealBolts1,Group::HealBolts2,Group::HealLittleRay,Group::ManaStarSwirl,Group::ManaShafts];
impl Group {
    pub fn index(self)->usize {GROUPS.iter().position(|g|*g==self).unwrap()}
    pub fn class(self)->Class {match self {Self::HealBolts1|Self::HealBolts2|Self::HealLittleRay=>Class::Complex,_=>Class::Simple}}
    pub fn name(self)->&'static str {match self {Self::HealStarTrail=>"starTrailspin",Self::HealMesh=>"mesh",Self::HealBolts1=>"bolts_1",Self::HealBolts2=>"bolts_2",Self::HealLittleRay=>"littleray",Self::ManaStarSwirl=>"starswirl",Self::ManaShafts=>"shafts"}}
    pub fn simple_index(self)->Option<usize>{match self {Self::HealStarTrail=>Some(0),Self::HealMesh=>Some(1),Self::ManaStarSwirl=>Some(2),Self::ManaShafts=>Some(3),_=>None}}
    pub fn complex_index(self)->Option<usize>{match self {Self::HealBolts1=>Some(0),Self::HealBolts2=>Some(1),Self::HealLittleRay=>Some(2),_=>None}}
}
