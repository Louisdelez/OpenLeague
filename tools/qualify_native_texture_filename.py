from pathlib import Path
import itertools,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_config_cache_policy.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native texture filename prerequisites','exec'))
src=0x41070000;dst=0x40010000
def hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0xc98528:finish(0);return
 if a==0x5c35b0:ssowrite(this,bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 if a==0x5c5580:finish(1,8);return # Equal-length replacement, no storage growth needed.
 if a==0x564d60:
  length=read(sp+4);p=read(this) if read(this+20)>=16 else this;w(this+16,length);u.mem_write(p+length,b'\0');finish(this,4);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x14ae870,0);w(0x14bef40,0)
names=[b'',b'NONE',b'none',b'None',b'NONE\t',b'ShadowIslesHUDAtlas.tga',b'HUDAtlas.dds',b'A.tga',b'A.TGA',b'A.tga.tga',b'.tga.backup',b'DATA/menu/Textures/A.tga',b'DATA\\menu\\Textures\\A.tga',b'A.tgabc',b'x.tga\0ignored',b'\xff.tga',b'A.dds',b'A',b'.tga']
cases=[]
for name,leading,trailing,guard in itertools.product(names,[b'',b' ',b'\t ',b'  \t'],[b'',b' ',b'  ',b'\t '],[0,32]):
 input_bytes=leading+name+trailing;allocation=0x41000000
 u.mem_write(src,input_bytes+b'\0');u.mem_write(dst-16,b'\xa5'*15+bytes([guard])+b'\xcc'*400);w(stack,end)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,src);u.reg_write(UC_X86_REG_EDX,dst);u.emu_start(0x97d0a0,end,count=50000)
 assert u.reg_read(UC_X86_REG_EIP)==end,(input_bytes,hex(u.reg_read(UC_X86_REG_EIP)))
 actual=cbytes(dst);expected=input_bytes.split(b'\0',1)[0].lstrip(b' \t').rstrip(b' ')
 if expected.lower()==b'none':expected=b''
 else:
  index=expected.lower().find(b'.tga')
  if index>=0:expected=expected[:index]+b'.dds'+expected[index+4:]
 assert actual==expected,(input_bytes,actual,expected)
 cases.append(dict(input=list(input_bytes),output=list(actual),preceding_byte=guard,preceding_byte_after=u.mem_read(dst-1,1)[0],underwrite=u.mem_read(dst-1,1)[0]!=guard))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x97d0a0',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Original leading-space/tab skip, trailing-space trim, C-locale NONE comparison, case-insensitive substring comparison, first .tga replacement, copy-back and cleanup execute.','Initial std::string assignment, equal-length capacity check, length/NUL setter, free and cookie adapted. Original native string search/replacement and CRT search/compare/copy execute.'],limits=['Filename normalization only; texture manager/cache/GPU loading and native HUD caller integration remain open.','Inputs bounded below supplied output storage; empty/space-only output can write before destination if preceding byte is space. Safe port must preserve output bytes without reproducing memory underwrite.','Case preserved outside replacement; first ASCII case-insensitive .tga substring changes to .dds, even before a suffix.'])
(r/'data/4.20/native_texture_filename_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),underwrites=sum(c['underwrite'] for c in cases))))
