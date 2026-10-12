from pathlib import Path
import sys,struct,json,hashlib,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');import pefile,capstone
p=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
pe=pefile.PE(str(p));data=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);rows=[]
sections=[(s.VirtualAddress,s.VirtualAddress+s.Misc_VirtualSize) for s in pe.sections if s.Characteristics&0x20000000]
for text_value in ['DestroyedTower','DestroyedNexus','DestroyedInhibitor','SRUAP_Turret_Order1_Rubble','Sruap_Ordernexus_Rubble','TT_Buffplat_L','TT_OrderInhibitor_D']:
 needle=text_value.encode()+b'\0';offset=0
 while True:
  offset=data.find(needle,offset)
  if offset<0:break
  pointer=base+offset;encoded=struct.pack('<I',pointer);references=[]
  for lo,hi in sections:
   cursor=lo
   while True:
    cursor=data.find(encoded,cursor,hi)
    if cursor<0:break
    # Find a nearby padded function boundary; stop a linear decode before INT3.
    start=max(lo,cursor-700);pad=data.rfind(b'\xcc\xcc',start,cursor)
    if pad>=0:
     start=pad+2
     while data[start]==0xcc:start+=1
    instructions=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(data[start:min(cursor+400,hi)],base+start)]
    references.append(dict(operand_address=hex(base+cursor),decode_start=hex(base+start),instructions=instructions));cursor+=4
  row=dict(value=text_value,string_address=hex(pointer),references=references);rows.append(row)
  print(json.dumps(dict(value=text_value,string_address=hex(pointer),code_references=[ref['operand_address'] for ref in references])))
  for ref in references:
   address=int(ref['operand_address'],16)
   for i in ref['instructions']:
    if address-95<int(i['address'],16)<address+140:print(i['address'],i['mnemonic'],i['operands'])
  offset+=len(needle)
report=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=hashlib.sha256(p.read_bytes()).hexdigest(),qualified=False,strings=rows,limits=['Static string references and surrounding instructions only; no native selection execution or Map10 behavior proof.'])
Path('E:/OpenLeague/docs/native_destroyed_selection_trace.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
