# SYS-01.2-02 — VFX des passifs, sources et consommateurs V669

UTC : 2026-10-27T09:32:17.777612+00:00. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct.

## Résultat intégré

V669 :121 fiches VFX de passif reliées à382 sources natives et5 points actuels de résolution,605liens. 184chunks et184INIBIN examinés ;20mentions d’effets,14fichiers Troy candidats. Sonde Rust :481requêtes,142résolues dans le profil courant,339sans résultat dans ce profil ;ce ne sont pas des comptes d’assets manquants. 16contrôles source dont11refus,9contrôles provider dont5refus. Métadonnées désactivées/contradictoires et priorités natives ouvertes ;aucun rendu de passif accepté.

Les121fiches restantes et SYS-01.2-02 sont enrichies dans le registre et les deux bases. Chaque instruction copiée contient ses sources, valeurs, indicateurs, résultats de résolution, prérequis et limites. Le lot AnnieV668 reste intact. Aucun code de jeu ni asset modifié, aucune case cochée, aucune question fermée.

## Constats natifs

L’audit porte sur184INIBIN et184chunks Lua sélectionnés par les fiches de passif antérieures, avec deux textes et deux preloads conservés en contexte sans leur attribuer une fonction de particule. Les385fichiers natifs uniques relus, candidats compris, correspondent aux manifestes sélectionnés. L’inventaire de recherche contient12065Troy et498fichiers Rust du client. Il ne constitue pas un inventaire des effets indispensables à chaque passif.

- **Akali :** AutoBuffActivateEffect et Effect2 nomment les effets DMG/AP, attachés respectivement à L_hand/R_hand. Deux Troy sont présents. Les conditions de déclenchement et la lecture graphique restent à qualifier.
- **Noms hérités non résolus :** six mentions AnnieBasicAttack_mis.troy et une SpiralBlade_tar.troy n’ont pas de candidat dans le scan. Plusieurs indicateurs HaveHitEffect/HaveAfterEffect valent0. Leur nécessité effective n’est pas démontrée : ne pas fabriquer un asset sur ce seul nom.
- **Renekton :** BloodSlash possède deux candidats, dans Darius/Base et Shared. Le catalogue actuel résout Shared ; cela ne prouve pas la priorité historique ou celle d’un skin.
- **Skins :** AzirPassive contient CyberEzreal, SionPassive contient ZiggsSnowday, KhazixPassive contient KhazixSkin02. Valeurs natives conservées, sélection effective non qualifiée.
- **Ezreal :** BuffTextureName correspond à l’icône lue par native_ezreal_passive_hud. Les modules projected/sparks utilisent r_samples_3d pour R ;ils ne sont pas promus en effets du passif.

Les champs absents, vides, non textuels, nommés et leurs indicateurs sont distingués. La présence d’une icône de buff ne démontre pas un effet dans la scène. L’absence de nom dans le code ne démontre pas l’absence d’un chargement dynamique.

## Consommateur courant vérifié

Les méthodes Provider/SearchProvider sont extraites exactement de map_resource_provider.rs et compilées dans une sonde isolée. Les lignes réelles du catalogue embarqué et de Map10 sont fournies par un adaptateur explicite. Le profil comporte25198fichiers et46595entrées. Sur481requêtes uniques,142résolvent un chemin logique et339restent sans résultat dans ce profil ;504associations aux champions sont conservées.

Les wrappers RecoveredGlobalCatalog/Map10Catalog et l’application Bevy ne sont pas exécutés. Un chemin logique .troy ne prouve pas l’ouverture de son .troybin. Les cinq consommateurs ajoutés décrivent l’insertion, les recherches locale/contextuelle, le catalogue embarqué et son enregistrement au démarrage. Ce sont des frontières de résolution, pas des renderers de passif complets.

## Contrôles exécutés

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| AUDIT_SOURCE | 0 | c845d59fd5788a33a80be81dda10a6b7904f5b3d3af4d60ea111f8e480645d85 |
| PROVIDER | 0 | c9f3b03f0dab30db8c83c9c411f71d1ceb152c7f6b723c4f214a63d73d3378fa |
| INSPECTION_SCOPED | 0 | 3fdd11b1f9e97f579d59da83a39770ef1e1dbb21592ae7105e8a9cd1f3718a3e |
| PREPARE | 0 | 2b7ccfabe27c577db51289d403ec50980b4cc9ad19ecd7328b6c58f4d405fbae |
| CHECK | 0 | c2bdcbfc66727f20a69cb698c41a3ad123652f7f1d1cace6f4af8c92e2d5132d |
| PUBLISH | 0 | 3918821b4655a476a2bc32dba32bc4e0aec597785752fa04d69c2d3a8b9b2580 |
| AUDIT | 0 | ce0fda38925544476e3c17e3f0bdfd2d162993a8eb49a221f38efd394c77974c |

16contrôles de source dont11refus : états de champ, noms sûrs, attaches, noms invalides/traversants/non-particules et Lua invalide/tronqué. La sonde Rust passe9contrôles dont5refus : non-ASCII, clé doublonnée, nom de fichier invalide, ordre des alias, masque local vide, différence resolve/contains sans contexte et nom absent. Toutes les requêtes sont également vérifiées en majuscules.

Le candidat refuse2420falsifications d’association et4graphes invalides. Trois corruptions du format de sauvegarde compact sont refusées.121fragments de trace changent ;42094restent identiques. Pour chacune des deux bases :122lignes ciblées vérifiées,42485autres lignes,42607états manuels et23historiques conservés ;synchronisation normale idempotente. Identités, hiérarchie et inconnues identiques en octets.

La première préparation de fiches a échoué sur un argument own_questions dupliqué, avant publication. Le script et le journal sont conservés ;la variante scoped corrige l’assemblage et passe. Aucune source native corrigée pour faire passer le contrôle.

La revue globale contrôle42215exigences et5605ancres/empreintes de consommateurs, sans écart. Le registre comporte99365sources ;elles ne sont pas toutes rehachées dans ce lot. Aucun nouveau GPU, audio, Bevy ou serveur historique exécuté.

## Fichiers, sauvegardes et limites

Modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json ;122lignes de chacune des bases ;couverture, plan, reprise et notes courtes. Ajoutés : rapport, reçu et vérificationV669. Les scripts/sonde/observations sont conservés sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20.

F étant presque plein, les six archives de baseline identiques sont partagées avec V668 sans changer leurs octets. candidate/PATCH.json.gz reconstruit les six documents et vérifie leurs SHA complets. Les lignes avant mise à jour et toutes les métadonnées de base sont conservées dans DATABASES_BEFORE.json ;l’inversion de la mise à jour est testée sur copie et restitue exactement les valeurs et empreintes logiques antérieures. Cela ne revendique pas une restauration de la disposition physique SQLite. Les anciennes sauvegardes complètes restent intactes. Les deux lignes héritées « Archived verified ... snapshot » du journal PREPARE désignent ici les copies temporaires sur C, pas de nouvelles archives complètes sur F ;les reçus précisent cette portée. Les copies temporaires C sont supprimées après contrôle. Ne jamais modifier en place une archive liée physiquement.

Preuve : F:\OpenLeague\docs\fidelity_passive_vfx_links_v669.json. Reçu : F:\OpenLeague\docs\reference_requirement_trace_sources\passive-vfx-links-v669.json. Audit source : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision669_passive_vfx_metadata_audit\OBSERVATIONS.json. Sonde : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision669_passive_vfx_provider_probe\OBSERVATIONS.json. Instructions : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision669_passive_vfx_inspection_scoped/TASK_INSTRUCTIONS.json. Revue : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision670_trace_review\REVIEW.json.

## Suite

Continuer SYS-01.2-02 sur F:/OpenLeague. V669 publié/audité :121fiches VFX plusSYS,382liens natifs et605liens vers5frontières de résolution ;Annie V668 conservée. 385sources natives relues,184Lua/184INIBIN,20mentions d’effets et14Troy candidats. Sonde exacte Provider/SearchProvider :481requêtes,142résolues et339sans résultat dans le profil courant,504liens parchampion. Ne pas convertir ces nombres en assets manquants. Akali :2effets et attachesL_hand/R_hand présents ;rendu/conditions/skins encore ouverts. Six mentions AnnieBasicAttack_mis et une SpiralBlade_tar sans candidat dans le scan ;indicateurs désactivés/inapplicabilité possibles,ne pas reconstruire arbitrairement. Renekton BloodSlash a2candidats natifs ;le profil courant résoutShared,prioritéhistorique/skinouverte. Azir CyberEzreal etSion ZiggsSnowday restent métadonnées nonqualifiées. HUDpassifEzreal séparé desVFXR. Revue670 :99365sources/5605consommateurs,5605ancres/SHA exacts.122VFX dépassent le seul loader de définition sans renderer accepté. Suite :examiner les fiches PASSIF-PRESENTATION-AUDIO de revision669_passive_vfx_delivery/NEXT_PASSIVE_AUDIO_QUEUE.json ;identifier événements/banques/variantes et consommateurs réels,preuves audio distinctes. Stockage V669 :baseline6archives liées à V668,immuables ;candidate/PATCH.json.gz reconstruit les6documents exactement,3falsifications refusées. Sauvegarde logique ciblée DATABASES_BEFORE.json et inversion vérifiée sur copie ;pas de nouvelle grosse archiveSQLiteF. CopiesSQLiteC supprimées après audit. Préserver tousanciens reçus/bases/cases/notes ;goal actif.
