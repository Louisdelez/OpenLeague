from pathlib import Path
import json, struct, hashlib
root=Path('E:/OpenLeague')
bootstrap=root/'tools/qualify_native_audio_legacy_paths.py'
__file__=str(bootstrap)
source=bootstrap.read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
arena=0x34000000
u.mem_map(arena,0x1000000)
cursor=arena
def allocate(size):
    global cursor
    result=cursor; cursor+=(size+31)&~15
    assert cursor<arena+0x1000000
    u.mem_write(result,b'\0'*size)
    return result
clone=read32(0x109e274);destroy=read32(0x109e270)
maps={};nodes={};bindings=[];other=[];slots={};other_bindings=[]
def capture(uc,a,size,user):
    sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
    if a in [0xc9f39b,0x9933e0]:finish(eax=allocate(read32(sp+4)));return
    if a==0xc982e4:
        start,width,count=read32(sp+4),read32(sp+8),read32(sp+12)
        assert width==8 and count==167
        for index in range(count):
            sentinel=allocate(48);write32(start+index*width,sentinel);maps[start+index*width]=index
        finish(20);return
    if a==0x564c20:
        ptr,n=read32(sp+4),read32(sp+8);raw=bytes(u.mem_read(ptr,n))
        assert n<16;u.mem_write(ecx,raw+b'\0');write32(ecx+16,n);write32(ecx+20,15);finish(8,ecx);return
    if a==0x5c2b70:
        assert ecx in maps;finish(4,read32(ecx));return
    if a==0x6efc90:
        node=allocate(48); key_pointer=read32(read32(sp+8)); key=string(key_pointer)
        nodes[node]=(maps[ecx],key)
        finish(12,node);return
    if a==0x6f07e0:
        result,node=read32(sp+4),read32(sp+16)
        assert node in nodes
        write32(result,node);finish(16,result);return
    if a==clone:
        copied=allocate(8);u.mem_write(copied,bytes(u.mem_read(ecx,8)));finish(eax=copied);return
    if a==destroy:finish(4);return
    if a==0x6e7890:
        slot=allocate(4);key=string(read32(sp+4));slots[slot]=(maps[ecx],key)
        finish(4,slot);return
    if a in [0x6e7900,0x564900,0x56ff50]:finish();return
    if a==0x6ed160:finish(4,ecx);return
    if a==0x6d04b7:
        uc.emu_stop();return
def written(uc,access,address,size,value,user):
    node=address-0x28
    if node in nodes:
        index,key=nodes[node]
        bindings.append({'map_index':index,'key':key,'callback':hex(read32(value+4)) if value else None})
    if address in slots and value:
        index,key=slots[address];other_bindings.append({'map_index':index,'key':key,'callback':hex(read32(value+4))})
u.hook_add(unicorn.UC_HOOK_CODE,capture)
u.hook_add(unicorn.UC_HOOK_MEM_WRITE,written)
write32(0x2d77b20,1);write32(0x14bef58,0)
sp=stack+0xe000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp)
u.emu_start(0x6cfb40,end,count=2000000)
print(json.dumps({'pc':hex(u.reg_read(UC_X86_REG_EIP)),'bindings':len(bindings),'maps':len(maps),'clone':hex(clone),'destroy':hex(destroy),'first':bindings[:5],'last':bindings[-5:]}))
assert len(bindings)==835
for index in range(167):
    assert [entry['callback'] for entry in bindings[index*5:index*5+5]]==[hex(x) for x in [0x6e7970,0x6e7990,0x6e79c0,0x6e7a10,0x6e7a30]]
proof={'native_sha256':digest,'passed':True,'complete':False,'entry':'0x6cfb40','bindings':bindings,'other_bindings':other_bindings,'maps':167,'limits':['Original first registration loop executed for all167 maps and835 actor formatter bindings. Physical vector/map/string allocation, insertion and virtual clone/destruction adapted; actual registration keys and function-pointer stores are native.', 'Later non-actor formatter registrations and overall initialization/exception ownership remain incomplete. No playback claim.']}
(root/'data/4.20/audio_announcer_callback_registration_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
