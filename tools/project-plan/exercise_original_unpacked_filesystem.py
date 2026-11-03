"""Compose original bootstrap/providers/physical wrappers/cache/getters on668declared selections."""
import argparse,datetime,hashlib,json,pathlib,sys,traceback
from original_unpacked_filesystem_reference import OriginalUnpackedFilesystem
from original_strstr_instruction_reference import NativeStrstrPcmp
class GuestPages:
 def __init__(self,x):self.u=x.u;self.guarded=self
 def mem_read(self,a,n):
  if a<=0 or a+n>0x100000000 or not 0<=n<=65536:raise ValueError('Bounded guest memory observation required')
  return self.u.mem_read(a,n)
R=pathlib.Path('E:/OpenLeague');V=pathlib.Path(__file__).resolve().parent
def identity(p):
 p=pathlib.Path(p);return {'path':str(p),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
def main():
 global R
 parser=argparse.ArgumentParser();parser.add_argument('--root',default='E:/OpenLeague');parser.add_argument('--output',required=True);args=parser.parse_args();R=pathlib.Path(args.root)
 out=pathlib.Path(args.output);assert not out.exists(),'Preserve earlier receipt; choose a fresh output'
 reference=json.loads((R/'docs/reference_client_4_20.json').read_bytes());native=R/'docs/reference_native_skin_loader_sources/original-skin-resources-execution.json'
 prior=json.loads(native.read_bytes());assert prior['passed'] and len(prior['rows'])==668
 binary=pathlib.Path(reference['source_root'])/reference['client']['binary'];x=OriginalUnpackedFilesystem(binary,[binary.parent],reference['source_root'])
 rows=[];contexts=[];sources={};all_addresses=set();all_events=0;passed=False;t=None
 try:
  for begin in range(0,668,32):
   if t:t.close()
   x.start();t=NativeStrstrPcmp(GuestPages(x));attach=x.attach_dll();bootstrap=x.bootstrap();duplicate=x.bootstrap();locale=x.initialize_locale()
   assert bootstrap['provider_count']==2 and duplicate['provider_slots']==bootstrap['provider_slots'] and locale['locale']=='en_GB'
   for index in range(begin,min(begin+32,668)):
    old=prior['rows'][index];p=pathlib.Path(old['selected_compiled_source']['path']);logical=p.relative_to(binary.parent).as_posix()[:-3]
    scale=x.cached_scalar(logical,old['selected_section'],'SkinScale',0.0)
    fields={'ChampionSkinID':x.identity_field(old['selected_section'])}
    for field in ['ChampionSkinName','SimpleSkin','Skeleton','Texture','Animations']:fields[field]=x.string_field(old['selected_section'],field)
    illumination=x.cached_scalar(logical,old['selected_section'],'SelfIllumination',0.0)
    for field,actual in fields.items():
     expected=old['original_getter_fields'][field]
     assert (actual['found'],actual['value'])==(expected['found'],expected['value']),(index,field,actual,expected)
    assert scale['float32_hex']==old['original_getter_fields']['SkinScale']['float32_hex'],(index,'SkinScale')
    assert illumination['float32_hex']==old['original_getter_fields']['SelfIllumination']['float32_hex'],(index,'SelfIllumination')
    for item in x.opened:
     observed=identity(item['physical']);assert all(observed[k]==item[k] for k in ['bytes','sha256']);sources[str(pathlib.Path(item['physical']).resolve()).casefold()]=observed
    rows.append({'champion':old['champion'],'skin_num':old['skin_num'],'skin_id':old['skin_id'],'task_ids':old['task_ids'],
      'selected_logical_file_input':logical,'selected_section_input':old['selected_section'],'prior_row_index':index,
      'actual_cache_primary':scale['pair']['primary'],'actual_native_fields':fields,
      'SkinScale_float32_hex':scale['float32_hex'],'SelfIllumination_float32_hex':illumination['float32_hex'],
      'all_prior_original_getter_fields_match':True,'original_game_bootstrap_and_native_physical_wrapper_executed':True,
      'upstream_package_skin_selection_still_input':True,'historical_OS_process_qualified':False})
   all_addresses.update(x.case_visited);all_events+=len(t.events)
   contexts.append({'batch_begin':begin,'batch_end':len(rows),'attach':attach,'bootstrap':bootstrap,'duplicate_bootstrap':duplicate,'locale':locale,
     'original_addresses_count':len(x.case_visited),'corrected_instruction_events':len(t.events),'crt_read_calls':sum(z['operation']=='read' for z in x.crt_events),
     'closed_streams':len(x.read_streams),'no_read_handles_remaining':all(f['stream'].closed for f in x.crt_files.values()),
     'isolated_floating_state':x.evidence()['isolated_floating_state'],'RADS_file_operations':x.dll_file_operations,'bootstrap_loader_events':x.bootstrap_events})
   assert contexts[-1]['no_read_handles_remaining']
   print(json.dumps({'batch_completed':len(contexts),'selections_verified':len(rows),'of':668}),flush=True)
  reference_controls={'cheats':x.cached_string('DATA/CFG/Cheats.cfg','Cheats','GoldAmount'),
    'urf':x.cached_scalar('DATA/Characters/Urf/Urf.ini','Data','BaseHP',7.25)}
  assert reference_controls['cheats']['value']=='99950.0' and reference_controls['urf']['float32_hex']=='00403a45'
  for item in x.opened:
   observed=identity(item['physical']);assert all(observed[k]==item[k] for k in ['bytes','sha256']);sources[str(pathlib.Path(item['physical']).resolve()).casefold()]=observed
  all_addresses.update(x.case_visited)
  passed=True
 finally:
  cleanup=x.close_all_read_handles()
  if t:t.close()
  result={'schema':'openleague_original_unpacked_filesystem_corpus/v1','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':passed,
   'rows_count':len(rows),'named_fields_checked':len(rows)*8,'batch_contexts':len(contexts),'rows':rows,'contexts':contexts,'source_files':list(sources.values()),'reference_controls':reference_controls if passed else None,
   'source_files_count':len(sources),'unpacked_profile_evidence':x.evidence(),'host_windows_text_leaf_evidence':x.windows_text.evidence(),'original_addresses_count':len(all_addresses),'corrected_instruction_events':all_events,'cleanup_closed_read_handles':cleanup,
   'prior_original_selection_and_field_receipt':identity(native),'binary':identity(binary),'DLL':identity(x.dll_path),
   'producer':identity(__file__),'helpers':[identity(V/name) for name in ['original_unpacked_filesystem_reference.py','original_filesystem_bootstrap_reference.py','original_rads_runtime_reference.py','readonly_windows_text_reference.py','original_strstr_instruction_reference.py','pcmpistri_ordered_0c.py']],
   'scope':'Native58f880 and original provider construction/order/dedup then nativephysicalCRTFILEwrapper/cache/parser/getters. The logical file/section selection above remains the prior explicitly conditional selection; not full outer/base/package dispatch.',
   'adapters':['Mapped originalDLL pre-attached separately; game LoadLibrary/GetProcAddress leaves use exact PE identities/export table. No host originalDLL load.',
    'Read-only real host CRTopen/read/seek/close and metadata leaves; no guessed FILE layout admitted. Allocation/SSO/thread/clock/TLS/runtime/NLS/diagnostic boundaries explicit in helper sources.',
    'Two pinned PCMPISTRI sites corrected from preserved2123hardware cases; full6369source-strstr controls separately qualified. Current host NLS and guest padding are explicit, not historical state.'],
   'historical_OS_process_launched':False,'source_bytes_modified':False,'historical_effective_skin_precedence_qualified':False}
  out.write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
  print(json.dumps({'passed':passed,'rows':len(rows),'contexts':len(contexts),'sources':len(sources),'output':str(out)}),flush=True)
if __name__=='__main__':main()
