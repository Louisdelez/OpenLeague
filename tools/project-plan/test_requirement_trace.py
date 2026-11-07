import copy,json,os,pathlib,sys,tempfile,unittest
S=pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20');R=pathlib.Path('E:/OpenLeague');D=pathlib.Path(os.environ.get('OPENLEAGUE_TRACE_SNAPSHOT',str(R)))
sys.path.insert(0,os.environ.get('OPENLEAGUE_TRACE_CODE_ROOT',str(R/'tools/project-plan')))
from requirement_trace import TraceError,load,resolve,validate,instruction_lines
class TraceTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.reg=json.loads((R/'docs/completion_tasks_2026-10-20.json').read_bytes());cls.tasks={x['id']:x for x in cls.reg['tasks']};cls.bundle=load(D)
 def test_01_every_active_requirement_historical_parent_and_archive_has_exact_identity(self):
  r=validate(self.bundle,self.reg,R);self.assertEqual(r['active_requirements'],42214);self.assertFalse(r['gameplay_accepted'])
 def test_02_missing_task_binding_refused(self):
  b={**self.bundle,'requirements':dict(self.bundle['requirements'])};b['requirements'].pop('CH-Aatrox-Q-SOURCE')
  with self.assertRaisesRegex(TraceError,'coverage'):validate(b,self.reg,R)
 def test_03_rebound_identity_refused(self):
  b={**self.bundle,'requirements':dict(self.bundle['requirements'])};t='CH-Aatrox-Q-SOURCE';b['requirements'][t]={**b['requirements'][t],'requirement_id':'OLF-other'}
  with self.assertRaisesRegex(TraceError,'identity'):validate(b,self.reg,R)
 def test_04_native_spell_file_not_confused_with_garen_only_data_consumer(self):
  r=resolve(self.tasks['CH-Aatrox-Q-SOURCE'],D)
  self.assertTrue(any(x['source']['path'].lower().endswith('aatroxq.inibin') for x in r['native_sources']))
  self.assertTrue(any(x['role']=='explicit_refusal' for x in r['consumers']))
  self.assertFalse(any(x['role']=='filtered_data_loader' for x in r['consumers']))
 def test_05_garen_actual_filter_is_distinguished(self):
  r=resolve(self.tasks['CH-Garen-Q-SOURCE'],D);self.assertTrue(any(x['role']=='filtered_data_loader' for x in r['consumers']))
 def test_06_non_base_skin_is_not_accepted_by_base_model_presence(self):
  r=resolve(self.tasks['SKIN-Aatrox-1-SCOPE'],D)
  self.assertTrue(any(x['aspect']=='non_base_skin_dispatch' for x in r['unknowns']))
  self.assertFalse(r['requirement']['game_behavior_accepted'])
 def test_07_unknown_has_precise_question_search_and_closure(self):
  for u in self.bundle['unknowns'].values():
   self.assertTrue(u['task_id']);self.assertTrue(u['question']);self.assertTrue(u['research_performed']);self.assertTrue(u['resolution_condition']);self.assertIn(u['status'],['open','resolved'])
   if u['status']=='resolved':self.assertTrue(u['resolution_evidence']);self.assertTrue(u['resolution_history'])
 def test_08_false_game_acceptance_refused(self):
  b={**self.bundle,'requirements':dict(self.bundle['requirements'])};key=next(iter(b['requirements']));b['requirements'][key]={**b['requirements'][key],'game_behavior_accepted':True}
  with self.assertRaisesRegex(TraceError,'gameplay acceptance'):validate(b,self.reg,R)
 def test_09_lost_unknown_edge_refused(self):
  b={**self.bundle,'unknowns':dict(self.bundle['unknowns'])};b['unknowns'].pop(next(k for k,v in b['unknowns'].items() if v['status']=='open'))
  with self.assertRaisesRegex(TraceError,'Unknown edge'):validate(b,self.reg,R)
 def test_10_incomplete_artifact_set_never_silently_falls_back(self):
  with tempfile.TemporaryDirectory(dir=S) as td:
   p=pathlib.Path(td);(p/'docs').mkdir();(p/'docs/fidelity_requirement_trace_4_20.json').write_text('{}')
   with self.assertRaisesRegex(TraceError,'Incomplete'):load(p,required=False)
 def test_11_copied_trace_is_specific_and_keeps_limits(self):
  text='\n'.join(instruction_lines(self.tasks['CH-Aatrox-Q-SOURCE'],D))
  for value in ['CH-Aatrox-Q-SOURCE','AatroxQ.inibin','SHA-256','explicit_refusal','ne prouvent pas']:self.assertIn(value,text)
 def test_12_absent_item_lookup_is_not_present_data_entry(self):
  r=resolve(self.tasks['ITEM-3040-SCOPE'],D)
  links=[x['binding'] for x in r['references'] if x['source']['path'].endswith('shop_foundation.json')]
  self.assertTrue(links);self.assertEqual(links[0]['relation'],'current_catalog_lookup_absent');self.assertFalse(links[0]['selector_exists'])
 def test_13_consumer_anchor_move_refused(self):
  b={**self.bundle,'consumers':dict(self.bundle['consumers'])};key=next(iter(b['consumers']));b['consumers'][key]={**b['consumers'][key],'line':0}
  with self.assertRaisesRegex(TraceError,'anchor changed'):validate(b,self.reg,R,True)
 def test_14_dropped_archived_requirement_refused(self):
  b={**self.bundle,'trace':{**self.bundle['trace'],'archived_task_links':self.bundle['trace']['archived_task_links'][1:]}}
  with self.assertRaisesRegex(TraceError,'Archived'):validate(b,self.reg,R)
 def test_15_unknown_cannot_be_resolved_without_evidence_and_history(self):
  b={**self.bundle,'unknowns':dict(self.bundle['unknowns'])};key=next(k for k,v in b['unknowns'].items() if v['status']=='resolved');b['unknowns'][key]={**b['unknowns'][key],'resolution_evidence':None}
  with self.assertRaisesRegex(TraceError,'without explicit evidence'):validate(b,self.reg,R)
 def test_16_missing_source_version_refused(self):
  b={**self.bundle,'sources':dict(self.bundle['sources'])};key=next(iter(b['sources']));b['sources'][key]={**b['sources'][key],'version':None}
  with self.assertRaisesRegex(TraceError,'provenance/version'):validate(b,self.reg,R)
 def test_17_invalid_source_sha_refused(self):
  b={**self.bundle,'sources':dict(self.bundle['sources'])};key=next(iter(b['sources']));b['sources'][key]={**b['sources'][key],'sha256':'not-a-sha'}
  with self.assertRaisesRegex(TraceError,'SHA/size'):validate(b,self.reg,R)
 def test_18_empty_source_origin_refused(self):
  b={**self.bundle,'sources':dict(self.bundle['sources'])};key=next(iter(b['sources']));b['sources'][key]={**b['sources'][key],'origin':{}}
  with self.assertRaisesRegex(TraceError,'provenance/version'):validate(b,self.reg,R)
 def test_19_stale_status_or_unknown_summary_refused(self):
  b={**self.bundle,'trace':{**self.bundle['trace'],'counts':{**self.bundle['trace']['counts'],'status':{}}}}
  with self.assertRaisesRegex(TraceError,'Stale trace summary'):validate(b,self.reg,R)
  b={**self.bundle,'unknowns_document':{**self.bundle['unknowns_document'],'open_count':-1}}
  with self.assertRaisesRegex(TraceError,'Stale unknown summary'):validate(b,self.reg,R)
 def test_20_legacy_skin_section_is_in_actual_copied_trace_without_runtime_claim(self):
  row=resolve(self.tasks['SKIN-Akali-1-SCOPE'],D)
  self.assertTrue(any(x['binding']['selector'].startswith('MeshSkin1') for x in row['native_sources'] if x['binding'].get('selector')))
  self.assertTrue(any(x['aspect']=='native_skin_config' and x['status']=='resolved' for x in self.bundle['unknowns'].values() if x['task_id']=='SKIN-Akali-1-SCOPE'))
  self.assertTrue(any(x['aspect']=='non_base_skin_dispatch' for x in row['unknowns']))
  self.assertIn('MeshSkin1','\n'.join(instruction_lines(self.tasks['SKIN-Akali-1-SCOPE'],D)));self.assertFalse(row['requirement']['game_behavior_accepted'])
 def test_21_copied_conflict_keeps_both_native_configs_despite_repeated_pe_evidence(self):
  task=self.tasks['SKIN-Renekton-0-SCOPE'];row=resolve(task,D);text='\n'.join(instruction_lines(task,D))
  sources={x['source']['path'] for x in row['native_sources'] if x['source']['path'].endswith('.inibin')}
  self.assertTrue(any(p.endswith('Base.inibin') for p in sources));self.assertTrue(any(p.endswith('Renekton.inibin') for p in sources))
  for path in sources:self.assertIn(path,text)
  binary=next(x['source']['path'] for x in row['native_sources'] if x['source']['path'].endswith('League of Legends.exe'))
  self.assertEqual(text.count(binary),1);self.assertTrue(any(x['aspect']=='native_skin_configuration_precedence' and x['status']=='open' for x in row['unknowns']));self.assertFalse(row['requirement']['game_behavior_accepted'])
if __name__=='__main__':unittest.main(verbosity=2)
