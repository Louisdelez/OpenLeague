from pathlib import Path
import struct,json,datetime
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_fow_source_release.py').read_text(encoding='utf-8').split('\ncases=[]')[0];exec(compile(prefix,'native FoW prerequisites','exec'))
wrapper=heap+0x18000;renderer=wrapper+0x100;vtable=wrapper+0x200;calls=[]
write32(0x2d79078,wrapper);write32(wrapper+0x14,renderer);write32(renderer,vtable);write32(vtable+0x8c,0x9763d0)
def upload(uc,a,size,user):
 if a!=0x9763d0:return
 top=u.reg_read(UC_X86_REG_ESP);register=read32(top+4);ptr=read32(top+8);count=read32(top+12)
 assert u.reg_read(UC_X86_REG_ECX)==renderer and count==1
 calls.append({'register':register,'count':count,'bits':list(struct.unpack('<4I',u.mem_read(ptr,16))),'values':list(struct.unpack('<4f',u.mem_read(ptr,16)))})
 ret=read32(top);u.reg_write(UC_X86_REG_EAX,0);u.reg_write(UC_X86_REG_ESP,top+16);u.reg_write(UC_X86_REG_EIP,ret)
u.hook_add(unicorn.UC_HOOK_CODE,upload);cases=[]
for name,start,finish in [('map10',-1000000.,-2000000.),('diagnostic-positive',10.,20.),('diagnostic-fractional',.25,.75)]:
 calls.clear();u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 u.mem_write(0x1223eb8,struct.pack('<f',start));u.mem_write(0x1223eb4,struct.pack('<f',finish))
 u.emu_start(0x6b399f,0x6b3a3e,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x6b3a3e and len(calls)==2
 assert calls[0]['register']==250 and calls[0]['bits']==[0,0xc47a0000,0x3c23d70a,0x41200000]
 assert calls[1]['register']==251
 cases.append({'name':name,'fade_start':start,'fade_finish':finish,'uploads':list(calls)})
proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'entry':'0x6b399f..0x6b3a3e','native_addresses':len({a for a in visited if 0x6b399f<=a<0x6b3a3e}),'cases':cases,'finding':'c250 unconditionally uploads [0,-1000,0.01,10], followed by configured c251. Native below-height factor saturate(worldY*0.01+10) is1 at worldY>=-900.','limits':['Original coefficient stores and c251 SSE computation executed; supplied renderer/vtable captures uploads, actual D3D not executed.','Earlier renderer backend selection, full initialization and material variant routing remain separate open contracts.']}
(r/'data/4.20/fow_below_height_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
