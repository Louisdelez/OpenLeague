from pathlib import Path
import sys,json,struct,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone
p=json.loads((r/'docs/audio_security_cookie_entry_discovery.json').read_text());source=Path(p['native_file']);assert hashlib.sha256(source.read_bytes()).hexdigest()==p['native_sha256']
pe=pefile.PE(str(source));image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase;t=pe.DIRECTORY_ENTRY_TLS.struct
callbacks=[]
for i in range(64):
 pointer=struct.unpack_from('<I',image,t.AddressOfCallBacks-base+i*4)[0]
 if not pointer:break
 callbacks.append(pointer)
else:raise AssertionError('unterminated callback table')
assert callbacks==[]
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);instructions=[]
for v in md.disasm(image[0xcb0207-base:0xcb0207-base+96],0xcb0207):
 instructions.append({'address':v.address,'bytes':v.bytes.hex(),'mnemonic':v.mnemonic,'operands':v.op_str})
 if v.mnemonic=='ret':break
by={v['address']:v for v in instructions};assert by[0xcb0209]['operands']=='esi, 0x116fa14' and by[0xcb020e]['operands']=='edi, 0x116fa14'
exit_instructions=[{'address':v.address,'bytes':v.bytes.hex(),'mnemonic':v.mnemonic,'operands':v.op_str}for v in md.disasm(image[0xc9c356-base:0xc9c384-base],0xc9c356)]
imports={v.address:(v.name or b'').decode('ascii','replace') for dll in pe.DIRECTORY_ENTRY_IMPORT for v in dll.imports}
assert imports[0xfa42d8]=='ExitThread'
exit_by={v['address']:v for v in exit_instructions}
assert exit_by[0xc9c35a]['operands']=='0xca91a9' and exit_by[0xc9c374]['operands']=='0xca915b' and exit_by[0xc9c37d]['operands']=='dword ptr [0xfa42d8]'
receipt={'passed':True,'complete':False,'native_file':str(source),'native_sha256':p['native_sha256'],'tls_directory':{'data_start':t.StartAddressOfRawData,'data_end':t.EndAddressOfRawData,'index':t.AddressOfIndex,'callback_array':t.AddressOfCallBacks,'callbacks':callbacks,'zero_fill':t.SizeOfZeroFill},'post_root_initializer_reference':0xcb0207,'initializer_begin':0x116fa14,'initializer_end':0x116fa14,'instructions':instructions,'evidence':['Original PE TLS directory has an empty callback array. CB0207 post-root initializer iterates an empty begin/end range in this image.'],'limits':['Static PE evidence only. It does not establish how legacy TlsAlloc contexts are destroyed at application worker exit. Do not emulate legacy TLS thread-exit cleanup by assuming an OS callback equivalent to FlsAlloc. Find original explicit worker/detach retirement path and qualify it before integration.']}
receipt['worker_exit_reference']=0xc9c356
receipt['worker_exit_instructions']=exit_instructions
receipt['worker_exit_import']={'reference':0xfa42d8,'name':imports[0xfa42d8]}
receipt['evidence'].append('Contiguous C9C356 worker exit decode invokes original context getter CA91A9, conditionally calls C9C459 when record+3B4 is nonzero, invokes CA915B explicit detachment on the obtained context, then calls imported ExitThread with caller exit code. NULL context bypasses detach.')
receipt['limits']=['Static original PE/control-flow evidence; worker exit routine and conditional C9C459 dependency are not yet emulated/integrated in real legacy TLS workers. Existing CA915B detach port needs actual worker binding. Do not substitute an assumed automatic TLS callback for the original explicit exit route.']
(r/'tools/discover_audio_legacy_tls_lifecycle.py').write_text(Path(__file__).read_text(),encoding='utf-8');(r/'docs/audio_legacy_tls_lifecycle_discovery.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print('PASS original PE TLS callback list empty; post-root initializer range empty; explicit legacy worker retirement remains to trace')
