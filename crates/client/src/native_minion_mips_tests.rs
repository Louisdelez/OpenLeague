//! CPU regression source only. Root has not compiled or executed these tests.
use super::*;

fn handles() -> (Handle<Image>, Handle<Image>, Handle<Image>) {
    let mut images = Assets::<Image>::default();
    (images.add(Image::default()), images.add(Image::default()), images.add(Image::default()))
}

#[test]
fn foreign_none_after_png_admission_is_not_owned_before_dds_binding() {
    let (png, _, _) = handles();
    let entry = Entry { png: Some(png.clone()), owned: None, ..Default::default() };
    // Actual runtime guard: this foreign removal used to match entry.owned=None.
    assert!(!known_texture(&entry, &None));
    assert!(known_texture(&entry, &Some(png)));
}

#[test]
fn known_texture_requires_a_concrete_original_or_owned_handle() {
    let (png, dds, foreign) = handles();
    assert!(!known_texture(&Entry::default(), &None));
    let entry = Entry { png: Some(png.clone()), owned: Some(dds.clone()), ..Default::default() };
    assert!(known_texture(&entry, &Some(png)));
    assert!(known_texture(&entry, &Some(dds)));
    assert!(!known_texture(&entry, &Some(foreign)));
    assert!(!known_texture(&entry, &None));
}

#[test]
fn new_generation_clears_old_success_before_a_png_pending_return() {
    let (png, dds, _) = handles();
    let mut materials = Assets::<StandardMaterial>::default();
    let old = materials.add(StandardMaterial::default());
    let new = materials.add(StandardMaterial::default());
    let mut state = State::default();
    state.entries[0] = Entry { target: Some(old.id()), png: Some(png),
        dds: Some(dds.clone()), owned: Some(dds), foreign: false };
    state.restored_in_assets[0] = true;
    // Actual method used before either PNG_pending branch in update().
    state.begin(0, new.id());
    assert!(!state.restored_in_assets[0]);
    assert_eq!(state.entries[0].target, Some(new.id()));
    assert!(state.entries[0].png.is_none());
    assert!(state.entries[0].dds.is_none());
    assert!(state.entries[0].owned.is_none());
    assert!(!state.entries[0].foreign);
    assert!(state.restored_in_assets.iter().all(|value| !value));
}

#[test]
fn same_generation_starts_unrestored_and_keeps_its_foreign_guard() {
    let (png, _, _) = handles();
    let mut materials = Assets::<StandardMaterial>::default();
    let target = materials.add(StandardMaterial::default());
    let mut state = State::default();
    state.entries[1] = Entry { target: Some(target.id()), png: Some(png.clone()),
        foreign: true, ..Default::default() };
    state.restored_in_assets[1] = true;
    state.begin(1, target.id());
    assert!(!state.restored_in_assets[1]);
    assert!(state.entries[1].foreign);
    assert_eq!(state.entries[1].png, Some(png));
}

#[test]
fn fallback_restores_only_our_texture_and_preserves_other_material_fields() {
    let (png, dds, _) = handles();
    let mut materials = Assets::<StandardMaterial>::default();
    let original_color = Color::srgb(0.23, 0.41, 0.67);
    let target = materials.add(StandardMaterial { base_color_texture: Some(dds.clone()),
        base_color: original_color, unlit: true, double_sided: true,
        alpha_mode: AlphaMode::Opaque, ..Default::default() });
    let mut entry = Entry { target: Some(target.id()), png: Some(png.clone()),
        owned: Some(dds), ..Default::default() };
    fallback(&mut entry, &mut materials);
    let actual = materials.get(&target).unwrap();
    assert_eq!(actual.base_color_texture, Some(png));
    assert_eq!(actual.base_color, original_color);
    assert!(actual.unlit && actual.double_sided);
    assert_eq!(actual.alpha_mode, AlphaMode::Opaque);
    assert!(entry.owned.is_none());
}

#[test]
fn fallback_does_not_overwrite_foreign_none_or_foreign_some() {
    let (png, dds, foreign) = handles();
    let mut materials = Assets::<StandardMaterial>::default();
    for replacement in [None, Some(foreign)] {
        let target = materials.add(StandardMaterial {
            base_color_texture: replacement.clone(), ..Default::default() });
        let mut entry = Entry { target: Some(target.id()), png: Some(png.clone()),
            owned: Some(dds.clone()), ..Default::default() };
        fallback(&mut entry, &mut materials);
        assert_eq!(materials.get(&target).unwrap().base_color_texture, replacement);
        assert!(entry.owned.is_none());
    }
}

#[test]
fn fallback_without_owned_dds_keeps_the_current_png() {
    let (png, _, _) = handles();
    let mut materials = Assets::<StandardMaterial>::default();
    let target = materials.add(StandardMaterial { base_color_texture: Some(png.clone()),
        ..Default::default() });
    let mut entry = Entry { target: Some(target.id()), png: Some(png.clone()),
        owned: None, ..Default::default() };
    fallback(&mut entry, &mut materials);
    assert_eq!(materials.get(&target).unwrap().base_color_texture, Some(png));
    assert!(entry.owned.is_none());
}

#[test]
fn native_validation_requires_all_ten_exact_mips_format_and_sampler() {
    let input = &INPUTS[0];
    let mut image = Image::default();
    image.texture_descriptor.size.width = 512;
    image.texture_descriptor.size.height = 512;
    image.texture_descriptor.size.depth_or_array_layers = 1;
    image.texture_descriptor.dimension = TextureDimension::D2;
    image.texture_descriptor.format = TextureFormat::Bc1RgbaUnormSrgb;
    image.texture_descriptor.mip_level_count = 10;
    image.texture_descriptor.sample_count = 1;
    image.texture_view_descriptor = None;
    image.sampler = ImageSampler::Descriptor(sampler());
    image.data = Some(input.native[128..].to_vec());
    assert!(native(&image, input));
    image.data.as_mut().unwrap()[0] ^= 1;
    assert!(!native(&image, input));
    image.data.as_mut().unwrap()[0] ^= 1;
    image.texture_descriptor.mip_level_count = 1;
    assert!(!native(&image, input));
    image.texture_descriptor.mip_level_count = 10;
    image.texture_descriptor.format = TextureFormat::Bc1RgbaUnorm;
    assert!(!native(&image, input));
    image.texture_descriptor.format = TextureFormat::Bc1RgbaUnormSrgb;
    image.sampler = ImageSampler::Descriptor(ImageSamplerDescriptor::nearest());
    assert!(!native(&image, input));
}
