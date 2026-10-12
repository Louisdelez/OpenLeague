from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_global_services.rs';s=p.read_text()
s=s.replace('fn DecodePointer(pointer:*mut c_void)->*mut c_void;}', 'fn DecodePointer(pointer:*mut c_void)->*mut c_void;fn GetLastError()->u32;fn SetLastError(value:u32);}')
s=s.replace('#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure', 'struct NativeError(u32);impl Drop for NativeError{fn drop(&mut self){unsafe{SetLastError(self.0)}}}\n#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure',1)
for needle in ['GetModuleHandleW(wide.as_ptr())}as usize;', 'GetProcAddress(host as*mut c_void,name_c.as_ptr().cast())}as usize;', 'EncodePointer(source as usize as*mut c_void)}as usize;', 'DecodePointer(*pointer as*mut c_void)}as usize;']:
 assert needle in s;s=s.replace(needle,needle+'let _native_error=NativeError(unsafe{GetLastError()});')
needle='   assert!(d.is_empty());count+=1;'
addition=r'''
   let nil=match native.events()[0]{Event::Encode{result,..}=>result,_=>panic!("expected encoded NULL")};let terminate=match native.events()[1]{Event::Encode{result,..}=>result,_=>panic!("expected encoded terminate")};
   for v in p["regions"].as_array().unwrap(){let a=v["reference"].as_u64().unwrap()as u32;let mut expected=bytes(row["after"][v["name"].as_str().unwrap()].as_str().unwrap());for j in (0..expected.len()).step_by(4){let at=a+j as u32;let replacement=if[0x14ae620,0x14ae624,0x14ae86c,0x14ae60c,0x14ae610,0x14ae614,0x14ae618,0x14af108].contains(&at){Some(nil)}else if at==0x14ae5b0{Some(terminate)}else if (0x2da5300..0x2da5300+33*4).contains(&at){let slot=(at-0x2da5300)/4;let i=match slot{21=>22,22=>21,_=>slot}as usize;let Event::Procedure{result,..}=native.events()[3+i]else{panic!("expected resolved procedure")};Some(result^cookie)}else{None};if let Some(word)=replacement{expected[j..j+4].copy_from_slice(&word.to_le_bytes());}}assert_eq!(crate::audio_path_memory::read(&m,a,expected.len()).unwrap(),expected,"full native bank after explicit host-reference relocation {a:x}");}
'''
assert needle in s;s=s.replace(needle,addition+needle)
# Validate failed native lookups keep the actual API error despite tracing/registry work.
needle='assert_eq!(native.procedure(module,"OpenLeagueDefinitelyMissingExport"),Ok(0));'
replacement='''let host=match native.references[&module]{Reference::Module{pointer,..}=>pointer,_=>panic!("module required")};let name=CString::new("OpenLeagueDefinitelyMissingExport").unwrap();unsafe{SetLastError(97)};assert!(unsafe{GetProcAddress(host as*mut c_void,name.as_ptr().cast())}.is_null());let original_error=unsafe{GetLastError()};unsafe{SetLastError(97)};native.enable_trace();assert_eq!(native.procedure(module,"OpenLeagueDefinitelyMissingExport"),Ok(0));assert_eq!(unsafe{GetLastError()},original_error);'''
assert needle in s;s=s.replace(needle,replacement)
p.write_text(s,encoding='utf-8');(r/'tools/refine_audio_windows_global_services.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Preserved native API error state; full original global banks compared with explicit pointer-token relocation')
