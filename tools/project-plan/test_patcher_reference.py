import copy,json,pathlib,struct,unittest
from patcher_reference import verify,load_members,translations,PatcherReferenceError
from patcher_formats import read_load,read_manifest
R=pathlib.Path('E:/OpenLeague')
class PatcherReferenceTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):cls.d=json.loads((R/'docs/reference_patcher_routes_4_20.json').read_bytes())
 def test_01_actual_sources_manifest_binding_and_complete_recovered_surface(self):
  r=verify(self.d,R);self.assertEqual((r['bundles'],r['members'],r['controllers'],r['host_commands']),(7,457,8,13));self.assertFalse(r['native_binary_executed'])
 def test_02_missing_source_refused(self):
  d=copy.deepcopy(self.d);d['sources'][0]['path']='missing.exe'
  with self.assertRaisesRegex(PatcherReferenceError,'Source absente'):verify(d,R)
 def test_03_changed_source_refused(self):
  d=copy.deepcopy(self.d);d['sources'][0]['sha256']='0'*64
  with self.assertRaisesRegex(PatcherReferenceError,'Source modifiée'):verify(d,R)
 def test_04_changed_screen_anchor_refused(self):
  d=copy.deepcopy(self.d);d['screens'][0]['anchors'][0]['literal']='THIS_SCREEN_DOES_NOT_EXIST'
  with self.assertRaisesRegex(PatcherReferenceError,'Ancrage'):verify(d,R)
 def test_05_unknown_journey_command_refused(self):
  d=copy.deepcopy(self.d);d['journeys'][0]['commands'].append('UnknownNativeCommand')
  with self.assertRaisesRegex(PatcherReferenceError,'Commande'):verify(d,R)
 def test_06_prototype_page_not_promoted_to_live_patcher_route(self):
  d=copy.deepcopy(self.d);s=next(s for s in d['screens'] if s['kind']=='routed_view');s['route_member']='bundle-client-sitemap/module-game-champion-select/www/championSelect.html'
  with self.assertRaisesRegex(PatcherReferenceError,'Vue non routée'):verify(d,R)
 def test_07_native_render_acceptance_never_inferred_from_sources(self):
  d=copy.deepcopy(self.d);d['claims']['native_visual_acceptance']=True
  with self.assertRaisesRegex(PatcherReferenceError,'Qualification'):verify(d,R)
 def test_08_all_ui_commands_have_named_journeys(self):
  self.assertEqual(set(self.d['surface']['host_commands'])-{c for j in self.d['journeys'] for c in j['commands']},set())
 def test_09_native_historical_nominal_update_and_agreements_are_ordered(self):
  e=self.d['historical_log_events']['log_nov20'];text='\n'.join(x['event'] for x in e)
  self.assertLess(text.index('StartUpdate'),text.index('OnTaskComplete'))
  self.assertLess(text.index('DisplayAgreement: eula'),text.index('DisplayAgreement: nda'))
  self.assertIn('SendAgreementResponse 1',text)
 def test_10_load_bounds_and_traversal_refused(self):
  p=pathlib.Path(self.d['source_roots']['recovered'])/self.d['bundles'][0]['path'];data=p.read_bytes()
  b=bytearray(data);struct.pack_into('<I',b,12,1)
  with self.assertRaises(ValueError):read_load(bytes(b))
  b=bytearray(data);nameoff,namelen=struct.unpack_from('<2I',b,80+24);b[nameoff:nameoff+3]=b'../'
  with self.assertRaisesRegex(ValueError,'Unsafe'):read_load(bytes(b))
 def test_11_manifest_invalid_header_refused(self):
  with self.assertRaises(ValueError):read_manifest(b'RLSM'+b'\0'*40)
 def test_12_duplicate_translation_refused(self):
  with self.assertRaises(PatcherReferenceError):translations(b'tr "key" = "a"\ntr "key" = "b"\n')
 def test_13_stored_plan_consumer_has_exact_scope_and_sources(self):
  from instructions import make_instruction
  t=next(x for x in json.loads((R/'docs/completion_tasks_2026-10-20.json').read_bytes())['tasks'] if x['id']=='SYS-01.1-04');h=json.loads((R/'docs/execution_plan_A_Z.json').read_bytes())
  p=next(x for x in h['packages'] if t['id'] in x['task_ids']);phase=next(x for x in h['phases'] if x['id']==p['phase'])
  text=make_instruction(t,phase,p,{t['id']:t},R,R)
  for value in ['reference_patcher_routes_4_20.json','25','15','0.4.0.122']:self.assertIn(value,text)
  self.assertFalse(t['acceptance_complete']);self.assertEqual(t['human_acceptance'],'not_given')
if __name__=='__main__':unittest.main(verbosity=2)
