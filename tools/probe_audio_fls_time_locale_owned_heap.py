from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/probe_audio_fls_custom_locale_owned_heap.py').read_text()
s=s.replace('fls_custom_locale_owned_heap','fls_time_locale_owned_heap').replace('audio_crt_custom_locale_lifecycle_preparation.json','audio_crt_time_locale_lifecycle_preparation.json').replace(".replace('0..126','0..16')", ".replace('0..126','0..8')").replace('PASS32 real FLS custom-locale nested-allocation cases','PASS16 real FLS time-locale nested-allocation cases').replace("'cases':64,'cases_per_architecture':32", "'cases':32,'cases_per_architecture':16").replace('custom time payload pointers in these16 native states are NULL','87 distinct time payload fields are freed in their original destructor; all/alternating input states and count1/count2 ownership exercised')
exec(compile(s,'time-locale-physical-ownership-proof','exec'))
