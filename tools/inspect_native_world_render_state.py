from pathlib import Path
import sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
pe=pefile.PE(str(p));data=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
for start,end in [(0x73b130,0x73b190),(0x73fde0,0x73ff80),(0x6b3710,0x6b38d0),(0x73a850,0x73aa60),(0x95ad40,0x95ae90),(0x9836a0,0x983980),(0x9ac090,0x9ac270),(0x9ac600,0x9ac6d0)]:
 print('FUNCTION',hex(start))
 for i in md.disasm(data[start-base:end-base],start):
  print(hex(i.address),i.mnemonic,i.op_str)
  if i.mnemonic in ['ret','int3']:break
