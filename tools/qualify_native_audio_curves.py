"""Execute the original bounded x86 audio conversion routines in Unicorn."""
from pathlib import Path
import sys,json,struct,hashlib,xml.etree.ElementTree as ET
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import UC_X86_REG_ESP,UC_X86_REG_ECX,UC_X86_REG_EIP
ctx=json.loads((r/'data/4.20/ambient_audio_context.json').read_text())
# Derive deploy root by name, not depth.
exe=next(p for p in Path(ctx['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe'
raw=exe.read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase
assert pe.FILE_HEADER.Machine==0x14c
for bank in ctx['banks']:
 assert hashlib.sha256(Path(bank['path']).read_bytes()).hexdigest()==bank['sha256']
source_checks=[]
for n in ctx['nodes']:
 if n['native_type']!='CAkAttenuation' and n['id'] not in [393239870,3803692087,573128568]:continue
 bank=Path(n['native_bank']).read_bytes()
 for f in ET.fromstring(n['schema_xml']).findall('.//field'):
  if f.get('name') not in ['From','To','Interp','eScaling','RTPCID','ParamID']:continue
  fmt={'f32':'f','u32':'I','u8':'B','tid':'I'}.get(f.get('type'));assert fmt,f.attrib
  off=int(f.get('offset'));size=struct.calcsize('<'+fmt);actual=struct.unpack_from('<'+fmt,bank,off)[0]
  assert actual==(float(f.get('value')) if fmt=='f' else int(f.get('value')))
  source_checks.append({'node':n['key'],'field':f.get('name'),'offset':off,'bytes':bank[off:off+size].hex()})
constants={0x1138c74:0x3f800000,0x11392ec:0xbf800000,0x1138b64:0x3eaaaaab,0xff00ec:0x3f317218,0xff00dc:0x3ede5bd9,0xff00fc:0xbede5bd9,0x1138ff0:0x41a00000,0x11390b0:0x42fe0000}
for va,bits in constants.items():assert struct.unpack_from('<I',raw,pe.get_offset_from_rva(va-base))[0]==bits,hex(va)
expected={0xadecf8:'8bf9',0xaded6d:'8b548108',0xaded71:'83fa04',0xaded89:'f30f5ed8',0xadeda5:'83fa09',0xadedda:'e891070000',0xadee05:'83e802',0xadef49:'f30f581d748c1301',0xadefbd:'c74508000080c5',0xadefda:'f30f5cc3',0xadf04a:'c7450800008045',0xadf580:'ff2485acf7ad00',0xadf7ac:'97f6ad00',0xadf697:'d9e8',0xadf699:'d86508',0xadf69e:'d8c9',0xadf6a0:'dec9',0xb148bf:'83f802',0xb148df:'f30f58c1',0xb148f1:'c7410800000000',0xae45bd:'897e04',0xae45c0:'894608'}
for va,data in expected.items():assert raw[pe.get_offset_from_rva(va-base):][:len(data)//2].hex()==data,hex(va)
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
regions=[]
for a,size in [(0xadecf0,0x36a),(0xadf570,0x17),(0xadf697,0x1d),(0xb148b0,0x4a),(0xae4550,0x7e)]:
 off=pe.get_offset_from_rva(a-base);blob=raw[off:off+size];ins=list(md.disasm(blob,a));assert sum(i.size for i in ins)==size
 regions.append({'address':hex(a),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=pe.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
heap=0x30000000;stack=0x31000000;tramp=0x32000000;out=heap+0x800
for addr in [heap,stack,tramp]:u.mem_map(addr,0x1000)
u.mem_write(tramp,bytes.fromhex('d91d')+struct.pack('<I',out)+b'\xf4');u.mem_write(tramp+0x100,b'\xdb\xe3')
def guard(uc,addr,size,user):
 assert (0xadecf0<=addr<0xadf05a) or (0xadf570<=addr<0xadf587) or (0xadf697<=addr<0xadf6b4) or (0xb148b0<=addr<0xb148fa) or tramp<=addr<tramp+0x300,hex(addr)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def evaluate(curve,x,optimize=False):
 u.emu_start(tramp+0x100,tramp+0x102)
 points=curve['points'];u.mem_write(heap,struct.pack('<III',heap+0x100,len(points),curve['scaling']))
 u.mem_write(heap+0x100,b''.join(struct.pack('<ffI',p['from'],p['to'],p['interp']) for p in points))
 if optimize:
  u.mem_write(stack+0xf00,struct.pack('<I',tramp+0x200));u.reg_write(UC_X86_REG_ESP,stack+0xf00);u.reg_write(UC_X86_REG_ECX,heap);u.emu_start(0xb148b0,tramp+0x200,count=10000)
  assert u.reg_read(UC_X86_REG_EIP)==tramp+0x200
 u.mem_write(stack+0xf00,struct.pack('<IfII',tramp,float(x),0,heap+0x900));u.reg_write(UC_X86_REG_ESP,stack+0xf00);u.reg_write(UC_X86_REG_ECX,heap);u.emu_start(0xadecf0,tramp+6,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==tramp+6
 return struct.unpack('<f',u.mem_read(out,4))[0]
curves=[];cases=[]
for attenuation in ctx['attenuations']:
 native_node=next(n for n in ctx['nodes'] if n['key']==attenuation['key']);xml=ET.fromstring(native_node['schema_xml'])
 native_points=[{name:(int(f.get('value')) if name=='Interp' else float(f.get('value'))) for name in ['From','To','Interp'] for f in [p.find("field[@name='%s']"%name)]} for p in xml.findall(".//object[@name='AkRTPCGraphPoint']")]
 assert native_points==[p for c in attenuation['curves'] for p in c['points']]
 assert [int(f.get('value')) for f in xml.findall(".//field[@name='eScaling']")]==[c['scaling_raw'] for c in attenuation['curves']]
 for i,c in enumerate(attenuation['curves']):
  curve={'id':attenuation['key']+':'+str(i),'scaling':c['scaling_raw'],'points':[{'from':p['From'],'to':p['To'],'interp':p['Interp']} for p in c['points']]};curves.append(curve)
  maxdist=curve['points'][-1]['from'];start=curve['points'][1]['from']
  xs=[-10.0,0.0,start-0.01,start,start+0.01,maxdist,maxdist+100.0]+[start+(maxdist-start)*j/32 for j in range(1,32)]
  for x in xs:cases.append({'curve':curve['id'],'input':x,'native_output':evaluate(curve,x),'bus_gain':False})
for n in ctx['nodes']:
 if n['id'] not in [393239870,3803692087,573128568]:continue
 node=ET.fromstring(n['schema_xml'])
 for rtpc in node.findall(".//object[@name='RTPC']"):
  def val(name):return int(rtpc.find("field[@name='%s']"%name).get('value'))
  assert val('ParamID')==4
  ps=[{'from':float(p.find("field[@name='From']").get('value')),'to':float(p.find("field[@name='To']").get('value')),'interp':int(p.find("field[@name='Interp']").get('value'))} for p in rtpc.findall(".//object[@name='AkRTPCGraphPoint']")]
  curve={'id':n['key']+':bus','scaling':val('eScaling'),'points':ps,'parameter':val('RTPCID')};curves.append(curve)
  for x in [-10.0,0.0,1.0,25.0,50.0,75.0,99.0,100.0,110.0]:
   for optimize in [False,True]:cases.append({'curve':curve['id'],'input':x,'native_output':evaluate(curve,x,optimize),'bus_gain':optimize})
# Exercise both signs and exceptional normalized endpoints using a one-point native table.
for v in [-2.0,-1.0,-0.999999,-0.99,-0.75,-0.5,-0.25,-0.01,0.0,0.01,0.25,0.5,0.75,0.99,0.999999,1.0,2.0]:
 curve={'id':'scaling_boundary:'+str(v),'scaling':2,'points':[{'from':0.0,'to':v,'interp':4}]};curves.append(curve);cases.append({'curve':curve['id'],'input':0.0,'native_output':evaluate(curve,0),'bus_gain':False})
result={'schema':1,'curves':curves,'cases':cases,'provenance':{'native_executable':str(exe),'sha256':hashlib.sha256(raw).hexdigest(),'context_sha256':hashlib.sha256((r/'data/4.20/ambient_audio_context.json').read_bytes()).hexdigest(),'unicorn_version':unicorn.__version__},'limits':['Original generic conversion and bus preprocessing executed with bounded native code in an emulator. No sound playback, complete RTPC routing, listener positioning or live mixer acceptance implied.','Native normalized scaling uses approximate log and endpoint sentinels -4096/+4096, not a guessed -1 dB or -96.3 dB mapping.','Only native interpolation 0/4/9 and scaling 0/2 used here. Other modes remain unsupported.']}
(r/'data/4.20/audio_curve_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
receipt={'passed':True,'source_curve_fields_byte_checked':len(source_checks),'source_checks':source_checks,'native_constants_byte_checked':len(constants),'native_constants':{hex(a):hex(b) for a,b in constants.items()},'native_instructions_checked':len(expected)-1,'native_jump_table_entries_checked':1,'native_emulation_samples':len(cases),'native_attenuation_curves':4,'native_bus_curves':3,'boundary_cases':17,'regions':regions,'provenance':result['provenance'],'limits':result['limits'],'complete':False}
(r/'docs/map_ambient_audio_curve_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print({k:v for k,v in receipt.items() if k not in ['regions','provenance','limits','source_checks','native_constants']})
