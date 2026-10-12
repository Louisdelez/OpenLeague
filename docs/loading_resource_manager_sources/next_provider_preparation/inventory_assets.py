"""Read-only real Ahri/Annie input inventory; no native provider result supplied."""
from pathlib import Path
import sys, importlib.util, json, hashlib, struct, os, zipfile
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent
ROOT=Path('E:/OpenLeague')
DATA=ROOT/'data/4.20'
DEPLOY=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy')
PARSER=ROOT/'tools/references/lolpytools/lolpytools_inibin2.py'
spec=importlib.util.spec_from_file_location('inibin',PARSER);parser=importlib.util.module_from_spec(spec);spec.loader.exec_module(parser)
def hashed(p):
    b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
rows=[]
for champion in ['Ahri','Annie']:
    folder=DEPLOY/'DATA/Characters'/champion
    selected=[folder/(champion+'.inibin')]
    for skin in sorted((folder/'Skins').iterdir()):
        if not skin.is_dir():continue
        selected += [p for p in skin.iterdir() if p.suffix.lower()=='.inibin' or 'loadscreen' in p.name.lower()]
    for p in selected:
        if not p.is_file():continue
        item=hashed(p);item.update(champion=champion,relative_path=p.relative_to(DEPLOY).as_posix())
        b=p.read_bytes()
        if p.suffix.lower()=='.dds':
            assert b[:4]==b'DDS ' and len(b)>=128
            item['dds_header']={'height':struct.unpack_from('<I',b,12)[0],'width':struct.unpack_from('<I',b,16)[0],
                'mipmaps':struct.unpack_from('<I',b,28)[0],'fourcc':b[84:88].decode('ascii')}
        elif p.suffix.lower()=='.inibin':
            config=parser.from_file(str(p));values=config['UNKNOWN_HASHES'];fallback_hash=parser.ihash('Package','FallbackPackage')
            item['community_parser_only']={'version':b[0],'flags':struct.unpack_from('<H',b,3)[0],
                'entry_count':len(values),'fallback_package_hash':fallback_hash,
                'fallback_package_present':fallback_hash in values,'fallback_package':values.get(fallback_hash),
                'loadscreen_string_values':{str(k):v for k,v in values.items() if isinstance(v,str) and 'loadscreen' in v.lower()}}
        rows.append(item)
names={Path(r['path']).name.lower() for r in rows}
loose=[]
for scope in [ROOT/'assets',DATA]:
    for folder,dirs,files in os.walk(scope):
        for name in files:
            if name.lower() in names:
                p=Path(folder)/name
                # Shared filenames Base.inibin/Skin01.inibin are only relevant in matching champion directories.
                if 'loadscreen' in name.lower() or any(c in str(p).lower() for c in ['ahri','annie']):loose.append(hashed(p))
global_manifest=DATA/'recovered_global_resource_manifest.json'
catalog=json.loads(global_manifest.read_text())
catalog_rows=[r for r in catalog['files'] if any('/'+c+'/' in ('/'+r[0]+'/').lower() for c in ['ahri','annie'])
    and (r[1].lower() in names or 'loadscreen' in r[1].lower())]
zip_catalog=DATA/'native_zip_catalog.json';archives=[]
for archive in json.loads(zip_catalog.read_text())['archives']:
    p=ROOT/archive['path']
    with zipfile.ZipFile(p) as z:
        matches=[n for n in z.namelist() if ('ahri' in n.lower() or 'annie' in n.lower()) and ('loadscreen' in n.lower() or n.lower().endswith('.inibin'))]
    archives.append({'path':str(p),'matches':matches})
portraits=json.loads((DATA/'native_champion_portraits.json').read_text())
result={'complete':False,'files':rows,'loose_imports_with_matching_names':loose,
    'scope_import_search':['E:/OpenLeague/assets','E:/OpenLeague/data/4.20','five archives listed by native_zip_catalog.json'],
    'recovered_catalog_rows':catalog_rows,'listed_archive_matches':archives,
    'native_portraits_different_resource':[v for v in portraits['entries'] if v['id'] in ['ahri','annie']],
    'tools_config_xml_exists':(DEPLOY/'ToolsConfig.xml').exists(),
    'observed_write_target_config_exists':(DEPLOY.parents[5]/'Config').exists(),
    'sources':[hashed(PARSER),hashed(global_manifest),hashed(zip_catalog),hashed(DATA/'champion_resources.json'),hashed(DATA/'native_champion_portraits.json')],
    'limitations':['INIBIN values use the existing community parser for inventory; no native8B0630/8B0380 execution is claimed here.',
        'DDS headers and hashes prove file availability only; no texture decoding, upload or loading-screen rendering executed.',
        'Catalog rows do not prove physical import or provider binding. Absence of matching names does not exclude renamed or embedded assets.']}
(OUT/'asset_inventory.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'source_files':len(rows),'dds':sum('dds_header'in r for r in rows),'inibin':sum('community_parser_only'in r for r in rows),
    'loose_imports':len(loose),'catalog_rows':len(catalog_rows),'archive_matches':sum(len(a['matches'])for a in archives),
    'fallback_values':[(r['relative_path'],r['community_parser_only']['fallback_package']) for r in rows if 'community_parser_only'in r and r['community_parser_only']['fallback_package_present']]}))
