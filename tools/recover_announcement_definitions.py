"""Extract original announcement policies and resolve only bank-confirmed event names."""
import datetime, hashlib, itertools, json, pathlib, re

ROOT = pathlib.Path('E:/OpenLeague')
def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()
context = json.loads((ROOT/'data/4.20/ambient_audio_context.json').read_text(encoding='utf-8'))
deploy = next(p for p in pathlib.Path(context['banks'][0]['path']).parents if p.name == 'deploy')
graph_path = ROOT/'data/4.20/announcer_audio_graph.json'
graph = json.loads(graph_path.read_text(encoding='utf-8'))
voice_proof_path=ROOT/'data/4.20/audio_initialized_announcer_namespace_contract.json'
voice_proof=json.loads(voice_proof_path.read_text(encoding='utf-8'))
voice=voice_proof['startup_voice_literal']['value']
assert voice=='Female1' and voice_proof['startup_configuration_key']['value']=='Voice'
team_proof_path=ROOT/'data/4.20/audio_announcer_team_binding_contract.json'
team_proof=json.loads(team_proof_path.read_text(encoding='utf-8'))
assert team_proof['passed'] and team_proof['pattern']==' your team | enemy team@'
actor_proof_path=ROOT/'data/4.20/audio_announcer_actor_binding_contract.json'
actor_proof=json.loads(actor_proof_path.read_text(encoding='utf-8'))
assert actor_proof['passed'] and actor_proof['pattern']==' you | hero | minion | turret@'
registry = {}
for bank in graph['banks']:
    assert digest(pathlib.Path(bank['bank'])) == bank['bank_sha256']
    for event in bank['events']: registry.setdefault(event['id'], []).append(bank['bank'])
def event_hash(name):
    value = 0x811c9dc5
    for b in name.lower().encode('ascii'): value = ((value * 0x1000193) & 0xffffffff) ^ b
    return value
sources, definitions, confirmed, unresolved = [], [], [], []
for path in sorted((deploy/'DATA/cfg/defaults').glob('Announcements_*.ini')):
    sources.append({'path':str(path),'sha256':digest(path)})
    sections = []
    for number, line in enumerate(path.read_text(encoding='utf-8-sig').splitlines(), 1):
        line = line.strip()
        if not line or line.startswith(';'): continue
        if line.startswith('[') and line.endswith(']'):
            sections.append({'name':line[1:-1], 'line':number, 'fields':[]})
        elif '=' in line:
            assert sections, (path, number)
            key, value = line.split('=', 1)
            sections[-1]['fields'].append({'key':key.strip(),'value':value.strip(),'line':number})
        else: raise ValueError((path, number, line))
    definitions.append({'source':str(path),'sections':sections})
    for section in sections:
        for field in section['fields']:
            template = field['value']
            if not field['key'].startswith('Sounds') or '/Dialogue/Announcer/' not in template: continue
            template = template.replace('@event name@', section['name']).replace('@languageLocale@','en_US').replace('@dimension@','2D')
            tokens = re.findall(r'@([^@]+)@', template)
            choices = []
            for token in tokens:
                # Only finite alternatives explicitly present in the source template.
                if '|' not in token: break
                if ' '+token.split(' ',1)[1]+'@'==team_proof['pattern']:
                    choices.append(['YourTeam','EnemyTeam'])
                elif ' '+token.split(' ',1)[1]+'@'==actor_proof['pattern'] and token.split(' ',1)[0] in ['src','dest']:
                    # Bank identity candidates use native plain-token outputs. The outer
                    # formatter's choice between plain/localized dispatch is still open.
                    choices.append(['you','hero','minion','turret','blueHero','purpleHero','redHero'])
                else:
                    choices.append([v.strip() for v in token.split(' ',1)[1].split('|')])
            else:
                for values in itertools.product(*choices):
                    path_value = template
                    for token, value in zip(tokens, values): path_value = path_value.replace('@'+token+'@', value)
                    remainder = path_value.split('/Dialogue/Announcer/',1)[1]
                    name = 'play_vo_announcer_'+remainder.split('/',1)[0]+'_'+voice+'_'+remainder.rsplit('/',1)[1].replace('.','_')
                    identity = event_hash(name)
                    row = {'source':str(path),'section':section['name'],'field':field['key'],'line':field['line'],'path':path_value,'event_name':name,'event_id':identity}
                    if identity in registry:
                        row['banks']=registry[identity]; confirmed.append(row)
                    else: unresolved.append(row)
                continue
            unresolved.append({'source':str(path),'section':section['name'],'field':field['key'],'line':field['line'],'template':field['value'],'reason':'non-enumerable native substitution'})
result={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'sources':sources,'graph_sha256':digest(graph_path),'voice':voice,'voice_proof_sha256':digest(voice_proof_path),'team_binding_proof_sha256':digest(team_proof_path),'actor_binding_proof_sha256':digest(actor_proof_path),'definitions':definitions,'confirmed_event_names':confirmed,'unresolved':unresolved,'complete':False,'limits':['Team/actor candidates follow qualified native plain-token outputs; other finite substitutions enumerate source labels, not qualified runtime outputs.','Plain6D4A10 and localized6D4DC0 dispatch bodies qualified for actor-token family. Attribution to sound/text/source/destination at outer formatter level remains unqualified; bank-confirmed candidates are not a complete runtime substitution contract.','Dimension is ignored by the qualified legacy resolver; supplied 2D is an enumeration input, not a runtime spatialization claim.','Hash and bank membership prove event identity correspondence, not trigger scheduling, voice admission, mixing or audible playback.']}
target=ROOT/'data/4.20/announcement_definitions.json'
temp=target.with_suffix('.json.tmp');temp.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');json.loads(temp.read_text(encoding='utf-8'));temp.replace(target)
print(json.dumps({'files':len(sources),'sections':sum(len(x['sections']) for x in definitions),'confirmed':len(confirmed),'unique_events':len({x['event_id'] for x in confirmed}),'unresolved':len(unresolved)}))
