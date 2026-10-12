from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_inibin_loader.py').read_text(encoding='utf-8').split('queries=[]')[0]
exec(compile(prefix,'original INIBIN loader prerequisites','exec'))
import capstone
for i in dis.disasm(bytes(u.mem_read(0x8af830,0x60)),0x8af830):
 if i.mnemonic=='call' and i.op_str=='dword ptr [0xfa4378]':thread_calls[i.address]=i.address+i.size
native_code_ranges.extend([(0x8af830,0x8afb10),(0x5fa720,0x5fa800)])
queries=[]
float_stub=end+0x700;float_value=end+0x800;u.mem_write(float_stub,b'\xd9\x05'+struct.pack('<I',float_value)+b'\xc3');native_code_ranges.append((float_stub,float_stub+7));crt_conversions=[]
def numeric_conversion(uc,a,size,user):
 if a==0xc99987:
  top=uc.reg_read(UC_X86_REG_ESP);s=text(read32(top+4));value=float(s);crt_conversions.append(dict(entry=hex(a),text=s,value=value));u.mem_write(float_value,struct.pack('<f',value));uc.reg_write(UC_X86_REG_EIP,float_stub)
u.hook_add(unicorn.UC_HOOK_CODE,numeric_conversion)
def invalid(uc,access,address,size,value,user):
 print(json.dumps({'invalid_memory':hex(address),'eip':hex(uc.reg_read(UC_X86_REG_EIP))}),flush=True);return False
u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid)
for name,kind,fallback in [('Red','int',128),('Green','int',128),('Blue','int',128),('Enable','int',0),('useOpacityMap','int',0),('opacity','float',1.),('min_height','float',0.),('max_height','float',1.),('min_radius','float',0.),('max_radius','float',1.),('min_opaque_height','float',0.),('max_opaque_height','float',1.)]:
 key=int(parser['hashkey']('Fog',name));entry=0x8af830 if kind=='int' else 0x8afb10;default=int(fallback) if kind=='int' else struct.unpack('<I',struct.pack('<f',fallback))[0]
 u.mem_write(destination,b'\xcc'*4);invoke(entry,config,struct.pack('<5I',destination,0,0,key,default));found=bool(u.reg_read(UC_X86_REG_EAX)&255);bits=read32(destination);value=struct.unpack('<i' if kind=='int' else '<f',struct.pack('<I',bits))[0]
 queries.append(dict(property='Fog/'+name,kind=kind,default=fallback,found=found,result=value,result_bits=bits));print(json.dumps(queries[-1]),flush=True)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,source=str(source),source_sha256=hashlib.sha256(contents).hexdigest(),queries=queries,crt_conversions=crt_conversions,adapters=['Reuse original binary loader file/allocator/mutex/thread/cookie boundaries; original typed getter bodies execute against loaded config storage.','CRT atof0xc99987 conversion is adapted to Python float plus x87 FLD/RET for observed ASCII numeric string; original CRT locale/thread conversion internals not executed.'],limits=['Config cache/overlay registration and full fog consumer/render passes not executed.','Not original framebuffer qualification.'])
(r/'data/4.20/native_fog_value_reads_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
