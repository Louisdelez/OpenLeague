use super::*;
use bevy::render::render_resource::TextureFormat;
const COLOR:&[u8]=include_bytes!("../../../assets/particles/relic_runes/DefaultColorOverLifetime.dds");
const FALLOFF:&[u8]=include_bytes!("../../../assets/particles/relic_runes/DefaultFalloff.dds");
fn acquire(store:&mut Store,key:u32,bytes:&[u8],assets:&mut Assets<Image>)->Lease {
    store.acquire_dds(key,bytes,CompressedImageFormats::all(),false,ImageSampler::Default,assets).unwrap()
}
#[test]
fn original_dds_views_and_all_mip_bytes_match_native_parser() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/dds_parser_contract.json")).unwrap();
    assert_eq!(proof["passed"],true);
    for (index,(key,bytes,source,view,mips,format)) in [
        (0xdf8811a4,COLOR,[8,8,1],[8,8,1],1,TextureFormat::Bc1RgbaUnorm),
        (0x01cb3438,FALLOFF,[256,1,1],[256,4,1],9,TextureFormat::Bc3RgbaUnorm),
    ].into_iter().enumerate() {
        let mut assets=Assets::<Image>::default();let mut store=Store::default();
        let lease=acquire(&mut store,key,bytes,&mut assets);let handle=store.image(&lease,&assets).unwrap();
        let image=assets.get(&handle).unwrap();let layout=store.layout(&lease).unwrap();
        assert_eq!(layout.source_extent,source);assert_eq!(layout.storage_extent,view);assert_eq!(layout.mip_levels,mips);
        assert_eq!(image.texture_descriptor.format,format);assert_eq!(image.data.as_deref(),Some(&bytes[128..]));
        let row=&proof["rows"][index];assert_eq!(row["native_extent"],serde_json::json!([view[0],view[1]]));
        let offsets=row["mip_offsets"].as_array().unwrap();assert_eq!(offsets.len(),mips as usize);
        let block_size=if index==0 {8} else {16};
        let mut cursor=128usize;
        for level in 0..mips {
            assert_eq!(offsets[level as usize].as_u64(),Some(cursor as u64));
            let width=(view[0]>>level).max(1);let height=(view[1]>>level).max(1);
            cursor+=(width.div_ceil(4)*height.div_ceil(4)*block_size) as usize;
        }
        assert_eq!(cursor,bytes.len());assert_eq!(row["payload_end"].as_u64(),Some(cursor as u64));
        store.release(lease,&mut assets).unwrap();assert_eq!(assets.len(),0);
    }
}
#[test]
fn cached_images_follow_loader_resident_and_forced_cleanup_lifetimes() {
    let mut assets=Assets::<Image>::default();let mut store=Store::default();
    let a=acquire(&mut store,0xdf8811a4,COLOR,&mut assets);assert_eq!(store.refs(&a),Some(1));
    assert!(store.pin_for_renderer(&a).unwrap());assert_eq!(store.refs(&a),Some(2));
    let held=store.image(&a,&assets).unwrap();
    let b=acquire(&mut store,0xdf8811a4,b"cache hit skips provider",&mut assets);
    assert_eq!(a.id(),b.id());assert_eq!(store.refs(&a),Some(3));assert!(!store.pin_for_renderer(&b).unwrap());
    assert_eq!(store.refs(&a),Some(3));store.release(b,&mut assets).unwrap();assert_eq!(store.refs(&a),Some(2));
    store.release(a,&mut assets).unwrap();assert!(assets.contains(held.id()));
    store.cleanup_renderer(&mut assets).unwrap();assert!(!assets.contains(held.id()));assert_eq!(store.len(),0);
    let a=acquire(&mut store,0xdf8811a4,COLOR,&mut assets);store.pin_for_renderer(&a).unwrap();
    let b=acquire(&mut store,0xdf8811a4,COLOR,&mut assets);assert_eq!(store.refs(&a),Some(3));
    store.release(a,&mut assets).unwrap();assert_eq!(store.refs(&b),Some(2));
    store.cleanup_renderer(&mut assets).unwrap();assert!(store.image(&b,&assets).is_err());
    assert!(store.release(b,&mut assets).is_err());assert_eq!(assets.len(),0);
    assert!(store.acquire_dds(42,b"invalid DDS",CompressedImageFormats::all(),false,ImageSampler::Default,&mut assets).is_err());
    assert_eq!(assets.len(),0);assert_eq!(store.len(),0);
}
#[test]
fn foreign_store_cannot_alias_or_consume_another_owner_lease() {
    let mut assets=Assets::<Image>::default();let mut owner=Store::default();let mut other=Store::default();
    let owned=acquire(&mut owner,1,COLOR,&mut assets);let foreign=acquire(&mut other,1,COLOR,&mut assets);
    assert_ne!(owned.id(),foreign.id());assert!(other.image(&owned,&assets).is_err());assert!(other.layout(&owned).is_err());
    assert!(other.pin_for_renderer(&owned).is_err());
    let failure=other.release(owned,&mut assets).unwrap_err();assert!(failure.message.contains("foreign"));
    assert_eq!(owner.refs(&failure.lease),Some(1));assert_eq!(other.refs(&foreign),Some(1));
    owner.release(failure.lease,&mut assets).unwrap();other.release(foreign,&mut assets).unwrap();assert_eq!(assets.len(),0);
}
