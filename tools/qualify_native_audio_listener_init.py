"""Execute native global listener initialization and dirty-mask publication."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_pcm_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
areas=[(0xb19e30,0xb19eb4),(0xb19ec0,0xb19f6f),(0xb1a0b0,0xb1a15a),(0xb052b0,0xb05310)];md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for start,end in areas:
 blob=p.get_data(start-base,end-start);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
heap,stack,trap=0x30000000,0x31000000,0x32000000;u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
u.mem_write(trap+0x100,b'\xdb\xe3');notifications=[]
def hook(uc,a,n,d):
 if a==0xb09b60:
  sp=uc.reg_read(UC_X86_REG_ESP);ret,mask=struct.unpack('<II',uc.mem_read(sp,8));notifications.append(mask);uc.reg_write(UC_X86_REG_ESP,sp+8);uc.reg_write(UC_X86_REG_EIP,ret);return
 assert any(x<=a<z for x,z in areas) or a==trap+0x100,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def call(fn):
 u.emu_start(trap+0x100,trap+0x102);sp=stack+0x8000;u.mem_write(sp,struct.pack('<I',trap));u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(fn,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
u.mem_write(0x14a7e60,b'\0'*(8*0x90));call(0xb19e30);slots=[]
for i in range(8):
 a=0x14a7e60+i*0x90;slots.append({'frame':list(struct.unpack('<9f',u.mem_read(a,36))),'basis':list(struct.unpack('<9f',u.mem_read(a+0x50,36))),'distance_scale':struct.unpack('<f',u.mem_read(a+0x24,4))[0],'dirty':bool(u.mem_read(a+0x80,1)[0]),'channel_gains':list(struct.unpack('<8f',u.mem_read(a+0x30,32)))})
flags={'audio_enabled_mask':struct.unpack('<I',u.mem_read(0x1210244,4))[0],'other_mask_raw':struct.unpack('<I',u.mem_read(0x14a7e50,4))[0]};cases=[]
for mask in range(256):
 for i in range(8):u.mem_write(0x14a7ee0+i*0x90,bytes([255 if mask&(1<<i) else 0]))
 before=bytes(u.mem_read(0x14a7e60,8*0x90));notifications.clear();call(0xb19ec0);first=notifications.copy();notifications.clear();call(0xb19ec0);second=notifications.copy();after=bytes(u.mem_read(0x14a7e60,8*0x90))
 assert first==([mask] if mask else []) and not second
 for i in range(8):
  assert u.mem_read(0x14a7ee0+i*0x90,1)==b'\0';offset=i*0x90+0x80;assert after[i*0x90:offset]==before[i*0x90:offset] and after[offset+1:(i+1)*0x90]==before[offset+1:(i+1)*0x90]
 cases.append({'dirty_mask':mask,'first_notifications':first,'second_notifications':second,'dirty_after':[False]*8,'other_slot_bytes_preserved':True})
result={'passed':True,'initial_slots':slots,'initial_global_flags':flags,'default_frame_source':{'address':'0x1210294','bytes':p.get_data(0x1210294-base,36).hex()},'cases':cases,'regions':regions,'provenance':c['provenance'],'limits':['B09B60 notification callback stubbed to capture mask; downstream voice invalidation not executed.','Global initializer executed from zeroed listener storage; separate non-BSS memory fields untouched by initializer are not default-qualified.','No runtime audio callback scheduling or actual listening acceptance.'],'complete':False}
(r/'data/4.20/audio_listener_init_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Native listener init:8 slots; dirty flush:256 masks/512 calls; frame',slots[0]['frame'],'scale',slots[0]['distance_scale'])
