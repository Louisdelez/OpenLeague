from pathlib import Path
import itertools,json,shutil,re
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x1000;lane_owner=heap+0x6000;input_address=heap+0x4000;output=heap+0x4100
write32(actor+0x18b8,lane_owner)
path=r/'data/4.20/font_configuration/menu/fontconfig_en_US.txt'
translations=dict(re.findall(r'^tr "(game_announcement_replace_[^"]+)" = "([^"]*)"',path.read_text(encoding='utf-8-sig'),re.M))
def capture(uc,a,size,user):
 if a==0x78d0d0:
  key=cbytes(u.reg_read(UC_X86_REG_ECX)).decode('ascii');localizations.append(key);u.mem_write(heap+0xa000,translations[key].encode()+b'\0');finish(eax=heap+0xa000);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);pointer,n=read32(sp+4),read32(sp+8);assert u.reg_read(UC_X86_REG_ECX)==output
  outputs.append(bytes(u.mem_read(pointer,n)).hex());finish(8,output);return
 assert 0x400000<=a<0x1000000,hex(a)
def memory_reads(uc,access,address,size,value,user):
 if address in [actor+0x18b8,lane_owner+12,actor+0x2290,actor+0x1c]:
  assert size==4;reads.append({actor+0x18b8:'lane_owner',lane_owner+12:'lane',actor+0x2290:'kind',actor+0x1c:'flags'}[address])
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_reads);cases=[]
bindings=[(0x6d4a10,p) for p in [' turret lane@',' turret position@',' turret lane or nexus@']]+[(0x6d4dc0,p) for p in [' turret lane@',' turret position@']]
for (entry,pattern),exists,lane,kind,variant in itertools.product(bindings,[False,True],[0,1,2,3,0x7fffffff,0xffffffff],[0,1,2,3,4,5,6,0xffffffff],['exact','upper','tail']):
 reads=[];outputs=[];localizations=[];input=pattern.upper() if variant=='upper' else pattern+'tail' if variant=='tail' else pattern
 write32(lane_owner+12,lane);write32(actor+0x2290,kind);u.mem_write(input_address,input.encode()+b'\0')
 sp=stack+0xc000;write32(sp,end);write32(sp+4,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor if exists else 0)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;assert len(outputs)==1;assert 'flags' not in reads
 expected=[] if not exists else ['lane_owner','lane'] if pattern==' turret lane@' else ['kind'] if pattern==' turret position@' or kind in (4,5) else ['kind','lane_owner','lane']
 assert reads==expected,(pattern,exists,lane,kind,reads)
 cases.append({'entry':hex(entry),'pattern':pattern,'input':input,'exists':exists,'lane':lane,'kind':kind,'output_hex':outputs[0],'field_reads':list(reads),'localization_calls':list(localizations)})
proof={'native_sha256':digest,'functions':['0x6D4670','0x6D46B0','0x6D4700','0x6D4760','0x6D47A0','0x6D4A10','0x6D4DC0'],'passed':True,'complete':False,'translations':translations,'cases':cases,'limits':['Original registered turret-label bodies and ordered dispatchers executed with exact native field-read sequences; no class-flag validation added.','Lane owner pointer actor+18B8 and lane DWORD owner+C; position/kind DWORD actor+2290. Kind4/5 bypass lane reads in lane-or-nexus body.','Actor storage, localization and output storage supplied; null lane-owner pointer fault, live ownership and source field provenance remain unqualified.','Missing-actor behavior differs by native form/family; no unsupported localized lane-or-nexus binding invented. No normal event/playback claim.']}
(r/'data/4.20/audio_announcer_turret_labels_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_turret_labels.py'),r/'tools/qualify_announcer_turret_labels.py')
print(json.dumps({'native_turret_label_cases_prepared':len(cases)}))
