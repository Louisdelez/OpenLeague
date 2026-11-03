"""Technical qualification must never check the user's todo automatically."""
from pathlib import Path
import sys,tempfile,json,unittest
sys.path.insert(0,"E:/OpenLeague/tools/project-plan")
from store import Store
STAGE=Path(__file__).resolve().parent
class ManualProgress(unittest.TestCase):
    def test_technical_acceptance_does_not_check_a_new_task_or_erase_a_manual_choice(self):
        with tempfile.TemporaryDirectory(dir=STAGE) as td:
            root=Path(td);(root/"docs").mkdir()
            t={"id":"TEST-MANUAL","domain":"01","title":"Test du suivi manuel","kind":"work","status":"termine",
               "required":True,"required_if":None,"legacy_parent":"01.1","depends_on":[],"acceptance":"Résultat technique",
               "evidence_required":[],"entity":None,"acceptance_complete":True,"implementation_complete":True}
            package={"id":"P1","phase":"D01","title":"Suivi","task_ids":[t["id"]],"requires_packages":[]}
            phase={"id":"D01","title":"Suivi manuel","deliverable":"Contrôle","exit_criteria":"Vérifié","all_dependency_phases":[]}
            (root/"docs/completion_tasks_2026-10-20.json").write_text(json.dumps({"tasks":[t]}),encoding="utf-8")
            (root/"docs/execution_plan_A_Z.json").write_text(json.dumps({"task_to_package":{t["id"]:"P1"},"packages":[package],"phases":[phase]}),encoding="utf-8")
            s=Store(root,root/"state")
            self.assertEqual(s.task(t["id"])["done"],0)
            s.change([{"id":t["id"],"revision":0,"done":True,"notes":"Choix utilisateur"}])
            with s.db() as c:c.execute("UPDATE meta SET value='refresh' WHERE key='catalog_version'");c.commit()
            s.sync_catalog()
            self.assertEqual((s.task(t["id"])["done"],s.task(t["id"])["notes"]),(1,"Choix utilisateur"))
            s.change([{"id":t["id"],"revision":1,"done":False}])
            self.assertEqual(s.task(t["id"])["done"],0)
if __name__=="__main__":unittest.main(verbosity=2)
