from pathlib import Path
import hashlib,json

R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent;P=S/'production'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
base={}
def put(rel,text):
 p=P/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')
 base[rel]=sha(R/rel)

rel='tools/extract_replay_runtime_image.py'
s=(R/rel).read_text(encoding='utf-8')
anchor=" ('process_clock_outer_state_and_section',1,0x14b1840,28),"
assert s.count(anchor)==1 and 'loading_package_manager_global' not in s
s=s.replace(anchor,anchor+"\n ('loading_package_manager_global',1,0x2d78f1c,4),")
s=s.replace("stage=Path('E:/mapslol3v3/loading_clock_integration')", "stage=Path('E:/mapslol3v3/loading_standard_integration')")
put(rel,s)
rel='crates/core/src/audio_replay_runtime_image.rs'
s=(R/rel).read_text(encoding='utf-8')
assert 'const REGIONS: [(u32, u32, u32); 61]' in s
s=s.replace('const REGIONS: [(u32, u32, u32); 61]','const REGIONS: [(u32, u32, u32); 62]')
anchor='    (1, 0x14b1840, 28),';assert s.count(anchor)==1
s=s.replace(anchor,anchor+'\n    (1, 0x2d78f1c, 4),')
anchor='        assert_eq!(a.transport.word(0x10d5fa4).unwrap(), 0x8fc7b0);';assert s.count(anchor)==1
s=s.replace(anchor,'        assert_eq!(a.transport.word(0x2d78f1c).unwrap(), 0);\n'+anchor)
put(rel,s)
(S/'image_base_hashes.json').write_text(json.dumps(base,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'staged_image_sources':list(base),'additional_region':'2D78F1C/4 bytes','normal_manager_constructed':False}))
