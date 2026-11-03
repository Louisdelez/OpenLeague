"""Pinned historical client identity; no original client is executed."""
import argparse,datetime,functools,hashlib,json,pathlib,re,struct

CONTRACT="docs/reference_client_4_20.json"
class ReferenceError(ValueError):pass

def extract_client(binary):
    data=pathlib.Path(binary).read_bytes()
    if data[:2]!=b"MZ":raise ReferenceError("Le client n’est pas un PE Windows.")
    offset=struct.unpack_from("<I",data,0x3c)[0]
    if data[offset:offset+4]!=b"PE\0\0":raise ReferenceError("En-tête PE invalide.")
    pattern=rb"(?P<date>[A-Z][a-z]{2} [ 0-9][0-9] 20[0-9]{2})\x00(?P<time>[0-9]{2}:[0-9]{2}:[0-9]{2})\x00+(?P<version>4\.20\.[0-9]+\.[0-9]+)\x00+(?P<channel>PUBLIC)\x00+(?P<branch>Releases/4\.20)\x00"
    found=list(re.finditer(pattern,data))
    if len(found)!=1:raise ReferenceError("Identité de build 4.20 absente ou ambiguë.")
    m=found[0];identity={k:v.decode("ascii") for k,v in m.groupdict().items()}
    months={name:i+1 for i,name in enumerate("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec".split())}
    parts=identity["date"].split()
    identity["date_iso"]=datetime.date(int(parts[2]),months[parts[0]],int(parts[1])).isoformat()
    identity["literal_offset"]=m.start()
    identity["pe_timestamp_utc"]=datetime.datetime.fromtimestamp(struct.unpack_from("<I",data,offset+8)[0],datetime.timezone.utc).isoformat()
    identity["sha256"]=hashlib.sha256(data).hexdigest();identity["bytes"]=len(data)
    return identity

def fields(path):
    out={}
    for line in pathlib.Path(path).read_text(encoding="utf-8-sig").splitlines():
        if "=" in line:
            k,v=line.split("=",1);out[k.strip().casefold()]=v.strip()
    return out

def validate(document,source_root=None,verify_native=False):
    if document.get("schema")!="openleague_reference_client/v1":raise ReferenceError("Schéma de référence invalide.")
    c=document.get("client",{});r=document.get("reference",{})
    if c.get("patch")!="4.20" or c.get("version")!="4.20.0.315" or c.get("channel")!="PUBLIC" or c.get("branch")!="Releases/4.20":
        raise ReferenceError("Version/canal du client de référence incohérent.")
    if r.get("region")!="EUW" or r.get("locale")!="en_GB":raise ReferenceError("La référence fournie est EUW / en_GB.")
    if r.get("date_kind")!="embedded_client_build_date" or r.get("date")!=c.get("build_date"):
        raise ReferenceError("La date de référence doit être la date de build native.")
    if c.get("build_date")!="2014-11-17" or c.get("build_time_literal")!="17:46:45":
        raise ReferenceError("Date/heure de build incohérente.")
    if c.get("build_timezone") is not None or document.get("regional_patch_deployment_date") is not None:
        raise ReferenceError("Fuseau du build ou date de déploiement non établis : ne pas les inventer.")
    if document.get("catalogue",{}).get("version")!="4.20.1":raise ReferenceError("Catalogue de comparaison incorrect.")
    sources=document.get("sources",[])
    if len(sources)!=5 or len({s.get("path") for s in sources})!=5:
        raise ReferenceError("Les cinq sources de référence sont nécessaires.")
    for s in sources:
        rel=pathlib.PurePosixPath(s["path"])
        if rel.is_absolute() or ".." in rel.parts or "\\" in s["path"] or not re.fullmatch("[0-9a-f]{64}",s.get("sha256","")):
            raise ReferenceError("Chemin ou empreinte de source invalide.")
    if verify_native:
        root=pathlib.Path(source_root or document["source_root"]).resolve()
        for s in sources:
            path=(root/s["path"]).resolve()
            if not path.is_relative_to(root):raise ReferenceError("Source hors de la racine du client.")
            if not path.is_file():raise ReferenceError("Source absente : "+s["path"])
            b=path.read_bytes()
            if len(b)!=s["bytes"] or hashlib.sha256(b).hexdigest()!=s["sha256"]:
                raise ReferenceError("Source différente de la référence : "+s["path"])
        if fields(root/"RADS/system/system.cfg").get("region")!=r["region"]:raise ReferenceError("Région native divergente.")
        if fields(root/"RADS/system/locale.cfg").get("locale","").casefold()!=r["locale"].casefold():raise ReferenceError("Locale native divergente.")
        if fields(root/"RADS/system/launcher.cfg").get("airconfigproject")!="lol_air_client_config_euw":raise ReferenceError("Projet régional divergent.")
        manifest=(root/c["configuration_manifest"]).read_text(encoding="utf-8-sig").splitlines()
        if manifest!=["RADS Configuration Manifest","1.0.0.0","en_gb","2","lol_game_client","lol_game_client_en_gb"]:
            raise ReferenceError("Configuration de langue divergente.")
        native=extract_client(root/c["binary"])
        for key,target in [("version","version"),("channel","channel"),("branch","branch"),("date_iso","build_date"),("time","build_time_literal"),("pe_timestamp_utc","pe_linker_timestamp_utc")]:
            if native[key]!=c[target]:raise ReferenceError("Identité native divergente : "+target)
    return document

@functools.lru_cache(maxsize=8)
def _parse(raw):
    try:return validate(json.loads(raw))
    except (KeyError,TypeError,json.JSONDecodeError) as e:raise ReferenceError("Contrat de référence illisible.") from e

def load_reference(root,required=True):
    path=pathlib.Path(root)/CONTRACT
    if not path.exists() and not required:return None
    return _parse(path.read_bytes())

def reference_label(root,document=None):
    d=document if document is not None else load_reference(root,required=False)
    if d is None:return "RÉFÉRENCE : League of Legends 4.20 ; catalogues officiels 4.20.1 ; identité du client à fixer."
    c=d["client"];r=d["reference"]
    return (f'RÉFÉRENCE : League of Legends {c["version"]} ({c["channel"]}, {c["branch"]}) ; '
            f'région {r["region"]} ; locale {r["locale"]} ; build du {r["date"]} à {c["build_time_literal"]} '
            '(fuseau non établi, date de déploiement non établie) ; catalogue officiel 4.20.1.')

def main():
    p=argparse.ArgumentParser();p.add_argument("--root",default="E:/OpenLeague");p.add_argument("--source-root");p.add_argument("--output")
    args=p.parse_args();d=load_reference(args.root);validate(d,args.source_root,True)
    result={"task":"SYS-01.1-01","passed":True,"reference":d["reference"],"client":d["client"],
            "sources_verified":len(d["sources"]),"native_executed":False,"label":reference_label(args.root,d)}
    text=json.dumps(result,ensure_ascii=False,indent=2)
    if args.output:pathlib.Path(args.output).write_text(text,encoding="utf-8")
    print(text)
if __name__=="__main__":main()
