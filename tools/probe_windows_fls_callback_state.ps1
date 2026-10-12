Add-Type -TypeDefinition @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public static class OpenLeagueFlsCallbackStateProbe {
 [UnmanagedFunctionPointer(CallingConvention.Winapi)] public delegate void FlsCallback(IntPtr value);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] static extern uint FlsAlloc(IntPtr callback);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] [return:MarshalAs(UnmanagedType.Bool)] static extern bool FlsFree(uint slot);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] [return:MarshalAs(UnmanagedType.Bool)] static extern bool FlsSetValue(uint slot,IntPtr value);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] static extern void SetLastError(uint value);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] static extern IntPtr FlsGetValue(uint slot);
 [DllImport("kernel32.dll",ExactSpelling=true,SetLastError=false)] static extern uint GetLastError();
 public class Row{public long value,callbackValue,callbackSlotValue;public uint callbackSlotError;public uint errorBefore,errorAfterSet,errorAfterFree;public int callbackCount;public bool setSucceeded,freeSucceeded;}
 public static Row[] Run(){var rows=new List<Row>();foreach(long v in new long[]{0,0x1234})foreach(uint e in new uint[]{0,97,uint.MaxValue}){int calls=0;long argument=0,slotValue=0;uint slotError=0,slot=uint.MaxValue;FlsCallback callback=delegate(IntPtr value){argument=value.ToInt64();uint saved=GetLastError();slotValue=FlsGetValue(slot).ToInt64();slotError=GetLastError();SetLastError(saved);System.Threading.Interlocked.Increment(ref calls);};slot=FlsAlloc(Marshal.GetFunctionPointerForDelegate(callback));if(slot==uint.MaxValue)throw new Exception("FlsAlloc failed");bool freed=false;try{SetLastError(e);bool ok=FlsSetValue(slot,new IntPtr(v));uint afterSet=GetLastError();if(!ok)throw new Exception("FlsSetValue failed");SetLastError(e);bool free=FlsFree(slot);freed=free;uint afterFree=GetLastError();if(!free)throw new Exception("FlsFree failed");rows.Add(new Row{value=v,errorBefore=e,errorAfterSet=afterSet,errorAfterFree=afterFree,setSucceeded=ok,freeSucceeded=free,callbackCount=calls,callbackValue=argument,callbackSlotValue=slotValue,callbackSlotError=slotError});}finally{if(!freed)FlsFree(slot);GC.KeepAlive(callback);}}return rows.ToArray();}
}
"@
$flsCallbackRows = [OpenLeagueFlsCallbackStateProbe]::Run()
$flsCallbackEvidence = [ordered]@{saved_utc=[DateTime]::UtcNow.ToString('o');passed=$true;complete=$false;host_architecture=[Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture.ToString();cases=$flsCallbackRows;limits=@('Actual current Windows FlsAlloc/FlsSetValue/FlsFree with a rooted Winapi callback; argument is opaque and never dereferenced. Every slot freed in finally; native last error measured without CLR preservation.','Callback additionally observes FlsGetValue on its slot during FlsFree and restores its entry LastError; no original or Rust CRT destructor executed. Host architecture does not qualify original32bit bootstrap, fiber/thread teardown, concurrency, callback reentry or actual game integration.')}
$flsCallbackEvidence | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath E:\OpenLeague\docs\audio_windows_fls_callback_state_hardware_discovery.json -Encoding UTF8
Copy-Item -LiteralPath $PSCommandPath -Destination E:\OpenLeague\tools\probe_windows_fls_callback_state.ps1
$flsCallbackRows | Select-Object value,errorBefore,callbackCount,callbackValue,callbackSlotValue,callbackSlotError,errorAfterFree
