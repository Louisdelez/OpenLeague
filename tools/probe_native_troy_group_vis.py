"""Actual26nativeTroybinary loads ->8B1F50 ->918F74 ->921F60 placements."""
from pathlib import Path
import json,struct,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/qualify_native_fog_consumer.py').read_text(encoding='utf-8').split('\ndef invalid')[0]
setup=setup.replace("Path(__file__).with_name('qualify_native_fog_value_reads.py')","(r/'tools/qualify_native_fog_value_reads.py')").replace("assert path.lower()=='levels/map10/terrain.ini' and flag==0","assert flag==0")
exec(compile(setup,'actual typed config setup','exec'))
native_code_ranges.extend([(0x918f74,0x918f9c),(0x921f60,0x922000)])
metadata=0x4000b000;actor=0x4000c000;position=0x4000d000
def stop_hook(uc,a,size,user):
 if a==0x918f9c:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,stop_hook)
catalog=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text(encoding='utf-8'));definitions=[];placements=[]
for definition in catalog['definitions']:
 source=Path(definition['native_file']);contents=source.read_bytes();assert hashlib.sha256(contents).hexdigest()==definition['source_sha256'];cursor=0;closes=0;opens=[];reads=[]
 u.mem_write(config,bytes(0x180));write32(config+0x71,15);u.mem_write(key_vectors,bytes(14*12));write32(config+0x7c,key_vectors);write32(config+0x80,key_vectors+14*12);write32(config+0x84,key_vectors+14*12)
 u.mem_write(path_buffer,(source.stem+'.troy').encode('ascii')+b'\0');invoke(0x8b0380,config,struct.pack('<I',path_buffer));assert u.reg_read(UC_X86_REG_EAX)&255==1 and cursor==len(contents) and closes==1
 u.mem_write(config+0x148,b'\1');requests=[];conversions=[];write32(metadata+0x138,0xa5a5a5a5)
 sp=stack+0x8000;u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,metadata);u.reg_write(UC_X86_REG_EBX,path_buffer);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 u.emu_start(0x918f74,0x918f9c,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x918f9c
 coefficient=read32(metadata+0x138);doc=json.loads((r/definition['asset']).read_text(encoding='utf-8'));system=doc['sections']['System'];authored=system.get('group-vis');expected=250. if authored is None else float(authored);assert coefficient==struct.unpack('<I',struct.pack('<f',expected))[0]
 field=next((f for f in doc['fields'] if f.get('section')=='System' and f.get('name')=='group-vis'),None)
 definitions.append({'reference':definition['reference'],'native_file':str(source),'source_sha256':definition['source_sha256'],'byte_count':len(contents),'consumed':cursor,'system':system,'group_vis_field_type':None if field is None else field['field_type_bit'],'coefficient_bits':hex(coefficient),'requests':requests.copy(),'conversions':conversions.copy()})
 aliases={v.lower() for v in definition['aliases']}
 for placement in catalog['placements']:
  if placement['reference'].lower() not in aliases:continue
  input_bits=[struct.unpack('<I',struct.pack('<f',v))[0] for v in placement['position']];u.mem_write(actor,bytes(0x200));write32(actor+0xe8,metadata);u.mem_write(position,struct.pack('<3I',*input_bits));invoke(0x921f60,actor,struct.pack('<I',position))
  placements.append({'line':placement['line'],'reference':definition['reference'],'input_bits':[hex(v) for v in input_bits],'coefficient_bits':hex(coefficient),'position_bits':[hex(read32(actor+0x90+i*4)) for i in range(3)],'minimum_bits':[hex(read32(actor+0x130+i*4)) for i in range(3)],'maximum_bits':[hex(read32(actor+0x13c+i*4)) for i in range(3)]})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'definitions':definitions,'placements':placements,'adapters':['Original binary8B0380loader, key hash,8B1F50getter,8AFB10typedlookup,918F74callerdefault250andfieldstore,921F60position/bounds execute on actual26Troybinaryresources. File IO/allocator/thread/mutex/cookie transport reused.','Cache lookup provides pair pointing to actual native-loaded config; no text overlay. Numeric CRT conversion adapter reused if needed; conversions explicitly recorded.','Caller begins after group-slot enumeration. Supplied path and output metadata; stop before next System field. Actual placement f32positions supplied directly from Particles.dat catalog.'],'limits':['Config cache/hierarchy/global overlays and complete group-slot/resource construction remain incomplete.','Position producer, whole940frame pose dispatch and ordinary renderer binding remain incomplete.','This qualifies authored System/group-vis and fallback250 for recovered26definitions, not missing resources or other map definitions.']}
(r/'data/4.20/troy_group_vis_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'definitions':len(definitions),'placements':len(placements),'authored':sum(v['group_vis_field_type'] is not None for v in definitions)}))
