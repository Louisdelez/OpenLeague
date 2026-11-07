import copy,json,os,pathlib,sys,unittest
ROOT=pathlib.Path(os.environ.get('OPENLEAGUE_REFERENCE_ROOT','E:/OpenLeague'))
SNAPSHOT=pathlib.Path(os.environ.get('OPENLEAGUE_LIFECYCLE_SNAPSHOT',str(ROOT)))
sys.path.insert(0,str(ROOT/'tools/project-plan'))
from loading_return_reference import LifecycleError,constants,log_event,method,transpile,verify

class LoadingReturnTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.doc=json.loads((SNAPSHOT/'docs/reference_loading_return_4_20.json').read_bytes())
    def full(self,d): return verify(d,ROOT,snapshot_root=SNAPSHOT)
    def shape(self,d): return verify(d,ROOT,check_sources=False,snapshot_root=SNAPSHOT)
    def change(self): return copy.deepcopy(self.doc)
    def test_01_original_sources_and_nominal_lifecycle_inventory(self):
        r=self.full(self.doc)
        self.assertTrue(r['verified']);self.assertEqual(r['unresolved_boundaries'],2)
        self.assertEqual(r['historical_logs'],91);self.assertEqual(r['vm_methods'],22)
        namespaces={x['namespace'] for x in self.doc['states']}
        self.assertTrue({'air_view','air_preload','air_results','native_endgame','openleague_transport','openleague_process'}.issubset(namespaces))
        self.assertFalse(r['historical_game_executed']);self.assertFalse(r['manual_state_mutated'])
    def test_02_wrong_region_refused(self):
        d=self.change();d['reference']['region']='NA'
        with self.assertRaisesRegex(LifecycleError,'identity divergent'):self.shape(d)
    def test_03_missing_source_refused(self):
        d=self.change();d['sources']=[x for x in d['sources'] if x['id']!='air.MasterGameController']
        with self.assertRaisesRegex(LifecycleError,'source missing'):self.shape(d)
    def test_04_duplicate_source_or_anchor_refused(self):
        for key in ['sources','anchors']:
            d=self.change();d[key].append(copy.deepcopy(d[key][0]))
            with self.subTest(key=key),self.assertRaisesRegex(LifecycleError,'Duplicate'):self.shape(d)
    def test_05_source_content_change_refused(self):
        d=self.change();d['sources'][0]['sha256']='0'*64
        with self.assertRaisesRegex(LifecycleError,'Origin changed'):self.full(d)
    def test_06_snapshot_cannot_escape_project_root(self):
        d=self.change();d['sources'][0]['snapshot']='../outside.as'
        with self.assertRaisesRegex(ValueError,'Chemin de source interdit'):self.full(d)
    def test_07_transition_requires_known_endpoints(self):
        d=self.change();d['transitions'][0]['to']='invented.GAME_OVER'
        with self.assertRaisesRegex(LifecycleError,'endpoint'):self.shape(d)
    def test_08_every_original_state_constant_is_inventoried(self):
        d=self.change();d['states']=[s for s in d['states'] if s['id']!='view.GAME_OVER']
        with self.assertRaisesRegex(LifecycleError,'constant missing'):self.shape(d)
    def test_09_unresolved_bridges_cannot_be_promoted_or_hidden(self):
        for ident in ['T10','T26']:
            for mode in ['promote','remove']:
                d=self.change();row=next(x for x in d['transitions'] if x['id']==ident)
                if mode=='promote':row['confidence']='source_defined';row['qualified']=True
                else:d['transitions'].remove(row)
                with self.subTest(ident=ident,mode=mode),self.assertRaisesRegex(LifecycleError,'unresolved'):self.shape(d)
    def test_10_recovery_guard_cannot_be_omitted(self):
        d=self.change();d['guards']=[g for g in d['guards'] if g['id']!='G18']
        with self.assertRaisesRegex(LifecycleError,'guards missing'):self.shape(d)
    def test_11_private_log_fields_are_refused(self):
        d=self.change();d['historical_logs'][0]['events'][0]['player_name']='must-not-be-exported'
        with self.assertRaisesRegex(LifecycleError,'Private/unexpected'):self.shape(d)
    def test_12_startup_and_texture_warnings_do_not_become_loading_or_completion(self):
        for value in ['End Game Object Update','Processing Mutator EndOfGameScreenText',
                      'Processing Mutator LoadingScreenBackground','Leaked texture LoadScreen','Loading 100%']:
            with self.subTest(value=value):self.assertIsNone(log_event('000001.000| ALWAYS| '+value))
    def test_13_log_classifier_exports_only_safe_labels(self):
        line='000001.500| ALWAYS| '+json.dumps({'messageType':'riot__game_client__connection_info','message_body':'Hard Connect','player_name':'SECRET','password':'SECRET'},separators=(',',':'))
        self.assertEqual(log_event(line),{'kind':'hard_connect','elapsed_seconds':1.5})
        self.assertNotIn('SECRET',json.dumps(log_event(line)))
        line=line.replace('Hard Connect','Game exited')[:-1]+',"exit_code":"untrusted-user-data"}'
        self.assertIsNone(log_event(line))
    def test_14_no_human_acceptance_or_native_execution_inferred(self):
        for key,value in [('manual_state_mutated',True),('human_acceptance','accepted'),('historical_game_executed',True)]:
            d=self.change();d[key]=value
            with self.subTest(key=key),self.assertRaisesRegex(LifecycleError,'Unproven'):self.shape(d)
    def test_15_local_states_cannot_claim_native_observation(self):
        d=self.change();d['states'][0]['observed_now']=True
        with self.assertRaisesRegex(LifecycleError,'observation'):self.shape(d)
        d=self.change();d['states'][0]['namespace']='mixed_native_and_local'
        with self.assertRaisesRegex(LifecycleError,'namespace'):self.shape(d)
    def test_16_vm_erases_types_but_preserves_operators(self):
        m=method('function f(x:int):void { var a:int=3; this.state == x; }','f')
        js=transpile(m);self.assertIn('this.state == x',js);self.assertIn('var a=3',js);self.assertNotIn(':int',js)
        with self.assertRaisesRegex(LifecycleError,'outside'):transpile({'arguments':'','body':'require("fs");'})
    def test_17_method_binding_refuses_empty_missing_and_ambiguous(self):
        for text in ['function f() {}','function g() { return 1; }','function f(){return 1;} function f(){return 2;}']:
            with self.subTest(text=text),self.assertRaisesRegex(LifecycleError,'absent, empty, or ambiguous'):method(text,'f')
    def test_18_historical_exits_and_incomplete_logs_remain_distinct(self):
        events=[e for r in self.doc['historical_logs'] for e in r['events'] if e['kind']=='game_exit']
        self.assertEqual(sum(e['exit_code']=='EXITCODE_WIN' for e in events),1)
        self.assertEqual(sum(e['exit_code']=='EXITCODE_ABANDON' for e in events),61)
        self.assertEqual(sum(not any(e['kind']=='game_exit' for e in r['events']) for r in self.doc['historical_logs']),29)
    def test_19_lua_receipt_records_exact_sixteen_adapter_cases(self):
        lua=json.loads((SNAPSHOT/self.doc['lua_execution']['receipt']).read_bytes())
        self.assertEqual(len(lua['cases']),16);self.assertTrue(lua['instruction_arrays_preserved'])
        for case in lua['cases']:
            self.assertEqual([c for c in case['calls'] if c['name']=='EndGame'],[{'time':5.5,'name':'EndGame','args':[case['winner']]}])
            self.assertEqual([c for c in case['calls'] if c['name']=='SetMinionsNoRender'],[{'time':5.5,'name':'SetMinionsNoRender','args':[case['loser'],True]}])
    def test_20_changed_vm_corpus_identity_refused(self):
        d=self.change();d['vm_methods_sha256']='0'*64
        with self.assertRaisesRegex(LifecycleError,'VM method corpus changed'):self.full(d)
    def test_21_air_review_must_bind_to_exact_frozen_release_export(self):
        d=self.change();d['sources'][0]['upstream_input']='another-release.dat'
        with self.assertRaisesRegex(LifecycleError,'not bound'):self.full(d)
    def test_22_duplicate_historical_trace_refused(self):
        d=self.change();d['historical_logs'].append(copy.deepcopy(d['historical_logs'][0]))
        with self.assertRaisesRegex(LifecycleError,'Duplicate historical'):self.shape(d)
    def test_23_loading_milestones_require_all_observed_labels(self):
        d=self.change();d['states']=[s for s in d['states'] if s['id']!='log.waiting_connection']
        with self.assertRaisesRegex(LifecycleError,'milestone coverage'):self.shape(d)
    def test_24_reference_set_cannot_hide_game_identity(self):
        d=self.change();del d['reference_hashes']['docs/reference_client_4_20.json']
        with self.assertRaisesRegex(LifecycleError,'reference binding'):self.shape(d)
    def test_25_shape_only_mode_does_not_claim_source_verification(self):
        self.assertFalse(self.shape(self.doc)['verified'])

if __name__=='__main__': unittest.main(verbosity=2)
