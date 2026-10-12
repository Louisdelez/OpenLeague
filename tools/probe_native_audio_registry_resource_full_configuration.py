from pathlib import Path
import itertools,json,hashlib,struct
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x1000;stream=vector+0x2000;payload=vector+0x3000;old_keys=vector+0x4000;new_keys=vector+0x5000;new_owner=vector+0x6000;new_transitions=vector+0x7000;rtpc=vector+0x9000;records=vector+0x10000;existing_owner=vector+0x11000
data=struct.pack('<fH',1.,128)+struct.pack('<III',1,7,97)+struct.pack('<I',2)+struct.pack('<IIIIII',0x11223344,0x55667788,37,0x55667788,0x11223344,91)+struct.pack('<IIII',1,7,0xabcdef01,2)+struct.pack('<ffIffII',0.,1.,4,1.,7.,4,2)+struct.pack('<IIII',100,0x3f800000,293,0x3f000000);assert len(data)==106
regions=[('registry',registry,108),('stream',stream,40),('payload',payload,106),('old_keys',old_keys,32),('new_keys',new_keys,128),('new_owner',new_owner,24),('new_transitions',new_transitions,128),('rtpc',rtpc,0x950),('records',records,256),('existing_owner',existing_owner,24),('globals',0x12100c0,0x180),('curve_temp',vector+0x12000,48),('curve_node',vector+0x13000,52),('curve_points',vector+0x14000,48),('conversion_cache',0x14a7970,8),('thread_record',vector+0x18000,0x3bc)]
def snapshot():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];freed=[];allocations=[];visited=set();failure='none';record_index=0;last_error=97
float_visited=set(json.loads((r/'data/4.20/audio_global_float_configuration_tls_preparation.json').read_text(encoding='utf-8'))['visited_addresses']);w(0xfa43bc,vector+0x28000);w(0xfa43fc,vector+0x28010);w(0xfa4440,vector+0x28020);w(0x2da5308,read(0x1222ed0));w(0x12230cc,5)
def hook(uc,a,z,userdata):
 global record_index,last_error
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==vector+0x28000:calls.append({'kind':'windows','function':'GetLastError','result':last_error,'at_call':snapshot()});finish(last_error);return
 if a==vector+0x28010:
  slot=read(sp+4);assert slot==5;calls.append({'kind':'windows','function':'TlsGetValue','index':slot,'result':vector+0x18000,'last_error_before':last_error,'at_call':snapshot()});last_error=0;finish(vector+0x18000,4);return
 if a==vector+0x28020:
  value=read(sp+4);calls.append({'kind':'windows','function':'SetLastError','value':value,'last_error_before':last_error,'at_call':snapshot()});last_error=value;finish(0,4);return
 if a==0xca1ef0:
  dst=read(sp+4);src=read(sp+8);size=read(sp+12);u.mem_write(dst,bytes(u.mem_read(src,size)));finish(dst);return
 if a==0xada670:
  pool=read(sp+4);size=read(sp+8);assert pool==19
  if read(sp)==0xafb555:kind='curve_temp';ref=vector+0x12000
  elif read(sp)==0xae45a2:kind='curve_points';ref=vector+0x14000
  elif size==52:kind='curve_node';ref=vector+0x13000
  elif size==24:kind='key_owner';ref=new_owner
  elif size in[64,72]:kind='key_table';ref=new_keys
  elif size==60:kind='transition_table';ref=new_transitions
  elif size==40:kind='rtpc_record';ref=records+record_index*64
  else:raise AssertionError(size)
  result=0 if failure==kind else ref
  calls.append({'kind':'allocate','pool':pool,'size':size,'result':result,'at_call':snapshot()})
  if result:allocations.append({'reference':result,'size':size});record_index+=int(size==40)
  finish(result);return
 if a==0xada3e0:
  pool=read(sp+4);ref=read(sp+8);calls.append({'kind':'free','pool':pool,'reference':ref,'at_call':snapshot()});assert ref not in freed;freed.append(ref);finish(0);return
 if a==0xaeb3d0 or a==0xaeb180:
  calls.append({'kind':'configuration_float'if a==0xaeb3d0 else'configuration_word','value_bits':read(sp+4),'selector':read(sp+8),'at_call':snapshot()})

 if a==0xaf7900:
  dst=read(sp+4);size=read(sp+8);calls.append({'kind':'read','tag':read(sp),'size':size,'destination_before':bytes(u.mem_read(dst,size)).hex(),'at_call':snapshot()})
 if a==0xaf6890:calls.append({'kind':'publish_key','key':read(sp+4),'at_call':snapshot()})
 if a==0xaf7280:calls.append({'kind':'default_duration','key':read(sp+4),'duration':read(sp+8),'at_call':snapshot()})
 if a==0xaf69b0:calls.append({'kind':'transition','arguments':[read(sp+4+j*4)for j in range(5)],'at_call':snapshot()})
 if a==0xb121e0:calls.append({'kind':'rtpc_default','key':read(sp+4),'bits':read(sp+8),'at_call':snapshot()})
 assert a in float_visited or any(lo<=a<hi for lo,hi in[(0xb10450,0xb10780),(0xae4550,0xae45f3),(0xb11f20,0xb120a0),(0xb12870,0xb12911),(0xaeb180,0xaeb1b1),(0xafb320,0xafb623),(0xaf7900,0xaf7933),(0xaf7750,0xaf78fe),(0xaf6890,0xaf6950),(0xb15890,0xb15917),(0xb153b0,0xb15426),(0xaf7350,0xaf7387),(0xaf7280,0xaf72c1),(0xaf69b0,0xaf6a2b),(0xaf6f50,0xaf6fec),(0xaf95a0,0xaf9623),(0xb121e0,0xb121fd),(0xb111f0,0xb1127a),(0xb102d0,0xb10320)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,key_layout,failure,available,enabled,input_bits in itertools.product([0,0xa5],['empty','existing'],['none','key_owner','curve_node','curve_points','rtpc_record'],[0,62,106],[0,1],[0xc2000000,0,0x3f800000,0x7fc12345]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 u.mem_write(payload,struct.pack('<I',input_bits)+data[4:]);w(stream+8,available);w(stream+24,payload);w(stream+28,0)
 w(registry,0 if key_layout=='empty'else old_keys);w(registry+4,0 if key_layout=='empty'else 1);w(registry+8,0 if key_layout=='empty'else 1)
 if key_layout!='empty':w(old_keys,7 if key_layout=='existing'else 655);w(old_keys+4,existing_owner)
 for off,val in[(0,31),(4,0xabcdef01),(8,0),(12,0),(16,0),(20,0)]:w(existing_owner+off,val)
 u.mem_write(rtpc,bytes(0x950));w(rtpc+0x948,8);u.mem_write(vector+0x13000,bytes(52));w(0x14a7a34,registry);w(0x14a7a3c,rtpc);w(0x12100dc,19);u.mem_write(stack-0x1000,bytes([pattern])*0x1000);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 w(0x12100d4,2 if pattern==0 else 0xffffffff);w(0x2da52e8,0);u.mem_write(vector+0x18000,bytes(0x3bc));last_error=97;w(0x12100d8,2 if pattern==0 else 0xffffffff);calls.clear();freed.clear();allocations.clear();record_index=0;before=snapshot();w(stack,end);w(stack+4,enabled);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,stream);u.emu_start(0xafb320,end,count=25000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'key_layout':key_layout,'failure':failure,'available':available,'enabled':enabled,'input_bits':input_bits,'last_error_after':last_error,'before':before,'after':snapshot(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls),'freed':list(freed),'allocations':list(allocations)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Actual full AFB320 resource reader with original AEB3D0 floating configuration/CRT pow, AEB180 voice-limit producer, registry key/default/transition producers, B10450/AE4550 curve storage/cleanup and RTPC default creation. Only allocator/free/memcpy and measured Windows GetLastError/TlsGetValue/SetLastError ABI boundaries. No complete configuration-body replacement in original oracle.','480 whole canonical compositions: pattern0/a5, two key layouts, five failures, available0/62/106, enabled/disabled, decibel-32/0/invalid1/quietNaN. Floating priority2 accepts in pattern0; signed priority-1 skips patternA5. Initial failed read still calls float setter with caller bytes before returning read56. One nonempty curve, delayed subscribers empty, initialized thread record supplied.','Rust configuration/body replay pending; original CRT power fidelity remains separate dependency. Whole runtime startup/device/physical playback not qualified.']}
(r/'data/4.20/audio_registry_resource_full_configuration_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual full resource/global configurations/math/thread/curve/registry compositions')
