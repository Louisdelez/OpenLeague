using System;
using System.Runtime.InteropServices;
public static class OpenLeagueTlsProbe {
 [DllImport("kernel32.dll", EntryPoint="TlsAlloc")] public static extern uint Alloc();
 [DllImport("kernel32.dll", EntryPoint="TlsFree")] public static extern bool Free(uint index);
 [DllImport("kernel32.dll", EntryPoint="TlsSetValue")] public static extern bool Set(uint index,IntPtr value);
 [DllImport("kernel32.dll", EntryPoint="TlsGetValue")] public static extern IntPtr Get(uint index);
 [DllImport("kernel32.dll", EntryPoint="GetLastError")] public static extern uint Last();
 [DllImport("kernel32.dll", EntryPoint="SetLastError")] public static extern void Error(uint value);
 public static uint[] Run(uint previous,uint payload) {
  uint index=Alloc(); if(index==0xffffffff)throw new Exception("TlsAlloc failed");
  try{if(!Set(index,new IntPtr(payload)))throw new Exception("TlsSetValue failed"); Get(index); Last(); Error(0); Error(previous); uint before=Last(); var result=Get(index); uint after=Last(); Error(before); uint restored=Last(); return new uint[]{before,(uint)result.ToInt64(),after,restored};}finally{Free(index);}
 }
}
