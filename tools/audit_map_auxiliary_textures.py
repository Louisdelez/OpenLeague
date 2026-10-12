exec(__import__('pathlib').Path(__file__).with_name('audit_current_map_textures.py').read_text(encoding='utf-8').split('proof=')[0])
# Candidates are restricted to actual Map10 scene/prop directories and TT particles.
deploy=native_path.parents[3]
candidate_paths=set((native_path.parent/'Textures').glob('*.dds'))
characters=deploy/'DATA/Characters'
for folder in characters.iterdir():
 if folder.is_dir() and folder.name.lower().startswith('tt_'):candidate_paths.update(folder.rglob('*.dds'))
for folder in (deploy/'DATA/Particles',native_path.parent):
 candidate_paths.update(p for p in folder.glob('*.dds') if p.stem.lower().startswith('tt_') or 'fire_sprite' in p.stem.lower())
by_pixels={};decode_errors=[]
for path in sorted(candidate_paths):
 try:
  data=path.read_bytes();im=Image.open(io.BytesIO(data)).convert('RGBA');im.load();key=(im.size,sha(im.tobytes()));by_pixels.setdefault(key,[]).append({'path':str(path),'sha256':sha(data)})
 except Exception as e:decode_errors.append({'path':str(path),'error':str(e)})
aux=[]
for entry in other:
 image=images[entry['image']];matches=by_pixels.get((image.size,sha(image.tobytes())),[]);aux.append(dict(entry,original_pixel_matches=matches))
terrain=__import__('json').loads((r/'docs/terrain_native_source_validation.json').read_text(encoding='utf-8-sig'));terrain_checks=[]
for asset,entry in terrain['textures'].items():
 png=r/'assets'/asset;source=Path(entry['native']);im=Image.open(png).convert('RGBA');original=Image.open(source).convert('RGBA');equal=im.size==original.size and im.tobytes()==original.tobytes();assert equal,asset
 terrain_checks.append({'asset':asset,'source':str(source),'pixels_equal':equal,'source_sha256':sha(source.read_bytes()),'png_sha256':sha(png.read_bytes())})
proof={'complete':False,'updated_utc':datetime.now(timezone.utc).isoformat(),'map_sha256':sha(raw),'candidate_count':len(candidate_paths),'candidate_decode_errors':decode_errors,'auxiliary_materials':aux,'auxiliary_with_original_pixel_match':sum(bool(e['original_pixel_matches']) for e in aux),'unmatched_auxiliary_materials':[e for e in aux if not e['original_pixel_matches']],'terrain_shader_textures':terrain_checks,'limits':['Pixel match proves image content, not original material/skin ownership or shader/gamma equivalence. Multiple native files with identical pixels retained as candidates.','TT character and particle candidates only; unmatched auxiliary images are not assumed missing, corrupt or reconstructed without further provenance.','Composited4096-square GLB terrain fallback is not the runtime height-blend source; original runtime layers/height/color maps checked separately.']}
(r/'docs/current_map_auxiliary_texture_audit.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'candidate_count':len(candidate_paths),'auxiliary_matches':proof['auxiliary_with_original_pixel_match'],'auxiliary_materials':len(aux),'terrain_textures':len(terrain_checks),'unmatched':[e['name'] for e in proof['unmatched_auxiliary_materials']]}))
