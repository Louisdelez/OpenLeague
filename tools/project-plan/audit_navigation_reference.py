"""Navigation source/consumer tracing; no claim of native movement parity."""
import collections,hashlib,json,math,pathlib,struct,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from rads_reference_membership import RadsReferenceMembership,identity
from reference_inibin import read,hashkey
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(value,message):
 if not value:raise ValueError(message)
def pin(p):return identity(pathlib.Path(p).resolve())
TARGETS=[f'SYS-09.1-{i:02}' for i in range(1,5)]+[f'SYS-09.2-{i:02}' for i in range(1,10)]
BOUNDARIES={'SYS-09.1-04','SYS-09.2-05'}
LOCAL=['crates/core/src/lib.rs','crates/core/src/pillar_navigation.rs','crates/core/src/ally_occupancy.rs','crates/core/src/combat.rs','crates/core/src/attacks.rs','crates/core/src/collision.rs','crates/core/src/trundle_e.rs','crates/core/src/map10_dense_height.rs','crates/client/src/main.rs','crates/client/src/map_coordinates.rs','crates/client/src/native_minimap_geometry.rs','crates/client/src/native_minimap_input.rs','crates/client/src/fow_level_bounds.rs','crates/client/src/picking.rs','crates/server/src/main.rs']
SPECS={
 'SYS-09.1-01':[(14,'let navigation = Navigation::load('),(8,'commands.insert_resource(MapHandle(assets.load("maps/twisted_treeline.glb")));'),(9,'pub fn map_root_transform()')],
 'SYS-09.1-02':[(0,'pub fn ground(&self, p: Point)'),(2,'if let Some(height) = self.navigation.ground(p.position) { p.height = height; }'),(8,'Vec3::new(p.position.x / 20., p.height / 20., p.position.z / 20.);'),(7,"pub fn binding() -> Result<&'static Binding")],
 'SYS-09.1-03':[(10,'pub fn inverse(self,r:Rect,p:Vec2)'),(11,'if terrain.0.ground(point).is_none() {continue;}'),(11,'connection.send_action(openleague_core::Action::Move{point})')],
 'SYS-09.1-04':[(10,'pub fn map10()->Result<Self,String>'),(14,'root.join("assets/maps/tt_navigation_grid.json")')],
 'SYS-09.2-01':[(0,'pub fn path(&self, start: Point, end: Point)'),(6,'pub(crate) fn dynamic_path('),(1,'pub(crate) fn segment_allowed(')],
 'SYS-09.2-02':[(2,'fn occupancy_replan('),(2,'if terrain_blocked {'),(3,'pub(crate) fn advance_pursuit(')],
 'SYS-09.2-03':[(5,'pub(crate) fn pathfinding_radius('),(2,'fn edge(&self, a: Point, b: Point)'),(1,'pub(crate) fn point_allowed(')],
 'SYS-09.2-04':[(2,'fn allies(mobile: Body,'),(2,'pub(crate) fn reserve(&mut self,'),(2,'pub(crate) fn advance_allied_motion(&mut self)')],
 'SYS-09.2-05':[(2,'if b.id != mobile.id && b.team == mobile.team { out.push(*b); }'),(2,'let mut batches = [blue, purple];')],
 'SYS-09.2-06':[(3,'pub(crate) fn advance_pursuit('),(2,'pub(crate) fn ally_pursuit_path_current(')],
 'SYS-09.2-07':[(4,'pub(crate) fn cancel_windup('),(0,'if self.ally_move_is_repeat(id, point) { return Ok(()); }')],
 'SYS-09.2-08':[(0,'.ok_or("destination unreachable")?;'),(2,'pub(crate) fn route('),(1,'pub(crate) fn segment_allowed(')],
 'SYS-09.2-09':[(0,'fn index(&self, p: Point)'),(2,'pub(crate) fn placement('),(1,'fn bounded_index(')]
}
FINDINGS={
 'SYS-09.1-01':('Le serveur et le picking chargent la même grille Map10 ; le modèle visible utilise le repère natif XYZ/20. Les hauteurs et flags des39474 cellules sont identiques aux octets natifs.','Qualifier l’alignement géométrique et visuel complet entre triangles rendus et navigation ; l’identité des cellules et le transform commun ne prouvent pas cet alignement.'),
 'SYS-09.1-02':('Le mouvement ordinaire donne au champion la hauteur centrale de la cellule praticable, puis le client divise XYZ par20. Une grille dense séparée existe pour les usages explicitement liés à Map10.','Comparer poses,contacts et interpolations au terrain visible ; ne pas attribuer automatiquement la grille dense à la hauteur de tous les acteurs ou aux déplacements spéciaux.'),
 'SYS-09.1-03':('Projection Map10 utilise les bornes du LevelSize SCB,pan central etzoom1 ; inverse retourne X/Z. Le clic droit émet Move seulement sur une cellule praticable et après les gardes de session/focus/UI.','Qualifier précision et comportement dans toutes les tailles de fenêtre,bords et zones ; callbacks souris historiques non portés,aucun test visuel/natif actuel.'),
 'SYS-09.1-04':('Les points d’entrée inspectés choisissent explicitement Map10 ; Projection::map10 refuse des minima X/Z non nuls. Une procédure multi-cartes n’est pas réalisée par ces points d’entrée.','Établir pour chaque autre carte requise les ressources,axes,unités,bornes et contrôles d’alignement ; aucun élargissement silencieux des constantes Map10.'),
 'SYS-09.2-01':('Navigation.path utilise une recherche en largeur à4 voisins sur cellules praticables ; dynamic_path ajoute les cercles TrundleE et des contrôles de segments. Ce code est local,reconstruit.','Qualifier tracé,lissage,coûts et contraintes historiques ; ne pas présenter ce BFS comme A* ou comme algorithme serveur Riot récupéré.'),
 'SYS-09.2-02':('Les conflits alliés déclenchent une recherche espacée de10 ticks. Une obstruction terrain/pilier annule le chemin Move ; un nouvel ordre ou la poursuite normale peut recalculer.','Qualifier et couvrir les recalculs attendus selon chaque obstacle ; arrêt Move et replanification alliée ne prouvent pas un recalcul automatique universel.'),
 'SYS-09.2-03':('Les122 rayons PathfindingCollisionRadius sont relus ; le calcul allié compare sommes de rayons. La navigation terrain/pilier reste celle d’un point, sans érosion générale du terrain par rayon.','Qualifier et intégrer la largeur corporelle pour tous passages et catégories ; rayon de sélection,rayon gameplay et rayon de pathfinding restent distincts.'),
 'SYS-09.2-04':('Le solveur local filtre les champions vivants de la même équipe,au plus deux autres alliés. Il réserve des trajectoires balayées et des arrivées distinctes avant engagement du mouvement.','Qualifier règles historiques,priorités et autres catégories d’unités ; le solveur reconstruit et les rayons natifs ne prouvent pas les règles serveur.'),
 'SYS-09.2-05':('Le filtre allies exclut les autres équipes et les réservations sont séparées par équipe. Ces frontières n’implémentent pas le blocage par unités ennemies.','Qualifier puis relier le blocage ennemi réel pour champions,sbires,mobs et effets ; aucune absence globale déduite au-delà de ce chemin inspecté.'),
 'SYS-09.2-06':('La poursuite vérifie vie,équipe,visibilité et casts,arrête à portée attaque plus rayon cible,et utilise un délai10 ticks. Le cache conserve une arrivée encore à portée de la cible mobile.','Qualifier stabilité et absence d’oscillation sur trajectoires mobiles,obstacles et changements de visibilité ; les gardes sources ne suffisent pas à une recette comportementale.'),
 'SYS-09.2-07':('Move valide d’abord son chemin puis appelle cancel_windup ; une attaque non annulable refuse,une windup annulée remet next_attack au tick courant. La cible est ensuite effacée et le nouveau chemin conservé.','Qualifier reprise,cadence et priorités par attaque/champion ; Stop et attaque annulée ne signifient pas restauration automatique d’un ancien trajet.'),
 'SYS-09.2-08':('Un nouveau Move inaccessible est refusé avant annulation de l’ordre antérieur. Le solveur allié choisit une arrivée libre atteignable ; les segments ordinaires sont revérifiés avant avance.','Qualifier la politique historique de refus/arrivée alternative et toutes les zones ; ne pas promettre qu’un ordre rejeté arrête automatiquement l’ancien mouvement.'),
 'SYS-09.2-09':('Index refuse coordonnées non finies/hors dimensions ; le solveur dynamique ajoute des gardes de grille et de segments. Placement recherche une position libre depuis un seed ou une cellule praticable.','Qualifier toutes les positions invalides et limites ; Navigation.load seul ne valide pas min fini,nearest_walkable sans cercles n’a pas de garde de finitude explicite. Ne pas confondre spawn,ordre et déplacement forcé.')
}
def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[i+1 for i,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l]
 require(len(hits)==1,'unique anchor '+tid+': '+n)
 return dict(path=p,line=hits[0],needle=n,role='navigation_'+tid.lower().replace('-','_').replace('.','_')+'_'+str(i)+('_entry_boundary' if tid in BOUNDARIES else '_partial_consumer'))
def collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):
  s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 m=RadsReferenceMembership(root)
 for x in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[z['identity'] for z in m.manifests],*m.provenance]:keep(x['path'])
 def native(logical):
  p=m.deploy/logical;s=keep(p);member=m.inspect(logical,p,s);check('membership_'+logical,member['status']=='matches_selected_project_manifest');return dict(source=s,membership=member)
 nav=native('LEVELS/Map10/AIPath.aimesh_ngrid');scb=native('LEVELS/Map10/Scene/__LevelSize_.SCB')
 raw=pathlib.Path(nav['source']['path']).read_bytes();meta=load(root/'assets/maps/tt_navigation_grid.json');compact=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes()
 check('nav_version',raw[:3]==bytes([3,1,0]));head=struct.unpack_from('<6ffII',raw,3);count=head[7]*head[8]
 check('nav_dimensions',head[7:]==(306,129) and count==39474 and len(compact)==count*11)
 check('meta_header',meta['width']==head[7] and meta['height']==head[8] and meta['cellSize']==head[6] and all(struct.pack('<f',a)==struct.pack('<f',b) for a,b in zip(meta['min']+meta['max'],head[:6])))
 flags=collections.Counter();open_cells=0
 for i in range(count):
  a=39+56*i;b=11*i
  require(raw[a:a+4]==compact[b:b+4] and raw[a+50:a+52]==compact[b+4:b+6],'native height/flag mismatch '+str(i))
  h,f=struct.unpack_from('<fH',compact,b);flags[str(f)]+=1;open_cells+=int(math.isfinite(h) and not f&2)
 check('all39474_cell_height_flags',True)
 dense=(root/'data/4.20/map10_dense_height/sampled_heights.bin').read_bytes();offset=raw.find(dense)
 check('dense_payload_exact_unique',len(dense)==613*259*4 and offset>=39+56*count and raw.find(dense,offset+1)==-1)
 check('dense_metadata_identical',load(root/'data/4.20/map10_dense_height/navigation_metadata.json')==meta)
 sb=pathlib.Path(scb['source']['path']).read_bytes();check('level_size_identical',sb==(root/'assets/maps/tt_level_size.scb').read_bytes() and sb[:12]==b'r3d2Mesh\x02\0\x02\0')
 bounds=list(struct.unpack_from('<6f',sb,152));check('level_bounds',bounds==[0.,-1440.2152099609375,0.,15398.671875,0.,15398.671875])
 profiles=load(root/'data/4.20/collision_profiles.json');radii=[]
 for name,p in sorted(profiles.items()):
  s=keep(p['source']);check('radius_source_'+name,s['sha256']==p['sha256']);logical=pathlib.Path(p['source']).relative_to(m.deploy).as_posix();member=m.inspect(logical,p['source'],s)
  check('radius_membership_'+name,member['status']=='matches_selected_project_manifest');v=read(p['source']).get(hashkey('Data','PathfindingCollisionRadius'))
  number=float(v);check('radius_value_'+name,number==p['pathfinding_radius'] and math.isfinite(number) and 0<number<=50)
  radii.append(dict(champion=name,source=s,membership=member,field='Data.PathfindingCollisionRadius',native=v,native_python_type=type(v).__name__,numeric_value=number,local=p['pathfinding_radius']))
 check('122_radius_profiles',len(radii)==122)
 local={p:(root/p).read_text(encoding='utf8') for p in LOCAL}
 tokens={0:['h.is_finite() && flags & 2 == 0','let mut queue = VecDeque::from([s]);','for (dx, dz) in [(1, 0), (-1, 0), (0, 1), (0, -1)]','.ok_or("destination unreachable")?;','self.cancel_windup(id)?;'],1:['//! Reconstructed point-agent circle navigation','if circles.is_empty()','return nav.path(start, end);','&& terrain_segment(nav, a, b)'],2:['//! Reconstructed allied-champion geometry','b.team == mobile.team','slot.next_search = self.tick.saturating_add(10);','p.path.clear(); p.destination = None;','let mut batches = [blue, purple];','if let Some(height) = self.navigation.ground(p.position) { p.height = height; }'],3:['<= self.definitions[&p.champion].attack_range + enemy.radius','p.next_repath = self.tick + 10;'],4:['return Err("attack windup cannot be cancelled".into());','p.next_attack = self.tick;'],9:['pub const NATIVE_UNITS_PER_WORLD_UNIT: f32 = 20.;','Transform::from_scale(Vec3::splat(1. / NATIVE_UNITS_PER_WORLD_UNIT))'],10:['bounds.min[0]!=0. || bounds.min[2]!=0.','z:-(self.span[1]*dy/r.height)+self.pan[1]'],11:['Original minimap mouse callbacks, attack/ping/targeted spells remain unported.','if terrain.0.ground(point).is_none() {continue;}'],14:['assets/maps/tt_navigation_grid.json','assets/maps/tt_navigation_grid.cells.bin']}
 for idx,ts in tokens.items():
  for i,t in enumerate(ts):check('token_'+str(idx)+'_'+str(i),t in local[LOCAL[idx]])
 move=local[LOCAL[0]].split('Action::Move { point } => {',1)[1].split('Action::Attack { target } => {',1)[0]
 check('move_path_before_cancel',move.index('destination unreachable')<move.index('self.cancel_windup(id)?')<move.index('p.path = path;'))
 # Read actual GLB root transforms, without claiming triangle/nav alignment or GPU rendering.
 gp=root/'assets/maps/twisted_treeline.glb';keep(gp)
 with gp.open('rb') as fh:
  magic,version,size=struct.unpack('<4sII',fh.read(12));n,kind=struct.unpack('<II',fh.read(8));gltf=json.loads(fh.read(n))
 check('map_glb_header',magic==b'glTF' and version==2 and size==gp.stat().st_size and kind==0x4e4f534a)
 scene=gltf['scenes'][gltf.get('scene',0)];nodes=[dict(index=i,**{k:v for k,v in gltf['nodes'][i].items() if k in ['name','matrix','translation','rotation','scale','mesh','children']}) for i in scene['nodes']]
 for p in LOCAL+['assets/maps/tt_navigation_grid.json','assets/maps/tt_navigation_grid.cells.bin','assets/maps/tt_level_size.scb','data/4.20/map10_dense_height/navigation_metadata.json','data/4.20/map10_dense_height/sampled_heights.bin','data/4.20/collision_profiles.json','docs/reference_client_4_20.json','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py']:keep(root/p)
 for tid in TARGETS:
  for i,s in enumerate(SPECS[tid]):a=anchor(root,tid,i,s);checks.append('anchor_'+a['role'])
 facts=dict(navigation=dict(**nav,header=list(head),cell_count=count,height_and_flag_byte_matches=count,flag_counts=dict(flags),locally_walkable_cells=open_cells,unused_compact_fields=['region bytes6..10','open byte10'],dense_payload_offset=offset,dense_payload_bytes=len(dense),dense_layout_decoder_qualified=False),level_size=dict(**scb,bounds=bounds),radii=radii,map_glb_scene_roots=nodes,source_checks=checks,local_policy=dict(ordinary_search='four_neighbor_BFS',terrain_agent='point',ally_body_source='PathfindingCollisionRadius',enemy_blocking_in_ally_solver=False,replan_ticks=10,terrain_blocked_move='clear_path_destination_wait_new_order',pursuit='recheck_at_deadline',ordinary_actor_height='walkable_cell_center',dense_actor_height_automatic=False,map_units_per_world_unit=20,minimap='Map10_default_center_zoom1_XZ',global_other_map_absence_proven=False),native_server_policy_qualified=False,complete_visual_alignment_proven=False,native_or_game_executed=False)
 return facts,list(pins.values())
def bindings(f,tid):
 out=[dict(path=f['navigation']['source']['path'],role='native_map10_navigation_authoring_not_server_algorithm',selector='version3.1; header@3;39474 cells@39 stride56; centerHeight@0 flags@50; no pathfinding algorithm recovered')]
 if tid.startswith('SYS-09.1-'):out.append(dict(path=f['level_size']['source']['path'],role='native_map10_level_bounds_not_alignment_acceptance',selector='r3d2Mesh2.2 bounds@152; X/Z0..15398.671875; minimap default projection'))
 if tid in ['SYS-09.2-03','SYS-09.2-04','SYS-09.2-05']:
  out.extend(dict(path=r['source']['path'],role='native_pathfinding_radius_not_body_block_policy',selector='Data.PathfindingCollisionRadius='+str(r['native'])) for r in f['radii'])
 return out
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no source verification bypass')
 require(q['schema']=='openleague_navigation_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source pins changed')
 require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'checks census')
 require([x['task_id'] for x in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchor rebound '+t)
  require(a['native_bindings']==bindings(f,t),'native binding rebound '+t)
  require((a['finding'],a['remaining'])==FINDINGS[t],'claim rebound '+t)
  require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope promoted '+t)
  u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown rebound '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_radius_profiles=len(f['radii']),cell_matches=f['navigation']['cell_count'],native_or_game_executed=False)
