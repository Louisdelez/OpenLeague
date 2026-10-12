from pathlib import Path
import json,struct,datetime,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'metrics prerequisites','exec'))
owner=vector+0x6000;face=owner+0x100;metrics=owner+0x200;slot=owner+0x300;stop=0x8c1c59;calls=[]
signed=lambda x:x if x<0x80000000 else x-0x100000000
def hook(uc,a,size,user):
 if a==0xc3af80:
  sp=uc.reg_read(UC_X86_REG_ESP);assert [read(sp+4),read(sp+8)]==[face,32];calls.append('index_space');finish(7);return
 if a==0xc3b830:
  sp=uc.reg_read(UC_X86_REG_ESP);assert [read(sp+4+i*4) for i in range(3)]==[face,7,0];calls.append('load_space_flags0');finish(0);return
 assert 0x8c1c06<=a<stop,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(owner+0x18,face);w(face+0x58,metrics);w(face+0x54,slot);cases=[]
for ascender,descender,height,advance in itertools.product([0,1023,-65],[-513,-1,0,-0x80000000],[0,1535,-1],[0,703,-65]):
 calls.clear();w(metrics+0x18,ascender);w(metrics+0x1c,descender);w(metrics+0x20,height);w(slot+0x28,advance);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,face);u.reg_write(UC_X86_REG_EDI,owner);u.reg_write(UC_X86_REG_ESI,owner+0x18);u.emu_start(0x8c1c06,stop,count=200)
 assert u.reg_read(UC_X86_REG_EIP)==stop and u.reg_read(UC_X86_REG_ESP)==stack
 actual=[signed(read(owner+off)) for off in [4,8,12,16]];expected=[ascender>>6,signed((-descender)&0xffffffff)>>6,height>>6,advance>>6];assert actual==expected and bytes(u.mem_read(owner+0x14,2))==b' \0'
 cases.append({'metrics_26_6':[ascender,descender,height,advance],'pixels':actual,'space_character':32,'calls':list(calls)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x8c1c06','stop_before_cleanup':'0x8c1c59','case_count':len(cases),'native_addresses':len(visited),'cases':cases,'findings':['Original constructor metric suffix executes. Font+4 ascender>>6; +8 wrappingNEG(descender) then>>6; +C height>>6.','Space char32 maps index and loads flags0; font+10 stores space advance>>6.'],'limits':['Prepared FT face/slot/metrics supplied; native source allocation/init/fit/error and constructor cleanup not executed in this probe. FT index/load providers supplied success.','No original framebuffer, original compiler/hinting pixel identity or widget runtime proof.']}
(r/'data/4.20/native_font_face_metrics_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
