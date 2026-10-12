"""Record the bounded, Python-only verifier revision; never call full verify."""
from pathlib import Path
import ast
import hashlib
import json

HERE=Path(__file__).resolve().parent
STAGE=Path('E:/mapslol3v3/loading_clock_integration')
VERIFY=STAGE/'verify_client_commands.py'
SELFTEST=STAGE/'verify_client_commands_selftest.json'

def record(path):
    path=Path(path)
    raw=path.read_bytes()
    return {'path':str(path),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest()}

backups=[record(HERE/'backup'/name) for name in [
    'verify_client_commands.py','verify_checks_selftest.py','verify_client_commands_selftest.json']]
assert backups[0]['sha256']=='5d069944fd3ea93799651e9771c9f3b779bce32d584159198d87aeaa7ddefde5'
assert backups[1]['sha256']=='56de27c699cbb3f09f3c851b4b8d7625a0f131be3f6677f128a98299d2f2ecc6'
before=ast.parse((HERE/'backup/verify_client_commands.py').read_text(encoding='utf-8-sig'))
after=ast.parse(VERIFY.read_text(encoding='utf-8-sig'))
assert len(before.body)==len(after.body)
changed=[]
for old,new in zip(before.body,after.body):
    if ast.dump(old,include_attributes=False)!=ast.dump(new,include_attributes=False):
        assert isinstance(old,ast.FunctionDef) and isinstance(new,ast.FunctionDef)
        assert old.name==new.name=='verify_clock'
        changed.append(new.name)
assert changed==['verify_clock']
clock=next(n for n in after.body if isinstance(n,ast.FunctionDef) and n.name=='verify_clock')
dictionaries={target.id:ast.literal_eval(node.value)
              for node in clock.body if isinstance(node,ast.Assign)
              for target in node.targets if isinstance(target,ast.Name)
              and target.id in ['expected_retired','expected_shared_drop']}
assert dictionaries=={
    'expected_retired':{'engine_allocations':0,'active_workers':0,'handles':0,
                        'critical_sections':1,'scope_critical_section_reference':0x2d6ed58,
                        'critical_section_report_owners':3,'errors':[]},
    'expected_shared_drop':{'app_dropped':True,'clock_handle_dropped':True,
                           'critical_section_report_owners':1,'critical_section_failures':[],
                           'bank_and_sections_retired':True,'direct_os_deletion_count_observed':False},
}
receipt=json.loads(SELFTEST.read_text(encoding='utf-8-sig'))
assert receipt['passed'] is True and receipt['complete'] is False
for key in ['current_client_qualified','client_executed','compiler_executed','verify_full_commands_executed']:
    assert receipt[key] is False
assert len(receipt['corrupted_clock_reports_rejected'])==42
assert len(receipt['corrupted_archived_event_reports_rejected'])==3
assert receipt['archived_native_finite_samples_compared']==265
assert receipt['verifier_sha256']==record(VERIFY)['sha256']
assert receipt['selftest_sha256']==record(HERE/'verify_checks_selftest.py')['sha256']
manifest={
    'kind':'process_clock_verifier_shared_scope_retirement_revision',
    'complete':False,'production_modified':False,'client_executed':False,
    'compiler_executed':False,'full_command_qualification_run':False,
    'python_selftest_passed':True,'changed_verifier_functions':changed,
    'unchanged_verifier_top_level_ast_except_verify_clock':True,
    'strict_expected_dictionaries':dictionaries,
    'corrupt_clock_reports_rejected':42,'corrupt_event_reports_rejected':3,
    'archived_native_samples_compared':265,'archived_zero_frequency_samples_excluded':12,
    'backups':backups,
    'artifacts':[record(path) for path in [VERIFY,HERE/'verify_checks_selftest.py',SELFTEST,
        HERE/'record_revision.py']],
}
path=HERE/'manifest.json'
path.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest':record(path),'verifier':record(VERIFY),'selftest_receipt':record(SELFTEST),
                  'changed_functions':changed,'client_executed':False,'compiler_executed':False}))
