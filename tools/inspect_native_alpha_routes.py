from pathlib import Path
import sys,struct
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');pe=pefile.PE(str(p));data=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
for address in [0x10e31a8,0x10e2d68]:print(hex(address),list(struct.unpack_from('<8I',data,address-base)))
for start,end in [(0x95bff0,0x95cad0),(0x957000,0x957a00)]:
 ins=list(md.disasm(data[start-base:end-base],start))
 for i,line in enumerate(ins):
  if (line.mnemonic=='call' and line.op_str in ['0x9abc90','0x9abee0','0x9ac500']) or ('0x108]' in line.op_str):
   print('ROUTE',hex(line.address))
   for item in ins[max(0,i-5):i+6]:print(hex(item.address),item.mnemonic,item.op_str)
