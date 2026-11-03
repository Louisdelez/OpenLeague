# Rôles manquants — traçabilité V112

Les observations préparatoires sont conservées ;la preuve finale fixe les résultats effectifs de publication. Présence de rôle et qualification native restent distinctes.

# V112 — Réconciliation des rôles

La liste historique animation_binding_validation.json contient56 affectations manquantes. Lecture fraîche des122 GLB sélectionnés par le catalogue actuel,avec surcharge Ezreal joint_identity :46 de ces affectations sont maintenant liées,10 restent absentes,zéro nouvelle absence,zéro indice invalide parmi les huit rôles contrôlés. Tous les noms de clips concordent avec le catalogue. Le détail par paire champion/rôle est dans role-reconciliation.json.

Manquants :Azir Q,Fiora W/E,Garen W,Karma R,Khazix R,Quinn W,Varus W,Vayne W/R. Les classifications natives viennent du reçu V27 revalidé par SHA ;elles ne sont pas fraîchement exécutées. Une affectation présente ne prouve ni nécessité du clip ni sélection native correcte. Aucune reconstruction autorisée par ce seul recensement.

Première tentative :supposition incorrecte que audit contenait les lignes ;il s’agit d’un reçu pointant vers le JSON historique. Lecture corrigée avec contrôle taille/SHA avant usage ;script initial conservé. Aucun catalogue,asset ou code de production changé. Suite :classifications et alias compatibles,consommateurs de reconstruction/remplacement puis lecteur et intégration SYS-14.5.


# V112 — Classification des dix absences

Dix sources de sort relues via le lecteur INIBIN actuel ;taille/SHA et sept champs comparés aux preuves précédentes. Huit AnimationName nommés,deux champs présents mais vides (Varus W,Vayne W). Aucun champ manquant dans ces dix cas.

Karma R et Quinn W déclarent Spell3. Les recherches de sous-chaîne dans le catalogue trouvent deux clips Karma et trois Quinn ;cela ne prouve aucune sélection effective et ne justifie pas un remappage. Les six autres alias nommés n’ont pas de candidat par cette recherche bornée,ce qui ne prouve pas une absence dans toutes les formes ou graphes.

Huit cas du classificateur passent :absent,vide,nommé et cinq refus de types invalides. Aucun runtime natif,export ou reconstruction exécuté. Ne pas conclure que les deux champs vides sont des bugs ni que les huit alias nécessitent une reconstruction. Suite :lier les consommateurs et contrôles de remplacement aux cinq exigences SYS-14.5,puis qualifier le lecteur et intégrer.


## Lecteur

197 fichiers,240 contrôles et26 cas dont25 refus. Les six tests Rust de V111 sont hérités,non rejoués. Aucune animation reconstruite ni affectation changée.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-14.5-01 | Historical56 missing bindings reconcile to46 now bound and10 still absent;122 current GLB names agree and controlled role indices are valid. | Presence is not semantic/native playback qualification;retain original56 report unchanged. |
| SYS-14.5-02 | Ten native source field sets freshly reread:eight named aliases,two explicitly empty;classifier passes8 cases including5 invalid-type refusals. | Empty,absent and named states do not prove legitimate no-cast,export failure or mandatory reconstruction. |
| SYS-14.5-03 | Karma R and Quinn W both use Spell3;substring search finds2 Karma and3 Quinn candidates. Native graph/skin resolver remains bounded. | No dispatch or compatibility inferred from names;qualify graph types,forms,rig and selection before remap. |
| SYS-14.5-04 | Current renderer skips missing role;classifier distinguishes evidence states. | No qualified mandatory-clip reconstruction consumer identified;do not invent clips solely because a binding is absent. |
| SYS-14.5-05 | Actual GLB Ezreal R binding/interruptions were exercised in six V111 tests;transitions use current80ms policy. | Retained scoped tests are not every replacement,all roles or native transition acceptance. |

Reçu : docs/reference_animation_role_gap_sources/animation_role_gap-links.json. Livraison : docs/fidelity_registry_animation_role_gap_links_revision_4_20.json. Les cinq tâches et le Goal restent ouverts.
