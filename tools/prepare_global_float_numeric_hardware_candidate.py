from pathlib import Path
import re,json
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
c=Cs(CS_ARCH_X86,CS_MODE_32);ins=list(c.disasm(bytes(u.mem_read(0xaeb43e,0xaeb6ee-0xaeb43e)),0xaeb43e))
addresses=sorted(set(int(a,16)for i in ins for a in re.findall(r'\[0x([0-9a-f]+)\]',i.op_str))-set([0x14a7970,0x14a7974,0x121022c,0x1210230]));offset={a:j*4 for j,a in enumerate(addresses)};labels={i.address:500+j for j,i in enumerate(ins)}
asm=['fnstcw word ptr [{control}]','fldcw word ptr [{control} + 2]','stmxcsr dword ptr [{control} + 4]','ldmxcsr dword ptr [{control} + 8]','fld dword ptr [{power}]']
for i in ins:
 asm.append(str(labels[i.address])+':')
 if i.mnemonic=='pop'or i.mnemonic=='mov'and i.op_str in['esp, ebp','esp, ebx']:continue
 if i.mnemonic=='ret':asm.append('jmp 900f');continue
 if i.mnemonic.startswith('j'):
  target=int(i.op_str,16);asm.append(i.mnemonic+' '+str(labels[target])+('f'if target>i.address else'b'));continue
 op=i.op_str
 op=re.sub(r'\[ebp - (0x[0-9a-f]+|[0-9]+)\]',lambda m:'[{locals} + '+str(64-int(m.group(1),0))+']',op)
 for old,new in [('[ebx + 8]','[{args}]'),('[0x14a7970]','[{cache}]'),('[0x14a7974]','[{cache} + 4]'),('[0x121022c]','[{result}]'),('[0x1210230]','[{result} + 4]')]:op=op.replace(old,new)
 op=re.sub(r'\[0x([0-9a-f]+)\]',lambda m:'[{constants} + '+str(offset[int(m.group(1),16)])+']',op)
 assert 'ebp'not in op and'ebx'not in op and'esp'not in op,(i.mnemonic,op)
 asm.append(i.mnemonic+(' '+op if op else''))
asm+=['900:','ldmxcsr dword ptr [{control} + 4]','fldcw word ptr [{control}]']
body='''fn numeric(bits:u32,cache:&mut[u32;2])->[u32;2]{
 let scaled=(f32::from_bits(bits)*f32::from_bits(0x3d4ccccd)).to_bits();let power=(10f64.powf(f32::from_bits(scaled) as f64) as f32).to_bits();
 let args=[bits];let mut locals=[0u32;16];locals[15]=scaled;let constants=[CONSTANTS];let mut control=[0x037f0000u32,0,0x1f80];let mut result=[0u32;2];
 unsafe{std::arch::asm!(ASM,args=in(reg)args.as_ptr(),locals=in(reg)locals.as_mut_ptr(),constants=in(reg)constants.as_ptr(),cache=in(reg)cache.as_mut_ptr(),power=in(reg)&power,result=in(reg)result.as_mut_ptr(),control=in(reg)control.as_mut_ptr(),out("eax")_,out("ecx")_,out("edx")_,out("xmm0")_,out("xmm1")_,out("xmm2")_,out("xmm3")_,out("xmm4")_,out("xmm5")_,out("xmm6")_,out("xmm7")_,out("st(0)")_,out("st(1)")_,options(nostack));}result
}
'''.replace('CONSTANTS',','.join(hex(read(a))+'u32'for a in addresses)).replace('ASM',',\n'.join(json.dumps(a)for a in asm))
p=json.loads((r/'data/4.20/audio_global_float_configuration_tls_preparation.json').read_text(encoding='utf-8'));cases=[]
def word(b,o):return int.from_bytes(bytes.fromhex(b)[o:o+4],'little')
for x in p['cases']:
 bits=x['bits'];v=__import__('struct').unpack('<f',bits.to_bytes(4,'little'))[0];prio=x['priority'] if x['priority']<0x80000000 else x['priority']-2**32;sel=x['selector'] if x['selector']<0x80000000 else x['selector']-2**32
 if not(v<__import__('struct').unpack('<f',bytes.fromhex('9a99c0c2'))[0]or v>0)and sel<=prio:cases.append([bits,word(x['before']['conversion_cache'],0),word(x['before']['conversion_cache'],4),word(x['after']['globals'],0x16c),word(x['after']['globals'],0x170),word(x['after']['conversion_cache'],0),word(x['after']['conversion_cache'],4)])
main='''fn main(){let cases:[ [u32;7];COUNT ]=[CASES];let mut passed=0;let mut failed=0;for (i,c)in cases.iter().enumerate(){let mut cache=[c[1],c[2]];let actual=numeric(c[0],&mut cache);if actual==[c[3],c[4]]&&cache==[c[5],c[6]]{passed+=1;}else{failed+=1;if failed<=12{println!("MISMATCH {} input {:08x} expected {:08x?}/{:08x?} actual {:08x?}/{:08x?}",i,c[0],[c[3],c[4]],[c[5],c[6]],actual,cache);}}}println!("RESULT passed={} failed={}",passed,failed);}
'''.replace('COUNT',str(len(cases))).replace('CASES',','.join('['+','.join(hex(v)+'u32'for v in c)+']'for c in cases))
(r/'tools/global_float_numeric_hardware_candidate.rs').write_text(body+main,encoding='utf-8');(r/'tools/prepare_global_float_numeric_hardware_candidate.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Prepared',len(cases),'active numeric hardware comparisons; host pow is explicit candidate, not original CRT port.')
