from pathlib import Path
import json,struct,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague')
exec(compile((Path(__file__).parent/'probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native HUD scanner prerequisites','exec'))
warnings=0;scan_return=None
def property_hook(uc,a,size,user):
 global warnings,scan_return
 if a==0x5642d0:warnings+=1
 if a in [0x9a21c6,0x9a2025,0x9a25f8]:
  scan_return=uc.reg_read(UC_X86_REG_EAX);scan_return=scan_return if scan_return<0x80000000 else scan_return-0x100000000
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,property_hook)
w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca1da7,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
audit=json.loads((r/'data/4.20/native_hud_layout_source_audit.json').read_text(encoding='utf-8'));inputs={k:set() for k in ['Rect','UV','Anchor']}
for file in audit['files']:
 for record in file['records']:
  for k,v in record['_ordered_properties']:
   if k in inputs:inputs[k].add(v)
source_counts={k:len(v) for k,v in inputs.items()}
edge=['',' ','0','0,','0,0','0,0 - 1,1','16,32 - 96,128 / 1024x1024','  .5 , -.25 - +1 , 1e2 / 256 x 512  ','1,2-3,4/5x6tail','1,2-3,4/5','1,2-3,4 garbage','1 2 3 4','1;2-3;4','x','+','-','.','+.','1e','1e+','1e-','1e2','.5e-2','nan,inf','INF,NaN','0x1,2','1,2\0-3,4','1,2\r\n-3,4','\t1,\t2 -\t3,4 / 5\tx6','-0,+0 - -0,+0','1e40,2','1e-50,2','392.32,596.48 - 423.04,627.2 / 1024x768']
for values in inputs.values():values.update(edge)
bits=lambda x:struct.unpack('<I',struct.pack('<f',x))[0]
initial=[bits(x) for x in [.125,-.25,.375,-.5]];cases=[]
for prop in ['Anchor','Rect','UV']:
 for value in sorted(inputs[prop]):
  for variant in ([0,1] if prop in ['Rect','UV'] else [0]):
   warnings=0;scan_return=None;calls.clear();u.mem_write(obj,b'\0'*0x300);u.mem_write(text,b'\0'*1024);u.mem_write(text,value.encode('latin-1')+b'\0');kind=variant+1 if prop=='UV' else 1;w(obj+0x40,kind)
   for p in [0x1a8,0x1c0,0x204,0x214,0x264,0x274]:u.mem_write(obj+p,struct.pack('<4I',*initial))
   offset=[.125,-.25] if prop=='Rect' and variant else [0.,0.];u.mem_write(origin,struct.pack('<2f',*offset));w(errno,0)
   w(stack,end);w(stack+4,obj);w(stack+8,text);w(stack+12,0);w(stack+16,origin);u.reg_write(UC_X86_REG_ESP,stack)
   entry={'Anchor':0x9a2000,'Rect':0x9a2180,'UV':0x9a2590}[prop];u.emu_start(entry,end,count=250000);assert u.reg_read(UC_X86_REG_EIP)==end,(prop,value,hex(u.reg_read(UC_X86_REG_EIP)))
   out=lambda p,n:list(struct.unpack('<'+'I'*n,u.mem_read(obj+p,n*4)))
   cases.append(dict(property=prop,text_bytes=list(value.encode('latin-1')),element_type=kind,origin_bits=[bits(x) for x in offset],initial_bits=initial,scanner_assignments=scan_return,result=u.reg_read(UC_X86_REG_EAX),warnings=warnings,anchor_bits=out(0x1a8,4),rect_bits=out(0x1c0,4),type1_uv_bits=out(0x204,8),type2_uv_bits=out(0x264,8)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),source_audit_sha256=hashlib.sha256((r/'data/4.20/native_hud_layout_source_audit.json').read_bytes()).hexdigest(),source_unique_values=source_counts,case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['CRT thread context supplied with original static C locale pointers; original locale accessor executes.','Original floating dispatch initialization CA1DA7 executes; DecodePointer returns the unencoded initialized pointer (matching supplied encoding context).','Security cookie, errno accessor and diagnostic logger adapted; original scanf, decimal/float conversion and HUD property handlers execute.'],limits=['Property value reading only; structural HUD file parser, types/visibility, anchor interpretation, scale, pixel layout and drawing remain open.','Supplied default C locale/thread and floating dispatch; actual process startup/TLS/pointer encoding/hardware FP mode not qualified.','Finite source values and listed edge inputs; no general CRT compatibility claim.'])
(r/'data/4.20/native_hud_property_text_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
for name in [Path(__file__).name,'probe_native_hud_formatted_scanner.py']:
 shutil.copy2(Path(__file__).parent/name,r/'tools'/name)
print(json.dumps(dict(cases=len(cases),source_unique_values=source_counts,native_addresses=len(visited),passed=True)))
