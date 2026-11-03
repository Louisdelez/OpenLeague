-- Additive v1: legacy tables and checkbox history are never rewritten.
CREATE TABLE IF NOT EXISTS work_assessments(
 task_id TEXT PRIMARY KEY REFERENCES tasks(id),
 audit TEXT NOT NULL DEFAULT 'a_examiner' CHECK(audit IN ('a_examiner','en_cours','termine_avec_preuves','bloque')),
 implementation TEXT NOT NULL DEFAULT 'non_evaluee' CHECK(implementation IN ('non_evaluee','absente','partielle','implementee')),
 verification TEXT NOT NULL DEFAULT 'non_executee' CHECK(verification IN ('non_executee','partielle','echec','reussie')),
 acceptance TEXT NOT NULL DEFAULT 'non_demandee' CHECK(acceptance IN ('non_demandee','a_valider','acceptee','refusee','non_applicable')),
 record TEXT NOT NULL DEFAULT '{}',parent_task_id TEXT REFERENCES tasks(id),revision INTEGER NOT NULL DEFAULT 0,updated_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS work_history(id TEXT PRIMARY KEY,task_id TEXT NOT NULL,before_json TEXT NOT NULL,after_json TEXT NOT NULL,created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS work_corrections(id TEXT PRIMARY KEY,task_id TEXT NOT NULL REFERENCES tasks(id),objective TEXT NOT NULL,record TEXT NOT NULL,parent_id TEXT REFERENCES work_corrections(id),implementation TEXT NOT NULL DEFAULT 'non_evaluee',verification TEXT NOT NULL DEFAULT 'non_executee',revision INTEGER NOT NULL DEFAULT 0,updated_at TEXT NOT NULL,UNIQUE(task_id,objective));
CREATE TABLE IF NOT EXISTS work_journeys(id TEXT PRIMARY KEY,definition TEXT NOT NULL,verification TEXT NOT NULL DEFAULT 'non_executee',record TEXT NOT NULL DEFAULT '{}',revision INTEGER NOT NULL DEFAULT 0,updated_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS work_snapshots(id TEXT PRIMARY KEY,created_at TEXT NOT NULL,data TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS work_migrations(version INTEGER PRIMARY KEY,applied_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS work_assessment_parent ON work_assessments(parent_task_id);
CREATE INDEX IF NOT EXISTS work_assessment_status ON work_assessments(audit,task_id);
CREATE INDEX IF NOT EXISTS work_correction_parent ON work_corrections(parent_id);
CREATE TRIGGER IF NOT EXISTS work_snapshot_no_update BEFORE UPDATE ON work_snapshots BEGIN SELECT RAISE(ABORT,'Dated snapshots are immutable'); END;
CREATE TRIGGER IF NOT EXISTS work_snapshot_no_delete BEFORE DELETE ON work_snapshots BEGIN SELECT RAISE(ABORT,'Dated snapshots are immutable'); END;
