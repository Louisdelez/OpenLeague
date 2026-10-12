from pathlib import Path
import sys,json,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
exe=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');raw=exe.read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);md.detail=True
imports={imp.address:imp.name.decode('ascii')for desc in pe.DIRECTORY_ENTRY_IMPORT for imp in desc.imports if imp.name};functions={};todo=[(0xca8673,0),(0xc98528,0)];seen=set()
while todo:
 address,depth=todo.pop(0)
 if address in seen:continue
 seen.add(address);instructions=[];targets=[]
 for ins in md.disasm(pe.get_data(address-base,768),address):
  row={'address':ins.address,'mnemonic':ins.mnemonic,'operands':ins.op_str,'bytes':ins.bytes.hex()};instructions.append(row)
  if ins.mnemonic=='call'and ins.operands:
   operand=ins.operands[0]
   if operand.type==capstone.x86.X86_OP_IMM:
    target=operand.imm;targets.append(target)
    if depth<1 and base<=target<base+pe.OPTIONAL_HEADER.SizeOfImage:todo.append((target,depth+1))
   elif operand.type==capstone.x86.X86_OP_MEM and operand.mem.base==0:row['import']=imports.get(operand.mem.disp,'unresolved')
  if ins.mnemonic.startswith('ret'):break
 functions[f'{address:08x}']={'depth':depth,'instructions':instructions,'direct_calls':targets}
receipt={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entries':{'calloc':'0xca8673','free':'0xc98528'},'functions':functions,'limits':['Read-only disassembly of original native CRT entry wrappers and direct callees; stops at first return perfunction. Cold branches or shared tails may extend beyond captured fragments. No algorithm reproduction, execution trace or native heap equivalence claimed.']}
(r/'docs/audio_crt_heap_entry_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');(r/'tools/discover_audio_crt_heap_entries.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8')
for name,v in functions.items():print(name,'direct_calls:',','.join(hex(t)for t in v['direct_calls']),'imports:',','.join(i['import']for i in v['instructions']if 'import'in i))
