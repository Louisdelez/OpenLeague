"""Read-only reconciliation of OpenLeague task, trace and audit evidence files."""
import collections
import csv
import datetime
import gc
import hashlib
import json
import pathlib
import re
import unicodedata

PROJECT = pathlib.Path('F:/OpenLeague')
DOCS = PROJECT / 'docs'
OUTPUT = pathlib.Path(__file__).resolve().parent
INPUTS = []

def emit(message):
    print(message, flush=True)

def read_json(name):
    path = DOCS / name
    before = path.stat()
    raw = path.read_bytes()
    data = json.loads(raw)
    after = path.stat()
    if (before.st_size, before.st_mtime_ns) != (after.st_size, after.st_mtime_ns):
        raise RuntimeError('Input changed while reading: ' + name)
    INPUTS.append({'path': 'docs/' + name, 'bytes': len(raw), 'sha256': hashlib.sha256(raw).hexdigest(),
                   'mtime_ns': after.st_mtime_ns, 'mtime_utc': datetime.datetime.fromtimestamp(after.st_mtime, datetime.timezone.utc).isoformat()})
    return data

def fold(text):
    return ''.join(c for c in unicodedata.normalize('NFD', text.lower()) if not unicodedata.combining(c))

def local_path(raw):
    value = str(raw).replace('\\', '/').strip('` \"')
    if value.lower().startswith(('e:/openleague/', 'f:/openleague/')):
        return PROJECT / value.split('/', 2)[2]
    if re.match(r'^[a-zA-Z]:/', value):
        return pathlib.Path(value)
    if value.startswith(('http:', 'https:', 'plugin:')):
        return None
    return PROJECT / value

def normalized_ref(raw):
    value = str(raw).replace('\\', '/').lower()
    if value.startswith(('e:/openleague/', 'f:/openleague/')):
        value = value.split('/', 2)[2]
    return value

def write_csv(name, rows, fields):
    with (OUTPUT / name).open('w', encoding='utf-8-sig', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=fields, extrasaction='ignore')
        writer.writeheader()
        for row in rows:
            writer.writerow({key: json.dumps(row.get(key), ensure_ascii=False) if isinstance(row.get(key), (list, dict)) else row.get(key) for key in fields})

def count_by(rows, key):
    return dict(collections.Counter(str(row.get(key)) for row in rows))

emit('1/7 — registre des tâches et périmètre')
task_document = read_json('completion_tasks_2026-10-20.json')
tasks = {}
for item in task_document['tasks']:
    if item['id'] in tasks:
        raise RuntimeError('Duplicate task ID: ' + item['id'])
    fields = ['id', 'domain', 'phase', 'title', 'kind', 'status', 'required', 'required_if', 'depends_on', 'entity', 'task_group',
              'implementation_complete', 'acceptance_complete', 'technical_verification_complete', 'human_acceptance', 'evidence']
    tasks[item['id']] = {field: item.get(field) for field in fields}
metadata = {'declared_counts': task_document['counts'], 'scope': task_document.get('scope'),
            'counting_limit': task_document.get('counting_limit'), 'retired_aggregate_count': len(task_document.get('retired_aggregate_tasks', []))}
del task_document
gc.collect()
execution = read_json('execution_plan_A_Z.json')
packages = execution['packages']
phase_names = {phase['id']: phase['title'] for phase in execution['phases']}
task_package = execution['task_to_package']
for item in tasks.values():
    item['package'] = task_package.get(item['id'])
del execution
gc.collect()
coverage = read_json('coverage.json')
domain_names = {item['id']: item['title'] for item in coverage.get('lots', [])}
coverage_top = {'complete': coverage.get('complete'), 'generated_utc': coverage.get('generated_utc'), 'updated_utc': coverage.get('updated_utc')}
del coverage
gc.collect()

emit('2/7 — sources et vérification mécanique des ancres courantes')
source_document = read_json('fidelity_sources_4_20.json')
sources = {item['source_id']: {'path': item['path'], 'kind': item.get('kind'), 'sha256': item.get('sha256'),
                             'identity_recorded_verified': item.get('source_identity_verified')} for item in source_document['sources']}
consumers = {item['consumer_id']: item for item in source_document['consumers']}
registered_paths = {normalized_ref(item['path']) for item in sources.values()}
source_counts = {'sources': len(sources), 'consumers': len(consumers), 'kinds': count_by(source_document['sources'], 'kind'),
                 'identity_recorded_verified': sum(bool(item.get('source_identity_verified')) for item in source_document['sources'])}
del source_document
gc.collect()
file_lines = {}
anchor_rows = []
for consumer in consumers.values():
    path = local_path(consumer['path'])
    key = str(path)
    if key not in file_lines:
        try:
            file_lines[key] = path.read_text(encoding='utf-8-sig').splitlines() if path and path.is_file() else None
        except (OSError, UnicodeError):
            file_lines[key] = None
    lines = file_lines[key]
    line = consumer.get('line', 0)
    needle = consumer.get('needle', '')
    if lines is None:
        state, matches = 'fichier_non_accessible', []
    elif not isinstance(line, int) or not needle:
        state, matches = 'ancre_incomplete', []
    elif 1 <= line <= len(lines) and needle in lines[line - 1]:
        state, matches = 'ligne_exacte', [line]
    else:
        matches = [index + 1 for index, value in enumerate(lines) if needle in value]
        state = 'deplacee_unique' if len(matches) == 1 else 'deplacee_ambigue' if matches else 'texte_non_retrouve'
    consumer['_anchor_state'] = state
    anchor_rows.append({'consumer_id': consumer['consumer_id'], 'path': consumer['path'], 'role': consumer.get('role'),
                        'recorded_line': line, 'anchor_state': state, 'found_lines': matches,
                        'qualification_kind': consumer.get('qualification_kind'), 'provides_feature_consumer': consumer.get('provides_feature_consumer')})
anchor_counts = dict(collections.Counter(row['anchor_state'] for row in anchor_rows))
del file_lines

emit('3/7 — rapprochement exhaustif des exigences et des liens')
trace_document = read_json('fidelity_requirement_trace_4_20.json')
trace_counts = {'statuses': count_by(trace_document['requirements'], 'status'), 'recorded_counts': trace_document['counts']}
trace_ids = set()
broken_refs = []
linked_unknown_ids = set()
for row in trace_document['requirements']:
    identifier = row['task_id']
    if identifier in trace_ids:
        raise RuntimeError('Duplicate trace task: ' + identifier)
    trace_ids.add(identifier)
    if identifier not in tasks:
        broken_refs.append({'task_id': identifier, 'kind': 'trace_without_task'})
        continue
    task = tasks[identifier]
    excluded = {item['consumer_id'] for item in row.get('consumer_scope_exclusions', [])}
    linked = []
    for cid in row['current_consumers']:
        if cid not in consumers:
            broken_refs.append({'task_id': identifier, 'kind': 'missing_consumer', 'id': cid})
        elif cid not in excluded:
            linked.append(consumers[cid])
    other_than_plan = [item for item in linked if item.get('role') != 'plan_requirement_consumer']
    usable = [item for item in other_than_plan if item.get('qualification_kind') != 'entry_boundary_only' and item.get('provides_feature_consumer') is not False]
    task.update({'requirement_id': row['requirement_id'], 'trace_status': row['status'],
                 'native_source_count': len({item['source_id'] for item in row['native_inputs']}),
                 'reference_source_count': len({item['source_id'] for item in row['reference_inputs']}),
                 'consumer_count': len(linked), 'nonplan_consumer_count': len(other_than_plan),
                 'nonboundary_consumer_count': len(usable), 'excluded_consumer_count': len(excluded),
                 'exact_anchor_count': sum(item['_anchor_state'] == 'ligne_exacte' for item in usable),
                 'locatable_anchor_count': sum(item['_anchor_state'] in {'ligne_exacte', 'deplacee_unique'} for item in usable),
                 'unknown_ids': row.get('unknown_ids', []), 'resolved_unknown_ids': row.get('resolved_unknown_ids', []),
                 'native_source_ids': sorted({item['source_id'] for item in row['native_inputs']}),
                 'consumer_ids': [item['consumer_id'] for item in linked]})
    linked_unknown_ids.update(row.get('unknown_ids', []))
    for item in row['native_inputs'] + row['reference_inputs']:
        if item['source_id'] not in sources:
            broken_refs.append({'task_id': identifier, 'kind': 'missing_source', 'id': item['source_id']})
    for key in ('native_inputs', 'reference_inputs'):
        if key == 'reference_inputs':
            task['registered_reference_paths'] = sorted({sources[item['source_id']]['path'] for item in row[key] if item['source_id'] in sources})
del trace_document
gc.collect()

emit('4/7 — inconnues, conditions de reprise et regroupements')
unknown_document = read_json('fidelity_unknowns_4_20.json')
unknown_rows = []
unknowns_by_task = collections.defaultdict(list)
for unknown in unknown_document['unknowns']:
    task_id = unknown.get('task_id')
    task = tasks.get(task_id, {})
    row = {key: unknown.get(key) for key in ('unknown_id', 'task_id', 'requirement_id', 'aspect', 'status', 'question', 'resolution_condition')}
    row.update({'phase': task.get('phase'), 'required': task.get('required'), 'research_count': len(unknown.get('research_performed', [])),
                'resolution_evidence_recorded': bool(unknown.get('resolution_evidence'))})
    unknown_rows.append(row)
    unknowns_by_task[task_id].append(row)
unknown_counts = {'total': len(unknown_rows), 'statuses': count_by(unknown_rows, 'status'),
                  'open_aspects': dict(collections.Counter(item['aspect'] for item in unknown_rows if item['status'] == 'open')),
                  'open_missing_reprise_condition': sum(not str(item.get('resolution_condition') or '').strip() for item in unknown_rows if item['status'] == 'open')}
del unknown_document
gc.collect()
unknown_idset = {item['unknown_id'] for item in unknown_rows}
for uid in linked_unknown_ids - unknown_idset:
    broken_refs.append({'kind': 'missing_unknown', 'id': uid})
for task in tasks.values():
    task['open_unknown_count'] = sum(item['status'] == 'open' for item in unknowns_by_task.get(task['id'], []))
    task['resolved_unknown_count'] = sum(item['status'] == 'resolved' for item in unknowns_by_task.get(task['id'], []))

emit('5/7 — rapports dédiés, déclarations et liens explicites')
report_rows = []
reports_by_task = collections.defaultdict(list)
source_reports_by_task = collections.defaultdict(list)
known_task_ids = set(tasks)
token_pattern = re.compile(r'[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)+')
closure_pattern = re.compile(r'(?:sous.audit|audit(?:\s+du\s+lot)?|lot|unite)[^\n.]{0,100}\b(?:clos|close|cloture|cloturee|termine|terminee)\b|\b(?:clos|cloture|termine)\s+pour\b')
for path in sorted(DOCS.glob('*.md')):
    name = path.name
    if not name.startswith(('AUDIT_', 'REVIEW_', 'FIDELITY_', 'REFERENCE_')):
        continue
    raw = path.read_bytes()
    text = raw.decode('utf-8-sig', errors='replace')
    normalized = fold(text)
    category = 'audit' if name.startswith('AUDIT_') else 'review' if name.startswith('REVIEW_') else 'source_reference'
    mentions = sorted(set(token_pattern.findall(text)) & known_task_ids)
    units = sorted(set(re.findall(r'\bAUD-[A-Za-z0-9][A-Za-z0-9._-]+', text[:5000])))
    headings = re.findall(r'^#{1,4}\s+(.+)$', text, re.M)
    row = {'path': 'docs/' + name, 'kind': category, 'bytes': len(raw), 'sha256': hashlib.sha256(raw).hexdigest(),
           'explicit_task_mentions': mentions, 'early_audit_ids': units,
           'closure_wording_present': bool(closure_pattern.search(normalized)),
           'numbered_sections_1_to_7': all(re.search(r'^##\s+' + str(i) + r'[.) —-]', text, re.M) for i in range(1, 8)),
           'registered_as_source': normalized_ref('docs/' + name) in registered_paths,
           'headings': headings[:24]}
    report_rows.append(row)
    for identifier in mentions:
        (reports_by_task if category == 'audit' else source_reports_by_task)[identifier].append(row['path'])

emit('6/7 — matrice par exigence et bilan par domaine')
presence = {}
for task in tasks.values():
    evidence_paths = task['evidence'] or []
    evidence_present = []
    evidence_missing = []
    for reference in evidence_paths:
        key = str(reference)
        if key not in presence:
            path = local_path(reference)
            presence[key] = bool(path and (path.is_dir() if key.endswith(('/', '\\')) else path.is_file()))
        (evidence_present if presence[key] else evidence_missing).append(key)
    task['evidence_present_count'] = len(evidence_present)
    task['evidence_missing_count'] = len(evidence_missing)
    task['missing_evidence_paths'] = evidence_missing
    task['audit_reports_explicit'] = reports_by_task.get(task['id'], [])
    task['source_reports_explicit'] = source_reports_by_task.get(task['id'], [])
    if task['audit_reports_explicit']:
        bucket = 'rapport_audit_mentionnant_la_tache_a_relire'
    elif not task.get('native_source_count') or not task.get('nonboundary_consumer_count'):
        bucket = 'lien_source_ou_consommateur_a_preciser'
    elif not task.get('locatable_anchor_count'):
        bucket = 'ancre_courante_a_reconcilier'
    else:
        bucket = 'liaison_documentee_audition_semantique_a_consolider'
    task['audit_work_bucket'] = bucket
    task['whole_requirement_audit_closed'] = None
    task['audit_closure_reason'] = 'Non certifie automatiquement : mentions, statuts du jeu et liens ne demontrent pas les sept criteres pour toute cette exigence.'

phase_rows = []
for phase in sorted(phase_names):
    subset = [item for item in tasks.values() if item['phase'] == phase]
    phase_rows.append({'phase': phase, 'title': domain_names.get(phase[1:], phase_names[phase]), 'requirements': len(subset),
        'required_now': sum(item['required'] is True for item in subset), 'conditional': sum(item['required'] is not True for item in subset),
        'with_native_source': sum(bool(item.get('native_source_count')) for item in subset),
        'with_nonboundary_consumer': sum(bool(item.get('nonboundary_consumer_count')) for item in subset),
        'with_locatable_anchor': sum(bool(item.get('locatable_anchor_count')) for item in subset),
        'with_explicit_audit_report_mention': sum(bool(item['audit_reports_explicit']) for item in subset),
        'with_open_unknowns': sum(bool(item['open_unknown_count']) for item in subset),
        'open_questions': sum(item['open_unknown_count'] for item in subset),
        'work_buckets': count_by(subset, 'audit_work_bucket')})

integrity = {'task_ids_unique': len(tasks) == metadata['declared_counts']['atomic_tasks'],
             'task_trace_sets_equal': set(tasks) == trace_ids,
             'task_package_coverage': all(item['package'] for item in tasks.values()),
             'package_task_ids_match': set(tasks) == {identifier for package in packages for identifier in package['task_ids']},
             'broken_reference_count': len(broken_refs), 'broken_references': broken_refs[:100],
             'phase_total_equals_requirements': sum(item['requirements'] for item in phase_rows) == len(tasks),
             'unique_evidence_paths_checked': len(presence), 'present_evidence_paths': sum(presence.values()),
             'missing_evidence_paths': sum(not value for value in presence.values())}
for item in INPUTS:
    state = (PROJECT / item['path']).stat()
    item['unchanged_at_end'] = state.st_size == item['bytes'] and state.st_mtime_ns == item['mtime_ns']
integrity['all_input_stats_stable'] = all(item['unchanged_at_end'] for item in INPUTS)
summary = {'generated_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'scope': 'SYS-01.2-02 read-only global evidence reconciliation; not gameplay acceptance',
    'requirements': len(tasks), 'required_now': sum(item['required'] is True for item in tasks.values()),
    'conditional': sum(item['required'] is not True for item in tasks.values()), 'packages': len(packages),
    'task_metadata': metadata, 'task_statuses': count_by(tasks.values(), 'status'), 'task_kinds': count_by(tasks.values(), 'kind'),
    'implementation_complete_recorded': sum(item['implementation_complete'] is True for item in tasks.values()),
    'acceptance_complete_recorded': sum(item['acceptance_complete'] is True for item in tasks.values()),
    'technical_verification_complete_recorded': sum(item.get('technical_verification_complete') is True for item in tasks.values()),
    'source_counts': source_counts, 'trace_counts': trace_counts, 'anchor_counts': anchor_counts, 'unknown_counts': unknown_counts,
    'requirements_with_native_source': sum(bool(item.get('native_source_count')) for item in tasks.values()),
    'requirements_with_nonboundary_consumer': sum(bool(item.get('nonboundary_consumer_count')) for item in tasks.values()),
    'requirements_with_locatable_anchor': sum(bool(item.get('locatable_anchor_count')) for item in tasks.values()),
    'requirements_with_explicit_audit_report_mention': sum(bool(item['audit_reports_explicit']) for item in tasks.values()),
    'reports': {'counts_by_kind': count_by(report_rows, 'kind'),
                'audit_closure_wording_present': sum(item['kind'] == 'audit' and item['closure_wording_present'] for item in report_rows),
                'audit_reports_without_explicit_task_id': sum(item['kind'] == 'audit' and not item['explicit_task_mentions'] for item in report_rows),
                'audit_reports_not_in_frozen_source_registry': sum(item['kind'] == 'audit' and not item['registered_as_source'] for item in report_rows)},
    'work_buckets': count_by(tasks.values(), 'audit_work_bucket'), 'phases': phase_rows, 'integrity': integrity,
    'audits_closed_percentage': None, 'audit_closed_requirement_count': None,
    'percentage_limit': 'Les registres ne contiennent pas un statut de cloture audit par exigence et la relecture des sept criteres ne peut pas etre deduite des occurrences lexicales.',
    'coverage_snapshot': coverage_top, 'inputs': INPUTS}

emit('7/7 — génération des livrables séparés')
(OUTPUT / 'synthese.json').write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding='utf-8')
(OUTPUT / 'rapports_indexes.json').write_text(json.dumps(report_rows, ensure_ascii=False, indent=2), encoding='utf-8')
write_csv('exigences.csv', sorted(tasks.values(), key=lambda item: (item['phase'], item['package'] or '', item['id'])),
    ['id','phase','package','title','kind','required','required_if','status','implementation_complete','acceptance_complete',
     'native_source_count','reference_source_count','nonplan_consumer_count','nonboundary_consumer_count','exact_anchor_count','locatable_anchor_count',
     'open_unknown_count','resolved_unknown_count','evidence_present_count','evidence_missing_count','audit_work_bucket','audit_reports_explicit',
     'source_reports_explicit','missing_evidence_paths','unknown_ids','whole_requirement_audit_closed','audit_closure_reason'])
write_csv('inconnues.csv', unknown_rows, ['unknown_id','task_id','phase','required','aspect','status','question','resolution_condition','research_count','resolution_evidence_recorded'])
write_csv('ancres_consommateurs.csv', anchor_rows, ['consumer_id','path','role','recorded_line','anchor_state','found_lines','qualification_kind','provides_feature_consumer'])
write_csv('domaines.csv', phase_rows, ['phase','title','requirements','required_now','conditional','with_native_source','with_nonboundary_consumer','with_locatable_anchor','with_explicit_audit_report_mention','with_open_unknowns','open_questions','work_buckets'])
write_csv('rapports.csv', report_rows, ['path','kind','sha256','explicit_task_mentions','early_audit_ids','closure_wording_present','numbered_sections_1_to_7','registered_as_source'])
emit(json.dumps({key: summary[key] for key in ['requirements', 'required_now', 'conditional', 'reports', 'work_buckets', 'integrity']}, ensure_ascii=False, indent=2))
