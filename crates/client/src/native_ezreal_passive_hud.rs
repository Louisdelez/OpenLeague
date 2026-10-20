//! LOCAL owner-only Rising Spell Force count in the original normal Buff0 slot.
//! Authoritative receipt/freshness belongs to ezreal_r_passive_presentation::State.
//! No expiry prediction, passive grants, F3 path or native slot allocator is supplied.
use bevy::{prelude::*, asset::RenderAssetUsages, image::CompressedImageFormats,
    render::{renderer::RenderDevice, render_resource::{Extent3d, TextureDimension, TextureFormat}},
    ui_render::ui_material::MaterialNode, window::PrimaryWindow};
use crate::{native_font_gpu::{FontMaterial, Pages}, native_font_metrics::Faces,
    native_hud_element_storage::ElementStorage, native_hud_font_creation::Sizes,
    native_hud_icon_material::IconMaterial, native_hud_panels::Panel,
    native_zip_provider::{Provider, StartupHud}};
use std::{collections::BTreeMap, path::Path};

const ICON_QUERY: &str = "Icons2D/Ezreal_RisingSpellForce.dds";
const LAYOUT: &str = "HUD/Elements/CenterHUD_Buffs.ini";

struct Source { icon: Panel, stack: ElementStorage, binding: usize }
struct Glyph { entity: Entity, material: Handle<FontMaterial> }
struct Icon { entity: Entity, material: Handle<IconMaterial> }
enum Retired { Glyph(Glyph), Icon(Icon) }
struct Payloads { glyph: (Node, FontMaterial), icon: (Node, IconMaterial), glyph_z: i32, icon_z: i32 }

#[derive(Resource, Default)]
struct Live {
    source: Option<Source>, fill: Handle<Image>, texture: Handle<Image>,
    glyph: Option<Glyph>, icon: Option<Icon>, retired: Vec<Retired>,
    signature: Option<String>, last_error: Option<String>,
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        // Material plugins already belong to the existing native font/panel paths.
        app.init_resource::<Live>().add_systems(Startup, setup)
            .add_systems(Update, update.after(crate::receive)
                .after(crate::native_font_metrics::MetricsSet).before(crate::render_probe::capture));
    }
}
fn name(storage: &ElementStorage) -> &[u8] {
    storage.bytes()[..32].split(|b| *b == 0).next().unwrap()
}
fn load(hud: &StartupHud) -> Result<Source, String> {
    let mut icon = None; let mut stack = None; let mut binding = 0usize;
    for layout in &hud.shadow_isles_layouts { for record in &layout.structure.accepted {
        let s = &record.element.storage;
        if layout.request == LAYOUT && s.kind() == 1 && name(s) == b"Buff0" {
            if icon.is_some() || s.bytes()[0x1e0..0x200].split(|b| *b == 0).next() != Some(b"BuffIcon0".as_slice()) {
                return Err("unique original Buff0 icon/texture required".into());
            }
            let mut owned = ElementStorage::new(1).map_err(str::to_owned)?;
            owned.write_bytes(0, s.bytes()); owned.set_word(0x48, owned.flags() | 1);
            icon = Some(Panel { name: "Buff0".into(), path: layout.request.clone(), storage: owned });
        }
        if s.kind() == 3 {
            if layout.request == LAYOUT && name(s) == b"BuffStack0" {
                if stack.is_some() { return Err("duplicate original BuffStack0".into()); }
                let font = u32::try_from(binding).ok().and_then(|n| n.checked_add(1))
                    .ok_or("passive source font binding overflow")?;
                let mut owned = ElementStorage::new(3).map_err(str::to_owned)?;
                owned.write_bytes(0, s.bytes()); owned.set_word(0x200, font);
                owned.set_word(0x48, owned.flags() | 1);
                stack = Some((owned, binding));
            }
            // Count ALL native Text records, including unselected/disabled records.
            binding = binding.checked_add(1).ok_or("passive source font order overflow")?;
        }
    }}
    let (stack, binding) = stack.ok_or("original BuffStack0 missing")?;
    Ok(Source { icon: icon.ok_or("original Buff0 missing")?, stack, binding })
}
fn icon_image(provider: &mut Provider, root: &Path, formats: CompressedImageFormats) -> Result<Image, String> {
    let bytes = provider.read_optional(root, Path::new(ICON_QUERY)).map_err(|e| e.to_string())?
        .ok_or("original Rising Spell Force icon unavailable")?;
    let image = crate::native_hud_atlases::decode(&bytes, formats).map_err(|e| e.to_string())?;
    if image.texture_descriptor.size.width != 64 || image.texture_descriptor.size.height != 64 {
        return Err("original Rising Spell Force icon dimensions changed".into());
    }
    Ok(image)
}
fn white_fill() -> Result<Image, String> {
    let mut image = Image::new(Extent3d { width: 1, height: 1, depth_or_array_layers: 1 },
        TextureDimension::D2, vec![255; 4], TextureFormat::Rgba8Unorm,
        RenderAssetUsages::MAIN_WORLD | RenderAssetUsages::RENDER_WORLD);
    image.sampler = crate::native_font_material::sampler(1, false).map_err(str::to_owned)?;
    Ok(image)
}
fn setup(hud: Res<StartupHud>, mut provider: ResMut<Provider>, device: Res<RenderDevice>,
    mut images: ResMut<Assets<Image>>, mut live: ResMut<Live>) {
    let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let result = (|| -> Result<_, String> {
        Ok((load(&hud)?, icon_image(&mut provider, &root,
            CompressedImageFormats::from_features(device.features()))?, white_fill()?))
    })();
    match result {
        Ok((source, icon, fill)) => { live.source = Some(source); live.texture = images.add(icon); live.fill = images.add(fill); }
        Err(error) => { eprintln!("Native Ezreal passive HUD unavailable: {error}"); live.last_error = Some(error); }
    }
}
fn batch(source: &mut Source, stacks: u8, dimensions: [u32; 2], scalar: f32)
    -> Result<crate::native_hud_text_batch::Batch, String> {
    if !(1..=5).contains(&stacks) { return Err("passive HUD requires authoritative count1..5".into()); }
    let mut text = [0u8; 256]; text[0] = b'0' + stacks;
    source.stack.write_bytes(0x20c, &text);
    crate::native_hud_text_batch::from_elements(&mut [&mut source.stack], dimensions, scalar,
        0, [1., 1., 0., 0.]).map_err(str::to_owned)
}
fn payloads(source: &mut Source, stacks: u8, dimensions: [u32; 2], scalar: f32, dpi: f32,
    faces: &mut Faces, sizes: &Sizes, pages: &mut Pages, images: &mut Assets<Image>,
    fill: Handle<Image>, icon: Handle<Image>) -> Result<Payloads, String> {
    let packet = batch(source, stacks, dimensions, scalar)?;
    let bindings = BTreeMap::from([(source.stack.word(0x200), source.binding)]);
    let prepared = crate::native_hud_text_render::prepare(faces, sizes, &packet,
        &crate::native_hud_text_render::Context { viewport: dimensions, packet_scalar: scalar, glyph_owner_scale: 1. },
        &bindings, |text| if text.len() == 1 && (b'1'..=b'5').contains(&text[0]) {
            Ok(vec![u16::from(text[0])])
        } else { Err("passive HUD count must be one ASCII digit1..5".into()) })?;
    if !prepared.copy_errors.is_empty() { return Err("passive HUD native text copy failed".into()); }
    pages.sync(faces, sizes, images)?;
    let mut glyphs = crate::native_hud_text_render::projected_ui_payloads(&prepared, faces, sizes,
        pages, fill, Vec2::splat(0.5))?;
    if glyphs.len() != 1 { return Err("passive HUD requires one prepared native stack glyph".into()); }
    let icon = crate::native_hud_panels::payload(&source.icon, dimensions, scalar, dpi, icon)?;
    let glyph_z = i32::try_from(source.stack.word(0x1a4)).ok().and_then(|z| z.checked_add(100))
        .ok_or("passive Text source layer overflow")?;
    let icon_z = i32::try_from(source.icon.storage.word(0x1a4)).ok().and_then(|z| z.checked_add(80))
        .ok_or("passive Icon source layer overflow")?;
    Ok(Payloads { glyph: glyphs.pop().unwrap(), icon, glyph_z, icon_z })
}
fn same_font(a: &FontMaterial, b: &FontMaterial) -> bool {
    let bits = |v: Vec4| v.to_array().map(f32::to_bits);
    a.font == b.font && a.fill == b.fill && a.glow == b.glow
        && bits(a.parameters.uv) == bits(b.parameters.uv)
        && bits(a.parameters.fill_uv) == bits(b.parameters.fill_uv)
        && bits(a.parameters.color0) == bits(b.parameters.color0)
        && bits(a.parameters.color1) == bits(b.parameters.color1)
}
fn same_icon(a: &IconMaterial, b: &IconMaterial) -> bool {
    let bits = |v: Vec4| v.to_array().map(f32::to_bits);
    a.texture == b.texture && bits(a.parameters.uv) == bits(b.parameters.uv)
        && bits(a.parameters.vertex_color) == bits(b.parameters.vertex_color)
        && bits(a.parameters.tint) == bits(b.parameters.tint) && bits(a.parameters.mode) == bits(b.parameters.mode)
}
fn clear(live: &mut Live, commands: &mut Commands) {
    if let Some(glyph) = live.glyph.take() {
        commands.entity(glyph.entity).try_despawn(); live.retired.push(Retired::Glyph(glyph));
    }
    if let Some(icon) = live.icon.take() {
        commands.entity(icon.entity).try_despawn(); live.retired.push(Retired::Icon(icon));
    }
    live.signature = None;
}
fn reap(live: &mut Live, ids: &bevy::ecs::entity::Entities,
    fonts: &mut Assets<FontMaterial>, icons: &mut Assets<IconMaterial>) {
    live.retired.retain(|item| match item {
        Retired::Glyph(glyph) => if ids.contains(glyph.entity) { true } else { fonts.remove(glyph.material.id()); false },
        Retired::Icon(icon) => if ids.contains(icon.entity) { true } else { icons.remove(icon.material.id()); false },
    });
}
fn intact(live: &Live, nodes: &Query<Option<&Node>>, fonts: &Assets<FontMaterial>, icons: &Assets<IconMaterial>) -> bool {
    match (&live.glyph, &live.icon) {
        (None, None) => true,
        (Some(g), Some(i)) => nodes.get(g.entity).ok().flatten().is_some()
            && nodes.get(i.entity).ok().flatten().is_some() && fonts.contains(g.material.id()) && icons.contains(i.material.id()),
        _ => false,
    }
}
fn reconcile(live: &mut Live, commands: &mut Commands, nodes: &Query<Option<&Node>>,
    fonts: &mut Assets<FontMaterial>, icons: &mut Assets<IconMaterial>, next: Payloads) -> Result<(), String> {
    if !intact(live, nodes, fonts, icons) { return Err("owned passive HUD entity/material disappeared".into()); }
    let (node, material) = next.glyph;
    if let Some(glyph) = &live.glyph {
        if nodes.get(glyph.entity).ok().flatten() != Some(&node) { commands.entity(glyph.entity).insert(node); }
        if !same_font(fonts.get(glyph.material.id()).unwrap(), &material) { *fonts.get_mut(glyph.material.id()).unwrap() = material; }
    } else {
        let material = fonts.add(material);
        let entity = commands.spawn((node, MaterialNode(material.clone()), GlobalZIndex(next.glyph_z), Name::new("NativeEzrealPassiveStack"))).id();
        live.glyph = Some(Glyph { entity, material });
    }
    let (node, material) = next.icon;
    if let Some(icon) = &live.icon {
        if nodes.get(icon.entity).ok().flatten() != Some(&node) { commands.entity(icon.entity).insert(node); }
        if !same_icon(icons.get(icon.material.id()).unwrap(), &material) { *icons.get_mut(icon.material.id()).unwrap() = material; }
    } else {
        let material = icons.add(material);
        let entity = commands.spawn((node, MaterialNode(material.clone()), GlobalZIndex(next.icon_z), Name::new("NativeEzrealPassiveIcon"))).id();
        live.icon = Some(Icon { entity, material });
    }
    Ok(())
}
fn signature(live: &Live, session: u64, viewer: u32, epoch: Option<u64>, stacks: u8,
    dimensions: [u32; 2], dpi: f32, scalar: f32, faces: &Faces, sizes: &Sizes, pages: &Pages) -> String {
    let bank = live.source.as_ref().and_then(|s| sizes.descriptor_bindings.get(s.binding))
        .and_then(|face| pages.banks.get(*face)).map(|p| p.iter().map(Handle::id).collect::<Vec<_>>());
    format!("{session}:{viewer}:{epoch:?}:{stacks}:{dimensions:?}:{}:{}:{:?}:{:?}:{bank:?}:{:?}:{:?}",
        dpi.to_bits(), scalar.to_bits(), faces.dpi, sizes.height, live.texture.id(), live.fill.id())
}
fn update(mut commands: Commands, ids: &bevy::ecs::entity::Entities, nodes: Query<Option<&Node>>,
    state: Res<crate::Match>, connection: Res<crate::Connection>, window: Query<&Window, With<PrimaryWindow>>,
    viewport: Res<crate::native_hud_viewport::Viewport>, sizes: Res<Sizes>, mut faces: NonSendMut<Faces>,
    mut pages: ResMut<Pages>, mut images: ResMut<Assets<Image>>, mut fonts: ResMut<Assets<FontMaterial>>,
    mut icons: ResMut<Assets<IconMaterial>>, mut live: ResMut<Live>, clock: Res<crate::native_effect_clock::EffectClock>) {
    reap(&mut live, ids, &mut fonts, &mut icons);
    let Some(snapshot) = &state.snapshot else { clear(&mut live, &mut commands); return; };
    let Some((session, viewer, epoch)) = connection.inventory_input_identity() else { clear(&mut live, &mut commands); return; };
    let healthy = clock.presentation_ready() && clock.now.is_finite() && clock.now >= 0.;
    let Some(stacks) = state.ezreal_passive_hud.passive(snapshot, viewer, session, epoch, clock.now, healthy)
        .filter(|n| (1..=5).contains(n)) else { clear(&mut live, &mut commands); return; };
    let Ok(window) = window.single() else { clear(&mut live, &mut commands); return; };
    let dimensions = [window.physical_width(), window.physical_height()]; let dpi = window.scale_factor();
    if live.source.is_none() || images.get(&live.texture).is_none() || images.get(&live.fill).is_none()
        || dimensions.contains(&0) || sizes.height != Some(dimensions[1]) || faces.height != sizes.height {
        clear(&mut live, &mut commands); return;
    }
    if !intact(&live, &nodes, &fonts, &icons) { clear(&mut live, &mut commands); }
    let wanted = signature(&live, session, viewer, epoch, stacks, dimensions, dpi, viewport.scalar, &faces, &sizes, &pages);
    if live.signature.as_ref() == Some(&wanted) { return; }
    let fill = live.fill.clone(); let icon = live.texture.clone();
    let result = payloads(live.source.as_mut().unwrap(), stacks, dimensions, viewport.scalar, dpi,
        &mut faces, &sizes, &mut pages, &mut images, fill, icon)
        .and_then(|p| reconcile(&mut live, &mut commands, &nodes, &mut fonts, &mut icons, p));
    match result {
        Ok(()) => { live.signature = Some(signature(&live, session, viewer, epoch, stacks, dimensions, dpi, viewport.scalar, &faces, &sizes, &pages)); live.last_error = None; }
        Err(error) => { clear(&mut live, &mut commands); if live.last_error.as_ref() != Some(&error) { eprintln!("Native Ezreal passive HUD hidden: {error}"); live.last_error = Some(error); } }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn source() -> (Provider, StartupHud) {
        let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let mut provider = Provider::from_catalog(&root).unwrap(); let hud = provider.startup_hud(&root).unwrap();
        (provider, hud)
    }
    fn source_bytes(hud: &StartupHud) -> Vec<Vec<u8>> {
        hud.shadow_isles_layouts.iter().flat_map(|l| &l.structure.accepted).map(|r| r.element.storage.bytes().to_vec()).collect()
    }
    #[test]
    fn original_buff_slot_global_font_order_and_exact_provider_icon_are_preserved() {
        let (mut provider, hud) = source(); let before = source_bytes(&hud); let mut s = load(&hud).unwrap();
        let texts = hud.shadow_isles_layouts.iter().flat_map(|l| &l.structure.accepted)
            .filter(|r| r.element.storage.kind() == 3).collect::<Vec<_>>();
        assert_eq!(texts.len(), 154); assert_eq!(name(&texts[s.binding].element.storage), b"BuffStack0");
        assert_eq!(s.stack.word(0x200), s.binding as u32 + 1);
        assert_eq!(s.stack.word(0x208), 1); assert_eq!(s.stack.word(0x1dc), 0xdcffffff);
        assert_eq!(s.stack.flags(), 0x11); assert_eq!(s.icon.storage.flags(), 1);
        assert_eq!(s.icon.storage.word(0x1a4), 0); assert_eq!(s.stack.word(0x1a4), 3);
        assert_eq!(source_bytes(&hud), before);
        let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let raw = provider.read_optional(&root, Path::new(ICON_QUERY)).unwrap().unwrap();
        assert_eq!(raw.len(), 2176); assert_eq!(&raw[84..88], b"DXT1");
        let image = icon_image(&mut provider, &root, CompressedImageFormats::BC).unwrap();
        assert_eq!(image.texture_descriptor.size.width, 64); assert_eq!(image.texture_descriptor.size.height, 64);
        assert_eq!(image.data.as_deref(), Some(&raw[128..]));
        for dimensions in [[1280, 800], [1920, 1080]] {
            let (normal, material) = crate::native_hud_panels::payload(&s.icon, dimensions, 1., 1., Handle::default()).unwrap();
            let (scaled, _) = crate::native_hud_panels::payload(&s.icon, dimensions, 1., 2., Handle::default()).unwrap();
            assert_eq!(material.parameters.uv.to_array(), [0., 0., 1., 1.]);
            match (normal.width, scaled.width) { (Val::Px(a), Val::Px(b)) => { assert!(a > 0.); assert_eq!(a, b * 2.); }, _ => panic!("original icon pixel geometry required") }
            for count in [1, 5] { let b = batch(&mut s, count, dimensions, 1.).unwrap(); assert_eq!(b.records.len(), 1); assert_eq!(b.fonts, vec![s.binding as u32 + 1]); assert_eq!(&b.records[0].bytes[28..30], &[b'0' + count, 0]); }
            for count in [0, 6, u8::MAX] { assert!(batch(&mut s, count, dimensions, 1.).is_err()); }
        }
    }
    #[test]
    fn real_source_stack_digits_prepare_native_font_pages_and_resize_without_widget_mutation() {
        let (mut provider, hud) = source(); let before = source_bytes(&hud); let mut s = load(&hud).unwrap();
        let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let mut images = Assets::<Image>::default(); let icon = images.add(icon_image(&mut provider, &root, CompressedImageFormats::BC).unwrap());
        let fill = images.add(white_fill().unwrap()); let mut pages = Pages::default();
        let mut app = App::new(); app.insert_resource(hud).insert_resource(crate::native_font_metrics::Dpi { explicit: Some([96, 96]) })
            .add_plugins((crate::native_hud_font_creation::Plugin, crate::native_font_metrics::Plugin));
        let window = app.world_mut().spawn((Window { resolution: (1280, 800).into(), ..default() }, PrimaryWindow)).id();
        for dimensions in [[1280, 800], [1920, 1080]] {
            app.world_mut().entity_mut(window).get_mut::<Window>().unwrap().resolution.set_physical_resolution(dimensions[0], dimensions[1]); app.update();
            let sizes = app.world_mut().remove_resource::<Sizes>().unwrap(); let mut faces = app.world_mut().non_send_resource_mut::<Faces>();
            for count in 1..=5 {
                let p = payloads(&mut s, count, dimensions, 1., 1., &mut faces, &sizes, &mut pages, &mut images, fill.clone(), icon.clone()).unwrap();
                let face = sizes.descriptor_bindings[s.binding]; let binding = &faces.atlases[face].bindings[&u16::from(b'0' + count)];
                assert_eq!(p.glyph.1.font, pages.banks[face][binding.page]); assert_eq!(p.icon.1.texture, icon);
                assert_eq!(p.glyph.1.parameters.uv.to_array(), binding.placement.uv);
                assert_eq!(p.glyph.1.parameters.color0, crate::native_font_material::packed_color(0xdcffffff));
                assert!(images.get(&p.glyph.1.font).unwrap().data.as_ref().unwrap().iter().any(|b| *b != 0));
                match (p.glyph.0.width, p.glyph.0.height) { (Val::Px(w), Val::Px(h)) => assert!(w > 0. && h > 0.), _ => panic!("prepared glyph pixel geometry required") }
            }
            drop(faces); app.insert_resource(sizes);
            assert_eq!(source_bytes(app.world().resource::<StartupHud>()), before);
        }
    }
    #[test]
    fn ecs_icon_and_glyph_reuse_owned_handles_and_retire_after_entities_leave() {
        use crate::native_hud_icon_material::Parameters as IconParameters;
        use crate::native_font_gpu::Parameters as FontParameters;
        #[derive(Resource, Default)] struct Pending(Option<Option<Payloads>>);
        fn make(color: f32) -> Payloads {
            Payloads { glyph: (Node { width: Val::Px(8.), height: Val::Px(12.), ..default() }, FontMaterial {
                parameters: FontParameters { uv: Vec4::ONE, fill_uv: Vec4::ONE, color0: Vec4::splat(color), color1: Vec4::ZERO },
                font: Handle::default(), fill: Handle::default(), glow: false }),
                icon: (Node { width: Val::Px(30.), height: Val::Px(30.), ..default() }, IconMaterial {
                    parameters: IconParameters { uv: Vec4::ONE, vertex_color: Vec4::ONE, tint: Vec4::ONE, mode: Vec4::ZERO }, texture: Handle::default() }), glyph_z: 103, icon_z: 80 }
        }
        fn drive(mut commands: Commands, ids: &bevy::ecs::entity::Entities, nodes: Query<Option<&Node>>,
            mut live: ResMut<Live>, mut fonts: ResMut<Assets<FontMaterial>>, mut icons: ResMut<Assets<IconMaterial>>, mut pending: ResMut<Pending>) {
            reap(&mut live, ids, &mut fonts, &mut icons);
            if let Some(action) = pending.0.take() { match action { Some(p) => reconcile(&mut live, &mut commands, &nodes, &mut fonts, &mut icons, p).unwrap(), None => clear(&mut live, &mut commands) } }
        }
        let mut app = App::new(); app.init_resource::<Live>().init_resource::<Assets<FontMaterial>>()
            .init_resource::<Assets<IconMaterial>>().init_resource::<Pending>().add_systems(Update, drive);
        let foreign_entity = app.world_mut().spawn_empty().id();
        let foreign_font = app.world_mut().resource_mut::<Assets<FontMaterial>>().add(make(0.5).glyph.1);
        let foreign_icon = app.world_mut().resource_mut::<Assets<IconMaterial>>().add(make(0.5).icon.1);
        app.world_mut().resource_mut::<Pending>().0 = Some(Some(make(1.))); app.update();
        let live = app.world().resource::<Live>(); let ge = live.glyph.as_ref().unwrap().entity; let ie = live.icon.as_ref().unwrap().entity;
        let gf = live.glyph.as_ref().unwrap().material.clone(); let im = live.icon.as_ref().unwrap().material.clone();
        for color in [1., 0.8, 0.8] {
            app.world_mut().resource_mut::<Pending>().0 = Some(Some(make(color))); app.update();
            let live = app.world().resource::<Live>(); assert_eq!(live.glyph.as_ref().unwrap().entity, ge); assert_eq!(live.icon.as_ref().unwrap().entity, ie);
            assert_eq!(live.glyph.as_ref().unwrap().material, gf); assert_eq!(live.icon.as_ref().unwrap().material, im);
            assert_eq!(app.world().resource::<Assets<FontMaterial>>().len(), 2); assert_eq!(app.world().resource::<Assets<IconMaterial>>().len(), 2);
        }
        // A removed Node still has an entity generation: retain its material until actual despawn.
        app.world_mut().entity_mut(ge).remove::<Node>(); app.world_mut().resource_mut::<Pending>().0 = Some(None); app.update();
        assert!(app.world().resource::<Assets<FontMaterial>>().get(&gf).is_some()); assert!(app.world().resource::<Assets<IconMaterial>>().get(&im).is_some());
        app.update(); assert!(app.world().resource::<Assets<FontMaterial>>().get(&gf).is_none()); assert!(app.world().resource::<Assets<IconMaterial>>().get(&im).is_none());
        assert!(app.world().get_entity(foreign_entity).is_ok());
        assert!(app.world().resource::<Assets<FontMaterial>>().get(&foreign_font).is_some()); assert!(app.world().resource::<Assets<IconMaterial>>().get(&foreign_icon).is_some());
        assert!(app.world().resource::<Live>().retired.is_empty());
    }
}
