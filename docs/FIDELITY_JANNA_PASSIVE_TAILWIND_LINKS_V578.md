# SYS-01.2-02 — Janna : Tailwind, V578

Date UTC : 2026-10-26T02:17:00.605653+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat intégré

CH-Janna-PASSIF-SOURCE, CH-Janna-PASSIF-SIMULATION-CONTRAT et CH-Janna-PASSIF-SIMULATION reçoivent 39 associations vers 13 ressources natives aux rôles distincts et 44 liens vers 22 points du code actuel. SYS-01.2-02 référence ce lot. Trois inconnues propres, quatre dépendances, critères et statuts conservés. Les prérequis des phases et lots sont consultés, sans acceptation implicite du gameplay.

**Les vitesses et déplacements mesurés ne montrent aucun bonus Tailwind dans les chemins actuels.** Les bottes et le Soin produisent leurs effets de contrôle distincts. Les consommateurs restent `entry_boundary_only`, `provides_feature_consumer=false`. Aucun gameplay ni asset modifié.

## Sources et limites

| Ressource | Identifiant |
|---|---|
| Janna.inibin | OLS-725c4ad7-7c45-59a3-b76f-bcb536e09ed7 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptJanna.luaobj | OLS-0250a997-2e51-58a9-907e-d00020a554ac |
| CharScriptJanna.preload | OLS-7a08fdfb-9087-5ca8-ba2e-8639dc2860be |
| Tailwind.inibin | OLS-513bb595-32f2-57ec-9244-5b24e38f65f2 |
| Tailwind.luaobj | OLS-7a187359-9cb6-5aee-b538-6324a6b5a09d |
| TailwindSelf.inibin | OLS-3180b89a-3bd4-54e6-830f-d531a44c5a07 |
| TailwindSelf.luaobj | OLS-7c87240c-f249-5a8a-9fab-4011f5c159d3 |
| SowTheWind.inibin | OLS-bd530e39-df77-5e7b-95da-7e7008d58593 |
| SowTheWind.luaobj | OLS-c7a101f1-a3b0-58bb-bea4-89b3c96013b9 |
| SowTheWind.preload | OLS-a7bb66f4-a545-575b-aafa-925eb7c6cb3f |
| Zephyr.inibin | OLS-95764081-1965-5ed0-966c-26f1854fc374 |
| Janna.ddf | OLS-1b30db7f-4e76-5473-9370-bfbc42b80912 |

Les 13 ressources sont vérifiées par taille/SHA256 contre le registre et taille/MD5 contre les manifestes RADS sélectionnés. L’ordre effectif de montage historique reste distinct. Les rôles, notamment le contexte W, sont explicites dans `native_metadata.source_roles`.

Le personnage désigne TailwindSelf ; son icône et celles des deux buffs concordent sur Janna_Tailwind.dds. Les bindings en_GB résolus sont : Tailwind ligne 2745, +5 % de vitesse ; TailwindSelf ligne 2746, Janna et ses champions alliés proches gagnent +5 % ; Zephyr ligne 2997, bonus personnel de vitesse et passage à travers les unités, lié au W.

La description du personnage ligne 4203 dit **tous les champions alliés**, tandis que TailwindSelf précise **les alliés proches et Janna**. Les textes sont conservés séparément. Le chiffre 5 % est attesté ; la portée, les cibles et la politique effectivement appliquée historiquement restent à qualifier. Aucune portée globale ou locale n’est choisie automatiquement.

Quatre chunks Lua sont entièrement lus, sans prototype enfant ; trois initialisations littérales sont reconnues. CharScriptJanna a des globals vides. TailwindSelf déclare PersistsThroughDeath=true et NonDispellable=true. Tailwind ne contient pas ces champs : absence non convertie en false. Ces métadonnées ne démontrent ni transmission du bonus ni cycle de vie effectif.

Le lecteur littéral rencontre NEWTABLE au pc18 dans SowTheWind.luaobj : limite de lecture des initialisations, pas corruption démontrée. Aucun callback serveur historique exécuté. Les deux preloads sont conservés ; celui du personnage référence Tailwind/TailwindSelf, SowTheWind, ForecastJannaVO et des scripts de taunts. Un preload ne qualifie pas le rendu ou le déclenchement du gameplay.

SowTheWind, Zephyr et les quatre entrées du DDF sont un contexte W distinct de l’aura. Les coefficients DDF liés aux dégâts magiques/puissance du W ne remplacent pas le pourcentage du passif. Les champs Passive1Level1..4 portent littéralement la chaîne zéro, tandis que 5 et 6 sont absents ; ces zéros ne signifient pas un bonus Tailwind nul. L’ancienne chaîne « 5 Astral Spirts » reste conservée sans adoption.

Dix références communautaires sont séparées des sources natives. CharScriptJanna.cs est vide ; les autres scripts et JSON ne constituent pas une exécution du serveur original.

## Vitesses et déplacements réellement observés

Quatre simulations Map10 utilisent Janna bleue, Annie rouge comme contrôle éloigné et Ahri bleue comme alliée. Janna atteint une position centrale par Move/Stop avant l’arrivée d’Ahri. Ahri achète éventuellement les bottes 1001 au départ, puis rejoint une position à 250 unités. Le second contrôle éventuel est un Soin public d’Ahri, sans destinataire allié automatique ; Janna conserve son état de vitesse sans Soin.

| Cas | Distance proche / éloignée | Vitesse proche | Après expiration | Vitesse éloignée | Refus |
|---|---|---:|---:|---:|---:|
| janna_ally_bootsfalse_healfalse | 250.000000 / 1249.999512 | 330.000000 | 330.000000 | 330.000000 | 17 |
| janna_ally_bootstrue_healfalse | 250.000000 / 1249.999512 | 355.000000 | 355.000000 | 355.000000 | 17 |
| janna_ally_bootsfalse_healtrue | 250.000000 / 1249.999512 | 426.200012 | 330.000000 | 330.000000 | 18 |
| janna_ally_bootstrue_healtrue | 250.000000 / 1249.999512 | 452.200012 | 355.000000 | 355.000000 | 18 |

Sans Soin, Ahri reste à 330, ou 355 avec les bottes, aussi bien à 250 qu’à environ 1 250 unités. Janna et Annie restent à 335 dans tous les échantillons. Le Soin donne temporairement environ 426,2 ou 452,2 à Ahri selon l’équipement, puis retour exact au régime de base au tick 30. Le bonus de vitesse de Soin est distinct de Tailwind.

Chaque phase proche/éloignée comprend 30 ticks. Les cinq premiers exécutent un déplacement public ; Stop immobilise ensuite l’alliée. Au total : 240 ticks observés et 40 pas réellement mesurés. La distance parcourue par pas correspond à la vitesse courante divisée par 30, avec un résidu inférieur à 0,005 unité ; après Stop, le déplacement est nul. Les vitesses observées correspondent aux valeurs de contrôle à moins de 0,001. Les positions sont restaurées uniquement par de nouvelles commandes Move/Stop avant la phase éloignée.

Ces distances de test **ne définissent pas la portée native**. Elles démontrent le comportement courant, complété par l’inspection du calcul de vitesse qui ne contient pas de contribution Tailwind. Elles ne prouvent pas une aura native de valeur zéro.

Aucune injection de position, santé, niveau, rang, XP ou effet ; aucun événement artificiel de dégâts, aucun PNJ supprimé. Aucun sort W de Janna ni passage à travers les unités n’est exercé. Les 70 refus atomiques incluent les 60 refus Janna — joueur inconnu, attaque de soi, slot invalide et Learn/Cast/CastAt pour quatre capacités —, huit cibles Soin invalides et deux relances de Soin en cooldown. Snapshots inchangés après refus.

## Consommateurs et portée des contrôles

Les liens couvrent initialisation, commandes, statistiques, rangs et refus Janna, calcul de vitesse, plafonds, bonus d’objets, achat, Soin, occupation alliée, mouvement, snapshot et cycle de vie statique. La fonction de vitesse applique base/objets puis les modificateurs courants, ralentissements et plafonds ; aucun calcul d’aura alliée Tailwind n’est présent dans les chemins inspectés.

Les règles de plafonds restent une reconstruction locale non qualifiée historiquement. Le contrôle Soin conserve ses propres limites, notamment le conflit de cooldown 240/300 secondes. Ces règles ne sont pas adoptées comme contrat natif de cumul ou d’arrondi de Tailwind. Les snapshots ne sont pas une preuve de transport réseau.

## Identité et livraison

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-janna-passive-tailwind-probe.exe`. Taille : 6031872 octets. SHA256 : `71373f316991eec8cc40245a8bd8bdccda96b5a8ce549b87f8523ef62cac7d3b`.

BUILD/RUN code 0, openleague_core courant non-test, verrou privé aligné sur les identités/checksums du verrou racine. Les 1 158 entrées core/ressources et la chaîne antérieure sont inchangées. Les preuves Irelia V577, son inspection initiale et sa préparation échouées sont explicitement conservées par identité, ainsi que les essais antérieurs de Heimerdinger. Aucun client ou serveur historique exécuté.

Discovery, inspection, prepare, check, publish et audit : code 0 pour ce lot. Les contrôles refusent 72 associations invalides et quatre graphes invalides. Trois fragments enrichis, 42 212 autres inchangés. Lecteurs réels Store.task/copy_text/summary/dépendances et résolution de trace vérifiés dans les deux bases SQLite. Dans chacune : quatre destinataires enrichis, 42 603 autres lignes, 42 607 états manuels et 23 historiques conservés ; intégrité et synchronisation idempotente vérifiées. Identifiants, hiérarchie et registre des inconnues identiques en octets.

Revue globale fraîche : 42 215 exigences, 98 989 sources, 3 502 consommateurs ; 3 502 ancres exactes, aucune divergence courante. Les 26 189 inconnues ouvertes et 5 517 résolues restent inchangées. Cette revue structurelle ne re-hashe pas toutes les sources et ne mesure pas le pourcentage de jeu terminé.

## Travail restant

- Établir la politique effective globale ou locale, la portée et l’auto-application.
- Qualifier cibles, sources multiples, cumul, base du pourcentage, ralentissements, plafonds et arrondis.
- Intégrer l’aura au calcul de vitesse et aux déplacements, puis vérifier entrée/sortie de portée, achats/ventes et effets temporaires.
- Vérifier niveaux, mort/réapparition, dispel, perte de source et fin de partie.
- Traiter séparément les fonctions W de vitesse personnelle et de passage à travers les unités.
- Qualifier séparément HUD, réseau, icônes affichées, animations, VFX et audio.
- Conserver les anomalies antérieures de déplacement, dont V564 ; ce lot ne les corrige pas.

## Fichiers et reprise

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/janna-passive-tailwind-links-v578.json. Preuve : docs/fidelity_janna_passive_tailwind_links_v578.json. Couverture, plan, checkpoint, CURRENT, HANDOFF et deux bases actualisés avec sauvegardes. Scripts/journaux sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20, préfixe revision578. Aucun statut, case ou inconnu fermé automatiquement.

Continuer SYS-01.2-02 depuis revision579_trace_review/REVIEW.json. JannaV578 publiée/auditée :3fiches,13natives,39associations,22points/44liens limités. Quatre cas publics de vitesse :70refus,240ticks,40pas mesurés;Ahri330/355près250etloin1250,Soin426.2/452.2puis retourtick30,Janna335. Texte5%mais tous alliés versus proches+Janna nonrésolu;portée,cumuls,arrondis et lifecycle ouverts. W/SowTheWind/Zephyr distinct;NEWTABLEpc18limitelecteur,zéros/AstralSpirtsnonadoptés. Préserver INPUTS_BEFORE.previous_artifacts V578 incluant Irelia577 et ses échecs documentaires. Aucun statut/case/inconnu fermé. Poursuivre un autre passif après inspection réelle,par exemple JarvanIV. Défaut déplacementV564 ouvert;goal actif.
