# SYS-01.2-02 — Fiches principales des attaques, V718

Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB ; catalogue officiel 4.20.1 distinct.

V718 : les 122 fiches principales d attaque sont reliees aux sources et consommateurs precis de leurs 789 sous-taches. 2974 liaisons natives et 2431 liens vers 28 consommateurs existants sont ajoutes. 300 fichiers natifs et 152 references sont verifies par SHA ; 2977 champs natifs sont relus, dont 935 absences conservees. Les 5628 ancres du registre correspondent aux 541 fichiers actuels sur F. Aucun jeu ou test de gameplay reexecute, aucune portee fonctionnelle promue.

## Problème corrigé

121 fiches principales CH-…-ATTAQUE ne pointaient que vers champion_catalog. Leurs sous-tâches avaient déjà des sources et lecteurs précis. La fiche Gnar conservait trois liens supplémentaires. Les 122 parents exposent maintenant les composants existants, avec la provenance par sous-tâche et les limites inchangées.

## Attendu et observé

| Contrôle | Attendu | Observé |
|---|---|---|
| Périmètre des parents | 122 champions, dépendances du même champion | 122 parents, 789 enfants vérifiés |
| Couverture des aspects | 6 aspects communs et projectiles recensés | 732 enfants communs et 57 PROJECTILE |
| Fichiers originaux liés | Taille et SHA conformes au registre | 300 / 300 |
| Références des enfants | Identité conforme aux preuves enregistrées | 152 / 152, y compris les GLB concernés |
| Champs INIBIN | Présence, hash et valeur conformes aux sélecteurs | 2977 / 2977 ; 935 occurrences absentes restent absentes |
| Ancres du registre complet | Ligne, texte et identité du fichier actuel | 5628 ancres, 541 fichiers, 671 paires fichier/source ; aucun écart |
| Ajouts aux parents | Seulement les liens de leurs enfants | 2974 liaisons natives, 2431 liens de consommateurs ; aucun nouveau rôle |
| Falsifications | Refuser enfant manquant, mauvaise identité, champ et ancre faux | 6 refus vérifiés |

Les 28 consommateurs couvrent notamment la portée, le rayon du corps, le délai d attaque, la cadence, le critique, l impact physique et son vol de vie, le vol des projectiles, les branches Q et la sélection d animation. Leurs qualifications restent partielles ou limitées à une frontière selon la preuve existante. La présence de ces liens n accepte pas les comportements des 122 champions.

## Audit global et priorités

Avant intégration : 42215 exigences, 100288 sources, 5628 consommateurs. Aucune exigence sans référence ni lien de consommateur ; 384 sans source native, à interpréter selon leur contrat local. Les exigences avec un unique rôle étaient : chargeur de champions 7765, refus explicite 3461, chargeur de monde 3139, chargement Map10 662, catalogue objet 224, dispatch sort d invocateur 156, lecteur du plan 73. Ces comptes mesurent des liens, pas des fonctionnalités manquantes ni terminées.

Cette livraison enlève 121 parents de la catégorie « seul chargeur de champions ». Les autres liaisons génériques doivent être inspectées par famille. Les limites de portraits et de rendu V717 restent ouvertes ; elles ne bloquent pas la correction des autres liens du registre.

## Limites

- Audit de traçabilité : les liens de chaque fiche principale sont composés uniquement à partir de ses dépendances explicites, du même champion. Les anciennes liaisons restent conservées. Aucun lien de consommateur hors périmètre n est propagé.
- Les 28 consommateurs conservent leurs rôles, limites et qualification. Un refus de sort ne devient pas une implémentation de reset ; le vol de vie partagé ne prouve pas tous les effets à impact ; le chargeur ne devient pas un moteur d attaque complet.
- Les 935 occurrences de champs absents restent absentes et nulles : aucune valeur zéro ni règle native n est inventée. Les formules de timing, cadence, rayons de corps, RNG, reset, annulation et sélection d animation restent qualifiées selon leurs preuves partielles antérieures.
- V519/V520/V521/V522 sont des preuves héritées dont les identités sont revérifiées. Leurs tests Rust, simulations et inspections graphiques ne sont pas réexécutés dans V718. Le parseur Python INIBIN est exécuté ; aucun binaire natif ni client du jeu ne l est.
- Gnar possède désormais la sous-tâche PROJECTILE ajoutée en V522 : 57 sous-tâches de vol sont présentes. La lacune du plan décrite historiquement en V521 est conservée comme historique, pas comme absence actuelle. Cela ne qualifie pas toutes les formes de tous les champions.
- L audit global contrôle toutes les ancres courantes et leurs identités source, pas la sémantique de 42215 exigences ni les empreintes de 100288 sources. Les 384 exigences sans native_input comprennent des contrats locaux ; elles ne sont pas automatiquement déclarées défectueuses.
- Aucune tâche, prérequis ou inconnue n est fermé. Les compteurs de questions ouvertes ne garantissent pas un inventaire exhaustif des différences. La validation du jeu complet reste distincte.
- Les chemins de certains enregistrements sources restent historiques sur E ; leurs octets correspondent au code effectivement lu sur F. Le consommateur actuel est contrôlé sur F sans déplacer ni écraser ces sources historiques.
- Le premier générateur du script de livraison a échoué sur une erreur de délimitation de chaîne avant création de fichier ou modification du projet. La version présente a été créée et vérifiée séparément.

## Intégration et conservation

123 fiches (les 122 parents et SYS-01.2-02) sont mises à jour dans le registre et dans les deux bases du plan. Les enfants, autres tâches, cases, notes, historiques, identifiants, inconnues et ordre des phases restent inchangés. Les contrôles de l application réelle Store.task et copy_text, le rechargement idempotent, les contrôles SQLite et les empreintes des tables conservées sont consignés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision718_delivery/VERIFIED.json après exécution.

Fichiers modifiés : ce rapport, [reçu détaillé](fidelity_attack_parent_links_v718.json), les registres completion_tasks/fidelity_requirement_trace/fidelity_sources, coverage/completion_plan/resume_checkpoint, CURRENT/HANDOFF et les deux bases du plan. Scripts et observations sur F:/OpenLeague-work. Deltas ciblés compressés ; aucune copie intégrale de base.

Aucun code de production du jeu modifié, aucun build lancé. Goal et tâches restent ouverts.
