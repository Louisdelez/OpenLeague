"""Independent checks over generated reconciliation artifacts, no source mutation."""
import collections
import csv
import hashlib
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent
PROJECT = pathlib.Path('F:/OpenLeague')

def rows(name):
    with (ROOT / name).open(encoding='utf-8-sig', newline='') as stream:
        return list(csv.DictReader(stream))

summary = json.loads((ROOT / 'synthese.json').read_text(encoding='utf-8'))
tasks = rows('exigences.csv')
task_ids = {row['id'] for row in tasks}
lots = rows('lots.csv')
unknowns = rows('inconnues.csv')
anchors = rows('ancres_consommateurs.csv')
reports = rows('rapports.csv')
closure = rows('relecture_clotures.csv')
unmapped = rows('rapports_sans_tache_explicite.csv')
checks = {}
checks['requirements_count'] = len(tasks) == summary['requirements'] == 42215
checks['requirements_unique'] = len({row['id'] for row in tasks}) == len(tasks)
checks['required_conditional_partition'] = sum(row['required'] == 'True' for row in tasks) == 24727 and sum(row['required'] == 'False' for row in tasks) == 17488
checks['packages_count'] = len(lots) == 2770
checks['package_sums'] = sum(int(row['requirements']) for row in lots) == len(tasks)
package_task_ids = [identifier for row in lots for identifier in row['task_ids'].split(';')]
checks['package_partition'] = len(package_task_ids) == len(set(package_task_ids)) == len(tasks) and set(package_task_ids) == {row['id'] for row in tasks}
checks['domains_count_and_sum'] = len(summary['phases']) == 24 and sum(row['requirements'] for row in summary['phases']) == len(tasks)
checks['work_buckets_partition'] = dict(collections.Counter(row['audit_work_bucket'] for row in tasks)) == summary['work_buckets']
checks['unknowns_count_and_unique'] = len(unknowns) == len({row['unknown_id'] for row in unknowns}) == 31706
checks['unknown_status_counts'] = dict(collections.Counter(row['status'] for row in unknowns)) == {'open': 26189, 'resolved': 5517}
checks['open_reprise_conditions_present'] = all(row['resolution_condition'].strip() for row in unknowns if row['status'] == 'open')
checks['unknowns_link_to_tasks'] = all(row['task_id'] in task_ids for row in unknowns)
checks['anchors_count_and_result'] = len(anchors) == 5759 and all(row['anchor_state'] == 'ligne_exacte' for row in anchors)
checks['reports_count'] = len(reports) == 809
checks['report_relecture_queues'] = len(closure) == 303 and len(unmapped) == 32
checks['no_false_requirement_closure'] = all(row['whole_requirement_audit_closed'] == '' for row in tasks) and summary['audits_closed_percentage'] is None
checks['directory_references_present'] = all((PROJECT / name).is_dir() for name in ['docs/reference_loading_return_sources', 'docs/reference_local_services_sources'])
checks['declared_evidence_presence'] = sum(int(row['evidence_missing_count']) for row in tasks) == 0 and summary['integrity']['present_evidence_paths'] == 1527
checks['input_files_unchanged'] = all((PROJECT / item['path']).stat().st_size == item['bytes'] and (PROJECT / item['path']).stat().st_mtime_ns == item['mtime_ns'] for item in summary['inputs'])
checks['sample_reports_identical'] = all(hashlib.sha256((PROJECT / item['report']).read_bytes()).hexdigest() == item['report_sha256'] for item in summary['manual_interpretation_review'])
checks['report_text_counts'] = all(token in (ROOT / 'BILAN_GLOBAL_GOAL_2026-11-03.md').read_text(encoding='utf-8') for token in ['42 215', '26 189', '5 759', '303', '32', '36 569', '5 343'])
result = {'passed': all(checks.values()), 'checks_passed': sum(checks.values()), 'checks_total': len(checks), 'checks': checks,
          'limits': 'Independent structural validation of the report artifacts; not an independent semantic audit of all game requirements.'}
(ROOT / 'VALIDATION_BILAN.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
manifest = []
for path in sorted(ROOT.iterdir()):
    if path.is_file() and path.name != 'MANIFESTE_SHA256.json':
        data = path.read_bytes()
        manifest.append({'path': path.name, 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()})
(ROOT / 'MANIFESTE_SHA256.json').write_text(json.dumps({'files':manifest}, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(result, ensure_ascii=False, indent=2))
if not result['passed']:
    raise SystemExit(1)
