"""Read-only verification of the completed preparation publication, not the game."""
from pathlib import Path
import importlib.util
import json
import re

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('rads_process_publication_definition', HERE / 'install.py')
publication = importlib.util.module_from_spec(spec)
spec.loader.exec_module(publication)  # Definitions only; never main/prepare/publish.


def verify():
    p = publication
    require = p.require
    require(len(p.NATIVE_SHA) == 64, 'final native manifest not pinned')
    read_bytes = {}
    def read(path):
        raw = path.read_bytes()
        read_bytes[path] = raw
        return raw
    def checked(path, digest, size=None):
        raw = read(path)
        require(p.sha_bytes(raw) == digest and (size is None or len(raw) == size), 'hash/size mismatch: ' + str(path))
        return raw
    receipt_raw = read(p.RECEIPT)
    receipt = p.decode(receipt_raw)
    summary = receipt['summary']
    require(all(receipt[key] == value for key, value in summary.items()), 'flattened and nested summaries differ')
    require(summary['manifest_sha256'] == p.NATIVE_SHA and summary['static_audit_sha256'] == p.AUDIT_SHA
            and summary['final_review_sha256'] == p.FINAL_REVIEW_SHA
            and summary['receipt'] == p.RECEIPT.relative_to(p.R).as_posix(), 'publication identity mismatch')
    require(all(summary[key] is False for key in ['integrated', 'complete', 'rust_compiled', 'client_executed',
                                                'provider_connected', 'rendered']), 'unsupported completion/integration claim')
    require(summary['new_rust_tests'] == 0 and receipt['domain_statuses_changed'] is False
            and receipt['rust_test_counts_changed'] is False and receipt['static_audit_is_runtime_qualification'] is False,
            'unsupported Rust/domain/audit claim')
    require(receipt['archive_verified'] is True, 'archive flag missing')

    actual_files = {path.relative_to(p.A).as_posix() for path in p.A.rglob('*') if path.is_file()}
    require(actual_files == set(receipt['archived_files']), 'archive file set differs')
    for name, row in receipt['archived_files'].items():
        checked(p.inside(p.A, name), row['sha256'], row['bytes'])
    require(p.sha_bytes(read_bytes[p.A / 'manifest.json']) == p.NATIVE_SHA, 'native archive manifest mismatch')
    require(p.sha_bytes(read_bytes[p.A / 'static_review/manifest.json']) == p.AUDIT_SHA, 'audit archive manifest mismatch')
    require(p.sha_bytes(read_bytes[p.A / 'final_review/manifest.json']) == p.FINAL_REVIEW_SHA, 'final review archive manifest mismatch')
    require(summary['final_review_read_only'] is True, 'review execution scope changed')
    native = p.decode(read_bytes[p.A / 'manifest.json'])
    for prefix in ['', 'static_review/', 'final_review/']:
        manifest = p.decode(read_bytes[p.A / (prefix + 'manifest.json')])
        for name, row in manifest['files'].items():
            raw = read_bytes[p.inside(p.A, prefix + name)]
            require(p.sha_bytes(raw) == row['sha256'] and len(raw) == row['bytes'], 'archived package content differs')
    # Verify recorded facts against archived reports without executing their code.
    facts, next_action, html_section, limits = p.frozen_facts(
        native, lambda name:p.decode(read_bytes[p.inside(p.A, name)]),
        lambda path, digest, size=None:checked(Path(path), digest, size))
    require(all(summary[k] == value for k, value in facts.items()) and receipt['limits'] == limits
            and receipt['next_action'] == next_action, 'published facts differ from pinned evidence')
    for name in ['install.py', 'verify_published.py', 'README.md']:
        require(read(HERE / name) == read_bytes[p.A / 'publication' / name], 'publication tool changed: ' + name)

    prior = p.decode(checked(p.R / 'docs/loading_rads_native_preparation_receipt.json', p.PRIOR_SHA))
    shutdown = p.decode(checked(p.R / 'docs/normal_client_shutdown_validation.json', p.SHUTDOWN_SHA))
    require(receipt['prior_preparation_receipt_sha256'] == p.PRIOR_SHA
            and receipt['shutdown_receipt_sha256'] == p.SHUTDOWN_SHA, 'prior receipt references changed')
    require(shutdown['passed'] is True and shutdown['complete'] is False
            and shutdown['real_normal_client_wm_close_passed'] is True, 'shutdown qualification changed')
    assets = receipt['physical_assets_preserved']
    asset_receipt = p.decode(checked(p.inside(p.R, assets['receipt']), p.ASSET_RECEIPT_SHA))
    checked(p.inside(p.R, assets['manifest']), assets['manifest_sha256'])
    require(all(asset_receipt[key] == value for key, value in assets.items()), 'asset evidence differs')
    require((assets['champions'], assets['files'], assets['images'], assets['inibin']) == (122, 1178, 720, 458)
            and all(assets[key] is False for key in ['complete', 'provider_connected', 'rendered']), 'asset scope changed')

    expected_documents = {'docs/coverage.json', 'docs/resume_checkpoint.json',
                          'docs/completion_plan.json', 'docs/completion_plan.html'}
    require(set(receipt['original_document_sha256']) == expected_documents
            and set(receipt['published_document_sha256']) == expected_documents, 'document set changed')
    backup = Path(receipt['backup'])
    require(backup.resolve().is_relative_to((p.R / 'docs/plan_history').resolve()), 'backup outside history')
    require({path.relative_to(backup).as_posix() for path in backup.rglob('*') if path.is_file()}
            == {Path(name).name for name in expected_documents}, 'backup file set changed')
    for relative in sorted(expected_documents):
        path = p.inside(p.R, relative)
        old_raw = checked(backup / path.name, receipt['original_document_sha256'][relative])
        raw = checked(path, receipt['published_document_sha256'][relative])
        if path.suffix == '.html':
            matches = list(re.finditer(rb'<section id="loading-rads-process-preparation">.*?</section>', raw, flags=re.S))
            require(len(matches) == 1, 'HTML preparation section missing/duplicated')
            part = matches[0]
            require(part.group() == html_section.encode('utf-8'), 'published HTML facts differ')
            require(raw[:part.start()] + raw[part.end():] == old_raw, 'unrelated HTML content changed')
            require(b'id="normal-client-shutdown-validation"' in raw, 'shutdown HTML proof lost')
            continue
        old, current = p.decode(old_raw), p.decode(raw)
        require(current[p.FIELD] == summary and current['complete'] is False, 'three document summaries differ')
        require(current['next_action'] == receipt['next_action'], 'next action differs')
        require(current[p.ASSETS] == old[p.ASSETS] == assets, 'asset summary altered')
        require(current['loading_rads_native_preparation'] == old['loading_rads_native_preparation']
                and current['loading_rads_native_preparation']['manifest_sha256'] == prior['manifest_sha256'], 'prior RADS evidence altered')
        require(current['normal_client_shutdown_validation'] == old['normal_client_shutdown_validation']
                and all(shutdown[key] == value for key, value in current['normal_client_shutdown_validation'].items()),
                'shutdown summary altered')
        allowed = {p.FIELD, 'next_action', 'updated_utc'}
        if path.name == 'resume_checkpoint.json':
            require(current['state'] == old['state'] == 'active', 'checkpoint state changed')
            require(current['communication_preferences'] == old['communication_preferences']
                    and 'Do not repeat' in current['communication_preferences']['progress_dashboard_repetition'],
                    'communication preference changed')
            allowed.add('saved_utc')
        if path.name == 'completion_plan.json':
            require(current['counts'] == old['counts'] and len(current['domains']) == 24
                    and sum(len(d['tasks']) for d in current['domains']) == 114
                    and current['counts']['additional_requirements'] == 37, 'plan scope/counts changed')
            require(current['next_execution_steps'][0] == current['next_action']
                    and current['next_execution_steps'][1:] == old['next_execution_steps'][1:], 'plan execution tail changed')
            for before, after in zip(old['domains'], current['domains']):
                if before['id'] in ['02', '17']:
                    require({k:v for k,v in before.items() if k != 'progress_evidence'} ==
                            {k:v for k,v in after.items() if k != 'progress_evidence'}, 'domain state/tasks changed')
                    links = list(before.get('progress_evidence', []))
                    if summary['receipt'] not in links:
                        links.append(summary['receipt'])
                    require(after['progress_evidence'] == links, 'domain evidence changed beyond appended link')
                else:
                    require(before == after, 'unrelated domain changed')
            allowed.update(['domains', 'next_execution_steps'])
        require({k:v for k,v in old.items() if k not in allowed} ==
                {k:v for k,v in current.items() if k not in allowed}, 'unrelated history/proof/state changed')
    for path, raw in read_bytes.items():
        require(path.read_bytes() == raw, 'evidence changed during verification: ' + str(path))
    return dict(publication_verified=True, complete=False, receipt=str(p.RECEIPT),
                receipt_sha256=p.sha_bytes(receipt_raw), archived_files=len(actual_files),
                documents_verified=4, native_manifest_sha256=p.NATIVE_SHA, static_audit_sha256=p.AUDIT_SHA,
                final_review_sha256=p.FINAL_REVIEW_SHA,
                shutdown_receipt_preserved=True, physical_assets_preserved=True,
                plan_domains=24, plan_tasks=114, additional_requirements=37,
                checkpoint_state='active', communication_preferences_preserved=True,
                new_native_probe_or_rust_test_executed=False)


if __name__ == '__main__':
    print(json.dumps(verify(), indent=2, ensure_ascii=False))
