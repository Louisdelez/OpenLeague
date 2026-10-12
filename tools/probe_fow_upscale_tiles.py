from pathlib import Path
import json,datetime,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
frame=sp+0x100; source=heap+0x8000; output=heap+0x12000; cases=[]
table=bytes(u.mem_read(0x10a0230,256))
for dim,pattern,low,high in [(2,p,128,129) for p in range(16)]+[(d,p,0,255) for d in [3,8] for p in [0,1,2,3]]:
 pitch=dim*4+7; size=pitch*dim*4
 if dim==2: values=bytes(high if pattern&(1<<i) else low for i in range(4))
 else: values=bytes(high if (pattern==1 or pattern==2 and i%2==0 or pattern==3 and i//dim%2==0) else low for i in range(dim*dim))
 u.mem_write(source,values);u.mem_write(output,bytes([90])*size)
 for off,val in [(-0x10,source),(-8,output),(-0x28,pitch),(-0x1c,dim)]:write32(frame+off,val)
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,frame-0x48);u.reg_write(UC_X86_REG_EDI,dim);u.reg_write(UC_X86_REG_EBX,pitch);u.reg_write(UC_X86_REG_ECX,output)
 u.emu_start(0x6b5117,0x6b5208,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x6b5208
 actual=bytes(u.mem_read(output,size));expected=bytearray([90])*size
 for y in range(dim-1):
  for x in range(dim-1):
   code=sum((values[(y+dy)*dim+x+dx]>128)<<bit for bit,(dx,dy) in enumerate([(0,0),(1,0),(0,1),(1,1)]))
   tile=table[code*16:code*16+16]
   for ty in range(4):
    index=(2+y*4+ty)*pitch+2+x*4;expected[index:index+4]=tile[ty*4:ty*4+4]
 assert actual==expected,(dim,pattern)
 cases.append({'dimension':dim,'pattern':pattern,'low':low,'high':high,'pitch':pitch,'source':list(values),'output':list(actual),'passed':True})
receipt={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6b5117','stop':'0x6b5208','original_instruction_addresses':len(visited),'runtime_adapters':[],'lookup_address':'0x10a0230','lookup_table':list(table),'cases':cases,'limits':['Original inner tile loop executed with supplied valid frame and buffer prerequisites.','Texture lock/upload, four boundary-row copies and left/right boundary replication are not executed; full upscaler integration remains open.']}
(r/'data/4.20/fow_upscale_tiles_contract.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'passed':True,'native_addresses':len(visited),'complete':False}))
