//! Native97D0A0 filename bytes. Safe storage avoids native empty-output underwrites.
pub fn normalize(input:&[u8])->Vec<u8> {
    let input=&input[..input.iter().position(|&b|b==0).unwrap_or(input.len())];
    let first=input.iter().position(|&b|b!=b' ' && b!=b'\t').unwrap_or(input.len());
    let input=&input[first..];let last=input.iter().rposition(|&b|b!=b' ').map(|p|p+1).unwrap_or(0);
    let mut output=input[..last].to_vec();
    if output.eq_ignore_ascii_case(b"NONE") {return Vec::new();}
    if let Some(index)=output.windows(4).position(|w|w.eq_ignore_ascii_case(b".tga")) {output[index..index+4].copy_from_slice(b".dds");}
    output
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn filename_bytes_match_every_native_case_without_reproducing_underwrites() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_texture_filename_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],608);
        let bytes=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<_>>();
        let mut underwrites=0;
        for c in proof["cases"].as_array().unwrap() {assert_eq!(normalize(&bytes(&c["input"])),bytes(&c["output"]));underwrites+=usize::from(c["underwrite"].as_bool().unwrap());}
        assert_eq!(underwrites,16);
    }
}
