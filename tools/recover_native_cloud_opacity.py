from pathlib import Path
import json,struct,hashlib,datetime,sys,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
prefix=(r/'tools/probe_native_inibin_loader.py').read_text(encoding='utf-8').split('\nqueries=[]')[0]
prefix=prefix.replace('terrain.inibin','clouds.inibin').replace('terrain.ini','clouds.ini')
exec(compile(prefix,'native clouds config loader','exec'))
native_code_ranges.extend([(0x73a5d1,0x73a678),(0x8b1f50,0x8b2026),(0x8e51a0,0x8e5300)])
pair=0x40009b00;write32(pair,config);write32(pair+4,0);write32(0x2d83fb8,1)
stub=end+0x700;cell=end+0x800;u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',cell)+b'\xc3');native_code_ranges.append((stub,stub+7));requests=[];conversions=[]
def boundary(uc,a,size,user):
 if a==0x8acef0:
  top=uc.reg_read(UC_X86_REG_ESP);path=text(read32(top+4));flag=read32(top+8);assert path.lower()=='levels/map10/clouds.ini' and flag==0
  requests.append(dict(path=path,flag=flag));returned(pair,8)
 elif a==0xc99987:
  top=uc.reg_read(UC_X86_REG_ESP);s=text(read32(top+4));value=float(s);conversions.append(dict(text=s,value=value));u.mem_write(cell,struct.pack('<f',value));uc.reg_write(UC_X86_REG_EIP,stub)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
filename=0x40009c00;u.mem_write(filename,bytes(24));write32(filename,path_buffer);write32(filename+0x10,23);write32(filename+0x14,31)
frame=stack+0x8000;u.mem_write(frame-0x80,bytes(0x100));u.mem_write(frame-0x28,b'Clouds\0');write32(frame-0x18,6);write32(frame-0x14,15)
u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,frame-0x60);u.reg_write(UC_X86_REG_ESI,filename)
u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
u.emu_start(0x73a5d1,0x73a678,count=20000);assert u.reg_read(UC_X86_REG_EIP)==0x73a678
params={name:struct.unpack('<f',u.mem_read(addr,4))[0] for name,addr in [('Tile',0x14be7e0),('SpeedU',0x14be7d8),('SpeedV',0x14be7dc)]}
parsed=parser['ini'](source)
for name,value in params.items():
 expected=float(parsed[str(parser['hashkey']('Clouds',name))])
 assert struct.pack('<f',value)==struct.pack('<f',expected)
texture_name=parsed[str(parser['hashkey']('Clouds','Texture'))];assert texture_name=='Cloud2.tga'
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');from PIL import Image
dds=source.parent.parent.parent/'DATA/Images/Clouds/Cloud2.DDS';assert dds.exists()
im=Image.open(dds).convert('RGBA');out=r/'assets/maps/terrain_native/cloudOpacityMap.png';assert not out.exists()
im.save(out);saved=Image.open(out).convert('RGBA');assert im.size==saved.size and im.tobytes()==saved.tobytes()
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,
 source=str(source),source_sha256=hashlib.sha256(contents).hexdigest(),consumer_start='0x73a5d1',consumer_stop='0x73a678',parameters=params,config_requests=requests,crt_conversions=conversions,
 texture_config_name=texture_name,texture_source=str(dds),texture_source_sha256=hashlib.sha256(dds.read_bytes()).hexdigest(),texture_asset='maps/terrain_native/cloudOpacityMap.png',texture_asset_sha256=hashlib.sha256(out.read_bytes()).hexdigest(),dimensions=im.size,rgba_pixels_exact=True,
 adapters=['Native binary INIBIN loader and typed/high-level float getters execute. File/cache/thread/allocator/cookie boundaries supplied.',
 'Entered actual consumer after filename/section construction, supplied Clouds std::string; stopped before native texture string/load consumer.',
 'CRT atof observed2000 ASCII string adapted to Python numeric conversion plus x87 FLD/RET.'],
 limits=['Texture field decoded by reference parser; native texture string getter/path extension/resource loader not executed.','DDS decompression and PNG conversion verified byte-for-byte in Pillow output, not against native D3D decompression.','Cloud time/UV phase producer, sampler and native macro merging/GPU bind remain open. Texture recovered but runtime cloud/high fog not integrated.'])
(r/'data/4.20/native_cloud_opacity_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(parameters=params,dimensions=im.size,rgba_pixels_exact=True,asset=str(out))))
