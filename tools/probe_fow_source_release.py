from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_fow_circle_factory.py').read_text().split('cases=[]')[0]
exec(compile(prefix,'native circle factory prerequisites','exec'))
u.mem_map(0x40000000,0x10000);view=0x40000000;view_control=0x40001000;event_control=0x40002000;counts=0x40003000;pixels=0x40004000;bits=0x40005000
head=heap+0x18100;node=heap+0x18200;event_body=heap+0x18300;event_list=heap+0x18400;subscriber=heap+0x18500;promoted=heap+0x18700
frees=[];events=[]
def os_boundary(uc,a,size,user):
 if a==0xc98528:
  pointer=read32(u.reg_read(UC_X86_REG_ESP)+4);frees.append(pointer);events.append(dict(kind='free',pointer=pointer));finish()
 elif a in [0x9941b0,0x994210]:finish()
 elif a==0x6b48bb:events.append(dict(kind='callback',strong=read32(source_control+4),applied=bool(u.mem_read(source_object+0x44,1)[0])))
u.hook_add(unicorn.UC_HOOK_CODE,os_boundary)
def invoke(entry,this,args=b''):
 write32(sp,end);u.mem_write(sp+4,args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(entry,end,count=200000);assert u.reg_read(UC_X86_REG_EIP)==end
cases=[]
for observer,applied,initial in itertools.product([False,True],[False,True],[0,1,2]):
 allocation_cursor=heap+0x19000;events.clear();frees.clear();u.mem_write(manager,bytes(0x40));u.mem_write(entries,bytes(16));u.mem_write(output,bytes(8))
 write32(manager+4,entries);write32(manager+8,entries);write32(manager+0xc,entries+16)
 for pointer,size in [(head,0x40),(node,0x40),(event_body,0x30),(event_list,0x30),(subscriber,0x20),(view,0x100),(view_control,16),(event_control,16)]:u.mem_write(pointer,bytes(size))
 u.mem_write(head+0xd,bytes([1]));write32(head+4,node if observer else head);write32(manager+0x1c,head);write32(0x2d5f468,77)
 if observer:
  write32(node,head);write32(node+8,head);write32(node+0x10,77);write32(node+0x14,event_body)
  write32(event_body+0xc,event_list);write32(event_body+0x10,event_control);write32(event_control+4,10);write32(event_control+8,10)
  write32(view,0x10a0330);write32(view+4,view);write32(view+8,view_control);write32(view_control+4,10);write32(view_control+8,10)
  invoke(0x68cf70,subscriber,struct.pack('<4I',view,0,0x669d81,0));write32(event_list,subscriber);write32(event_list+4,subscriber+20);write32(event_list+8,subscriber+20)
 u.mem_write(counts,bytes([initial])*64);u.mem_write(pixels,bytes([90])*64);u.mem_write(bits,struct.pack('<2I',0x55555555,0x55555555))
 write32(view+0x10,8);write32(view+0x14,counts);write32(view+0x18,pixels)
 args=struct.pack('<5IfI5f',output,0,55,66,100,200.,0,128.,64.,0.,128.,128.)
 invoke(0x6b1b20,manager,args);source_object=read32(output);source_control=read32(output+4)
 write32(source_object+0x40,bits);u.mem_write(source_object+0x44,bytes([applied]))
 for offset,value in [(0xc,1),(0x10,5),(0x14,2),(0x18,6)]:write32(source_object+0x40+offset,value)
 before_counts=(read32(source_control+4),read32(source_control+8));invoke(0x6b1f90,manager,struct.pack('<I',entries))
 after_counts=(read32(source_control+4),read32(source_control+8));assert read32(manager+8)==entries and source_object in frees
 invoke(0x5bd6f0,output,struct.pack('<I',promoted));assert read32(promoted)==0 and read32(promoted+4)==0
 c=bytes(u.mem_read(counts,64));p=bytes(u.mem_read(pixels,64));changes=[]
 for z in range(8):
  for x in range(8):
   i=z*8+x;o=(7-z)*8+x;inside=1<=x<5 and 2<=z<6;expected=max(0,initial-1) if observer and applied and inside and i%2==0 else initial
   assert c[i]==expected and p[o]==((255 if expected else 0) if observer and applied and inside else 90)
   changes.append(dict(index=i,texture_index=o,count=c[i],visibility=p[o]))
 trace=[{'kind':e['kind'],**({'strong':e['strong'],'applied':e['applied']} if e['kind']=='callback' else {'source':e['pointer']==source_object,'control':e['pointer']==source_control})} for e in events]
 cases.append(dict(observer=observer,initial_applied=applied,initial_count=initial,before_strong=before_counts[0],before_weak=before_counts[1],after_strong=after_counts[0],after_weak=after_counts[1],manager_source_count=(read32(manager+8)-read32(manager+4))//8,weak_expired=True,source_freed=True,applied_after=bool(u.mem_read(source_object+0x44,1)[0]),trace=trace,changes=changes))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b1f90',factory='0x6b1b20',event_dispatch='0x64e8d0',subscriber_constructor='0x68cf70',view_callback='0x6b4860',native_addresses=len(visited-{0xc9f39b,0x9933e0,0xc98528,0x9941b0,0x994210,0xc975f5}),runtime_adapters=['C9F39B/9933E0 allocate supplied storage; C98528 records deallocation requests without unmapping emulator memory.','9941B0/994210 mutex boundaries are no-ops in this single-thread probe; C975F5 cookie boundary adapted if visited.'],cases=cases,limits=['Complete original circular creation/removal, synchronous event dispatch, original subscriber callback/count rollback, source destructor and weak expiration execute; allocator/mutex OS boundaries adapted.','Event tree, receiver/shared controls and empty pending-source heap supplied, not created through complete view initialization/registration. Only one source and one observer exercised.','No gameplay source creation callers/team field producers, non-null weak provider, cone source, live GPU or current graphical verification qualified.'])
(r/'data/4.20/fow_source_release_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],first=cases[0])))
