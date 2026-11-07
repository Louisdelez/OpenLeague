"""Full non-base native discovery through real native iterator and config chain."""
import argparse,collections,datetime,hashlib,json,pathlib,sys,traceback
from original_directory_iterator_reference import OriginalPhysicalDirectoryScanner
from original_strstr_instruction_reference import NativeStrstrPcmp
from reference_client import load_reference,validate
class GuestPages:
 def __init__(self,x):self.u=x.u;self.guarded=self
 def mem_read(self,a,n):
  if a<=0 or a+n>0x100000000 or not 0<=n<=65536:raise ValueError("Bounded guest read required")
  return self.u.mem_read(a,n)
def identity(p):
 p=pathlib.Path(p);return {"path":str(p),"bytes":p.stat().st_size,"sha256":hashlib.sha256(p.read_bytes()).hexdigest()}
def main():
 p=argparse.ArgumentParser();p.add_argument("--root",default="E:/OpenLeague");p.add_argument("--output",required=True);a=p.parse_args()
 root=pathlib.Path(a.root);out=pathlib.Path(a.output)
 if out.exists():p.error("Existing evidence is preserved; choose a new output.")
 reference=load_reference(root);validate(reference,verify_native=True)
 binary=pathlib.Path(reference["source_root"])/reference["client"]["binary"]
 catalogue_path=pathlib.Path(reference["catalogue"]["local_path"]);catalogue=json.loads(catalogue_path.read_bytes())
 assert catalogue["version"]=="4.20.1" and identity(catalogue_path)["sha256"]==reference["catalogue"]["sha256"]
 official={(champ,int(skin["num"])):int(skin["id"]) for champ,data in catalogue["data"].items() for skin in data["skins"] if int(skin["num"])!=0}
 old_path=root/"docs/reference_native_skin_loader_sources/original-directory-execution.json"
 old=json.loads(old_path.read_bytes());assert old["passed"] and old["rows_count"]==546
 assert {(r["champion"],r["skin_num"]):r["skin_id"] for r in old["rows"]}==official
 native_path=root/"docs/reference_native_skin_loader_sources/original-unpacked-filesystem-execution.json"
 native=json.loads(native_path.read_bytes());assert native["passed"] and native["rows_count"]==668
 known={(r["champion"],r["skin_num"]):r for r in native["rows"]}
 x=OriginalPhysicalDirectoryScanner(binary,[binary.parent],reference["source_root"])
 t=None;rows=[];contexts=[];actual_sources={};compiled={};counts=collections.Counter();diffs=[];all_addresses=set();error=None
 try:
  for index,previous in enumerate(old["rows"]):
   if t is None or index-contexts[-1]["batch_begin"]>=32 or x.scan_alloc>0x50080000 or x.scan_strings>0x50300000:
    if t:t.close()
    x.start();t=NativeStrstrPcmp(GuestPages(x));attach=x.attach_dll();bootstrap=x.bootstrap();duplicate=x.bootstrap();locale=x.initialize_locale()
    assert locale["locale"]=="en_GB" and duplicate["provider_slots"]==bootstrap["provider_slots"]
    contexts.append({"batch_begin":index,"attach":attach,"bootstrap":bootstrap,"duplicate_bootstrap":duplicate,"locale":locale})
    print(json.dumps({"phase":"cold_context_ready","context":len(contexts),"next_row":index,"locale":"en_GB"}),flush=True)
   champ,num=previous["champion"],previous["skin_num"]
   print(json.dumps({"phase":"discover","row":index,"champion":champ,"skin_num":num}),flush=True)
   scan=x.discover_non_base(champ,num);selection=x.filename_registered(champ,num);resolved=x.resolve_registered(selection["logical_name"])
   normalized={k:(v[5:] if v.startswith("DATA/") else v) for k,v in scan["entries"].items()}
   different=normalized!=previous["scan"]["entries"] or any(selection[k]!=previous["selection_in_non_base_map_only"][k] for k in ["logical_name","dedicated"])
   if different:diffs.append({"row":index,"champion":champ,"skin_num":num,"old_entries":previous["scan"]["entries"],"current_normalized_entries":normalized,"previous_selection":previous["selection_in_non_base_map_only"],"current_selection":selection})
   variant=f"Skin{num:02}.ini";payload=None
   if variant in scan["entries"]:
    assert selection["dedicated"] and selection["logical_name"]==variant
    logical=resolved["path"];physical=pathlib.Path(str(binary.parent/logical)+"bin")
    assert physical.resolve().is_relative_to(binary.parent.resolve())
    scale=x.cached_scalar(logical,"MeshSkin","SkinScale",-1.)
    fields={"ChampionSkinID":x.identity_field("MeshSkin")}
    for field in ["ChampionSkinName","SimpleSkin","Skeleton","Texture","Animations"]:fields[field]=x.string_field("MeshSkin",field)
    illumination=x.cached_scalar(logical,"MeshSkin","SelfIllumination",0.)
    assert fields["ChampionSkinID"]["found"] and int(fields["ChampionSkinID"]["value"])==official[(champ,num)]
    expected=known[(champ,num)]
    for field,value in fields.items():
     prior=expected["actual_native_fields"][field];assert (value["found"],value["value"])==(prior["found"],prior["value"]),(champ,num,field)
    assert scale["float32_hex"]==expected["SkinScale_float32_hex"] and illumination["float32_hex"]==expected["SelfIllumination_float32_hex"],(champ,num,"scalar")
    source=identity(physical);assert source["sha256"]==previous["compiled_config"]["source"]["sha256"]
    compiled[str(physical).casefold()]=source
    payload={"source":source,"logical":logical,"section":"MeshSkin","fields":fields,"SkinScale_float32_hex":scale["float32_hex"],"SelfIllumination_float32_hex":illumination["float32_hex"],"all_fields_match_prior_original_getters":True}
    category="dedicated_config_discovered_and_original_id_verified"
   else:category="no_dedicated_config_in_non_base_scan_base_legacy_context_open"
   counts[category]+=1
   for item in x.opened:
    actual=identity(item["physical"]);assert all(actual[k]==item[k] for k in ["bytes","sha256"]);actual_sources[str(pathlib.Path(item["physical"]).resolve()).casefold()]=actual
   for item in x.dll_file_sources:
    actual=identity(item["path"]);assert all(actual[k]==item[k] for k in ["bytes","sha256"]);actual_sources[str(pathlib.Path(item["path"]).resolve()).casefold()]=actual
   assert not any(isinstance(h,dict) and h.get("kind")=="find" for h in x.dll_handles.values())
   rows.append({"champion":champ,"skin_num":num,"skin_id":previous["skin_id"],"task_ids":known[(champ,num)]["task_ids"],"classification":category,"scan":scan,"selection_in_non_base_map_only":selection,"resolved_in_non_base_map_only":resolved,"compiled_config":payload,"discovery_matches_prior_normalized":not different,"full_historical_package_context_qualified":False})
   all_addresses.update(x.case_visited)
   contexts[-1].update(batch_end=len(rows),find_handles_all_closed=True,original_addresses_count=len(x.case_visited),corrected_instruction_events=len(t.events),find_operations=list(x.dll_file_operations),game_find_IATs=x.game_find_iats,isolated_floating_state=x.evidence()["isolated_floating_state"])
   if len(rows)%16==0:print(json.dumps({"processed":len(rows),"of":546,"contexts":len(contexts),"counts":dict(counts),"discovery_differences":len(diffs)}),flush=True)
 except BaseException:
  error=traceback.format_exc();print(error,flush=True)
 finally:
  cleanup=x.close_all_read_handles()
  if t:t.close()
  passed=error is None and len(rows)==546
  result={"schema":"openleague_original_native_directory_iterator_corpus/v1","utc":datetime.datetime.now(datetime.timezone.utc).isoformat(),"passed":passed,"rows_count":len(rows),"counts":dict(counts),"rows":rows,"contexts":contexts,"source_files":list(actual_sources.values()),"compiled_sources":list(compiled.values()),"compiled_named_fields_checked":len(compiled)*8,"differences_from_prior":diffs,"error":error,"cleanup_handles":cleanup,"original_addresses_count":len(all_addresses),"prior_directory_reference":identity(old_path),"prior_native_getter_reference":identity(native_path),"reference":identity(root/"docs/reference_client_4_20.json"),"catalogue":identity(catalogue_path),"binary":identity(binary),"DLL":identity(x.dll_path),"producer":identity(__file__),"helper":identity(pathlib.Path(__file__).with_name("original_directory_iterator_reference.py")),"profile_evidence":x.evidence(),"current_host_text_evidence":x.windows_text.evidence(),"source_bytes_modified":False,"historical_OS_process_launched":False,"full_original_package_constructor_qualified":False,"actual_current_Rust_skin_dispatch_qualified":False,"scope":"All546official non-base identities;originalscanner/iterator/alias/query/config chain. Outerone-context container,character/skin/DATAinputs remain declared;currentWin32/NLS/FP/order not historical state. Missing dedicated maps do not prove absent base/legacy/overlays."}
  out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
  print(json.dumps({"passed":passed,"rows":len(rows),"contexts":len(contexts),"counts":dict(counts),"compiled_sources":len(compiled),"discovery_differences":len(diffs),"output":str(out)}),flush=True)
 return 0 if passed else 1
if __name__=="__main__":raise SystemExit(main())
