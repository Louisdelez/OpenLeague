// Generated from byte-qualified B2BB30 setter. Preserve f32 operation order.
#[allow(unused_assignments)]
fn expand(input:[f32;5])->[f32;40] {
 let mut out=[0.0f32;40]; let mut stack=[0.0f32;12];
 stack[6..11].copy_from_slice(&input);
 let mut eax:f32;
 let mut xmm0=[0.0f32;4];
 let mut xmm1=[0.0f32;4];
 let mut xmm2=[0.0f32;4];
 let mut xmm3=[0.0f32;4];
 let mut xmm4=[0.0f32;4];
 let mut xmm5=[0.0f32;4];
 let mut xmm6=[0.0f32;4];
 let mut xmm7=[0.0f32;4];
 // 0xb2bb36 movss xmm4, dword ptr [ebp + 8]
 xmm4 = [stack[6],0.0,0.0,0.0];
 // 0xb2bb3b movss xmm7, dword ptr [ebp + 0x14]
 xmm7 = [stack[9],0.0,0.0,0.0];
 // 0xb2bb40 movaps xmm2, xmm4
 xmm2 = xmm4;
 // 0xb2bb43 xorps xmm7, xmmword ptr [0x11393d0]
 for v in &mut xmm7 {*v=f32::from_bits(v.to_bits() ^ 0x80000000);}
 // 0xb2bb4a movss xmm0, xmm4
 xmm0[0] = xmm4[0];
 // 0xb2bb4e movss xmm5, dword ptr [ebp + 0xc]
 xmm5 = [stack[7],0.0,0.0,0.0];
 // 0xb2bb53 movss xmm6, dword ptr [ebp + 0x10]
 xmm6 = [stack[8],0.0,0.0,0.0];
 // 0xb2bb58 movss xmm3, dword ptr [ebp + 0x18]
 xmm3 = [stack[10],0.0,0.0,0.0];
 // 0xb2bb5d xorps xmm3, xmmword ptr [0x11393d0]
 for v in &mut xmm3 {*v=f32::from_bits(v.to_bits() ^ 0x80000000);}
 // 0xb2bb64 mulss xmm2, xmm7
 xmm2[0] = xmm2[0] * xmm7[0];
 // 0xb2bb68 mov dword ptr [ebp - 0x10], 0
 stack[0] = 0.0f32;
 // 0xb2bb6f mov eax, dword ptr [ebp - 0x10]
 eax = stack[0];
 // 0xb2bb72 mov dword ptr [ecx + 0x10], eax
 out[4] = eax;
 // 0xb2bb75 addss xmm2, xmm5
 xmm2[0] = xmm2[0] + xmm5[0];
 // 0xb2bb79 shufps xmm0, xmm0, 0
 xmm0 = [xmm0[0];4];
 // 0xb2bb7d movaps xmmword ptr [ecx], xmm0
 out[0..4].copy_from_slice(&xmm0);
 // 0xb2bb80 movaps xmm0, xmm4
 xmm0 = xmm4;
 // 0xb2bb83 mulss xmm0, xmm3
 xmm0[0] = xmm0[0] * xmm3[0];
 // 0xb2bb87 mov dword ptr [ebp - 0xc], 0
 stack[1] = 0.0f32;
 // 0xb2bb8e mov eax, dword ptr [ebp - 0xc]
 eax = stack[1];
 // 0xb2bb91 mov dword ptr [ecx + 0x14], eax
 out[5] = eax;
 // 0xb2bb94 movaps xmm1, xmm2
 xmm1 = xmm2;
 // 0xb2bb97 mulss xmm1, xmm7
 xmm1[0] = xmm1[0] * xmm7[0];
 // 0xb2bb9b mov dword ptr [ebp - 8], 0
 stack[2] = 0.0f32;
 // 0xb2bba2 mov eax, dword ptr [ebp - 8]
 eax = stack[2];
 // 0xb2bba5 mov dword ptr [ecx + 0x18], eax
 out[6] = eax;
 // 0xb2bba8 addss xmm1, xmm6
 xmm1[0] = xmm1[0] + xmm6[0];
 // 0xb2bbac movss dword ptr [ebp - 4], xmm2
 stack[3] = xmm2[0];
 // 0xb2bbb1 mov eax, dword ptr [ebp - 4]
 eax = stack[3];
 // 0xb2bbb4 mov dword ptr [ecx + 0x1c], eax
 out[7] = eax;
 // 0xb2bbb7 movss dword ptr [ebp + 0x14], xmm7
 stack[9] = xmm7[0];
 // 0xb2bbbc movss dword ptr [ecx + 0x8c], xmm7
 out[35] = xmm7[0];
 // 0xb2bbc4 addss xmm1, xmm0
 xmm1[0] = xmm1[0] + xmm0[0];
 // 0xb2bbc8 mulss xmm7, xmm3
 xmm7[0] = xmm7[0] * xmm3[0];
 // 0xb2bbcc mov dword ptr [ebp - 0x10], 0
 stack[0] = 0.0f32;
 // 0xb2bbd3 mov eax, dword ptr [ebp - 0x10]
 eax = stack[0];
 // 0xb2bbd6 mov dword ptr [ecx + 0x20], eax
 out[8] = eax;
 // 0xb2bbd9 mov dword ptr [ebp - 0xc], 0
 stack[1] = 0.0f32;
 // 0xb2bbe0 movaps xmm0, xmm7
 xmm0 = xmm7;
 // 0xb2bbe3 mov eax, dword ptr [ebp - 0xc]
 eax = stack[1];
 // 0xb2bbe6 mov dword ptr [ecx + 0x24], eax
 out[9] = eax;
 // 0xb2bbe9 movss dword ptr [ebp - 8], xmm2
 stack[2] = xmm2[0];
 // 0xb2bbee mov eax, dword ptr [ebp - 8]
 eax = stack[2];
 // 0xb2bbf1 movss dword ptr [ebp - 4], xmm1
 stack[3] = xmm1[0];
 // 0xb2bbf6 movss dword ptr [ebp - 8], xmm1
 stack[2] = xmm1[0];
 // 0xb2bbfb mulss xmm1, dword ptr [ebp + 0x14]
 xmm1[0] = xmm1[0] * stack[9];
 // 0xb2bc00 mov dword ptr [ecx + 0x28], eax
 out[10] = eax;
 // 0xb2bc03 mov eax, dword ptr [ebp - 4]
 eax = stack[3];
 // 0xb2bc06 mulss xmm0, xmm4
 xmm0[0] = xmm0[0] * xmm4[0];
 // 0xb2bc0a mov dword ptr [ecx + 0x2c], eax
 out[11] = eax;
 // 0xb2bc0d movss dword ptr [ebp + 0x18], xmm3
 stack[10] = xmm3[0];
 // 0xb2bc12 movss dword ptr [ecx + 0x90], xmm3
 out[36] = xmm3[0];
 // 0xb2bc1a movaps xmm3, xmm5
 xmm3 = xmm5;
 // 0xb2bc1d mulss xmm3, dword ptr [ebp + 0x18]
 xmm3[0] = xmm3[0] * stack[10];
 // 0xb2bc22 addss xmm0, xmm1
 xmm0[0] = xmm0[0] + xmm1[0];
 // 0xb2bc26 mov dword ptr [ebp - 0x10], 0
 stack[0] = 0.0f32;
 // 0xb2bc2d mov eax, dword ptr [ebp - 0x10]
 eax = stack[0];
 // 0xb2bc30 movss dword ptr [ecx + 0x84], xmm5
 out[33] = xmm5[0];
 // 0xb2bc38 movss dword ptr [ebp - 0x10], xmm5
 stack[0] = xmm5[0];
 // 0xb2bc3d addss xmm0, xmm3
 xmm0[0] = xmm0[0] + xmm3[0];
 // 0xb2bc41 mov dword ptr [ecx + 0x30], eax
 out[12] = eax;
 // 0xb2bc44 movss dword ptr [ebp - 0xc], xmm2
 stack[1] = xmm2[0];
 // 0xb2bc49 movaps xmm2, xmm6
 xmm2 = xmm6;
 // 0xb2bc4c mov eax, dword ptr [ebp - 0xc]
 eax = stack[1];
 // 0xb2bc4f mov dword ptr [ecx + 0x34], eax
 out[13] = eax;
 // 0xb2bc52 mov eax, dword ptr [ebp - 8]
 eax = stack[2];
 // 0xb2bc55 movss dword ptr [ebp - 4], xmm0
 stack[3] = xmm0[0];
 // 0xb2bc5a movss xmm0, dword ptr [ebp + 0x14]
 xmm0 = [stack[9],0.0,0.0,0.0];
 // 0xb2bc5f mulss xmm5, xmm0
 xmm5[0] = xmm5[0] * xmm0[0];
 // 0xb2bc63 mov dword ptr [ecx + 0x38], eax
 out[14] = eax;
 // 0xb2bc66 mov eax, dword ptr [ebp - 4]
 eax = stack[3];
 // 0xb2bc69 movss dword ptr [ecx + 0x80], xmm4
 out[32] = xmm4[0];
 // 0xb2bc71 movss xmm4, dword ptr [ebp + 0x18]
 xmm4 = [stack[10],0.0,0.0,0.0];
 // 0xb2bc76 addss xmm5, xmm6
 xmm5[0] = xmm5[0] + xmm6[0];
 // 0xb2bc7a movss dword ptr [ecx + 0x88], xmm6
 out[34] = xmm6[0];
 // 0xb2bc82 mov dword ptr [ecx + 0x3c], eax
 out[15] = eax;
 // 0xb2bc85 mulss xmm2, xmm4
 xmm2[0] = xmm2[0] * xmm4[0];
 // 0xb2bc89 movss dword ptr [ebp - 0xc], xmm5
 stack[1] = xmm5[0];
 // 0xb2bc8e mulss xmm5, xmm0
 xmm5[0] = xmm5[0] * xmm0[0];
 // 0xb2bc92 addss xmm5, xmm3
 xmm5[0] = xmm5[0] + xmm3[0];
 // 0xb2bc96 movss dword ptr [ebp - 8], xmm5
 stack[2] = xmm5[0];
 // 0xb2bc9b mulss xmm5, xmm0
 xmm5[0] = xmm5[0] * xmm0[0];
 // 0xb2bc9f movaps xmm1, xmm6
 xmm1 = xmm6;
 // 0xb2bca2 mov eax, dword ptr [ebp - 0x10]
 eax = stack[0];
 // 0xb2bca5 mulss xmm3, xmm0
 xmm3[0] = xmm3[0] * xmm0[0];
 // 0xb2bca9 mov dword ptr [ecx + 0x40], eax
 out[16] = eax;
 // 0xb2bcac mov eax, dword ptr [ebp - 0xc]
 eax = stack[1];
 // 0xb2bcaf addss xmm5, xmm2
 xmm5[0] = xmm5[0] + xmm2[0];
 // 0xb2bcb3 movss dword ptr [ebp - 0x10], xmm6
 stack[0] = xmm6[0];
 // 0xb2bcb8 mulss xmm6, dword ptr [0x1138df8]
 xmm6[0] = xmm6[0] * f32::from_bits(0x40000000);
 // 0xb2bcc0 mov dword ptr [ecx + 0x44], eax
 out[17] = eax;
 // 0xb2bcc3 mov eax, dword ptr [ebp - 8]
 eax = stack[2];
 // 0xb2bcc6 addss xmm5, xmm3
 xmm5[0] = xmm5[0] + xmm3[0];
 // 0xb2bcca mov dword ptr [ecx + 0x48], eax
 out[18] = eax;
 // 0xb2bccd mulss xmm6, xmm4
 xmm6[0] = xmm6[0] * xmm4[0];
 // 0xb2bcd1 movaps xmm3, xmm4
 xmm3 = xmm4;
 // 0xb2bcd4 mulss xmm3, dword ptr [0x1138df8]
 xmm3[0] = xmm3[0] * f32::from_bits(0x40000000);
 // 0xb2bcdc movss dword ptr [ebp - 4], xmm5
 stack[3] = xmm5[0];
 // 0xb2bce1 movaps xmm5, xmm0
 xmm5 = xmm0;
 // 0xb2bce4 mov eax, dword ptr [ebp - 4]
 eax = stack[3];
 // 0xb2bce7 mulss xmm1, xmm5
 xmm1[0] = xmm1[0] * xmm5[0];
 // 0xb2bceb mov dword ptr [ecx + 0x4c], eax
 out[19] = eax;
 // 0xb2bcee mov eax, dword ptr [ebp - 0x10]
 eax = stack[0];
 // 0xb2bcf1 mov dword ptr [ecx + 0x50], eax
 out[20] = eax;
 // 0xb2bcf4 movss dword ptr [ebp - 0xc], xmm1
 stack[1] = xmm1[0];
 // 0xb2bcf9 mov eax, dword ptr [ebp - 0xc]
 eax = stack[1];
 // 0xb2bcfc mulss xmm1, xmm5
 xmm1[0] = xmm1[0] * xmm5[0];
 // 0xb2bd00 mov dword ptr [ecx + 0x54], eax
 out[21] = eax;
 // 0xb2bd03 movss dword ptr [ebp - 0x10], xmm5
 stack[0] = xmm5[0];
 // 0xb2bd08 movaps xmm0, xmm1
 xmm0 = xmm1;
 // 0xb2bd0b addss xmm6, xmm1
 xmm6[0] = xmm6[0] + xmm1[0];
 // 0xb2bd0f addss xmm0, xmm2
 xmm0[0] = xmm0[0] + xmm2[0];
 // 0xb2bd13 movaps xmm1, xmm5
 xmm1 = xmm5;
 // 0xb2bd16 mulss xmm1, xmm5
 xmm1[0] = xmm1[0] * xmm5[0];
 // 0xb2bd1a movaps xmm2, xmm4
 xmm2 = xmm4;
 // 0xb2bd1d mulss xmm2, xmm4
 xmm2[0] = xmm2[0] * xmm4[0];
 // 0xb2bd21 movss dword ptr [ebp - 8], xmm0
 stack[2] = xmm0[0];
 // 0xb2bd26 movaps xmm0, xmm1
 xmm0 = xmm1;
 // 0xb2bd29 mov eax, dword ptr [ebp - 8]
 eax = stack[2];
 // 0xb2bd2c addss xmm0, xmm4
 xmm0[0] = xmm0[0] + xmm4[0];
 // 0xb2bd30 mov dword ptr [ecx + 0x58], eax
 out[22] = eax;
 // 0xb2bd33 mulss xmm6, xmm5
 xmm6[0] = xmm6[0] * xmm5[0];
 // 0xb2bd37 movss dword ptr [ebp - 0xc], xmm0
 stack[1] = xmm0[0];
 // 0xb2bd3c movaps xmm0, xmm3
 xmm0 = xmm3;
 // 0xb2bd3f addss xmm0, xmm1
 xmm0[0] = xmm0[0] + xmm1[0];
 // 0xb2bd43 movss dword ptr [ebp - 4], xmm6
 stack[3] = xmm6[0];
 // 0xb2bd48 mov eax, dword ptr [ebp - 4]
 eax = stack[3];
 // 0xb2bd4b mov dword ptr [ecx + 0x5c], eax
 out[23] = eax;
 // 0xb2bd4e mov eax, dword ptr [ebp - 0x10]
 eax = stack[0];
 // 0xb2bd51 mov dword ptr [ecx + 0x60], eax
 out[24] = eax;
 // 0xb2bd54 mulss xmm0, xmm5
 xmm0[0] = xmm0[0] * xmm5[0];
 // 0xb2bd58 mov eax, dword ptr [ebp - 0xc]
 eax = stack[1];
 // 0xb2bd5b movss dword ptr [ebp - 0xc], xmm7
 stack[1] = xmm7[0];
 // 0xb2bd60 mov dword ptr [ecx + 0x64], eax
 out[25] = eax;
 // 0xb2bd63 movss dword ptr [ebp - 8], xmm0
 stack[2] = xmm0[0];
 // 0xb2bd68 movaps xmm0, xmm4
 xmm0 = xmm4;
 // 0xb2bd6b mulss xmm0, dword ptr [0x1138e98]
 xmm0[0] = xmm0[0] * f32::from_bits(0x40400000);
 // 0xb2bd73 mov eax, dword ptr [ebp - 8]
 eax = stack[2];
 // 0xb2bd76 mulss xmm7, xmm5
 xmm7[0] = xmm7[0] * xmm5[0];
 // 0xb2bd7a mov dword ptr [ecx + 0x68], eax
 out[26] = eax;
 // 0xb2bd7d addss xmm0, xmm1
 xmm0[0] = xmm0[0] + xmm1[0];
 // 0xb2bd81 mulss xmm3, xmm4
 xmm3[0] = xmm3[0] * xmm4[0];
 // 0xb2bd85 movss dword ptr [ebp - 0x10], xmm4
 stack[0] = xmm4[0];
 // 0xb2bd8a addss xmm3, xmm7
 xmm3[0] = xmm3[0] + xmm7[0];
 // 0xb2bd8e mulss xmm0, xmm5
 xmm0[0] = xmm0[0] * xmm5[0];
 // 0xb2bd92 mulss xmm0, xmm5
 xmm0[0] = xmm0[0] * xmm5[0];
 // 0xb2bd96 mulss xmm3, xmm5
 xmm3[0] = xmm3[0] * xmm5[0];
 // 0xb2bd9a addss xmm0, xmm2
 xmm0[0] = xmm0[0] + xmm2[0];
 // 0xb2bd9e movss dword ptr [ebp - 4], xmm0
 stack[3] = xmm0[0];
 // 0xb2bda3 movaps xmm0, xmm7
 xmm0 = xmm7;
 // 0xb2bda6 mov eax, dword ptr [ebp - 4]
 eax = stack[3];
 // 0xb2bda9 addss xmm0, xmm2
 xmm0[0] = xmm0[0] + xmm2[0];
 // 0xb2bdad mov dword ptr [ecx + 0x6c], eax
 out[27] = eax;
 // 0xb2bdb0 mov eax, dword ptr [ebp - 0x10]
 eax = stack[0];
 // 0xb2bdb3 mov dword ptr [ecx + 0x70], eax
 out[28] = eax;
 // 0xb2bdb6 mov eax, dword ptr [ebp - 0xc]
 eax = stack[1];
 // 0xb2bdb9 mov dword ptr [ecx + 0x74], eax
 out[29] = eax;
 // 0xb2bdbc movss dword ptr [ebp - 8], xmm0
 stack[2] = xmm0[0];
 // 0xb2bdc1 mov eax, dword ptr [ebp - 8]
 eax = stack[2];
 // 0xb2bdc4 movss dword ptr [ebp - 4], xmm3
 stack[3] = xmm3[0];
 // 0xb2bdc9 mov dword ptr [ecx + 0x78], eax
 out[30] = eax;
 // 0xb2bdcc mov eax, dword ptr [ebp - 4]
 eax = stack[3];
 // 0xb2bdcf mov dword ptr [ecx + 0x7c], eax
 out[31] = eax;
 out
}
