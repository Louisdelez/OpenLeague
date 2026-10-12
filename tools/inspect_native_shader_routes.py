import sys,re,struct
from pathlib import Path
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=p.read_bytes();pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
if '--pass-stores' in sys.argv:
 for m in re.finditer(rb'[\x89\xc7][\x40-\x7f]\x54',image[0x950000-base:0x95d000-base]):
  a=0x950000+m.start();decoded=list(md.disasm(image[a-base:a-base+30],a))
  if decoded and decoded[0].mnemonic=='mov' and decoded[0].op_str.startswith('dword ptr') and ' + 0x54]' in decoded[0].op_str:print('STORE',hex(a));print('\n'.join(f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in decoded))
 sys.exit(0)
if '--calls' in sys.argv:
 target=int(sys.argv[sys.argv.index('--calls')+1],16)
 for section in pe.sections:
  if not section.Characteristics&0x20000000:continue
  start=section.VirtualAddress;end=start+section.Misc_VirtualSize
  for m in re.finditer(b'\xe8',image[start:end]):
   at=start+m.start()
   if base+at+5+struct.unpack_from('<i',image,at+1)[0]==target:print(hex(base+at))
 sys.exit(0)
if '--material-stores' in sys.argv:
 for m in re.finditer(rb'[\x89\xc7][\x80-\xbf][\x04\x08]\x01\x00\x00',image[0x900000-base:0x980000-base]):
  a=0x900000+m.start();print('STORE',hex(a));print('\n'.join(f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in md.disasm(image[a-base:a-base+35],a)))
 sys.exit(0)
if '--pointer' in sys.argv:
 k=sys.argv.index('--pointer');target=int(sys.argv[k+1],16)
 for m in re.finditer(re.escape(struct.pack('<I',target)),image):
  at=m.start();print('REFERENCE',hex(base+at))
  for o in range(at-20,at+44,4):
   v=struct.unpack_from('<I',image,o)[0];s=''
   if base<=v<base+len(image):
    z=image[v-base:v-base+180].split(b'\0')[0]
    if z and all(32<=c<=126 for c in z):s=z.decode()
   print(hex(base+o),hex(v),s)
 sys.exit(0)
if '--strings' in sys.argv:
 k=sys.argv.index('--strings');a=int(sys.argv[k+1],16);b=int(sys.argv[k+2],16)
 for m in re.finditer(rb'[ -~]{3,}',image[a-base:b-base]):print(hex(a+m.start()),m.group().decode())
 sys.exit(0)
if '--range' in sys.argv:
 k=sys.argv.index('--range');a=int(sys.argv[k+1],16);b=int(sys.argv[k+2],16)
 for i in md.disasm(image[a-base:b-base],a):print(f'{i.address:08x} {i.mnemonic} {i.op_str}')
 sys.exit(0)
for match in re.finditer(rb'[ -~]{5,}',raw):
 s=match.group().decode()
 if not any(term in s.lower() for term in ['baked_env','lit_prop','mod2x_colormap','dual_color']):continue
 address=base+pe.get_rva_from_offset(match.start());refs=[]
 for sect in pe.sections:
  if not sect.Characteristics&0x20000000:continue
  start=sect.VirtualAddress;end=start+sect.Misc_VirtualSize
  for x in re.finditer(re.escape(struct.pack('<I',address)),image[start:end]):
   at=base+start+x.start();refs.append(hex(at))
   if '--disasm' in sys.argv:
    print('CONTEXT',s,hex(at));print('\n'.join(f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in md.disasm(image[start+x.start()-20:start+x.start()+110],at-20)))
 print(s[:180],hex(address),refs[:30])
