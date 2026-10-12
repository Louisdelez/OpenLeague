from pathlib import Path
import json, hashlib, datetime, shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
proof=load('data/4.20/native_spell_icons.json');assert proof['recovered_primary_icons']==486 and proof['recovered_variant_icons']==143 and len(proof['unresolved'])==3
for entry in proof['entries']:assert sha('assets/'+entry['asset'])==entry['source_sha256']
progress=dict(updated_utc=now,passed=True,complete=False,primary_icons=486,variant_icons=143,required_primary_icons=488,unresolved=proof['unresolved'],manifest='data/4.20/native_spell_icons.json',manifest_sha256=sha('data/4.20/native_spell_icons.json'),findings=['629 native DDS images copied byte-for-byte, decoded and linked to original SpellData inventory-icon fields. No source substitution or generated replacement.','217 primary icon references absent from per-character folders were searched in the native global DATA/Spells/Icons2D directory. Ambiguous AmumuW/NunuR copies remain unresolved. HeimerdingerE InventoryIcon2 file is missing in supplied4.20tree.'],limits=proof['limits'],next_action='Qualifier le choix natif des icônes Amumu W/Nunu R et la variante manquante d’Heimerdinger ; raccorder les icônes QWER au HUD, états de rang/coût/délai et interactions, puis poursuivre le plan intégral.')
progress['tools_sha256']={'tools/recover_native_spell_icons.py':sha('tools/recover_native_spell_icons.py')}
history=r/'docs/plan_history'/('spell-icon-record-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
(r/'docs/native_spell_icons_progress.json').write_text(json.dumps(progress,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p=r/'docs'/name;shutil.copy2(p,history/name);d=load('docs/'+name);d.update(updated_utc=now,complete=False,native_spell_icons_progress='docs/native_spell_icons_progress.json')
 e=d['last_verified'] if name=='resume_checkpoint.json' else d['current_evidence'];e.update(native_qwer_primary_icons_recovered=486,native_qwer_variant_icons_recovered=143,native_qwer_icons_unresolved=3)
 if name=='resume_checkpoint.json':d.update(saved_utc=now,pending_native_jobs=[],next_projected_action=progress['next_action'])
 if name=='completion_plan.json':
  d['next_execution_steps']=[progress['next_action']]+d.get('next_execution_steps',[])
  for domain in d.get('domains',[]):
   if domain['id'] in ['02','17']:domain.setdefault('progress_evidence',[]).append('docs/native_spell_icons_progress.json')
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');assert 'id="native-spell-icons-progress"' not in s;s=s.replace('</body>','<section id="native-spell-icons-progress"><h2>Icônes QWER 4.20</h2><p>486 icônes principales sur 488 et 143 variantes récupérées et décodées. Deux références ambiguës et une variante absente restent ouvertes. Intégration graphique et états de gameplay non qualifiés.</p><a href="native_spell_icons_progress.json">Sources et limites</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_native_spell_icons.py'),r/'tools/record_native_spell_icons.py')
print(json.dumps({'primary_icons':486,'variant_icons':143,'unresolved':3,'complete':False}))
