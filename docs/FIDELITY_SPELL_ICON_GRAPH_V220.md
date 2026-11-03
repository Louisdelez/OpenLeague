# SYS-01.2-02 — icônes de sorts par capacité (V220)

Les 488 fiches HUD Q/W/E/R relient désormais le nom de sort du champion (`Data/Spell1..4`), son champ `SpellData/InventoryIcon*`, le DDS source, sa copie et le chargement actuel. Les 629 copies sont exactes ; 1129 fichiers natifs distincts concordent avec les manifestes RADS sélectionnés. Les anciennes associations et inconnues sont conservées.

Le filtre de `native_hud_spells::setup` charge seulement les 486 entrées `InventoryIcon`. Les 143 variantes numérotées existent au catalogue mais sont explicitement exclues de ce chemin actuel. Les fonctions `source`, `setup`, `update` et le décodeur DDS partagé sont liés ; le consommateur partagé est réutilisé sans le dupliquer.

Deux icônes principales restent ambiguës : Amumu W et Nunu R désignent des noms présents sous plusieurs chemins avec des octets différents. Aucun choix de priorité ni remplacement n’est inventé. Heimerdinger E comporte une variante `InventoryIcon2` dont le fichier manque. Les tâches et leurs inconnues restent ouvertes. Les icônes ne qualifient pas les textes, rangs, changements de forme, états complets ou sorts jouables.

Un test Rust actuel a été exécuté en V218 : `native_hud_spells::tests::all486_source_primary_icon_payloads_and_fourteen_widgets_are_preserved`, `cargo test --locked --offline`, Rust1.96.1, code0, un test passé et1542 filtrés. Il décode les486DDS et contrôle14widgets. Sources d’entrée inchangées, journal et binaire épinglés ; octets identiques aux copies d’identité V214. Aucun GPU, fenêtre ou processus historique exécuté. Les variantes numérotées ne sont pas qualifiées par ce test.

Six données erronées sont refusées par le contrôle de provenance. L’audit final relit490sélecteurs, refuse quatre sélecteurs ou tâches incorrects, vérifie quatre ancres et les identités ciblées. Chaque base fournit les490fiches et textes attendus ;42606états manuels et historique conservés. Un libellé de catégorie locale hérité du générateur a été corrigé vers `local_spell_icon_evidence`, avec conservation des enregistrements précédents et des identités. La validation globale reste structurelle, sans rehash de tout le catalogue.

Fichiers : `docs/fidelity_sources_4_20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/completion_tasks_2026-10-20.json`, `docs/reference_spell_icon_sources/spell-icons-v220.json`, `docs/fidelity_spell_icon_graph_v220.json` et les deux bases du plan. Sources du jeu, assets, packs et états de complétion inchangés.

Preuves et scripts : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision218/CURRENT_BEVY_SPELL_ICONS_TEST.json`, `revision219/SPELL_ICON_ASSOCIATIONS.json`, `revision219_qualify_spell_icons.py`, `revision220_register_spell_icons.py`, `revision220/audit_delivery.py`. Sauvegardes : `revision220/before-spell-icon-graph`. Le contrôle de génération initial refusé avant écriture est décrit dans `revision220_preparation_notes.json`. Le premier échec du comparateur V217 est conservé avec son script ; son contrôle absent/objet vide a été corrigé et repassé.

Suite : ressources/liaisons dynamiques et champs de configuration encore génériques. Les trois lacunes d’icône, variantes actives et rendu restent ouverts. Le candidat d’archives SYS-03.4-07 reste non identifié après réponse utilisateur. Aucun champion, jeu ou objectif général déclaré terminé.

## Lot borne -- appartenance et consumer des icones ambigues Amumu/Nunu (2026-11-02)

### Perimetre et critere de fin
Sous-perimetre du parent `SYS-01.2-02` / `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`: examiner si l'appartenance aux manifests RADS selectionnes choisit le candidat de `InventoryIcon` pour Amumu W (slot 1) et Nunu R (slot 3), puis verifier le comportement du consumer HUD courant. Le lot est clos si les manifests identifies sont verifies, les quatre candidates comparees et le choix ou son indetermination relie au consumer actuel. Cela ne clot pas le parent.

### Sources et controle nominal/refus
Les fiches `data/4.20/native_spell_icons.json` enregistrent pour les deux champs `InventoryIcon` le hash de champ `2059614685`, un basename, deux chemins candidats et deux SHA-256 distincts. Les quatre fichiers originaux existent sous le deploy client 4.20; leurs octets correspondent aux SHA-256 deja inscrits. Les tailles sont de 4 224 octets chacune.

Les manifests courants sous F ont ete lus avec `tools/project-plan/patcher_formats.py:3-37` et compares aux identites du recu `docs/reference_native_skin_loader_sources/native-release-membership.json`:
- core `lol_game_client` release `0.0.1.7`: 4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`, identite conforme, 70 286 membres;
- locale `lol_game_client_en_gb` release `0.0.0.235`: 49 251 octets, SHA-256 `c06c83f829dd18cf587098529aa83459c8356dc2fe5ee82d7203c7a9ee3662f0`, identite conforme, 563 membres.

Attendu: une seule candidate est admissible si l'appartenance au release devait trancher. Observe: les quatre candidates sont des membres du core; chacune a 4 224 octets et son MD5 correspond a son entree RADS. Les deux chemins `Characters/.../Info` ont le release de contenu `0.0.0.40`; les deux chemins `Spells/Icons2D` ont `0.0.0.25`. Aucune des quatre n'est dans le manifeste en_GB. Resultat: le membership confirme les deux variantes, il n'etablit pas leur ordre de recherche.

| Ressource | Candidate | SHA-256 du fichier | Release de contenu | MD5 RADS |
|---|---|---|---|---|
| Amumu W | `DATA/Characters/Amumu/Info/SadMummy_AuraOfDespair.dds` | `5bd1bfbb92f83357da92793257b302866ca172e54bf16f5cdd18d2bbca7c298c` | `0.0.0.40` | `e4bce69ebe72c3b5c3547ddcb1e4837f` |
| Amumu W | `DATA/Spells/Icons2D/SadMummy_AuraOfDespair.dds` | `6d35800d5b222e7f3d7e5cbc48517de19b9cde06df8495b5c5702fa9fa517126` | `0.0.0.25` | `2f2cf9fcca4940913f6efde3ae54158a` |
| Nunu R | `DATA/Characters/Nunu/Info/Yeti_Shatter.dds` | `462aaee66cdb94f32ff30c3a501191a9f82f347866526c88f9c8129d3cd6637f` | `0.0.0.40` | `f8cffe76dfcafb5419347e5c27e1ce8f` |
| Nunu R | `DATA/Spells/Icons2D/Yeti_Shatter.dds` | `7f4ead579233a5f1e607abaea51f623ecc8602f9c947e1112915ded538e77c90` | `0.0.0.25` | `2ab6510eb37c4b05708ce6b0bb5425ad` |

### Consumer courant et resultat observe
`crates/client/src/native_hud_spells.rs:35-36` charge uniquement `native_spell_icons.json` -> `entries` pour creer `live.icons`; les deux champs ambigus sont dans `unresolved` et n'ont aucune ligne correspondante dans `entries`. A `:47-48`, le consumer cherche la texture par `(champion, slot)` puis saute l'element si l'icone manque. Attendu pour ces slots dans la version actuelle: aucune texture inventee ni candidate arbitraire. Observe dans le code: Amumu/1 et Nunu/3 n'ont pas d'icone chargee et le widget sans icone est omis. Cela prouve le chemin statique courant, pas un rendu visuel execute.

### Conclusion, ecart et reprise
L'audit borne de l'appartenance et du consumer courant est termine. L'incertitude de priorite native reste ouverte: le champ n'indique pas quel chemin gagne lorsque ces deux membres de contenu different portent le meme basename. Ne choisir aucune variante et ne modifier ni manifest ni consumer. Reprendre seulement avec une trace du lookup original ou un contrat/provider complet demontrant le chemin effectivement choisi et ses octets. Aucun test, build, processus client, affichage ou acceptation humaine n'a ete execute; les anciens tests de 486 icones ne sont pas rejoues. Aucun code, asset, registre de taches, goal, interface ou base n'a ete modifie.


### Precision de casse des chemins Amumu

La valeur `filename` d'Amumu dans `data/4.20/native_spell_icons.json` est `SadMummy_AuraofDespair.dds` (o minuscule), tandis que les chemins de candidates et les cles RADS preserves sont `SadMummy_AuraOfDespair.dds` (O majuscule). Les empreintes et tailles etablissent l'identite des fichiers presents a ces chemins; elles ne prouvent pas la regle de comparaison du provider. Une equivalence du systeme de fichiers Windows ne suffit pas a etablir le lookup RADS historique. Cela rejoint l'inconnue ouverte `OLU-3293c388-b623-5429-8fd7-c89f6f0aba7e` sur l'etat CRT/locale effectif et le case-folding; aucun des candidats n'est promu.
