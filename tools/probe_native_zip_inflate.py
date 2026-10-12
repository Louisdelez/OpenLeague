from pathlib import Path
import json,zipfile,struct,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_config_cache_policy.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'ZIP inflate prerequisites','exec'))
u.mem_map(0x42000000,0x800000);u.mem_map(0x41100000,0x800000)
archive=0x40010000;entry=0x40011000;vec=0x40012000;buffer=0x42000000;stream=0x40013000;allocation=0x41000000;payload=b'';pos=0
def hook(uc,a,size,user):
 global allocation,pos
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0xc9f39b:
  count=read(sp+4);p=allocation;allocation+=(count+31)//16*16;assert allocation<0x41900000
  u.mem_write(p,b'\0'*count);finish(p);return
 if a==0xc98528:finish(0);return
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0xc9973d:
  dest,sz,count,fp=[read(sp+i) for i in [4,8,12,16]];assert fp==stream
  data=payload[pos:pos+sz*count]
  if data:u.mem_write(dest,data)
  pos+=len(data);finish(len(data)//sz if sz else 0);return
 if a==0xc9ce75:
  assert read(sp+4)==stream and read(sp+12)==0;pos=read(sp+8);finish(0);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.mem_write(0x2d77b20,b'\x01');w(0x14bef58,0);w(0x14bef40,0)
source=next(Path('D:/LeagueOfLegendsV2/4.20/Client').rglob('HUD.zip'))
data=source.read_bytes()
with zipfile.ZipFile(source) as z:
 info=z.getinfo('HUD/defaults/Chat.ini');expected=z.read(info)
offset=info.header_offset;header=data[offset:offset+30];start=offset+30+int.from_bytes(header[26:28],'little')+int.from_bytes(header[28:30],'little')
payload=data;w(archive,stream);w(archive+0x108,entry);w(archive+0x10c,entry+32);w(entry,offset);w(entry+4,0);w(entry+8,8);w(entry+12,info.compress_size);w(entry+16,info.file_size);w(entry+20,info.CRC);w(entry+24,archive)
w(vec,buffer);w(vec+4,buffer+info.file_size);w(vec+8,buffer+info.file_size);w(stack,end);w(stack+4,0);w(stack+8,vec)
u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,archive)
try:
 u.emu_start(0x8b9750,end,count=20000000)
 assert u.reg_read(UC_X86_REG_EIP)==end,hex(u.reg_read(UC_X86_REG_EIP))
 actual=bytes(u.mem_read(buffer,info.file_size));assert actual==expected
 print(json.dumps(dict(result=u.reg_read(UC_X86_REG_EAX),bytes=len(actual),sha256=hashlib.sha256(actual).hexdigest(),addresses=len(visited))))
except Exception:
 eip=u.reg_read(UC_X86_REG_EIP);print('ERROR_AT',hex(eip),'LAST',sorted(hex(a) for a in visited)[-15:]);raise
