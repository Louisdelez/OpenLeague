"""Map10 objectives: exact source links and bounded current consumers, not gameplay acceptance."""
import hashlib,json,math,pathlib,re,struct,sys
R=pathlib.Path('E:/OpenLeague');sys.path[:0]=[str(R/'tools/project-plan'),str(R/'tools')]
from audit_navigation_reference import pin,load,require
from audit_structures_reference import functions
from native_lua import initialization
from reference_inibin import read,hashkey
from rads_reference_membership import RadsReferenceMembership
TARGETS=[f'SYS-10.4-{i:02}' for i in range(1,16)]
BOUNDARIES=set(TARGETS[9:13])
LOCAL=['crates/core/src/altars.rs','crates/core/src/interactions.rs','crates/core/src/world.rs','crates/core/src/progression.rs','crates/core/src/movement.rs','crates/core/src/vilemaw_attacks.rs','crates/core/src/spells.rs','crates/client/src/main.rs','crates/client/src/animation.rs','crates/client/src/vilemaw_attack_animation.rs','crates/client/src/entity_orientation.rs','crates/core/src/lifecycle.rs']
SPECS={
 TARGETS[0]:[(0,'pub(crate) fn initial('),(0,'pub(crate) fn advance('),(1,'crate::altars::advance(')],
 TARGETS[1]:[(0,'pub(crate) fn initial('),(0,'pub(crate) fn advance('),(1,'crate::altars::advance(')],
 TARGETS[2]:[(0,'if present[0] && present[1] {'),(0,'if altar.capturing != active {')],
 TARGETS[3]:[(0,'if tick < altar.locked_until {'),(0,'altar.locked_until = tick + spells::seconds(config().lock_seconds);')],
 TARGETS[4]:[(0,'pub(crate) fn altar_kill_bonus('),(2,'let altar_bonus = if kind.lane()')],
 TARGETS[5]:[(0,'pub(crate) fn altar_damage_multiplier('),(3,'pub(crate) fn ad_components('),(3,'ability_power: items.ability_power * self.altar_damage_multiplier(p.team),')],
 TARGETS[6]:[(1,'relic_ready_tick: spells::seconds(c.relic_initial_seconds),'),(1,'i.state.relic_available = self.tick >= i.state.relic_ready_tick;')],
 TARGETS[7]:[(1,'pub fn relic_haste('),(1,'let level = p.level.saturating_sub(1) as f32;'),(4,'flat * (1. + q + heal + interactions::relic_haste(p, tick)')],
 TARGETS[8]:[(1,'i.state.relic_ready_tick = self.tick + spells::seconds(c.relic_respawn_seconds);'),(1,'.then(a.id.cmp(&b.id))')],
 TARGETS[9]:[(5,'pub(crate) fn begin_vilemaw_attack('),(5,'return Err(Error::NonBasic);')],
 TARGETS[10]:[(2,'let stationary_vilemaw = vilemaw_attacks::is_vilemaw(unit)'),(5,'attack::Kind::Basic, audience);'),(9,'pub fn selection(')],
 TARGETS[11]:[(2,'let killing_team = self.target_info(source)'),(6,'pub struct Effects {')],
 TARGETS[12]:[(6,'pub struct Effects {'),(11,'p.effects = Default::default();')],
 TARGETS[13]:[(2,'member.facing,'),(7,'.with_rotation(Quat::from_rotation_y(unit.facing))'),(10,'pub fn apply(transform:')],
 TARGETS[14]:[(8,'state.vilemaw_visuals.selection('),(9,'pub fn selection('),(7,'.with_rotation(Quat::from_rotation_y(unit.facing))')]
}
FINDINGS={
 TARGETS[0]:('Les autels sont nommés ouest/est et commencent neutres ; les équipes0 et1 partagent advance, avec présence vivante dans un rayon et une cadence uniques. Bleu ne désigne pas une propriété native fixe de l’autel ouest.','Qualifier centres de déclenchement,rayon,durée et règles multijoueurs historiques ; distinguer emplacement et équipe propriétaire.'),
 TARGETS[1]:('La même machine de capture accepte l’équipe1 et les deux positions ouest/est. Les centres sont déclarés dérivés du maillage,le rayon500 et la durée8secondes reconstruits.','Qualifier les déclencheurs et règles côté serveur pour les deux équipes ; ne pas déduire une propriété rouge permanente de la position est.'),
 TARGETS[2]:('Deux présences adverses suspendent la progression sans la remettre à zéro ; absence,propriétaire présent ou changement de capturant réinitialisent le compteur par des branches distinctes.','Qualifier la conservation de progression,les interruptions et l’effet du nombre de champions contre le moteur historique ; scripts clients bornés sans callbacks ne suffisent pas.'),
 TARGETS[3]:('Le code bloque avant locked_until,initialement180secondes,puis fixe90secondes depuis la capture. Les textes natifs annoncent90secondes après capture.','Qualifier l’horloge initiale,les frontières de tick et les comportements moteur ; un texte d’annonce ne prouve pas le scheduler.'),
 TARGETS[4]:('Au moins un autel donne3or sur les derniers coups de sbires/monstres/boss via damage_unit et combat_owner. Les textes distinguent bonus actifs et grisés,et indiquent aussi une régénération de mana.','Qualifier tous les bénéficiaires et événements ; retrouver le producteur de régénération de mana et la récompense de capture au-delà de ce bonus de dernier coup.'),
 TARGETS[5]:('Deux autels multiplient le total AD base+croissance+objets par1.1,et l’AP des objets par1.1. Le texte natif dit10% Bonus Attack Damage et10% Ability Power.','Résoudre la différence bonusAD/totalAD avec le producteur natif ; qualifier toutes les sources AP et interactions. Ne pas présenter le multiplicateur courant comme fidèle.'),
 TARGETS[6]:('Le consommateur initialise la relique indisponible jusqu’à180secondes. Le callback natif porte95,et le dossier camp antérieur conserve l’écart85 sans qualifier l’ancrage moteur.','Qualifier l’origine historique de l’horloge et le temps absolu ; ne pas transformer95+85 en preuve d’apparition à180.'),
 TARGETS[7]:('Le ramassage applique94+13*(niveau-1) santé et90+14*(niveau-1) mana plafonnés,avec filtre de ressource et soins reçus ; haste20% décroît linéairement sur5secondes. Les nombres de soin viennent du code communautaire,le texte natif ne confirme que20% et une décroissance.','Qualifier coefficients4.20,portée175,durée5,courbe et cumul vitesse ; le code communautaire porte encore TODO pour la décroissance.'),
 TARGETS[8]:('Le joueur vivant le plus proche gagne le ramassage,avec id comme départage ; ready_tick est repoussé de90secondes. Le champ natif de respawn du camp7 vaut90.','Qualifier le callback de ramassage/mort,les unités et l’horloge du moteur ; l’ancien essai réseau ne couvre pas un second ramassage réel.'),
 TARGETS[9]:('Les INIBIN distinguent Attack1,Melee1,Melee2 etWebReel ; les scripts client contiennent des métadonnées et parfois aucun corps. Le canal courant n’accepte que Kind::Basic et refuse NonBasic.','Qualifier les callbacks serveur,aires,coefficients et sélection des attaques spéciales ; la présence d’un nom/clip ne vaut pas implémentation.'),
 TARGETS[10]:('La logique courante est une attaque générique,avec retrait local pour le boss immobile et un journal de présentation Basic. Le catalogue expose WebReel/Smash mais le sélecteur ordinaire rend le rôle attack.','Relier une vraie machine de transitions et chaque sort spécial ; les rôles spell1/spell2 du catalogue ne prouvent pas un dispatch courant.'),
 TARGETS[11]:('damage_unit crédite or/XP et nettoie l’unité ; Effects ne porte pas de buff Vilemaw dans le code inspecté. TT_BossBuff déclare une icône,un effet et NonDispellable ; le texte annonce régénération,AS etCDR.','Identifier et relier attribution à l’équipe,durée,coefficients et bénéficiaires ; ne pas déduire une durée de NonDispellable ni confondre récompense et buff.'),
 TARGETS[12]:('Le reset générique des effets à la réapparition existe,mais aucun état de buff Vilemaw n’est identifié dans Effects. TT_BossBuff n’a pas de clé PersistsThroughDeath dans ses globals lus.','Qualifier la valeur par défaut native et les callbacks décès/expiration ; absence de clé ne signifie ni false ni une règle de suppression établie.'),
 TARGETS[13]:('Camp8 utilise le vecteur natif position→face et un angle atan2 transmis au spawn puis au quaternion client. Ensuite la rotation provient du déplacement ; delta nul conserve la pose.','Qualifier le repère anatomique du maillage et la projection de la vue de référence : un angle source ne prouve pas que l’arrière apparaît en bas à l’écran.'),
 TARGETS[14]:('Le GLB expose28clips ; attack pointe TT_Spiderboss_attack1. La présentation Basic utilise l’âge de l’événement et la durée du clip chargé,indépendamment de l’impact. La rotation initiale et le déplacement restent des chemins distincts.','Vérifier en rendu courant attaque,poses et anatomie après rotation ; qualifier les variantes directionnelles et les sorts spéciaux séparément. Aucun rendu nouveau dans ce lot.')
}
def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='objectives_'+tid.replace('-','_').replace('.','_')+'_'+str(i))

def _collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 m=RadsReferenceMembership(root)
 for x in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[z['identity'] for z in m.manifests],*m.provenance]:keep(x['path'])
 def native(logical):
  p=m.deploy/logical;s=keep(p);member=m.inspect(logical,p,s);check('membership_'+logical,member['status']=='matches_selected_project_manifest');return dict(source=s,membership=member)
 names=sorted(p.name for p in (m.deploy/'DATA/Spells').glob('*.luaobj') if any(w in p.name.lower() for w in ['treelinelantern','treelinemaster','tt_spiderboss','tt_boss','tt_relic','tt_speedshrine']))
 paths=['DATA/Spells/'+n for n in names]+[f'DATA/Characters/{n}/Scripts/CharScript{n}.luaobj' for n in ['TT_Buffplat_L','TT_Buffplat_R','TT_Relic','TT_Spiderboss']]+['LEVELS/Map10/Scripts/NeutralMinionSpawn.luaobj']
 scripts={}
 for path in paths:
  s=native(path);top,fs=functions(pathlib.Path(s['source']['path']).read_bytes());rows=[]
  for n,f in fs.items():rows.append(dict(name=n,constants=f['constants'],opcodes=[w&63 for w in f['code']],words_sha256=hashlib.sha256(struct.pack('<'+'I'*len(f['code']),*f['code'])).hexdigest()))
  scripts[path]=dict(**s,functions=rows,top_constants=top['constants'],initialization=json.loads(json.dumps(initialization(top))),source_only=True)
  check('script_'+path,True)
 boss=scripts['DATA/Spells/TT_BossBuff.luaobj']['initialization']['globals'];check('boss_buff_not_death_policy',boss['NonDispellable'] is True and 'PersistsThroughDeath' not in boss)
 neutral=scripts[paths[-1]];ng=neutral['initialization']['globals']
 check('partial_neutral_initialization',neutral['initialization']['stopped']=={'pc':364,'opcode':20})
 tooltips=load(root/'data/4.20/native_tooltips_map10.json');font=native(tooltips['native_resource']);raw=pathlib.Path(font['source']['path']).read_bytes();check('native_tooltip_hash',font['source']['sha256']==tooltips['source_sha256'])
 text=raw.decode('utf-8-sig');lines=text.splitlines()
 for row in tooltips['rows']:check('tooltip_'+row['key'],row['key'] in lines[row['line']-1] and row['text'] in lines[row['line']-1])
 config=load(root/'data/4.20/altars_map10.json');inter=load(root/'data/4.20/map10_interactions.json');world=load(root/'data/4.20/map10_world.json')
 provenance=[]
 for obj in [config,inter]:
  for entry in obj['sources']:
   p=pathlib.Path(entry['path']);p=p if p.is_absolute() else root/p;s=keep(p);check('declared_provenance_'+p.name,s['sha256']==entry['sha256']);provenance.append(dict(source=s,declared=entry,authority='community_or_local_declared_source_not_native_server'))
 check('altar_local_values',(config['unlock_seconds'],config['lock_seconds'],config['capture_seconds'],config['capture_radius'],config['unit_kill_bonus_gold'],config['two_altar_damage_percent'])==(180,90,8,500,3,.1))
 check('relic_local_values',[inter[k] for k in ['relic_initial_seconds','relic_respawn_seconds','relic_pickup_radius','relic_health_base','relic_health_per_level','relic_mana_base','relic_mana_per_level','relic_haste_seconds','relic_haste_percent']]==[180,90,175,94,13,90,14,5,.2])
 relic=ng['CampSpawnPoints']['7']['1'];check('relic_position',inter['relic_position']=={'x':relic['x'],'z':relic['z']} and inter['relic_height']==relic['y'])
 camp=next(c for c in world['camps'] if c['index']==8);b=camp['members'][0];pos=ng['CampSpawnPoints']['8']['1'];face=ng['CampFacePoints']['8']['1'];yaw=math.atan2(face['x']-pos['x'],face['z']-pos['z']);check('boss_position_and_facing',b['position']=={'x':pos['x'],'z':pos['z']} and b['height']==pos['y'] and abs(b['facing']-yaw)<1e-12)
 spells=[];fields=['AnimationName','CastRange','CooldownTime','DelayCastOffsetPercent','Effect1Level1','Effect2Level1','ManaCost1','MissileSpeed']
 for name in ['TT_SpiderbossAttack','TT_SpiderbossAttack2','TT_SpiderbossAttack3','TT_SpiderbossVortex']:
  s=native('DATA/Spells/'+name+'.inibin');v=read(s['source']['path']);rows=[]
  for f in fields:rows.append(dict(field='SpellData.'+f,present=hashkey('SpellData',f) in v,value=v.get(hashkey('SpellData',f))));checks.append('spell_'+name+'_'+f)
  spells.append(dict(name=name,**s,fields=rows))
 catalog=load(root/'data/4.20/world_animation_manifest.json')['TT_Spiderboss'];model=keep(root/'assets'/catalog['asset']);raw=pathlib.Path(model['path']).read_bytes();length=struct.unpack_from('<I',raw,12)[0];glb=json.loads(raw[20:20+length]);clips=[a['name'] for a in glb['animations']];check('boss28clips',clips==catalog['clips'] and len(clips)==28)
 for role,index in catalog['roles'].items():check('boss_role_'+role,0<=index<len(clips))
 check('boss_basic_clip',clips[catalog['roles']['attack']]=='TT_Spiderboss_attack1')
 anim=[]
 for name in clips:
  s=native('DATA/Characters/TT_Spiderboss/Animations/'+name+'.anm');anim.append(dict(name=name,**s))
 blend=native('DATA/Characters/TT_Spiderboss/TT_Spiderboss.blnd')
 current={p:(root/p).read_text(encoding='utf8') for p in LOCAL}
 for name,idx,needles in [
 ('altar_capture',0,['if tick < altar.locked_until','if present[0] && present[1]','altar.contested = true;','altar.progress_ticks += 1;','altar.owner = active;','p.team < 2 && p.health > 0.']),
 ('bonus_totalAD',3,['let existing = (base + growth * factor + item) * altar;','ability_power: items.ability_power * self.altar_damage_multiplier(p.team),']),
 ('relic_pickup',1,['.then(a.id.cmp(&b.id))','lifecycle::restores_resource(&p.champion)','healing::received_multiplier(p,self.tick)','c.relic_health_base + c.relic_health_per_level * level','c.relic_mana_base + c.relic_mana_per_level * level']),
 ('basic_presentation',5,['attack::Kind::Basic, audience);','return Err(Error::NonBasic);']),
 ('clip_time_not_hit',9,['loaded_attack_duration.filter','age >= f64::from(duration)','kind: Kind::Basic, role: "attack"']),
 ('orientation_paths',7,['.with_rotation(Quat::from_rotation_y(unit.facing))','entity_orientation::apply(&mut transform,[unit.position.x-previous.position.x'])]:
  check(name,all(n in current[LOCAL[idx]] for n in needles))
 effect_body=current[LOCAL[6]].split('pub struct Effects {',1)[1].split('\n}',1)[0];check('no_boss_buff_in_effect_fields',not re.search('vilemaw|boss_buff|ttbossbuff',effect_body,re.I))
 community={pathlib.Path(p['source']['path']).name:pathlib.Path(p['source']['path']).read_text(encoding='utf-8-sig') for p in provenance if p['source']['path'].endswith('.cs')}
 check('community_heal_formula','94 + 13 * (unit.Stats.Level - 1)' in community['TT_RelicHeal.cs'] and '90 + 14 * (unit.Stats.Level - 1)' in community['TT_RelicHeal.cs'])
 check('community_haste_todo','TODO: Make it decay' in community['TT_SpeedShrine_Buff.cs'])
 inherited={}
 for rel in ['docs/altar_network_validation.json','docs/relic_network_validation.json','docs/altar_source_audit.json','docs/vilemaw_hud_and_launcher_progress.json','docs/nexus_sparkle_chaos_vilemaw_progress.json','docs/reference_camp_sources/camp-reference.json']:
  keep(root/rel);inherited[rel]=dict(data=load(root/rel),fresh_execution=False)
 camp_proof=inherited['docs/reference_camp_sources/camp-reference.json']['data']
 for entry in camp_proof['inherited_native_experiments']+camp_proof['fresh_native_experiments']:
  s=keep(entry['path']);check('inherited_camp_hash_'+pathlib.Path(s['path']).name,s==entry)
  old=load(s['path']);check('inherited_camp_source_'+pathlib.Path(s['path']).name,old['source']==neutral['source'])
  inherited[s['path']]=dict(data=old,fresh_execution=False)
 timer=camp_proof['comparison']['camp_rows'][6]
 check('camp7_timer_limits',timer['camp']==7 and timer['native_delay_field']==95 and timer['current_initial_seconds']==inter['relic_initial_seconds'] and timer['native_respawn_field']==timer['current_respawn_seconds']==inter['relic_respawn_seconds']==90 and timer['literal_initial_difference']==85 and timer['timer_anchor_or_absolute_schedule_qualified'] is False)
 for tid in TARGETS:
  for i,s in enumerate(SPECS[tid]):checks.append('anchor_'+anchor(root,tid,i,s)['role'])
 for p in LOCAL+['data/4.20/altars_map10.json','data/4.20/map10_interactions.json','data/4.20/map10_world.json','data/4.20/world_animation_manifest.json','data/4.20/native_tooltips_map10.json','docs/reference_client_4_20.json','tools/native_lua.py','tools/project-plan/audit_structures_reference.py','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py','tools/project-plan/audit_navigation_reference.py']:keep(root/p)
 facts=dict(scripts=scripts,tooltip_source=font,tooltips=tooltips,altars=config,relic=inter,declared_provenance=provenance,boss_camp=camp,boss_native_position=pos,boss_native_face=face,boss_yaw_radians=yaw,boss_definition=world['definitions']['TT_Spiderboss'],boss_spells=spells,boss_model=dict(source=model,catalog=catalog),boss_animations=anim,boss_blend=blend,buff_death_key=dict(present=False,value=None,default_qualified=False),inherited_evidence=inherited,policies=dict(altar_server_trigger_qualified=False,totalAD_matches_native_bonusAD=False,relic_engine_clock_anchor_qualified=False,community_heal_native_qualified=False,linear_decay_native_qualified=False,special_AI_implemented=False,boss_buff_implemented=False,boss_death_default_qualified=False,screen_anatomical_orientation_qualified=False,current_render_observed=False),source_checks=checks,native_or_game_executed=False,rust_tests_executed=False)
 return facts,list(pins.values())
_CACHE={}
def collect(root=R):
 k=str(pathlib.Path(root).resolve())
 if k not in _CACHE:_CACHE[k]=_collect(root)
 else:
  for p in _CACHE[k][1]:require(pin(p['path'])==p,'changed source '+p['path'])
 return _CACHE[k]

def bindings(f,tid):
 rows=[];idx=TARGETS.index(tid)
 def add(s,role,selector):rows.append(dict(path=s['source']['path'],role=role,selector=selector))
 if idx<6:
  add(f['tooltip_source'],'native_altar_text_not_server_policy','announcements90seconds;TreelineMasterBuffT0/T1/T2;Bonus Attack Damage distinct from totalAD; Hexakill distinct')
  for path,s in f['scripts'].items():
   if ('Treeline' in path and 'Hexakill' not in path) or 'CharScriptTT_Buffplat' in path:add(s,'native_altar_client_metadata_not_capture_engine',path+'; constants/initialization/callback bodies retained; no inferred absent defaults')
 elif idx<9:
  add(f['scripts']['LEVELS/Map10/Scripts/NeutralMinionSpawn.luaobj'],'native_camp7_source_not_absolute_clock','NeutralMinionInit/CreateRespawnNeutralTimer/NeutralMinionDeath; partial static init pc364; prior adapted callbacks separately bounded')
  add(f['tooltip_source'],'native_relic_haste_display_not_curve','game_buff_tooltip_TT_SpeedShrine_Buff;20percent;fades over time;no duration or linear curve')
  for path,s in f['scripts'].items():
   if 'TT_Relic' in path or 'TT_SpeedShrine' in path:add(s,'native_relic_client_metadata',path+'; no native server heal coefficients inferred')
 else:
  for path,s in f['scripts'].items():
   if 'TT_Spiderboss' in path or 'TT_Boss' in path:add(s,'native_boss_metadata_not_complete_server_AI',path+'; constants/globals/absence retained')
  if idx in [11,12]:add(f['tooltip_source'],'native_boss_buff_description_not_duration','TTBossBuff;health/mana regeneration,attack speed,cooldown reduction;no duration or death default')
  if idx in [9,10,14]:
   for s in f['boss_spells']:add(s,'native_boss_spell_fields_not_callback_policy',s['name']+';AnimationName/CastRange/delay/missile;absent cooldown/effects retained')
  if idx in [13,14]:
   add(f['scripts']['LEVELS/Map10/Scripts/NeutralMinionSpawn.luaobj'],'native_camp8_position_and_face_not_screen_anatomy','CampSpawnPoints[8][1]/CampFacePoints[8][1]; local atan2 and renderer transform separately linked')
   add(f['boss_blend'],'native_boss_blend_source_not_dispatch','animation state resource; no full blend execution')
   for s in f['boss_animations']:add(s,'native_boss_animation_source_not_current_render',s['name']+'; current GLB clip name correspondence only, not keyframe/pose equality')
 return rows

def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no source verification bypass');require(q['schema']=='openleague_objectives_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source pins changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'checks census');require([x['task_id'] for x in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchor rebound '+t);require(a['native_bindings']==bindings(f,t),'native role rebound '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim rebound '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope promoted '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown rebound '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_scripts=len(f['scripts']),native_or_game_executed=False)


