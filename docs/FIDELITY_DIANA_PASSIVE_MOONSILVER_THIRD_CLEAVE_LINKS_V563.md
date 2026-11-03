# SYS-01.2-02 — Diana : Moonsilver et limites de déplacement, V563

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et date de déploiement inconnus. Catalogue officiel 4.20.1 distinct.

**Résultat : sources et consommateurs reliés, sans qualification du passif. Les attaques observées n’ajoutent pas le bonus du troisième coup. Trois essais de déplacement depuis le côté bleu ont échoué avant le combat ; cette limite reste ouverte. Aucun gameplay ni asset modifié.**

## Intégration réelle

CH-Diana-PASSIF-SOURCE, CH-Diana-PASSIF-SIMULATION-CONTRAT et CH-Diana-PASSIF-SIMULATION reçoivent 39 associations vers 13 sources natives. Les deux fiches de simulation reçoivent 48 liens vers 24 points de code, entry_boundary_only et provides_feature_consumer=false pour le passif. SYS-01.2-02 référence le lot. Les prérequis de phase/lot sont relevés, trois questions propres et quatre dépendances conservées.

## Sources

| Fichier natif | Identifiant |
|---|---|
| Diana.inibin | OLS-5e55ca54-734f-57c5-80e8-ccf311780616 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptDiana.luaobj | OLS-e14aaa77-87e6-520d-aa0a-0c76aed8e861 |
| CharScriptDiana.preload | OLS-2b6785f6-7f11-5ae1-a337-a5fdf981a06b |
| DianaPassive.inibin | OLS-31f8f0ba-0783-5d4c-8875-9db58682a1e0 |
| DianaPassive.luaobj | OLS-74227958-7665-5875-a931-f6afdb357533 |
| DianaPassive.preload | OLS-5aa097a6-8048-5437-aa88-44db1d39d4e4 |
| DianaPassiveDeathRecap.inibin | OLS-e5e8bb42-158d-52e6-8235-cffe5151765f |
| DianaPassiveDeathRecap.luaobj | OLS-ec4cbc4e-a782-5a16-949b-d64dd20aa883 |
| DianaCombatBuff.luaobj | OLS-004d1b3b-fd0a-56b1-85a7-d7b626a7a75d |
| DianaBasicAttack.inibin | OLS-6cd732cd-5732-579a-a7ef-1cd261dc770f |
| DianaBasicAttack2.inibin | OLS-136252b4-8532-5fce-8242-3c284ca46f9e |
| DianaBasicAttack3.inibin | OLS-3b08fe3a-7d8e-54cb-bf3d-0a5e3c2d539e |

Tailles/SHA256 conformes au registre et sources revérifiées ; tailles/MD5 conformes aux projets RADS sélectionnés lors de la découverte. Cette appartenance ne prouve pas la priorité historique de chargement.

Le texte natif 1838 déclare un bonus de vitesse d’attaque f3 et, tous les trois coups, des dégâts magiques supplémentaires f1/f2 sur les ennemis proches. Le producteur de ces variables et la géométrie exacte ne sont pas qualifiés. Diana.inibin lie DianaPassive et Diana_Passive_LunarBlade.dds ; niveaux 1/4/7 présents sans adoption comme progression, niveaux suivants absents. Passive1 et Passive1Desc sont absents.

Deux fichiers INIBIN lient le même tooltip. Quatre Lua sont entièrement parsés et littéraux sans prototypes enfants. CharScriptDiana et DianaCombatBuff ont des globals vides. DianaPassive et DianaPassiveDeathRecap ont les mêmes octets Lua et exposent BuffName, icône et PersistsThroughDeath ; cela ne démontre ni dispatch de récapitulatif, ni persistance réelle.

Deux preloads et les trois ressources BasicAttack sont conservés comme déclarations. Les sept références communautaires ne sont pas du code serveur natif. Leur CharScript contient OnActivate/OnUpdate et du code de posture/animation : il ne doit être présenté ni comme vide, ni comme une implémentation du passif.

## Exécutions et échecs conservés

Trois tentatives initiales depuis le côté bleu ont été compilées avec code 0 puis ont échoué avec code 101 avant les mesures de combat :

1. Déplacement direct de Diana et des deux cibles : assertion d’arrivée non satisfaite.
2. Seconde cible plus espacée : les deux Garen arrivent, Diana s’arrête à (3305.1125, 4214.1094), sans destination, à 2400 ticks ; les deux cibles restent invisibles depuis sa position.
3. Trajet par points de passage : premier waypoint demandé (4500,7000), ramené à (4534.9819,6984.2402) ; Diana s’arrête à (3308.3494,5057.6084), sans destination, à 1800 ticks.

Les binaires, sources privées, verrous et journaux restent immuables. La branche de mouvement peut annuler un chemin sur refus de terrain ; la cause précise de ces occurrences n’est pas encore mesurée. Un rayon de navigation de 35 pour Diana et 25.7666 pour Darius est présent dans les ressources, mais cette différence ne suffit pas à démontrer la cause. Aucun défaut d’asset ou de carte n’est déduit de ces seuls résultats.

Les essais de combat suivants font entrer Diana en équipe 1, deux Darius en équipe 0 et un Garen allié resté à sa base. Ils utilisent les spawns ordinaires et exclusivement les commandes publiques Move, Buy, Attack et Stop. Aucun PV, mana, or, XP, dégât, position ou effet injecté. Aucun décès, niveau gagné ou match terminé.

Un premier ensemble de trois cas réussit avec la seconde cible à 273.589 unités de Diana ; un second ensemble resserre la position à 141.421 unités de Diana et 144.141 de la cible principale. Les deux ensembles sont conservés ; le second est le reçu runtime principal. Ce changement de côté et de cible isole le combat, sans résoudre le problème de déplacement bleu.

Une première inspection a échoué parce qu’un script généré obsolète visait le dossier runtime initial sans OBSERVATIONS. Elle n’a pas modifié le registre. Le script est conservé ; l’inspection verified utilise les preuves réellement disponibles. Aucune de ces étapes échouées n’est comptée comme validation réussie.

## Cas de combat retenus

| Cas | Puissance | Intervalle observé en ticks | Impacts | Dégâts sur cible secondaire |
|---|---:|---:|---:|---:|
| base | 0 | 48 | 6 | 0 |
| amplifying_tome | 20 | 48 | 6 | 0 |
| dagger | 0 | 42 | 6 | 0 |

Tome 1052 acheté pour 435 or : +20 AP. Dague 1042 achetée pour 450 or : +15% vitesse d’attaque ordinaire, intervalle de 48 à 42 ticks. Ces contrôles ne prouvent pas le bonus propre à Moonsilver.

Attendu : distinguer les attaques physiques ordinaires du supplément magique au troisième coup, le compteur, le bonus de vitesse et le dégât collatéral. Observé : les 18 coups correspondent à 53.040001 AD contre 29.879999 armure, après compensation de régénération plafonnée aux PV maximum ; résidu maximal 0.0000114441. Le troisième et le sixième coup restent physiques ordinaires. Les 18 coups de l’ensemble précédent donnent le même constat, conservé séparément.

Ticks du reçu principal : 845/893/941/989/1037/1085 sans objet ou avec Tome ; 844/886/928/970/1012/1054 avec Dague. Tous les windups retenus sont non critiques. Aucun dégât sur la cible secondaire dans chacune des deux géométries. Cela ne qualifie pas tout un cône, rayon, angle, bord, obstacle ou type de cible.

48 refus atomiques par ensemble réussi : joueur inconnu, cible inconnue, cible propre, allié, puis douze Learn/Cast/CastAt sur quatre slots, avec snapshot inchangé. Aucun déclenchement par sort n’est déduit de ces refus.

## Consommateurs et travail restant

Les points de code relient initialisation, statistiques/AP/cadence, commandes et refus, attaques/impact physique, dégâts et mitigation, windup et critique, tick, régénération, achats, cibles, carte, sorts temporisés, mouvement allié et recherche de point praticable. Aucun rôle global existant n’est rétrogradé ; leur portée pour Diana reste limitée.

- Qualifier les producteurs f1/f2/f3, compteur, cadence, règles de cumul/expiration/réinitialisation et moment d’échantillonnage de l’AP.
- Vérifier géométrie, orientation, multi-cibles, sbires, monstres, structures, critique, effets à impact, boucliers, annulation, mort et persistance.
- Expliquer les trois échecs de déplacement bleu et les rattacher aux exigences existantes ; le succès depuis le côté opposé ne les clôt pas.
- Qualifier HUD, animation du troisième coup, particules, audio et réseau séparément. Aucun serveur historique, VM Lua complète, GUI, GPU ou réseau exécuté ici.

## Contrôles et conservation

Les deux ensembles de combat réussis ont build/run 0 ; les trois premiers ont build 0/run 101. Inspection corrigée, préparation, contrôle du candidat, publication et audit ont terminé avec code 0. Binaire principal `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-diana-passive-moonsilver-third-cleave-nearby-probe.exe`, 6041088 octets, SHA256 `c8865aaac145fb46a1ab78a81fd6fabcf1660a38b557b8cf4f76e140e2d22a85`. Reçu `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision563_Diana_passive_probe_nearby\OBSERVATIONS.json`. Les 1158 entrées de code/ressources, verrous et anciens artefacts sont exacts. Core non-test en cache, suite historique complète non relancée.

72 associations invalides et quatre graphes invalides refusés, dont assimilation du bonus de Dague au passif, du code communautaire d’animation au serveur natif ou du succès côté opposé à la résolution du déplacement bleu.

Chaque base SQLite conserve exactement 42603 autres lignes de catalogue, 42607 états manuels et 23 événements historiques ; quatre destinataires sont vérifiés. Store.task, copie des instructions, résumé, dépendances, références, intégrité et synchronisation idempotente contrôlés. Trois fragments de trace changés, 42212 inchangés. Identifiants, hiérarchie et inconnues identiques en octets.

Graphe : 42215 exigences, 98928 sources, 3181 consommateurs ; 3181 ancres exactes, zéro divergence. Questions ouvertes 26189 et résolues 5517 inchangées. Pas de recensement physique complet de toutes les sources. Les 8312 fiches CH à chargeur partagé seulement restent une file de recherche, pas un pourcentage d’achèvement.

## Fichiers et suite

Registres completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json enrichis ; reçu docs/reference_requirement_trace_sources/diana-passive-moonsilver-third-cleave-links-v563.json ; preuve docs/fidelity_diana_passive_moonsilver_third_cleave_links_v563.json. Couverture, plan, checkpoint, CURRENT et HANDOFF sauvegardés puis complétés. Aucun stage/reset/commit. Aucun passif, champion ou jeu déclaré terminé.

Continuer SYS-01.2-02 depuis revision564_trace_review/REVIEW.json. Diana V563 est publiée/auditée : 13 sources,39 associations,24 points/48 liens,3 fiches ; aucun passif accepté. Runtime retenu revision563_Diana_passive_probe_nearby,plus comparaison opposite.18 impacts et48refus dans chaque géométrie ; troisième/sixième coups physiques seulement,second ennemi sans dégâts à141.421 puis273.589 unités ; AP0/20/0,cadence48/48/42. Trois essais blue-side initial/qualified/routed ont build0/run101 avant combat ; positions Diana3305.1125/4214.1094 et3308.3494/5057.6084,autres joueurs arrivés. Le succès équipe1 contre deux Darius ne résout pas ces échecs de déplacement. Ancienne inspection échouée conservée,verified réussie. Au prochain probe, utiliser nearby/OBSERVATIONS et ajouter ses INPUTS_BEFORE.previous_artifacts pour conserver les trois échecs et opposite ;ne pas chercher OBSERVATIONS dans les dossiers échoués. Sources client4Lua littéraux sans callbacks,2bindings identiques,2preloads,7communautaires. Niveaux1/4/7 non adoptés,code communautaire posture/animation distinct du passif. Continuer en reliant les échecs blue-side aux exigences de déplacement déjà existantes et aux routes command/ally_occupancy/prefix/navigation : identifier précisément le refus de terrain et ses sources avant correction hors périmètre. Ne pas affirmer un défaut de rayon ou de map sans mesure. Puis reprendre la file restante des exigences de champions depuis la revue. Aucun statut/case/inconnue fermé. Goal actif. Les fiches CH-Diana-MOUVEMENT-RAYON/CHEMIN/BLOCAGE existent et restent a_faire ;le parent CH-Diana-MOUVEMENT reste partiel_a_requalifier. Conserver leurs liens V519/V523/V524 et leurs zéro inconnues actuelles ;ne pas annoncer une implémentation absente sans relire ces consommateurs. Le prefix de ally_occupancy.rs appelle pillar_navigation::segment_allowed avant TerrainBlocked :capturer le premier tick de destination annulée et le segment réel,comparer Diana/Garen/Darius et les vitesses avant de conclure.
