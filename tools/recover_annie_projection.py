"""Preserve native projected shaders and both ambiguous glow candidates; install UV preparation."""
from pathlib import Path
import json, hashlib, datetime, shutil
from PIL import Image
r=Path('E:/OpenLeague')
n=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy')
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
records=[]
for name in ['SIMPLE_PROJECTED_VS.vs_2_0','SIMPLE_PROJECTED_PS.ps_2_0']:
    source=n/'DATA/Shaders/HLSL/ParticleSystem'/name
    target=r/'data/4.20/shaders/ParticleSystem'/name
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(source,target)
    assert sha(source)==sha(target)
    records.append({'source':str(source),'archive':str(target.relative_to(r)),'sha256':sha(source)})
textures=[]
for label, relative in [('base','DATA/Characters/Annie/Skins/Base/Particles/annie_fire_glow.dds'),('shared','DATA/Shared/Particles/Annie_Fire_Glow.dds')]:
    source=n/relative
    target=r/f'assets/particles/annie/candidates/Annie_Fire_Glow_{label}.png'
    target.parent.mkdir(parents=True,exist_ok=True)
    pixels=Image.open(source).convert('RGBA')
    pixels.save(target)
    assert Image.open(target).convert('RGBA').tobytes()==pixels.tobytes()
    textures.append({'candidate':label,'source':str(source),'source_sha256':sha(source),'asset':str(target.relative_to(r/'assets')),'png_sha256':sha(target),'rgba_sha256':hashlib.sha256(pixels.tobytes()).hexdigest(),'dimensions':list(pixels.size),'pixels_equal':True,'selected_for_runtime':False})
assert textures[0]['rgba_sha256']!=textures[1]['rgba_sha256']
source=Path('E:/mapslol3v3/projected_surface.rs')
target=r/'crates/client/src/projected_surface.rs'
shutil.copyfile(source,target)
main=r/'crates/client/src/main.rs'
text=main.read_text(encoding='utf-8')
line='#[allow(dead_code)] // Native UV/terrain preparation; emitter constant producer and GPU consumer pending.\nmod projected_surface;\n'
if 'mod projected_surface;' not in text: main.write_text(line+text,encoding='utf-8')
proof={
    'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,
    'native_shaders':records,'glow_candidates':textures,
    'native_projection_contract':{
        'uv':'temp = (native_world_xz - OFFSET_AND_SCALE.xy) * OFFSET_AND_SCALE.zw; uv = (temp.x*cos - temp.y*sin, temp.x*sin + temp.y*cos)',
        'height':'Y does not affect UV. Positions come from input mesh; no screen-depth sampling appears in this shader.',
        'pixel':'Texture sampled at projected UV, RGB multiplied by FogOfWar factor alpha, then environment death/color-palette/mip visualization variants.',
        'absent_from_pixel_shader':['particle vertex RGBA multiplication','p-rgba color lookup sampling','scene-depth reconstruction'],
        'constant_producer_qualified':False,
    },
    'preparation_module':'crates/client/src/projected_surface.rs',
    'module_sha256':sha(target),
    'runtime_projected_consumer':False,
    'limits':[
        'Both glow assets retained with distinct names; native path precedence remains unresolved. No arbitrary runtime selection.',
        'CPU clipping retains original triangle heights and winding; UV footprint clipping is reconstructed, not a qualified native clipping/sampler policy.',
        'UV math port is not an emitter implementation. Native c235/c236 producer, terrain submission, projection scale/rotation/offset, blend/depth/sampler/FOW and lifetime remain unqualified.',
        'Native pixel shader does not read particle RGBA; do not apply the quad color-lookup contract to this projected shader without evidence.',
        'No new GPU appearance or full champion completion claimed.'
    ]
}
(r/'docs/annie_projection_sources.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copyfile(Path(__file__),r/'tools/recover_annie_projection.py')
print(json.dumps({'shaders_archived':len(records),'glow_candidates_preserved':len(textures),'projected_runtime_complete':False}))
