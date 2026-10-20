import contextlib,datetime,hashlib,json,pathlib,sqlite3,unicodedata,uuid
from instructions import make_instruction

def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def normal(s):return ''.join(c for c in unicodedata.normalize('NFKD',s.casefold()) if not unicodedata.combining(c))
def encode(v):return json.dumps(v,ensure_ascii=False,separators=(',',':'))
class Invalid(ValueError):pass
class Conflict(ValueError):pass

class Store:
    def __init__(self,root,data_dir,source_cache=None):
        self.root=pathlib.Path(root);self.data_dir=pathlib.Path(data_dir)
        self.data_dir.mkdir(parents=True,exist_ok=True);self.path=self.data_dir/'plan.sqlite3'
        self.source_cache=pathlib.Path(source_cache or r'E:\mapslol3v3\Full_project_audit_2026-10-20\official_reference')
        self.ensure_schema();self.sync_catalog()
    @contextlib.contextmanager
    def db(self):
        c=sqlite3.connect(self.path,timeout=15);c.row_factory=sqlite3.Row
        c.execute('PRAGMA foreign_keys=ON');c.execute('PRAGMA synchronous=FULL')
        try:yield c
        finally:c.close()
    def ensure_schema(self):
        with self.db() as c:
            c.execute('PRAGMA journal_mode=WAL')
            c.executescript('''
             CREATE TABLE IF NOT EXISTS meta(key TEXT PRIMARY KEY,value TEXT NOT NULL);
             CREATE TABLE IF NOT EXISTS phases(id TEXT PRIMARY KEY,ordinal INTEGER NOT NULL,data TEXT NOT NULL);
             CREATE TABLE IF NOT EXISTS packages(id TEXT PRIMARY KEY,phase TEXT NOT NULL,ordinal INTEGER NOT NULL,data TEXT NOT NULL);
             CREATE TABLE IF NOT EXISTS tasks(id TEXT PRIMARY KEY,package_id TEXT NOT NULL,phase TEXT NOT NULL,ordinal INTEGER NOT NULL,
                title TEXT NOT NULL,kind TEXT NOT NULL,source_status TEXT NOT NULL,scope_required INTEGER NOT NULL,
                search_text TEXT NOT NULL,data TEXT NOT NULL,instructions TEXT NOT NULL,active INTEGER NOT NULL DEFAULT 1);
             CREATE INDEX IF NOT EXISTS tasks_order ON tasks(active,ordinal);
             CREATE INDEX IF NOT EXISTS tasks_package ON tasks(package_id,active);
             CREATE INDEX IF NOT EXISTS tasks_phase ON tasks(phase,active);
             CREATE INDEX IF NOT EXISTS tasks_cards ON tasks(active,package_id,phase,ordinal,id,title,kind,source_status,scope_required,search_text);
             CREATE TABLE IF NOT EXISTS task_groups(task_id TEXT PRIMARY KEY,name TEXT NOT NULL);
             CREATE TABLE IF NOT EXISTS task_state(task_id TEXT PRIMARY KEY,done INTEGER NOT NULL DEFAULT 0 CHECK(done IN (0,1)),
                notes TEXT NOT NULL DEFAULT '',revision INTEGER NOT NULL DEFAULT 0,updated_at TEXT);
             CREATE TABLE IF NOT EXISTS changes(id TEXT PRIMARY KEY,created_at TEXT NOT NULL,before_json TEXT NOT NULL,after_json TEXT NOT NULL,undone INTEGER NOT NULL DEFAULT 0);
            ''');c.commit()
    def sync_catalog(self):
        a=self.root/'docs/completion_tasks_2026-10-20.json';b=self.root/'docs/execution_plan_A_Z.json'
        raw=a.read_bytes();hier=b.read_bytes()
        instruction_code=pathlib.Path(__file__).with_name('instructions.py').read_bytes()
        version=hashlib.sha256(raw+hier+instruction_code+b'listing-groups-v1').hexdigest()
        with self.db() as c:
            prior=c.execute("SELECT value FROM meta WHERE key='catalog_version'").fetchone()
            if prior and prior[0]==version:return
            tasks=json.loads(raw)['tasks'];hierarchy=json.loads(hier);alltasks={t['id']:t for t in tasks}
            if len(tasks)!=len(alltasks) or set(alltasks)!=set(hierarchy['task_to_package']):raise Invalid('Le plan et son découpage ne correspondent pas.')
            phases={p['id']:p for p in hierarchy['phases']};packages={p['id']:p for p in hierarchy['packages']}
            rows=[];ordinal=0
            for package in hierarchy['packages']:
                for ident in package['task_ids']:
                    t=alltasks[ident];phase=phases[package['phase']]
                    text=make_instruction(t,phase,package,alltasks,self.root,self.source_cache)
                    search=normal(' '.join([ident,t['title'],package['title'],phase['title'],t.get('task_group',''),str(t.get('entity') or '')]))
                    rows.append((ident,package['id'],phase['id'],ordinal,t['title'],t['kind'],t['status'],int(t['required']),search,encode(t),text,1));ordinal+=1
            c.execute('BEGIN IMMEDIATE');c.execute('UPDATE tasks SET active=0')
            c.execute('DELETE FROM phases');c.execute('DELETE FROM packages')
            c.executemany('INSERT INTO phases VALUES(?,?,?)',[(p['id'],i,encode(p)) for i,p in enumerate(hierarchy['phases'])])
            c.executemany('INSERT INTO packages VALUES(?,?,?,?)',[(p['id'],p['phase'],i,encode(p)) for i,p in enumerate(hierarchy['packages'])])
            c.executemany('''INSERT INTO tasks VALUES(?,?,?,?,?,?,?,?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET
              package_id=excluded.package_id,phase=excluded.phase,ordinal=excluded.ordinal,title=excluded.title,
              kind=excluded.kind,source_status=excluded.source_status,scope_required=excluded.scope_required,
              search_text=excluded.search_text,data=excluded.data,instructions=excluded.instructions,active=1''',rows)
            c.executemany('INSERT OR IGNORE INTO task_state(task_id,done) VALUES(?,?)',[(t['id'],int(bool(t.get('acceptance_complete')))) for t in tasks])
            c.executemany('INSERT OR REPLACE INTO task_groups VALUES(?,?)',[(t['id'],t.get('task_group','Travail')) for t in tasks])
            c.execute("INSERT OR REPLACE INTO meta VALUES('catalog_version',?)",(version,))
            c.execute("INSERT OR REPLACE INTO meta VALUES('imported_at',?)",(now(),));c.commit()
    def summary(self):
        with self.db() as c:
            stats={r['phase']:dict(r) for r in c.execute('''SELECT t.phase,COUNT(*) total,SUM(s.done) done FROM tasks t
               JOIN task_state s ON s.task_id=t.id WHERE t.active=1 GROUP BY t.phase''')}
            phases=[]
            for r in c.execute('SELECT data FROM phases ORDER BY ordinal'):
                p=json.loads(r[0]);p.update(stats[p['id']]);phases.append(p)
            last=c.execute('SELECT MAX(updated_at) FROM task_state').fetchone()[0]
            version=c.execute("SELECT value FROM meta WHERE key='catalog_version'").fetchone()[0]
            return {'app':'openleague-plan-local/v1','phases':phases,'total':sum(p['total'] for p in phases),
              'done':sum(p['done'] for p in phases),'packages':c.execute('SELECT COUNT(*) FROM packages').fetchone()[0],
              'last_saved':last,'catalog_version':version,'database_path':str(self.path)}
    def list_packages(self,phase='',query='',status='all',page=1,page_size=16):
        if phase and not self.phase_exists(phase):raise Invalid('Phase inconnue.')
        if status not in ['all','todo','done']:raise Invalid('Filtre inconnu.')
        if not 1<=page_size<=30 or page<1:raise Invalid('Pagination invalide.')
        if len(query)>200:raise Invalid('Recherche trop longue.')
        where=['t.active=1'];params=[]
        if phase:where.append('t.phase=?');params.append(phase)
        if status!='all':where.append('s.done=?');params.append(int(status=='done'))
        for term in normal(query).split()[:12]:
            value=term.replace('\\','\\\\').replace('%','\\%').replace('_','\\_')
            if len(term)==1:
                where.append("(' '||t.search_text||' ') LIKE ? ESCAPE '\\'");params.append('% '+value+' %')
            else:
                where.append("t.search_text LIKE ? ESCAPE '\\'");params.append('%'+value+'%')
        condition=' AND '.join(where)
        join='FROM tasks t INDEXED BY tasks_cards JOIN task_state s ON s.task_id=t.id JOIN packages p ON p.id=t.package_id'
        with self.db() as c:
            counts=c.execute('SELECT COUNT(*) tasks,COUNT(DISTINCT t.package_id) packages '+join+' WHERE '+condition,params).fetchone()
            pages=max(1,(counts['packages']+page_size-1)//page_size);page=min(page,pages)
            packrows=c.execute('SELECT p.id,MIN(p.ordinal) ord '+join+' WHERE '+condition+
               ' GROUP BY p.id ORDER BY ord LIMIT ? OFFSET ?',params+[page_size,(page-1)*page_size]).fetchall()
            result=[]
            for pack in packrows:
                data=json.loads(c.execute('SELECT data FROM packages WHERE id=?',(pack['id'],)).fetchone()[0])
                ts=c.execute('SELECT t.id,t.title,t.kind,t.source_status,t.scope_required,g.name task_group,s.done,s.notes,s.revision,s.updated_at '+join+' JOIN task_groups g ON g.task_id=t.id'+
                   ' WHERE '+condition+' AND t.package_id=? ORDER BY t.ordinal',params+[pack['id']]).fetchall()
                data['tasks']=[dict(t) for t in ts]
                result.append(data)
            return {'packages':result,'matched_tasks':counts['tasks'],'matched_packages':counts['packages'],'page':page,'pages':pages,'page_size':page_size}
    def phase_exists(self,phase):
        with self.db() as c:return c.execute('SELECT 1 FROM phases WHERE id=?',(phase,)).fetchone() is not None
    def task(self,ident):
        with self.db() as c:
            r=c.execute('''SELECT t.*,s.done,s.notes,s.revision,s.updated_at FROM tasks t JOIN task_state s ON s.task_id=t.id
              WHERE t.id=? AND t.active=1''',(ident,)).fetchone()
            if r is None:raise Invalid('Tâche inconnue.')
            d=dict(r);d['data']=json.loads(d['data'])
            d['dependencies']=[dict(c.execute('SELECT t.id,t.title,s.done FROM tasks t JOIN task_state s ON s.task_id=t.id WHERE t.id=?',(x,)).fetchone()) for x in d['data']['depends_on']]
            return d
    def change(self,updates,allow_archived=False):
        if not isinstance(updates,list) or not 1<=len(updates)<=100000:raise Invalid('Liste de modifications invalide.')
        ids=[u.get('id') for u in updates if isinstance(u,dict)]
        if len(ids)!=len(updates) or len(set(ids))!=len(ids):raise Invalid('Identifiants dupliqués ou invalides.')
        before=[];after=[];stamp=now();changeid=uuid.uuid4().hex
        with self.db() as c:
            c.execute('BEGIN IMMEDIATE')
            try:
                for u in updates:
                    r=c.execute('SELECT s.* FROM task_state s JOIN tasks t ON t.id=s.task_id WHERE t.id=?'+('' if allow_archived else ' AND t.active=1'),(u['id'],)).fetchone()
                    if not r:raise Invalid('Tâche inconnue : '+str(u['id']))
                    if type(u.get('revision')) is not int or u['revision']!=r['revision']:raise Conflict('La tâche a changé dans une autre fenêtre. Actualise le plan.')
                    done=u.get('done',bool(r['done']));notes=u.get('notes',r['notes'])
                    if type(done) is not bool or not isinstance(notes,str) or len(notes)>20000:raise Invalid('Statut ou notes invalides.')
                    before.append(dict(r));n={'task_id':u['id'],'done':int(done),'notes':notes,'revision':r['revision']+1,'updated_at':stamp};after.append(n)
                    c.execute('UPDATE task_state SET done=?,notes=?,revision=?,updated_at=? WHERE task_id=?',(n['done'],notes,n['revision'],stamp,u['id']))
                c.execute('INSERT INTO changes VALUES(?,?,?,?,0)',(changeid,stamp,encode(before),encode(after)));c.commit()
            except BaseException:c.rollback();raise
        return {'change_id':changeid,'updated':after,'saved_at':stamp}
    def undo(self,ident):
        with self.db() as c:
            c.execute('BEGIN IMMEDIATE');r=c.execute('SELECT * FROM changes WHERE id=?',(ident,)).fetchone()
            if not r or r['undone']:c.rollback();raise Invalid('Modification introuvable ou déjà annulée.')
            old=json.loads(r['before_json']);after=json.loads(r['after_json'])
            for a in after:
                current=c.execute('SELECT revision FROM task_state WHERE task_id=?',(a['task_id'],)).fetchone()
                if not current or current[0]!=a['revision']:c.rollback();raise Conflict('Une modification plus récente empêche cette annulation.')
            stamp=now();updated=[]
            for before,a in zip(old,after):
                n={**before,'revision':a['revision']+1,'updated_at':stamp};updated.append(n)
                c.execute('UPDATE task_state SET done=?,notes=?,revision=?,updated_at=? WHERE task_id=?',(n['done'],n['notes'],n['revision'],stamp,n['task_id']))
            c.execute('UPDATE changes SET undone=1 WHERE id=?',(ident,));c.commit()
            return {'updated':updated,'saved_at':stamp}
    def copy_text(self,kind,ident):
        if kind=='task':
            t=self.task(ident);text=t['instructions']
            if t['notes']:text+='\nNOTES DE SUIVI AJOUTÉES LOCALEMENT\n'+t['notes']+'\n'
            return {'title':t['title'],'text':text}
        with self.db() as c:
            if kind=='package':
                r=c.execute('SELECT data FROM packages WHERE id=?',(ident,)).fetchone()
                if not r:raise Invalid('Lot inconnu.')
                p=json.loads(r[0]);texts=[self.copy_text('task',tid)['text'] for tid in p['task_ids']]
                return {'title':p['title'],'text':f'LOT {ident} — {p["title"]}\nProjet : {self.root}\nTraiter les tâches de ce lot dans l’ordre de leurs dépendances.\n\n'+'\n\n' .join(texts)}
            if kind=='phase':
                r=c.execute('SELECT data FROM phases WHERE id=?',(ident,)).fetchone()
                if not r:raise Invalid('Phase inconnue.')
                p=json.loads(r[0]);lines=[f'PHASE {ident} — {p["title"]}',f'Projet : {self.root}','Référence : LoL 4.20.',
                    'OBJECTIF : '+p['deliverable'],'CONDITION DE FIN : '+p['exit_criteria'],
                    'PRÉREQUIS : '+', '.join(p['all_dependency_phases']),
                    'Traiter chaque tâche ci-dessous avec sa fiche complète du registre docs/completion_tasks_2026-10-20.json et les critères de son type. Conserver les acquis, relier preuves et binaires actuels, et garder les inconnues ouvertes.',
                    'TÂCHES DE LA PHASE :']
                for t in c.execute('SELECT id,title FROM tasks WHERE phase=? AND active=1 ORDER BY ordinal',(ident,)):lines.append(f'- {t["id"]} : {t["title"]}')
                return {'title':p['title'],'text':'\n'.join(lines)+'\n'}
        raise Invalid('Copie inconnue.')
    def export(self):
        with self.db() as c:
            rows=[dict(r) for r in c.execute('SELECT s.task_id,s.done,s.notes,s.revision,s.updated_at FROM task_state s JOIN tasks t ON t.id=s.task_id WHERE t.active=1 ORDER BY t.ordinal')]
            archived=[dict(r) for r in c.execute('SELECT s.task_id,s.done,s.notes,s.revision,s.updated_at FROM task_state s JOIN tasks t ON t.id=s.task_id WHERE t.active=0 ORDER BY t.id')]
        return {'schema':'openleague_plan_progress/v1','exported_at':now(),'catalog_version':self.summary()['catalog_version'],'tasks':rows,'archived_tasks':archived}
    def import_progress(self,data):
        if not isinstance(data,dict) or data.get('schema')!='openleague_plan_progress/v1' or not isinstance(data.get('tasks'),list):raise Invalid('Format de sauvegarde invalide.')
        archived=data.get('archived_tasks',[])
        if not isinstance(archived,list):raise Invalid('Archives de sauvegarde invalides.')
        rows=data['tasks']+archived
        if not rows or len(rows)>100000:raise Invalid('Nombre de tâches invalide.')
        with self.db() as c:
            current={r['task_id']:r['revision'] for r in c.execute('SELECT s.task_id,s.revision FROM task_state s JOIN tasks t ON t.id=s.task_id')}
        updates=[];seen=set()
        for row in rows:
            if not isinstance(row,dict) or not isinstance(row.get('task_id'),str) or row['task_id'] in seen:raise Invalid('Identifiant de sauvegarde invalide ou dupliqué.')
            seen.add(row['task_id'])
            if row['task_id'] not in current:raise Invalid('Tâche de sauvegarde inconnue : '+row['task_id'])
            d=row.get('done');notes=row.get('notes','')
            if type(d) not in [int,bool] or d not in [0,1] or not isinstance(notes,str) or len(notes)>20000:raise Invalid('Contenu de sauvegarde invalide.')
            updates.append({'id':row['task_id'],'done':bool(d),'notes':notes,'revision':current[row['task_id']]})
        return self.change(updates,allow_archived=True)
    def backup(self,path):
        with self.db() as c:
            other=sqlite3.connect(path)
            try:c.backup(other)
            finally:other.close()
