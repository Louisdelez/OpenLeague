from pathlib import Path
import zipfile,json,hashlib,datetime,collections,shutil
r=Path('E:/OpenLeague');source=r/'data/4.20/archives/menu/HUD.zip';files=[];types=collections.Counter();textures=collections.Counter();all_elements=0
with zipfile.ZipFile(source) as z:
 lookup={i.filename.lower():i.filename for i in z.infolist()}
 listing=z.read('HUD/ShadowIslesElementsListNormal.ini');names=[line.strip() for line in listing.decode('ascii').splitlines() if line.strip()]
 for name in names:
  requested='HUD/Elements/'+name;path=lookup.get(requested.lower())
  if path is None:files.append(dict(requested=requested,available=False));continue
  data=z.read(path);records=[];record={};other=[]
  for line in data.decode('ascii').splitlines():
   line=line.strip()
   if not line or line.startswith('//'):continue
   if ':' not in line:other.append(line);continue
   key,value=line.split(':',1);key=key.strip();value=value.strip()
   if key=='Type' and record:records.append(record);record={}
   record.setdefault('_ordered_properties',[]).append([key,value])
   if key in record:record.setdefault('_duplicate_properties',[]).append([key,value])
   else:record[key]=value
  if record:records.append(record)
  base={k:v for k,v in records[0].items() if k=='BaseOffset'} if records else {}
  for record in records:
   if 'Type' in record:types[record['Type']]+=1;all_elements+=1
   if 'Texture' in record:textures[record['Texture']]+=1
  files.append(dict(requested=requested,path=path,available=True,bytes=len(data),sha256=hashlib.sha256(data).hexdigest(),base=base,records=records,unparsed_lines=other))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,native_parser_qualified=False,source_archive_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),profile='ShadowIsles',orientation='Normal',list_path='HUD/ShadowIslesElementsListNormal.ini',list_sha256=hashlib.sha256(listing).hexdigest(),file_count=len(files),element_count=all_elements,types=dict(types),texture_names=dict(textures),files=files,limits=['Source inventory only; colon records are an audit view, not a qualified replacement of the native HUD parser.','Profile selection, base/anchor/scale/window transforms, runtime visibility, widget bindings, texture sampling and interactions remain open.'])
(r/'data/4.20/native_hud_layout_source_audit.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(files=len(files),available=sum(f['available'] for f in files),elements=all_elements,types=dict(types),unparsed=sum(len(f.get('unparsed_lines',[])) for f in files))))
