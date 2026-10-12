from pathlib import Path
import itertools,struct,json,hashlib,datetime
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
renderer=vector+0x6000;manager=vector+0x7000;device=vector+0x8000;vtbl=vector+0x9000;render_callback=vector+0xa000;sampler_callback=vector+0xa010
events=[]
def hook_state(uc,address,length,data):
    sp=u.reg_read(UC_X86_REG_ESP)
    if address==0xc975f5:finish(0);return
    if address==0x9836a0:
        assert u.reg_read(UC_X86_REG_ECX)==0x802;finish(123);return
    if address==0x983780:
        assert [read(sp+4),read(sp+8)]==[2,123];events.append(dict(kind='sampler_object_boundary',args=[2,123]));finish(0,8);return
    if address==render_callback:
        assert read(sp+4)==device;events.append(dict(kind='D3D9_SetRenderState',state=read(sp+8),value=read(sp+12)));finish(0,12);return
    if address==sampler_callback:
        events.append(dict(kind='engine_sampler_state',args=[read(sp+4),read(sp+8),read(sp+12)]));finish(0,12);return
    assert 0x99f170<=address<=0x99f280 or 0x9abc90<=address<0x9abee0 or 0x9abee0<=address<=0x9ac085 or 0x9ac600<=address<=0x9ac709,hex(address);visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook_state)
w(0x2d79078,manager);w(manager+0x14,device);w(0x2d794b0,device);u.mem_write(0x2d79470,b'\0');w(device,vtbl);w(vtbl+0xe4,render_callback);w(vtbl+0x70,sampler_callback)
cases=[];desired=[1,1,7,7,0];cache_addresses=[0x123ff48,0x123ff4c,0x123ff50,0x123ff54,0x123ff58];states=[19,207,20,208,171];values=[2,2,6,6,1]
for flags,cache_mode in itertools.product([0,0x8000000,0x10000000,0x18000000],['miss','hit','mixed']):
    events=[];w(0x123ff20,flags);u.mem_write(renderer,b'\xa5'*0x500)
    cache=[v if cache_mode=='hit' or cache_mode=='mixed' and n%2==0 else 0xffffffff for n,v in enumerate(desired)]
    for a,v in zip(cache_addresses,cache):w(a,v)
    w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,renderer);u.emu_start(0x99f170,end,count=1500);assert u.reg_read(UC_X86_REG_EIP)==end
    expected_render=[]
    if not flags&0x8000000:expected_render.append((27,1))
    expected_render.extend((states[n],values[n]) for n in range(5) if cache[n]!=desired[n]);expected_render.append((206,1))
    if flags&0x10000000:expected_render.append((22,1))
    actual=[(e['state'],e['value']) for e in events if e['kind']=='D3D9_SetRenderState'];assert actual==expected_render,(flags,cache_mode,actual,expected_render)
    samplers=[e['args'] for e in events if e['kind']=='engine_sampler_state'];assert samplers==[[0,0,0],[0,1,0],[0,3,0],[0,4,2],[0,5,2],[0,6,0],[0,7,0]]
    assert read(0x123ff20)==0x8000000 and [read(a) for a in cache_addresses]==desired
    expected_fields={0x438:1,0x4d0:0,0x42c:0,0x440:0,0x470:0x7f7fffff,0x430:0,0x4c8:0};assert all(read(renderer+a)==v for a,v in expected_fields.items())
    cases.append(dict(initial_flags=flags,cache_mode=cache_mode,events=events,final_flags=read(0x123ff20),renderer_fields={hex(a):read(renderer+a) for a in expected_fields}))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x99f170','0x9abc90','0x9abee0','0x9ac600'],case_count=len(cases),native_addresses=len(visited),cases=cases,findings=['D3D9 reset enables alpha blending, sets both RGB/alpha factors ONE and INVSRCALPHA, additive operation, separate alpha enabled; culling disabled.','Native cache hit/miss paths verified; seven engine sampler-state assignments captured with their raw enum arguments.','Combined with archived UI_Alpha HLSL this establishes premultiplied RGB composition, before packet-specific changes.'],runtime_adapters=['9836A0 sampler object selection supplied handle123;983780 binding captures request.','D3D9 SetRenderState and engine sampler-state virtual calls captured; no device execution.','Stack cookie adapted; initialized state caches and D3D9 backend context supplied.'],limits=['Packet-specific99F3A0 state/projection and sampler enum-to-backend mapping remain open.','Does not establish sRGB/gamma, original framebuffer equivalence or ordinary Icon panel rendering.'])
(r/'data/4.20/native_hud_icon_state_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
