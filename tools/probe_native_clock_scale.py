from pathlib import Path
import struct,json,itertools,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
obj=vector+0x6000;source_obj=vector+0x7000;table=vector+0x8000;stub=vector+0x9000;value=vector+0xa000
u.mem_write(stub,b'\xdd\x05'+struct.pack('<I',value)+b'\xc3');w(table+4,stub);w(source_obj,table)
reads=[];inputs=[]
def observe(uc,address,size,user):
 if address==stub:
  n=len(reads);assert n<len(inputs);reads.append(inputs[n]);u.mem_write(value,struct.pack('<d',inputs[n]))
u.hook_add(unicorn.UC_HOOK_CODE,observe)
def f64(address):return struct.unpack('<d',u.mem_read(address,8))[0]
rows=[]
for present,source,origin,scale,offset,new_scale,advance in itertools.product([False,True],[0.,12.5],[0.,2.25],[0.,.5,1.,2.],[0.,.125],[0.,.25,1.,2.],[0.,.125]):
 reads.clear();inputs[:]=[source,source+advance]
 u.mem_write(obj,b'\0'*0x30);w(obj,0x10d6bc4);w(obj+8,source_obj if present else 0)
 for off,x in [(0x10,scale),(0x20,origin),(0x28,offset)]:u.mem_write(obj+off,struct.pack('<d',x))
 w(stack,end);u.mem_write(stack+4,struct.pack('<d',new_scale));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 u.emu_start(0x9283c0,end,count=100);assert u.reg_read(UC_X86_REG_EIP)==end
 expected_offset=(source-origin)*scale+offset if present else offset
 expected_origin=source+advance if present else offset
 result={'origin':f64(obj+0x20),'scale':f64(obj+0x10),'offset':f64(obj+0x28)}
 assert result==dict(origin=expected_origin,scale=new_scale,offset=expected_offset)
 assert len(reads)==(2 if present else 0)
 rows.append(dict(source_reads=list(reads),before=dict(origin=origin,scale=scale,offset=offset),new_scale=new_scale,after=result,after_words={k:struct.pack('<d',v).hex() for k,v in result.items()}))
out=dict(complete=False,passed=True,entry='0x9283c0',native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Mutator calls underlying source twice when present: wrapper current sample then new origin sample.','Offset and origin are stored as f64, not f32.','No source: both offset and origin retain previous offset; new scale still stored.','Zero scale freezes sampled clock; rescaling preserves offset at second source observation.'],limits=['Exact dyadic finite profiles; arbitrary rounding, nonfinite values and original source provider remain unqualified.','Original native mutator and wrapper executed; source virtual method is a deterministic test stub.'])
(r/'data/4.20/clock_scale_transition_contract.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'passed':True,'native_cases':len(rows),'source_calls':'two when present, zero when absent'}))
