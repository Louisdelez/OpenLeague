"""Per-requirement exclusions of retained consumer links; no gameplay inference."""


def consumer_scope_exclusions(row, consumers):
    entries = row.get('consumer_scope_exclusions', [])
    if not isinstance(entries, list):
        raise ValueError('Consumer scope exclusions must be a list')
    result = {}
    for entry in entries:
        if not isinstance(entry, dict):
            raise ValueError('Invalid consumer scope exclusion')
        cid = entry.get('consumer_id')
        if not isinstance(cid, str) or cid not in row['current_consumers'] or cid not in consumers:
            raise ValueError('Excluded consumer must retain an existing requirement link')
        if cid in result:
            raise ValueError('Duplicate consumer scope exclusion')
        if (entry.get('kind') != 'outside_requirement_scope'
                or entry.get('provides_feature_consumer') is not False):
            raise ValueError('Excluded consumer cannot claim the requested feature')
        if not row.get('unknown_ids'):
            raise ValueError('Excluded consumer needs an open requirement question')
        if any(not isinstance(entry.get(k), str) or not entry[k].strip()
               for k in ['reason', 'evidence_source_id', 'evidence_selector']):
            raise ValueError('Consumer scope exclusion needs a reason and precise evidence')
        if not any(e['source_id'] == entry['evidence_source_id']
                   and e.get('selector') == entry['evidence_selector']
                   and e.get('relation') == 'consumer_requirement_scope_evidence'
                   for e in row['reference_inputs']):
            raise ValueError('Consumer scope evidence must be linked to this requirement')
        result[cid] = entry
    return result


def consumer_instruction_line(consumer, root, exclusion=None):
    import pathlib
    location = f'{pathlib.Path(root)/consumer["path"]}:{consumer["line"]}'
    if exclusion is None:
        return f'- Consommateur actuel ({consumer["role"]}) : {location} ; {consumer["scope"]}.'
    return (f'- Référence conservée hors périmètre ({consumer["role"]}) : {location} ; '
            f'{exclusion["reason"]} Aucun consommateur de cette fonctionnalité '
            f'n’est démontré par ce lien. Preuve : {exclusion["evidence_source_id"]}'
            f'#{exclusion["evidence_selector"]}.')
