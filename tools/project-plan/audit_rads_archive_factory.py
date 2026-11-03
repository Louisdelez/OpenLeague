"""Audit pinned original-code archive experiments; do not infer runtime mounting."""
import argparse,hashlib,json,pathlib

def identity(p):
    p=pathlib.Path(p);b=p.read_bytes()
    return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}

def checked(row):
    expected={k:row[k] for k in ['path','bytes','sha256']}
    if identity(row['path'])!=expected:raise ValueError('Changed archive evidence: '+row['path'])
    return json.loads(pathlib.Path(row['path']).read_bytes())

def audit(root,receipt):
    root=pathlib.Path(root)
    if isinstance(receipt,(str,pathlib.Path)):receipt=json.loads(pathlib.Path(receipt).read_bytes())
    if receipt.get('schema')!='openleague_archive_factory_inputs/v1':raise ValueError('Archive audit contract schema')
    for row in receipt['identities']:checked_bytes=identity(row['path']);assert checked_bytes=={k:row[k] for k in ['path','bytes','sha256']},row['path']
    contract=checked(receipt['input_contract'])
    if contract['DLL']['sha256']!='60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521':raise ValueError('Wrong reference DLL')
    if pathlib.Path(contract['original_missing_directory']).exists():raise ValueError('Original archive directory no longer absent')
    source=checked(receipt['source_qualification'])
    assert source['passed'] and source['source_checks_count']==14 and all(source['source_checks'].values())
    outcomes={}
    for n in [32,33,34,35,36]:
        evidence=receipt['experiments'][str(n)];native=checked(evidence['native']);execution=checked(evidence['execution'])
        assert execution['exit_code']==(2 if n in [34,35] else 0)
        assert not execution['forced_owned_probe_process_termination'] and execution['outer_deadline_seconds']==180
        for row in [execution['log'],execution['producer'],execution['probe'],native['producer'],native['binary'],native['DLL'],native['archive_input_contract'],*native['helpers']]:
            assert identity(row['path'])=={k:row[k] for k in ['path','bytes','sha256']},row['path']
        assert native['DLL']==contract['DLL'] and native['binary']==contract['binary']
        assert not native['invalid_access'] and not native['source_instruction_bytes_changed'] and not native['historical_OS_process_launched']
        assert native['read_handles_closed_by_host_cleanup']==0 and native['virtual_handles_after_host_cleanup']==5
        assert not native['archive_namespace_mount_qualified'] and not native['native_archive_data_decompression_qualified']
        if n in [34,35]:
            assert not native['execution_completed'] and 'AssertionError' in native['error']
        else:
            assert native['execution_completed'] and not native.get('error') and native['input_string_unchanged'] and native['declared_no_stack_argument_return_verified']
        if n==32:
            assert native['factory_return']=='0x0' and native['DLL_file_sources']==[]
        elif n in [33,36]:
            assert int(native['factory_return'],16)!=0 and native['DLL_file_sources']==[contract['index']]
            reads=[o for o in native['DLL_file_operations'] if o['operation']=='read']
            assert len(reads)==1 and reads[0]['offset']==0 and reads[0]['requested']==4096 and reads[0]['bytes']==2455
        outcomes[n]=native
    cases=outcomes[36]['native_lookup_cases'];members=contract['members']
    assert len(members)==34 and len(cases)==71
    for row,case1,case2 in zip(members,cases[:68:2],cases[1:68:2],strict=True):
        for name,case in [(row['name'],case1),(row['name'].upper(),case2)]:
            assert case['name']==name and case['found'] and case['callee_pop16_verified'] and case['input_object_unchanged']
            assert (case['offset'],case['stored_bytes'])==(row['offset'],row['stored_bytes'])
            expected=pathlib.Path(contract['original_missing_directory'])/pathlib.Path(contract['data']['path']).name
            assert pathlib.Path(case['selected_data']).resolve()==expected.resolve()
    for case in cases[68:]:assert not case['found'] and (case['offset'],case['stored_bytes'],case['selected_data'])==(0,0,'')
    assert outcomes[36]['factory_heap_after_lookup_cleanup_unchanged'] and outcomes[36]['lookup_output_string_destructors_original']
    assert outcomes[36]['DLL_virtual_heap_blocks_at_stop']==73 and not outcomes[36]['manager_teardown_qualified']
    return {'passed':True,'source_checks':14,'successful_original_and_uppercase_lookups':68,'missing_or_empty_lookups':3,'index_bytes_read':2455,'failed_experiments_preserved':[34,35],'all_source_and_artifact_identities_checked':len(receipt['identities']),'full_manager_teardown_qualified':False,'archive_data_IO_or_decompression_freshly_qualified':False,'whole_native_or_Rust_mount_qualified':False,'human_acceptance':'not_given'}

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--receipt',required=True);args=p.parse_args()
    print(json.dumps(audit(args.root,args.receipt),indent=2))
