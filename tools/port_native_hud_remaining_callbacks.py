from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
shutil.copy2(stage/'native_hud_remaining_properties.rs',r/'crates/client/src/native_hud_remaining_properties.rs');shutil.copy2(stage/'qualify_native_hud_remaining_callbacks.py',r/'tools/qualify_native_hud_remaining_callbacks.py')
p=r/'crates/client/src/native_hud_integer_properties.rs';s=p.read_text(encoding='utf-8').replace('fn decimal_prefix(value:','pub(crate) fn decimal_prefix(value:');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_property_driver.rs';s=p.read_text(encoding='utf-8')
if 'pub fn read_line' not in s:
 s=s.replace('fn line(cursor:', 'pub fn read_line(cursor:').replace(')->Vec<u8> {',')->Result<Vec<u8>, &\'static str> {',1).replace('    let mut out=Vec::new();','    if cursor.position>cursor.data.len() || !cursor.data.is_ascii() {return Err("unqualified HUD cursor");}\n    let mut out=Vec::new();',1).replace('    out\n}', '    Ok(out)\n}',1).replace('let bytes=line(cursor);','let bytes=read_line(cursor)?;')
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_property_text.rs';s=p.read_text(encoding='utf-8')
if 'pub fn scan_pattern' not in s:
 s=s.replace('pub fn scan(bytes:&[u8],property:Property)->Result<Scanned,&\'static str> {','pub fn scan_pattern(bytes:&[u8],prefix:&[u8],delimiters:&[u8])->Result<Scanned,&\'static str> {')
 s=s.replace('    let delimiters:&[u8]=match property {Property::Anchor=>b",",Property::Rect|Property::Uv=>b",-,/x"};\n    let mut position=0;', '    if !bytes.starts_with(prefix) {return Ok(Scanned {values:Vec::new(),assignments:0});}\n    let mut position=prefix.len();')
 wrapper='pub fn scan(bytes:&[u8],property:Property)->Result<Scanned,&\'static str> {let delimiters:&[u8]=match property {Property::Anchor=>b",",Property::Rect|Property::Uv=>b",-,/x"};scan_pattern(bytes,b"",delimiters)}\n'
 s=s.replace('#[cfg(test)]',wrapper+'#[cfg(test)]',1)
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_property_apply.rs';s=p.read_text(encoding='utf-8')
s=s.replace('"LeftAnchor"|"Color"|"PerPixelUVsX"|"MinUV"|"EffectParams0"|"EffectColor0"|"EffectColor1"|"Align"=>return Err("registered native HUD property not yet qualified"),','"LeftAnchor"|"MinUV"=>return Err("native HUD property requires following-line cursor"),\n        "Color"|"PerPixelUVsX"|"EffectParams0"|"EffectColor0"|"EffectColor1"|"Align"=>{let mut cursor=crate::native_hud_property_driver::Cursor {data:&[],position:0};return crate::native_hud_remaining_properties::apply(element,key,value,&mut cursor);},')
if 'pub fn apply_with_cursor' not in s:
 s=s.replace('#[cfg(test)]','pub fn apply_with_cursor(element:&mut ElementStorage,key:&str,value:&[u8],origin:[f32;2],cursor:&mut crate::native_hud_property_driver::Cursor<\'_>)->Result<Option<Applied>, &\'static str> {if let Some(out)=crate::native_hud_remaining_properties::apply(element,key,value,cursor)? {return Ok(Some(out));}apply(element,key,value,origin)}\n#[cfg(test)]',1)
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
if 'mod native_hud_remaining_properties;' not in s:s='mod native_hud_remaining_properties;\n'+s
p.write_text(s,encoding='utf-8');print('Eight remaining native HUD callbacks ported; combined source verification next.')
