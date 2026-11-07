"""Revalidate historical classification evidence without claiming a fresh Rust run.

The original auditor and its receipts remain unchanged. This adapter preserves
its result and gives execution claims an explicit current/inherited scope.
"""
from pathlib import Path
import json
import audit_content_classification_reference as legacy


def revalidate(document, root=None):
    root = Path(root) if root is not None else Path(__file__).resolve().parents[2]
    result = legacy.audit(document, root, verify_files=True)
    if result.get('verified') is not True:
        raise ValueError('classification source audit did not verify')
    if result.get('native_or_game_executed') is not False:
        raise ValueError('unexpected execution scope in read-only source audit')
    return {
        'schema': 'openleague_content_classification_revalidation/v1',
        'verified': True,
        'legacy_audit_result': result,
        'fresh_execution': {
            'python_source_audit': True,
            'rust_test': False,
            'native_client': False,
            'game': False,
        },
        'inherited_evidence': {
            'rust_test_receipt_verified': result.get('rust_test_executed') is True,
            'receipt': str(root / 'docs/reference_content_classification_sources/rust-catalogue-test.json'),
        },
        'feature_scope_complete': False,
    }


if __name__ == '__main__':
    root = Path(__file__).resolve().parents[2]
    path = root / 'docs/reference_content_classification_sources/content_classification-links.json'
    print(json.dumps(revalidate(json.loads(path.read_bytes()), root), ensure_ascii=False))
