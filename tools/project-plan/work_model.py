"""Independent audit/implementation/verification/human acceptance tracking.
No legacy checkbox is a technical or human acceptance decision.
"""
import datetime,hashlib,json,pathlib,sqlite3,uuid
APP=pathlib.Path(__file__).resolve().parent
CONTRACT=json.loads((APP/'work_contract.json').read_bytes())
TABLES=['work_assessments','work_history','work_corrections','work_journeys','work_snapshots','work_migrations']
def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def encode(v):return json.dumps(v,ensure_ascii=False,separators=(',',':'),allow_nan=False)
def require(v,message):
 if not v:raise ValueError(message)
def migrate(c):
 try:
  c.executescript('BEGIN IMMEDIATE;\n'+(APP/'work_schema.sql').read_text('utf8'))
  for j in CONTRACT['journeys']:c.execute('INSERT OR IGNORE INTO work_journeys(id,definition,updated_at) VALUES(?,?,?)',(j['id'],encode(j),now()))
  c.execute('INSERT OR IGNORE INTO work_migrations VALUES(1,?)',(now(),));c.commit()
 except BaseException:c.rollback();raise

def active(c,task_id):require(c.execute('SELECT 1 FROM tasks WHERE id=? AND active=1',(task_id,)).fetchone()is not None,'Tâche inconnue.')
def assessment(c,task_id):
 active(c,task_id);row=c.execute('SELECT audit,implementation,verification,acceptance,record,parent_task_id,revision,updated_at FROM work_assessments WHERE task_id=?',(task_id,)).fetchone()
 if row is None:return dict(task_id=task_id,**CONTRACT['defaults'],record={},parent_task_id=None,revision=0,updated_at=None,inherited=True)
 return dict(task_id=task_id,**dict(zip(['audit','implementation','verification','acceptance','record','parent_task_id','revision','updated_at'],[*row[:4],json.loads(row[4]),*row[5:]])),inherited=False)
def nonempty(v):return isinstance(v,str)and bool(v.strip())
def proof_checks(proofs):
 require(isinstance(proofs,list)and len(proofs)<=100,'Liste de preuves invalide.')
 for v in proofs:
  require(isinstance(v,dict)and all(nonempty(v.get(k))for k in ['path','sha256','kind','verified_utc']),'Preuve : chemin,empreinte,nature et date requis.')
  p=pathlib.Path(v['path']);require(p.is_absolute()and p.is_file(),'Fichier de preuve introuvable : '+str(p))
  with p.open('rb')as f:actual=hashlib.file_digest(f,'sha256').hexdigest()
  require(actual==v['sha256'],'Empreinte de preuve différente : '+str(p))
def validate_assessment(c,task_id,body):
 require(isinstance(body,dict),'Évaluation invalide.');record=body.get('record',{});require(isinstance(record,dict)and len(encode(record))<=262144,'Compte rendu invalide ou trop volumineux.')
 for k,values in CONTRACT['dimensions'].items():require(body.get(k)in values,'Statut '+k+' invalide.')
 proofs=record.get('proofs',[]);proof_checks(proofs)
 if body['audit']=='termine_avec_preuves':
  require(all(nonempty(record.get(k))for k in CONTRACT['audit_fields']),'Les sept rubriques de clôture doivent être documentées.')
  require(nonempty(record.get('reviewer'))and nonempty(record.get('reviewed_utc'))and proofs,'Relecture datée et preuves requises pour clore un audit.')
  require(type(record.get('has_gaps'))is bool,'Préciser si des corrections sont nécessaires.')
  ids=record.get('correction_ids',[]);require(isinstance(ids,list)and len(set(ids))==len(ids),'Liens de correction invalides.')
  if record['has_gaps']:require(ids,'Relier les écarts à au moins une correction précise.')
  else:require(nonempty(record.get('no_correction_reason')),'Justifier l’absence de correction.')
  for ident in ids:require(c.execute('SELECT 1 FROM work_corrections WHERE id=? AND task_id=?',(ident,task_id)).fetchone(),'Correction non reliée à cette exigence.')
 if body['audit']=='bloque':
  b=record.get('blocker',{});require(isinstance(b,dict)and b.get('kind')in CONTRACT['blocker_kinds']and all(nonempty(b.get(k))for k in ['required_input','resume_condition','impact']),'Décrire la nature,entrée indispensable,impact et condition de reprise.')
 if body['verification']=='reussie':
  require(nonempty(record.get('verification_scope'))and proofs,'Périmètre vérifié et preuves requis.')
  controls=record.get('controls',[]);require(isinstance(controls,list)and controls and all(isinstance(x,dict)and all(nonempty(x.get(k))for k in ['name','expected','observed','execution_kind'])and x.get('outcome')=='passed'for x in controls),'Contrôles attendus/observés réussis et leur nature requis.')
 if body['acceptance']=='non_applicable':require(nonempty(record.get('acceptance_justification')),'Justification de non-applicabilité requise.')
 if body['acceptance']in ['acceptee','refusee']:require(nonempty(record.get('human_decision')),'Décision humaine explicite et référence requises.')
 parent=body.get('parent_task_id')
 if parent:
  active(c,parent);require(parent!=task_id,'Une tâche ne peut pas être son parent.');seen={task_id};cursor=parent
  while cursor:
   require(cursor not in seen,'Cycle parent/enfant refusé.');seen.add(cursor);r=c.execute('SELECT parent_task_id FROM work_assessments WHERE task_id=?',(cursor,)).fetchone();cursor=r[0]if r else None
 return record

def change(c,task_id,body):
 c.execute('BEGIN IMMEDIATE')
 try:
  before=assessment(c,task_id);require(type(body.get('revision'))is int and body['revision']==before['revision'],'Conflit de révision : actualiser l’évaluation.')
  record=validate_assessment(c,task_id,body);after={k:body[k]for k in CONTRACT['dimensions']};after.update(task_id=task_id,record=record,parent_task_id=body.get('parent_task_id'),revision=before['revision']+1,updated_at=now(),inherited=False)
  c.execute('INSERT INTO work_assessments VALUES(?,?,?,?,?,?,?,?,?) ON CONFLICT(task_id) DO UPDATE SET audit=excluded.audit,implementation=excluded.implementation,verification=excluded.verification,acceptance=excluded.acceptance,record=excluded.record,parent_task_id=excluded.parent_task_id,revision=excluded.revision,updated_at=excluded.updated_at',(task_id,*[after[k]for k in CONTRACT['dimensions']],encode(record),after['parent_task_id'],after['revision'],after['updated_at']))
  c.execute('INSERT INTO work_history VALUES(?,?,?,?,?)',(uuid.uuid4().hex,task_id,encode(before),encode(after),now()));c.commit()
 except BaseException:c.rollback();raise
 return after

def atomic(function):
 def run(c,*args,**kwargs):
  c.execute('BEGIN IMMEDIATE')
  try:
   result=function(c,*args,**kwargs)
   if c.in_transaction:c.commit()
   return result
  except BaseException:c.rollback();raise
 return run
CORRECTION_FIELDS=['expected_behavior','sources','source_limits','consumers','prerequisites','dependencies','work_steps','done_criteria','checks','expected_evidence','resume_condition']
@atomic
def correction(c,body):
 task_id=body.get('task_id');active(c,task_id);objective=body.get('objective');require(nonempty(objective),'Objectif unique requis.');record=body.get('record');require(isinstance(record,dict)and all(nonempty(record.get(k))or isinstance(record.get(k),list)and record[k]for k in CORRECTION_FIELDS),'Fiche de correction incomplète.')
 ident='FIX-'+hashlib.sha256((task_id+'\n'+objective.strip()).encode()).hexdigest()[:20];old=c.execute('SELECT revision FROM work_corrections WHERE id=?',(ident,)).fetchone();revision=old[0]if old else 0;require(body.get('revision',0)==revision,'Conflit de correction.')
 implementation=body.get('implementation','non_evaluee');verification=body.get('verification','non_executee');require(implementation in CONTRACT['dimensions']['implementation']and verification in CONTRACT['dimensions']['verification'],'Statut de correction invalide.')
 if record.get('existing_task_id'):active(c,record['existing_task_id'])
 if verification=='reussie':
  require(nonempty(record.get('verification_scope'))and record.get('proofs'),'Périmètre et preuves de correction requis.');proof_checks(record['proofs'])
  controls=record.get('controls',[]);require(controls and all(isinstance(x,dict)and all(nonempty(x.get(k))for k in ['name','expected','observed','execution_kind'])and x.get('outcome')=='passed'for x in controls),'Contrôles réussis de correction requis.')
 parent=body.get('parent_id');require(parent!=ident,'Parent de correction invalide.')
 if parent:
  seen={ident};cursor=parent
  while cursor:
   require(cursor not in seen,'Cycle de corrections refusé.');seen.add(cursor);r=c.execute('SELECT parent_id FROM work_corrections WHERE id=?',(cursor,)).fetchone();require(r is not None,'Parent de correction inconnu.');cursor=r[0]
 old_record=c.execute('SELECT * FROM work_corrections WHERE id=?',(ident,)).fetchone()
 c.execute('INSERT INTO work_corrections VALUES(?,?,?,?,?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET record=excluded.record,parent_id=excluded.parent_id,implementation=excluded.implementation,verification=excluded.verification,revision=excluded.revision,updated_at=excluded.updated_at',(ident,task_id,objective.strip(),encode(record),parent,implementation,verification,revision+1,now()));after=c.execute('SELECT * FROM work_corrections WHERE id=?',(ident,)).fetchone();c.execute('INSERT INTO work_history VALUES(?,?,?,?,?)',(uuid.uuid4().hex,ident,encode(list(old_record)if old_record else None),encode(list(after)),now()));c.commit();return dict(id=ident,revision=revision+1)
def definitions(c):return [dict(id=r[0],definition=json.loads(r[1]),verification=r[2],record=json.loads(r[3]),revision=r[4],updated_at=r[5])for r in c.execute('SELECT * FROM work_journeys ORDER BY id')]
@atomic
def journey(c,ident,body):
 row=c.execute('SELECT definition,revision FROM work_journeys WHERE id=?',(ident,)).fetchone();require(row,'Parcours inconnu.');definition=json.loads(row[0]);require(body.get('revision')==row[1],'Conflit de parcours.');status=body.get('verification');require(status in CONTRACT['dimensions']['verification'],'Statut de parcours invalide.');record=body.get('record',{});require(isinstance(record,dict),'Compte rendu invalide.')
 if status=='reussie':
  require(record.get('execution_kind')==definition['required_execution'],'Le parcours requiert une exécution dans le client réel.');require(set(definition['criteria'])<=set(record.get('passed_criteria',[])),'Un fragment ne clôture pas le parcours.');require(record.get('proofs')and nonempty(record.get('scope')),'Périmètre et preuves du parcours requis.');proof_checks(record['proofs'])
 old_record=c.execute('SELECT * FROM work_journeys WHERE id=?',(ident,)).fetchone()
 c.execute('UPDATE work_journeys SET verification=?,record=?,revision=revision+1,updated_at=? WHERE id=?',(status,encode(record),now(),ident));after=c.execute('SELECT * FROM work_journeys WHERE id=?',(ident,)).fetchone();c.execute('INSERT INTO work_history VALUES(?,?,?,?,?)',(uuid.uuid4().hex,ident,encode(list(old_record)),encode(list(after)),now()));c.commit();return dict(id=ident,revision=row[1]+1)
def metrics(c):
 excluded=CONTRACT['audit_exclusions'];placeholders=','.join('?'for _ in excluded)
 where='t.active=1 AND t.id NOT IN ('+placeholders+') AND NOT EXISTS(SELECT 1 FROM work_assessments child JOIN tasks ct ON ct.id=child.task_id AND ct.active=1 WHERE child.parent_task_id=t.id)'
 count=c.execute('SELECT COUNT(DISTINCT t.id),COALESCE(SUM(CASE WHEN a.audit=\'termine_avec_preuves\' THEN 1 ELSE 0 END),0) FROM tasks t LEFT JOIN work_assessments a ON a.task_id=t.id WHERE '+where,excluded).fetchone();total,done=count
 correction_counts=c.execute("SELECT COUNT(*),COALESCE(SUM(implementation='implementee' AND verification='reussie'),0) FROM work_corrections p WHERE NOT EXISTS(SELECT 1 FROM work_corrections child WHERE child.parent_id=p.id)").fetchone();journeys=c.execute("SELECT COUNT(*),COALESCE(SUM(verification='reussie'),0) FROM work_journeys").fetchone();blockers={}
 for(r,)in c.execute("SELECT record FROM work_assessments a JOIN tasks t ON t.id=a.task_id WHERE t.active=1 AND t.id!='SYS-01.2-02' AND a.audit='bloque' AND NOT EXISTS(SELECT 1 FROM work_assessments child JOIN tasks ct ON ct.id=child.task_id AND ct.active=1 WHERE child.parent_task_id=t.id)"):
  kind=json.loads(r).get('blocker',{}).get('kind','indetermine');blockers[kind]=blockers.get(kind,0)+1
 def item(n,d,exclusions,rule,limit):return dict(numerator=n,denominator=d,percent=round(n*100/d,2)if d else None,exclusions=exclusions,aggregation=rule,limits=limit)
 return dict(audits=item(done,total,excluded+['archives','parents déclarés','phases et lots'],'Une fois par ID actif atomique.','La clôture d’audit ne termine pas sa fonctionnalité.'),corrections=item(correction_counts[1],correction_counts[0],['parents de corrections'],'Feuilles implémentées et vérifiées.','Inventaire des corrections encore en cours.'),journeys=item(journeys[1],journeys[0],['fragments','simulations et exécutions isolées'],'Tous les critères du parcours réel.','Valable uniquement pour le périmètre et les preuves enregistrés.'),blockers=dict(total=sum(blockers.values()),by_kind=blockers),historical_links=historical_coverage(c))
def snapshot(c):
 value=metrics(c);value['evidence_sets']=evidence_sets(c);ident=uuid.uuid4().hex;c.execute('INSERT INTO work_snapshots VALUES(?,?,?)',(ident,now(),encode(value)));c.commit();return dict(id=ident,metrics=value)
def copy_context(c,task_id):
 a=assessment(c,task_id);return '\n\nSUIVI INDÉPENDANT DE CETTE EXIGENCE\n'+encode(a)+'\nRègle de clôture : un audit terminé documente ses sources ou recherches,consommateurs ou absence,contrôles,écarts,corrections et preuves. Il peut être terminé avec une fonctionnalité absente. Les statuts hérités et cases cochées ne prouvent ni vérification ni acceptation humaine. Cadrage : docs/audit/AUDIT_CHARTER.md.\n'

def historical_coverage(c):
 r=c.execute("SELECT value FROM meta WHERE key='historical_link_coverage'").fetchone()
 return json.loads(r[0])if r else dict(available=False,limits='Instantané historique non importé ; aucun pourcentage de jeu déduit.')
def export_work(c):
 tables={}
 for name in TABLES:
  columns=[r[1]for r in c.execute('PRAGMA table_info('+name+')')];tables[name]=dict(columns=columns,rows=[list(r)for r in c.execute('SELECT * FROM '+name+' ORDER BY '+columns[0])])
 return dict(schema='openleague_work_backup/v1',created_at=now(),tables=tables)
def rollback(c):
 archive=export_work(c);c.commit();foreign=c.execute('PRAGMA foreign_keys').fetchone()[0];c.execute('PRAGMA foreign_keys=OFF')
 try:
  c.execute('BEGIN IMMEDIATE')
  for name in reversed(TABLES):c.execute('DROP TABLE '+name)
  c.commit()
 except BaseException:c.rollback();raise
 finally:c.execute('PRAGMA foreign_keys='+str(foreign))
 return archive

def proof_identity(path,kind='document_review'):
 p=pathlib.Path(path);require(p.is_absolute()and p.is_file(),'Fichier de preuve introuvable.')
 with p.open('rb')as f:sha=hashlib.file_digest(f,'sha256').hexdigest()
 return dict(path=str(p),bytes=p.stat().st_size,sha256=sha,kind=kind,verified_utc=now())

def correction_instruction(c,ident):
 row=c.execute('SELECT * FROM work_corrections WHERE id=?',(ident,)).fetchone();require(row is not None,'Correction inconnue.');names=[r[1]for r in c.execute('PRAGMA table_info(work_corrections)')];v=dict(zip(names,row));record=json.loads(v['record']);labels=dict(expected_behavior='COMPORTEMENT ATTENDU',sources='SOURCES UTILISABLES',source_limits='LIMITES DES SOURCES',consumers='FICHIERS ET CONSOMMATEURS INSPECTÉS',prerequisites='PRÉREQUIS',dependencies='DÉPENDANCES',work_steps='TRAVAIL À EFFECTUER',done_criteria='CRITÈRES DE FIN',checks='CONTRÔLES À EXÉCUTER',expected_evidence='PREUVES ATTENDUES',resume_condition='CONDITION DE REPRISE')
 lines=['Réalise cette correction OpenLeague explicitement délimitée.','IDENTIFIANT : '+v['id'],'EXIGENCE AUDITÉE : '+v['task_id'],'OBJECTIF UNIQUE : '+v['objective'],'PROJET : F:/OpenLeague','Conserve les identifiants,modifications,preuves,cases,notes et historiques existants.']
 for key,label in labels.items():lines+=['',label,str(record[key])]
 lines+=['','ÉTATS INDÉPENDANTS','Implémentation : '+v['implementation']+' ; vérification : '+v['verification']+'.','L’audit de l’exigence et son acceptation humaine ne sont pas clôturés automatiquement par cette correction.','Décrire le périmètre réellement vérifié et les limites restantes ; relier les preuves identifiées.']
 return dict(title=v['objective'],text='\n'.join(lines)+'\n')

def evidence_sets(c):
 exclude=CONTRACT['audit_exclusions'];where="t.active=1 AND t.id NOT IN ("+','.join('?'for _ in exclude)+") AND NOT EXISTS(SELECT 1 FROM work_assessments child JOIN tasks ct ON ct.id=child.task_id AND ct.active=1 WHERE child.parent_task_id=t.id)"
 def ids(sql,args=()):return sorted(r[0]for r in c.execute(sql,args))
 return dict(audits=ids("SELECT t.id FROM tasks t JOIN work_assessments a ON a.task_id=t.id WHERE "+where+" AND a.audit='termine_avec_preuves'",exclude),corrections=ids("SELECT id FROM work_corrections p WHERE implementation='implementee' AND verification='reussie' AND NOT EXISTS(SELECT 1 FROM work_corrections child WHERE child.parent_id=p.id)"),journeys=ids("SELECT id FROM work_journeys WHERE verification='reussie'"),blockers=ids("SELECT t.id FROM tasks t JOIN work_assessments a ON a.task_id=t.id WHERE t.active=1 AND t.id!='SYS-01.2-02' AND a.audit='bloque' AND NOT EXISTS(SELECT 1 FROM work_assessments child JOIN tasks ct ON ct.id=child.task_id AND ct.active=1 WHERE child.parent_task_id=t.id)"),gaps=ids('SELECT id FROM work_corrections'))
def weekly(c):
 cutoff=(datetime.datetime.now(datetime.timezone.utc)-datetime.timedelta(days=7)).isoformat();row=c.execute('SELECT created_at,data FROM work_snapshots WHERE created_at<=? ORDER BY created_at DESC LIMIT 1',(cutoff,)).fetchone()
 if not row:return dict(comparison_available=False,reason='Aucun instantané datant d’au moins sept jours ; aucun bilan rétrospectif inventé.',current=metrics(c))
 baseline=json.loads(row[1]);sets=baseline.get('evidence_sets');require(isinstance(sets,dict),'Ancien instantané sans identifiants : comparaison indisponible.');current=evidence_sets(c);result={}
 for key in ['audits','corrections','journeys','gaps']:result[key]=len(set(current[key])-set(sets[key]))
 result['blockers_lifted']=len(set(sets['blockers'])-set(current['blockers']));result['new_blockers']=len(set(current['blockers'])-set(sets['blockers']));result['audits_reopened']=len(set(sets['audits'])-set(current['audits']))
 return dict(comparison_available=True,baseline_at=row[0],current_at=now(),results=result,baseline_denominator=baseline['audits']['denominator'],current_denominator=metrics(c)['audits']['denominator'],limits='Comparaison des identifiants,clôtures encore effectives à la date courante. Nouvelles lacunes : corrections distinctes enregistrées. Les réouvertures et changements de dénominateur sont signalés.')

def restore_work(c,archive):
 require(isinstance(archive,dict)and archive.get('schema')=='openleague_work_backup/v1'and set(archive.get('tables',{}))==set(TABLES),'Archive de méthode invalide.')
 migrate(c)
 for name in ['work_assessments','work_history','work_corrections','work_snapshots']:require(c.execute('SELECT COUNT(*) FROM '+name).fetchone()[0]==0,'Restauration réservée à une méthode vide ; données existantes conservées.')
 for name in TABLES:require(archive['tables'][name]['columns']==[r[1]for r in c.execute('PRAGMA table_info('+name+')')],'Schéma de restauration incompatible.')
 c.commit();foreign=c.execute('PRAGMA foreign_keys').fetchone()[0];c.execute('PRAGMA foreign_keys=OFF')
 try:
  c.execute('BEGIN IMMEDIATE');c.execute('DELETE FROM work_journeys');c.execute('DELETE FROM work_migrations')
  for name in TABLES:
   rows=archive['tables'][name]['rows'];columns=archive['tables'][name]['columns']
   if rows:c.executemany('INSERT INTO '+name+' VALUES('+','.join('?'for _ in columns)+')',rows)
  require(not c.execute('PRAGMA foreign_key_check').fetchall(),'Liens invalides dans la restauration.');c.commit()
 except BaseException:c.rollback();raise
 finally:c.execute('PRAGMA foreign_keys='+str(foreign))
 return dict(restored=True,tables=TABLES)
