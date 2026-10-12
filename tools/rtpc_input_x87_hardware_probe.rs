mod error{#[derive(Debug)]pub enum Error{Backend(&'static str)}}
use error::Error;
#[cfg(target_arch="x86_64")]
fn loaded(bits:u32)->Result<u32,Error>{
 let mut result=0u32;let mut control=[0x037f0000u32,0,0];
 unsafe{std::arch::asm!("fnstcw word ptr [{control}]","fldcw word ptr [{control} + 2]","fld dword ptr [{bits}]","fstp dword ptr [{result}]","fldcw word ptr [{control}]",control=in(reg)control.as_mut_ptr(),bits=in(reg)&bits,result=in(reg)&mut result,out("st(0)")_,options(nostack));}Ok(result)
}
#[cfg(not(target_arch="x86_64"))]fn loaded(_:u32)->Result<u32,Error>{Err(Error::Backend("native RTPC input x87 conversion unavailable"))}


fn main(){
 for bits in[0u32,0x80000000,0x3f000000,0x7f800000,0xff800000,0x7fc12345,0xffc12345,0x7f812345,0xff812345]{
  println!("{bits:08x},{:08x}",loaded(bits).unwrap());
 }
}
