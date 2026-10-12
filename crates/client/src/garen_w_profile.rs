//! Explicit base-skin texture descriptor, not an implementation of all W effects.
//! Exact field bytes and native reader sites are in garen_w_base_profile.json.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct BaseOverride {
    pub group: &'static str,
    pub keyword_required: &'static str,
    pub texture_asset: &'static str,
    pub texture_sha256: &'static str,
    pub submesh: &'static str,
    pub priority: i32,
    pub descriptor_flags: u32,
    pub owner_flags: u32,
}
pub const BASE_OVERRIDE: BaseOverride = BaseOverride {
    group: "base_override",
    keyword_required: "Garen",
    texture_asset: "champions/garen/effects/Garen_Base_W_Metal_Gold.dds",
    texture_sha256: "f09d42ff8a4a373c53e5acd7c0023f5bd33fa3a986c8cb2bc5b7560b0825808a",
    submesh: "",
    priority: 0,
    descriptor_flags: 0x02,
    owner_flags: 0x01,
};
// No keyword matching implementation is inferred here. The host must explicitly
// select the verified base model. Other skins remain outside this descriptor.
// Native empty submesh applies to all model submeshes; it is not a bone name.
