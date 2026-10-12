from pathlib import Path
import sys
source=Path(__file__).with_name('probe_replay_recording_resource.py').read_text(encoding='utf-8')
source=source.replace('cases=[]\ntry:', '''cases=[]
resource_pointer=0;resource_read_phase=False;retired_resource_reads=[]
def observe_retired_resource(uc,access,address,size,value,user):
 if resource_read_phase and resource_pointer and address<resource_pointer+40 and address+size>resource_pointer:
  retired_resource_reads.append({'address':address,'bytes':size,'pc':u.reg_read(UC_X86_REG_EIP)})
u.hook_add(unicorn.UC_HOOK_MEM_READ,observe_retired_resource)
try:''')
source=source.replace("  scheduled_call(0x8f67c0,stream,[1]);destroyed=snapshot()", "  resource_pointer=state['resource'][0];retired_resource_reads.clear()\n  scheduled_call(0x8f67c0,stream,[1]);destroyed=snapshot();resource_read_phase=bool(resource_pointer and resource_pointer in destroyed['freed'])")
source=source.replace("  shutdown=snapshot();assert", "  resource_read_phase=False;shutdown=snapshot();assert")
source=source.replace("'shutdown':shutdown})", "'shutdown':shutdown,'retired_resource_reads':list(retired_resource_reads)})")
source=source.replace("'limits':['Actual8FB650", "'limits':['Read instrumentation additionally records whether global release/logging touches a resource already freed by stream destruction; the caller shutdown order must be qualified before porting this combined recording lifetime.','Actual8FB650")
exec(compile(source,'recording resource retired-read qualification','exec'))
