from pathlib import Path
import hashlib,json,struct
import pefile,capstone
from capstone.x86_const import X86_OP_IMM,X86_OP_MEM,X86_REG_EBX
out=Path('E:/mapslol3v3/replay_packet_agent')
native=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=native.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image()
decoder=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);decoder.detail=True
regions=[]
for address,length,role in [(0x65e9e0,0x11,'callback20_invoke'),(0x738a3a,5,'virtual_thunk'),(0x72b2d0,0x17,'receive_wrapper'),(0x72b2f0,0xb9,'receive_body'),(0x72ec40,0x1d1,'activate_pending'),(0x72eec0,0xd0,'dispatch_active'),(0x588290,0x3f1c,'packet_switch_code'),(0x58c1ac,496,'packet_jump_table'),(0x58c39c,301,'packet_case_indices'),(0x5c86f0,0xc5,'packet88_helper'),(0x598eb0,0x45,'packet92_write_pair'),(0x597cc0,0x92,'packet92_assign_text'),(0x577e90,0x99,'packet95_shared_consumer'),(0x5cc140,0x76,'packet95_shared_getter'),(0x588010,0x280,'packet_c6_consumer'),(0x10afe8c,0xb4,'service_vtable'),(0x2d62878,4,'local_owner_global'),(0x14c761c,8,'packet95_global_shared_pair'),(0x10a0360,48,'owner_metadata_callback_vtables'),(0x1086078,12,'owner_callback_vtable')]:
 data=pe.get_data(address-base,length);regions.append({'address':address,'length':length,'role':role,'sha256':hashlib.sha256(data).hexdigest(),'hex':data.hex()})
out.joinpath('replay_service_packet_sources.json').write_text(json.dumps({'native_source':str(native),'native_sha256':digest,'regions':regions},indent=2)+'\n')
targets=list(struct.unpack('<124I',image[0x58c1ac-base:0x58c39c-base]));indices=image[0x58c39c-base:0x58c39c-base+301]
def graph(start):
 todo=[start];seen={};calls=set();indirect=[];outside=set();ebx_fields=[]
 while todo:
  address=todo.pop()
  if address in seen:continue
  if not 0x588290<=address<0x58c1ac:outside.add(address);continue
  instruction=next(decoder.disasm(image[address-base:address-base+16],address,count=1));seen[address]=f'{address:08x} {instruction.mnemonic} {instruction.op_str}'
  if instruction.mnemonic=='call':calls.add(instruction.op_str)
  for op in instruction.operands:
   if op.type==X86_OP_MEM and op.mem.base==X86_REG_EBX:ebx_fields.append({'instruction':address,'displacement':op.mem.disp,'bytes':op.size,'text':seen[address]})
  if instruction.group(capstone.CS_GRP_RET):continue
  if instruction.group(capstone.CS_GRP_JUMP):
   if instruction.operands[0].type==X86_OP_IMM:todo.append(instruction.operands[0].imm)
   else:indirect.append(seen[address])
   if instruction.mnemonic=='jmp':continue
  todo.append(address+instruction.size)
 return {'entry':start,'direct_and_indirect_call_operands':sorted(calls),'indirect_jumps':indirect,'outside_jumps':sorted(outside),'ebx_memory_operands_not_proven_packet_fields':ebx_fields,'instructions':[seen[a] for a in sorted(seen)]}
graphs={str(target):graph(target) for target in sorted(set(targets))}
mapping=[{'code':code,'index':indices[code-2],'target':targets[indices[code-2]]} for code in range(2,303)]
out.joinpath('packet_switch_map.json').write_text(json.dumps({'native_sha256':digest,'map':mapping,'targets':targets,'handlers':graphs,'limits':['CFG stays inside588290..58C1AC. Direct calls are recorded, not followed. Indirect jumps are recorded, not invented. EBX references are syntax observations; no blanket size/packet-field claim.']},indent=2)+'\n')
selected=[0x88,0x92,0x54,0x95,0xc6]
text=[]
for code in selected:
 target=mapping[code-2]['target'];text.append(f'OPCODE {code:#x}, ENTRY {target:#x}');text+=graphs[str(target)]['instructions'];text.append('')
out.joinpath('allowed_packet_branches.txt').write_text('\n'.join(text)+'\n')
print(json.dumps({'regions':len(regions),'opcode_entries':len(mapping),'distinct_targets':len(graphs),'default_opcodes':sum(r['target']==0x58830a for r in mapping)}))
