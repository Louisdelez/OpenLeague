from pathlib import Path
import json,struct,hashlib,datetime,shutil
r=Path('E:/OpenLeague');p=json.loads((r/'data/4.20/native_cloud_opacity_contract.json').read_text(encoding='utf-8'))
source=Path(p['texture_source']);dds=source.read_bytes();asset=r/'assets/maps/terrain_native/cloudOpacityMap.ktx2';ktx=asset.read_bytes()
assert dds[:4]==b'DDS ' and dds[84:88]==b'DXT1'
assert ktx[:12]==b'\xabKTX 20\xbb\r\n\x1a\n'
fmt,type_size,width,height,depth,layers,faces,count,compression=struct.unpack_from('<9I',ktx,12)
assert (fmt,type_size,width,height,depth,layers,faces,count,compression)==(133,1,1024,1024,0,0,1,11,0)
offset=128;levels=[]
for i in range(count):
 w=max(1,width>>i);h=max(1,height>>i);size=((w+3)//4)*((h+3)//4)*8
 dest,length,uncompressed=struct.unpack_from('<3Q',ktx,80+i*24)
 assert length==uncompressed==size and dest%8==0
 assert dds[offset:offset+size]==ktx[dest:dest+size]
 levels.append(dict(level=i,width=w,height=h,block_bytes=size,source_offset=offset,asset_offset=dest,sha256=hashlib.sha256(dds[offset:offset+size]).hexdigest(),byte_exact=True));offset+=size
assert offset==len(dds)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,source=str(source),source_sha256=hashlib.sha256(dds).hexdigest(),asset='assets/maps/terrain_native/cloudOpacityMap.ktx2',asset_sha256=hashlib.sha256(ktx).hexdigest(),format='BC1_RGBA_UNORM (DXT1)',levels=levels,mip_count=11,recompressed=False,bevy_loader_verified=True,
 validation='Rust helper constructs KTX2 via local ktx2 crate; Reader validates descriptor and levels; Bevy ktx2_buffer_to_image verifies11mips and byte-exact concatenated GPU data.',
 limits=['Original texture producer and its mip creation/loading flags remain unqualified.','This preserves source blocks; physical GPU filtering, original sampler frame state and numeric shader fidelity remain separate requirements.'])
(r/'data/4.20/native_cloud_mip_chain_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2('E:/mapslol3v3/convert_cloud_mip_chain.rs',r/'tools/convert_cloud_mip_chain.rs');shutil.copy2('E:/mapslol3v3/qualify_cloud_mip_chain.py',r/'tools/qualify_cloud_mip_chain.py')
print(json.dumps(dict(mip_count=11,byte_exact=True,bevy_loader_verified=True,asset_sha256=proof['asset_sha256'])))
