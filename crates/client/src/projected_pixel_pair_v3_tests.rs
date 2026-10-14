use super::*;
use crate::{relic_pickup_events::{Key,Binding},relic_pickup_seven_render::Ticket};
use crate::relic_pickup_seven_identity::{Group,GROUPS,Class};
fn ticket(draw:Entity,key:Key,index:usize)->Ticket{
 let group=GROUPS[index];
 let layout=crate::relic_pickup_seven_render::ExpectedImage{source:[8,8,1],storage:[8,8,1],mips:1,format:TextureFormat::Bc1RgbaUnorm};
 Ticket{key,owner:Binding{root:Entity::PLACEHOLDER,model:Handle::<Gltf>::default().id()},group,slot:0,birth:1,counter:(group.class()==Class::Complex).then_some(42),layouts:[layout;2],draw,mesh:Handle::<Mesh>::default().id(),material:Handle::<crate::nexus_glow_material::GlowMaterial>::default().id(),images:std::array::from_fn(|_|Handle::<Image>::default().id())}}


#[test]
fn pickup_pair_uses_current_visible_ticket_identity_and_one_request(){
 let mut world=World::new();let draws:Vec<_>=(0..10).map(|_|world.spawn_empty().id()).collect();
 let key=Key{session:10,pickup_tick:80,picker:21};let later=Key{pickup_tick:81,..key};
 let mut tickets:Vec<_>=(0..7).map(|group|ticket(draws[group],key,group)).collect();
 tickets.push(ticket(draws[7],later,0));tickets.push(ticket(draws[8],key,0));
 let mut malformed=ticket(draws[9],key,3);malformed.counter=None;tickets.push(malformed);
 let mut actual=tickets.clone();actual[8].birth=2;
 let visible=[true,true,false,true,true,true,true,true,true,true];
 let selected=selected_pickup(&tickets,false,|t|actual.iter().enumerate().any(|(i,a)|a==t&&visible[i]));
 assert_eq!(selected.iter().map(|t|t.group.index()).collect::<Vec<_>>(),vec![0,1,3,4,5,6]);
 assert!(selected.iter().all(|t|t.key==key));
 assert!(!selected.iter().any(|t|t.draw==draws[8] || t.draw==draws[9]));
 assert!(selected_pickup(&tickets,true,|_|true).is_empty());
 assert!(selected_pickup(&tickets,false,|_|false).is_empty());
}

#[test]
fn pickup_pair_gpu_header_preserves_request_and_camera_match(){
 let key=Key{session:0xabcdefff_12345678,pickup_tick:0x90123456_789abcde,picker:21};
 let pair=Pair{on:default(),off:default(),atlas:default(),time:1.25,draws:149,entity:0x99887766_55443322,effect_time:321.5_f32.to_bits(),paused:0,ready:false,pickup:true,main:Entity::PLACEHOLDER,cameras:[Entity::PLACEHOLDER;2],published_frames:0x11223344_55667788,key:Some(key),groups:0x7f};
 let words=header_words(&pair,87,true);let mut bytes=[0u8;256];for (i,word) in words.iter().enumerate(){bytes[i*4..i*4+4].copy_from_slice(&word.to_le_bytes());}
 let word=|i:usize|u32::from_le_bytes(bytes[i*4..i*4+4].try_into().unwrap());let wide=|i|word(i) as u64|((word(i+1) as u64)<<32);
 assert_eq!(HEADER_WORDS as usize,words.len());assert_eq!(word(0),0x4f4c5052);assert_eq!(word(1),87);assert_eq!(word(2),149);
 assert_eq!(wide(4),pair.entity);assert_eq!(word(6),321.5_f32.to_bits());assert_eq!(word(8),2);
 assert_eq!(wide(9),pair.published_frames);assert_eq!(wide(11),key.session);assert_eq!(wide(13),key.pickup_tick);assert_eq!(word(15),21);assert_eq!(word(16),0x7f);assert_eq!(word(17),1);
 assert_eq!(header_words(&pair,88,false)[17],0);
}

#[test]
fn pickup_atlas_files_are_bounded_by_request_despite_particle_entity_turnover(){
 // This is a decoder/journal fixture, not a GPU render receipt.
 let dir=std::env::temp_dir().join(format!("openleague-pickup-pair-test-{}-{}",std::process::id(),std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos()));std::fs::create_dir(&dir).unwrap();
 let path=dir.join("pair.json");let mut world=World::new();world.insert_resource(Results{path:path.clone(),rows:vec![],saved:default(),cleanup_saved:default(),pickup_saved:default(),pickup_cleanup_saved:default(),paused_frames:vec![]});
 let emitter=world.spawn_empty().id();world.entity_mut(emitter).observe(read);
 let key=Key{session:123,pickup_tick:6512,picker:21};
 let mut pair=Pair{on:default(),off:default(),atlas:default(),time:30.,draws:0,entity:0,effect_time:217.5_f32.to_bits(),paused:0,ready:false,pickup:true,main:Entity::PLACEHOLDER,cameras:[Entity::PLACEHOLDER;2],published_frames:400,key:None,groups:0};
 let mut send=|world:&mut World,pair:&Pair,frame:u32,changed:bool|{
  let mut data=vec![0u8;(W*2*(H+1)*4) as usize];if changed{data[0]=64;}
  let header=(W*2*H*4) as usize;for (i,word) in header_words(pair,frame,true).iter().enumerate(){data[header+i*4..header+i*4+4].copy_from_slice(&word.to_le_bytes());}
  world.trigger(ReadbackComplete{entity:emitter,data});
 };
 send(&mut world,&pair,10,false);
 pair.key=Some(key);pair.groups=0x7f;pair.draws=149;
 for frame in 11..14{pair.entity=u64::from(frame);pair.published_frames+=1;send(&mut world,&pair,frame,true);}
 pair.key=None;pair.groups=0;pair.draws=0;pair.entity=0;pair.published_frames+=1;
 send(&mut world,&pair,14,false);send(&mut world,&pair,15,false);
 let result=world.resource::<Results>();assert_eq!(result.pickup_saved.len(),1);assert_eq!(result.pickup_cleanup_saved.len(),1);
 assert!(result.rows[1]["rgba"].as_str().unwrap().ends_with("pickup-123-6512-21.rgba"));
 assert!(result.rows[2]["rgba"].is_null());assert!(result.rows[3]["rgba"].is_null());
 assert!(result.rows[4]["cleanup_rgba"].as_str().unwrap().ends_with("pickup-123-6512-21-clean.rgba"));assert!(result.rows[5]["cleanup_rgba"].is_null());
 assert_eq!(std::fs::read_dir(&dir).unwrap().filter_map(Result::ok).filter(|e|e.path().extension().is_some_and(|ext|ext=="rgba")).count(),3);
 for entry in std::fs::read_dir(&dir).unwrap(){std::fs::remove_file(entry.unwrap().path()).unwrap();}std::fs::remove_dir(dir).unwrap();
}
