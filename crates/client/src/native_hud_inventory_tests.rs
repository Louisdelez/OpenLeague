use super::*;
use openleague_core::{Action, Navigation, ServerPacket, Simulation, Snapshot};

fn root()->std::path::PathBuf {std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..")}
fn source_hud()->StartupHud {let root=root();crate::native_zip_provider::Provider::from_catalog(&root).unwrap().startup_hud(&root).unwrap()}
fn game()->(Simulation,u32) {
    let root=root();let nav=Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
    let mut game=Simulation::new(nav).unwrap();game.enable_map10().unwrap();let id=game.join("garen").unwrap();(game,id)
}
fn received(game:&Simulation)->Snapshot {
    let snapshot=game.snapshot();let mut assembler=openleague_core::wire::StateAssembler::default();let mut result=None;
    for bytes in openleague_core::wire::state_datagrams(&snapshot).unwrap() {if let Some(bytes)=assembler.push(&bytes,Some(snapshot.session)){result=Some(bytes);}}
    let ServerPacket::State(snapshot)=serde_json::from_slice(&result.unwrap()).unwrap() else {panic!("state required")};snapshot
}
fn slots(game:&Simulation,id:u32)->[Option<Slot>;6] {values(&received(game),Some(id)).unwrap().unwrap()}

#[test]
fn original_six_slots_counts_and_all_playable_dds_are_used_without_replacement() {
    let (panels,counts)=sources(&source_hud()).unwrap();assert_eq!(panels.len(),6);assert_eq!(counts.len(),6);
    for (index,panel) in panels.iter().enumerate() {
        assert_eq!(panel.name,format!("InventoryItem{index}"));assert_eq!(panel.storage.flags()&1,0);assert_eq!(panel.storage.word(0x1a4),4);
        assert_eq!(counts[index].slot,index);assert_eq!(counts[index].storage.flags()&1,0);assert_eq!(counts[index].storage.word(0x1a4),6);
        assert_eq!(counts[index].storage.word(0x200),counts[index].binding as u32+1);
        assert_eq!(std::array::from_fn::<_,4,_>(|n|f32::from_bits(panel.storage.word(0x204+n*4))),[0.,0.,1.,1.]);
    }
    let catalog:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_inventory_icons.json")).unwrap();
    let entries=catalog["entries"].as_array().unwrap();assert_eq!(entries.len(),openleague_core::shop::catalog().len());assert_eq!(entries.len(),32);
    for item in openleague_core::shop::catalog() {
        let matching=entries.iter().filter(|entry|entry["id"]==item.id).collect::<Vec<_>>();assert_eq!(matching.len(),1);let entry=matching[0];
        let bytes=std::fs::read(root().join("assets").join(entry["asset"].as_str().unwrap())).unwrap();assert_eq!(bytes.len() as u64,entry["bytes"].as_u64().unwrap());
        let image=crate::native_hud_atlases::decode(&bytes,CompressedImageFormats::BC).unwrap();assert_eq!(image.data.as_deref(),Some(&bytes[128..]));
        assert_eq!(image.texture_descriptor.size.width,entry["width"].as_u64().unwrap() as u32);assert_eq!(image.texture_descriptor.size.height,entry["height"].as_u64().unwrap() as u32);
    }
}

#[test]
fn buy_swap_sell_and_stack_changes_follow_same_tick_authoritative_slots() {
    let (mut game,id)=game();let tick=game.tick;assert_eq!(slots(&game,id),[None;6]);
    game.command(id,Action::Buy{item:1001}).unwrap();assert_eq!(slots(&game,id)[0],Some(Slot{item:1001,count:1,stackable:false}));
    game.command(id,Action::Buy{item:2003}).unwrap();game.command(id,Action::Buy{item:2003}).unwrap();
    let stacked=slots(&game,id);assert_eq!(stacked[1],Some(Slot{item:2003,count:2,stackable:true}));assert_eq!(count_text(stacked[0]),None);assert_eq!(count_text(stacked[1]),Some("2".into()));
    game.command(id,Action::SwapItems{from:0,to:5}).unwrap();assert_eq!(slots(&game,id)[0],None);assert_eq!(slots(&game,id)[5],stacked[0]);
    game.command(id,Action::Sell{slot:1}).unwrap();assert_eq!(count_text(slots(&game,id)[1]),Some("1".into()));
    game.command(id,Action::Sell{slot:1}).unwrap();game.command(id,Action::Sell{slot:5}).unwrap();assert_eq!(slots(&game,id),[None;6]);assert_eq!(game.tick,tick);
}

#[test]
fn holes_exact_texture_handles_resize_and_missing_image_are_explicit() {
    let (panels,_)=sources(&source_hud()).unwrap();let before=panels.iter().map(|p|p.storage.bytes().to_vec()).collect::<Vec<_>>();
    let mut assets=Assets::<Image>::default();let boots=assets.add(Image::default());let potion=assets.add(Image::default());
    let images=BTreeMap::from([(1001,Icon{image:boots.clone(),asset:"boots".into()}),(2003,Icon{image:potion.clone(),asset:"potion".into()})]);
    let slots=[None,Some(Slot{item:2003,count:2,stackable:true}),None,None,None,Some(Slot{item:1001,count:1,stackable:false})];
    for dimensions in [[1280,800],[1920,1080]] {
        let payloads=icon_payloads(&panels,&images,&slots,dimensions,1.,1.).unwrap();assert_eq!(payloads.len(),2);
        for ((node,material,z,index),expected) in payloads.iter().zip([1,5]) {assert_eq!(*index,expected);assert_eq!(*z,84);assert_eq!(material.texture.id(),if expected==1 {potion.id()}else{boots.id()});assert_eq!(material.parameters.uv,Vec4::new(0.,0.,1.,1.));
            let scaled=icon_payloads(&panels,&images,&slots,dimensions,1.,2.).unwrap();let scaled=&scaled[usize::from(expected==5)].0;
            let (Val::Px(width),Val::Px(half))=(node.width,scaled.width) else {panic!("pixel geometry")};assert_eq!(width,half*2.);
        }
    }
    assert!(icon_payloads(&panels,&BTreeMap::new(),&slots,[1280,800],1.,1.).is_err());
    assert!(icon_payloads(&panels,&images,&[None;6],[1280,800],1.,1.).unwrap().is_empty());
    for (panel,original) in panels.iter().zip(before) {assert_eq!(panel.storage.bytes(),original);}
}

#[test]
fn quantity_packets_clear_after_sale_and_keep_original_font_binding() {
    let (_,mut counts)=sources(&source_hud()).unwrap();let mut slots=[None;6];slots[4]=Some(Slot{item:2003,count:5,stackable:true});slots[0]=Some(Slot{item:1001,count:1,stackable:false});
    let (batch,bindings)=prepare_counts(&mut counts,&slots,[1280,800],1.).unwrap();assert_eq!(batch.records.len(),1);assert_eq!(&batch.records[0].bytes[28..30],b"5\0");assert_eq!(batch.records[0].copy_error,None);
    let font=u32::from_le_bytes(batch.records[0].bytes[..4].try_into().unwrap());assert_eq!(bindings[&font],counts[4].binding);
    let (batch,_)=prepare_counts(&mut counts,&[None;6],[1280,800],1.).unwrap();assert!(batch.records.is_empty());assert!(counts.iter().all(|source|source.storage.flags()&1==0 && source.storage.bytes()[0x20c..0x30c].iter().all(|b|*b==0)));
}

#[test]
fn no_player_unsupported_item_and_owned_render_cleanup_never_keep_stale_inventory() {
    let (game,id)=game();let mut snapshot=received(&game);assert_eq!(values(&snapshot,None).unwrap(),None);assert_eq!(values(&snapshot,Some(u32::MAX)).unwrap(),None);
    snapshot.players.iter_mut().find(|p|p.id==id).unwrap().inventory[0]=Some(u32::MAX);assert!(values(&snapshot,Some(id)).is_err());
    let mut world=World::new();let entity=world.spawn_empty().id();let other=world.spawn_empty().id();
    let mut materials=Assets::<IconMaterial>::default();let material=materials.add(IconMaterial{parameters:crate::native_hud_icon_material::Parameters{uv:Vec4::ZERO,vertex_color:Vec4::ONE,tint:Vec4::ONE,mode:Vec4::ZERO},texture:Handle::default()});let other_material=materials.add(materials.get(&material).unwrap().clone());
    let mut live=Icons{entities:vec![entity],materials:vec![material.clone()],signature:Some("previous session".into()),..default()};
    let mut queue=bevy::ecs::world::CommandQueue::default();{let mut commands=Commands::new(&mut queue,&world);clear_icons(&mut live,&mut commands,&mut materials);}queue.apply(&mut world);
    assert!(world.get_entity(entity).is_err());assert!(world.get_entity(other).is_ok());assert!(materials.get(&material).is_none());assert!(materials.get(&other_material).is_some());assert!(live.entities.is_empty()&&live.materials.is_empty()&&live.signature.is_none());
}
