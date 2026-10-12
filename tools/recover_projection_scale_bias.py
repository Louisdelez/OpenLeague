from pathlib import Path
import sys,json,hashlib,datetime,shutil
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,capstone
r=Path('E:/OpenLeague');d=json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8'));native=Path(d['source']);raw=native.read_bytes();pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
decoder=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
def string(a):return image[a-base:a-base+100].split(b'\0')[0].decode('ascii')
assert string(0x10d83d4)=='p-scalebias' and string(0x10d83c4)=='p-simpleorient'
code=[]
for name,start,end in [('constructor_scale_bias_one',0x91c366,0x91c39d),('reader_scale_bias_and_simpleorient',0x91ebd5,0x91ec25),('type7_scale_bias_applied',0x931354,0x931389)]:
    b=image[start-base:end-base]
    code.append({'name':name,'start':hex(start),'end_exclusive':hex(end),'sha256':hashlib.sha256(b).hexdigest(),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str} for i in decoder.disasm(b,start)]})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'fields':{'p-scalebias':{'native_string_address':'0x10d83d4','reader_call':'0x91ebf6','default':[1.,1.],'destination_offsets':['0x1d4','0x1d8'],'type7_use':'Each bias component multiplied by current particle scale*emitter scale factor before92E130 projection preparation.'},'p-simpleorient':{'native_string_address':'0x10d83c4','reader_call':'0x91ec17','default':0,'destination_offset':'0x1dc'}},'code':code,'qualification':'Static original instructions/constants recovered. Full reader, emission scale producer and local-orient/angle/attachment behavior not executed or qualified.'}
(r/'data/4.20/particle_projection_scale_bias.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
p=r/'docs/resume_checkpoint.json';d=json.loads(p.read_text(encoding='utf-8'));d['next_actions'].insert(0,'Native scale-bias producer discovered: p-scalebias defaults[1,1], stored1D4/1D8 and multiplied by current particle scale before92E130. p-simpleorient defaults0 stored1DC. Evidence data/4.20/particle_projection_scale_bias.json static only. Qualify current scale, local-orient angle, bind/attachment and lifecycle, then connect Q Projected consumer; material already GPU-visible under explicit diagnostic flag. Full24domain goal stays open.');p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copyfile(Path(__file__),r/'tools/recover_projection_scale_bias.py')
print('Native projection scale bias[1,1] and simpleorient0 recovered; full emitter binding remains open.')
