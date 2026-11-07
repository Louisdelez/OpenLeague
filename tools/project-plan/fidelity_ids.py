"""Immutable identity namespace for OpenLeague 4.20 fidelity requirements.

Identity is independent of titles, task order, status and evidence. The EMPTY
task family uses its resource path/action so rescanning cannot renumber identity.
The existing task ids and manual progress remain untouched.
"""
import functools,hashlib,json,pathlib,re,uuid

NAMESPACE=uuid.UUID('ca018cd0-36bd-56d9-8515-f616cb194d4a')
CONTRACT='docs/fidelity_requirement_ids_4_20.json'
class IdentityError(ValueError):pass

def positional_subject_key(task):
    ident=task.get('id','');entity=task.get('entity')
    m=re.fullmatch(r'(REF|STRUCTURE|CAMP)-\d+-(.+)',ident)
    if m:
        if entity is None or isinstance(entity,(dict,list,bool)):raise IdentityError('Positional requirement subject missing or ambiguous')
        return 'semantic-task:'+m[1]+':'+str(entity).casefold()+':'+m[2]
    if re.fullmatch(r'ROLE-\d+',ident):
        if not isinstance(entity,dict) or not entity.get('champion') or not entity.get('role'):raise IdentityError('Role identity subject missing')
        return 'semantic-task:ROLE:'+entity['champion'].casefold()+':'+entity['role'].casefold()
    m=re.fullmatch(r'TT-MAT-\d+-(.+)',ident)
    if m:
        if not isinstance(entity,dict) or not entity.get('material_name'):raise IdentityError('Material identity subject missing')
        return 'semantic-task:TT-MAT:'+entity['material_name'].casefold()+':'+m[1]
    return None

def validate_aliases(doc):
    if doc.get('schema')!='openleague_fidelity_identity_aliases/v1' or doc.get('namespace_uuid')!=str(NAMESPACE):raise IdentityError('Alias schema/namespace changed')
    rows=doc['bindings'];mapping={r['subject_key']:r['canonical_seed_key'] for r in rows}
    if len(mapping)!=len(rows) or len({r['requirement_id'] for r in rows})!=len(rows):raise IdentityError('Duplicate or ambiguous semantic identity alias')
    if any(stable_id(r['canonical_seed_key'])!=r['requirement_id'] for r in rows):raise IdentityError('Alias would reassign initial identity')
    return mapping

@functools.lru_cache(maxsize=4)
def _load_aliases(path,mtime,size):return validate_aliases(json.loads(pathlib.Path(path).read_bytes()))

def alias_bindings():
    p=pathlib.Path(__file__).with_name('fidelity_identity_aliases_4_20.json')
    if not p.is_file():raise IdentityError('Semantic identity aliases missing; refuse identity reassignment')
    stat=p.stat();return _load_aliases(str(p),stat.st_mtime_ns,stat.st_size)

def canonical_task_key(task):
    ident=task.get('id')
    if not isinstance(ident,str) or not ident or ident!=ident.strip() or any(ord(c)<32 for c in ident):
        raise IdentityError('Invalid task identifier')
    subject=positional_subject_key(task)
    if subject:return alias_bindings().get(subject,subject)
    empty=re.fullmatch(r'EMPTY-\d+-(CLASSIFY|RESOLVE|TEST)',ident)
    if empty:
        resource=task.get('entity')
        if not isinstance(resource,str) or not resource or '\x00' in resource:raise IdentityError('EMPTY resource identity missing')
        resource=resource.replace('\\','/')
        p=pathlib.PureWindowsPath(resource)
        if p.drive or p.root or '..' in p.parts:raise IdentityError('Resource identity outside native root')
        return 'native-resource-action:'+pathlib.PurePosixPath(resource).as_posix().casefold()+':'+empty[1]
    return 'task:'+ident

def stable_id(key):
    if not isinstance(key,str) or not key or '\x00' in key:raise IdentityError('Invalid requirement key')
    return 'OLF-'+str(uuid.uuid5(NAMESPACE,key))

def for_task(task):return stable_id(canonical_task_key(task))

def meaningful(task):
    return {k:task.get(k) for k in ['id','domain','title','kind','legacy_parent','entity','required','required_if']}

def definition_digest(tasks,crosswalk,archived):
    value={'tasks':sorted((meaningful(t) for t in tasks),key=lambda x:x['id']),
           'historical_requirements':sorted(crosswalk,key=lambda x:x['legacy_id']),
           'archived':sorted((meaningful(t) for t in archived),key=lambda x:x['id'])}
    return hashlib.sha256(json.dumps(value,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode('utf-8')).hexdigest()

def validate(doc,registry):
    if doc.get('schema')!='openleague_fidelity_ids/v1' or doc.get('namespace_uuid')!=str(NAMESPACE):raise IdentityError('Identity namespace/schema changed')
    if doc['definition_sha256']!=definition_digest(registry['tasks'],registry['crosswalk'],registry['retired_aggregate_tasks']):
        raise IdentityError('Requirement definitions changed; update the registry without reassigning identities')
    aliases_path=pathlib.Path(__file__).with_name('fidelity_identity_aliases_4_20.json')
    if doc['identity_policy'].get('positional_aliases_sha256')!=hashlib.sha256(aliases_path.read_bytes()).hexdigest():raise IdentityError('Alias bindings differ from registered identities')
    rows=doc['requirements'];bytask={r['task_id']:r for r in rows}
    if len(bytask)!=len(rows) or set(bytask)!={t['id'] for t in registry['tasks']}:raise IdentityError('Active requirement coverage incomplete')
    ids=[];keys=[]
    for t in registry['tasks']:
        row=bytask[t['id']];key=canonical_task_key(t)
        if row['canonical_key']!=key or row['requirement_id']!=stable_id(key):raise IdentityError('Active requirement identity rebound')
        if row['definition']!=meaningful(t):raise IdentityError('Requirement definition inconsistent')
        ids.append(row['requirement_id']);keys.append(key)
    origin={r['legacy_id']:r for r in doc['historical_requirements']}
    if len(origin)!=len(doc['historical_requirements']) or set(origin)!={r['legacy_id'] for r in registry['crosswalk']}:raise IdentityError('Historical requirement coverage incomplete')
    for old in registry['crosswalk']:
        row=origin[old['legacy_id']];key='legacy-requirement:'+old['legacy_id']
        if row['requirement_id']!=stable_id(key) or row['children']!=old['children'] or row['requirement']!=old['requirement']:raise IdentityError('Historical requirement identity rebound')
        ids.append(row['requirement_id']);keys.append(key)
    archived={r['task_id']:r for r in doc['archived_requirements']}
    if len(archived)!=len(doc['archived_requirements']) or set(archived)!={t['id'] for t in registry['retired_aggregate_tasks']}:raise IdentityError('Archived identities dropped')
    for t in registry['retired_aggregate_tasks']:
        row=archived[t['id']];key='archived-task:'+t['id']
        if row['requirement_id']!=stable_id(key) or row['definition']!=meaningful(t):raise IdentityError('Archived identity rebound')
        ids.append(row['requirement_id']);keys.append(key)
    if len(set(ids))!=len(ids) or len(set(keys))!=len(keys):raise IdentityError('Duplicate fidelity identity')
    if doc['manual_state_mutated'] or doc['human_acceptance']!='not_given':raise IdentityError('Unproven manual acceptance')
    return {'verified':True,'active_requirements':len(rows),'historical_requirements':len(origin),
            'archived_requirements':len(archived),'unique_identities':len(ids),'manual_state_mutated':False}
