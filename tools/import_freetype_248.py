from pathlib import Path
import urllib.request,hashlib,tarfile,io,json,datetime,shutil
r=Path('E:/OpenLeague');target=r/'third_party/freetype-2.4.8';archive=r/'tools/downloads/freetype-VER-2-4-8.tar.gz';url='https://codeload.github.com/freetype/freetype/tar.gz/refs/tags/VER-2-4-8'
archive.parent.mkdir(parents=True,exist_ok=True)
if archive.exists():raw=archive.read_bytes()
else:
 with urllib.request.urlopen(url,timeout=60) as response:raw=response.read()
 archive.write_bytes(raw)
count=0
with tarfile.open(fileobj=io.BytesIO(raw),mode='r:gz') as tar:
 for member in tar.getmembers():
  prefix='freetype-VER-2-4-8/';assert member.name.startswith(prefix) or member.name=='freetype-VER-2-4-8'
  relative=member.name[len(prefix):] if member.name.startswith(prefix) else ''
  if not relative:continue
  path=target/relative;assert path.resolve().is_relative_to(target.resolve())
  if member.isdir():path.mkdir(parents=True,exist_ok=True)
  elif member.isfile():
   data=tar.extractfile(member).read();path.parent.mkdir(parents=True,exist_ok=True)
   if path.exists():assert path.read_bytes()==data
   else:path.write_bytes(data)
   count+=1
  else:raise ValueError('Unexpected archive link/type')
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,source=url,source_tag='VER-2-4-8',archive=str(archive.relative_to(r)),archive_sha256=hashlib.sha256(raw).hexdigest(),source_directory=str(target.relative_to(r)),file_count=count,native_version_contract='data/4.20/native_freetype_version_contract.json',license_files=[str(p.relative_to(r)) for p in target.glob('docs/*') if 'LICENSE' in p.name or 'FTL' in p.name or 'GPL' in p.name],native_compile_options_or_patches_verified=False,native_glyph_fidelity_verified=False)
(r/'docs/freetype_248_source_import.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
destination=r/'tools'/Path(__file__).name
if destination.resolve()!=Path(__file__).resolve():shutil.copy2(Path(__file__),destination)
print(json.dumps(proof))
