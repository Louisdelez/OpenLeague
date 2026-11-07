# SYS-01.2-02 — Chemin DDS existant dans les trois fiches textures (V493)

24 octobre 2026 — F:\OpenLeague. Référence fournie LoL 4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; catalogue 4.20.1 distinct.

## Résultat intégré

Les fiches PRESENT-TEXTURE de Blue_Minion_Basic, Blue_Minion_Wizard et Red_Minion_MechMelee exposent maintenant le remplacement conditionnel DDS déjà présent dans le client. V492 avait relié ce chemin aux fiches parentes PRESENT ; cette livraison complète les trois exigences précises de textures.

Quinze liens sont ajoutés vers cinq consommateurs existants, sans créer de nouvelle ancre ni modifier le code du jeu : activation `DRAFT=false`, validation des données DDS, demande de chargement, affectation à `base_color_texture` et enregistrement du plugin. Trois liens supplémentaires désignent la chaîne de mipmaps native complète. Une source documentaire nouvelle porte ce reçu. Les preuves V489 et V492 sont conservées et référencées.

Les trois questions de fidélité restent strictement identiques, ainsi que toutes les autres inconnues du registre. Aucun état de tâche ou critère d’acceptation ne change. Aucun son, animation, shader, texture ou code de jeu n’est réparé dans ce lot.

## Sources et consommateurs réels

Pour chacun des trois noms, la source native est `DATA/Characters/<nom>/<nom>.dds` du deploy de référence. Le fichier actuel est `assets/forms/native_minion_mips/<nom>.dds`. La relecture fraîche confirme l’égalité des octets : 174 904 octets, DXT1, 512×512, dix niveaux de mip, dont 174 776 octets de données après l’en-tête. Chemins, tailles et SHA-256 sont enregistrés dans le reçu ; aucun changement d’asset n’est effectué.

Le module `crates/client/src/native_minion_mips.rs` cible exactement les sous-assets `forms/<nom_en_minuscules>.glb#Material0/std` et `#Texture0`. Il est enregistré dans `main.rs`. L’exécution du système est ordonnée après `animation::load_models` et avant `actor_fow::bind`.

Le code contrôle la disponibilité du matériau, l’identité de sa texture, le support BC, la présence du DDS chargé et ses dimensions/octets. Il conserve une texture étrangère. Il conserve ou restaure le PNG en cas de support BC absent, chargement en attente/échec ou validation refusée. Lorsqu’il est admissible, seul `base_color_texture` reçoit le DDS. La demande configure sRGB, filtrage linéaire et répétition.

Ces conditions sont constatées dans le code courant, pas observées sur le GPU. Les PNG embarqués dans les GLB et les UV comparés en V489 ne sont pas invalidés par ce chemin supplémentaire. Les autres niveaux ne se trouvent pas dans ces PNG, mais une source DDS distincte est disponible au consommateur conditionnel. Le registre distingue désormais explicitement ces deux ressources.

## Vérifications

- Trois cas nominaux : identité du profil, correspondance des sous-assets, égalité native/copie, en-tête et taille DDS, et cinq ancres de code exactes par tâche.
- Neuf refus du contrôle de preuve : autre profil, octets modifiés et mauvais en-tête, chacun essayé sur les trois profils en mémoire. Ils ne sont pas présentés comme des tests du moteur ou du GPU.
- Quatre sélecteurs nominaux et cinq sélecteurs invalides dans la préparation.
- Trois refus du registre : mauvais propriétaire d’inconnue, fausse résolution et condition de résolution absente.
- Comparaison des 42 214 instructions : seules les trois fiches textures changent, les 42 211 autres restent exactes. Tous les enregistrements d’inconnues sont inchangés. Les anciens liens, recherches, notes, critères et dépendances sont préservés.
- Publication puis audit indépendant dans les deux bases : quatre lignes documentaires actualisées par base, 42 602 autres lignes exactes, 42 606 états/notes et 23 entrées d’historique conservés. Vérification par le lecteur réel Store.task/copy_text.

Attendu et observé : les trois fiches donnent accès au chemin DDS réel et conservent leurs limites ; aucune preuve source n’est transformée en validation visuelle. Aucun build, test Rust, lancement de jeu ou capture GPU n’est effectué. Les tests CPU existants du module ne sont pas rejoués.

## Limites et reprise

Restent ouverts : la branche réellement choisie dans une session ordinaire, l’image préparée par le moteur, le matériau effectivement dessiné, le choix des niveaux de mip, le filtrage, la politique alpha, l’éclairage et la comparaison visuelle native. Les observations de normales, UV et pixels embarqués gardent leur portée précédente. Aucune des trois questions n’est déclarée résolue.

Livrables : `docs/reference_minion_behavior_sources/minion-texture-dds-v493.json`, `docs/fidelity_minion_texture_dds_v493.json`, quatre registres de fidélité/tâches, couverture, plan, reprise et notes docs/ai. Les scripts `revision493_delivery.py`, `revision493_check.py`, `revision493_finish.py` et les reçus de préparation/contrôle/audit sont sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision493*`.

Suite de SYS-01.2-02 : examiner les huit fiches ACCEPT des sbires et leurs preuves de cycle naissance/combat/mort/fin. Ne pas déduire leur acceptation de cette correction de liens. Le sous-inventaire du chargeur conserve 127 fiches à reprendre, 381 associations partielles et 32 exclusions ouvertes ; ces trois fiches étaient déjà partielles. Le Goal reste actif.

Bilan vérifié :3liens natifs,15liens vers des consommateurs existants,1source documentaire nouvelle,aucune inconnue ajoutée ou résolue. 47 identités directement vérifiées. Graphe :98667 sources/2538 consommateurs/25724 questions ouvertes/5517 résolues avec historique.
