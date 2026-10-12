from pathlib import Path
import re,struct,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'native font shader inspection','exec'))
native=Path(source);folder=native.parent/'DATA/Shaders/HLSL/RenderGlyph';archived=[];descriptors=[]
def string(address):
 if not base<=address<base+len(image):return None
 data=image[address-base:address-base+500].split(b'\0')[0]
 return data.decode('ascii') if data and all(32<=x<=126 for x in data) else None
for path in sorted(folder.iterdir()):
 if not path.is_file():continue
 target=r/'data/4.20/shaders/RenderGlyph'/path.name;target.parent.mkdir(parents=True,exist_ok=True)
 if target.exists():assert target.read_bytes()==path.read_bytes()
 else:shutil.copy2(path,target)
 archived.append({'source':str(path),'archive':str(target.relative_to(r)).replace('\\','/'),'bytes':path.stat().st_size,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
for match in re.finditer(rb'RenderGlyph_[A-Z_]+\x00',image):
 address=base+match.start();name=match.group()[:-1].decode('ascii')
 suffix=name.removeprefix('RenderGlyph_');path='RenderGlyph/'+suffix+('.ps_2_0' if suffix.startswith('PS_') else '.vs_2_0')
 encoded=path.encode()+b'\0';source_offset=image.find(encoded);assert source_offset>=0;source_address=base+source_offset
 refs=lambda pointer:[hex(base+m.start()) for m in re.finditer(re.escape(struct.pack('<I',pointer)),image)]
 descriptors.append({'name':name,'native_name_address':hex(address),'native_source_address':hex(source_address),'name_pointer_references':refs(address),'source_pointer_references':refs(source_address),'source':path,'source_sha256':hashlib.sha256((native.parent/'DATA/Shaders/HLSL'/path).read_bytes()).hexdigest()})
assert len(archived)==8 and len(descriptors)==4
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'static_discovery_only':True,'native_sha256':hashlib.sha256(native.read_bytes()).hexdigest(),'descriptor_count':len(descriptors),'archived_file_count':len(archived),'descriptors':descriptors,'artifacts':archived,'source_findings':['Fill/outline PS uses font texel.r for fill and texel.b for outline; fill also samples second texture RGB/alpha.','Output RGB is alpha_fill*color_fill + alpha_outline*color_outline; output alpha is1-(alpha_fill+alpha_outline). Blend state consumer must be qualified before integration.','Glow PS uses font texel.x and color alpha; outputs unmodified color RGB.','VS fill/outline transforms float3 position with column-major pMtx(c4) and forwards two colors/two UVs; native color swizzle depends on compiler macros.'],'limits':['Files copied byte-for-byte, original compiled binaries preserved. Static descriptor/source linkage is not executed shader registration, compiler macro, blend state, GPU or HUD proof.','CPU atlas byte0/byte2 channel interpretation still requires actual native texture format mapping. Secondary/glow atlas generation and sampling remain open.']}
(r/'data/4.20/native_font_shader_catalog.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/recover_native_font_shaders.py'),r/'tools/recover_native_font_shaders.py')
print(json.dumps({'descriptors':len(descriptors),'files':len(archived),'gpu_qualified':False}))
