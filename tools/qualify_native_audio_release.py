"""Original voice release/hash emulation and byte-checked stop event recovery."""
from pathlib import Path
import sys,json,struct,hashlib,xml.etree.ElementTree as ET
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import UC_X86_REG_ESP,UC_X86_REG_ECX,UC_X86_REG_EIP,UC_X86_REG_EAX
ctx=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());exe=next(p for p in Path(ctx['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe'
b=exe.read_bytes();p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
def native(a,n):return b[p.get_offset_from_rva(a-base):][:n]
assert native(0x10af41c,6)==b'Stop_\0'
areas=[(0x706f90,0x707062),(0xaea430,0xaea50e),(0xaeb740,0xaeb781),(0x704a80,0x704b07),(0xb078e8,0xb07958)]
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for a,end in areas:
 blob=native(a,end-a);ins=list(md.disasm(blob,a));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(a),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
anchors={0x706f9a:'807e4800',0x706fb1:'8b4628',0x706fbf:'83f9ff',0x706fd6:'e825383e00',0x707049:'6a04',0x70704b:'6a00',0x707050:'e8eb463e00',0x707058:'c6464801',0x704ab7:'6a05',0x704ab9:'681cf40a01',0x704af3:'83f801',0x704af8:'83f803',0xaea4d3:'bac59d1c81',0xaea4f8:'69d293010001',0xaea4ff:'33d1',0xaeb750:'b91e000000'}
for a,data in anchors.items():assert native(a,len(data)//2).hex()==data,hex(a)
assert struct.unpack('<I',native(0xb07d78+30*4,4))[0]==0xb078e8
heap=0x30000000;stack=0x31000000;tramp=0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,tramp]:u.mem_map(a,0x4000)
u.mem_write(tramp,b'\xf4')
def put(a,fmt,*values):u.mem_write(a,struct.pack('<'+fmt,*values))
def ret(uc,value,cleanup=0):
 sp=uc.reg_read(UC_X86_REG_ESP);addr=struct.unpack('<I',uc.mem_read(sp,4))[0];uc.reg_write(UC_X86_REG_EAX,value);uc.reg_write(UC_X86_REG_ESP,sp+4+cleanup);uc.reg_write(UC_X86_REG_EIP,addr)
calls=[];available=True;post_result=99
def guard(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0xaea6b0:ret(uc,int(available));return
 if a==0xaea800:
  args=struct.unpack('<8I',uc.mem_read(sp+4,32));assert args[2:]==(0,0,0,0,0,0)
  calls.append({'kind':'post_stop_event','event_id':args[0],'object_id':args[1]});ret(uc,post_result);return
 if a in [0x5642d0,0x5fa170]:ret(uc,0);return
 if a==0x5bfee0:ret(uc,56);return
 if a==0xb05ed0:
  msg,n=struct.unpack('<II',uc.mem_read(sp+4,8));assert n==56
  payload=uc.mem_read(msg,20);assert struct.unpack_from('<H',payload,2)[0]==30
  playing,duration,curve=struct.unpack_from('<III',payload,8);calls.append({'kind':'stop_playing_id','playing_id':playing,'duration_ms':duration,'curve':curve});ret(uc,1,8);return
 if a==0xca02ed:
  dest,capacity,src,count=struct.unpack('<4I',uc.mem_read(sp+4,16));assert count<=capacity and count<=259
  uc.mem_write(dest,bytes(uc.mem_read(src,count)));ret(uc,0);return
 assert any(start<=a<end for start,end in areas[:3]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(a,args=(),receiver=heap):
 put(stack+0x3800,'I'*(1+len(args)),tramp,*args);u.reg_write(UC_X86_REG_ESP,stack+0x3800);u.reg_write(UC_X86_REG_ECX,receiver);u.emu_start(a,tramp,count=10000);assert u.reg_read(UC_X86_REG_EIP)==tramp
 return u.reg_read(UC_X86_REG_EAX)
release_cases=[]
import itertools
for released,available,stop_id,obj,post_result,playing in itertools.product([False,True],[False,True],[0,3068939807],[-1,123],[0,99],[0,456]):
 u.mem_write(heap,b'\0'*0x100);put(heap+4,'Ii',playing,obj);put(heap+0x28,'I',stop_id);put(heap+0x40,'I',15);put(heap+0x48,'B',int(released));put(0x14a7a28,'I',heap+0x900)
 calls.clear();invoke(0x706f90);invoke(0x706f90)
 release_cases.append({'released':released,'engine_available':available,'stop_event_id':stop_id,'object_id':obj,'playing_id':playing,'post_result':post_result,'calls':list(calls),'final_released':bool(u.mem_read(heap+0x48,1)[0])})
def native_hash(name):
 assert name.isascii() and len(name)<=258
 u.mem_write(heap+0x1000,name.encode()+b'\0');return invoke(0xaea430,(heap+0x1000,))
registry={};banks=[];field_checks=[]
for family,xml in [('ENV_Map10_SFX',r/'docs/ambient_env_banks.xml'),('NPC_Map10_SFX',Path('E:/mapslol3v3/output/Map_Completion/npc_map10.xml'))]:
 tree=ET.fromstring('<banks>'+xml.read_text(encoding='utf-8')+'</banks>')
 for bank in tree.findall('./root'):
  source=Path(bank.get('path'))/bank.get('filename');raw=source.read_bytes();banks.append({'path':str(source),'sha256':hashlib.sha256(raw).hexdigest(),'xml_sha256':hashlib.sha256(xml.read_bytes()).hexdigest()})
  for node in bank.findall('./object/list/object'):
   f=node.find("field[@name='ulID']")
   if f is not None:registry[(family,int(f.get('value')))]=(node,raw,str(source))
def verify(node,raw,source):
 for f in node.findall('.//field'):
  if f.get('offset') is None:continue
  fmt={'u8':'B','u16':'H','u32':'I','sid':'I','tid':'I','uni':'I'}[f.get('type')];off=int(f.get('offset'));size=struct.calcsize('<'+fmt);assert struct.unpack_from('<'+fmt,raw,off)[0]==int(f.get('value'))
  field_checks.append({'bank':source,'node':int(node.find("field[@name='ulID']").get('value')),'name':f.get('name'),'offset':off,'raw_bytes':raw[off:off+size].hex()})
events=[];hash_cases=[]
for asset in sorted((r/'data/4.20/particles').glob('Audio-Emitter_*.json')):
 particle=json.loads(asset.read_text());system=particle['sections']['System'];name=system.get('SoundPersistent') or system['SoundOnCreate'];assert name.startswith('Play_')
 family='NPC_Map10_SFX' if 'Shopkeeper' in asset.name else 'ENV_Map10_SFX';stop='Stop_'+name[5:];stop_id=native_hash(stop)
 for name_to_hash in [name,stop]:hash_cases.append({'name':name_to_hash,'native_id':native_hash(name_to_hash)})
 actions=[];entry=registry.get((family,stop_id))
 if entry:
  node,raw,source=entry;assert node.get('name')=='CAkEvent';verify(node,raw,source)
  for action in node.findall(".//field[@name='ulActionID']"):
   n,raw,source=registry[(family,int(action.get('value')))];assert n.get('name')=='CAkActionStop';verify(n,raw,source)
   def value(name):return int(n.find(".//field[@name='%s']"%name).get('value'))
   props={int(z.find("field[@name='pID']").get('value')):int(z.find("field[@name='pValue']").get('value')) for z in n.findall(".//object[@name='AkPropBundle']")}
   assert value('ulActionType')==259 and value('idExt_4')==0 and props.keys()=={15} and value('byBitVector')==4 and value('ulExceptionListSize')==0
   actions.append({'id':value('ulID'),'target':value('idExt'),'action_type':259,'transition_ms':props[15],'curve':4})
 events.append({'asset':asset.name,'play_name':name,'stop_name':stop,'stop_id':stop_id if entry else 0,'candidate_stop_id':stop_id,'found_in_source_banks':bool(entry),'actions':actions})
assert sum(bool(e['actions']) for e in events)==4
limits=['Release and ASCII event hash routines executed in bounded emulator; readiness/PostEvent/audio queue/logging/memcpy stubbed. No audible output, DSP or full-game acceptance.','Stop name replacement and availability checks are instruction-qualified; recovered four stop events/six stop actions byte checked against two relevant banks. Brazier stop missing from these banks is not claimed absent from every bank.','Stop action scope=259 and fade=4 retained; full bank action execution and fades not yet mixed.','Fallback API identification as StopPlayingID supported by native message30 parameters and official SDK signature; matching native symbols absent.']
result={'schema':1,'provenance':{'executable':str(exe),'sha256':hashlib.sha256(b).hexdigest(),'unicorn_version':unicorn.__version__},'release_cases':release_cases,'hash_cases':hash_cases,'events':events,'banks':banks,'limits':limits}
(r/'data/4.20/audio_release_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
receipt={'passed':True,'release_cases':len(release_cases),'release_invocations':len(release_cases)*2,'event_hash_samples':len(hash_cases),'stop_events':4,'stop_actions':6,'source_field_checks':len(field_checks),'source_checks':field_checks,'instruction_anchors':len(anchors),'regions':regions,'provenance':result['provenance'],'limits':limits,'complete':False,'reference':'https://www.audiokinetic.com/en/public-library/2024.1.5_8803/?id=AkSoundEngine.h&source=SDK'}
(r/'docs/map_ambient_audio_release_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print({k:v for k,v in receipt.items() if k not in ['source_checks','regions','provenance','limits','reference']})
