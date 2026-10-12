from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_shared_fls.rs';s=p.read_text();s=s.replace('let report=Arc::clone(&data.report);','let report=Arc::clone(&data.report);report.attempt();').replace('report.attempt();if outcome.is_err()','if outcome.is_err()').replace('as Windows specifies','as measured on Windows');p.write_text(s,encoding='utf-8')
