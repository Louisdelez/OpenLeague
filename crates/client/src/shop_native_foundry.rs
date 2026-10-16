//! Static atlas bindings from original 4.20 FoundryItemShop.gfx and its eight raw DDS files.
//! No patched SWF/panel composite, external player fixture or legacy atlas is used.
//! Region bounds are initial shape pixels [x,y,width,height]; callers apply native parent placements.
//! Source slices do not qualify original framebuffer, tween, resize or glyph fidelity.
use bevy::prelude::*;
use bevy::image::{ImageAddressMode, ImageFilterMode, ImageLoaderSettings, ImageSampler, ImageSamplerDescriptor};

pub const FONT_PATH: &str = "ui/shop420/foundry/GillSansMTProMedium.ttf";
/// Original font-library source was extracted; own glyph rasterization remains unqualified.
pub const FONTLIB_SOURCE_EXTRACTED: bool = true;
pub const ORIGINAL_FONT_GLYPH_RASTERIZATION_QUALIFIED: bool = false;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
#[repr(usize)]
pub enum Texture { I7, I4, I1, I42, I66, I7B, IB4, I112 }
impl Texture {
    pub const fn filename(self) -> &'static str {
        match self {
            Self::I7 => "FoundryItemShop_I7.dds",
            Self::I4 => "FoundryItemShop_I4.dds",
            Self::I1 => "FoundryItemShop_I1.dds",
            Self::I42 => "FoundryItemShop_I42.dds",
            Self::I66 => "FoundryItemShop_I66.dds",
            Self::I7B => "FoundryItemShop_I7B.dds",
            Self::IB4 => "FoundryItemShop_IB4.dds",
            Self::I112 => "FoundryItemShop_I112.dds",
        }
    }
}

#[derive(Resource, Clone)]
pub struct SourceImages { pub handles: [Handle<Image>; 8] }
pub fn load(asset_server: &AssetServer) -> SourceImages {
    SourceImages { handles: [
        load_image(asset_server, "ui/shop420/foundry/FoundryItemShop_I7.dds"),
        load_image(asset_server, "ui/shop420/foundry/FoundryItemShop_I4.dds"),
        load_image(asset_server, "ui/shop420/foundry/FoundryItemShop_I1.dds"),
        load_image(asset_server, "ui/shop420/foundry/FoundryItemShop_I42.dds"),
        load_image(asset_server, "ui/shop420/foundry/FoundryItemShop_I66.dds"),
        load_image(asset_server, "ui/shop420/foundry/FoundryItemShop_I7B.dds"),
        load_image(asset_server, "ui/shop420/foundry/FoundryItemShop_IB4.dds"),
        load_image(asset_server, "ui/shop420/foundry/FoundryItemShop_I112.dds"),
    ] }
}

/// Own renderer policy: linear filtering and edge clamp. Original sampler equivalence is unknown.
fn load_image(asset_server: &AssetServer, path: &'static str) -> Handle<Image> {
    asset_server.load_with_settings(path, |settings: &mut ImageLoaderSettings| {
        settings.sampler = ImageSampler::Descriptor(ImageSamplerDescriptor {
            address_mode_u: ImageAddressMode::ClampToEdge,
            address_mode_v: ImageAddressMode::ClampToEdge,
            address_mode_w: ImageAddressMode::ClampToEdge,
            mag_filter: ImageFilterMode::Linear,
            min_filter: ImageFilterMode::Linear,
            mipmap_filter: ImageFilterMode::Linear,
            ..default()
        });
    })
}

#[derive(Clone, Copy, Debug)]
pub struct Region {
    pub texture: Texture,
    pub crop: Rect,
    pub bounds: [f32; 4],
    pub shape_id: u16,
}

#[derive(Component, Clone, Copy, Debug)]
pub struct NativePlacement(pub Vec4);

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Part { Background, Header, GoldPlate, Buy, Sell, TabAll, TabRecommended, Search, Close, Undo, GridButton, ListButton, InventorySlot, CatalogRow, CatalogGridBackground, Details, Filter, FilterHeader, FilterTag, FilterPanel }
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum State { Up, Over, Down, Disabled, Selected }

/// Source rectangle only; unsupported labels return None instead of inventing a native state.
/// InventorySlot returns its principal frame/highlight; use layers for base plus highlight.
/// CatalogRow is swc.ItemButtonBG; Filter is swc.FilterButtonAllItems.
/// CatalogGridBackground is swc.ItemButtonBGSmall; no list-row stretching is substituted.
pub fn region(part: Part, state: State) -> Option<Region> {
    match (part, state) {
        (Part::Background, State::Up) => Some(Region { texture: Texture::I1, crop: Rect::new(0.0, 0.0, 1023.0, 512.0), bounds: [0.0, 0.0, 1023.0, 512.0], shape_id: 2 }),
        (Part::Header, State::Up) => Some(Region { texture: Texture::I4, crop: Rect::new(0.0, 0.0, 1170.0, 70.0), bounds: [0.0, 0.0, 1170.0, 70.0], shape_id: 5 }),
        (Part::GoldPlate, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(5.0, 547.0, 106.0, 589.0), bounds: [0.0, 0.0, 101.0, 42.0], shape_id: 324 }),
        (Part::Buy, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(596.0, 357.0, 783.0, 412.0), bounds: [-33.0, 19.0, 187.0, 55.0], shape_id: 168 }),
        (Part::Buy, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(407.0, 357.0, 594.0, 412.0), bounds: [-33.0, 19.0, 187.0, 55.0], shape_id: 171 }),
        (Part::Buy, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(218.0, 357.0, 405.0, 412.0), bounds: [-33.0, 19.0, 187.0, 55.0], shape_id: 173 }),
        (Part::Buy, State::Disabled) => Some(Region { texture: Texture::I7, crop: Rect::new(29.0, 357.0, 216.0, 412.0), bounds: [-33.0, 19.0, 187.0, 55.0], shape_id: 175 }),
        (Part::Sell, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(169.0, 463.0, 307.0, 506.0), bounds: [0.0, 0.0, 138.0, 43.0], shape_id: 47 }),
        (Part::Sell, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(309.0, 463.0, 447.0, 506.0), bounds: [0.0, 0.0, 138.0, 43.0], shape_id: 50 }),
        (Part::Sell, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(789.0, 414.0, 927.0, 457.0), bounds: [0.0, 0.0, 138.0, 43.0], shape_id: 52 }),
        (Part::Sell, State::Disabled) => Some(Region { texture: Texture::I7, crop: Rect::new(29.0, 463.0, 167.0, 506.0), bounds: [0.0, 0.0, 138.0, 43.0], shape_id: 54 }),
        (Part::Close, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(939.0, 357.0, 984.0, 402.0), bounds: [38.0, -1.25, 45.0, 45.0], shape_id: 340 }),
        (Part::Close, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(695.0, 414.0, 740.0, 459.0), bounds: [38.0, -1.25, 45.0, 45.0], shape_id: 342 }),
        (Part::Close, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(742.0, 414.0, 787.0, 459.0), bounds: [38.0, -1.25, 45.0, 45.0], shape_id: 344 }),
        (Part::Undo, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(812.0, 547.0, 854.0, 589.0), bounds: [62.0, 6.0, 42.0, 42.0], shape_id: 57 }),
        (Part::Undo, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(460.0, 547.0, 502.0, 589.0), bounds: [62.0, 6.0, 42.0, 42.0], shape_id: 59 }),
        (Part::Undo, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(592.0, 547.0, 634.0, 589.0), bounds: [62.0, 6.0, 42.0, 42.0], shape_id: 61 }),
        (Part::Undo, State::Disabled) => Some(Region { texture: Texture::I7, crop: Rect::new(680.0, 547.0, 722.0, 589.0), bounds: [62.0, 6.0, 42.0, 42.0], shape_id: 63 }),
        (Part::GridButton, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(196.0, 547.0, 238.0, 589.0), bounds: [-17.0, -20.0, 42.0, 42.0], shape_id: 306 }),
        (Part::GridButton, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(372.0, 547.0, 414.0, 589.0), bounds: [-17.0, -20.0, 42.0, 42.0], shape_id: 308 }),
        (Part::GridButton, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(328.0, 547.0, 370.0, 589.0), bounds: [-17.0, -20.0, 42.0, 42.0], shape_id: 310 }),
        (Part::GridButton, State::Selected) => Some(Region { texture: Texture::I7, crop: Rect::new(284.0, 547.0, 326.0, 589.0), bounds: [-17.0, -20.0, 42.0, 42.0], shape_id: 312 }),
        (Part::ListButton, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(240.0, 547.0, 282.0, 589.0), bounds: [-17.0, -20.0, 42.0, 42.0], shape_id: 315 }),
        (Part::ListButton, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(152.0, 547.0, 194.0, 589.0), bounds: [-17.0, -20.0, 42.0, 42.0], shape_id: 317 }),
        (Part::ListButton, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(929.0, 414.0, 971.0, 456.0), bounds: [-17.0, -20.0, 42.0, 42.0], shape_id: 319 }),
        (Part::ListButton, State::Selected) => Some(Region { texture: Texture::I7, crop: Rect::new(108.0, 547.0, 150.0, 589.0), bounds: [-17.0, -20.0, 42.0, 42.0], shape_id: 321 }),
        (Part::TabAll, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(473.0, 414.0, 693.0, 461.0), bounds: [0.0, 0.0, 220.0, 47.0], shape_id: 293 }),
        (Part::TabAll, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(251.0, 414.0, 471.0, 461.0), bounds: [0.0, 0.0, 220.0, 47.0], shape_id: 289 }),
        (Part::TabAll, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(29.0, 414.0, 249.0, 461.0), bounds: [0.0, 0.0, 220.0, 47.0], shape_id: 295 }),
        (Part::TabAll, State::Selected) => Some(Region { texture: Texture::I7, crop: Rect::new(499.0, 0.0, 719.0, 81.0), bounds: [0.0, 0.0, 220.0, 81.0], shape_id: 291 }),
        (Part::TabRecommended, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(473.0, 414.0, 693.0, 461.0), bounds: [0.0, 0.0, 220.0, 47.0], shape_id: 293 }),
        (Part::TabRecommended, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(251.0, 414.0, 471.0, 461.0), bounds: [0.0, 0.0, 220.0, 47.0], shape_id: 289 }),
        (Part::TabRecommended, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(29.0, 414.0, 249.0, 461.0), bounds: [0.0, 0.0, 220.0, 47.0], shape_id: 295 }),
        (Part::TabRecommended, State::Selected) => Some(Region { texture: Texture::I7, crop: Rect::new(499.0, 0.0, 719.0, 81.0), bounds: [0.0, 0.0, 220.0, 81.0], shape_id: 291 }),
        (Part::InventorySlot, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(854.0, 290.0, 906.0, 342.0), bounds: [0.0, 0.0, 52.0, 52.0], shape_id: 39 }),
        (Part::InventorySlot, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(785.0, 357.0, 837.0, 409.0), bounds: [0.0, 0.0, 52.0, 52.0], shape_id: 41 }),
        (Part::InventorySlot, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(854.0, 290.0, 906.0, 342.0), bounds: [0.0, 0.0, 52.0, 52.0], shape_id: 42 }),
        (Part::InventorySlot, State::Selected) => Some(Region { texture: Texture::I7, crop: Rect::new(785.0, 357.0, 837.0, 409.0), bounds: [0.0, 0.0, 52.0, 52.0], shape_id: 43 }),
        (Part::CatalogRow, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(271.0, 156.0, 511.0, 221.0), bounds: [0.0, 0.0, 240.0, 65.0], shape_id: 188 }),
        (Part::CatalogRow, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(29.0, 156.0, 269.0, 221.0), bounds: [0.0, 0.0, 240.0, 65.0], shape_id: 190 }),
        (Part::CatalogRow, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(755.0, 156.0, 995.0, 221.0), bounds: [0.0, 0.0, 240.0, 65.0], shape_id: 192 }),
        (Part::CatalogRow, State::Selected) => Some(Region { texture: Texture::I7, crop: Rect::new(755.0, 156.0, 995.0, 221.0), bounds: [0.0, 0.0, 240.0, 65.0], shape_id: 192 }),
        (Part::CatalogRow, State::Disabled) => Some(Region { texture: Texture::I7, crop: Rect::new(29.0, 223.0, 269.0, 288.0), bounds: [0.0, 0.0, 240.0, 65.0], shape_id: 194 }),
        (Part::CatalogGridBackground, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(781.0, 0.0, 839.0, 72.0), bounds: [0.0, 0.0, 58.0, 72.0], shape_id: 14 }),
        (Part::CatalogGridBackground, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(283.0, 0.0, 353.0, 90.0), bounds: [0.0, 0.0, 58.0, 72.0], shape_id: 16 }),
        (Part::CatalogGridBackground, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(139.0, 0.0, 209.0, 90.0), bounds: [0.0, 0.0, 58.0, 72.0], shape_id: 18 }),
        (Part::CatalogGridBackground, State::Selected) => Some(Region { texture: Texture::I7, crop: Rect::new(139.0, 0.0, 209.0, 90.0), bounds: [0.0, 0.0, 58.0, 72.0], shape_id: 18 }),
        (Part::CatalogGridBackground, State::Disabled) => Some(Region { texture: Texture::I7, crop: Rect::new(355.0, 0.0, 425.0, 90.0), bounds: [0.0, 0.0, 58.0, 72.0], shape_id: 20 }),
        (Part::Details, State::Up) => Some(Region { texture: Texture::I7B, crop: Rect::new(0.0, 0.0, 60.0, 60.0), bounds: [0.0, 0.0, 60.0, 60.0], shape_id: 124 }),
        (Part::Filter, State::Up) => Some(Region { texture: Texture::I7, crop: Rect::new(0.0, 617.0, 278.0, 656.0), bounds: [3.0, 1.0, 278.0, 39.0], shape_id: 217 }),
        (Part::Filter, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(280.0, 617.0, 558.0, 656.0), bounds: [3.0, 1.0, 278.0, 39.0], shape_id: 220 }),
        (Part::Filter, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(280.0, 617.0, 558.0, 656.0), bounds: [3.0, 1.0, 278.0, 39.0], shape_id: 220 }),
        (Part::Filter, State::Selected) => Some(Region { texture: Texture::I7, crop: Rect::new(280.0, 617.0, 558.0, 656.0), bounds: [3.0, 1.0, 278.0, 39.0], shape_id: 220 }),
        (Part::FilterHeader, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(729.0, 463.0, 1007.0, 505.0), bounds: [-36.15, 51.4, 246.0, 36.0], shape_id: 225 }),
        (Part::FilterHeader, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(449.0, 463.0, 727.0, 505.0), bounds: [-36.15, 51.4, 246.0, 36.0], shape_id: 227 }),
        (Part::FilterHeader, State::Selected) => Some(Region { texture: Texture::I7, crop: Rect::new(449.0, 463.0, 727.0, 505.0), bounds: [-36.15, 51.4, 246.0, 36.0], shape_id: 227 }),
        (Part::FilterTag, State::Over) => Some(Region { texture: Texture::I7, crop: Rect::new(729.0, 463.0, 1007.0, 505.0), bounds: [0.0, 0.0, 246.0, 34.0], shape_id: 231 }),
        (Part::FilterTag, State::Down) => Some(Region { texture: Texture::I7, crop: Rect::new(449.0, 463.0, 727.0, 505.0), bounds: [0.0, 0.0, 246.0, 34.0], shape_id: 232 }),
        (Part::FilterTag, State::Selected) => Some(Region { texture: Texture::I7, crop: Rect::new(449.0, 463.0, 727.0, 505.0), bounds: [0.0, 0.0, 246.0, 34.0], shape_id: 232 }),
        (Part::FilterPanel, State::Up) => Some(Region { texture: Texture::IB4, crop: Rect::new(0.0, 0.0, 60.2140789857, 60.2011727422), bounds: [0.0, 0.0, 60.0, 60.0], shape_id: 181 }),
        _ => None,
    }
}

pub fn frame_background() -> Region {
    Region { texture: Texture::I1, crop: Rect::new(0.0, 0.0, 1023.0, 512.0), bounds: [0.0, 0.0, 1023.0, 512.0], shape_id: 2 }
}

/// Source rectangular layers only, in native depth order.
/// Item icon/text/disabled-marker content is supplied by the own client, not native placeholder icons.
/// Arrow uses its initial child frame; runtime arrow transitions are not qualified here.
pub fn layers(part: Part, state: State) -> Vec<Region> {
    match (part, state) {
        (Part::Search, State::Up) => vec![
            Region { texture: Texture::I7, crop: Rect::new(271.0, 290.0, 852.0, 348.0), bounds: [0.0, 0.0, 581.0, 58.0], shape_id: 262 },
            Region { texture: Texture::I7, crop: Rect::new(139.0, 92.0, 702.0, 126.0), bounds: [8.9, 6.0, 563.05, 34.0], shape_id: 262 },
        ],
        (Part::InventorySlot, State::Over | State::Down | State::Selected) => vec![
            Region { texture: Texture::I7, crop: Rect::new(854.0, 290.0, 906.0, 342.0), bounds: [0.0, 0.0, 52.0, 52.0], shape_id: 39 },
            region(part, state).expect("source label is bound"),
        ],
        (Part::TabRecommended, State::Up | State::Over | State::Down | State::Selected) => vec![
            region(part, state).expect("source label is bound"),
            Region { texture: Texture::I7, crop: Rect::new(970.0, 92.0, 988.0, 107.0), bounds: [179.0, 20.0, 18.0, 15.0], shape_id: 299 },
        ],
        _ => region(part, state).into_iter().collect(),
    }
}

pub fn image(images: &SourceImages, region: Region) -> ImageNode {
    ImageNode::new(images.handles[region.texture as usize].clone())
        .with_rect(region.crop)
        .with_mode(NodeImageMode::Stretch)
}

pub fn px_node([x, y, width, height]: [f32; 4]) -> Node {
    Node { position_type: PositionType::Absolute, left: Val::Px(x), top: Val::Px(y),
        width: Val::Px(width), height: Val::Px(height), ..default() }
}

pub fn placement(region: Region) -> NativePlacement {
    NativePlacement(Vec4::from_array(region.bounds))
}
