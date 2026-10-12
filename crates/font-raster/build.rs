use std::path::PathBuf;
fn main() {
    let root=PathBuf::from("../../third_party/freetype-2.4.8");
    println!("cargo:rerun-if-changed=bridge.c");println!("cargo:rerun-if-changed={}",root.display());
    cc::Build::new().file("bridge.c").include(root.join("include")).compile("openleague_font_bridge");
    let files=["autofit/autofit.c","base/ftbase.c","base/ftbbox.c","base/ftbitmap.c","base/ftdebug.c","base/ftglyph.c","base/ftinit.c","base/ftmm.c","base/ftpatent.c","base/ftstroke.c","base/ftsystem.c","base/fttype1.c","base/ftwinfnt.c","bdf/bdf.c","cff/cff.c","cid/type1cid.c","gzip/ftgzip.c","lzw/ftlzw.c","pcf/pcf.c","pfr/pfr.c","psaux/psaux.c","pshinter/pshinter.c","psnames/psnames.c","raster/raster.c","sfnt/sfnt.c","smooth/smooth.c","truetype/truetype.c","type1/type1.c","type42/type42.c","winfonts/winfnt.c"];
    let mut build=cc::Build::new();build.include(root.join("include")).define("FT2_BUILD_LIBRARY",None).warnings(false);
    for file in files {build.file(root.join("src").join(file));}
    build.compile("openleague_freetype_248");
}
