import copy,json,pathlib,tempfile,unittest
import test_source_versions as prior
from source_versions import SourceVersionError,validate_history,prepare_version

class RelocatedHistoryTests(unittest.TestCase):
    def setUp(self):
        self.f=prior.SourceVersionsTests('test_12_no_history_is_backward_compatible');self.f.setUp();self.addCleanup(self.f.doCleanups)
        self.temp=tempfile.TemporaryDirectory();self.addCleanup(self.temp.cleanup);self.root=pathlib.Path(self.temp.name)
        self.record,self.archive=self.f.version();self.before=copy.deepcopy(self.record)
        self.config={'schema':'openleague-project-location/v1','active_root':str(self.root),'previous_root':str(self.f.root),'external_historical_sources_preserved':True}
        self.location=self.root/'docs/project_location.json';self.location.parent.mkdir();self.write()
    def write(self):self.location.write_text(json.dumps(self.config),encoding='utf-8')
    def test_archived_history_validates_without_rebinding(self):
        self.assertEqual(validate_history(self.record,self.root,True),1);self.assertEqual(self.record,self.before)
    def test_archived_record_cannot_adopt_new_version(self):
        with self.assertRaises(SourceVersionError):prepare_version(self.record,self.root,b'corrected',b'new',self.f.event,'reason','2026-10-23T00:00:00+00:00')
    def test_missing_declaration_refused(self):
        self.location.unlink()
        with self.assertRaises(SourceVersionError):validate_history(self.record,self.root,True)
    def test_wrong_active_root_refused(self):
        self.config['active_root']=str(self.f.root);self.write()
        with self.assertRaises(SourceVersionError):validate_history(self.record,self.root,True)
    def test_undeclared_historical_source_refused(self):
        self.config['previous_root']=str(self.root.parent/'not-a-declared-root');self.write()
        with self.assertRaises(SourceVersionError):validate_history(self.record,self.root,True)
    def test_overlapping_roots_refused(self):
        self.config['previous_root']=str(self.root.parent);self.write()
        with self.assertRaises(SourceVersionError):validate_history(self.record,self.root,True)
    def test_unpreserved_history_refused(self):
        self.config['external_historical_sources_preserved']=False;self.write()
        with self.assertRaises(SourceVersionError):validate_history(self.record,self.root,True)
    def test_changed_old_archive_refused(self):
        self.archive.write_bytes(b'changed')
        with self.assertRaises(SourceVersionError):validate_history(self.record,self.root,True)
    def test_changed_old_receipt_refused(self):
        self.f.event_path.write_bytes(b'changed')
        with self.assertRaises(SourceVersionError):validate_history(self.record,self.root,True)
    def test_active_copy_drift_is_not_certified_by_archived_validation(self):
        p=self.root/'data/4.20/animation_manifest.json';p.parent.mkdir(parents=True);p.write_bytes(b'different current work')
        self.assertEqual(validate_history(self.record,self.root,True),1)
        self.assertEqual(self.record,self.before);self.assertNotEqual(p.read_bytes(),self.f.path.read_bytes())

if __name__=='__main__':unittest.main(verbosity=2)