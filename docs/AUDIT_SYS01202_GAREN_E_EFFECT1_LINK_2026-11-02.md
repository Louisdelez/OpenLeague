# SYS-01.2-02 — Garen E : chaîne numérique Effect1 vers le consommateur de dégâts

Vérifié le 2026-11-02. Lot limité aux champs natifs de dégâts Garen E et à leur consommation par la simulation Rust. Cela ne clôt pas l’audit de tout Garen E ni l’exigence parente OLF-3a11ace9-485c-55ae-8dff-2533902a5839.

## Critère de sortie

Relier les valeurs d’un seul sort de la référence 4.20 au tableau de données consommé et au calcul Rust; contrôler les rangs, un cas nominal et des refus locaux. Séparer ce résultat de la complétude de la capacité, du runtime historique et de l’acceptation humaine.

## Source et provenance

La source native enregistrée est OLS-f118485c-3ebd-5ac9-b577-0eba5cd34d3d : DATA/Characters/Garen/Spells/GarenE.inibin, version 4.20.0.315, 1 125 octets, SHA-256 A8C5BAFD2314176333A3EFEE067ABFE4ACD0538C534FEE05EB7860C6B7C49DC3. Le hachage direct de ce lot concorde avec le registre source. Celui-ci indique une appartenance au projet lol_game_client, projet 0.0.1.7, release membre 0.0.0.181, MD5 bf2e9b4547529208fcf4e2b1fb01f811.

Le lecteur local tools/project-plan/reference_inibin.py a décodé les clés SpellData de l’INIBIN. Les valeurs observées sont :

| Rang | Effect1 base | Effect3, % AD | Effect2, secondes |
|---:|---:|---:|---:|
| 1 | 20 | 70 | 3 |
| 2 | 45 | 80 | 3 |
| 3 | 70 | 90 | 3 |
| 4 | 95 | 100 | 3 |
| 5 | 120 | 110 | 3 |

La table locale data/4.20/native_spells_420.json relie la ligne champion=Garen, slot=2, spell=GarenE au même chemin natif. SHA-256 actuel de cette table : 0CAE6F5C167AA852E8F86E7F3298D7C797727D5CC92616DCB856AC15C8AF5D14. La ligne exportée donne le SHA-256 de l’export GarenE.json 0c29ccdfaa01bf8193c47fa1eb8c7fbf00459916eb64a54ead709b60de741fa3. Elle porte mechanics_validated=false; cette étiquette et les données numériques n’attestent pas la fidélité complète de la capacité.

## Consommateur Rust courant

crates/core/src/spells.rs::garen_value(slot, effect, rank) lit native_spells_420.json et sélectionne Garen par slot. Le chemin slot=2 écrit spin_until depuis Effect2 et capture spin_rank. Dans la boucle de pulsations, le dégât physique est calculé comme Effect1/2 + attaque × Effect3/200, puis appliqué aux cibles dans le rayon local de 325.

À rang 1, le calcul avant armure attendu depuis la source est donc 20/2 + 0,70 × AD/2 = 10 + 0,35 × AD. Les rangs suivent de la même manière les valeurs du tableau. La réduction par armure, le calendrier des pulsations et les gardes restent des comportements de la simulation locale.

## Contrôles exécutés

Les fichiers Rust et la table de données observés ont des dates antérieures au binaire de tests préexistant utilisé : target/debug/deps/openleague_core-21eb81eb13817108.exe, 787 789 824 octets, daté du 2026-10-21T10:19:25Z. Son identité SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D est reprise du reçu ITEM-3024 V858; le binaire n’a pas été rehaché ici et aucun rebuild n’a été effectué. Les trois tests ciblés suivants ont chacun exécuté 1 test et réussi :

- spell_tests::judgment_has_six_pulses_and_blocks_attacks — cas nominal, six pulsations et commande d’attaque refusée pendant l’action.
- spell_tests::judgment_all_ranks_damage_players_without_lifesteal_or_molten_retaliation — vérifie le calcul des cinq rangs sans soin ni représailles.
- spell_tests::silenced_judgment_recast_is_rejected_without_mutating_active_spin — refuse une recast silencieuse et conserve l’état actif.

Les deux premiers appels avec --exact n’ont exécuté aucun test à cause du filtre incomplet; ils sont écartés des résultats. Les relances sans --exact ci-dessus ont exécuté les tests indiqués.

## Décision et limites

Clôturé pour ce lot : identité source et membership enregistrés, champs natifs Effect1/Effect2/Effect3 décodés, donnée locale correspondante et callsite Rust établis, calcul des cinq rangs vérifié par test local, cas nominal et refus local observés.

État distinct : la simulation de Garen E est partielle. Ces tests ne démarrent pas le client original, ne prouvent pas la priorité RADS effective au démarrage, le rendu ni un parcours réseau. Les règles natives de coup critique, le multiplicateur de critique, la collision/swept contact, la pénalité de déplacement dans le jeu historique et le timing historique de recast restent à qualifier; les reçus garen_e_crossing_progress.json et garen_e_cancel_progress.json conservent les limites déjà établies. Aucune acceptation humaine n’a été donnée.

Aucun code, registre de tâches, statut, goal, application de suivi ou base de données n’a été modifié. Condition de reprise : nouvelle source primaire versionnée sur ces règles, ou runtime/client qualifié; ne pas refaire le hash ni le décodage Effect1/2/3 sans changement de source.

## Fichiers et contrôles de ce lot

Nouvelle preuve : docs/AUDIT_SYS01202_GAREN_E_EFFECT1_LINK_2026-11-02.md. Source de code inspectée : crates/core/src/spells.rs et crates/core/src/spell_tests.rs. Données inspectées : data/4.20/native_spells_420.json et docs/fidelity_sources_4_20.json. Contrôles exécutés : hachage INIBIN et table exportée, décodage INIBIN ciblé, trois tests précompilés ciblés. Aucun Cargo/build, test complet, jeu original ou client réseau exécuté.