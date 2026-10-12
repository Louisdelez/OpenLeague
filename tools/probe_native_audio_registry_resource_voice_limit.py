from pathlib import Path
import itertools,json,hashlib,struct
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x1000;stream=vector+0x2000;payload=vector+0x3000;old_keys=vector+0x4000;new_keys=vector+0x5000;new_owner=vector+0x6000;new_transitions=vector+0x7000;rtpc=vector+0x9000;records=vector+0x10000;existing_owner=vector+0x11000
data=struct.pack('<fH',1.,128)+struct.pack('<III',1,7,97)+struct.pack('<I',2)+struct.pack('<IIIIII',0x11223344,0x55667788,37,0x55667788,0x11223344,91)+struct.pack('<II',0,2)+struct.pack('<IIII',100,0x3f800000,293,0x3f000000);assert len(data)==70
regions=[('registry',registry,108),('stream',stream,40),('payload',payload,70),('old_keys',old_keys,32),('new_keys',new_keys,128),('new_owner',new_owner,24),('new_transitions',new_transitions,128),('rtpc',rtpc,0x920),('records',records,256),('existing_owner',existing_owner,24),('globals',0x12100c0,64)]
def snapshot():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];freed=[];allocations=[];visited=set();failure='none';record_index=0
def hook(uc,a,z,userdata):
 global record_index
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xca1ef0:
  dst=read(sp+4);src=read(sp+8);size=read(sp+12);u.mem_write(dst,bytes(u.mem_read(src,size)));finish(dst);return
 if a==0xada670:
  pool=read(sp+4);size=read(sp+8);assert pool==19
  if size==24:kind='key_owner';ref=new_owner
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
  if a==0xaeb3d0:finish(1);return
 if a==0xaf7900:
  dst=read(sp+4);size=read(sp+8);calls.append({'kind':'read','tag':read(sp),'size':size,'destination_before':bytes(u.mem_read(dst,size)).hex(),'at_call':snapshot()})
 if a==0xaf6890:calls.append({'kind':'publish_key','key':read(sp+4),'at_call':snapshot()})
 if a==0xaf7280:calls.append({'kind':'default_duration','key':read(sp+4),'duration':read(sp+8),'at_call':snapshot()})
 if a==0xaf69b0:calls.append({'kind':'transition','arguments':[read(sp+4+j*4)for j in range(5)],'at_call':snapshot()})
 if a==0xb121e0:calls.append({'kind':'rtpc_default','key':read(sp+4),'bits':read(sp+8),'at_call':snapshot()})
 assert any(lo<=a<hi for lo,hi in[(0xaeb180,0xaeb1b1),(0xafb320,0xafb623),(0xaf7900,0xaf7933),(0xaf7750,0xaf78fe),(0xaf6890,0xaf6950),(0xb15890,0xb15917),(0xb153b0,0xb15426),(0xaf7350,0xaf7387),(0xaf7280,0xaf72c1),(0xaf69b0,0xaf6a2b),(0xaf6f50,0xaf6fec),(0xaf95a0,0xaf9623),(0xb121e0,0xb121fd),(0xb111f0,0xb1127a),(0xb102d0,0xb10320)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,key_layout,failure,available,enabled in itertools.product([0,0xa5],['empty','existing','full'],['none','key_owner','key_table','transition_table','rtpc_record'],[0,3,4,6,10,18,46,70],[0,1]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 u.mem_write(payload,data);w(stream+8,available);w(stream+24,payload);w(stream+28,0)
 w(registry,0 if key_layout=='empty'else old_keys);w(registry+4,0 if key_layout=='empty'else 1);w(registry+8,0 if key_layout=='empty'else 1)
 if key_layout!='empty':w(old_keys,7 if key_layout=='existing'else 655);w(old_keys+4,existing_owner)
 for off,val in[(0,31),(4,0xabcdef01),(8,0),(12,0),(16,0),(20,0)]:w(existing_owner+off,val)
 u.mem_write(rtpc,bytes(0x920));w(0x14a7a34,registry);w(0x14a7a3c,rtpc);w(0x12100dc,19);u.mem_write(stack-0x1000,bytes([pattern])*0x1000);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 w(0x12100d8,2 if pattern==0 else 0xffffffff);calls.clear();freed.clear();allocations.clear();record_index=0;before=snapshot();w(stack,end);w(stack+4,enabled);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,stream);u.emu_start(0xafb320,end,count=25000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'key_layout':key_layout,'failure':failure,'available':available,'enabled':enabled,'before':before,'after':snapshot(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls),'freed':list(freed),'allocations':list(allocations)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Actual AFB320 memory resource reader, AF7900/AF7750 partial reads, AF6890 key publication, AF7280 default durations, AF69B0 transition insertion/growth, B121E0/B111F0/B102D0 RTPC default record creation execute original bodies. Allocator/free/memcpy and configuration float ABI boundary only; actual AEB180 voice-limit setter executes with signed priority, low16 and zero-status semantics. RTPC curve section count0 in this matrix; B10450 curve registration must qualify separately.','Memory stream, payload and managers supplied. Truncated headers preserve caller-stack bytes; stack seeded0/a5, relevant destination_before captured per read. Disabled flag bypasses all work; key-allocation status2 maps to1 then missing default returns20. RTPC default record OOM has no propagated status. Real float configuration/device/startup and normal bank-to-game/global wiring remain open. Rust replay pending.']}
(r/'data/4.20/audio_registry_resource_voice_limit_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual resource admission memory/keys/default/transitions/RTPC/truncation/failure compositions')
