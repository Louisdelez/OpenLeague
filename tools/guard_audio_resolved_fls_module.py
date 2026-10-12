from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_global_services.rs';s=p.read_text()
needle='for(i,name)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){addresses[i]='
assert needle in s
s=s.replace(needle,'for(i,name)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){let module=match self.references.get(&references[i]){Some(Reference::Procedure{module,..})=>*module,_=>return Err(Error::Backend("native typed FLS export kind mismatch"))};match self.references.get(&module){Some(Reference::Module{name,..})if name.eq_ignore_ascii_case("kernel32.dll")=>{},_=>return Err(Error::Backend("native typed FLS export module mismatch"))}addresses[i]=')
needle='let missing=native.procedure(module,"OpenLeagueDefinitelyMissingExport")'
assert needle in s
s=s.replace(needle,'let other=native.module("KernelBase.dll").unwrap();assert_ne!(other,0);let mut other_refs=[0;4];for(i,n)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){other_refs[i]=native.procedure(other,n).unwrap();}assert!(native.fls_functions(other_refs).is_err());\n  '+needle)
p.write_text(s,encoding='utf-8')
(r/'tools/guard_audio_resolved_fls_module.py').write_text(Path(__file__).read_text(),encoding='utf-8')
print('Guarded registered FLS ABI conversion by original kernel32 module provenance')
