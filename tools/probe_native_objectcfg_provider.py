from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0],'native setup','exec'))
objectptr=terrain+0x2000;nameptr=terrain+0x3000;frame=sp-0x1000;formatted=terrain+0x4000;allocated=terrain+0x6000;requests=[]
def cstring(p):return bytes(u.mem_read(p,256)).split(b'\0')[0].decode('ascii')
def value(p):return cstring(read32(p) if read32(p+0x14)>=16 else p)
def hook(uc,address,size,user):
 stack=u.reg_read(UC_X86_REG_ESP)
 if address==0x5cb980:
  fmt=cstring(u.reg_read(UC_X86_REG_EDX));source=cstring(read32(read32(stack+4)));assert fmt=='LEVELS/%1/Scene/CFG/ObjectCFG.cfg';out=u.reg_read(UC_X86_REG_ECX);text=fmt.replace('%1',source);b=text.encode();u.mem_write(formatted,b+b'\0');write32(out,formatted);write32(out+0x10,len(b));write32(out+0x14,len(b));requests.append(dict(format=fmt,input=source,output=text));u.reg_write(UC_X86_REG_EAX,out);u.reg_write(UC_X86_REG_EIP,read32(stack));u.reg_write(UC_X86_REG_ESP,stack+4)
 elif address==0x9933e0:
  length=read32(stack+4);assert length<0x1000;u.reg_write(UC_X86_REG_EAX,allocated);u.reg_write(UC_X86_REG_EIP,read32(stack));u.reg_write(UC_X86_REG_ESP,stack+4)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for name in ['Map1','Map8','Map10','Map12','']:
 requests.clear();u.mem_write(objectptr,bytes(0x100));write32(objectptr+0x34,15);write32(objectptr+0x4c,15);u.mem_write(nameptr,name.encode()+b'\0');u.mem_write(frame,bytes(0x100));write32(frame+8,nameptr)
 u.reg_write(UC_X86_REG_ECX,objectptr);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,frame-0x100)
 u.emu_start(0x5b24ab,0x5b2539,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x5b2539;assert value(objectptr+0x20)==name and value(objectptr+0x38)==f'LEVELS/{name}/Scene/CFG/ObjectCFG.cfg'
 cases.append(dict(map=name,map_field=value(objectptr+0x20),resource_field=value(objectptr+0x38),requests=list(requests)))
proof=dict(passed=True,complete=False,native_sha256=digest,native_addresses=len(visited),cases=cases,limits=['Actual5B24AB..5B2539 field producer and native string copy/assignment execute; formatter and small allocation adapted.','Static5B2415 format Map%1 supplies the map name; native numeric startup map argument, formatter internals and global lifetime not fully executed.'])
(r/'docs/native_objectcfg_provider_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),map10_resource=cases[2]['resource_field'])))
