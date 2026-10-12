from pathlib import Path
import capstone,json,shutil,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
decoder=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);decoder.detail=True
tables={}
for entry,form in [(0x6d4a10,'plain'),(0x6d4dc0,'localized')]:
 pushes=[];bindings=[];end_address=None
 for instruction in decoder.disasm(bytes(u.mem_read(entry,1024)),entry):
  if instruction.mnemonic=='push':pushes.append(instruction)
  if instruction.mnemonic=='call':
   operands=instruction.operands;target=operands[0].imm if operands and operands[0].type==capstone.x86.X86_OP_IMM else None
   if target in (0x6ed1f0,0x6ed260,0x6ed2c0):
    assert len(pushes)>=3;block=pushes[-3:];callback=block[0].operands[0];assert callback.type==capstone.x86.X86_OP_IMM
    pattern=block[2].operands[0];literal_address=pattern.imm if pattern.type==capstone.x86.X86_OP_IMM else None
    if target==0x6ed1f0:assert literal_address is not None
    else:assert literal_address is None
    bindings.append({'ordinal':len(bindings),'call_address':hex(instruction.address),'matcher':hex(target),'callback':hex(callback.imm),'pattern_address':hex(literal_address) if literal_address else None,'literal_pattern':cbytes(literal_address).decode('ascii') if literal_address else None,'stack_pushes':[i.op_str for i in block]})
   pushes=[]
  if instruction.mnemonic=='ret':end_address=instruction.address+instruction.size;break
 assert end_address and bindings
 body=bytes(u.mem_read(entry,end_address-entry))
 tables[form]={'entry':hex(entry),'body_end':hex(end_address),'body_sha256':hashlib.sha256(body).hexdigest(),'bindings':bindings}
proof={'native_sha256':digest,'passed':True,'complete':False,'tables':tables,'limits':['Ordered callback/matcher/literal pattern registration inside both native dispatcher bodies recovered directly from instructions.','6ED260/6ED2C0 dynamic matcher arguments retained as source operand records; no literal pattern inferred.','This does not qualify outer callback registration, matcher bodies, unsupported token behavior, actor field ownership, formatter rendering or normal playback.']}
(r/'data/4.20/audio_announcer_dispatch_inventory.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/inspect_announcer_dispatch_inventory.py'),r/'tools/inspect_announcer_dispatch_inventory.py')
print(json.dumps({'ordered_bindings':{k:len(v['bindings']) for k,v in tables.items()}}))
