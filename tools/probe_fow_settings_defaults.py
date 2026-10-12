from pathlib import Path
import json,struct,datetime,ast,hashlib
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_fow_source_release.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(prefix,'native prerequisites','exec'))
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));parser={'struct':struct};exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'inibin','exec'),parser)
discovery=json.loads((r/'docs/native_projection_discovery.json').read_text());path=Path(discovery['source']).parent/'LEVELS/Map10/terrain.inibin';values=parser['ini'](path)
keys=['fadeStart','fadeFinish','edgeEnhancement','edgeTintPoint','blurKernelSigma'];authored={k:values.get(parser['hashkey']('FoW',k)) for k in keys}
defaults={k:struct.unpack('<f',u.mem_read(addr,4))[0] for k,addr in [('fadeStart',0x1223eb8),('fadeFinish',0x1223eb4),('blurKernelSigma',0x11392ec)]}
stub=end+0x240;retval=end+0x400;resource=heap+0x1f300;frame=sp+0x1000
native_code_ranges=list(native_code_ranges)+[(stub,stub+7)];u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',retval)+b'\xc3')
requests=[];current={}
def text_at(ptr):return bytes(u.mem_read(ptr,80)).split(b'\0')[0].decode('ascii')
def reader(uc,a,size,user):
 if a==0x8b1f50:
  top=u.reg_read(UC_X86_REG_ESP);res=read32(top+4);section=text_at(read32(top+8));key=text_at(read32(top+12));fallback=struct.unpack('<f',u.mem_read(top+16,4))[0]
  assert res==resource and section=='FoW' and read32(top+20)==0
  value=current.get(key);value=fallback if value is None else value
  requests.append(dict(key=key,default=fallback,value=value));u.mem_write(retval,struct.pack('<f',value));u.reg_write(UC_X86_REG_EIP,stub)
u.hook_add(unicorn.UC_HOOK_CODE,reader)
cases=[]
for name,inputs,previous in [('map10-original',authored,0.),('diagnostic-positive-tint',dict(fadeStart=.25,fadeFinish=.75,edgeEnhancement=2.,edgeTintPoint=.2,blurKernelSigma=.5),0.),('diagnostic-zero-retains-tint',dict(edgeTintPoint=0.),5.),('diagnostic-negative-retains-tint',dict(edgeTintPoint=-1.),5.)]:
 requests.clear();current=inputs
 u.mem_write(resource,bytes(32));u.mem_write(resource,b'terrain.ini\0');write32(resource+0x10,11);write32(resource+0x14,15)
 for key,addr in [('fadeStart',0x1223eb8),('fadeFinish',0x1223eb4)]:u.mem_write(addr,struct.pack('<f',defaults[key]))
 u.mem_write(0x2d78a2c,struct.pack('<f',previous));u.mem_write(0x2d78a30,b'\0'*4)
 def init():
  u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,resource);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 init();u.emu_start(0x6b32d1,0x6b33a9,count=20000);assert u.reg_read(UC_X86_REG_EIP)==0x6b33a9
 result=[read32(a) for a in [0x1223eb8,0x1223eb4,0x2d78a30,0x2d78a2c]]
 init();u.emu_start(0x6b343e,0x6b3462,count=20000);assert u.reg_read(UC_X86_REG_EIP)==0x6b3462
 # Caller writes the x87 return to EBP-44 at6B346D, after loading extent; execute that native store.
 u.emu_start(0x6b346d,0x6b3470,count=2);result.append(read32(frame-0x44))
 assert len(requests)==5
 cases.append(dict(name=name,authored=inputs,previous_tint=previous,requests=list(requests),result_bits=result))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,resource_source=str(path),resource_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),map10_authored=authored,defaults=defaults,cases=cases,native_addresses=len({a for a in visited if 0x6b32d1<=a<0x6b33a9 or 0x6b343e<=a<0x6b3470}),limits=['Original native reader call/default propagation, SSE tint reciprocal and x87 sigma store execute.8B1F50 is adapted to parsed native terrain INIBIN values and explicit overrides.','Resource/path lookup, whole initialization, upscale selection, overlay resolver and GPU shader consumers remain open.','Zero/negative tint leaves prior global reciprocal unchanged; this is retained, not silently reset. Native global cold-start values used for map case.'])
(r/'data/4.20/fow_settings_defaults_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),defaults=defaults,native_addresses=proof['native_addresses'],map10_result_bits=cases[0]['result_bits'])))
