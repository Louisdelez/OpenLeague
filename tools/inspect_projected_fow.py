from pathlib import Path
import sys,json,hashlib,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');d=json.loads((r/'docs/native_projection_discovery.json').read_text());raw=Path(d['source']).read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest==d['sha256']
p=pefile.PE(data=raw);image=p.get_memory_mapped_image();base=p.OPTIONAL_HEADER.ImageBase;dis=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
blocks=[]
for label,start,end in [('terrain_fow_setup',0x92ddf0,0x92df10),('projected_base_setup',0x931020,0x931235),('projected_geometry_bind',0x92e2c0,0x92e3ec)]:
 code=image[start-base:end-base];instructions=[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str} for i in dis.disasm(code,start)]
 blocks.append({'label':label,'start':hex(start),'end_exclusive':hex(end),'bytes_sha256':hashlib.sha256(code).hexdigest(),'instructions':instructions})
out={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'complete':False,'behavior_emulated':False,'blocks':blocks,'limits':['Static native instruction inventory only; FOW texture identity, coordinates and bindings must be qualified before porting.']}
(r/'docs/projected_fow_discovery.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
for block in blocks:
 print(block['label'])
 for i in block['instructions']:print(i['address'],i['mnemonic'],i['operands'])
