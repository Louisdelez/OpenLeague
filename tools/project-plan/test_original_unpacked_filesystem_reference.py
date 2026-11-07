import hashlib,json,pathlib,struct,tempfile,unittest
from original_unpacked_filesystem_reference import OriginalUnpackedFilesystem
from original_strstr_instruction_reference import NativeStrstrPcmp
from unicorn.x86_const import *
R=pathlib.Path('E:/OpenLeague');S=pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision13')
class GuestPages:
 def __init__(self,x):self.u=x.u;self.guarded=self
 def mem_read(self,a,n):
  if a<=0 or a+n>0x100000000 or not 0<=n<=65536:raise ValueError('Bounded guest read required')
  return self.u.mem_read(a,n)
class UnpackedFilesystemTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.reference=json.loads((R/'docs/reference_client_4_20.json').read_bytes());cls.binary=pathlib.Path(cls.reference['source_root'])/cls.reference['client']['binary']
 def setUp(self):
  self.x=OriginalUnpackedFilesystem(self.binary,[self.binary.parent],self.reference['source_root']);self.x.start();self.transport=NativeStrstrPcmp(GuestPages(self.x));self.x.attach_dll();self.initial=self.x.bootstrap()
 def tearDown(self):self.x.close_all_read_handles();self.transport.close()
 def test_01_original_bootstrap_constructs_orders_and_deduplicates_without_supplied_slots(self):
  x=self.x;again=x.bootstrap()
  self.assertEqual(self.initial['provider_count'],2);self.assertEqual(again['provider_slots'],self.initial['provider_slots'])
  self.assertEqual([row['vtable'] for row in self.initial['provider_slots'][:2]],['0x10c9998','0x10c9854'])
  self.assertFalse(any(int(row['object'],16) in x.backend_objects for row in self.initial['provider_slots'][:2]))
  self.assertEqual(self.initial['RADS_manager'],'0x0');self.assertEqual(self.initial['game_RADS_initialized_flag'],0)
  missing=pathlib.Path(self.reference['source_root'])/'RADS/projects/lol_game_client_en_gb/releases/0.0.0.235/releasemanifest'
  self.assertFalse(missing.exists());self.assertTrue(any('lol_game_client_en_gb' in str(row) for row in x.dll_file_operations))
 def test_02_actual_locale_default_is_read_through_native_physical_wrapper(self):
  x=self.x;locale=x.initialize_locale();self.assertEqual(locale['locale'],'en_GB')
  opened=next(row for row in x.opened if row['logical'].lower().endswith('defaults/locale.cfg'))
  self.assertEqual(opened['bytes'],37);self.assertEqual(opened['sha256'],'053f2ad45a7d6c808ba0b394f6a101e985099a953e5a2c7575ab44467804b42f')
  for pc in [0x58f880,0x8b63a0,0x8b6280,0x8b5f90,0x8b61f0,0x8aec00,0x82d1a0]:self.assertIn(pc,x.case_visited)
  self.assertTrue(all(f['stream'].closed for f in x.crt_files.values()))
 def test_03_original_cache_hit_and_forced_reload_reuse_real_provider(self):
  x=self.x;first=x.cached_scalar('DATA/Characters/Akali/Akali.ini','MeshSkin','SkinScale',7.25)
  count=len(x.opened);second=x.cached_scalar('DATA/Characters/Akali/Akali.ini','MeshSkin','SkinScale',7.25)
  self.assertEqual(first['float32_hex'],'6766a63f');self.assertEqual(first['float32_hex'],second['float32_hex']);self.assertEqual(len(x.opened),count)
  third=x.cached_scalar('DATA/Characters/Akali/Akali.ini','MeshSkin','SkinScale',7.25,force=True)
  self.assertEqual(third['float32_hex'],first['float32_hex']);self.assertGreater(len(x.opened),count)
 def test_04_divergent_loose_reference_sources_stay_visible(self):
  x=self.x;x.initialize_locale();cheats=x.cached_string('DATA/CFG/Cheats.cfg','Cheats','GoldAmount')
  self.assertEqual(cheats['value'],'99950.0');self.assertEqual(cheats['new_opened_streams'][0]['bytes'],150)
  urf=x.cached_scalar('DATA/Characters/Urf/Urf.ini','Data','BaseHP',7.25)
  self.assertEqual(urf['float32_hex'],'00403a45');self.assertEqual(urf['new_opened_streams'][0]['bytes'],515)
 def test_05_missing_input_uses_original_default_not_an_invented_resource(self):
  x=self.x;r=x.cached_scalar('DATA/Characters/__MissingReferenceControl__/none.ini','MeshSkin','SkinScale',7.25)
  self.assertEqual(r['float32_hex'],'0000e840');self.assertEqual(r['new_opened_streams'],[])
  self.assertTrue(x.crt_events)
  self.assertTrue(all(e['operation']=='access' and e['exists'] is False for e in x.crt_events))
  self.assertTrue(all(e['found'] is False for e in r['original_scalar_events']))
 def test_06_all_write_modes_and_root_escape_refused_before_access(self):
  x=self.x;path=self.binary.parent/'DATA/Characters/Akali/Akali.inibin';before=hashlib.sha256(path.read_bytes()).hexdigest()
  x.u.mem_write(x.work+0x3100,str(path).encode()+b'\0')
  for mode in ['w','wb','a','r+']:
   x.u.mem_write(x.work+0x3500,mode.encode()+b'\0')
   with self.subTest(mode=mode),self.assertRaisesRegex(ValueError,'write/create'):x.invoke(0xc99533,[x.work+0x3600,x.work+0x3100,x.work+0x3500])
  x.u.mem_write(x.work+0x3500,b'rb\0');x.u.mem_write(x.work+0x3100,b'C:/Windows/System32/kernel32.dll\0')
  with self.assertRaisesRegex(ValueError,'escaped declared root'):x.invoke(0xc99533,[x.work+0x3600,x.work+0x3100,x.work+0x3500])
  self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(),before)
 def test_07_unknown_FILE_and_direct_layout_reads_are_refused(self):
  x=self.x
  with self.assertRaisesRegex(ValueError,'Unknown/closed'):x.invoke(0xc9cd17,[0x60001234])
  at=x.work+0x54100;x.u.mem_write(at,b'\xa1\x00\x01\x00\x60\xc3');x.allowed.append((at,at+6))
  with self.assertRaisesRegex(ValueError,'direct CRT FILE layout'):x.invoke(at)
 def test_08_read_bound_refusal_keeps_real_handle_cleanup_possible(self):
  x=self.x;path=self.binary.parent/'DATA/Characters/Akali/Akali.inibin'
  x.u.mem_write(x.work+0x3100,str(path).encode()+b'\0');x.u.mem_write(x.work+0x3500,b'rb\0')
  self.assertEqual(x.invoke(0xc99533,[x.work+0x3600,x.work+0x3100,x.work+0x3500]),0);ptr=x.rd(x.work+0x3600)
  with self.assertRaisesRegex(ValueError,'fread bound'):x.invoke(0xc9973d,[x.work+0x3800,1,65537,ptr])
  self.assertEqual(x.close_all_read_handles(),1);self.assertTrue(all(f['stream'].closed for f in x.crt_files.values()))
if __name__=='__main__':unittest.main(verbosity=2)
