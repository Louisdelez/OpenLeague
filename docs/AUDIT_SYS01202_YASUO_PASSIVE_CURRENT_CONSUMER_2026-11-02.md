# SYS-01.2-02 — Yasuo : frontière du consommateur actuel de Way of the Wanderer (V808)

Date : 2026-11-02 13:45 UTC. Projet : `F:/OpenLeague`. Exigence : `OLF-202d0384-81f7-5b11-b7b0-c99a3405fb25`. Tâche source : `CH-Yasuo-PASSIF-SOURCE` (`a_qualifier`, acceptation et implémentation à false). Son prérequis `CH-Yasuo-IDENTITE` reste également `a_qualifier`. Inconnue conservée : `OLU-5dd3c2d5-ecf3-521d-ac2c-f471376ddfcc`.

## Portée et critère de sortie

Unité bornée : établir statiquement si les deux parties visibles dans la référence du passif — doublement du critique et bouclier alimenté par le déplacement — atteignent un consommateur de jeu actuel. La question de sortie est : les chemins Rust actuels lisent-ils une charge de mouvement Yasuo et accordent-ils le bouclier après une source de dégâts admissible ? Critère : relever la donnée attendue, les ancres de calcul/événement présentes, les producteurs d’octroi de bouclier, leurs refus visibles et les limites de portée. Cette clôture concerne seulement l’audit de frontière consommateur ; elle ne clôt aucune tâche fonctionnelle.

Réutilisation : le rapport V536 couvre déjà le contrôle comparatif du critique, et le V533 porte l’identité, les champs bruts et les candidats natifs. Je n’ai pas relancé ces collectes ni réexécuté leur binaire.

## Source et résultat attendu

- Le contrat local de référence Data Dragon `4.20.1`, `championFull.json /data/Yasuo`, décrit le doublement de la chance de critique, une charge de bouclier liée au déplacement et le déclenchement du bouclier lorsqu’un champion ou un monstre inflige des dégâts. Il s’agit du catalogue comparatif `4.20.1`, pas d’une preuve de la politique serveur du client PUBLIC `4.20.0.315`.
- Le reçu V533 relie `Yasuo.inibin` (`OLS-179ec002-1983-5538-9ef7-b20afedef0f7`, 1 266 octets, SHA-256 `797977795e29e35e2a3140a90ff6fca9132d0fcf94af27b0bcd26d7ea786e579`) et les candidats `YasuoPassive.inibin` (`OLS-50defacd-21e9-50fd-bd48-995a2f2c7053`, 1 560 octets, SHA-256 `00c99df33e71f82f168c3a09bbea576d877214d03de038c4e02b5159d3cce4c8`) et `YasuoPassive.luaobj` (`OLS-e012d9c9-48b1-55d6-a450-8164ca5ce336`, 182 octets, SHA-256 `590931f87f55aa1fceb44f85f205a4c4de0ba56f557ff0c309590116bb4daa54`). L’INIBIN du champion déclare le nom `YasuoPassive` et l’icône `Yasuo_Passive.dds`; sa description passive est absente. Ces liens ne restituent ni callback serveur, ni ordre d’alias, ni formule de bouclier.
- L’identité et le membership de ces entrées sont réutilisés depuis les reçus V533/V536 ; les empreintes de ressources originales n’ont pas été recalculées dans ce lot.

## Consommateurs courants inspectés

| Clause | Observé dans la révision lue | Conclusion de cette portée |
|---|---|---|
| Chance de critique | `critical.rs:12` lit `critical_contracts.json`. `progression.rs:92–98` forme la chance à partir de base + croissance + objets, clampée à 0–1 ; aucun multiplicateur Yasuo n’y est appliqué. La ligne Yasuo du JSON porte chance `0`, croissance `0`, multiplicateur de dégâts critiques `2`. `attacks.rs:294` utilise la chance calculée au tirage. | Le consommateur courant de statistiques/attaques existe ; le facteur passif de doublement n’apparaît pas dans cette formule. Le `2.0` du profil est un multiplicateur de dégâts, pas le doublement de chance. Le résultat de test V536 est historique et n’est pas revendiqué comme exécution de la révision actuelle. |
| Charge de mouvement et déclenchement du bouclier Yasuo | `shields.rs:12–36` expose un octroi événementiel générique avec gardes (montant fini et positif, durée positive, cible connue et vivante) ; il ne calcule aucune charge. `summoners.rs:75–85` est l’appel de production relevé : `Barrier` crée le tag `SummonerBarrier`. `damage.rs:101` consomme les boucliers après mitigation ; cette étape ne crée pas le bouclier Yasuo. Aucun appel de production reliant le mouvement Yasuo ou un coup de champion/monstre à `grant_shield` n’a été trouvé dans les sources parcourues. | Le stockage, l’absorption et un producteur Barrière existent. Le couple « déplacement Yasuo → charge → dégât éligible → bouclier » n’a pas de consommateur/producteur identifié dans le code actuel inspecté. |

Contrôle borné des appels `grant_shield(` dans `crates/` : l’unique appel de production identifié est Barrière. Les occurrences restantes sont sous des tests ou utilisent des montants fixture ; notamment l’appel du client dans `ezreal_q_flash_events.rs` est dans le bloc `#[cfg(test)]`. Les appels de fixtures ne sont pas pris comme générateurs de gameplay. La recherche textuelle Yasuo / `Way of the Wanderer` / `flow shield` dans les sources Rust n’a retourné aucune ancre Yasuo ; cela ne prouve pas une absence au-delà de ces sources et ne remplace pas la lecture des chemins ci-dessus.

Empreintes SHA-256 des fichiers courants relus :

| Fichier | Taille | SHA-256 |
|---|---:|---|
| `data/4.20/champions.json` | 32 052 | `7cc80048c9460419041134232345d9b4da6d8f4e6795f7236720bef39e99de88` |
| `data/4.20/critical_contracts.json` | 185 623 | `661bd30040648592d784481dba54b0b1dd26a172afbe5dd1a17cfb624891323d` |
| `crates/core/src/critical.rs` | 5 157 | `7b21e470dfb43e9a49b890006dccf2edb42cad5d16aa8dc32bfab8de5f2d92db` |
| `crates/core/src/progression.rs` | 8 632 | `eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766` |
| `crates/core/src/attacks.rs` | 24 623 | `f6532eebe422900006c2af22a3fab2f0618f38938f8e24fc012fba340f1325bc` |
| `crates/core/src/shields.rs` | 4 875 | `e26cf459029a0ae771fcaf0dcadf684f9898aec20fec5d6a21371515d9d348cf` |
| `crates/core/src/summoners.rs` | 5 147 | `7af19297380715624cb37f70ab62dfa9a65f7c8665e49b7699ee495d7a0d56a3` |
| `crates/core/src/damage.rs` | 14 316 | `0d579a7b4e7a3941df7e70f78d62029c9f34df0c345749c2adc17153f9624387` |

## Attendu, observé, contrôles et décision

- Attendu au niveau de la référence : les deux chemins passifs modifient le critique et le bouclier dans les conditions décrites par le catalogue comparatif.
- Observé statiquement : calcul de critique sans facteur Yasuo ; stockage/consommation génériques de boucliers, avec Barrière comme producteur courant identifié ; aucun lien Yasuo mouvement/dégâts → octroi relevé.
- Cas nominal et limites : l’audit de sources prouve les branches statiques et les refus de `grant_shield`, mais aucune commande de jeu ou fonction n’a été exécutée pour ces refus. Aucun test, build, binaire, client, VM Lua, rendu, audio ou réseau n’a été lancé dans ce lot.
- Décision : **sous-audit statique consommateur clos** pour les deux frontières décrites. **CH-Yasuo-PASSIF-SOURCE reste à qualifier**, le passif n’est pas implémenté ni accepté, et SYS-01.2-02 reste actif/partiel. Le prérequis global D01-SYS-01-1 demeure non accepté selon V805. Aucun statut, case, registre, Plan, application ou base n’a été modifié.

## Conditions précises de reprise

1. Pour qualifier la règle native : obtenir une preuve primaire `4.20.0.315` du producteur de charge, du seuil/reset, du déclencheur éligible, de la valeur/durée du bouclier et des événements de cycle de vie. Le nom de l’asset ou le texte `4.20.1` ne suffit pas.
2. Pour l’implémentation : ajouter un état de charge Yasuo au chemin de déplacement et le relier aux événements de dégâts admissibles et à l’octroi/affichage du bouclier ; conserver Barrière et les autres producteurs existants.
3. Pour la vérification : après qualification et implémentation, tester seuil, dégâts par champion/monstre, non-déclencheurs, mort/réapparition, interruptions et remise à zéro ; séparer preuve runtime, rendu et acceptation humaine.

Reprendre la recherche uniquement sur un nouvel élément primaire ou un changement de consommateur/source. Ne pas refaire V533/V536 ni la recherche lexicalement identique sans cette piste.

## Documents utilisés

- `docs/reference_requirement_trace_sources/champion-passive-source-partial-links-v533.json` (entrée Yasuo, source et metadata partiels).
- `docs/FIDELITY_YASUO_CRITICAL_GAP_BOUNDARY_LINKS_V536.md` et `docs/fidelity_yasuo_critical_gap_boundary_links_v536.json` (critique : résultat historique, frontière déjà documentée).
- `docs/completion_tasks_2026-10-20.json` et `docs/fidelity_requirement_trace_4_20.json` (lecture seulement : tâche, prérequis, inconnue et consommateurs enregistrés).
- Sources locales et code listés dans les tableaux ci-dessus.
