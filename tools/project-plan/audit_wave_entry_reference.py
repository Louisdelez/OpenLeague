"""Explicit erratum to the V88 human-readable entry name, preserving original evidence."""
import json,pathlib,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
import audit_waves_reference as old
from audit_navigation_reference import pin,load,require
T='SYS-10.5-01'
FINDING='Correction explicite de la mention enable_world dans V88 : la méthode réelle est Simulation::enable_map10, qui initialise next_slot depuis initial_wave_seconds. Les deux ancres V88 pointaient déjà sur les bonnes lignes ; leur identité est conservée. advance_world déclenche ensuite au tick prévu. Aucune méthode enable_world n’est appelée par ce chemin.'
REMAINING=old.FINDINGS[T][1]

def collect(root=R):
 root=pathlib.Path(root);f,p=old.collect(root);p=p.copy()
 for path in [root/'tools/project-plan/audit_waves_reference.py',root/'docs/reference_waves_sources/waves-links.json']:
  s=pin(path)
  if s not in p:p.append(s)
 text=(root/'crates/core/src/world.rs').read_text(encoding='utf8');lines=text.splitlines()
 methods=[i+1 for i,l in enumerate(lines) if 'pub fn enable_map10(&mut self) -> Result<(), String>' in l]
 require(len(methods)==1 and 'fn enable_world(' not in text,'actual method identity')
 start=methods[0];slot=next(i+1 for i,l in enumerate(lines) if 'next_slot: spells::seconds(config.initial_wave_seconds),' in l)
 require(start<slot<start+40,'initializer in method body')
 prior=load(root/'docs/reference_waves_sources/waves-links.json');a=next(a for a in prior['associations'] if a['task_id']==T)
 require('enable_world arme next_slot' in a['finding'],'explicit prior erratum target')
 require(a['anchors']==[old.anchor(root,T,i,s) for i,s in enumerate(old.SPECS[T])],'prior anchors retained and correct')
 anchors=[dict(path='crates/core/src/world.rs',line=start,needle='pub fn enable_map10(&mut self) -> Result<(), String>',role='wave_entry_actual_method'),dict(path='crates/core/src/world.rs',line=slot,needle='next_slot: spells::seconds(config.initial_wave_seconds),',role='wave_entry_initial_scheduler')]
 facts=dict(actual_method='Simulation::enable_map10',prior_claim=a['finding'],prior_anchors=a['anchors'],prior_native_bindings=a['native_bindings'],native_initial_delay=f['timers'][0],method_line=start,initializer_line=slot,old_proof_preserved=True,gameplay_changed=False,native_or_game_executed=False)
 return facts,p,anchors,a['native_bindings']

def audit(q,root='E:/OpenLeague',verify_files=True):
 require(verify_files,'no bypass');require(q['schema']=='openleague_wave_entry_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope')
 f,p,anchors,bindings=collect(root)
 require(q['facts']==f and q['source_identities']==p,'facts or source changed')
 require(q['checks']==['V88_source_reader_894_checks','actual_method_and_body','prior_anchors_unchanged'] and q['checks_count']==3,'check accounting')
 require(len(q['associations'])==1,'single erratum scope');a=q['associations'][0]
 require(a['task_id']==T and a['anchors']==anchors and a['native_bindings']==bindings,'role binding')
 require(a['finding']==FINDING and a['remaining']==REMAINING,'erratum claim')
 require(a['entry_boundary_only'] is False and a['full_task_scope_complete'] is False,'partial scope')
 u={u['unknown_id']:u for u in load(pathlib.Path(root)/'docs/fidelity_unknowns_4_20.json')['unknowns']}[a['existing_unknown_id']]
 require(u['status']=='open' and u['task_id']==T,'open unknown identity')
 return dict(verified=True,checks_count=3,inherited_reader_source_checks=894,tasks=1,roles=2,source_pins=len(p),native_or_game_executed=False)
