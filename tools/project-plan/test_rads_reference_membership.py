"""Actual 4.20 manifest/payload qualification, including explicit negative cases."""
import copy,json,pathlib,tempfile,unittest
from rads_reference_membership import (RadsReferenceMembership,logical_key,identity,
    verify_recovered_alternatives,binding_for,validate_binding,instruction_summary)
R=pathlib.Path('E:/OpenLeague');S=pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision11')

class MembershipTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.v=RadsReferenceMembership(R)
  cls.binary=cls.v.inspect('League of Legends.exe',cls.v.deploy/'League of Legends.exe')
  cls.binary['source_id']='original-binary'
  cls.alternatives=verify_recovered_alternatives(cls.v)
 def source(self,row=None):
  row=row or self.binary
  return {'source_id':row['source_id'],**{k:row['observed'][k] for k in ['bytes','sha256']},'rads_release_membership':binding_for(row,'receipt')}
 def test_01_actual_solution_selects_exact_two_projects(self):
  self.assertEqual([(x['project'],x['release'],x['member_count']) for x in self.v.manifests],
   [('lol_game_client','0.0.1.7',70286),('lol_game_client_en_gb','0.0.0.235',563)])
 def test_02_actual_game_binary_exact_member(self):
  self.assertEqual(self.binary['status'],'matches_selected_project_manifest')
  self.assertEqual(self.binary['matching_members'][0]['md5'],'957ad5b28823f3351cacd751b83b7d90')
  self.assertFalse(self.binary['effective_runtime_precedence_qualified'])
 def test_03_renekton_two_payload_releases_keep_both_configs(self):
  old=self.v.inspect('DATA/Characters/Renekton/Renekton.inibin',self.v.deploy/'DATA/Characters/Renekton/Renekton.inibin')
  new=self.v.inspect('DATA/Characters/Renekton/Skins/Base/Base.inibin',self.v.deploy/'DATA/Characters/Renekton/Skins/Base/Base.inibin')
  self.assertEqual(old['matching_members'][0]['release'],'0.0.1.7')
  self.assertEqual(new['matching_members'][0]['release'],'0.0.0.249')
  self.assertFalse(new['effective_runtime_precedence_qualified'])
 def test_04_native_loose_urf_is_divergent_and_not_silently_promoted(self):
  row=self.v.inspect('DATA/Characters/Urf/Urf.inibin',self.v.deploy/'DATA/Characters/Urf/Urf.inibin')
  self.assertEqual(row['status'],'differs_from_all_selected_manifest_payloads');self.assertEqual(row['observed']['bytes'],515)
  self.assertEqual(row['candidates'][0]['bytes'],610);self.assertEqual(row['matching_members'],[])
 def test_05_native_loose_cheats_divergence_is_real(self):
  row=self.v.inspect('DATA/CFG/defaults/Cheats.cfg',self.v.deploy/'DATA/CFG/defaults/Cheats.cfg')
  self.assertEqual(row['status'],'differs_from_all_selected_manifest_payloads')
  self.assertEqual((row['observed']['bytes'],row['candidates'][0]['bytes']),(150,148))
 def test_06_exact_recovered_alternatives_and_original_backing(self):
  self.assertEqual(len(self.alternatives),2)
  for row in self.alternatives:
   self.assertEqual(row['status'],'matches_selected_project_manifest');self.assertFalse(row['ordinary_runtime_integration_qualified'])
   self.assertEqual(row['observed']['sha256'],row['recovery_backing']['sha256'])
 def test_07_recorded_empty_member_is_not_treated_as_corrupt(self):
  logical='DATA/Characters/AzirSoldier/Skins/Base/Animations/AzirSoldier_Idle2.anm'
  row=self.v.inspect(logical,self.v.deploy/logical)
  self.assertEqual(row['observed']['bytes'],0);self.assertEqual(row['status'],'matches_selected_project_manifest')
 def test_08_loose_locale_is_unlisted_without_automatic_corruption_or_absence_claim(self):
  logical='DATA/CFG/defaults/Locale.cfg';row=self.v.inspect(logical,self.v.deploy/logical)
  self.assertEqual(row['observed']['bytes'],37);self.assertEqual(row['status'],'not_listed_in_two_selected_projects')
 def test_09_casefolded_lookup_preserves_original_member_spelling(self):
  row=self.v.inspect('data/characters/renekton/skins/base/base.inibin',self.v.deploy/'DATA/Characters/Renekton/Skins/Base/Base.inibin')
  self.assertEqual(row['matching_members'][0]['member_path'],'DATA/Characters/Renekton/Skins/Base/Base.inibin')
 def test_10_invalid_logical_paths_refused(self):
  for name in ['','../outside','data/../file','C:/file','/root','a//b','a/./b','a\x00b','é', 'x'*1025]:
   with self.subTest(name=name),self.assertRaises(ValueError):logical_key(name)
 def test_11_changed_registered_source_refused(self):
  with self.assertRaisesRegex(ValueError,'Registered source identity'):
   self.v.inspect('League of Legends.exe',self.v.deploy/'League of Legends.exe',{'bytes':15973880,'sha256':'0'*64})
 def test_12_two_matching_candidates_do_not_invent_precedence(self):
  key='__ambiguity_control__';entry=copy.deepcopy(self.binary['candidates'][0]);self.v.by_key[key]=[entry,{**entry,'project':'explicit-test-overlay'}]
  try:
   row=self.v.inspect(key,self.v.deploy/'League of Legends.exe')
   self.assertEqual(row['status'],'multiple_manifest_members_same_observed_payload');self.assertEqual(len(row['matching_members']),2)
   self.assertFalse(row['effective_runtime_precedence_qualified'])
  finally:self.v.by_key.pop(key)
 def test_13_tampered_catalogue_refused_before_other_inputs(self):
  with tempfile.TemporaryDirectory(dir=S) as tmp:
   root=pathlib.Path(tmp);p=root/'data/4.20/recovered_rads_manifests.json';p.parent.mkdir(parents=True);p.write_text('{}')
   with self.assertRaisesRegex(ValueError,'catalogue changed'):RadsReferenceMembership(root)
 def test_14_tampered_dated_reference_refused(self):
  with tempfile.TemporaryDirectory(dir=S) as tmp:
   root=pathlib.Path(tmp);p=root/'data/4.20/recovered_rads_manifests.json';p.parent.mkdir(parents=True);p.write_bytes((R/'data/4.20/recovered_rads_manifests.json').read_bytes())
   (root/'docs').mkdir();(root/'docs/reference_client_4_20.json').write_text('{}')
   with self.assertRaisesRegex(ValueError,'Dated reference identity'):RadsReferenceMembership(root)
 def test_15_binding_matches_exact_receipt_row(self):
  source=self.source();validate_binding(source,{'receipt':{}},{'original-binary':self.binary})
  self.assertIn('projet 0.0.1.7 / contenu 0.0.1.7',instruction_summary(source))
  self.assertIn('ne qualifie pas',instruction_summary(source))
 def test_16_forged_status_or_precedence_refused(self):
  for field,value in [('status','not_listed_in_two_selected_projects'),('effective_runtime_precedence_qualified',True),('evidence_source_id','missing')]:
   source=self.source();source['rads_release_membership'][field]=value
   with self.subTest(field=field),self.assertRaises(ValueError):validate_binding(source,{'receipt':{}},{'original-binary':self.binary})
 def test_17_mismatched_observation_or_dropped_candidate_refused(self):
  for field,value in [('observed',{'bytes':1,'sha256':'0'*64,'md5':'0'*32}),('matching_members',[])]:
   source=self.source();source['rads_release_membership'][field]=value
   with self.subTest(field=field),self.assertRaises(ValueError):validate_binding(source,{'receipt':{}},{'original-binary':self.binary})
 def test_18_self_consistent_forgery_still_rejected_by_receipt(self):
  source=self.source();source['rads_release_membership']['logical_path']='unrelated-but-valid'
  with self.assertRaisesRegex(ValueError,'pinned receipt'):validate_binding(source,{'receipt':{}},{'original-binary':self.binary})

if __name__=='__main__':unittest.main(verbosity=2)
