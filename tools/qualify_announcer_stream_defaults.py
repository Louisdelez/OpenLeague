from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
obj=heap+0x1000;ios=obj+0x68;buffer=heap+0x2000;locale=heap+0x3000;locale_vtable=heap+0x3500;released=heap+0x4000;released_vtable=heap+0x4500;facet=heap+0x5000;facet_vtable=heap+0x5500;allocation=heap+0x6000
ref_release=end+0x100;delete=end+0x200;widen=end+0x300
write32(locale,locale_vtable);write32(locale_vtable+8,ref_release);write32(released,released_vtable);write32(released_vtable,delete);write32(facet,facet_vtable);write32(facet_vtable+0x20,widen)
def capture(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0x9933e0:assert read32(sp+4)==4;calls.append('allocate4');finish(eax=allocation if allocates else 0);return
 if a==0xce0d77:assert read32(sp+4)==1;calls.append('ref_counter');finish(eax=0xabcd0001);return
 if a==0x5fca80:assert ecx==ios;calls.append('locale');write32(read32(sp+4),0 if locale_mode=='none' else locale);finish(4,read32(sp+4));return
 if a==0x5fc1b0:calls.append('ctype_facet');finish(eax=facet);return
 if a==ref_release:assert ecx==locale;calls.append('locale_release');finish(eax=released if locale_mode=='delete' else 0);return
 if a==delete:assert ecx==released and read32(sp+4)==1;calls.append('locale_delete');finish(4);return
 if a==widen:assert ecx==facet and read32(sp+4)==32;calls.append('widen_space');finish(4,fill_raw);return
 assert 0x400000<=a<0x1000000,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture);cases=[]
for initial,has_buffer,allocates,locale_mode,fill_raw in itertools.product([0,0xa5],[False,True],[False,True],['none','ref_only','delete'],[0,32,0x120,0xffffffff]):
 u.mem_write(obj,bytes([initial])*0x200);write32(obj,0x1084ee4);write32(obj+16,0x1084eec);write32(obj+0x68,0x1042b4c);calls=[];sp=stack+0xc000;write32(sp,end);write32(sp+4,buffer if has_buffer else 0);write32(sp+8,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,obj)
 u.emu_start(0x5f8590,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==obj
 fields={str(offset):read32(ios+offset) for offset in [8,0xc,0x10,0x14,0x18,0x1c,0x20,0x24,0x28,0x2c,0x30,0x38,0x3c]};fill=u.mem_read(ios+0x40,1)[0]
 assert fields['20']==0x201 and fields['24']==6 and fields['28']==0 and fields['12']==(0 if has_buffer else 4) and fields['16']==0 and fill==fill_raw&255
 assert fields['56']==(buffer if has_buffer else 0) and fields['60']==0 and fields['48']==(allocation if allocates else 0)
 assert calls==['allocate4']+(['ref_counter'] if allocates else [])+['locale','ctype_facet']+([] if locale_mode=='none' else ['locale_release']+(['locale_delete'] if locale_mode=='delete' else []))+['widen_space']
 cases.append({'initial_byte':initial,'has_buffer':has_buffer,'allocates':allocates,'locale_mode':locale_mode,'fill_raw':fill_raw,'ios_fields':fields,'fill':fill,'calls':calls.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'initial_flags':0x201,'initial_precision':6,'initial_width':0,'limits':['Original5F8590 complete stream constructor,5F84D0 basic_ios init,5F83C0 ios_base init and5FDFB0 state setter execute; fresh flags201,precision6,width0,clear/no-buffer-bad states and fill low byte verified.','Allocation/ref-counter, locale/facet/release/delete and widening supplied; ordinary stream-default field provenance is qualified, full locale ownership/physical storage and exceptional constructor unwind are not.','Caller inheritance-header layout is the actual color-helper layout; general other stream subclasses, standard-stream registration, native integer num_put and live playback remain incomplete.']}
(r/'data/4.20/audio_announcer_stream_defaults_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_stream_defaults.py'),r/'tools/qualify_announcer_stream_defaults.py')
print(json.dumps({'native_stream_default_cases':len(cases),'initial_flags':proof['initial_flags']}))
