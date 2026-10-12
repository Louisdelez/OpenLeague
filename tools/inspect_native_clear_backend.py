from pathlib import Path
exec(Path(__file__).with_name('inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0])
for start,end in [(0x9873c0,0x987460),(0x987460,0x987590)]:
 if start>=0x1000000:
  for a in range(start,end,4):print(hex(a),hex(struct.unpack_from('<I',image,a-base)[0]))
 else:
  for i in md.disasm(image[start-base:end-base],start):print(hex(i.address),i.mnemonic,i.op_str)
