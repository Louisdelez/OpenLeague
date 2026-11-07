"""Source membership in the exact recovered 4.20 EUW project manifests.

RADS project and per-payload releases are distinct from the game build. This
reader verifies bytes and keeps every candidate; it never chooses precedence.
"""
import argparse
import collections
import hashlib
import json
import pathlib
import sys

from frontend_builds import release_manifest

CATALOGUE='data/4.20/recovered_rads_manifests.json'
CATALOGUE_SHA='8dfd48645040526d5a3e7b91cb9438418078f2d617c236d9834a31dfdcb5d2da'
PINS=[('lol_game_client','0.0.1.7',4905302,'88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09',70286),
      ('lol_game_client_en_gb','0.0.0.235',49251,'c06c83f829dd18cf587098529aa83459c8356dc2fe5ee82d7203c7a9ee3662f0',563)]


def identity(path,md5=False):
    p=pathlib.Path(path);before=p.stat();sha=hashlib.sha256();legacy=hashlib.md5()
    with p.open('rb') as f:
        for chunk in iter(lambda:f.read(1024*1024),b''):
            sha.update(chunk)
            if md5:legacy.update(chunk)
    after=p.stat()
    if (before.st_size,before.st_mtime_ns)!=(after.st_size,after.st_mtime_ns):raise ValueError('Source changed during readonly observation')
    result={'path':str(p),'bytes':before.st_size,'sha256':sha.hexdigest()}
    if md5:result['md5']=legacy.hexdigest()
    return result


def logical_key(value):
    if not isinstance(value,str) or not value or not value.isascii() or '\0' in value or len(value)>1024:
        raise ValueError('Explicit bounded ASCII project-relative path required')
    value=value.replace('\\','/')
    if value.startswith('/') or ':' in value or any(p in ['', '.', '..'] for p in value.split('/')):
        raise ValueError('Manifest path traversal/absolute/empty component refused')
    return value.casefold()


class RadsReferenceMembership:
    def __init__(self,root):
        self.root=pathlib.Path(root).resolve(strict=True)
        catalogue=self.root/CATALOGUE;self.catalogue_identity=identity(catalogue)
        if self.catalogue_identity['sha256']!=CATALOGUE_SHA:raise ValueError('Recovered manifest catalogue changed')
        d=json.loads(catalogue.read_bytes())
        if (d['game_version'],d['source_realm'],d['files_imported'],len(d['files']))!=('4.20','live',2,2):
            raise ValueError('Wrong recovered source catalogue scope')
        reference_path=self.root/'docs/reference_client_4_20.json'
        if identity(reference_path)['sha256']!='efdf40252574a98f439829d43c6b29606d3c12d631c4a64c89ef15637e859d02':
            raise ValueError('Dated reference identity changed')
        self.reference=json.loads(reference_path.read_bytes())
        if (self.reference['client']['version'],self.reference['reference']['region'],self.reference['reference']['locale'])!=('4.20.0.315','EUW','en_GB'):
            raise ValueError('Reference version/region/locale changed')
        self.native_root=pathlib.Path(self.reference['source_root']).resolve(strict=True)
        self.deploy=(self.native_root/self.reference['client']['binary']).parent
        solution=self.deploy.parent/'solutionmanifest';configuration=self.deploy.parent/'configurationmanifest'
        self.solution_identity=identity(solution);self.configuration_identity=identity(configuration)
        if self.solution_identity['sha256']!='4926fe4cfdb8641c918c5ad69b891a9c7e48ba37939e4258e2b4b181accc9243' or self.configuration_identity['sha256']!='f601219e81fe20e4c805c5faaa7af664c0c6adcdd43d591c7a4f22ebbd7601f3':
            raise ValueError('Native solution/configuration identity changed')
        lines=solution.read_text(encoding='ascii').splitlines()
        if lines[:4]!=['RADS Solution Manifest','1.0.0.0','lol_game_client_sln','0.0.1.68']:
            raise ValueError('Native solution header changed')
        projects={lines[5+4*i]:lines[6+4*i] for i in range(int(lines[4]))}
        cfg=configuration.read_text(encoding='ascii').splitlines()
        if cfg[:4]!=['RADS Configuration Manifest','1.0.0.0','en_gb','2'] or cfg[4:]!=[x[0] for x in PINS]:
            raise ValueError('Configured project selection changed')
        self.by_key=collections.defaultdict(list);self.manifests=[];self.provenance=[]
        for item,(project,release,size,digest,count) in zip(d['files'],PINS,strict=True):
            path=self.root/'data/4.20/rads_manifests'/project/'releases'/release/'releasemanifest'
            observed=identity(path)
            if (item['project'],item['release'],item['bytes'],item['sha256'])!=(project,release,size,digest) or projects.get(project)!=release:
                raise ValueError('Recovered manifest not selected by native solution')
            if pathlib.Path(item['path']).resolve()!=path.resolve() or observed['bytes']!=size or observed['sha256']!=digest:
                raise ValueError('Recovered manifest bytes or backing changed')
            manifest=release_manifest(path,project,release)
            if identity(path)!=observed:raise ValueError('Manifest changed during parsing')
            if len(manifest['files'])!=count:raise ValueError('Recovered manifest member count changed')
            self.manifests.append({'project':project,'release':release,'identity':observed,'member_count':count,
                'archive_path':item['archive_path'],'archive_file_id':item['archive_file_id']})
            for name,entry in manifest['files'].items():
                self.by_key[logical_key(name)].append({'project':project,'project_release':release,'member_path':name,**entry})
        for name in ['recovery_receipt','review_manifest','recovery_package_manifest']:
            p=pathlib.Path(d['provenance'][name]);observed=identity(p)
            if observed['sha256']!=d['provenance'][name+'_sha256']:raise ValueError('Previous recovery proof changed')
            self.provenance.append({'role':name,**observed})

    def inspect(self,logical,path,expected_identity=None):
        key=logical_key(logical);p=pathlib.Path(path)
        if any(q.is_symlink() or q.is_junction() for q in [p,*p.parents]):raise ValueError('Payload reparse source refused')
        observed=identity(p,md5=True)
        if expected_identity is not None and any(observed[k]!=expected_identity[k] for k in ['bytes','sha256']):
            raise ValueError('Registered source identity changed')
        candidates=[dict(x,bytes_match=x['bytes']==observed['bytes'],md5_match=x['md5']==observed['md5']) for x in self.by_key.get(key,[])]
        matching=[x for x in candidates if x['bytes_match'] and x['md5_match']]
        if len(matching)>1:status='multiple_manifest_members_same_observed_payload'
        elif matching:status='matches_selected_project_manifest'
        elif candidates:status='differs_from_all_selected_manifest_payloads'
        else:status='not_listed_in_two_selected_projects'
        return {'logical_path':logical,'observed':observed,'status':status,'candidates':candidates,
            'matching_members':matching,'effective_runtime_precedence_qualified':False}



def source_id(path):
    import uuid
    return 'OLS-'+str(uuid.uuid5(uuid.UUID('cbd917dc-d33b-55c0-ab95-3923cec56dbb'),str(pathlib.Path(path).resolve()).replace('\\','/').casefold()))


def verify_recovered_alternatives(verifier):
    """Keep the separately recovered exact members beside divergent loose files."""
    metadata_path=verifier.root/'data/4.20/recovered_client_assets.json'
    metadata_identity=identity(metadata_path);metadata=json.loads(metadata_path.read_bytes())
    if metadata.get('artifact')!='recovered_native_client_payloads' or metadata.get('game_version')!='4.20':
        raise ValueError('Recovered payload catalogue scope changed')
    proofs=[]
    for name in ['recovery_receipt','audit_differences']:
        p=pathlib.Path(metadata['provenance'][name]);observed=identity(p)
        if observed['sha256']!=metadata['provenance'][name+'_sha256']:raise ValueError('Recovered payload provenance changed')
        proofs.append({'role':name,**observed})
    results=[]
    pins=[('DATA/Characters/Urf/Urf.inibin','0.0.1.7',610,'10aba1ff86213cc533ab4e8f45d0c63646ff16d8ba1dcd16be28fcae4d296d3a'),
          ('DATA/CFG/defaults/Cheats.cfg','0.0.0.64',148,'ab54ae2f8b0dba1aea64c95577018c834db8fa9dfa2ff4a6a6f64d83d56aa34c')]
    for logical,release,size,sha in pins:
        entries=[x for x in metadata['files'] if logical_key(x['relative_path'])==logical_key(logical)]
        if len(entries)!=1:raise ValueError('Recovered alternative absent or ambiguous')
        entry=entries[0];path=verifier.root/'data/4.20/recovered_client_assets'/logical
        if pathlib.Path(entry['path']).resolve()!=path.resolve() or (entry['project'],entry['version'],entry['bytes'],entry['sha256'])!=('lol_game_client',release,size,sha):
            raise ValueError('Recovered alternative identity changed')
        row=verifier.inspect(logical,path,{'bytes':size,'sha256':sha})
        if row['status']!='matches_selected_project_manifest' or row['matching_members'][0]['release']!=release:
            raise ValueError('Recovered alternative does not match selected manifest')
        original=identity(entry['source_path'],md5=True)
        if any(original[k]!=row['observed'][k] for k in ['bytes','sha256','md5']) or original['md5']!=entry['md5']:
            raise ValueError('Recovered original backing changed')
        if entry['archive_path']!='live/projects/lol_game_client/releases/'+release+'/files/'+logical:
            raise ValueError('Recovered archive record changed')
        row.update(source_id=source_id(path),recovery_record=entry,recovery_backing=original,
                   metadata=metadata_identity,recovery_proofs=proofs,ordinary_runtime_integration_qualified=False)
        results.append(row)
    return results


def binding_for(row,evidence_source_id):
    """Compact source-node provenance; all candidates survive the projection."""
    return {'schema':'openleague_source_rads_membership/v1','evidence_source_id':evidence_source_id,
        'row_source_id':row['source_id'],'logical_path':row['logical_path'],'status':row['status'],
        'observed':{k:row['observed'][k] for k in ['bytes','sha256','md5']},
        'candidates':row['candidates'],'matching_members':row['matching_members'],
        'effective_runtime_precedence_qualified':False}


def validate_binding(source,sources,receipt=None):
    b=source.get('rads_release_membership')
    if b is None:return
    if (b.get('schema')!='openleague_source_rads_membership/v1' or b.get('row_source_id')!=source['source_id']
        or b.get('evidence_source_id') not in sources or b.get('effective_runtime_precedence_qualified') is not False):
        raise ValueError('Invalid RADS source binding/evidence/precedence')
    logical_key(b['logical_path'])
    if any(b['observed'][k]!=source[k] for k in ['bytes','sha256']):raise ValueError('RADS observed source identity differs')
    candidates=b['candidates'];matching=b['matching_members']
    actual=[x for x in candidates if x['bytes']==b['observed']['bytes'] and x['md5']==b['observed']['md5']]
    if matching!=actual:raise ValueError('RADS matching candidate projection differs')
    expected=('multiple_manifest_members_same_observed_payload' if len(actual)>1 else
              'matches_selected_project_manifest' if actual else
              'differs_from_all_selected_manifest_payloads' if candidates else 'not_listed_in_two_selected_projects')
    if b['status']!=expected:raise ValueError('RADS status misrepresents observed matches')
    if receipt is not None:
        row=receipt.get(source['source_id'])
        if row is None or b!=binding_for(row,b['evidence_source_id']):raise ValueError('RADS binding differs from pinned receipt row')


def instruction_summary(source):
    b=source.get('rads_release_membership')
    if not b:return None
    members=' ; '.join(x['project']+' projet '+x['project_release']+' / contenu '+x['release'] for x in b['candidates']) or 'aucun membre dans les deux projets sélectionnés'
    return ('  Appartenance RADS : '+b['status']+' ; '+members+' ; preuve '+b['evidence_source_id']+
            ', ligne '+b['row_source_id']+'. Ce constat ne qualifie pas la priorité de chargement ni le gameplay.')


def main():
    a=argparse.ArgumentParser();a.add_argument('--root',default='E:/OpenLeague');a.add_argument('--output',required=True)
    args=a.parse_args();root=pathlib.Path(args.root);out=pathlib.Path(args.output)
    if out.exists():raise ValueError('Preserve earlier receipt; choose a fresh output')
    verifier=RadsReferenceMembership(root);registry_path=root/'docs/fidelity_sources_4_20.json'
    registry=json.loads(registry_path.read_bytes());rows=[]
    for s in registry['sources']:
        path=pathlib.Path(s['path']).resolve()
        if not path.is_relative_to(verifier.deploy):continue
        row=verifier.inspect(path.relative_to(verifier.deploy).as_posix(),path,s)
        row['source_id']=s['source_id'];rows.append(row)
    binary=next(x for x in rows if logical_key(x['logical_path'])=='league of legends.exe')
    if binary['status']!='matches_selected_project_manifest':raise ValueError('Game binary not attested by selected core manifest')
    counts=dict(collections.Counter(x['status'] for x in rows))
    result={'schema':'openleague_native_rads_manifest_membership/v1','audit_completed':True,
        'all_payloads_match':all(x['matching_members'] for x in rows),'rows_count':len(rows),'counts':counts,
        'reference':identity(root/'docs/reference_client_4_20.json'),'input_source_registry':identity(registry_path),
        'native_solution':verifier.solution_identity,'native_configuration':verifier.configuration_identity,
        'recovered_catalogue':verifier.catalogue_identity,'manifests':verifier.manifests,'recovery_proofs':verifier.provenance,
        'rows':rows,'recovered_alternatives':verify_recovered_alternatives(verifier),'producer':identity(__file__),'native_binary_or_DLL_executed':False,'source_bytes_modified':False,
        'limits':['Preserved Riot manifest metadata recovered from a community archive; independent Riot CDN authenticity is not established.',
            'Aggregate project release and member payload release are distinct from PUBLIC game4.20.0.315 and catalogue4.20.1.',
            'Unlisted or divergent files are observations, not automatically corruption: generated configuration, other projects/locales, altered copies and archive provenance require specific research.',
            'All matching candidates are retained; no mounted-provider precedence, archive payload availability, native parser acceptance, current renderer or game completion is inferred.']}
    out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'audit_completed':True,'rows':len(rows),'counts':counts,'output':str(out)}),flush=True)


if __name__=='__main__':main()
