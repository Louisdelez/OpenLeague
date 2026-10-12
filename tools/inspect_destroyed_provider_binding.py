from pathlib import Path
import sys,struct,json
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');import pefile,capstone
p=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');pe=pefile.PE(str(p));data=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);target=0x2d7878c;refs=[]
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 start=section.VirtualAddress;hi=start+section.Misc_VirtualSize;cursor=start
 while True:
  cursor=data.find(struct.pack('<I',target),cursor,hi)
  if cursor<0:break
  pad=data.rfind(b'\xcc\xcc',max(start,cursor-200),cursor);lo=pad+2 if pad>=0 else max(start,cursor-100)
  while data[lo]==0xcc:lo+=1
  instructions=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(data[lo:min(cursor+240,hi)],base+lo)]
  refs.append(dict(operand=hex(base+cursor),instructions=instructions));cursor+=4
Path('E:/OpenLeague/docs/native_destroyed_provider_binding_trace.json').write_text(json.dumps(dict(qualified=False,global_pointer=hex(target),references=refs,limits=['Static references only; global resource assignment, startup object type and field+38 filename remain unqualified.']),indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(global_pointer=hex(target),references=len(refs))))
for ref in refs:
 address=int(ref['operand'],16)
 lines=[i for i in ref['instructions'] if address-12<int(i['address'],16)<address+100]
 print('REFERENCE',ref['operand'])
 for i in lines:print(i['address'],i['mnemonic'],i['operands'])
