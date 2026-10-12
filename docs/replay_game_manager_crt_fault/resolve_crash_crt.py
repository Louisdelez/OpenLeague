from pathlib import Path
import pefile, capstone
for path,targets in [('C:/Windows/System32/ucrtbase.dll',[0x7c49,0x82f0]),('C:/Windows/System32/msvcrt.dll',[0x1d60c,0x5f034,0x514c5,0x51570])]:
    pe=pefile.PE(path);image=pe.get_memory_mapped_image();exports=sorted((s.address,s.name) for s in pe.DIRECTORY_ENTRY_EXPORT.symbols if s.name)
    for target in targets:
        preceding=[(a,n.decode()) for a,n in exports if a<=target]
        entry=next((x for x in pe.DIRECTORY_ENTRY_EXCEPTION if x.struct.BeginAddress<=target<x.struct.EndAddress),None)
        print(path,hex(target),'export',[(hex(a),n) for a,n in preceding[-2:]],'function',hex(entry.struct.BeginAddress) if entry else None)
        if entry:
            for i in capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_64).disasm(image[entry.struct.BeginAddress:entry.struct.EndAddress],entry.struct.BeginAddress):
                if target-35<=i.address<=target+15: print(' ',hex(i.address),i.mnemonic,i.op_str)
exe=pefile.PE('E:/OpenLeague/target/debug/openleague-client.exe',fast_load=True)
exe.parse_data_directories(directories=[pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_IMPORT']])
for module in exe.DIRECTORY_ENTRY_IMPORT:
    for symbol in module.imports:
        if symbol.name in [b'fopen',b'fopen_s',b'fclose',b'fprintf',b'free',b'calloc',b'malloc',b'_fdopen',b'__acrt_iob_func']:
            print('CLIENT_IMPORT',module.dll,symbol.name,hex(symbol.address-exe.OPTIONAL_HEADER.ImageBase))
for i in capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_64).disasm(exe.get_data(0x84ffb0,0x300),0x84ffb0):
    if i.address>=0x8501e0:print('CLIENT_CODE',hex(i.address),i.mnemonic,i.op_str)
for i in capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_64).disasm(exe.get_data(0x4e75d6e,6),0x4e75d6e):
    print('CLIENT_FCLOSE_THUNK',hex(i.address),i.mnemonic,i.op_str)
