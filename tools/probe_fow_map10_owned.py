from pathlib import Path
import json,struct,hashlib,datetime,collections
r=Path('E:/OpenLeague')
exe=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source'])
nav_source=exe.parent/'LEVELS/Map10/AIPath.aimesh_ngrid'
archived=Path('E:/mapslol3v3/output/TwistedTreeline_Map10_Native_4.20/Map10/AIPath.aimesh_ngrid')
nav_raw=archived.read_bytes(); original=nav_source.read_bytes(); assert nav_raw==original
assert nav_raw[:3]==bytes([3,1,0])
header=struct.unpack_from('<6ffII',nav_raw,3); minimum=header[:3];maximum=header[3:6];cell_size=header[6];width,height=header[7:];total=width*height
compact=(r/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();assert len(compact)==total*11
disk=nav_raw[39:39+56*total];assert len(disk)==56*total
for i in range(total):
 assert disk[i*56:i*56+4]==compact[i*11:i*11+4], ('height',i)
 assert disk[i*56+50:i*56+52]==compact[i*11+4:i*11+6], ('flags',i)
flags=[struct.unpack_from('<H',disk,56*i+50)[0] for i in range(total)]
meta=json.loads((r/'assets/maps/tt_navigation_grid.json').read_text())
assert meta['width']==width and meta['height']==height and meta['cellSize']==cell_size
assert all(abs(meta['min'][i]-minimum[i])<0.0001 for i in range(3))
prefix=(r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0].replace('u.mem_map(terrain,0x10000)','u.mem_map(terrain,0x300000)')
exec(compile(prefix,'native terrain prerequisites','exec'))
u.mem_write(cells,disk)
for offset,value in [(7,minimum[0]),(0xb,minimum[1]),(0xf,minimum[2]),(0x314,cell_size),(0x318,1./cell_size),(0x320,cell_size*.5)]:u.mem_write(terrain+offset,struct.pack('<f',value))
write32(terrain+0x30c,width);write32(terrain+0x310,height)
counts=heap+0x12000;pixels=heap+0x8000;pointer=heap+0x1fa00;n=128;extent=15398.671875
queries=[];returns=[]
def query_record(uc,address,size,user):
 if address==0x8f3390:
  top=uc.reg_read(UC_X86_REG_ESP);queries.append(list(struct.unpack('<3f',uc.mem_read(top+4,12))))
 if address in [0x8f3644,0x8f364f,0x8f3681]:returns.append(uc.reg_read(UC_X86_REG_EAX))
u.hook_add(unicorn.UC_HOOK_CODE,query_record)
indices=[]
for wanted,goal in [(False,[7700.,7000.]),(True,[7700.,7000.]),(False,[4000.,6000.]),(True,[10000.,8000.])]:
 choices=[i for i,f in enumerate(flags) if bool(f&1)==wanted and not f&2]
 assert choices
 indices.append(min(choices,key=lambda i:(minimum[0]+(i%width+.5)*cell_size-goal[0])**2+(minimum[2]+(i//width+.5)*cell_size-goal[1])**2))
cases=[]
for index in indices[:2]:
 center=[minimum[0]+(index%width+.5)*cell_size,minimum[2]+(index//width+.5)*cell_size]
 for radius in [200.,800.]:
  for percent,valid_owner in [(p,v) for p in [-0.5,0.,0.5] for v in [False,True]]:
   metric=64.;flat=50.
   queries.clear();returns.clear();u.mem_write(obj,bytes(0x80));write32(obj,0x10a03d0)
   for offset,value in [(4,center[0]),(8,center[1]),(0xc,radius),(0x14,metric),(0x18,1.),(0x1c,0.)]:u.mem_write(obj+offset,struct.pack('<f',value))
   native_owner=terrain+0x250000;owner_table=terrain+0x251000;owner_handle=0x12340002
   u.mem_write(native_owner,bytes(0x800));write32(native_owner,0x1090ea8);write32(native_owner+8,owner_handle);write32(native_owner+0x18,7 if valid_owner else 8)
   u.mem_write(native_owner+0x778,struct.pack('<2f',flat,percent));u.mem_write(owner_table,bytes(16));write32(owner_table+8,native_owner)
   write32(0x2d628c0,owner_table);write32(0x2d628c4,4);write32(obj+0x24,owner_handle);write32(obj+0x34,native_owner);write32(obj+0x30,7)
   write32(obj+0x40,bits);write32(obj+0x48,n*n//32);u.mem_write(obj+0x45,b'\x01');u.mem_write(obj+0x68,b'\x01');write32(pointer,counts)
   u.mem_write(bits,bytes(n*n//8));u.mem_write(counts,bytes(n*n));u.mem_write(pixels,bytes(n*n))
   write32(sp,end);write32(sp+4,n);u.mem_write(sp+8,struct.pack('<f',extent));write32(sp+12,pixels);write32(sp+16,pointer)
   u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
   u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
   u.emu_start(0x6b14e0,end,count=2000000);assert u.reg_read(UC_X86_REG_EIP)==end;assert len(queries)==len(returns)==1,(queries,returns)
   words=list(struct.unpack('<512I',u.mem_read(bits,n*n//8)));c=bytes(u.mem_read(counts,n*n));v=bytes(u.mem_read(pixels,n*n))
   for z in range(n):
    for x in range(n):
     i=z*n+x;chosen=bool(words[i//32]&(1<<(i%32)));assert c[i]==int(chosen);assert v[(n-1-z)*n+x]==(255 if chosen else 0)
   cases.append(dict(owner_percent=percent,owner_flat=flat,owner_valid=valid_owner,dimension=n,extent=extent,center=center,radius=radius,source_metric=metric,source_flag=bool(returns[0]),source_query=queries[0],rect=[read32(obj+o) for o in [0x4c,0x54,0x50,0x58]],words=words,selected_cells=sum(c),nav_cell_index=index))

assert 0x6b17e0 in visited and 0x717d10 in visited and 0x617f80 in visited
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,passed=True,native_sha256=digest,entry='0x6b14e0',source_query_entry='0x8f3390',original_instruction_addresses=len(visited),runtime_adapters=[],terrain=dict(source=str(nav_source),sha256=hashlib.sha256(nav_raw).hexdigest(),archived_copy_identical=True,version=[3,1,0],origin=minimum,maximum=maximum,width=width,height=height,cell_size=cell_size,disk_cells_offset=39,disk_cell_stride=56,flag_offset=50,heights_and_flags_byte_matches=total,flag_counts=dict(collections.Counter(flags))),cases=cases,limits=['Actual original Map10 cell bytes supplied to native runtime layout; original terrain constructor/deserializer itself is not executed.','Runtime inverse cell size and half-cell center supplied as 1/cell and cell/2; native provider initialization not yet traced.','World extent15398.671875 is supplied candidate from original map geometry; actual extent provider remains open.','Owned source with supplied native registry and modifier fields; actual actor state producers, cones, lifecycle and GPU binding remain open.','Native source query executes; no query return adapter used. This does not prove complete ordinary gameplay.'])
(r/'data/4.20/fow_map10_owned_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),cell_byte_matches=total,native_addresses=len(visited),source_sha256=proof['terrain']['sha256'],selected_cells=[c['selected_cells'] for c in cases],source_flags=[c['source_flag'] for c in cases])))
