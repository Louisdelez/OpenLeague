from pathlib import Path
import sys,json,hashlib,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');d=json.loads((r/'docs/native_projection_discovery.json').read_text());native=Path(d['source']);raw=native.read_bytes();assert hashlib.sha256(raw).hexdigest()==d['sha256']
p=pefile.PE(data=raw);base=p.OPTIONAL_HEADER.ImageBase;dis=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);image=p.get_memory_mapped_image()
sources=[]
for name in ['FogOfWar_VS.hls','FogOfWar_PS.hls']:
 src=native.parent/'DATA/Shaders/HLSL/FogOfWar'/name;target=r/'data/4.20/shaders/FogOfWar'/name;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(src.read_bytes());sources.append({'source':str(src),'archive':str(target.relative_to(r)),'sha256':hashlib.sha256(src.read_bytes()).hexdigest()})
blocks=[]
for section in p.sections:
 if not section.Characteristics&0x20000000:continue
 data=section.get_data();pos=0
 while True:
  pos=data.find(bytes.fromhex('68e6000000'),pos)
  if pos<0:break
  addr=base+section.VirtualAddress+pos;start=max(addr-96,base+section.VirtualAddress)
  blocks.append({'candidate_register230_push':hex(addr),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str} for i in dis.disasm(image[start-base:addr+96-base],start)]});pos+=1
out={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':d['sha256'],'complete':False,'sources':sources,'candidate_blocks':blocks,'shader_contract':{'uv':'worldPosition.xz * FOG_OF_WAR_PARAMS.xy + FOG_OF_WAR_PARAMS.zw','visibility_texture_register':6,'overlay_texture_register':10,'factor_alpha':'lerp(overlay.a,1,visibility.r)','projected_rgb':'texel.rgb * factor_alpha','height_fade_used_by_projected':False},'limits':['Static push230 candidates may be unrelated; native producer and actual texture dimensions require instruction-level qualification.','No native visibility rasterizer, gameplay grid, palette or death pipeline proved.']}
(r/'docs/projected_fow_sources.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print('candidates',len(blocks))
for block in blocks:
 print(block['candidate_register230_push'])
 for i in block['instructions']:print(i['address'],i['mnemonic'],i['operands'])
