from pathlib import Path
import sys,json,struct
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');p=json.loads((r/'docs/audio_security_cookie_store_discovery.json').read_text());pe=pefile.PE(p['native_file']);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;store=p['absolute_cookie_stores'][0]['address'];prologue=image.rfind(bytes.fromhex('558bec'),store-base-512,store-base);entry=base+prologue
if image[prologue-2:prologue]==bytes.fromhex('8bff'):entry-=2
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);instructions=[]
for v in md.disasm(image[entry-base:store-base+32],entry):
 instructions.append({'address':v.address,'bytes':v.bytes.hex(),'mnemonic':v.mnemonic,'operands':v.op_str})
 if v.mnemonic=='ret':break
imports={v.address:((v.name or b'').decode('ascii','replace'))for dll in pe.DIRECTORY_ENTRY_IMPORT for v in dll.imports}
iat=[0xfa4308,0xfa4378,0xfa4370,0xfa4134];entropy=[{'reference':a,'name':imports.get(a,'unresolved')}for a in iat]
calls=[]
for section in pe.sections:
 if not section.Characteristics&0x20000000:continue
 cursor=section.VirtualAddress;end=cursor+max(section.Misc_VirtualSize,section.SizeOfRawData)
 while True:
  cursor=image.find(b'\xe8',cursor,end)
  if cursor<0:break
  at=cursor;cursor+=1
  if at+5>len(image):continue
  target=base+at+5+struct.unpack_from('<i',image,at+1)[0]
  if target==entry:calls.append({'address':base+at,'target':target,'bytes':image[at:at+5].hex()})
receipt={'passed':True,'complete':False,'native_file':p['native_file'],'native_sha256':p['native_sha256'],'entry_reference':entry,'prologue_reference':base+prologue,'cookie_reference':0x1222ed0,'complement_reference':0x1222ed4,'initial_cookie':p['initial_cookie'],'initial_complement':p['adjacent_word'],'direct_call_candidates':calls,'entropy_imports':entropy,'instructions':instructions,'limits':['Exact contiguous decode from confirmed prologue/hotpatch prefix through return; direct-relative call occurrences retained as candidates until caller control flow is qualified.','Body identifies actual four entropy APIs, local-address XOR, default magic avoidance, low16 promotion with0x4711 and complement publication. Producer not yet emulated or ported; no executed entropy or security-cookie readiness claim.']}
(r/'docs/audio_security_cookie_entry_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n');(r/'tools/discover_audio_security_cookie_entry.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Cookie entry',hex(entry),'direct call candidates',[(hex(v['address']),hex(v['target']))for v in calls],'entropy imports',entropy)
