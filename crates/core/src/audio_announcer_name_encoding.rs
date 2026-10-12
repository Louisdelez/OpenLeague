//! Original99C1F0/99C030 UTF16-to-multibyte primitives, including legacy surrogate rules.
//! A zero-capacity destination's preceding byte is explicit storage, never an unsafe write.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct WriteState { pub position: u32, pub flag_word: u32 }
fn scalar(units:&[u16], cursor:&mut usize)->Result<u32,&'static str> {
    let first=*units.get(*cursor).ok_or("native wide source unavailable")? as u32;
    *cursor+=1;
    if (0xd800..=0xdbff).contains(&first) {
        let next=*units.get(*cursor).ok_or("native surrogate follower unavailable")? as u32;
        *cursor+=1;
        // Original combines any follower; it does not validate a low-surrogate range.
        Ok((first<<10).wrapping_add(0xfca02400).wrapping_add(next))
    } else {Ok(first)}
}
fn bytes(value:u32)->([u8;4],usize) {
    if value<0x80 {([value as u8,0,0,0],1)}
    else if value<0x800 {([((value>>6) as u8)|0xc0,((value&0x3f) as u8)|0x80,0,0],2)}
    else if value<0x10000 {([((value>>12) as u8)|0xe0,(((value>>6)&0x3f) as u8)|0x80,((value&0x3f) as u8)|0x80,0],3)}
    else {([((value>>18) as u8)|0xf0,(((value>>12)&0x3f) as u8)|0x80,(((value>>6)&0x3f) as u8)|0x80,((value&0x3f) as u8)|0x80],4)}
}
/// The caller supplies the exact UTF16 range, including the terminator if required.
pub fn encoded_size(units:&[u16])->Result<usize,&'static str> {
    let mut cursor=0;let mut size=0usize;
    while cursor<units.len() {let value=scalar(units,&mut cursor)?;size=size.checked_add(bytes(value).1).ok_or("native encoded size overflow")?;}
    Ok(size)
}
/// Reproduce saturation: after capacity is reached, subsequent bytes overwrite its last byte.
/// With capacity zero the original primitive overwrites the preceding byte, modeled separately.
/// Native higher-level99AB40 uses positive preflight sizes before calling this writer.
pub fn encode(units:&[u16],output:&mut[u8],preceding:&mut u8)->Result<WriteState,&'static str> {
    encoded_size(units)?; // Reject unavailable surrogate storage before mutating any destination.
    if output.len()>i32::MAX as usize {return Err("native destination size unsupported");}
    let mut cursor=0;let mut state=WriteState {position:0,flag_word:0};
    while cursor<units.len() {
        let value=scalar(units,&mut cursor)?;let (encoded,length)=bytes(value);
        for byte in &encoded[..length] {
            let position=state.position as usize;
            if position<output.len() {output[position]=*byte;state.position+=1;}
            else {state.flag_word=1;if let Some(last)=output.last_mut() {*last=*byte;} else {*preceding=*byte;}}
        }
    }
    Ok(state)
}
fn narrow_scalar(memory:&[u8],cursor:&mut usize)->Result<u32,&'static str> {
    let first=*memory.get(*cursor).ok_or("native narrow source unavailable")?;
    let length=if first<0x80 {1} else if first&0xe0==0xc0 {2} else if first&0xf0==0xe0 {3} else if first&0xf8==0xf0 {4} else {1};
    let mut value=match length {2=>(first&0x1f) as u32,3=>(first&0xf) as u32,4=>(first&7) as u32,_=>first as u32};
    for offset in 1..length {
        // Native masks every follower; it does not validate continuation bytes or range ends.
        let byte=*memory.get(*cursor+offset).ok_or("native narrow lookahead storage unavailable")?;
        value=(value<<6)+(byte&0x3f) as u32;
    }
    *cursor+=length;Ok(value)
}
/// Native range-end guards only the start of each sequence. Any additional memory needed
/// by a malformed sequence must be supplied explicitly, never invented as padding.
pub fn decoded_size(memory:&[u8],range_end:usize)->Result<usize,&'static str> {
    if range_end>memory.len() {return Err("native narrow range unavailable");}
    let mut cursor=0;let mut size=0usize;
    while cursor<range_end {size=size.checked_add(if narrow_scalar(memory,&mut cursor)?>0xffff {2} else {1}).ok_or("native decoded size overflow")?;}
    Ok(size)
}
/// Original99B230 C-string mode: the first NUL participates in conversion.
/// Capacity zero selects preflight, while positive capacities saturate and overwrite the last unit.
pub fn decode_cstring(memory:&[u8],output:&mut[u16])->Result<u32,&'static str> {
    let end=memory.iter().position(|b|*b==0).ok_or("native narrow terminator unavailable")?+1;
    let size=decoded_size(memory,end)?;
    if output.is_empty() {return u32::try_from(size).map_err(|_|"native decoded size unsupported");}
    if output.len()>i32::MAX as usize {return Err("native wide destination size unsupported");}
    let mut cursor=0;let mut position=0usize;
    while cursor<end {
        let value=narrow_scalar(memory,&mut cursor)?;
        let (units,count)=if value>0xffff {([((value>>10).wrapping_sub(0x2840)) as u16,((value&0x3ff).wrapping_sub(0x2400)) as u16],2)} else {([value as u16,0],1)};
        for unit in &units[..count] {
            if position<output.len() {output[position]=*unit;position+=1;} else {*output.last_mut().unwrap()=*unit;}
        }
    }
    Ok(position as u32)
}
#[derive(Debug, PartialEq, Eq)]
pub struct ConvertedName { pub success: bool, pub bytes: Vec<u8>, pub sized_cache_len: usize }
/// Byte-level normal-return composition of99AD50/99AB40. String allocation and
/// native exceptional unwinding are separate obligations; input lookahead is explicit.
pub fn convert_name_bytes(memory:&[u8])->Result<ConvertedName,&'static str> {
    let expected=decode_cstring(memory,&mut[])? as usize;
    if expected==0 {return Err("native name preflight exception unqualified");}
    let mut wide=vec![0;expected];
    if decode_cstring(memory,&mut wide)? as usize!=expected {return Err("native name decode count exception unqualified");}
    // Native99B390 searches backwards; it trims at the last NUL within the length.
    if let Some(last)=wide.iter().rposition(|v|*v==0) {wide.truncate(last);}
    // A constructed native string has its own terminator beyond the stored length.
    wide.push(0);
    let end=wide.iter().position(|v|*v==0).unwrap()+1;
    let size=encoded_size(&wide[..end])?;
    let mut output=vec![0;size];let mut preceding=0;
    let state=encode(&wide[..end],&mut output,&mut preceding)?;
    if let Some(last)=output.iter().rposition(|v|*v==0) {output.truncate(last);}
    Ok(ConvertedName {success:state.position!=0,bytes:output,sized_cache_len:size})
}
#[cfg(test)] mod tests {
    use super::*;
    fn hex(bytes:&[u8])->String {bytes.iter().map(|b|format!("{b:02x}")).collect()}
    fn unhex(text:&str)->Vec<u8> {(0..text.len()).step_by(2).map(|i|u8::from_str_radix(&text[i..i+2],16).unwrap()).collect()}
    #[test] fn audio_name_conversion_matches1324_native_composed_decoder_encoder_reverse_nul_trim_and_cache_cases() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_name_conversion_composed_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1324);
        for case in cases {
            let mut memory=unhex(case["input_hex"].as_str().unwrap());let length=memory.len();memory.push(0);memory.extend_from_slice(&[0xcc;32]);
            if length<16 {memory[16..20].copy_from_slice(&(length as u32).to_le_bytes());memory[20..24].copy_from_slice(&15u32.to_le_bytes());}
            let result=convert_name_bytes(&memory).unwrap();assert_eq!(result.success,case["returned_success"].as_bool().unwrap());
            assert_eq!(hex(&result.bytes),case["output_hex"].as_str().unwrap());assert_eq!(result.bytes.len() as u64,case["length"].as_u64().unwrap());
        }
    }
    #[test] fn audio_narrow_decoder_matches2351_actual_native_ascii_unicode_malformed_sequences_and_capacity_cases() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_name_narrow_decoder_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),2351);
        for case in cases {
            let mut memory=unhex(case["input_hex"].as_str().unwrap());memory.push(0);memory.extend_from_slice(&[0xcc;32]);
            assert_eq!(decode_cstring(&memory,&mut[]).unwrap() as u64,case["preflight_units"].as_u64().unwrap());
            let mut output=vec![0xcccc;case["capacity_units"].as_u64().unwrap() as usize];
            assert_eq!(decode_cstring(&memory,&mut output).unwrap() as u64,case["returned_units"].as_u64().unwrap());
            assert_eq!(hex(&output.iter().flat_map(|v|v.to_le_bytes()).collect::<Vec<_>>()),case["output_buffer_hex"].as_str().unwrap());
        }
    }
    #[test] fn audio_wide_encoder_matches615_actual_native_unicode_surrogates_saturated_and_zero_capacity_writes() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_name_wide_encoder_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),615);
        for case in cases {
            let units:Vec<u16>=case["input_utf16_units"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u16).collect();
            assert_eq!(encoded_size(&units).unwrap() as u64,case["preflight_bytes"].as_u64().unwrap());
            let mut destination=vec![0xcc;case["capacity_bytes"].as_u64().unwrap() as usize];let mut preceding=0xcc;
            let state=encode(&units,&mut destination,&mut preceding).unwrap();
            assert_eq!(state.position as u64,case["returned_position"].as_u64().unwrap());assert_eq!(state.flag_word as u64,case["returned_flag_word"].as_u64().unwrap());
            assert_eq!(hex(&destination),case["output_buffer_hex"].as_str().unwrap());assert_eq!(hex(&[preceding]),case["preceding_byte_hex"].as_str().unwrap());
        }
    }
}
