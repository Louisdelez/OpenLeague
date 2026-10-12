"""Execute original B008B0 on byte-verified bank RTPC blocks and boundary fixtures."""
from pathlib import Path
import json,struct,itertools,hashlib,xml.etree.ElementTree as ET
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py')
exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
node=heap+0x1000;vtable=heap+0x2000;buffer=heap+0x3000;cursor=heap+0x8000;remaining=heap+0x8100
put(node,'I',vtable);put(vtable+0x134,'I',trap+0x100);put(vtable+0x70,'I',trap+0x200)
calls=[];kind=3;status=1

def guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==trap+0x100: calls.append({'kind':'class'});ret(kind,0);return
 if a==trap+0x200: calls.append({'kind':'notify','parameter':read(sp+4,'I')[0]});ret(0,4);return
 if a==0xb124e0:
  sub,rtpc,parameter,curve,scaling,points,count,owner,cls=read(sp+4,'IIIIIIIII');assert sub==node and owner==0
  calls.append({'kind':'subscribe','rtpc':rtpc,'parameter':parameter,'curve_id':curve,'scaling':scaling,'points':[dict(zip(['from','to','interp'],read(points+i*12,'ffI'))) for i in range(count)],'owner':owner,'class':cls});ret(status,36);return
 assert 0xb008b0<=a<0xb00987,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
ctx=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());blocks=[];banks={}
for n in ctx['nodes']:
 t=ET.fromstring(n['schema_xml']);count=t.find(".//field[@name='ulNumRTPC']")
 if count is None:continue
 raw=Path(n['native_bank']).read_bytes();bank=next(v for v in ctx['banks'] if v['path']==n['native_bank']);assert hashlib.sha256(raw).hexdigest()==bank['sha256'];banks[bank['path']]=bank['sha256']
 off=int(count.get('offset'));size=2
 for curve in t.findall(".//object[@name='RTPC']"):
  size+=15+12*int(curve.find("field[@name='ulSize']").get('value'))
 blocks.append({'id':n['key'],'bytes':raw[off:off+size].hex(),'native_bank':n['native_bank'],'offset':off})
for parameter in [0,4,29,30,31,32,37,63,64,95]:
 for length in [0,1,2]:
  entries=[]
  for index in range(length):
   pts=struct.pack('<ffIffI',0.,-1.,4,100.,0.,4)
   entries.append(struct.pack('<IIIBH',100+index*193,parameter,500+index,2,2)+pts)
  blocks.append({'id':f'boundary:{parameter}:{length}','bytes':(struct.pack('<H',length)+b''.join(entries)).hex()})
rows=[]
for block,enabled,initial,kind,status in itertools.product(blocks,[False,True],[(0,0),(0x81,0x80000002)],[3,4],[1,31,52]):
 raw=bytes.fromhex(block['bytes']);u.mem_write(buffer,raw);put(cursor,'I',buffer);put(remaining,'I',len(raw));put(node+0x30,'II',*initial);put(0x14a7a3c,'I',heap+0x9000 if enabled else 0)
 calls.clear();sp=stack+0x8000;put(sp,'III',trap,cursor,remaining);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb008b0,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'block':block['id'],'manager':enabled,'initial_flags':initial,'class':kind,'subscribe_status':status,'result':u.reg_read(UC_X86_REG_EAX),'flags':read(node+0x30,'II'),'consumed':read(cursor,'I')[0]-buffer,'remaining':read(remaining,'I')[0],'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(b).hexdigest(),'native_reader_sha256':hashlib.sha256(p.get_data(0xb008b0-base,0xd7)).hexdigest(),'blocks':blocks,'banks':banks,'cases':rows,'case_count':len(rows),'adapters':['Virtual class getter134 returns explicit3/4; native notify70 captured.','B124E0 subscription creation captured with explicit return1/31/52. Actual reader/header/point forwarding/flags/cursor arithmetic executes original instructions.'],'limits':['Subscription allocation/replacement/notification side effects not executed.','RTPC flags beyond63 are captured as original behavior; runtime use remains unsupported.','No voice mixer/device output claim.']}
(r/'data/4.20/audio_rtpc_bank_reader_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native RTPC bank reader cases;',len(blocks),'blocks')
