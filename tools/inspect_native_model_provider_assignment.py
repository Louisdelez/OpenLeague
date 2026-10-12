exec(open('E:/mapslol3v3/inspect_grass_sampler.py',encoding='utf-8').read().split('for start,size')[0])
import json,struct
references=[]
for offset in [0x2068,0x9e4]:
 for section in pe.sections:
  if not section.Characteristics&0x20000000:continue
  cursor=section.VirtualAddress;high=cursor+section.Misc_VirtualSize
  while True:
   at=data.find(struct.pack('<I',offset),cursor,high)
   if at<0:break
   cursor=at+1
   for begin in range(at-6,at):
    instructions=list(cs.disasm(data[begin:at+8],base+begin,count=1))
    if not instructions or instructions[0].address+instructions[0].size!=base+at+4 or hex(offset) not in instructions[0].op_str:continue
    instruction=instructions[0]
    start=data.rfind(b'\xcc\xcc\xcc',max(section.VirtualAddress,begin-4096),begin)+3
    while data[start]==0xcc:start+=1
    references.append(dict(offset=hex(offset),address=hex(instruction.address),instruction=instruction.mnemonic+' '+instruction.op_str,candidate_start=hex(base+start),context=[dict(address=hex(i.address),instruction=i.mnemonic+' '+i.op_str) for i in cs.disasm(data[start:at+50],base+start)]))
proof=dict(qualified=False,notice='Instruction references and padding-derived boundaries locate model assignment; producer type, resource loading and execution require qualification.',references=references)
Path('E:/mapslol3v3/native-model-provider-assignment.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps([dict(offset=x['offset'],address=x['address'],instruction=x['instruction'],candidate_start=x['candidate_start']) for x in references]))
