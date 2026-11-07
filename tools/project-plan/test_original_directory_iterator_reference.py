"""Real original iterator/scanner/config paths and explicit refusal controls."""
import json,pathlib,os,unittest
from original_directory_iterator_reference import OriginalPhysicalDirectoryScanner
from original_strstr_instruction_reference import NativeStrstrPcmp

R=pathlib.Path("E:/OpenLeague")
class GuestPages:
 def __init__(self,x):self.u=x.u;self.guarded=self
 def mem_read(self,a,n):
  if a<=0 or a+n>0x100000000 or not 0<=n<=65536:raise ValueError("Bounded guest read required")
  return self.u.mem_read(a,n)
class OriginalDirectoryIteratorTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.reference=json.loads((R/"docs/reference_client_4_20.json").read_bytes())
  cls.binary=pathlib.Path(cls.reference["source_root"])/cls.reference["client"]["binary"]
  cls.prior=json.loads((R/"docs/reference_native_skin_loader_sources/original-unpacked-filesystem-execution.json").read_bytes())
 def setUp(self):
  self.x=OriginalPhysicalDirectoryScanner(self.binary,[self.binary.parent],self.reference["source_root"])
  self.x.start();self.transport=NativeStrstrPcmp(GuestPages(self.x))
  self.x.attach_dll();self.boot=self.x.bootstrap();self.locale=self.x.initialize_locale()
  self.assertEqual(self.locale["locale"],"en_GB")
 def tearDown(self):
  self.x.close_all_read_handles();self.transport.close()
 def test_01_actual_names_and_types_through_full_original_factory_and_methods(self):
  x=self.x;directory="DATA/Characters/Aatrox/Skins"
  obj,table=x.open_iterator(directory+"/*")
  observed=x.collect_iterator(obj,table)
  expected=[{"name":e.name,"is_directory":e.is_dir(follow_symlinks=False)} for e in os.scandir(self.binary.parent/directory)]
  self.assertCountEqual(observed,expected)
  self.assertTrue(any(e["operation"]=="find_close" for e in x.dll_file_operations))
  self.assertIn(0x8b4830,x.case_visited);self.assertIn(0x8b9e30,x.case_visited)
  self.assertEqual(x.close_all_read_handles(),0)
 def test_02_actual_directory_hint_on_mixed_real_folder_is_not_a_python_filter(self):
  x=self.x;directory="DATA/Characters/Aatrox"
  obj,table=x.open_iterator(directory+"/*",4);observed=x.collect_iterator(obj,table)
  expected=[{"name":e.name,"is_directory":True} for e in os.scandir(self.binary.parent/directory) if e.is_dir(follow_symlinks=False)]
  self.assertCountEqual(observed,expected)
  self.assertTrue(any(e.get("search")==1 and e.get("filter_is_advisory_no_Python_filtering") for e in x.dll_file_operations))
 def test_03_absent_directory_returns_original_empty_iterator(self):
  x=self.x;directory="DATA/Characters/Akali/Skins"
  self.assertFalse((self.binary.parent/directory).exists())
  obj,table=x.open_iterator(directory+"/*")
  self.assertEqual(x.collect_iterator(obj,table),[])
 def test_04_native_nonbase_scan_alias_query_cache_and_typed_fields_compose(self):
  x=self.x;scan=x.discover_non_base("Aatrox",1);selection=x.filename_registered("Aatrox",1)
  self.assertTrue(scan["original_host_iterator_factory_executed"])
  self.assertTrue(scan["original_physical_iterator_factory_executed"])
  self.assertTrue(scan["original_skin_package_scan_executed"])
  self.assertTrue(selection["dedicated"]);self.assertEqual(selection["logical_name"],"Skin01.ini")
  logical=x.resolve_registered(selection["logical_name"])["path"]
  value=x.cached_scalar(logical,"MeshSkin","SkinScale",-1.);identity=x.identity_field("MeshSkin")
  old=next(row for row in self.prior["rows"] if row["champion"]=="Aatrox" and row["skin_num"]==1)
  self.assertEqual(value["float32_hex"],old["SkinScale_float32_hex"])
  for key in ["found","value","storage"]:self.assertEqual(identity[key],old["actual_native_fields"]["ChampionSkinID"][key])
  for field in ["ChampionSkinName","SimpleSkin","Skeleton","Texture","Animations"]:
   actual=x.string_field("MeshSkin",field);expected=old["actual_native_fields"][field]
   self.assertEqual((actual["found"],actual["value"]),(expected["found"],expected["value"]))
 def test_05_early_stop_closes_the_actual_readonly_find_handle(self):
  x=self.x;obj,table=x.open_iterator("DATA/Characters/Aatrox/Skins/*")
  self.assertTrue(x.invoke(x.rd(table),ecx=obj))
  self.assertEqual(x.close_all_read_handles(),1)
 def test_06_nul_nonascii_unqualified_mode_and_root_escape_refused_before_host_find(self):
  x=self.x;before=len(x.dll_file_operations)
  for query,mode,expected in [("DATA/Characters/Aatrox/*",8,"modes0/4"),("DATA/\0suffix/*",0,"ASCII"),("DATA/é/*",0,"ASCII"),("C:/Windows/*",0,"escaped declared root")]:
   with self.subTest(query=query,mode=mode),self.assertRaisesRegex(ValueError,expected):x.open_iterator(query,mode)
  self.assertEqual(len(x.dll_file_operations),before)
 def test_07_unknown_handle_and_unqualified_hint_fields_refused(self):
  x=self.x;marker=next(int(i["marker"],16) for i in x.game_find_iats if i["name"]=="FindNextFileA")
  with self.assertRaisesRegex(ValueError,"search identity"):x.invoke(marker,[0x12345678,x.work+0x3500])
  marker=next(int(i["marker"],16) for i in x.game_find_iats if i["name"]=="FindFirstFileExA")
  x.u.mem_write(x.work+0x3100,b"DATA/Characters/Aatrox/*\0")
  before=len(x.dll_file_operations)
  for level,filter_ptr,flags in [(3,0,0),(0,1,0),(0,0,4)]:
   with self.subTest(level=level,filter_ptr=filter_ptr,flags=flags),self.assertRaisesRegex(ValueError,"directory-hint"):
    x.invoke(marker,[x.work+0x3100,level,x.work+0x3500,1,filter_ptr,flags])
  self.assertEqual(len(x.dll_file_operations),before)
 def test_08_repeated_cold_context_repatches_iats_and_native_provider_slots(self):
  x=self.x;self.transport.close();x.start();self.transport=NativeStrstrPcmp(GuestPages(x))
  x.attach_dll();again=x.bootstrap();self.assertEqual(self.boot["provider_slots"],again["provider_slots"])
  self.assertEqual(len(x.game_find_iats),4)
  obj,table=x.open_iterator("DATA/Characters/Aatrox/Skins/*")
  self.assertTrue(x.collect_iterator(obj,table))
 def test_09_invalid_scan_identity_and_base_number_stay_explicit(self):
  x=self.x
  for champion,number in [("../Aatrox",1),("Aatrox",True),("Aatrox",0),("Aatrox",100)]:
   with self.subTest(champion=champion,number=number),self.assertRaises(ValueError):x.discover_non_base(champion,number)
  with self.assertRaisesRegex(ValueError,"DATA scan"):x.scan_files("../Characters/Aatrox")
  with self.assertRaisesRegex(ValueError,"wildcard"):x.scan_files("DATA/Characters/Aatrox","*.exe")
if __name__=="__main__":unittest.main(verbosity=2)
