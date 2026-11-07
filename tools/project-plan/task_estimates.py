"""IA-agent planning scenarios, research provenance and real local tool anchors.

No human-day conversion, promised completion, automatic status or model changes.
"""
import argparse,collections,datetime,functools,hashlib,json,math,pathlib,re,unicodedata

VERSION='openleague-task-estimates/v2'
HERE=pathlib.Path(__file__).resolve().parent
DIFFICULTIES=['Simple','Standard','Avancée','Recherche']
# model id, full name, compact name, effort id, effort label, selection rationale
MODELS=[
 ['gpt-6-luna','GPT‑6 Luna','Luna','low','Faible','Contrôle borné et scriptable : privilégier une réponse rapide avec vérification déterministe.'],
 ['gpt-6-luna','GPT‑6 Luna','Luna','medium','Moyen','Travail ciblé à volume élevé, avec un contrat et un résultat faciles à vérifier.'],
 ['gpt-6.1-sol','GPT‑6.1 Sol','6.1 Sol','medium','Moyen','Intégration courante avec plusieurs fichiers et outils ; point de départ équilibré.'],
 ['gpt-6.1-sol','GPT‑6.1 Sol','6.1 Sol','high','Élevé','Code, transitions, tests ou sources à croiser : davantage de raisonnement et de vérification.'],
 ['gpt-6.1-sol','GPT‑6.1 Sol','6.1 Sol','xhigh','Très élevé','Analyse précise d’éléments contradictoires ; comparer le gain obtenu à l’effort Élevé.'],
 ['gpt-6-astra','GPT‑6 Astra','Astra','high','Élevé','Recherche ambiguë ou mécanisme complexe : synthèse approfondie, sans supposer les sources manquantes résolues.'],
 ['gpt-6-astra','GPT‑6 Astra','Astra','xhigh','Très élevé','Recherche critique très ambiguë ; niveau à réserver aux cas où la première passe ne suffit pas.'],
]
REASONS=[
 'Extraction ou contrôle ciblé : script déterministe, puis vérification par l’agent.',
 'Croiser la règle historique, ses valeurs et les exceptions connues.',
 'Relier ou réparer la ressource, puis contrôler son utilisation réelle.',
 'Modifier la simulation, exécuter les tests et corriger les écarts.',
 'Vérifier la réplication, la visibilité et l’autorité serveur.',
 'Intégrer la présentation, puis contrôler l’image ou le son dans le jeu.',
 'Exécuter un scénario de recette et examiner les résultats attendus et observés.',
 'Synthèse : coordination et contrôle final de cette étape, sans refaire tous les prérequis.',
 'Périmètre transversal : durée d’un premier lot IA, durée totale à recadrer après ses résultats.',
 'Mécanisme complexe : transformations, clones, chronologie ou interactions multiples.',
 'Des questions restent ouvertes : prévoir une recherche et des reprises.',
 'Source contradictoire ou recherche non bornée : une durée de résolution complète ne peut pas être garantie.',
 'Technique déclarée terminée : temps IA de préparation de la revue, hors attente de validation humaine.',
 'Concurrence, sécurité ou persistance : vérification approfondie des cas limites.',
 'Qualifier d’abord si le contenu est réellement requis ou historiquement disponible.',
]
TOOLSETS={
 'read':'Python · recherche dans les sources',
 'code':'Rust · scripts · tests ciblés',
 'network':'Rust · tests client/serveur locaux',
 'visual':'Blender ou outils du moteur · contrôle visuel',
 'audio':'Extraction audio · écoute · contrôle des événements',
 'asset':'Scripts de conversion · Blender selon le format',
 'research':'Recherche documentaire · analyse des sources · scripts',
 'qa':'Application locale · scénarios · captures',
}

def norm(v):return ''.join(x for x in unicodedata.normalize('NFKD',str(v).casefold()) if not unicodedata.combining(x))
def signature(t):
 text='\x1f'.join(str(t.get(k,'')) for k in ['id','title','kind','status'])
 h=2166136261;raw=text.encode('utf-16-le')
 for i in range(0,len(raw),2):h=((h^(raw[i]|raw[i+1]<<8))*16777619)&0xffffffff
 return h

@functools.lru_cache(maxsize=1)
def research():return json.loads((HERE/'task_estimate_research.json').read_text(encoding='utf-8'))

def duration_label(lo,hi):
 if lo>=60 and lo%60==0 and hi%60==0:return f'{lo//60}–{hi//60} h'
 return f'{lo}–{hi} min'

def estimate(t,open_questions=0):
 ident,kind=t['id'],t['kind'];title=norm(t['title']);group=norm(t.get('task_group',''))
 entity=t.get('entity') if isinstance(t.get('entity'),dict) else {}
 official=(t.get('reference_context') or {}).get('official_entry') or {}
 mechanics=norm(' '.join(str(official.get(k,'')) for k in ['description','tooltip']))
 deps=len(t.get('depends_on',[]));reasons=[];scope='task';difficulty=1
 base={
  'source':(3,9,1,'research'), 'asset':(4,12,2,'asset'),
  'simulation':(6,18,3,'code'), 'network':(6,20,4,'network'),
  'presentation':(4,14,5,'visual'), 'acceptance':(3,10,6,'qa'),
  'work':(4,12,1,'research'),
 }
 lo,hi,reason,tools=base.get(kind,base['work']);reasons=[reason]
 if kind in ['simulation','network']:difficulty=2
 small=bool(re.search(r'-(?:RANG\d+|HP|HPREGEN|MP|MPREGEN|ARMOR|SPELLBLOCK|ATTACKDAMAGE|ATTACKSPEED|MOVESPEED|CRIT|PRIX|ICONE|TEXTE|SCOPE)$',ident))
 small|=bool(re.search(r'valeur de base|sha-?256|somme de controle',title))
 if small:lo,hi,difficulty,reasons,tools=1,4,0,[0],'read'
 if entity.get('clip'):lo,hi,difficulty,reasons,tools=2,7,1,[0,5],'visual'
 if ident.startswith('EMPTY-'):
  lo,hi,difficulty,reasons,tools=(2,7,1,[14],'read') if ident.endswith('-CLASSIFY') else (4,14,2,[2,14],'asset')
 if kind=='presentation' and re.search(r'audio|voix|sons|ecouter',title):tools='audio'
 if re.search(r'reconstru|recreer|topolog|uv|squelette|retarget',title):
  lo,hi,difficulty=max(lo,6),max(hi,22),max(difficulty,2)
 complex_mechanic=bool(re.search(r'clone|transformat|possession|multi.phase|recast|reactivation|channell?ing|ressuscit|rewind',title+' '+mechanics))
 complex_mechanic|=str(entity.get('slot') or '').startswith('SEC')
 if complex_mechanic and kind in ['simulation','network','source']:
  lo+=4;hi+=14;difficulty=3;reasons.append(9)
 umbrella=ident.endswith('-KIT') or deps>=4
 if umbrella:
  lo+=2;hi+=5;difficulty=max(difficulty,2);reasons.append(7)
 broad=False;conflict=False;critical=False
 if ident.startswith('SYS-'):
  broad=bool(re.search(r'chaque exigence|tous les scripts|scripts communautaires|tous les|toutes les|exhaustif|integral|global',title))
  conflict=bool(re.search(r'retro.?ingen|decompil|assembleur|contradict|divergen|autorite historique',title))
  critical=bool(re.search(r'concurren|transaction|authentif|chiffrement|securit|anti.?triche|rollback|determin|resynchron|desynchron',title))
  if broad:
   lo,hi,difficulty,scope=max(lo,16),max(hi,40),3,'first_pass';reasons.append(8)
  if conflict:
   lo+=5;hi+=16;difficulty=3;reasons.append(11)
   if open_questions:scope='first_pass'
  if critical:lo+=3;hi+=10;difficulty=max(difficulty,2);reasons.append(13)
  if t.get('phase') in ['D19','D20','D21']:difficulty=max(difficulty,2)
 if open_questions:
  lo+=1;hi+=min(12,2+2*open_questions);reasons.append(10)
  if kind=='source' and not small:difficulty=max(difficulty,2)
 if t.get('implementation_complete') and t.get('technical_verification_complete'):
  lo,hi,difficulty,reasons,tools,scope=1,3,1,[12],'read','review'
  if open_questions:hi+=5;reasons.append(10);difficulty=2
 model=0 if difficulty==0 else 2 if difficulty==1 else 3 if difficulty==2 else 5
 if kind=='acceptance' and small and not open_questions:model=1
 if kind=='source' and small and open_questions:model=2
 if conflict and not broad:model=4
 if conflict and critical and open_questions>=3:model=6
 if difficulty==3:tools='research' if kind in ['work','source'] else tools
 # Cadence hypotheses are explicit and independent of any invented model speed.
 assumption=research()['timing_assumptions']
 minutes_lo=lo*assumption['cycle_seconds_low']/60+assumption['tool_allowance_minutes'][0]
 minutes_hi=hi*assumption['cycle_seconds_high']/60+assumption['tool_allowance_minutes'][1]
 minutes_lo=max(2,int(math.floor(minutes_lo/5)*5))
 minutes_hi=max(minutes_lo+5,int(math.ceil(minutes_hi/5)*5))
 confidence='faible' if open_questions or broad or conflict or complex_mechanic else 'indicative'
 return {'minutes_low':minutes_lo,'minutes_high':minutes_hi,'time':duration_label(minutes_lo,minutes_hi),
  'difficulty':difficulty,'model':model,'confidence':confidence,'reasons':sum(1<<i for i in set(reasons)),
  'scope':scope,'cycles_low':lo,'cycles_high':hi,'tools':tools,'open_questions':open_questions,'dependencies':deps}

def build(root,output):
 root,output=pathlib.Path(root),pathlib.Path(output)
 names=['completion_tasks_2026-10-20.json','execution_plan_A_Z.json','fidelity_unknowns_4_20.json']
 raw={n:(root/'docs'/n).read_bytes() for n in names}
 tasks=json.loads(raw[names[0]])['tasks'];hierarchy=json.loads(raw[names[1]])
 unknowns=json.loads(raw[names[2]])['unknowns']
 opened=collections.Counter(u.get('task_id') for u in unknowns if u.get('status')!='resolved')
 assert len(tasks)==len({t['id'] for t in tasks})
 assert {t['id'] for t in tasks}==set(hierarchy['task_to_package'])
 profiles=[];indexes={};rows={};counts={k:collections.Counter() for k in ['difficulty','model_effort','scope']}
 for t in tasks:
  a=estimate(t,opened[t['id']])
  p=[a[k] for k in ['minutes_low','minutes_high','difficulty','model','confidence','reasons','scope','cycles_low','cycles_high','tools']]
  key=tuple(p)
  if key not in indexes:indexes[key]=len(profiles);profiles.append(p)
  rows[t['id']]=[signature(t),indexes[key],a['open_questions'],a['dependencies']]
  counts['difficulty'][DIFFICULTIES[a['difficulty']]]+=1
  counts['model_effort'][MODELS[a['model']][2]+' / '+MODELS[a['model']][4]]+=1
  counts['scope'][a['scope']]+=1
 data={'schema':VERSION,'date':datetime.date.today().isoformat(),'sources':{n:hashlib.sha256(b).hexdigest() for n,b in raw.items()},
  'research':research(),'difficulties':DIFFICULTIES,'models':MODELS,'reasons':REASONS,'toolsets':TOOLSETS,'profiles':profiles,'tasks':rows}
 output.parent.mkdir(parents=True,exist_ok=True)
 output.write_text(json.dumps(data,ensure_ascii=False,separators=(',',':')),encoding='utf-8')
 audit={'schema':VERSION,'date':data['date'],'sources':data['sources'],'task_count':len(tasks),'profiles':len(profiles),
  'counts':{k:dict(v) for k,v in counts.items()},'basis':'AI agent cycles + tools; no human-hour conversion',
  'no_model_inference_benchmark_claimed':True,'manual_states_mutated':False,
  'full_completion_time_open_for_first_pass':True,'research':data['research']}
 output.with_name('task-estimates-audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2),encoding='utf-8')
 print(json.dumps({k:v for k,v in audit.items() if k not in ['research','sources']},ensure_ascii=True,indent=2))
 return data

def refresh_ui(root,data):
 root=pathlib.Path(root)
 safe=json.dumps(data,ensure_ascii=False,separators=(',',':')).replace('<','\\u003c').replace('>','\\u003e').replace('&','\\u0026')
 replacements={'task-estimate-data':('script','type="application/json" ',safe),
  'task-estimate-runtime':('script','',(HERE/'task_estimates_ui.js').read_text(encoding='utf-8')),
  'task-badge-styles':('style','',(HERE/'task_badges.css').read_text(encoding='utf-8'))}
 pending=[]
 for relative in ['tools/project-plan/index.html','tools/project-plan-desktop/web/index.html']:
  path=root/relative;text=path.read_text(encoding='utf-8')
  for ident,(tag,attrs,body) in replacements.items():
   text,count=re.subn(rf'<{tag}\b[^>]*\bid="{ident}"[^>]*>.*?</{tag}>',lambda m:f'<{tag} {attrs}id="{ident}">\n{body}\n</{tag}>',text,flags=re.S)
   if count!=1:raise ValueError(f'Section absente ou ambiguë : {relative}/{ident}')
  pending.append((path,text))
 for path,text in pending:path.write_text(text,encoding='utf-8',newline='\n')

if __name__=='__main__':
 parser=argparse.ArgumentParser();parser.add_argument('--root',default='E:/OpenLeague');parser.add_argument('--output',required=True);parser.add_argument('--refresh-ui',action='store_true')
 args=parser.parse_args();data=build(args.root,args.output)
 if args.refresh_ui:refresh_ui(args.root,data)
