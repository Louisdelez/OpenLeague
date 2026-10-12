from pathlib import Path
import json,shutil,datetime
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');p=r/'crates/client/src/native_hud_recharge.rs'
history=r/'docs/plan_history'/('recharge-geometry-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True);shutil.copy2(p,history/p.name)
c=json.loads((r/'data/4.20/native_hud_recharge_direction_contract.json').read_text(encoding='utf-8'));keys=['0x1138eac','0x1138f8c','0x1138d2c','0x1138c74','0x1138a48','0x1138b0c','0x1138a8c','0x1138ba0']
port=(stage/'native_hud_recharge_geometry_port.rs').read_text(encoding='utf-8').replace('NATIVE_CONSTANT_BITS',','.join(f'f32::from_bits(0x{c["constant_bits"][k]:08x})' for k in keys));s=p.read_text(encoding='utf-8');assert 'pub fn direction(' not in s;p.write_text(s+'\n'+port,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Installed original recharge geometry and polynomial direction port.')
