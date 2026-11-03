import copy,json,os,pathlib,sys,unittest
ROOT=pathlib.Path('E:/OpenLeague')
SNAPSHOT=pathlib.Path(os.environ.get('OPENLEAGUE_SERVICE_SCOPE_SNAPSHOT',str(ROOT)))
sys.path.insert(0,str(ROOT/'tools/project-plan'))
from local_services_reference import ScopeError,assess,proxy_properties,rpc_surface,tauri_commands,verify

class LocalServiceScopeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.doc=json.loads((SNAPSHOT/'docs/reference_local_services_4_20.json').read_bytes())
    def changed(self):return copy.deepcopy(self.doc)
    def check(self,d):return verify(d,ROOT,SNAPSHOT)
    def test_01_real_sources_nominal_complete_scope(self):
        result=self.check(self.doc)
        self.assertTrue(result['verified']);self.assertEqual(result['families'],32)
        self.assertEqual(result['service_proxy_properties'],37);self.assertEqual(result['rpc_destinations'],20)
        self.assertEqual(result['local_tauri_commands'],6);self.assertFalse(result['backend_services_implemented_by_this_task'])
    def test_02_missing_family_refused(self):
        d=self.changed();d['families']=[f for f in d['families'] if f['id']!='identity']
        with self.assertRaisesRegex(ScopeError,'perimeter incomplete'):self.check(d)
    def test_03_do_not_promote_scope_to_operational_service(self):
        d=self.changed();d['families'][0]['current_state']='ready'
        with self.assertRaisesRegex(ScopeError,'readiness'):self.check(d)
    def test_04_recovered_client_is_not_recovered_riot_backend(self):
        d=self.changed();d['families'][0]['riot_server_implementation_recovered']=True
        with self.assertRaisesRegex(ScopeError,'backend/runtime recovery'):self.check(d)
    def test_05_every_proxy_property_has_explicit_local_scope(self):
        d=self.changed();del d['service_proxy']['family_mapping']['smtpMailService']
        with self.assertRaisesRegex(ScopeError,'ServiceProxy scope gap'):self.check(d)
    def test_06_every_named_rpc_destination_is_mapped(self):
        d=self.changed();del d['rpc_surface']['destination_family_mapping']['gameService']
        with self.assertRaisesRegex(ScopeError,'RPC destination scope gap'):self.check(d)
    def test_07_original_call_inventory_cannot_omit_observed_call(self):
        d=self.changed();d['rpc_surface']['calls'].pop()
        with self.assertRaisesRegex(ScopeError,'RPC surface incomplete'):self.check(d)
    def test_08_services_must_link_real_implementation_tasks(self):
        d=self.changed();d['families'][0]['backlog_task_ids']=['invented-task']
        with self.assertRaisesRegex(ScopeError,'work unlinked'):self.check(d)
    def test_09_dependency_cycle_refused(self):
        d=self.changed();next(f for f in d['families'] if f['id']=='persistence')['depends_on']=['identity']
        with self.assertRaisesRegex(ScopeError,'dependency cycle'):self.check(d)
    def test_10_wrong_historical_reference_refused(self):
        d=self.changed();d['reference']['locale']='fr_FR'
        with self.assertRaisesRegex(ScopeError,'historical reference'):self.check(d)
    def test_11_changed_source_bytes_refused(self):
        d=self.changed();d['sources'][0]['sha256']='0'*64
        with self.assertRaisesRegex(ScopeError,'origin changed'):self.check(d)
    def test_12_snapshot_cannot_escape_root(self):
        d=self.changed();d['sources'][0]['snapshot']='../outside.as'
        with self.assertRaisesRegex(ValueError,'Chemin de source interdit'):self.check(d)
    def test_13_call_parser_preserves_session_kind_and_literal_binding(self):
        source='function test():void { invokeServiceWithoutSession("gameService","getLatestGameTimerState",[id,state],ok); invokeServiceWithSession("summonerService","getProfile",[x],ok); }'
        rows=rpc_surface(source);self.assertEqual([(r['destination'],r['operation'],r['invoke_kind']) for r in rows],
        [('gameService','getLatestGameTimerState','invokeServiceWithoutSession'),('summonerService','getProfile','invokeServiceWithSession')])
    def test_14_interfaces_comments_and_strings_are_not_remote_calls(self):
        source='function invokeServiceWithoutSession(a:String,b:String):void; // invokeServiceWithSession("x","y");\nvar s:String="invokeServiceWithSession(ghost)";'
        self.assertEqual(rpc_surface(source),[])
    def test_15_dynamic_calls_are_not_invented_operations(self):
        rows=rpc_surface('this._lcdsService.invokeServiceWithoutSession(ENDPOINT_NAME,METHOD_NAME,request);')
        self.assertEqual(len(rows),1);self.assertEqual(rows[0]['classification'],'dynamic_client_call')
        self.assertNotIn('destination',rows[0]);self.assertNotIn('operation',rows[0])
    def test_16_current_command_registration_is_explicit(self):
        self.assertEqual(tauri_commands('tauri::generate_handler![roster, play, resume_session]'),['roster','play','resume_session'])
        with self.assertRaisesRegex(ScopeError,'absent or ambiguous'):tauri_commands('fn main() {}')
        with self.assertRaisesRegex(ScopeError,'Duplicate'):tauri_commands('tauri::generate_handler![play,play]')
    def test_17_nominal_scope_query_is_read_only_not_a_successful_backend_call(self):
        before=copy.deepcopy(self.doc)
        result=assess(self.doc,'identity')
        self.assertEqual(result['decision'],'replace_locally');self.assertEqual(result['current_state'],'not_implemented')
        self.assertFalse(result['implemented']);self.assertFalse(result['runtime_call_executed']);self.assertEqual(self.doc,before)
    def test_18_original_riot_real_money_or_external_requests_are_outside_contract(self):
        for args in [{'original_service':True},{'real_money':True},{'external':True}]:
            result=assess(self.doc,'store',**args)
            self.assertEqual(result['decision'],'outside_local_replacement_contract');self.assertFalse(result['runtime_call_executed'])
        with self.assertRaisesRegex(ScopeError,'Unknown service family'):assess(self.doc,'riot-production')
    def test_19_match_capability_cannot_claim_account_or_native_compatibility(self):
        for key in ['account_authentication_available','native_protocol_compatibility_qualified']:
            d=self.changed();d['current_local_interface'][key]=True
            with self.subTest(key=key),self.assertRaisesRegex(ScopeError,'confused'):self.check(d)
    def test_20_no_fallback_no_silent_success_no_plan_database_as_game_store(self):
        for key in ['remote_riot_fallback','silent_success_for_unsupported','plan_database_is_game_account_database']:
            d=self.changed();d['policy'][key]=True
            with self.subTest(key=key),self.assertRaisesRegex(ScopeError,'policy divergent'):self.check(d)
    def test_21_scope_does_not_hide_unknowns_or_accept_for_user(self):
        d=self.changed();d['open_questions']=[]
        with self.assertRaisesRegex(ScopeError,'unknowns hidden'):self.check(d)
        for key,value in [('native_executed',True),('manual_state_mutated',True),('human_acceptance','accepted')]:
            d=self.changed();d[key]=value
            with self.subTest(key=key),self.assertRaisesRegex(ScopeError,'execution/acceptance'):self.check(d)
    def test_22_every_family_has_nominal_refusal_storage_authority_and_backlog(self):
        for f in self.doc['families']:
            for key in ['nominal_acceptance','refusal_acceptance','authority','persistence','backlog_task_ids','current_evidence','remaining_work']:
                self.assertTrue(f[key],(f['id'],key))
        self.assertTrue(any('MockStore' in x['subject'] for x in self.doc['source_interpretation']))
        d=self.changed();d['cross_cutting_requirements']=d['cross_cutting_requirements'][:-1]
        with self.assertRaisesRegex(ScopeError,'invariants incomplete'):self.check(d)

if __name__=='__main__':unittest.main(verbosity=2)
