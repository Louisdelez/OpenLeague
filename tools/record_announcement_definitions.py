import datetime,hashlib,json,pathlib,shutil
r=pathlib.Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc);stamp=now.strftime('%Y%m%dT%H%M%SZ')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,d):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');json.loads(t.read_text(encoding='utf-8'));t.replace(p)
p=r/'data/4.20/announcement_definitions.json';data=json.loads(p.read_text(encoding='utf-8'));fields=0
for source,definition in zip(data['sources'],data['definitions']):
 path=pathlib.Path(source['path']);assert sha(path)==source['sha256'];lines=path.read_text(encoding='utf-8-sig').splitlines()
 for section in definition['sections']:
  assert lines[section['line']-1].strip()=='['+section['name']+']'
  for field in section['fields']:
   key,value=lines[field['line']-1].strip().split('=',1);assert (key.strip(),value.strip())==(field['key'],field['value']);fields+=1
graph=r/'data/4.20/announcer_audio_graph.json';assert sha(graph)==data['graph_sha256']
assert len(data['sources'])==5 and len(data['definitions'])==5
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'source_files':5,'sections':sum(len(d['sections']) for d in data['definitions']),'source_fields_roundtrip_verified':fields,'bank_confirmed_names':len(data['confirmed_event_names']),'unresolved_candidates':len(data['unresolved']),'artifact':'data/4.20/announcement_definitions.json','artifact_sha256':sha(p),'limits':data['limits'],'next_action':'Resolve original announcer substitution/cache and service-prefix inputs against banks before posting native announcements; import verified priorities and queue policies into normal client dispatch.'}
backup=r/'docs/plan_history'/('announcement-definitions-'+stamp);backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:
 shutil.copy2(r/'docs'/name,backup/name)
coverage_path=r/'docs/coverage.json';coverage=json.loads(coverage_path.read_text(encoding='utf-8-sig'));coverage['announcement_definitions_validation']=receipt
checkpoint_path=r/'docs/resume_checkpoint.json';checkpoint=json.loads(checkpoint_path.read_text(encoding='utf-8-sig'));checkpoint['saved_utc']=now.isoformat();checkpoint['announcement_definitions_validation']=receipt;checkpoint['next_action']=receipt['next_action']+' Preserve existing CRT worker/COM/TLS, custom-locale, normal mixing/device playback obligations and all 24 domains/114 tasks/37 requirements.'
write(r/'docs/announcement_definitions_validation.json',receipt);write(coverage_path,coverage);write(checkpoint_path,checkpoint)
shutil.copy2(pathlib.Path('E:/mapslol3v3/recover_announcement_definitions.py'),r/'tools/recover_announcement_definitions.py');shutil.copy2(pathlib.Path(__file__),r/'tools/record_announcement_definitions.py')
print(json.dumps(receipt))
