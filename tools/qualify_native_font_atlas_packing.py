from pathlib import Path
import json,hashlib,datetime,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text().split('\nu.hook_add(')[0],'native atlas packing prerequisites','exec'))
atlas=vector+0x6000;texture=vector+0x7000;rows=vector+0x8000;row_arrays=vector+0x9000;nodes=vector+0xb000;heap=vector+0xd000
alloc_cursor=0
def hook(uc,a,size,user):
 global alloc_cursor
 if a==0x5cc6b0:
  assert uc.reg_read(UC_X86_REG_ECX)==1;address=heap+alloc_cursor*0x100;alloc_cursor+=1;assert alloc_cursor<=16;finish(address);return
 if a==0x5c13c0:
  owner=uc.reg_read(UC_X86_REG_ECX);assert read(owner+4)==read(owner+8);w(owner+8,read(owner)+0x100);finish(0,4);return
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def observed_rows():
 result=[]
 for row in range((read(atlas+0x18)-rows)//12):
  owner=rows+row*12;result.append([(read(p)-nodes)//0x40 for p in range(read(owner),read(owner+4),4)])
 return result
def expected_insert(model,cell,size):
 remaining=size;width,height=dimensions[cell]
 if width>size or height>size:return None
 for row_index,row in enumerate(model):
  if remaining<height:break
  free=size;maximum=0
  for index in row:
   if free<width:break
   w0,h0=dimensions[index];maximum=max(maximum,h0);free-=w0
  if free>=width:
   row.append(cell);return [size-free,size-remaining]
  remaining-=maximum
 if remaining<height:return None
 model.append([cell]);return [0,size-remaining]
cases=[]
for size in [256,512]:
 for profile in ['empty','partial','full','two_full','short_rows','uneven']:
  initial={'empty':[],'partial':[[(size-6,11)]],'full':[[(size,size)]],'two_full':[[(size,size//2)],[(size,size//2)]],'short_rows':[[(size,10)],[(size,15)]],'uneven':[[(size//2,10),(size//2,70)]]}[profile]
  alloc_cursor=0;calls.clear();u.mem_write(atlas,b'\0'*0x20);w(atlas+4,size);w(atlas+8,texture);w(atlas+0x14,rows);w(atlas+0x18,rows+len(initial)*12);w(atlas+0x1c,rows+32*12);w(texture+0x60,size);w(texture+0x64,size)
  dimensions=[];model=[]
  for row_index,source_row in enumerate(initial):
   row_list=[];row_data=row_arrays+row_index*0x100;owner=rows+row_index*12
   for col,(width,height) in enumerate(source_row):
    index=len(dimensions);dimensions.append((width,height));row_list.append(index);w(row_data+col*4,nodes+index*0x40);w(nodes+index*0x40+4,width);w(nodes+index*0x40+8,height)
   w(owner,row_data);w(owner+4,row_data+len(source_row)*4);w(owner+8,row_data+0x100);model.append(row_list)
  original_rows=[list(row) for row in model];steps=[]
  for width,height in [(8,12),(25,44),(100,12),(180,90),(60,22),(200,60),(size+1,1),(1,size+1),(size,size)]:
   index=len(dimensions);dimensions.append((width,height));node=nodes+index*0x40;u.mem_write(node,b'\0'*0x38);w(node+4,width);w(node+8,height);w(node+0x28,0x3f800000);w(node+0x2c,0x3f800000)
   expected=expected_insert(model,index,size);w(stack,end);w(stack+4,node);w(0,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,atlas);u.emu_start(0x8c01e0,end,count=20000)
   assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+8
   success=u.reg_read(UC_X86_REG_EAX)==0;assert success==(expected is not None);assert observed_rows()==model
   if success:assert [read(node+0x18),read(node+0x1c)]==expected and bytes(u.mem_read(node,1))==b'\1'
   else:assert bytes(u.mem_read(node,1))==b'\0'
   steps.append({'node_index':index,'width':width,'height':height,'success':success,'position':expected,'rows_after':[list(row) for row in model],'uv_bits':[read(node+off) for off in [0x20,0x24,0x28,0x2c]]})
  cases.append({'size':size,'profile':profile,'initial_rows':original_rows,'dimensions':[list(v) for v in dimensions],'steps':steps})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8c01e0','case_count':len(cases),'insertion_steps':sum(len(c['steps']) for c in cases),'native_addresses':len(visited),'cases':cases,'limits':['Original full placement function, row search, native vector append/move helpers and UV suffix execute. Heap supplier returns reserved storage and vector grow supplier expands supplied capacity in place; allocator, reallocation/copy/error lifetime not qualified.','Texture/atlas dimensions256/512 and node sizes supplied; sequences cover new/existing rows, exact-full, uneven heights and rejects. Original early width-exhaustion stops max-height scan; do not substitute a generic packing library.','No native GPU texture allocation/upload, dirty refresh rasterization, outline/shadow effects, complete text layout or widgets proof.']}
(r/'data/4.20/native_font_atlas_packing_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'insertion_steps':proof['insertion_steps'],'native_addresses':len(visited)}))
