from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'native HUD prerequisites','exec'))
target=0x9a3347;previous=image.rfind(b'\xcc\xcc',target-base-0x1000,target-base);start=base+previous+2
while image[start-base]==0xcc:start+=1
print('padding-derived candidate',hex(start))
for ptr in [0x10df5d8,0x10df5e4,0x109b640,0x107efc4,0x10a572c,0x10df57c]:print(hex(ptr),repr(image[ptr-base:ptr-base+100].split(b'\0')[0]))
for start,end in [(0xc99c00,0xc99cc0),(0xc9cf31,0xc9cfb0)]:
 for i in md.disasm(image[start-base:end-base],start):print(hex(i.address),i.mnemonic,i.op_str)
