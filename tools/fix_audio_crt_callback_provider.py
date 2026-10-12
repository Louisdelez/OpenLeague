from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_thread_system_startup.rs';s=p.read_text(encoding='utf-8');old='dispatch(self.slot_callback,value,m,d)?';assert old in s;p.write_text(s.replace(old,'dispatch(self.slot_callback,value,m,d,self)?'),encoding='utf-8')
print('Corrected callback provider argument')
