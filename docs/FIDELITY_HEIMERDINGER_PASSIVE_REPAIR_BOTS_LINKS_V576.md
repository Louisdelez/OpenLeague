# SYS-01.2-02 — Heimerdinger : Techmaturgical Repair Bots, V576

Date UTC : 2026-10-26T01:39:12.194758+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat intégré

Les trois fiches CH-Heimerdinger-PASSIF-SOURCE, CH-Heimerdinger-PASSIF-SIMULATION-CONTRAT et CH-Heimerdinger-PASSIF-SIMULATION reçoivent 30 associations vers 10 ressources natives et 44 liens vers 22 points de code actuels. SYS-01.2-02 référence le lot. Les trois inconnues propres, quatre dépendances, critères et statuts restent conservés. Les prérequis des phases et lots ont été consultés ; ils ne deviennent pas satisfaits pour le gameplay.

**Les cas exécutés ne montrent que la régénération de base et son bonus d’objet. Le passif Heimerdinger reste à qualifier et intégrer.** Les consommateurs sont des limites de l’implémentation actuelle (`entry_boundary_only`, `provides_feature_consumer=false`). Aucun gameplay ou asset modifié.

## Sources, provenance et limites

| Ressource | Identifiant |
|---|---|
| Heimerdinger.inibin | OLS-2aab7108-d777-5bd8-a50e-242fd1909004 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptHeimerdinger.luaobj | OLS-8b1e02b6-5256-5114-b62f-35e7e3917b0d |
| CharScriptHeimerdinger.preload | OLS-24e6cf19-21d2-5d89-84d6-f5672ae85872 |
| HeimerdingerPassive.inibin | OLS-7e5e18dc-a5ef-54ed-80f8-30590f446b31 |
| HeimerdingerPassive.luaobj | OLS-f8183500-9ec6-551e-9503-d2ca9cf40a0e |
| HeimerdingerPassive.preload | OLS-109e466d-87ba-5552-a7d3-11c2b5bfd0dc |
| TechmaturgicalRepairBots.inibin | OLS-5b8ebf19-12b2-542d-83dc-e1a7f0789163 |
| TechmaturgicalRepairBots.luaobj | OLS-1d00d984-5320-5d92-bb33-cd555f059840 |
| Heimerdinger.ddf | OLS-e459111d-84d3-5458-a185-1937afbff57e |

Chaque source est vérifiée par taille/SHA256 contre le registre et par taille/MD5 contre le manifeste RADS sélectionné. Cela ne prouve pas l’ordre effectif de montage historique. Les dix rôles sont décrits dans `native_metadata.source_roles`.

Le personnage référence HeimerdingerPassive et Heimerdinger_Passive.dds. CharScriptHeimerdinger.preload référence le passif ; HeimerdingerPassive.preload référence TechmaturgicalRepairBots. Les bindings en_GB sont résolus exactement : ligne 1992, aura de régénération pour champions alliés proches et tourelles H-28G, paramètre f1 en PV par cinq secondes ; ligne 2756, buff reçu qui augmente la régénération. La description ligne 4200 confirme ces catégories.

Les trois chunks Lua sont entièrement lus, sans prototype enfant, avec initialisations littérales reconnues. CharScriptHeimerdinger a des globals vides ; les deux buffs livrent identité et icône. Le buff source déclare PersistsThroughDeath=true. Le buff reçu ne possède pas ce champ : son absence n’est pas transformée en false ni en politique de cycle de vie. Aucune exécution de callbacks du serveur historique.

Les champs de niveaux du passif recherchés sont absents. Le DDF contient 16 entrées Q/W/E/R, sans passif ni TechmaturgicalRepairBots ; il ne fournit pas le producteur f1. Les textes HeimerdingerQ/Nano Repair Bots sont conservés séparément, sans les substituer au binding du personnage. Cette recherche ne prouve pas l’absence de la formule dans toutes les sources possibles.

Huit références communautaires sont conservées séparément. CharScriptHeimerdinger.cs est vide. Les scripts actifs et les JSON ne sont pas une preuve d’exécution du serveur Riot. La présence des icônes et leurs noms ne démontre pas un rendu, mais aucun manque de texture n’est déduit de ce diagnostic de gameplay.

## Diagnostic public du moteur actuel

Deux simulations Map10 utilisent Heimerdinger bleu, Annie rouge et Ahri bleue. Les déplacements Move/Stop positionnent les trois personnages ; cinq attaques ordinaires d’Annie blessent Ahri. Le second cas achète publiquement l’objet 1006 avant déplacement. Aucune injection de position, santé, dégâts, rang ou XP ; aucun PNJ supprimé.

| Cas | Régénération alliée, PV/s | Distance proche / éloignée | Impacts | Refus | Suivi, ticks |
|---|---:|---|---:|---:|---:|
| heimerdinger_ally_base | 1.301600 | 250.000000 / 1250.999634 | 5 | 15 | 600 |
| heimerdinger_ally_bead1006 | 1.952400 | 250.000000 / 1250.999634 | 5 | 15 | 600 |

Attendu pour la voie générique actuelle : régénération de base Ahri 1,3016 PV/s ; l’objet 1006 applique +50 %, soit 1,9524. Observé : ces taux expliquent les variations de santé à 250 unités puis à environ 1 251 unités. Chaque phase dure 300 ticks et contient des mesures hors saturation de santé. Total : 1 200 ticks de suivi, plus 186 ticks pendant le déplacement entre les deux positions ; résidus inférieurs à 0,002 PV. Les mêmes taux demeurent pendant le déplacement.

Les dix impacts sont reliés à un projectile du snapshot précédent, de la bonne source et vers la bonne cible, sans critique. Le dommage attendu est `brut × 100 / (100 + armure)` ; la comparaison tient compte de la régénération du tick. Résidu inférieur à 0,002.

Les 30 refus atomiques couvrent joueur inconnu, attaque de soi, slot invalide et Learn/Cast/CastAt pour les quatre capacités, dans les deux cas. Le snapshot reste inchangé après chacun. Les sorts Heimerdinger sont explicitement non pris en charge dans ces chemins.

La portée native est inconnue : **250 unités ne signifie pas “dans la portée historique”, et 1 251 ne définit pas sa frontière**. Ces cas démontrent les voies génériques présentes, sans qualifier une valeur d’aura nulle. L’inspection du calcul de régénération montre base/croissance/objets, traitement distinct de Garen et multiplicateur de soin reçu ; aucun calcul spécifique Repair Bots dans les chemins liés.

Les fonctions existantes de création, commandes et aura de Tibbers sont seulement inspectées comme infrastructure actuelle de familier ; elles ne sont ni une tourelle H-28G ni une aura de réparation. Création des tourelles, auto-application, catégories alliées, empilement, changements de niveau, mort/réapparition, rendu et réseau ne sont pas exercés.

## Essais échoués conservés

- `revision576_Heimerdinger_passive_probe` : BUILD 0, RUN 101, assertion d’arrivée initiale. Aucun reçu OBSERVATIONS de réussite.
- `revision576_Heimerdinger_observer` : BUILD 0, RUN 101. Le journal révèle que les destinations demandées pour Heimerdinger et Ahri se projettent toutes deux sur x=7534,981934 / z=6934,240234. Leur arrivée simultanée au même centre occupé n’est pas un prérequis valide du test d’aura.
- `revision576_Heimerdinger_separated` : BUILD 0, RUN 101. Après séparation des destinations, le comparateur Hecarim n’achève pas le déplacement d’Ahri, restée près du départ ; la cause exacte de ce blocage reste ouverte. Les cas Heimerdinger précédents de ce processus ne sont pas utilisés comme reçu réussi.

La variante `revision576_Heimerdinger_qualified` réexécute uniquement les deux cas Heimerdinger avec destinations distinctes. BUILD et RUN retournent réellement 0. Le comparateur Hecarim reste non qualifié et n’est pas remplacé par une réussite inventée. Tous les scripts, trois exécutables échoués, logs et reçus sont conservés par identité dans INPUTS_BEFORE.previous_artifacts. Aucun correctif de navigation n’est prétendu ; le défaut V564 reste ouvert.

## Identité, livraison et conservation

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-heimer-passive-repair-bots-qualified.exe`. Taille : 6043648 octets. SHA256 : `cc9ce770ae29e10c909d612489e306d65a876d1156f49e8a6317902773990e8f`.

Le diagnostic utilise openleague_core courant non-test, avec verrou privé aligné sur les identités et checksums du verrou racine. Les 1 158 entrées core/ressources et toute la chaîne de preuves précédente, dont Hecarim V575 et les anciens échecs, sont conservées. Aucun client ou serveur historique exécuté.

Discovery, inspection, prepare, check, publish et audit : code 0. Les contrôles refusent 72 associations invalides et quatre graphes invalides. Trois fragments enrichis, 42 212 autres inchangés. Lecteurs réels Store.task/copy_text/summary/dépendances et résolution de trace vérifiés. Dans chacune des deux bases SQLite : quatre destinataires enrichis, 42 603 autres lignes, 42 607 états manuels et 23 événements historiques conservés. Intégrité et synchronisation normale idempotente réussies. Identifiants, hiérarchie et registre des inconnues identiques en octets.

Revue globale fraîche : 42 215 exigences, 98 980 sources, 3 453 consommateurs ; 3 453 ancres exactes, aucune divergence courante. Les 26 189 inconnues ouvertes et 5 517 résolues restent inchangées. Cette revue structurelle ne re-hashe pas les 98 980 sources et ne mesure pas le pourcentage du jeu terminé.

## Travail restant

- Trouver et qualifier f1, son évolution, son unité et ses arrondis.
- Établir portée, cibles exactes, auto-application, cadence, empilement et disparition du buff reçu.
- Intégrer l’aura aux voies de régénération, puis vérifier entrée/sortie de portée et plusieurs sources.
- Intégrer et tester les tourelles H-28G sans adopter Tibbers comme équivalent.
- Vérifier niveaux, objets, modificateurs de soins, mort/réapparition et fin de partie.
- Qualifier séparément HUD, réseau, icône affichée, animations, VFX et audio.
- Conserver et traiter séparément les diagnostics de déplacement non résolus.

## Fichiers et reprise

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/heimer-passive-repair_bots-links-v576.json. Preuve : docs/fidelity_heimer_passive_repair_bots_links_v576.json. Couverture, plan, checkpoint, CURRENT, HANDOFF et deux bases actualisés avec sauvegardes. Scripts et reçus sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20, préfixe revision576. Aucun statut, case ou inconnu fermé automatiquement.

Continuer SYS-01.2-02 depuis revision577_trace_review/REVIEW.json. HeimerdingerV576 publiée/auditée :3fiches,10ressources,30associations,22points/44liens limités. Deux cas publics alliés :10impacts,30refus,1200ticks et186ticks de déplacement;Ahri1.3016PV/s ou1.9524avec1006 à250et1251unités. f1,portée,cibles H-28G,cumuls et lifecycle ouverts;pas de qualification gameplay. Trois diagnostics échoués conservés :destinations confondues après nearest_walkable puis comparateur Hecarim avec Ahri bloquée au départ. Préserver INPUTS_BEFORE.previous_artifacts V576 et tous ses exécutables/logs. Aucun statut/case/inconnu fermé. Poursuivre un autre passif après inspection réelle,par exemple Irelia. Défaut déplacementV564 ouvert;goal actif.
