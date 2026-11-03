import copy,json,pathlib,tempfile,unittest
from game_server_reference import ConfigEvidenceError,verify,jsonc,summarize_settings,settings_inventory,source_contracts
R=pathlib.Path('E:/OpenLeague');S=pathlib.Path('E:/mapslol3v3/Game_client_server_reference_4_20_2026-10-20')
class GameServerReferenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.doc=json.loads((R/'docs/reference_game_server_4_20.json').read_bytes())
    def test_01_actual_client_and_all_sources(self):
        r=verify(self.doc,R)
        self.assertEqual(r['client_version'],'4.20.0.315');self.assertEqual(r['source_files_verified'],65)
        self.assertEqual((r['community_configs'],r['native_client_configs']),(8,37))
        self.assertFalse(r['native_or_server_executed']);self.assertFalse(r['manual_state_mutated'])
    def test_02_exact_client_identity_not_only_announced_server_version(self):
        d=copy.deepcopy(self.doc);d['game_client']['extracted_identity']['version']='4.21.0.0'
        with self.assertRaisesRegex(ConfigEvidenceError,'Identité du client'):verify(d,R)
    def test_03_changed_source_refused(self):
        d=copy.deepcopy(self.doc);d['sources'][1]['sha256']='0'*64
        with self.assertRaisesRegex(ConfigEvidenceError,'Source modifiée'):verify(d,R)
    def test_04_missing_source_refused(self):
        d=copy.deepcopy(self.doc);d['sources'][1]['path']='not-present.cs'
        with self.assertRaisesRegex(ConfigEvidenceError,'Source absente'):verify(d,R)
    def test_05_do_not_label_community_config_as_riot(self):
        d=copy.deepcopy(self.doc);d['server_origin']['riot_server_configuration_recovered']=True
        with self.assertRaisesRegex(ConfigEvidenceError,'Origine serveur Riot'):verify(d,R)
    def test_06_native_connection_not_claimed_from_matching_version(self):
        d=copy.deepcopy(self.doc);d['server_origin']['native_client_connects_to_openleague_rust']=True
        with self.assertRaisesRegex(ConfigEvidenceError,'Compatibilité'):verify(d,R)
    def test_07_jsonnet_comments_and_urls_preserved(self):
        d=jsonc('{/*comment*/"url":"http://localhost/x//y", "text":"comma,}", // comment\n"array":[1,2,],}')
        self.assertEqual(d,{'url':'http://localhost/x//y','text':'comma,}','array':[1,2]})
    def test_08_malformed_and_duplicate_evidence_refused(self):
        for text in ['{"a":1, "a":2}','{/* unfinished','{"a":']:
            with self.subTest(text=text),self.assertRaises(ConfigEvidenceError):jsonc(text)
    def test_09_actual_template_and_bin_profiles_are_distinct(self):
        a={x['path']:x['summary'] for x in self.doc['community_settings']}
        t=a['GameServerConsole/Settings/GameInfo.json.template'];b=a['GameServerConsole/bin/Debug/net6.0/Settings/GameInfo.json']
        self.assertEqual(t['game']['map'],1);self.assertEqual(b['game']['map'],11)
        self.assertFalse(t['game_flags']['MINION_SPAWNS_ENABLED']);self.assertTrue(b['game_flags']['MINION_SPAWNS_ENABLED'])
        self.assertEqual(b['players_count'],1);self.assertNotEqual(b['game']['map'],10)
    def test_10_no_secrets_or_player_values_exported(self):
        with tempfile.TemporaryDirectory(dir=S) as td:
            p=pathlib.Path(td)/'GameInfo.json'
            d={'game':{'map':10,'gameMode':'CLASSIC','dataPackage':'test','password':'DO_NOT_EXPORT'},
               'gameInfo':{'CHEATS_ENABLED':False,'token':'DO_NOT_EXPORT'},
               'players':[{'team':'BLUE','name':'DO_NOT_EXPORT','blowfishKey':'DO_NOT_EXPORT'}]}
            p.write_text(json.dumps(d),encoding='utf-8');text=json.dumps(summarize_settings(p))
            self.assertNotIn('DO_NOT_EXPORT',text);self.assertNotIn('blowfishKey',text)
    def test_11_actual_source_consumers_define_rust_and_community_defaults(self):
        c=source_contracts(self.doc['source_roots'])
        self.assertEqual(c['openleague']['default_bind'],'127.0.0.1:5896');self.assertEqual(c['openleague']['map_id_enabled_in_code'],10)
        self.assertEqual(c['openleague']['tick_rate_hz'],30);self.assertEqual(c['community']['default_game_port'],5119)
        self.assertEqual(c['master']['default_bind'],'0.0.0.0:8080')
    def test_12_wrong_availability_refused(self):
        d=copy.deepcopy(self.doc);d['availability'][0]['present']=True
        with self.assertRaisesRegex(ConfigEvidenceError,'Disponibilité'):verify(d,R)
    def test_13_changed_inventory_not_silently_accepted(self):
        d=copy.deepcopy(self.doc);d['community_settings'].pop()
        with self.assertRaisesRegex(ConfigEvidenceError,'Inventaire des configurations'):verify(d,R)
    def test_14_invalid_profile_structure_refused(self):
        with tempfile.TemporaryDirectory(dir=S) as td:
            p=pathlib.Path(td)/'GameInfo.json';p.write_text('{"game":{"map":"10","gameMode":"CLASSIC"},"players":[],"gameInfo":{}}')
            with self.assertRaisesRegex(ConfigEvidenceError,'Carte/mode'):summarize_settings(p)
    def test_15_plan_instruction_real_consumer(self):
        from instructions import make_instruction
        tasks=json.loads((R/'docs/completion_tasks_2026-10-20.json').read_bytes())['tasks'];t=next(x for x in tasks if x['id']=='SYS-01.1-03')
        h=json.loads((R/'docs/execution_plan_A_Z.json').read_bytes());p=next(x for x in h['packages'] if t['id'] in x['task_ids']);phase=next(x for x in h['phases'] if x['id']==p['phase'])
        text=make_instruction(t,phase,p,{t['id']:t},R,S)
        for v in ['4.20.0.315','0.0.1.68','5119','127.0.0.1:5896','Map11','reference_game_server_4_20.json']:
            self.assertIn(v,text)
        self.assertFalse(t['acceptance_complete']);self.assertEqual(t['human_acceptance'],'not_given')
if __name__=='__main__':unittest.main(verbosity=2)
