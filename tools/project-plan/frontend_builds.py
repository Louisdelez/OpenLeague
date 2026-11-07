"""Read historical updater/AIR build identities as data, without running them."""
import argparse,ctypes,hashlib,json,pathlib,re,struct,zlib
import xml.etree.ElementTree as ET

CONTRACT='docs/reference_frontend_builds_4_20.json'
class BuildError(ValueError):pass

def digest(path):
    b=pathlib.Path(path).read_bytes()
    return {'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}

def pe_versions(path):
    """Windows VERSIONINFO query; this does not load/execute the program."""
    b=pathlib.Path(path).read_bytes()
    if len(b)<64 or b[:2]!=b'MZ':raise BuildError('Binaire PE absent ou invalide.')
    off=struct.unpack_from('<I',b,60)[0]
    if b[off:off+4]!=b'PE\0\0':raise BuildError('Signature PE invalide.')
    api=ctypes.WinDLL('version',use_last_error=True)
    api.GetFileVersionInfoSizeW.argtypes=[ctypes.c_wchar_p,ctypes.POINTER(ctypes.c_uint32)]
    api.GetFileVersionInfoSizeW.restype=ctypes.c_uint32
    api.GetFileVersionInfoW.argtypes=[ctypes.c_wchar_p,ctypes.c_uint32,ctypes.c_uint32,ctypes.c_void_p]
    api.VerQueryValueW.argtypes=[ctypes.c_void_p,ctypes.c_wchar_p,ctypes.POINTER(ctypes.c_void_p),ctypes.POINTER(ctypes.c_uint)]
    ignored=ctypes.c_uint32();size=api.GetFileVersionInfoSizeW(str(pathlib.Path(path).resolve()),ctypes.byref(ignored))
    if not size:raise BuildError('Ressource VERSIONINFO absente.')
    buffer=ctypes.create_string_buffer(size)
    if not api.GetFileVersionInfoW(str(pathlib.Path(path).resolve()),0,size,buffer):raise BuildError('VERSIONINFO illisible.')
    ptr=ctypes.c_void_p();length=ctypes.c_uint()
    if not api.VerQueryValueW(buffer,'\\',ctypes.byref(ptr),ctypes.byref(length)) or length.value<52:raise BuildError('VS_FIXEDFILEINFO absent.')
    values=struct.unpack('<13I',ctypes.string_at(ptr,52))
    if values[0]!=0xFEEF04BD:raise BuildError('Signature VERSIONINFO invalide.')
    def number(a,b):return '.'.join(map(str,[a>>16,a&65535,b>>16,b&65535]))
    return {'file_version':number(values[2],values[3]),'product_version':number(values[4],values[5])}

def installed_release(text,project):
    """Accept only a candidate validated inside this precise project's block."""
    state=False;candidate=None;ok=False;results=[]
    prefix='EnumerateInstalledProjectReleases: '
    for line in text.splitlines():
        if prefix not in line:continue
        body=line.split(prefix,1)[1]
        begin=re.fullmatch(r'\(([^)]+)\)',body)
        if begin:state=begin[1]==project;candidate=None;ok=False;continue
        if not state:continue
        m=re.fullmatch(r'Found candidate "(\d+\.\d+\.\d+\.\d+)" \(0x([0-9a-fA-F]+)\)\.',body)
        if m:
            parts=list(map(int,m[1].split('.')))
            if any(x>255 for x in parts) or int.from_bytes(bytes(parts),'big')!=int(m[2],16):raise BuildError('Identifiant RADS texte/entier divergent.')
            candidate=m[1];ok=False
        if body=='Found OK-file, candidate is valid':ok=True
        if body=='Succeeded.':
            if candidate and ok:results.append(candidate)
            state=False
    unique=set(results)
    if len(unique)!=1:raise BuildError('Release installée absente ou ambiguë pour '+project)
    return unique.pop()

class ABC:
    def __init__(self,data):self.data=data;self.p=0
    def take(self,n):
        if n<0 or self.p+n>len(self.data):raise BuildError('ABC tronqué.')
        v=self.data[self.p:self.p+n];self.p+=n;return v
    def u8(self):return self.take(1)[0]
    def u30(self):
        v=0
        for i in range(5):
            x=self.u8();v|=(x&127)<<(7*i)
            if not x&128:return v
        raise BuildError('Entier ABC invalide.')
    def pool(self):
        self.take(4)
        for _ in range(2):
            for i in range(max(0,self.u30()-1)):self.u30()
        self.take(max(0,self.u30()-1)*8)
        self.strings=['']+[self.take(self.u30()).decode('utf-8') for _ in range(max(0,self.u30()-1))]
        self.ns=[None]+[(self.u8(),self.u30()) for _ in range(max(0,self.u30()-1))]
        for _ in range(max(0,self.u30()-1)):
            for i in range(self.u30()):self.u30()
        self.names=[None]
        for _ in range(max(0,self.u30()-1)):
            kind=self.u8()
            if kind in [7,13,9,14]:args=(self.u30(),self.u30())
            elif kind in [15,16,27,28]:args=(self.u30(),)
            elif kind in [17,18]:args=()
            elif kind==29:args=(self.u30(),tuple(self.u30() for i in range(self.u30())))
            else:raise BuildError('Multiname ABC inconnu.')
            self.names.append((kind,args))
    def qname(self,index):
        kind,args=self.names[index]
        if kind not in [7,13]:raise BuildError('QName attendu.')
        return self.strings[self.ns[args[0]][1]],self.strings[args[1]]
    def traits(self):
        found=[]
        for _ in range(self.u30()):
            name=self.u30();flags=self.u8();kind=flags&15;value=None
            if kind in [0,6]:
                slot=self.u30();type_name=self.u30();index=self.u30()
                if index:value=(self.u8(),index)
            elif kind in [1,2,3,4,5]:self.u30();self.u30()
            else:raise BuildError('Trait ABC inconnu.')
            if flags&64:
                for i in range(self.u30()):self.u30()
            found.append((name,kind,value))
        return found
    def version_constant(self):
        self.pool()
        for _ in range(self.u30()):
            params=self.u30();self.u30()
            for i in range(params):self.u30()
            self.u30();flags=self.u8()
            if flags&8:
                for i in range(self.u30()):self.u30();self.u8()
            if flags&128:
                for i in range(params):self.u30()
        for _ in range(self.u30()):
            self.u30();n=self.u30()
            for i in range(2*n):self.u30()
        classes=[]
        for _ in range(self.u30()):
            name=self.u30();self.u30();flags=self.u8()
            if flags&8:self.u30()
            for i in range(self.u30()):self.u30()
            self.u30();self.traits();classes.append(self.qname(name))
        versions=[]
        for name in classes:
            self.u30();traits=self.traits()
            if name!=('com.riotgames.platform.gameclient.application','Version'):continue
            for trait,kind,value in traits:
                if self.qname(trait)[1]=='CURRENT_VERSION' and kind in [0,6] and value and value[0]==1:
                    versions.append(self.strings[value[1]])
        if len(versions)!=1:raise BuildError('Valeur Version.CURRENT_VERSION absente ou ambiguë.')
        return versions[0]

def air_version(path):
    b=pathlib.Path(path).read_bytes()
    if len(b)<12 or b[:3] not in [b'CWS',b'FWS']:raise BuildError('Bibliothèque AIR non SWF.')
    expected=struct.unpack_from('<I',b,4)[0]
    if expected>16*1024*1024:raise BuildError('Bibliothèque AIR trop grande.')
    try:data=b[:8]+zlib.decompress(b[8:]) if b[:3]==b'CWS' else b
    except zlib.error as e:raise BuildError('SWF compressé corrompu.') from e
    if len(data)!=expected:raise BuildError('Longueur SWF divergente.')
    pos=8+(5+4*(data[8]>>3)+7)//8+4;found=[]
    while pos+2<=len(data):
        header=struct.unpack_from('<H',data,pos)[0];pos+=2;size=header&63;tag=header>>6
        if size==63:
            if pos+4>len(data):raise BuildError('Tag SWF tronqué.')
            size=struct.unpack_from('<I',data,pos)[0];pos+=4
        end=pos+size
        if end>len(data):raise BuildError('Tag SWF hors limites.')
        if tag==82:
            payload=data[pos:end];zero=payload.find(b'\0',4)
            if zero<0:raise BuildError('DoABC sans nom.')
            if payload[4:zero]==b'com/riotgames/platform/gameclient/application/Version':
                found.append(ABC(payload[zero+1:]).version_constant())
        pos=end
        if tag==0:break
    if len(found)!=1 or not re.fullmatch(r'4\.20\.\d{2}_\d{2}_\d{2}_\d{2}_\d{2}',found[0]):raise BuildError('Version AIR 4.20 absente ou ambiguë.')
    return {'build':found[0],'class':'com.riotgames.platform.gameclient.application.Version',
            'field':'CURRENT_VERSION','format':'AVM2 static String, trait_slot with default UTF-8 value','swf_version':b[3],'decoded_bytes':len(data)}

def safe_source(root,rel):
    p=pathlib.PurePosixPath(rel)
    if p.is_absolute() or '..' in p.parts or '\\' in rel or ':' in rel:raise BuildError('Chemin de source interdit.')
    path=(pathlib.Path(root)/rel).resolve()
    if not path.is_relative_to(pathlib.Path(root).resolve()):raise BuildError('Source hors de sa racine.')
    return path


def release_manifest(path,project,release):
    """Read the RLSM identity, independently of the enclosing folder name."""
    from patcher_formats import read_manifest
    try:
        result=read_manifest(pathlib.Path(path).read_bytes())
    except (ValueError,IndexError,struct.error,RecursionError) as e:
        raise BuildError('Manifeste RADS invalide : '+str(e)) from e
    if result['project']!=project:raise BuildError('Projet du manifeste RADS divergent.')
    if result['release']!=release:raise BuildError('Release du manifeste RADS divergente.')
    return result


def manifest_member(manifest,name,path,expected_release):
    entry=manifest['files'].get(name)
    if entry is None:raise BuildError('Ressource absente du manifeste RADS : '+name)
    if entry['release']!=expected_release:raise BuildError('Release de la ressource RADS divergente : '+name)
    payload=pathlib.Path(path).read_bytes()
    if entry['bytes']!=len(payload) or entry['md5']!=hashlib.md5(payload).hexdigest():
        raise BuildError('Contenu de la ressource RADS divergent : '+name)
    return {'path':name,**entry,'sha256':hashlib.sha256(payload).hexdigest()}


def excluded_union_candidate(manifest,name,path,expected):
    """Classify obsolete archive-union entries without admitting them as 4.20."""
    payload=pathlib.Path(path).read_bytes();entry=manifest['files'].get(name)
    if entry is None:observed='absent_from_release_manifest'
    elif entry['bytes']!=len(payload) or entry['md5']!=hashlib.md5(payload).hexdigest():
        observed='different_content_from_release_manifest'
    else:observed='matches_release_manifest'
    if observed!=expected:raise BuildError('Classification de la ressource archivée divergente : '+name)
    return {'path':name,'classification':observed,'candidate_bytes':len(payload),
            'candidate_md5':hashlib.md5(payload).hexdigest(),'manifest_entry':entry}

def verify(document,project_root,roots=None):
    from reference_client import load_reference,validate
    d=document;r=load_reference(project_root);validate(r,verify_native=True)
    if d.get('schema')!='openleague_frontend_builds/v1' or d.get('task')!='SYS-01.1-02':raise BuildError('Contrat des builds invalide.')
    if d.get('game_reference_sha256')!=digest(pathlib.Path(project_root)/'docs/reference_client_4_20.json')['sha256']:raise BuildError('Référence de partie divergente.')
    roots=roots or d['source_roots'];files={}
    for src in d['sources']:
        path=safe_source(roots[src['root']],src['path'])
        if not path.is_file():raise BuildError('Source absente : '+src['id'])
        if digest(path)!={k:src[k] for k in ['bytes','sha256']}:raise BuildError('Source modifiée : '+src['id'])
        if src['id'] in files:raise BuildError('Identifiant de source dupliqué.')
        files[src['id']]=path
    required={'patcher','patcher_manifest','installed_log_21','installed_log_22','air_common',
              'air_descriptor','stale_version','archive_merged','archive_inventory','air_manifest'}
    if set(files)!=required:raise BuildError('Ensemble des sources de builds incomplet ou inattendu.')
    if d['patcher']['project']!='lol_patcher' or d['air']['project']!='lol_air_client':
        raise BuildError('Projets des builds non conformes à la référence 4.20.')
    patch=pe_versions(files['patcher'])
    if patch!={k:d['patcher'][k] for k in ['file_version','product_version']}:raise BuildError('Version du patcher divergente.')
    if d['patcher']['rads_release']!=files['patcher'].parent.parent.name:raise BuildError('Release du patcher divergente.')
    air=air_version(files['air_common'])
    if air['build']!=d['air']['build']:raise BuildError('Build AIR divergent.')
    if (d['air']['build_source']!='air_common' or d['air']['class_name']!=air['class']
            or d['air']['field']!=air['field'] or d['air']['field_format']!=air['format']):
        raise BuildError('Liaison du champ de build AIR divergente.')
    patch_manifest=release_manifest(files['patcher_manifest'],d['patcher']['project'],d['patcher']['rads_release'])
    air_manifest=release_manifest(files['air_manifest'],d['air']['project'],d['air']['rads_release'])
    bindings={
        'patcher':{'project':patch_manifest['project'],'release':patch_manifest['release'],
                   'member':manifest_member(patch_manifest,'LoLPatcher.exe',files['patcher'],d['patcher']['rads_release'])},
        'air':{'project':air_manifest['project'],'release':air_manifest['release'],'manifest_files':len(air_manifest['files']),
               'member':manifest_member(air_manifest,'lib/ClientLibCommon.dat',files['air_common'],d['air']['rads_release'])}}
    classifications=d['archive_candidate_classification']
    if classifications!={'air_descriptor':'different_content_from_release_manifest','stale_version':'absent_from_release_manifest'}:
        raise BuildError('Ressources anciennes non exclues du client AIR 4.20.')
    bindings['excluded_union_candidates']=[
        excluded_union_candidate(air_manifest,name,files[ident],classifications[ident])
        for ident,name in [('air_descriptor','META-INF/AIR/application.xml'),('stale_version','version.txt')]]
    descriptor_expected=d['air']['descriptor_expected_by_release119']
    descriptor_entry=air_manifest['files']['META-INF/AIR/application.xml']
    if (descriptor_expected['source_release']!=descriptor_entry['release']
            or any(descriptor_expected[k]!=descriptor_entry[k] for k in ['bytes','md5'])
            or descriptor_expected['exact_payload_recovered_for_this_task'] is not False
            or descriptor_expected['version_number'] is not None or descriptor_expected['namespace'] is not None):
        raise BuildError('Descripteur 4.20 non récupéré : identité ou inconnues divergentes.')
    meta=d['archive']['release_manifest']
    if (meta['source_id']!='air_manifest' or meta['project']!=air_manifest['project']
            or meta['release']!=air_manifest['release'] or meta['files']!=len(air_manifest['files'])):
        raise BuildError('Provenance du manifeste AIR divergente.')
    provenance=safe_source(roots['project'],meta['provenance'])
    if digest(provenance)['sha256']!=meta['provenance_sha256']:raise BuildError('Reçu du manifeste AIR modifié.')
    receipt=json.loads(provenance.read_bytes())['recovery_receipt']
    if (len(receipt['files'])!=1 or receipt['historical_binary_executed'] is not False
            or receipt['files'][0]['archive_record']!=meta['archive_record']
            or any(receipt['files'][0][k]!=digest(files['air_manifest'])[k] for k in ['bytes','sha256'])
            or meta['archive_record']['entry']['path']!='live/projects/lol_air_client/releases/0.0.1.119/releasemanifest'):
        raise BuildError('Enregistrement original du manifeste AIR divergent.')
    for ident in ['installed_log_21','installed_log_22']:
        text=files[ident].read_text(encoding='utf-8')
        if installed_release(text,'lol_air_client')!=d['air']['rads_release']:raise BuildError('Release AIR divergente.')
        if installed_release(text,'lol_air_client_config_euw')!=d['air']['regional_config_release']:raise BuildError('Configuration AIR EUW divergente.')
        if 'Matched \'EUW\'|\'lol_air_client_config_euw\'' not in text:raise BuildError('Région du journal non établie.')
        if 'solutions/lol_game_client_sln/releases/0.0.1.68/configurationmanifest' not in text:raise BuildError('Association à la solution 4.20 manquante.')
    # Verify exact recovered source records. The whole archive union is not an executable install.
    merged=json.loads(files['archive_merged'].read_bytes());inventory=json.loads(files['archive_inventory'].read_bytes())
    for ident,name in [('air_common','lib/ClientLibCommon.dat'),('air_descriptor','META-INF/AIR/application.xml'),('stale_version','version.txt')]:
        entry=merged[name];hits=[x for x in inventory if x['name']==name]
        if len(hits)!=1 or hits[0]['sha256']!=digest(files[ident])['sha256'] or hits[0]['source']!=entry['path'] or hits[0]['fileId']!=entry['fileId'] or hits[0]['size']!=entry['size']:
            raise BuildError('Provenance archivée divergente : '+name)
    common_path=merged['lib/ClientLibCommon.dat']['path']
    if common_path!='live/projects/lol_air_client/releases/'+d['air']['rads_release']+'/files/lib/ClientLibCommon.dat':raise BuildError('Bibliothèque AIR issue d’une autre release.')
    if d['archive']['original_index_record']['entry']!=merged['lib/ClientLibCommon.dat']:raise BuildError('Enregistrement original de la bibliothèque divergent.')
    for name,entry in d['archive']['records'].items():
        if merged.get(name)!=entry:raise BuildError('Enregistrement archivé divergent : '+name)
    if merged['META-INF/AIR/application.xml']['path']!='live/projects/lol_air_client/releases/'+d['air']['descriptor_source_release']+'/files/META-INF/AIR/application.xml':raise BuildError('Héritage du descripteur divergent.')
    ns={'a':'http://ns.adobe.com/air/application/3.7'};xml=ET.fromstring(files['air_descriptor'].read_bytes())
    if xml.findtext('a:versionNumber',namespaces=ns)!=d['air']['descriptor_version'] or xml.findtext('a:id',namespaces=ns)!='LolClient':raise BuildError('Descripteur AIR divergent.')
    if d['air']['descriptor_namespace']!=xml.tag.split('}')[0][1:]:raise BuildError('Namespace du descripteur divergent.')
    if d['air'].get('build_timezone') is not None or d['air'].get('pe_loader_version') is not None:raise BuildError('Fuseau/build du chargeur AIR non établi.')
    if d['air']['build']==d['air']['descriptor_version'] or d['air']['build']==files['stale_version'].read_text().strip():raise BuildError('Version héritée confondue avec le build AIR.')
    return {'task':d['task'],'facts_verified':True,'native_executed':False,'patcher':d['patcher'],'air':d['air'],
            'verified_sources':len(files),'manifest_verification':bindings,
            'human_acceptance':'not_given','manual_state_mutated':False}

def main():
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--output');args=p.parse_args()
    try:
        result=verify(json.loads((pathlib.Path(args.root)/CONTRACT).read_bytes()),args.root)
    except (BuildError,OSError,ValueError,KeyError,IndexError,struct.error) as e:
        print(json.dumps({'facts_verified':False,'error':str(e)},ensure_ascii=False));return 1
    text=json.dumps(result,ensure_ascii=False,indent=2)
    if args.output:pathlib.Path(args.output).write_text(text,encoding='utf-8')
    print(text);return 0
if __name__=='__main__':raise SystemExit(main())
