from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text().split('\ncases=[]')[0],'native prerequisites','exec'))
block=terrain+0x3000;cases=[]
for entry,initial in [(0x6086d0,[0.,0.]),(0x6088d0,[-100.,-0.5]),(0x6088d0,[80.,1.]),(0x6088d0,[0.,0.])]:
 u.mem_write(block,bytes(0x200));u.mem_write(block+0x160,struct.pack('<2f',*initial));write32(sp,end)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,block)
 u.emu_start(entry,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(entry=hex(entry),initial=initial,result_bits=list(struct.unpack('<2I',u.mem_read(block+0x160,8)))))
names={}
for address,offset in [(0x109545c,0x160),(0x1095478,0x164)]:
 data=bytearray()
 for i in range(100):
  v=u.mem_read(address+i,1)[0]
  if v==0:break
  data.append(v)
 names[hex(offset)]=dict(address=hex(address),native_label=data.decode('ascii'))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,passed=True,complete=False,cases=cases,names=names,actor_stats_offset='0x618',actor_flat_offset='0x778',actor_percent_offset='0x77c',actor_stats_address_setup='0x612e8d',constructor_call_site='0x612e93',native_addresses=len(visited),runtime_adapters=[],limits=['Original stat constructor/reset executed with empty modifier collection; full actor constructor not executed.','Actor+618 constructor call and native debug labels identify fields; native buff aggregation and network decoding producers remain open.'])
(r/'data/4.20/fow_stat_fields_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
