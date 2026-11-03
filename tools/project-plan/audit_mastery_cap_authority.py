"""Read-only audit of the AIR mastery cap's source; never invent a service payload."""
import argparse, hashlib, json, pathlib, re, sys
R=pathlib.Path('E:/OpenLeague')
sys.path.insert(0,str(R/'tools/project-plan'))
from frontend_builds import release_manifest,manifest_member
from reference_inibin import read,hashkey
from rads_reference_membership import RadsReferenceMembership

def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
    p=pathlib.Path(p);b=p.read_bytes()
    return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def require(value,message):
    if not value:raise ValueError(message)
def check_pin(row):
    p=pathlib.Path(row['path']).resolve(strict=True)
    require(any(p.is_relative_to(root) for root in [R.resolve(),pathlib.Path('E:/mapslol3v3').resolve(),pathlib.Path('D:/LeagueOfLegendsV2/4.20').resolve(),pathlib.Path('C:/Program Files/Eclipse Adoptium').resolve()]),'Source outside declared roots')
    require(all(pin(p)[k]==row[k] for k in ['bytes','sha256']),'Source identity changed: '+str(p))

def method(p,name,accessor=None):
    text=pathlib.Path(p).read_text(encoding='utf-8-sig')
    pat=r'^\s*(?:public|private|protected)\s+(?:static\s+)?function\s+(?:(get|set)\s+)?'+re.escape(name)+r'\('
    found=[m for m in re.finditer(pat,text,re.M) if m[1]==accessor]
    require(len(found)==1,'Missing or ambiguous original method '+name)
    m=found[0];end=text.index('end ; method',m.end())+len('end ; method')
    body=text[m.start():end]
    codes=re.findall(r'^\s*code\s*$([\s\S]*?)^\s*end ; code\s*$',body,re.M)
    require(len(codes)==1,'Missing or ambiguous original method code')
    lines=[x.strip() for x in codes[0].splitlines() if x.strip()]
    return {'name':name,'accessor':accessor,'source':str(p),'first_line':text[:m.start()].count('\n')+1,
        'last_line':text[:end].count('\n')+1,'code_sha256':hashlib.sha256(('\n'.join(lines)+'\n').encode()).hexdigest(),
        'code':lines,'instruction_count':sum(not x.endswith(':') for x in lines)}

def audit(evidence_root,inputs_override=None):
    v=pathlib.Path(evidence_root).resolve(strict=True)
    require(v.is_relative_to(pathlib.Path('E:/mapslol3v3').resolve()),'Evidence root outside workspace')
    d=load(v/'mastery-cap-source-inputs.json') if inputs_override is None else inputs_override
    require(d['schema']=='openleague_mastery_cap_source_inputs/v1','Wrong source schema')
    require(d['historical_AIR_executed'] is False and d['historical_cap_payload_recovered'] is False,'Unsupported historical execution or payload claim')
    for k in ['reference','air_routes','manifest','native_fontconfig']:check_pin(d[k])
    for x in d['tools'].values():check_pin(x)
    routes=load(d['air_routes']['path'])
    manifest=release_manifest(d['manifest']['path'],'lol_air_client','0.0.1.119')
    require(len(d['classes'])==len(d['exports'])==4,'Four exact selected classes required')
    by={};identities={}
    def keep(x):identities[str(pathlib.Path(x['path']).resolve()).casefold()]=x
    for x in [d[k] for k in ['reference','air_routes','manifest','native_fontconfig']]:keep(x)
    for x in d['tools'].values():keep(x)
    for cls,export in zip(d['classes'],d['exports'],strict=True):
        for k in ['original','review']:check_pin(cls[k]);keep(cls[k])
        row=next(x for x in routes['review_sources'] if x['analysis']['class']==cls['class'])
        raw=next(x for x in routes['original_sources'] if x['path']==row['input'])
        require(pathlib.Path(cls['review']['path']).resolve()==(R/'docs/reference_air_sources'/row['path']).resolve(),'Review rebound')
        require(all(cls['review'][k]==row[k] and cls['original'][k]==raw[k] for k in ['bytes','sha256']),'Review or binary identity rebound')
        member=manifest_member(manifest,row['input'],cls['original']['path'],raw['manifest_entry']['release'])
        require(member==cls['member'],'Manifest member rebound')
        require(export['exit_code']==0 and len(export['outputs'])==1,'Bytecode export did not finish normally')
        require(export['command'][-1]==cls['original']['path'] and cls['class'] in export['command'] and 'script:pcode' in export['command'],'Wrong binary/class/export format')
        require(export['command'][0]==d['tools']['java']['path'] and d['tools']['ffdec_jar']['path'] in export['command'],'Exporter tool rebound')
        check_pin(export['log']);check_pin(export['outputs'][0]);keep(export['log']);keep(export['outputs'][0])
        by[cls['name']]=pathlib.Path(export['outputs'][0]['path'])
    spec=[('controller','grabCatalog',None),('controller','increaseTalentRank',None),('utilities','registerTree',None),('utilities','getMasteryByID',None),('talent','maxRank','get'),('talent','maxRank','set'),('renderer','setProperlyActivatedState',None),('renderer','updateRankDisplay',None),('renderer','updateTooltip',None)]
    methods={kind+':'+name+(':'+access if access else ''):method(by[kind],name,access) for kind,name,access in spec}
    def has(key,*tokens):
        code='\n'.join(methods[key]['code'])
        require(all(t in code for t in tokens),'Original property/control flow changed: '+key)
    has('controller:grabCatalog','"summonerCatalog")','"talentTree")','"registerTree"), 1')
    has('controller:increaseTalentRank','"getMasteryByID"), 1','"maxRank")\nifnlt ofs012f','increment_i','"ERROR_SPENDING_POINT")','"prereqTalentGameCode")')
    has('utilities:registerTree','"_registeredMasteryTree")','"masteriesByGameCode")','"tltId")','setproperty MultinameL(')
    has('utilities:getMasteryByID','"masteriesByGameCode")','getlocal1\ngetproperty MultinameL(','throw')
    has('talent:maxRank:get','"_844043184maxRank")\nreturnvalue')
    has('talent:maxRank:set','setproperty QName(PrivateNamespace("com.riotgames.platform.gameclient.masteries:Talent"),"_844043184maxRank")','pushstring "maxRank"')
    has('renderer:setProperlyActivatedState','"maxRank")\nifne ofs001d','pushstring "maxed"','pushstring "active"')
    has('renderer:updateRankDisplay','pushstring "/"','"maxRank")\nadd','"setText"), 1')
    has('renderer:updateTooltip','"maxRank")','"getTalentResourceString"), 3')
    require(not any('SpellData' in line or '"Ranks"' in line or 'buildFakeMasteryTree' in line for x in methods.values() for line in x['code']),'Unsupported native Ranks/fake-tree authority in bounded chain')
    catalogue_path=next(p for p in d['catalogues'] if pathlib.Path(p).name=='mastery.json')
    catalogue=load(catalogue_path);meta=d['catalogues'][catalogue_path]
    require(catalogue['version']==meta['version']=='4.20.1' and pin(catalogue_path)['sha256']==meta['sha256'],'Wrong mastery catalogue')
    keep(pin(catalogue_path))
    membership=RadsReferenceMembership(R)
    font=pathlib.Path(d['native_fontconfig']['path']).read_text(encoding='utf-8-sig')
    rows=[]
    require([x['id'] for x in d['native_rank_sources']]==['4312','4313'],'Wrong mastery identity set')
    for row in d['native_rank_sources']:
        ident=row['id'];check_pin(row['source']);keep(row['source'])
        native=read(row['source']['path'])[hashkey('SpellData','Ranks')]
        require(native==row['value']==4 and catalogue['data'][ident]['ranks']==3,'Rank observations changed')
        descriptors=[]
        for rank in range(1,6):
            hits=re.findall(r'^tr "game_mastery_level'+str(rank)+'desc_'+ident+r'" = "(.*)"\s*$',font,re.M)
            require(len(hits)==1,'Missing or ambiguous exact mastery description')
            descriptors.append(hits[0])
        require(all(descriptors[:4]) and descriptors[4]=='','Rank descriptions changed')
        member=membership.inspect('DATA/Talents/'+ident+'.inibin',row['source']['path'],row['source'])
        require(member['status']=='matches_selected_project_manifest','Native mastery not qualified against selected manifest')
        rows.append({'id':ident,'native_inibin_ranks':native,'native_descriptions':descriptors,'catalogue_ranks':3,
            'native_membership':member,'effective_historical_Talent_maxRank':None,'comparison_resolution':'open',
            'missing_input':'Original 4.20 EUW summonerCatalog.talentTree Talent.maxRank for this tltId/game code, or an independent primary record proving the same cap.'})
    return {'schema':'openleague_mastery_cap_authority_audit/v1','counts':{'classes':4,'manifest_bound_libraries':3,'methods':len(methods),'static_instructions_inspected':sum(x['instruction_count'] for x in methods.values()),'masteries':2,'open_numeric_comparisons':2},
        'methods':methods,'masteries':rows,'source_identities':list(identities.values()),
        'authority_chain':['session.summonerCatalog.talentTree','MasteriesUtils.registerTree/masteriesByGameCode[tltId]','getMasteryByID(id).maxRank','increaseTalentRank: rank < maxRank; renderer: equality/display'],
        'historical_payload_recovered':False,'historical_AIR_executed':False,'current_Rust_mastery_cap_implementation_qualified':False,
        'scope':'Fresh static p-code/AS/binary/manifest/INIBIN/catalogue proof. Bounded AIR methods consult the DTO cap. No service DTO value, runtime behavior, native SpellData.Ranks consumer equivalence, or gameplay cap is invented.'}

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output',required=True);a=p.parse_args()
    out=pathlib.Path(a.output);require(not out.exists(),'Preserve existing audit output')
    d=audit(a.evidence_root);out.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(d['counts']))
