fn main(){
 let inputs=[0u32,0x80000000,0x3f800000,0x7f800000,0xff800000,0x7fc01234,0x7fa01234,0xffa01234];
 println!("[");
 for (i,bits) in IntoIterator::into_iter(inputs).enumerate(){let mut copied=0u32;let mut cw=0u16;unsafe{std::arch::asm!("fnstcw word ptr [{cw}]","fld dword ptr [{src}]","fstp dword ptr [{dst}]",cw=in(reg)&mut cw,src=in(reg)&bits,dst=in(reg)&mut copied,out("st(0)") _,options(nostack));}println!("{{\"input_bits\":{bits},\"output_bits\":{copied},\"control_word\":{cw}}}{}",if i==7 {""}else{","});}
 println!("]");
}
