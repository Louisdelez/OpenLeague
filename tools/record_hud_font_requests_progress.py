from pathlib import Path
r=Path('E:/OpenLeague')
source=(r/'tools/record_hud_texture_bindings_progress.py').read_text(encoding='utf-8')
assert 'tests=300 if pending else 301' in source
source=source.replace('tests=300 if pending else 301','tests=301 if pending else 302')
source=source.replace("log='logs/native-hud-textures-tests.log' if pending else 'logs/native-hud-texture-bindings-tests.log'","log='logs/native-hud-texture-bindings-tests.log' if pending else 'logs/native-hud-font-requests-tests.log'")
source=source.replace('native_hud_texture_bindings_progress','native_hud_font_requests_progress').replace('native-hud-texture-bindings-','native-hud-font-requests-')
source=source.replace('crates/client/src/native_hud_texture_bindings.rs','crates/client/src/native_hud_font_requests.rs')
source=source.replace('font_selection_rust_ported=False','font_selection_rust_ported=True')
source=source.replace('Porter la sélection native des polices et qualifier leur résolution/production','Qualifier puis porter le fournisseur natif du nom de police par défaut et la création des polices')
source=source.replace('301tests source réussis.','302tests source réussis.').replace('924sélections de polices qualifiées, port à faire.','924sélections de polices portées et comparées ; API154requêtes source avec contexte explicite.').replace('Associations textures HUD','Requêtes de polices HUD')
source=source.replace("(r/'docs/native_hud_font_requests_progress.json').write_text", "proof.update(font_requests_api_integrated=True,font_requests_api_verified=not pending,manager_constructor_cases=2,manager_initialization_cases=16,manager_initialization_proof='data/4.20/native_hud_font_manager_contract.json',native_font_files_imported=33,native_font_files_manifest='data/4.20/native_hud_fonts_manifest.json',runtime_font_loading=False,font_default_supplier_qualified=False,glyph_gpu_rendering_qualified=False)\nproof['limits'].append('924font request/failure routes ported; supplier callback returns explicit removal directive, original removal lifecycle not yet integrated. No runtime default font invented.2constructor/16initialization native cases qualified; upstream locale getter790020 identified, not qualified.')\n(r/'docs/native_hud_font_requests_progress.json').write_text")
exec(compile(source,'record font request progress','exec'))
