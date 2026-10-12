from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD callback prerequisites','exec'))
warnings=0
def callback_hook(uc,a,size,user):
 global warnings
 if a==0x5642d0:warnings+=1
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,callback_hook);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca1da7,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
registry=json.loads((r/'data/4.20/native_hud_property_registry_contract.json').read_text(encoding='utf-8'));entries={v['name']:int(v['callback'],16) for v in registry['registrations']}
names=['LeftAnchor','Color','PerPixelUVsX','MinUV','EffectParams0','EffectColor0','EffectColor1','Align'];inputs={p:set() for p in names};cursor=vector+0xe000;following=vector+0x10000
audit=json.loads((r/'data/4.20/native_hud_layout_source_audit.json').read_text(encoding='utf-8'))
for file in audit['files']:
 for record in file['records']:
  pairs=record['_ordered_properties']
  for i,(key,value) in enumerate(pairs):
   if key in inputs:
    tail=(pairs[i+1][0]+': '+pairs[i+1][1]+'\n') if key in ['LeftAnchor','MinUV'] and i+1<len(pairs) else ''
    inputs[key].add((value,tail))
source_counts={k:len(v) for k,v in inputs.items()}
edges={
 'LeftAnchor':[(v,t) for v in ['', '0','0,','0.5,1',' 1 , 2','-0,+0'] for t in ['', 'RightAnchor: 1,0\nNext', 'RightAnchor: 1,\nNext', 'rightanchor: 1,2\nNext', '\nRightAnchor: 1,2\n']],
 'MinUV':[(v,t) for v in ['', '0,0-1,1','16,32-96,128/256x512','1,2-3,4/5','0,0-1,1/0x0'] for t in ['', 'MaxUV: 1,2-3,4\nNext','MaxUV: 16,32-64,96/256x512\nNext','MaxUV: 1,2-3,4/5\nNext','MaxUV: 1,2\nNext','maxuv: 1,2-3,4\nNext']],
 'Color':[(v,'') for v in ['', '0','1,2,3','1,2,3,4','255,256,257,-1','4294967296,0,0,0','-1,-2,-3,-4','1,2,3,4tail']],
 'PerPixelUVsX':[(v,'') for v in ['', '0','1','-1','4294967296','1.5','true']],
 'EffectParams0':[(v,'') for v in ['', '0','1,2','1,2,3','1,2,3,4',' .5 , -1 , 2e2 , -0','1e40,2,3,4','nan,1,2,3']],
 'EffectColor0':[(v,'') for v in ['', '1,2,3','1,2,3,4','255,256,257,-1','-1,-2,-3,-4']],
 'EffectColor1':[(v,'') for v in ['', '1,2,3','1,2,3,4','255,256,257,-1','-1,-2,-3,-4']],
 'Align':[(v,'') for v in ['', 'Left','left','LEFT','Center','Centered','Right','RightX',' Left trailing','Unknown','Lef','Right\0Left']],
}
cases=[]
for prop in names:
 for (value,tail),kind in itertools.product(sorted(inputs[prop]|set(edges[prop])),[1,2,3]):
  warnings=0;u.mem_write(obj,b'\xa5'*0x30c);w(obj+0x40,kind);u.mem_write(text,b'\0'*1024);u.mem_write(text,value.encode('ascii')+b'\0');u.mem_write(following,b'\0'*2048);u.mem_write(following,tail.encode('ascii'));w(cursor,following);w(cursor+4,len(tail))
  w(stack,end);w(stack+4,obj);w(stack+8,text);w(stack+12,cursor);w(stack+16,origin);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_FPCW,0x027f);u.reg_write(UC_X86_REG_FPSW,0);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(entries[prop],end,count=250000);assert u.reg_read(UC_X86_REG_EIP)==end
  consumed=read(cursor)-following;assert 0<=consumed<=len(tail) and read(cursor+4)==len(tail)-consumed
  cases.append(dict(property=prop,value=value,following=tail,kind=kind,result=u.reg_read(UC_X86_REG_EAX),warnings=warnings,consumed=consumed,output_hex=bytes(u.mem_read(obj,0x30c)).hex()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),property_count=8,source_unique_inputs=source_counts,case_count=len(cases),native_addresses=len(visited),cases=cases,runtime_adapters=['Original CRT scanner, conversion and handlers execute; C locale/thread/DecodePointer, cookie, errno and logger boundaries reused.','Floating state supplied x87CW027f andMXCSR1f80 percase.'],limits=['Native captured outputs for8callbacks; Rust comparison required separately.','Source audit values and paired following properties plus listed edge inputs, not complete structural file loading.','Owner/resource resolution, rendering/interactions and complete game remain open.'])
(r/'data/4.20/native_hud_remaining_callbacks_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,properties=8,cases=len(cases),source_unique_inputs=source_counts,native_addresses=len(visited))))
