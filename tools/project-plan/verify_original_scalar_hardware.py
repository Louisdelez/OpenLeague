"""Cross-check source scalar arithmetic on this CPU and in Unicorn.

Only the four source arithmetic/address instructions are copied. The literal
reference is relocated for x64 RIP addressing; ABI/capture/FP save/restore are
explicit probe code. No original historical process is launched.
"""
import argparse,ctypes,datetime,hashlib,json,pathlib,struct,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from original_config_reader_reference import OriginalConfigReader
from unicorn.x86_const import *

def identity(p):
 p=pathlib.Path(p);raw=p.read_bytes();return {'path':str(p),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest()}

def main():
 p=argparse.ArgumentParser();p.add_argument('--root',default=str(R));p.add_argument('--output',required=True);a=p.parse_args();root=pathlib.Path(a.root);out=pathlib.Path(a.output)
 if out.exists():p.error('Preserve existing hardware evidence.')
 if ctypes.sizeof(ctypes.c_void_p)!=8 or sys.platform!='win32':raise ValueError('This probe requires the current Windows x64 process')
 ref=json.loads((root/'docs/reference_client_4_20.json').read_bytes());binary=pathlib.Path(ref['source_root'])/ref['client']['binary'];reader=OriginalConfigReader(binary)
 start,stop=0x8af50a,0x8af51c;original=reader.image[start-reader.base:stop-reader.base]
 if original[:14]!=bytes.fromhex('0fb6c0f30f2ac08b450cf30f5905') or struct.unpack('<I',original[14:])[0]!=0x1138ac8:raise ValueError('Source arithmetic fragment changed')
 literal=reader.image[0x1138ac8-reader.base:0x1138ac8-reader.base+4]
 if literal!=bytes.fromhex('cdcccc3d'):raise ValueError('Source scalar factor changed')
 # Save RBP/MXCSR; set only a declared masked-exception rounding mode; supply
 # the source fragment's otherwise-unused output pointer load with zero.
 prefix=bytes.fromhex('554883ec304889e50fae5d00895504c7450c000000000fae550489c8')
 relocated=bytearray(original);struct.pack_into('<i',relocated,14,0x100-(len(prefix)+len(original)))
 suffix=bytes.fromhex('660f7ec00fae55004883c4305dc3')
 code=prefix+relocated+suffix
 getter=bytes.fromhex('4883ec080fae1c248b04244883c408c3')
 kernel=ctypes.WinDLL('kernel32',use_last_error=True)
 kernel.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32,ctypes.c_uint32];kernel.VirtualAlloc.restype=ctypes.c_void_p
 kernel.VirtualProtect.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32,ctypes.POINTER(ctypes.c_uint32)];kernel.VirtualProtect.restype=ctypes.c_int
 kernel.VirtualFree.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32];kernel.VirtualFree.restype=ctypes.c_int
 kernel.FlushInstructionCache.argtypes=[ctypes.c_void_p,ctypes.c_void_p,ctypes.c_size_t];kernel.FlushInstructionCache.restype=ctypes.c_int
 memory=kernel.VirtualAlloc(None,4096,0x3000,0x04)
 if not memory:raise ctypes.WinError(ctypes.get_last_error())
 cases=[]
 try:
  ctypes.memmove(memory,code,len(code));ctypes.memmove(memory+0x100,literal,4);ctypes.memmove(memory+0x180,getter,len(getter))
  previous=ctypes.c_uint32()
  if not kernel.VirtualProtect(memory,4096,0x20,ctypes.byref(previous)):raise ctypes.WinError(ctypes.get_last_error())
  if not kernel.FlushInstructionCache(ctypes.c_void_p(-1),memory,4096):raise ctypes.WinError(ctypes.get_last_error())
  function=ctypes.WINFUNCTYPE(ctypes.c_uint32,ctypes.c_uint32,ctypes.c_uint32)(memory)
  get_control=ctypes.WINFUNCTYPE(ctypes.c_uint32)(memory+0x180)
  reader.allowed=list(reader.original_ranges);frame=reader.work+0x10000;reader.w(frame+12,reader.work+0x3600)
  for mode,control in [('nearest_even',0x1f80),('downward',0x3f80),('upward',0x5f80),('toward_zero',0x7f80)]:
   for count in range(256):
    before_control=get_control();hardware=function(count,control);after_control=get_control()
    if after_control!=before_control:raise ValueError('Hardware probe failed to restore host MXCSR')
    reader.u.reg_write(UC_X86_REG_EAX,count);reader.u.reg_write(UC_X86_REG_EBP,frame);reader.u.reg_write(UC_X86_REG_MXCSR,control)
    reader.u.emu_start(start,stop,count=10)
    emulated=reader.u.reg_read(UC_X86_REG_XMM0)&0xffffffff
    cases.append({'rounding_mode':mode,'mxcsr_control':hex(control),'packed_byte':count,
                  'hardware_float32_hex':struct.pack('<I',hardware).hex(),'unicorn_float32_hex':struct.pack('<I',emulated).hex(),'matches':hardware==emulated,
                  'host_mxcsr_before':hex(before_control),'host_mxcsr_after':hex(after_control),'host_mxcsr_preserved':True})
 finally:
  if not kernel.VirtualFree(memory,0,0x8000):raise ctypes.WinError(ctypes.get_last_error())
 nearest=[x for x in cases if x['rounding_mode']=='nearest_even'];mismatches=[x for x in cases if not x['matches']]
 result={'schema':'openleague_original_scalar_cpu_crosscheck/v1','observed_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
  'nearest_even_cases':len(nearest),'nearest_even_all_match':all(x['matches'] for x in nearest),'all_rounding_cases':len(cases),'other_rounding_mismatches':len(mismatches),
  'all_rounding_modes_match':not mismatches,'all_hardware_call_host_mxcsr_preserved':all(x['host_mxcsr_preserved'] for x in cases),'source_binary':identity(binary),'source_fragment':{'start':hex(start),'stop':hex(stop),'original_bytes_hex':original.hex(),'sha256':hashlib.sha256(original).hexdigest()},
  'source_constant':{'address':'0x1138ac8','float32_hex':literal.hex()},'x64_probe':{'bytes_hex':code.hex(),'sha256':hashlib.sha256(code).hexdigest(),'literal_offset':0x100,'mxcsr_getter_offset':0x180,'mxcsr_getter_bytes_hex':getter.hex(),
    'adaptation':'Original four-instruction bytes with only the MULSS literal displacement relocated for x64 RIP addressing. Count input, frame/output-load slot, MOVD capture and MXCSR/RBP save/restore are probe ABI instructions.'},
  'cases':cases,'mismatch_cases':mismatches,'historical_game_process_launched':False,'historical_effective_fp_context_qualified':False,
  'hardware_code_permissions':'RW while writing, changed to RX before execution; original host MXCSR restored per call, allocation released.',
  'producer':identity(__file__),'python':{'version':sys.version,**identity(sys.executable)}}
 out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({k:result[k] for k in ['nearest_even_cases','nearest_even_all_match','all_rounding_cases','other_rounding_mismatches','all_rounding_modes_match']}),flush=True)
 return 0 if result['nearest_even_all_match'] else 1

if __name__=='__main__':raise SystemExit(main())
