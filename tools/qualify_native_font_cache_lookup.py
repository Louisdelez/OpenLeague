from pathlib import Path
import json,hashlib,datetime,itertools,struct,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text().split('\nu.hook_add(')[0],'font cache lookup prerequisites','exec'))
manager=vector+0x6000;query=vector+0x7000;entries=vector+0x8000;devices=vector+0x9000;query_name=vector+0xc000;descriptors=vector+0xd000;names=vector+0xd800;vtable=vector+0xf000
def descriptor(address,name_address,name,size,extra,flags):
 u.mem_write(address,b'\0'*0x24);encoded=name.encode('utf-16-le');u.mem_write(name_address,encoded+b'\0\0');w(address,name_address);w(address+0x10,len(encoded)//2);w(address+0x14,64);w(address+0x18,size);w(address+0x1c,extra);w(address+0x20,flags)
miss=False
def hook(uc,a,size,user):
 global miss
 if a==vector+0x5200:
  obj=uc.reg_read(UC_X86_REG_ECX);assert obj>=devices and (obj-devices)%0x100==0;finish(descriptors+(obj-devices)//0x100*0x40);return
 if a==0x8c0fb9:miss=True;uc.reg_write(UC_X86_REG_EIP,end);return
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(vtable,vector+0x5200)
profiles=[[],[('Gill Sans MT Pro Medium',17,0,0x10)],[('GILL SANS MT PRO MEDIUM',17,0,0x10)],[('Other',17,0,0x10),('Gill Sans MT Pro Medium',17,0,0x10)],[('Gill Sans MT Pro Medium',17,0,0x10),('Gill Sans MT Pro Medium',17,0,0x10)],[('Gill Sans MT Pro Medium',17,0,0x14),('Gill Sans MT Pro Medium',23,0,0x10)]]
queries=[('Gill Sans MT Pro Medium',17,0,0x10),('gill sans mt pro medium',17,0,0x10),('Gill Sans MT Pro Medium',17,0,0x14),('Gill Sans MT Pro Medium',23,0,0x10),('Gill Sans MT Pro Medium',17,1,0x10),('Missing',17,0,0x10)]
cases=[]
for profile,q,refcount in itertools.product(profiles,queries,[1,0xffffffff]):
 miss=False;w(0,0);u.mem_write(manager,b'\0'*0x40);w(manager+0x10,entries);w(manager+0x14,entries+8*len(profile));descriptor(query,query_name,*q)
 for i,row in enumerate(profile):
  descriptor(descriptors+i*0x40,names+i*0x100,*row);w(devices+i*0x100,vtable);w(entries+i*8,refcount);w(entries+i*8+4,devices+i*0x100)
 w(stack,end);w(stack+4,query);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0x8c0f50,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 found=None if miss else (u.reg_read(UC_X86_REG_EAX)-devices)//0x100
 after=[read(entries+i*8) for i in range(len(profile))]
 assert all(v==((refcount+1)&0xffffffff if i==found else refcount) for i,v in enumerate(after))
 cases.append(dict(entries=[dict(name=a,size=b,extra=c,flags=d) for a,b,c,d in profile],query=dict(name=q[0],size=q[1],extra=q[2],flags=q[3]),initial_references=refcount,found_index=found,references_after=after,creation_required=miss))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x8c0f50',case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original cache lookup loop, descriptor comparator and reference increment execute. Cached device virtual descriptor getter supplied; no GPU device used.','Miss stops at8C0FB9before allocation/creation; no insertion/removal/destruction/failure lifetime qualification.','First equal descriptor reused; references use original wrapping u32 increment. Default CRT locale only, supplied vector and strings.'])
(r/'data/4.20/native_font_cache_lookup_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
