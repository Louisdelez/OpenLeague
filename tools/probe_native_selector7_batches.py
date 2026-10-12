from pathlib import Path
source=Path('E:/mapslol3v3/probe_native_material_draw_state.py').read_text(encoding='utf-8').split('def hook')[0]
exec(compile(source,__file__,'exec'))
driver=arena+0x8000;driver_vt=arena+0x9000;owner=arena+0xa000;table=arena+0xb000;buffers=arena+0xc000;rows=arena+0x10000;draws=[];adapters=[]
def hook(uc,a,size,user):
 if a==end:uc.emu_stop();return
 if a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);receiver,state,value=struct.unpack('<3I',u.mem_read(sp+4,12));assert receiver==device;calls.append([state,value]);finish(12);return
 if arena+0xd000<=a<arena+0xd100:
  slot=a-(arena+0xd000);argc={0x20:6,0x58:1,0x3c:4,0x50:1,0x70:3,0x8c:3}[slot];assert u.reg_read(UC_X86_REG_ECX)==driver
  if slot==0x20:
   bits=read(0x123ff20);secondary=read(0x123ff60);args=struct.unpack('<6I',u.mem_read(u.reg_read(UC_X86_REG_ESP)+4,24));draws.append({'args':list(args),'alpha_enabled':bool(bits&0x4000000),'depth_enabled':bool(bits&0x1000000),'depth_write':bool(secondary&0x10000000),'color_write':secondary&15,'blend_enabled':bool(bits&0x8000000),'comparison':read(0x123ff40),'reference_bits':read(0x123ff44)})
  u.reg_write(UC_X86_REG_EAX,0);finish(argc*4);return
 if a in [0xc975f5,0x5f6620,0x8df580,0x8de480]:adapters.append(hex(a));finish();return
 if a==0x8de500:adapters.append(hex(a));finish(4);return
 if a==0x8deba0:adapters.append(hex(a));u.reg_write(UC_X86_REG_ECX,arena+0xe000);finish();return
 if a==0x95a730:adapters.append(hex(a));finish(4);return
 if a==0x98af00:u.reg_write(UC_X86_REG_EAX,0);finish();return
 assert (0x95ad40<=a<0x95b3c2 or 0x9836a0<=a<0x9838fe or 0x9abc90<=a<0x9ac340 or 0x9ac500<=a<0x9ac7c0),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(device,vt);w(vt+0xe4,callback);w(0x2d794b0,device);w(0x2d79078,manager);w(manager+0x14,driver);w(driver,driver_vt)
for slot in [0x20,0x58,0x3c,0x50,0x70,0x8c]:w(driver_vt+slot,arena+0xd000+slot)
u.mem_write(0x2d79470,b'\0');u.mem_write(0x14be79f,b'\0');w(0x14bef88,0)
cases=[]
for count,merge,material_cached,buffers_cached,initial_alpha,side in itertools.product([1,2,3],[False,True],[False,True],[False,True],[False,True],[0,1]):
 u.mem_write(context,b'\0'*0x100);w(context+0x34,rows);w(context+0x38,rows+count*40);w(context+0x54,7);w(context+0x5c,0xffffffff);w(context+0x6c,0 if material_cached else 0xffffffff)
 for offset in [0x60,0x64,0x68]:w(context+offset,0 if buffers_cached else 0xffffffff)
 u.mem_write(context+0x71,bytes([not merge]));u.mem_write(context+0x72,bytes([side]));w(material+0x104,0);w(material+0x108,20);w(owner+0x1c,table);w(owner+0x20,table+4);w(table,material)
 for offset in [0x28,0x34]:w(owner+offset,buffers)
 for offset in [0x2c,0x38]:w(owner+offset,buffers+4)
 w(buffers,arena+0xf000)
 for index in range(count):u.mem_write(rows+index*40,struct.pack('<10I',0,0,0,index*3,3,index*3,1,0,0,side))
 w(0x123ff20,0x4000000 if initial_alpha else 0);w(0x123ff60,15)
 for address in [0x123ff40,0x123ff44,*range(0x123ff48,0x123ff5c,4)]:w(address,0xffffffff)
 w(stack,end);w(stack+4,owner);w(stack+8,0);w(stack+12,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,context);calls=[];draws=[];adapters=[];u.emu_start(0x95b140,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert len(draws)==count+(1 if merge else count),(count,merge,draws)
 for draw in draws[:count]:assert draw['alpha_enabled'] and draw['depth_enabled'] and draw['depth_write'] and draw['color_write']==0 and not draw['blend_enabled'];assert draw['comparison']==4 and draw['reference_bits']==struct.unpack('<I',struct.pack('<f',0.9))[0]
 for draw in draws[count:]:assert not draw['alpha_enabled'] and draw['depth_enabled'] and not draw['depth_write'] and draw['color_write']==15 and draw['blend_enabled']
 cases.append({'batch_count':count,'merge':merge,'material_cached':material_cached,'buffers_cached':buffers_cached,'initial_alpha':initial_alpha,'double_sided':side,'draws':draws.copy(),'adapter_calls':sorted(set(adapters))})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x95b140','native_addresses':len(visited),'cases':cases,'findings':['Nonempty selector7 batches execute first depth-only native draws with alphaGREATER reference0.9, color-write0, depth-write1, blend0; then native merged/unmerged blended draws with alpha disabled, color-write15, depth-write0, blend1.','Native95AFC0 preserves first-phase state because argument3=0 skips material-state update; second phase calls with argument3=1.','Batch merging affects only second-phase draw count under tested contiguous geometry.'],'runtime_adapters':['Actual95B140/95B300/95AFC0/material-state routing and setters execute. Abstract renderer calls record draw-time state and buffer/constant binding; no original D3D pixels rendered.','Matrix helpers, profiling, security cookie and shader-binding helper adapted without changing render-state globals. Backend98AF00 suppliedD3Dfalse. Shader/sampler/internal device implementations remain separate scopes.'],'limits':['Original vertex/shader transforms, full scene sort/queue, actual buffers/device and native pixels not qualified.','Fixture type0flags20, selector7, 1..3contiguous rows, merge/cache/side/alpha combinations only.','Current client depth-only and alpha-disabled two-phase route remains to integrate.']}
(r/'data/4.20/selector7_batches_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'native_draws':sum(len(c['draws']) for c in cases),'passed':True}))
