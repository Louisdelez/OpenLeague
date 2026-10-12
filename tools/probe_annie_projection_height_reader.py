from pathlib import Path
import json,struct,hashlib,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0],'native setup','exec'))
stub=heap+0x1f000;u.mem_write(stub,bytes.fromhex('d9442410c3'));native_code_ranges.append((stub,stub+5));calls=[];values={}
def reader(uc,a,size,user):
 if a==0x8b1f50:
  top=u.reg_read(UC_X86_REG_ESP);ptr=read32(top+12);key=bytes(u.mem_read(ptr,80)).split(b'\0')[0].decode();default=struct.unpack('<f',u.mem_read(top+16,4))[0]
  value=values.get(key,default);u.mem_write(top+16,struct.pack('<f',value));calls.append(dict(key=key,default=default,value=value,authored=key in values));u.reg_write(UC_X86_REG_EIP,stub)
u.hook_add(unicorn.UC_HOOK_CODE,reader)
path=r/'data/4.20/particles/annie/Annie_Q_mis.json';doc=json.loads(path.read_text());keys=['p-projection-y-range','p-projection-fading'];actual={k:doc['sections']['Projected'][k] for k in keys if k in doc['sections']['Projected']};rows=[]
for name,values in [('annie',actual),('zero',dict(zip(keys,[0.,0.]))),('authored',dict(zip(keys,[12.,75.]))),('signed',dict(zip(keys,[-5.,-20.])) )]:
 for previous in [0,0x3f800000,0xa5a5a5a5]:
  for offset in [0x1cc,0x1d0]:write32(definition+offset,previous)
  calls.clear();u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBX,definition);u.reg_write(UC_X86_REG_ESI,0);u.reg_write(UC_X86_REG_EDI,0);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x91da6f,0x91dab1,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x91dab1
  result=floats(definition+0x1cc,2);assert result==[values.get(keys[0],5.),values.get(keys[1],200.)]
  rows.append(dict(name=name,previous=previous,calls=list(calls),result=result))
proof=dict(complete=False,passed=True,native_sha256=digest,resource_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),entry='0x91da6f',stop='0x91dab1',cases=rows,annie_authored=actual,annie_effective=[5.,200.],adapters=['8B1F50 lookup supplies decoded numeric resource values or actual native caller defaults using x87 FLD/RET. Full native lookup/parser not executed.'],limits=['Caller numeric transport/default replacement qualified; source resource decoder provenance separate.','Color lookup texture and full shader integration remain pending.'])
(r/'data/4.20/annie_projection_height_reader_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(cases=len(rows),annie=proof['annie_effective'],authored=actual)))
