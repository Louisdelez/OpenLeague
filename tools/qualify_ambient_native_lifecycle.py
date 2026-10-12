"""Qualify particle-event lifecycle against native executable instruction bytes."""
from pathlib import Path
import sys,json,struct,hashlib,datetime
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
prior=json.loads((r/'docs/map_ambient_native_timing_validation.json').read_text());p=Path(prior['native_executable']);b=p.read_bytes();assert hashlib.sha256(b).hexdigest()==prior['native_executable_sha256'];pe=pefile.PE(data=b);base=pe.OPTIONAL_HEADER.ImageBase;c=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
def raw(address,length):
 off=pe.get_offset_from_rva(address-base);return b[off:off+length]
expected={0x5b52f9:'89460c',0x5b533b:'c706f0610801',0x5b537b:'f30f10470c',0x5b5380:'0f2f4720',0x5b5384:'7607',0x5b538f:'884604',0x5b5410:'8b410c',0x5b5417:'d94020',0x5ed7e3:'8b4008',0x5ed7e6:'d1e8',0x5ed7e8:'83e001',0x88a4da:'ff500c',0x88a4dd:'c6430601',0x88a51d:'8a4304',0x88a524:'8a4305',0x88a529:'0f8585000000',0x88a537:'c7431002000000',0x88a599:'ff5014',0x88a59c:'c6430600',0x88a285:'f6400801',0x88a292:'c7431000000000',0x88a29d:'c6430500',0x88a309:'ff5014',0x88a30c:'c6430600'}
for va,s in expected.items():assert raw(va,len(s)//2).hex()==s,(hex(va),raw(va,len(s)//2).hex(),s)
vtable=struct.unpack('<16I',raw(0x10861f0,64));assert vtable[1]==0x5b5410 and vtable[3]==0x5b5430 and vtable[5]==0x5b5440 and vtable[9]==vtable[11]==vtable[13]==0x5ed7f0
regions=[]
for va,size in [(0x5b5361,49),(0x5b5410,18),(0x5ed7e0,12),(0x88a51d,36),(0x88a280,67),(0x88a2a6,106)]:
 data=raw(va,size);ins=list(c.disasm(data,va));assert sum(i.size for i in ins)==size,hex(va)
 regions.append({'address':hex(va),'sha256':hashlib.sha256(data).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'operation':i.mnemonic+' '+i.op_str} for i in ins]})
records=json.loads((r/'docs/map_ambient_blend_records.json').read_text());events=[]
for e in records['records']:
 wrapped=e['end_value_raw']>=0 and e['start_value_raw']>e['end_value_raw']
 events.append({'native_asset':e['native_asset'],'event':e['event_name'],'wrapped_interval':wrapped,'reset_on_loop':bool(e['flags_raw']&1),'resource_flag_bit1':bool(e['flags_raw']&2),'negative_end':e['end_value_raw']<0})
assert len(events)==18 and not any(e['wrapped_interval'] for e in events)
proof={'verified_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_executable_sha256':prior['native_executable_sha256'],'checked_instructions':len(expected),'particle_event_vtable':hex(0x10861f0),'vtable':[hex(x) for x in vtable],'regions':regions,'events':events,'qualified':{'end_record_offset':32,'wrapped_interval':'end >= 0 && start > end','instance_fields':{'4':'wrapped_interval','5':'continuation set on start of wrapped interval and cleared at loop reset','6':'emitter started flag','12':'native record pointer','16':'event state: dormant0/active1/ended2'},'start':'first frame >= start; native callback +0x0c invoked if emitter not already started; then end threshold evaluated in same update','end':'negative end remains active; otherwise ends when current >= end unless wrapped continuation is set','loop':'flags&1 resets state to0; continuation clears and retains emitter; otherwise started emitter gets end callback +0x14 and flag6 clears','resource_flags_bit1':'vtable+8 reads ((flags>>1)&1); meaning of this boolean in full emitter pipeline remains unqualified'},'passed':True,'complete':False,'limits':['Native particle/audio creation and teardown internals, spatial settings, blend ownership and loop endpoints are still incomplete.','All 18 recovered ambient records are non-wrapped; general native wrapped-interval behavior requires full graph/seek qualification.','This audit proves lifecycle branches and callback dispatch, not actual sound or particle playback.']}
(r/'docs/map_ambient_native_lifecycle_validation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS native lifecycle',len(expected),'instruction checks;',len(events),'non-wrapped ambient events')

