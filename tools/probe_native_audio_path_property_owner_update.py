from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
owner=vector+0x1000;clock=vector+0x2000;w(0x14a7a28,clock);w(clock+124,31);w(0x12100f8,48);visited=set()
def snap():return {'owner':bytes(u.mem_read(owner,64)).hex(),'clock':bytes(u.mem_read(clock,128)).hex(),'conversion_cache':bytes(u.mem_read(0x14a7970,8)).hex()}
def hook(uc,a,size,data):assert 0xaf5670<=a<0xaf5944,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,flags,keys,operation,duration,value in itertools.product([0,0xa5],[0,1,2,3],[(5,5),(5,6),(0xf000005,0xf000005)],[0,2],[0,1,48,49,0xffffffff],[0,0xc0c00000,0x40400000,0x80000000,0x7fc01234]):
 u.mem_write(owner,bytes([pattern])*64);u.mem_write(clock,bytes([pattern])*128);w(clock+124,31);u.mem_write(0x14a7970,bytes(8));w(owner,keys[0]);w(owner+4,0x3f800000);w(owner+8,0x40000000);w(owner+12,0xc0400000);w(owner+16,24);w(owner+20,40);w(owner+28,0);w(owner+44,4);w(owner+48,0);u.mem_write(owner+52,bytes([flags,1]))
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);before=snap();w(stack,end)
 for j,arg in enumerate([owner,keys[1],value,duration,4,operation]):w(stack+4+j*4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,vector+0x3000);u.emu_start(0xaf5670,end,count=6000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'flags':flags,'old_type':keys[0],'new_type':keys[1],'operation':operation,'duration':duration,'value_bits':value,'before':before,'after':snap()})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'entry':'0xaf5670','end_exclusive':'0xaf5944','function_sha256':hashlib.sha256(bytes(u.mem_read(0xaf5670,0xaf5944-0xaf5670))).hexdigest(),'constants':{hex(a):hex(read(a))for a in [0x1138a98,0xff0100,0xff00f8,0xff00d8,0xff00c4,0xff00e8]},'limits':['All original AF5670 paths execute without call adapters: flag0/1/2/3 raw/dB target conversion, old/default value selection, operation0/2 replacement/addition/multiplication, curve direction4/8-minus4, exact same-tagged-key duration shrink and general clock reset, unsigned duration wrapping division. Actual quiet NaN and negative-zero values, full owner/clock/cache byte snapshots captured.','Current clock31, frame quantum48, old owner timing24/40 and curve4 supplied; other producer/timing/curve/clamping/domain values require qualification. Rust replay, actual fade progression and full nonempty D0 composition remain open.']}
(r/'data/4.20/audio_path_property_owner_update_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual property-owner updates without downstream adapters')
