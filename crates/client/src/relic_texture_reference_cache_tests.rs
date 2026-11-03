use super::*;
#[test]
fn destroyed_resource_ids_are_unlinked_during_100000_balanced_lifetimes(){
 let mut cache=Cache::default();
 for id in 1..=100000u64 {
  assert_eq!(cache.acquire(0xdf8811a4,id).unwrap(),id);assert_eq!(cache.live_linked_len(),1);
  assert_eq!(cache.release(id).unwrap(),Release::Destroyed);assert_eq!(cache.live_linked_len(),0);assert_eq!(cache.len(),0);
 }
 assert!(cache.cleanup_renderer().unwrap().is_empty());
}
