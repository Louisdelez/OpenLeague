from pathlib import Path
s=Path('E:/mapslol3v3/probe_global_resource_catalog.py').read_text(encoding='utf-8')
s=s.replace("input_string(folder_string,row['folder'],0x40009000)","paths=paths if row['folder']=='DATA/Shaders/Texture' else paths[:2]\n input_string(folder_string,row['folder'],0x40009000)")
s=s.replace("query=0x40008a00;lookups=[]",'''query=0x40008a00;lookups=[]
def invalid_access(uc,access,address,size,value,user):
 print('FAULT',hex(u.reg_read(UC_X86_REG_EIP)),hex(address),'resource',hex(resource),'parent',hex(read32(resource+0x10)),'context',hex(read32(0x2d78f20)),'registers',{name:hex(u.reg_read(reg)) for name,reg in [('eax',UC_X86_REG_EAX),('ecx',UC_X86_REG_ECX),('edx',UC_X86_REG_EDX),('ebx',UC_X86_REG_EBX),('esi',UC_X86_REG_ESI),('edi',UC_X86_REG_EDI)]},'stack',[hex(read32(u.reg_read(UC_X86_REG_ESP)+off)) for off in range(0,28,4)],flush=True)
 return False
u.hook_add(unicorn.UC_HOOK_MEM_READ_UNMAPPED,invalid_access)''')
s=s.replace("(r/'data/4.20/global_resource_catalog_contract.json')","(r/'data/4.20/global_resource_catalog_debug.json')")
exec(compile(s,'catalog diagnostic subset','exec'))

