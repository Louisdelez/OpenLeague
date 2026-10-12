"""Verify preserved frozen inputs without executing or changing them."""
from pathlib import Path
import hashlib,json
OUT=Path(__file__).resolve().parent
SOURCES={
    Path('E:/mapslol3v3/loading_provider_io_probe'):'d275c6dc2ab1cfb0416bfff6e6fdecc3bbf2512988b3ae8932507a5c368cb698',
    Path('E:/mapslol3v3/loading_resource_provider_next'):'dde701270da710c68c49890a8eb4669a89b91da4c582fa7670904a5aeff61232',
}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def verify():
    checked={}
    for root,expected in SOURCES.items():
        manifest=root/'manifest.json'
        assert sha(manifest)==expected,(str(manifest),'manifest changed')
        checked[str(manifest)]=expected
        data=json.loads(manifest.read_text())
        for name,meta in data['files'].items():
            p=root/name;actual=sha(p)
            assert actual==meta['sha256'],(str(p),'frozen input changed')
            checked[str(p)]=actual
        for name,meta in data.get('external_dependencies',{}).items():
            p=Path(name);actual=sha(p)
            assert actual==meta['sha256'],(str(p),'external input changed')
            checked[str(p)]=actual
    return checked
if __name__=='__main__':
    data={'passed':True,'files':verify(),'new_bridge_changes':['WORKSPACE points only at new owned scratch',
          'real GetFileAttributesExW adapter','Config and Logs allowlist sharing identical confinement'],
          'source_or_frozen_edits':False}
    (OUT/'input_verification.json').write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps({'passed':True,'verified_files':len(data['files'])}))
