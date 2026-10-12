Add-Type -TypeDefinition @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public static class OpenLeagueFlsErrorProbe {
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] static extern uint FlsAlloc(IntPtr callback);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] [return:MarshalAs(UnmanagedType.Bool)] static extern bool FlsFree(uint slot);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] [return:MarshalAs(UnmanagedType.Bool)] static extern bool FlsSetValue(uint slot,IntPtr value);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] static extern IntPtr FlsGetValue(uint slot);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] static extern void SetLastError(uint value);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] static extern uint GetLastError();
 public class Row {public uint errorBefore,errorAfterSet,errorAfterGet;public long value,result;public bool setSucceeded;}
 public static Row[] Run(){uint slot=FlsAlloc(IntPtr.Zero);if(slot==uint.MaxValue)throw new Exception("FlsAlloc failed");var rows=new List<Row>();try {foreach(long v in new long[]{0,0x1234})foreach(uint e in new uint[]{0,97,uint.MaxValue}){SetLastError(e);bool ok=FlsSetValue(slot,new IntPtr(v));uint setError=GetLastError();SetLastError(e);IntPtr actual=FlsGetValue(slot);uint getError=GetLastError();if(!ok||actual.ToInt64()!=v)throw new Exception("FLS storage did not roundtrip");rows.Add(new Row{value=v,result=actual.ToInt64(),errorBefore=e,errorAfterSet=setError,errorAfterGet=getError,setSucceeded=ok});}}finally {if(!FlsFree(slot))throw new Exception("FlsFree failed");}return rows.ToArray();}
}
"@
$flsEvidenceRows = [OpenLeagueFlsErrorProbe]::Run()
$flsEvidence = [ordered]@{ saved_utc=[DateTime]::UtcNow.ToString('o'); passed=$true; complete=$false; host_architecture=[Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture.ToString(); cases=$flsEvidenceRows; limits=@('Actual current Windows kernel32 FLS APIs measured with actual temporary slot; slot always freed; no callback installed. Opaque value pointer stored without dereferencing.','Current host architecture does not prove original32bit CRT bootstrap, callback/destructor lifetime or concurrency. Import methods explicitly do not use CLR SetLastError preservation/reset.') }
$flsEvidence | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath E:\OpenLeague\docs\audio_windows_fls_error_hardware_discovery.json -Encoding UTF8
Copy-Item -LiteralPath $PSCommandPath -Destination E:\OpenLeague\tools\probe_windows_fls_error.ps1
$flsEvidenceRows | Select-Object value,errorBefore,errorAfterSet,errorAfterGet
