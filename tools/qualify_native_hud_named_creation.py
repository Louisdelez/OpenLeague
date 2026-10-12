from pathlib import Path
import json,struct,hashlib,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD named element prerequisites','exec'))
owner=vector+0x6000;registry_ptr=vector+0xf100;node=vector+0xf200;all_list=vector+0x17000;effect_list=vector+0x18000;current_kind=0
def named_hook(uc,a,size,user):
 if a in [0x9aa4d0,0x9aa6f0,0x9aa5e0]:
  assert a=={1:0x9aa4d0,2:0x9aa6f0,3:0x9aa5e0}[current_kind]
  assert uc.reg_read(UC_X86_REG_ECX)==owner+{1:0x1e4,2:0x214,3:0x1fc}[current_kind]
  finish(obj);return
 if a==0x9a6250:
  assert uc.reg_read(UC_X86_REG_ECX)==registry_ptr and read(uc.reg_read(UC_X86_REG_ESP)+4)==text
  finish(node,4);return
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,named_hook)
header=json.loads((r/'data/4.20/native_hud_record_header_contract.json').read_text(encoding='utf-8'))
inputs=[(c['source'],c['kind'],bytes.fromhex(c['name_storage_hex']).split(b'\0')[0]) for c in header['cases'] if c['source']!='edge'];assert len(inputs)==703
inputs += [('edge',k,n) for k in [1,2,3] for n in [b'',b'CaseName',b'casename',b'Name:Part',b'Name With Space',b'a'*31]]
def name_hash(name):
 value=0
 for c in name.lower():
  value=((value<<4)+c)&0xffffffff;high=value&0xf0000000
  if high:value^=high^(high>>24)
 return value
cases=[]
for source_label,current_kind,name in inputs:
 u.mem_write(owner,b'\0'*0x300);w(owner+4,registry_ptr);u.mem_write(obj,b'\xa5'*0x400);u.mem_write(text,name+b'\0'*64);u.mem_write(node,b'\0'*0x40)
 for offset,storage in [(0x24,all_list),(0x30,effect_list)]:w(owner+offset,storage);w(owner+offset+4,storage);w(owner+offset+8,storage+64);u.mem_write(storage,b'\xa5'*64)
 w(0x14ae664,0);w(0x1222f40,0);w(stack,end);w(stack+4,text);w(stack+8,current_kind);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
 u.emu_start(0x9a52a0,end,count=200000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==obj
 size={1:0x228,2:0x284,3:0x30c}[current_kind];expected=bytearray(size);expected[:len(name)+1]=name+b'\0'
 for offset,value in [(0x40,current_kind),(0x44,name_hash(name)),(0x48,0x100 if current_kind==2 else 0),(0x4c,0xffffffff),(0x1d0,0x3f800000),(0x1d4,0x3f800000),(0x1dc,0xffffffff)]:struct.pack_into('<I',expected,offset,value)
 output=bytes(u.mem_read(obj,size));assert output==expected
 assert read(node+0x20)==owner and read(node+0x24)==obj and read(owner+0x28)==all_list+4 and read(all_list)==obj
 assert read(owner+0x34)==effect_list+(4 if current_kind==2 else 0)
 if current_kind==2:assert read(effect_list)==obj
 cases.append(dict(source=source_label,kind=current_kind,name_hex=name.hex(),name_hash=name_hash(name),size=size,output_hex=output.hex(),general_list_count=1,effect_list_count=int(current_kind==2),registry_owner_and_element_written=True))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x9a52a0',native_sha256=hashlib.sha256(raw).hexdigest(),native_addresses=len(visited),source_case_count=703,case_count=len(cases),cases=cases,findings=['Original element factory, CRT name copying, ASCII case-insensitive ELF hash8E45D0 and vector append5BDCB0 execute.','Effect creation sets flag100 and appends to general and effect lists; Icon/Text append only general list.','Original constructor writes registry owner/element association.'],runtime_adapters=['Successful owner-pool allocation returns supplied storage; named registry lookup returns supplied entry, original registry allocation/collisions/lifetime open.','Vector capacity supplied to avoid growth; vector append executes.','Cookie/thread/errno/logger boundaries reused where needed.'],limits=['703parsed source header names plus18bounded ASCII edge inputs; null/oversize names and allocation failure not qualified.','Named creation only; full file loop/resource/font/effect resolution, widget drawing and interactions remain open.'])
(r/'data/4.20/native_hud_named_creation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),source_cases=703,native_addresses=len(visited))))
