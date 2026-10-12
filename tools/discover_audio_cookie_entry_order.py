from pathlib import Path
import sys,json,hashlib
r=Path('E:/OpenLeague')
sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone
p=json.loads((r/'docs/audio_security_cookie_entry_discovery.json').read_text())
source=Path(p['native_file'])
assert hashlib.sha256(source.read_bytes()).hexdigest()==p['native_sha256']
pe=pefile.PE(str(source)); image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
entry=base+pe.OPTIONAL_HEADER.AddressOfEntryPoint
assert entry==0xca0f20
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
def decode(a,b):return [{'address':v.address,'bytes':v.bytes.hex(),'mnemonic':v.mnemonic,'operands':v.op_str} for v in md.disasm(image[a-base:b-base],a)]
instructions=decode(entry,0xca0f2a)+decode(0xca0f2a,0xca0fb0)
by={v['address']:v for v in instructions}
for at,mn,operand in [(0xca0f20,'call','0xcb65b4'),(0xca0f25,'jmp','0xca0f2a'),(0xca0f8e,'call','0xcabb83'),(0xca0f95,'jne','0xca0f9f'),(0xca0f99,'call','0xca107a'),(0xca0f9f,'call','0xca92cb'),(0xca0fa6,'jne','0xca0fb0'),(0xca0faa,'call','0xca107a')]:
 assert (by[at]['mnemonic'],by[at]['operands'])==(mn,operand),(at,by[at])
receipt={'passed':True,'complete':False,'native_file':str(source),'native_sha256':p['native_sha256'],'pe_entry_reference':entry,'cookie_call':0xca0f20,'heap_bootstrap_call':0xca0f8e,'crt_root_call':0xca0f9f,'instructions':instructions,'evidence':['PE entry calls original cookie producer directly and jumps to CRT entry. Contiguous CRT entry decode reaches process-heap bootstrap then root startup, each followed by zero-result fatal-path branch. Heap and root successful result branches continue to the next phase.'],'limits':['Static original instruction/control-flow evidence, not execution of complete EXE entry. Intervening SEH and runtime setup routines and fatal error behavior still need execution/qualification. No claim entire executable startup is ported or normal client integration complete.']}
(r/'tools/discover_audio_cookie_entry_order.py').write_text(Path(__file__).read_text(),encoding='utf-8')
(r/'docs/audio_cookie_entry_order_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print('PASS original PE entry cookie->heap bootstrap->CRT root order; static evidence only')
