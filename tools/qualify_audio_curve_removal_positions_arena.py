from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_resource_curve_admission.rs';s=p.read_text(encoding='utf-8');start=s.index(' #[test]fn audio_curve_removal_subscription_matches576_');test=s[start:s.rfind('\n}')]
assert test.count('#[test]')==1
test=test.replace('audio_curve_removal_subscription_matches576_original_mutated_bound_traversal_delayed_requeue_capacity_oom_duplicates_and_full_cleanup_cases','audio_curve_removal_positions_arena_matches256_original_head_interior_tail_missing_null_duplicate_and_arena_cleanup_cases')
test=test.replace('data/4.20/audio_curve_removal_subscription_preparation.json','data/4.20/audio_curve_removal_positions_arena_preparation.json').replace('],576)','],256)')
test=test.replace('else if n=="bound"{8}else{*z}', 'else if n=="bound"{8}else if n=="other_curves"{52}else{*z}')
s=s[:s.rfind('\n}')]+ '\n'+test+s[s.rfind('\n}'):];p.write_text(s,encoding='utf-8');(r/'tools/qualify_audio_curve_removal_positions_arena.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Added256 native multiple-position/NULL/duplicate/arena removal replay')
