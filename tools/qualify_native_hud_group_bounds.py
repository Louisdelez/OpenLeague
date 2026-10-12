from pathlib import Path
import json,struct,hashlib,itertools,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD group bounds prerequisites','exec'))
u.mem_map(0x50000000,0x100000);owner=vector+0x6000;group=vector+0x7000;member_list=vector+0x14000
u.hook_add(unicorn.UC_HOOK_CODE,scanner_hook);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca1da7,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
source=json.loads((r/'data/4.20/native_hud_file_loop_contract.json').read_text(encoding='utf-8'));scenes=json.loads((r/'data/4.20/native_hud_scenes_contract.json').read_text(encoding='utf-8'))['cases'][0]['groups'];repaired={c['path']:c for c in source['cases'] if c['variant']=='restored'}
elements=[]
for case in source['cases']:
 if case['variant']=='original':elements.extend(repaired.get(case['path'],case)['accepted'])
assert len(elements)==703
members={g['name']:[] for g in scenes}
for i,e in enumerate(elements):
 data=bytes.fromhex(e['output_hex']);ptr=0x50000000+i*0x400;u.mem_write(ptr,data);name=data[32:64].split(b'\0')[0].decode()
 if name in members:members[name].append(i)
assert sum(len(v) for v in members.values())==697
cases=[]
for scene,dimensions,scalar,dirty,cache in itertools.product(scenes,[(1280,800),(1920,1080)],[-1.,0.,1.],[False,True],[0,1]):
 calls.clear();width,height=dimensions;u.mem_write(owner,b'\0'*0x40);u.mem_write(group,b'\0'*0x100);w(owner+0x1c,width);w(owner+0x20,height);u.mem_write(owner+0x18,struct.pack('<f',scalar));w(group+0xc,owner);w(group+0x1c,scene['flags']|(2 if dirty else 0));ids=members[scene['name']];w(group+0x4c,member_list);w(group+0x50,member_list+4*len(ids))
 for k,i in enumerate(ids):w(member_list+4*k,0x50000000+i*0x400)
 initial=[0x7f7fffff,0x7f7fffff,0xff7fffff,0xff7fffff] if cache==0 else [0xbf000000,0xbf800000,0x3f800000,0x40000000];u.mem_write(group+0x70,struct.pack('<4I',*initial))
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,group);u.reg_write(UC_X86_REG_FPCW,0x27f);u.reg_write(UC_X86_REG_FPSW,0);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x9a7960,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==group+0x70
 output=list(struct.unpack('<4I',u.mem_read(group+0x70,16)));flags=read(group+0x1c);assert flags==scene['flags'];assert dirty or output==initial
 cases.append(dict(group=scene['name'],width=width,height=height,owner_scalar_bits=struct.unpack('<I',struct.pack('<f',scalar))[0],dirty=dirty,initial_bits=initial,output_bits=output,output_flags=flags))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),elements=elements,members=members,cases=cases,limits=['Original9A7960bounds union and9A4B30transform/CRT rounding execute with703source element states and697members assigned by48source Scenes groups.','Owner dimensions/scalar and group/cache/list storage supplied; clock/caches/settings producers, text auto sizing and later movement/drawing remain open.','Finite supplied source states at two viewport sizes and three scalars; dirty/cache cases qualified, not an original framebuffer comparison.'])
(r/'data/4.20/native_hud_group_bounds_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(passed=True,cases=len(cases),source_elements=703,members=697,native_addresses=len(visited))))
