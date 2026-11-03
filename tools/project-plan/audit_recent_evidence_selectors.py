"""Audit JSON selectors for the explicitly registered V158-V161 evidence scope."""
import argparse,hashlib,json,pathlib,re
SPECS={
 'docs/reference_adoption_sources/decisions-v158.json':(['REF-%02d-ADOPT'%n for n in range(1,13)]+['SYS-01.2-02'],'decisions'),
 'docs/reference_adoption_sources/reader-qualification-v158.json':(['REF-%02d-ADOPT'%n for n in range(1,13)]+['SYS-01.2-02'],'cases'),
 'docs/reference_empty_config_sources/config-prop-v159.json':(['EMPTY-035-CLASSIFY','EMPTY-035-RESOLVE','SYS-01.2-02'],'facts'),
 'docs/reference_empty_network_sources/network-log-v160.json':(['EMPTY-%03d-%s'%(n,k) for n in list(range(1,32))+[64,65,66] for k in ['CLASSIFY','RESOLVE']]+['SYS-01.2-02'],'facts'),
 'docs/reference_rads_empty_sources/rads-empty-v161.json':(['EMPTY-%03d-%s'%(n,k) for n in [33,34,36,67] for k in ['CLASSIFY','RESOLVE']]+['SYS-01.2-02'],'associations')}
class SelectorError(ValueError):pass
def pointer(document,selector):
 if not isinstance(selector,str) or not selector.startswith('/'):raise SelectorError('Expected explicit JSON pointer')
 for token in selector[1:].split('/'):
  if re.search(r'~(?![01])',token):raise SelectorError('Invalid pointer escape')
  token=token.replace('~1','/').replace('~0','~')
  if isinstance(document,list):
   if not re.fullmatch(r'0|[1-9][0-9]*',token):raise SelectorError('Invalid array index')
   index=int(token)
   if index>=len(document):raise SelectorError('Array index outside evidence')
   document=document[index]
  elif isinstance(document,dict):
   if token not in document:raise SelectorError('Missing evidence member: '+token)
   document=document[token]
  else:raise SelectorError('Pointer traverses scalar')
 return document

def verify_edge(document,selector,task_id,section):
 resolved=pointer(document,selector)
 if section in ['decisions','associations']:
  if task_id=='SYS-01.2-02':
   if selector!='/'+section or not isinstance(resolved,list):raise SelectorError('Objective requires full association collection')
  elif not isinstance(resolved,dict) or resolved.get('task_id')!=task_id:raise SelectorError('Evidence assigned to another task')
 elif selector!='/'+section or not resolved:raise SelectorError('Wrong evidence section')
 return True

def audit(root):
 root=pathlib.Path(root).resolve();sources=json.loads((root/'docs/fidelity_sources_4_20.json').read_bytes())['sources'];trace=json.loads((root/'docs/fidelity_requirement_trace_4_20.json').read_bytes())['requirements'];result=[]
 for relative,(tasks,section) in SPECS.items():
  path=root/relative;matches=[s for s in sources if pathlib.Path(s['path']).resolve()==path]
  if len(matches)!=1:raise SelectorError('Missing or duplicated source identity: '+relative)
  source=matches[0];data=path.read_bytes()
  if len(data)!=source['bytes'] or hashlib.sha256(data).hexdigest()!=source['sha256']:raise SelectorError('Evidence content changed: '+relative)
  document=json.loads(data);seen=[]
  for row in trace:
   for edge in row['reference_inputs']:
    if edge['source_id']!=source['source_id']:continue
    task=row['task_id']
    if task not in tasks or task in seen:raise SelectorError('Unexpected or duplicate association')
    verify_edge(document,edge['selector'],task,section);seen.append(task)
  if set(seen)!=set(tasks):raise SelectorError('Missing task association: '+relative)
  result.append(dict(source=relative,sha256=source['sha256'],selectors_verified=len(seen)))
 return dict(verified=True,scope='Explicit V158-V161 JSON evidence only; not all registry selectors or gameplay.',sources_verified=len(result),selectors_verified=sum(x['selectors_verified'] for x in result),results=result)
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--root',required=True);a=p.parse_args()
 try:print(json.dumps(audit(a.root),ensure_ascii=False,indent=2))
 except (SelectorError,OSError,ValueError,KeyError) as e:print(json.dumps(dict(verified=False,error=str(e))));raise SystemExit(1)
