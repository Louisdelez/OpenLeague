from pathlib import Path
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_curve_delayed_admission.py').read_text(encoding='utf-8')
s=s.replace("bound_index=0\nsnapshot=","bound_index=0;loop_states={};cycle=None;loop_index=0\nsnapshot=")
s=s.replace('global bound_index','global bound_index,cycle,loop_index')
s=s.replace('sp=u.reg_read(UC_X86_REG_ESP)','''sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xb105e7:
  registers={name:u.reg_read(reg)for name,reg in [('eax',UC_X86_REG_EAX),('ecx',UC_X86_REG_ECX),('edx',UC_X86_REG_EDX),('ebx',UC_X86_REG_EBX),('esi',UC_X86_REG_ESI),('edi',UC_X86_REG_EDI),('ebp',UC_X86_REG_EBP),('esp',UC_X86_REG_ESP),('eflags',UC_X86_REG_EFLAGS)]}
  frame=bytes(u.mem_read(registers['ebp']-0x20,0x40)).hex();state={'registers':registers,'frame':frame,'bank':snapshot()};digest=hashlib.sha256(json.dumps(state,sort_keys=True).encode()).hexdigest()
  if digest in loop_states:cycle={'first_step':loop_states[digest],'repeated_step':loop_index,'state_sha256':digest,'pc':a,'registers':registers,'frame':frame};u.emu_stop();return
  loop_states[digest]=loop_index;loop_index+=1''')
s=s.replace('bound_index=0;before=snapshot();','bound_index=0;loop_states.clear();cycle=None;loop_index=0;before=snapshot();')
s=s.replace("'terminal':terminal,'before':before","'terminal':terminal,'cycle':cycle,'before':before")
s=s.replace("'instruction_limited_case_count':sum(not x['terminal']for x in rows)","'instruction_limited_case_count':sum(not x['terminal']and x['cycle']is None for x in rows),'cycle_case_count':sum(x['cycle']is not None for x in rows)")
s=s.replace('audio_curve_delayed_admission_preparation.json','audio_curve_delayed_admission_cycle_qualified_preparation.json').replace('probe_native_audio_curve_delayed_admission.py','probe_native_audio_curve_delayed_admission_cycle_qualified.py')
s=s.replace('nonterminal cases retain2500instruction-limited partial evidence, not successful qualification.','10 original paths now stop when complete GPR/EFLAGS,64byte active frame and entire canonical bank repeat atB105E7. No external service at repeated point; actual deterministic machine state cycle captured. Original128-case instruction-limited fixture retained. Cycles are not successful returns.')
s=s.replace("print('Native delayed admission:',len(rows),'cases;',p['terminal_case_count'],'terminal;',p['instruction_limited_case_count'],'instruction-limited')","print('Native delayed admission:',len(rows),'cases;',p['terminal_case_count'],'terminal;',p['cycle_case_count'],'exact-machine-state cycles;',p['instruction_limited_case_count'],'instruction-limited')")
(r/'tools/probe_native_audio_curve_delayed_admission_cycle_qualified.py').write_text(s,encoding='utf-8');exec(compile(s,'native delayed cycle qualification','exec'))
