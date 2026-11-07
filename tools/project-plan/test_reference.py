import copy,json,pathlib,sys,tempfile,unittest
from reference_client import validate,load_reference,reference_label,ReferenceError,extract_client
from instructions import make_instruction
STAGE=pathlib.Path(__file__).resolve().parent/'fixtures/reference-client'
class ReferenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.contract=json.loads((STAGE/"reference_client_4_20.json").read_text(encoding="utf-8"))
    def test_01_native_five_sources_and_exact_identity(self):
        d=validate(self.contract,verify_native=True)
        n=extract_client(pathlib.Path(d["source_root"])/d["client"]["binary"])
        self.assertEqual((n["date_iso"],n["time"],n["version"]),("2014-11-17","17:46:45","4.20.0.315"))
    def test_02_reject_wrong_region(self):
        d=copy.deepcopy(self.contract);d["reference"]["region"]="NA"
        with self.assertRaises(ReferenceError):validate(d)
    def test_03_reject_locale_inferred_from_available_french_files(self):
        d=copy.deepcopy(self.contract);d["reference"]["locale"]="fr_FR"
        with self.assertRaises(ReferenceError):validate(d)
    def test_04_reject_pe_date_as_reference_build_date(self):
        d=copy.deepcopy(self.contract);d["reference"]["date"]="2014-11-18"
        with self.assertRaises(ReferenceError):validate(d)
    def test_05_reject_unknown_timezone_or_deployment_claim(self):
        for path,value in [(("client","build_timezone"),"UTC"),(("regional_patch_deployment_date",),"2014-11-20")]:
            d=copy.deepcopy(self.contract)
            if len(path)==1:d[path[0]]=value
            else:d[path[0]][path[1]]=value
            with self.assertRaises(ReferenceError):validate(d)
    def test_06_reject_changed_source_and_missing_source(self):
        d=copy.deepcopy(self.contract);d["sources"][0]["sha256"]="0"*64
        with self.assertRaises(ReferenceError):validate(d,verify_native=True)
        with tempfile.TemporaryDirectory(dir=STAGE) as td:
            with self.assertRaises(ReferenceError):validate(self.contract,td,True)
    def test_07_reject_other_patch_or_traversal(self):
        d=copy.deepcopy(self.contract);d["client"]["version"]="4.21.0.1"
        with self.assertRaises(ReferenceError):validate(d)
        d=copy.deepcopy(self.contract);d["sources"][0]["path"]="../source.cfg"
        with self.assertRaises(ReferenceError):validate(d)
    def test_08_task_instruction_real_consumer_carries_date_region_and_source(self):
        t=json.loads((STAGE/"task-before.json").read_text(encoding="utf-8"))
        p={"id":"D01-SYS-01-1","title":"Référence historique et périmètre"}
        phase={"id":"D01","title":"Référentiel complet"}
        text=make_instruction(t,phase,p,{t["id"]:t},STAGE/"project",STAGE)
        for value in ["4.20.0.315","EUW","en_GB","2014-11-17","17:46:45","reference_client_4_20.json","date de déploiement non établie"]:
            self.assertIn(value,text)
        self.assertEqual(t["id"],"SYS-01.1-01")
    def test_09_missing_contract_not_misrepresented_as_verified(self):
        with tempfile.TemporaryDirectory(dir=STAGE) as td:
            with self.assertRaises(FileNotFoundError):load_reference(td)
            self.assertIn("identité du client à fixer",reference_label(td))
    def test_10_date_timezone_and_catalogue_are_separate(self):
        d=self.contract
        self.assertNotEqual(d["client"]["build_date"],d["client"]["pe_linker_timestamp_utc"][:10])
        self.assertIsNone(d["client"]["build_timezone"])
        self.assertEqual(d["catalogue"]["version"],"4.20.1")
        self.assertNotEqual(d["client"]["version"],d["catalogue"]["version"])
if __name__=="__main__":unittest.main(verbosity=2)
