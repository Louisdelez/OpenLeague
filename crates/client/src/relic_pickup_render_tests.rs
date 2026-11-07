//! Exercises the actual private publication backend, with explicit CPU assets.
use super::*;
use bevy::{asset::RenderAssetUsages,mesh::{PrimitiveTopology,Indices},image::ImageSampler};
fn world()->World{let mut w=World::new();w.init_resource::<Assets<Mesh>>();w.init_resource::<Assets<GlowMaterial>>();w.init_resource::<Assets<Image>>();
 w.spawn((crate::actor_fow::Root,crate::animation::material_test_playback(3,Handle::default()),Transform::IDENTITY,GlobalTransform::IDENTITY));w}
fn packet(world:&mut World,slot:usize,birth:u32)->Prepared{
 let mut mesh=Mesh::new(PrimitiveTopology::TriangleList,RenderAssetUsages::default());
 mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION,vec![[0.,0.,0.],[1.,0.,0.],[1.,1.,0.],[0.,1.,0.]]);
 mesh.insert_attribute(Mesh::ATTRIBUTE_UV_0,vec![[0.,0.];4]);mesh.insert_attribute(Mesh::ATTRIBUTE_UV_1,vec![[0.,0.];4]);mesh.insert_attribute(Mesh::ATTRIBUTE_COLOR,vec![[1.,1.,1.,1.];4]);mesh.insert_indices(Indices::U32(vec![0,1,2,0,2,3]));
 let bounds=mesh.compute_aabb().unwrap();
 let mut store=Store::default();
 let source=|name:&'static [u8],bytes:&'static [u8]|crate::relic_rune_image_bindings::Source::request(std::ffi::CStr::from_bytes_with_nul(name).unwrap(),std::ffi::CStr::from_bytes_with_nul(&[0]).unwrap(),bytes,ImageSampler::Descriptor(ImageSamplerDescriptor::default()),false).unwrap();
 let bindings=Bindings::acquire(&mut store,&mut world.resource_mut::<Assets<Image>>(),CompressedImageFormats::BC,
  source(b"Purify01.tga\0",include_bytes!("../../../assets/particles/relic_pickup/Purify01.DDS")),
  source(b"Wish_tar__starTrailSPI3__p-rgba.tga\0",include_bytes!("../../../assets/particles/relic_pickup/Wish_tar__starTrailSPI3__p-rgba.DDS"))).unwrap();
 let fog={let a=world.resource::<Assets<Image>>();[a.reserve_handle(),a.reserve_handle()]};
 let handles=bindings.images_render_fog(&store,world.resource::<Assets<Image>>(),fog.clone()).unwrap();
 let material=GlowMaterial::new_owned_render_fog(&bindings,&store,world.resource::<Assets<Image>>(),fog,Inputs{native_fog_extent:15398.671875,encoding:crate::nexus_complex_material::OutputEncoding::DisplayToLinear,cull:crate::nexus_complex_material::Cull::None,render_mode:0,render_flags:0,shader_features:0}).unwrap();
 assert!(!material.is_admitted());
 // The test retains material handles; no actual Store cleanup/GPU readiness claimed.
 let root=world.query::<(Entity,&crate::animation::Playback)>().iter(world).find(|(_,p)|p.network_id()==3).unwrap().0;
 Prepared{key:events::Key{session:7,pickup_tick:100,picker:3},owner:events::Binding{root,model:Handle::<Gltf>::default().id()},group:0,slot,birth,mesh,bounds,material,images:handles.map(|h|h.id())}
}
#[test]
fn retained_particle_reuses_draw_and_new_birth_replaces_owned_assets_then_empty_frame_retires(){
 let mut w=world();let mut b=Backend::default();let p=packet(&mut w,0,0);b.publish(&mut w,vec![p]).unwrap();let first=b.tickets()[0].clone();
 assert_eq!(w.get::<Visibility>(first.draw),Some(&Visibility::Visible));assert!(w.resource::<Assets<GlowMaterial>>().get(first.material).unwrap().is_admitted());
 let p=packet(&mut w,0,0);b.publish(&mut w,vec![p]).unwrap();let reused=b.tickets()[0].clone();assert_eq!(first.draw,reused.draw);assert_eq!(first.mesh,reused.mesh);assert_eq!(first.material,reused.material);
 let p=packet(&mut w,0,1);b.publish(&mut w,vec![p]).unwrap();let next=b.tickets()[0].clone();assert_ne!(first.draw,next.draw);assert!(w.get_entity(first.draw).is_err());assert!(!w.resource::<Assets<Mesh>>().contains(first.mesh));assert!(!w.resource::<Assets<GlowMaterial>>().contains(first.material));
 b.publish(&mut w,vec![]).unwrap();assert!(b.tickets().is_empty());assert!(w.get_entity(next.draw).is_err());assert_eq!(w.resource::<Assets<Mesh>>().len(),0);assert_eq!(w.resource::<Assets<GlowMaterial>>().len(),0);
}
#[test]
fn corrupted_owned_transform_is_rejected_before_draw_or_asset_replacement(){
 let mut w=world();let mut b=Backend::default();let p=packet(&mut w,0,0);b.publish(&mut w,vec![p]).unwrap();let before=b.tickets()[0].clone();
 *w.get_mut::<Transform>(before.draw).unwrap()=Transform::from_translation(Vec3::X);
 let p=packet(&mut w,0,1);assert!(b.publish(&mut w,vec![p]).is_err());assert_eq!(b.tickets(),vec![before.clone()]);assert!(w.resource::<Assets<Mesh>>().contains(before.mesh));assert!(w.resource::<Assets<GlowMaterial>>().contains(before.material));
 *w.get_mut::<Transform>(before.draw).unwrap()=Transform::IDENTITY;
 let one=packet(&mut w,0,1);let duplicate=packet(&mut w,0,1);assert!(b.publish(&mut w,vec![one,duplicate]).is_err());assert_eq!(b.tickets(),vec![before.clone()]);
 let p=packet(&mut w,0,1);w.entity_mut(before.owner.root).insert(crate::animation::material_test_playback(4,Handle::default()));
 assert!(b.publish(&mut w,vec![p]).is_err());assert_eq!(b.tickets(),vec![before.clone()]);
 b.hide(&mut w);assert_eq!(w.get::<Visibility>(before.draw),Some(&Visibility::Hidden));assert!(!w.resource::<Assets<GlowMaterial>>().get(before.material).unwrap().is_admitted());
}
