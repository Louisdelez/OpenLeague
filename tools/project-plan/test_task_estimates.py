import contextlib,copy,io,json,pathlib,tempfile,unittest
from task_estimates import build,estimate,signature,research,refresh_ui,MODELS

HERE=pathlib.Path(__file__).resolve().parent
ROOT=pathlib.Path('E:/OpenLeague')
class AIPlanningTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.tmp=tempfile.TemporaryDirectory(prefix='openleague-ai-estimates-')
  with contextlib.redirect_stdout(io.StringIO()):cls.data=build(ROOT,pathlib.Path(cls.tmp.name)/'estimates.json')
  cls.tasks={t['id']:t for t in json.loads((ROOT/'docs/completion_tasks_2026-10-20.json').read_text(encoding='utf-8'))['tasks']}
 @classmethod
 def tearDownClass(cls):cls.tmp.cleanup()
 def test_all_real_tasks_have_consistent_bounded_agent_profiles(self):
  self.assertEqual(set(self.data['tasks']),set(self.tasks))
  for ident,t in self.tasks.items():
   row=self.data['tasks'][ident];self.assertEqual(row[0],signature(t))
   lo,hi,difficulty,model,confidence,reasons,scope,cycles_lo,cycles_hi,tools=self.data['profiles'][row[1]]
   self.assertGreater(hi,lo);self.assertGreaterEqual(lo,1);self.assertGreaterEqual(cycles_hi,cycles_lo)
   self.assertIn(difficulty,range(4));self.assertIn(model,range(len(MODELS)))
   self.assertIn(confidence,['faible','indicative']);self.assertGreater(reasons,0)
   self.assertIn(scope,['task','review','first_pass']);self.assertIn(tools,self.data['toolsets'])
   self.assertEqual(row[3],len(t.get('depends_on',[])))
 def test_value_check_is_lighter_than_simulation(self):
  a=estimate(self.tasks['CH-Garen-IDENTITE-SPELLBLOCK']);b=estimate(self.tasks['CH-Garen-Q-SIMULATION'])
  self.assertLess(a['minutes_high'],b['minutes_high']);self.assertLess(a['difficulty'],b['difficulty'])
 def test_unknowns_add_research_cycles_and_lower_confidence(self):
  t=self.tasks['CH-Garen-Q-SOURCE'];a=estimate(t);b=estimate(t,3)
  self.assertGreater(b['cycles_high'],a['cycles_high']);self.assertGreater(b['minutes_high'],a['minutes_high'])
  self.assertEqual(b['confidence'],'faible');self.assertTrue(b['reasons']&(1<<10))
 def test_cross_catalogue_research_never_claims_a_total_delivery_time(self):
  a=estimate(self.tasks['SYS-01.2-02'],1)
  self.assertEqual(a['scope'],'first_pass');self.assertEqual(a['difficulty'],3)
  self.assertLess(a['minutes_high'],240);self.assertTrue(a['reasons']&(1<<8))
 def test_completed_technical_work_excludes_human_wait(self):
  a=estimate(self.tasks['SYS-01.2-01']);self.assertEqual(a['scope'],'review')
  self.assertLessEqual(a['minutes_high'],20);self.assertTrue(a['reasons']&(1<<12))
 def test_umbrella_does_not_sum_every_prerequisite(self):
  t=copy.deepcopy(self.tasks['CH-Garen-Q-ACCEPTANCE']);a=estimate(t)
  t['depends_on']=t['depends_on']*20;b=estimate(t)
  self.assertEqual(a['minutes_high'],b['minutes_high']);self.assertTrue(a['reasons']&(1<<7))
 def test_model_effort_is_documented_and_no_max_or_ultra_is_automatically_assigned(self):
  for model in MODELS:self.assertIn(model[3],research()['supported_api_efforts'])
  self.assertTrue(all(m[3] not in ['max','ultra'] for m in MODELS))
  self.assertGreaterEqual(len({(m[0],m[3]) for m in MODELS}),5)
 def test_estimate_is_not_a_human_time_conversion_or_inference_benchmark(self):
  a=research()['timing_assumptions'];self.assertGreater(a['cycle_seconds_high'],a['cycle_seconds_low'])
  self.assertIn('pas cadence publiée',a['cycle_time_status'])
  self.assertIn('Aucun benchmark',research()['model_timing_benchmark'])
  self.assertFalse(research()['local_ai_workflow_anchor']['statistical_calibration'])
 def test_signature_detects_metadata_changes_including_unicode(self):
  t={'id':'Élise-🕷','title':'Vérifier 100 %','kind':'source','status':'a_faire'}
  for key in t:self.assertNotEqual(signature(t),signature({**t,key:t[key]+'x'}))
 def test_refresh_preserves_unrelated_controls_and_adapters(self):
  root=pathlib.Path(self.tmp.name)/'refresh';text='<p>Keep</p><style id="task-badge-styles">old</style><script type="application/json" id="task-estimate-data">{}</script><script id="task-estimate-runtime">old</script><script>const adapter="keep";</script>'
  for rel in ['tools/project-plan/index.html','tools/project-plan-desktop/web/index.html']:
   p=root/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')
  refresh_ui(root,self.data)
  for rel in ['tools/project-plan/index.html','tools/project-plan-desktop/web/index.html']:
   s=(root/rel).read_text(encoding='utf-8');self.assertTrue(s.startswith('<p>Keep</p>'));self.assertTrue(s.endswith('<script>const adapter="keep";</script>'))
if __name__=='__main__':unittest.main(verbosity=2)
