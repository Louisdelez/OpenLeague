from pathlib import Path
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_global_float_configuration.py').read_text(encoding='utf-8')
s=s.replace("('conversion_cache',0x14a7970,8)]","('conversion_cache',0x14a7970,8),('thread_record',vector+0x12000,0x3bc)]")
s=s.replace('visited=set()','visited=set();windows_calls=[];last_error=0\nw(0xfa43bc,vector+0x28000);w(0xfa43fc,vector+0x28010);w(0xfa4440,vector+0x28020);w(0x2da5308,read(0x1222ed0));w(0x12230cc,5)')
s=s.replace('def hook(uc,a,z,user):visited.add(a)','''def hook(uc,a,z,user):
 global last_error
 visited.add(a)
 if a==vector+0x28000:windows_calls.append({'function':'GetLastError','result':last_error,'at_call':snapshot()});finish(last_error);return
 if a==vector+0x28010:
  slot=read(u.reg_read(UC_X86_REG_ESP)+4);assert slot==5;windows_calls.append({'function':'TlsGetValue','index':slot,'result':vector+0x12000,'last_error_before':last_error,'at_call':snapshot()});last_error=0;finish(vector+0x12000,4);return
 if a==vector+0x28020:
  value=read(u.reg_read(UC_X86_REG_ESP)+4);windows_calls.append({'function':'SetLastError','value':value,'last_error_before':last_error,'at_call':snapshot()});last_error=value;finish(0,4);return''')
s=s.replace('w(0x12100d4,priority);','u.mem_write(vector+0x12000,bytes(0x3bc));last_error=97;windows_calls.clear();w(0x12100d4,priority);')
s=s.replace("'fpcw_after':u.reg_read(UC_X86_REG_FPCW)","'windows_calls':list(windows_calls),'last_error_after':last_error,'fpcw_after':u.reg_read(UC_X86_REG_FPCW)")
s=s.replace('audio_global_float_configuration_preparation.json','audio_global_float_configuration_tls_preparation.json').replace('probe_native_audio_global_float_configuration.py','probe_native_audio_global_float_configuration_tls.py')
s=s.replace('execute without service substitution.','execute original bodies; only Windows GetLastError/TlsGetValue/SetLastError are explicit ABI adapters.').replace('supplied global/cache state,','supplied global/cache/initialized thread-record state, decoded CRT TLS dispatchNULL, slot5, prior LastError97; TlsGetValue returns supplied record and sets LastError0, native CRT restores prior97. Imported-call boundaries measured on actual Windows APIs in docs/audio_global_float_tls_hardware_discovery.json;')
s=s.replace('Native CRT hardware dispatch/startup controls, signaling NaNs and full resource/global integration require separate validation.','Actual Windows API probe uses current64bit host; entire original32bit CRT initialization/device context not proved. Supplied zeroed3BC record, absent locale/signal/custom math handler state. Native CRT hardware dispatch/startup controls, signaling NaNs and full resource/global integration require separate validation.')
(r/'tools/probe_native_audio_global_float_configuration_tls.py').write_text(s,encoding='utf-8');exec(compile(s,'original float with explicit measured TLS ABI','exec'))
