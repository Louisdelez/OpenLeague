exec(open('E:/OpenLeague/tools/discover_stop_setter_callers.py',encoding='utf-8').read().split('target=')[0])
for a in range(0x10d6c80,0x10d6d84,4):
 value=struct.unpack_from('<I',img,a-base)[0];print(hex(a),hex(value))
 for sec in p.sections:
  if sec.Characteristics&0x20000000 and base+sec.VirtualAddress<=value<base+sec.VirtualAddress+sec.Misc_VirtualSize:break
 else:
  if base<=value<base+len(img):
   print('DATA',bytes(img[value-base:value-base+32]).hex())
for start,end in [(0x928980,0x928a10)]:
 for i in m.disasm(img[start-base:end-base],start):print(hex(i.address),i.mnemonic,i.op_str)
