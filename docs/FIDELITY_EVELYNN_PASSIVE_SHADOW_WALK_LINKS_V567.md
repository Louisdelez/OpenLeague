# SYS-01.2-02 — Evelynn : Shadow Walk, vision et mana, V567

Date UTC 2026-10-25T23:27:02.398146+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et date de déploiement inconnus ; catalogue officiel 4.20.1 distinct.

## Résultat intégré

Les trois fiches CH-Evelynn-PASSIF-SOURCE, CH-Evelynn-PASSIF-SIMULATION-CONTRAT et CH-Evelynn-PASSIF-SIMULATION disposent de 78 associations vers 26 sources natives. Les deux fiches de simulation relient 24 points de code, soit 48 liens. SYS-01.2-02 référence ce lot. Ces consommateurs sont explicitement limités aux entrées existantes : `entry_boundary_only`, `provides_feature_consumer=false` pour le passif d’Evelynn.

Le moteur actuel applique la vision partagée et la régénération générale. Le code inspecté ne contient pas de branche Evelynn dans la décision de visibilité ni dans la régénération ; l’apprentissage et le lancement de ses sorts sont refusés. Les essais ci-dessous établissent ce comportement actuel, sans le qualifier comme reproduction de Shadow Walk. Aucun code de gameplay ni asset modifié ; aucun statut de tâche ou case coché.

## Sources et recherches

| Ressource | Identifiant |
|---|---|
| Evelynn.inibin | OLS-f73ce3f1-640d-5f45-942e-5ed9a3cd2d26 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptEvelynn.luaobj | OLS-d507eed1-5d46-5b16-9967-3b3b4aa27467 |
| CharScriptEvelynn.preload | OLS-4349cf18-3fc1-5dab-be01-a773ea56a17e |
| EvelynnPassive.inibin | OLS-42ce78b9-6e25-5681-8b63-04d9fb627333 |
| EvelynnPassive.luaobj | OLS-1dd57e09-95cb-5fa5-b260-ca8e2be15e9b |
| EvelynnPassive.preload | OLS-b9ba1389-898e-5bda-bd1d-1a2d8390e2cc |
| EvelynnStealth.luaobj | OLS-86f194b5-d168-5313-afb4-0eaf97b097e9 |
| EvelynnStealth.preload | OLS-7558b4a3-4b6c-596a-97f5-848c5193c0f0 |
| EvelynnStealthMana.luaobj | OLS-ceee52a1-375d-5f87-9e8d-e77385d86b28 |
| EvelynnStealthMana.preload | OLS-55ce7562-489f-50bc-80f1-bc0d6b17720e |
| EvelynnStealthMarker.inibin | OLS-094aaf3e-5d41-5bf9-b73b-40f5a0dde67e |
| EvelynnStealthMarker.luaobj | OLS-f2de1e94-1217-5af8-ac64-1fc3a226490a |
| EvelynnStealthMarker.preload | OLS-db83d435-30f4-5d13-8f8e-98ac571bb112 |
| EvelynnStealthRing.luaobj | OLS-16747456-b0fc-5cbe-9500-ae3c6f27b35f |
| EvelynnStealthRing.preload | OLS-381a66e9-fe60-52bf-93a6-ab7010ce2932 |
| ShadowWalk.inibin | OLS-bf92d7b2-8bb2-5a66-80c8-aca1df86b7dd |
| ShadowWalk.luaobj | OLS-faacce66-4e31-5086-bda8-dd45768cd48a |
| ShadowWalk.preload | OLS-168323bf-9c60-5e00-839f-d70e81e52244 |
| ShadowWalkRestealthFadeout.luaobj | OLS-25e933a7-3c39-5158-9a91-8e619678ac68 |
| ShadowWalkRestealthFadeout.preload | OLS-4c737e1b-4334-5b31-a86c-050345c29e3b |
| ShadowWalkRevealedDebuff.inibin | OLS-f5a99623-49a0-5ce9-acb8-115a0c069121 |
| ShadowWalkRevealedDebuff.luaobj | OLS-3e8ca6fa-ce2b-517f-9502-004d4453511f |
| ShadowWalkRevealedDebuff.preload | OLS-01baabba-b13b-5ef9-9b6d-353753be5e8d |
| ShadowWalkRevealedWarning.luaobj | OLS-d0d50634-cef8-5c53-af3c-8df5f919041d |
| ShadowWalkRevealedWarning.preload | OLS-7ce1a043-ea18-5821-a60a-e0fd9bd891a0 |

Les 26 fichiers correspondent aux tailles/SHA256 enregistrés et aux tailles/MD5 des projets RADS sélectionnés. Cette appartenance ne prouve pas la priorité effective du chargeur historique. Les empreintes et détails figurent dans le reçu JSON et les observations de découverte.

Le dossier `DATA/Characters/Evelynn/Spells` n’existe pas dans cette extraction. Les scripts ont été retrouvés dans `DATA/Characters/Evelynn/Scripts` et les sorts dans `DATA/Spells`. Ce classement ne constitue donc pas un manque de ressources. La recherche des noms dans DATA a aussi identifié des icônes et particules ; leur présence n’est pas une qualification de leur rendu et ces fichiers ne sont pas promus dans les 26 sources de comportement.

`Evelynn.inibin` lie Passive1LuaName à EvelynnPassive, l’icône à Evelynn_ShadowWalk.dds et PassLev1Desc1 à game_character_passiveDescription_Evelynn. Les quatre liaisons de tooltip natives sont conservées séparément : EvelynnPassive, EvelynnStealthMarker, ShadowWalk et ShadowWalkRevealedDebuff.

Le tooltip en_GB ligne 1879 décrit une visibilité limitée aux champions ennemis proches ou à la vraie vision, une régénération de **1 % du mana maximum par seconde** pendant la furtivité, et une sortie de furtivité pendant **6 secondes** lors d’un lancement de sort, de dégâts reçus ou de dégâts infligés. La ligne 1882 décrit le marqueur de furtivité et la ligne 4183 la description du passif. Ces textes ne donnent pas ici le rayon exact, tous les cas d’exclusion, la cadence interne, ni la composition du taux avec les autres régénérations. Ne pas remplacer « mana maximum » par « mana manquant ».

Dix Lua sont lus entièrement : initialisations littérales reconnues, aucun prototype enfant. Dix preloads sont conservés. Le CharScript natif fournit ici des métadonnées vides, pas un callback serveur exécuté. EvelynnPassive déclare PersistsThroughDeath et Nondispellable ; cela ne qualifie pas le comportement effectif à la mort. ShadowWalk déclare notamment SpellToggleSlot=2 et CastTime=0.5, tandis que Spell2 du personnage désigne EvelynnW : aucune substitution automatique de cet ancien sort au passif actuel. Les icônes ReadyToBetray et noms de marqueurs sont conservés tels quels.

Dix références communautaires locales sont identifiées séparément. Le CharScript communautaire enregistre OnTakeDamage, mais le corps de SelfWasDamaged est vide. Cette inscription n’implémente donc pas, à elle seule, la machine de furtivité. Les Q/W/E/R et profils JSON communautaires ne deviennent pas une autorité native par leur seule présence.

## Essais exécutés sur le moteur actuel

Les trois simulations utilisent le vrai openleague_core non-test, la navigation de Map10 et les commandes publiques. Aucune mutation directe de position, santé, mana, or, XP, rang ou effet. Aucun client/serveur historique exécuté.

### Vision et projection par joueur

Deux simulations avec Evelynn bleue et Garen rouge. Aux bases initiales, Evelynn est absente de la projection ennemie et présente de sa propre projection. Cible inexistante, équipe invalide et observateur inexistant sont rejetés. Après déplacements publics et Stop, les deux personnages restent sans combat sur un segment de vision dégagé.

| Cas | Distance constatée | Ticks sans combat | Visible pour l’adversaire | Présente dans sa projection | Refus Learn/Cast/CastAt |
|---|---:|---:|---:|---:|---:|
| public_clear_sight_near | 250.0 | 360 | 360 | 360 | 12 |
| public_clear_sight_far | 899.99951171875 | 360 | 360 | 360 | 12 |

360 ticks correspondent à 12 secondes au taux courant de 30 Hz. Les relevés à 1,180,181 et360 ticks sont conservés. Les distances 250 et899.9995 sont des géométries d’essai, **pas des seuils natifs de détection établis**. La visibilité à environ900 ne suffit pas seule à conclure à une violation du rayon historique inconnu ; elle est confrontée à l’absence de machine de furtivité dans le chemin de visibilité inspecté. Les24 refus de commande sont atomiques : snapshot avant/après identique.

`Simulation::snapshot_for` et son filtrage des joueurs sont effectivement exécutés. L’appel de cette fonction dans le serveur courant est identifié dans main.rs ; le transport réseau n’est pas exécuté par ce test. Le snapshot omniscient sert seulement d’instrument de diagnostic. Aucun rendu de brouillard ou effet visuel n’est accepté à partir de cette projection.

### Régénération sans injection de mana

Une troisième simulation attend210 ticks à la base, puis achète publiquement le Cristal de saphir1027. L’achat conserve le mana courant265.6 et porte le maximum à465.6, créant un déficit par le chemin existant de boutique. Les sémantiques natives de modification des réserves lors d’un achat restent à qualifier.

Les20 ticks211 à230 se trouvent entre les impulsions de fontaine du moteur courant. Chaque incrément est égal au calcul de régénération de base en float32 ; aucune impulsion de fontaine n’est comptée comme passif. Le taux observé est1.62160003 mana/s, correspondant au champ natif **BaseStaticMPRegen** ; BaseMPRegen absent ne doit pas être pris pour une absence de taux natif. Avec ce maximum,1% représente4.65600014 mana/s. Cette comparaison indique que seul le chemin général est exercé : aucun état furtif n’a été injecté ou établi, aucune règle d’addition/remplacement des taux natifs n’est inventée.

## Vérification et conservation

Exécutable `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-evelynn-passive-shadow-walk-probe.exe` ; 6112768 octets ; SHA256 `f7aaacde45883b6a7b4c9340972c43139febabb432a9ad773269737b44ab3a9c`. Compilation et exécution : code0. Cargo.lock privé aligné avec les identités/checksums du verrou racine ;1158 fichiers core/ressources et la chaîne des preuves antérieures inchangés. Le runtime conserve V566 et sa chaîne V565/V564/V563, y compris les anciens échecs documentés.

Deux inspections ont réussi. La seconde corrige uniquement la mention de version V566 restée dans un sélecteur de la première ; première observation et script sont conservés et épinglés. Aucune observation native ni résultat de runtime remplacé.

Prepare/check/publish/audit : code0.72 associations invalides et4 graphes invalides refusés. Deux bases SQLite vérifiées par les lecteurs réels Store.task/copy_text/summary/dépendances et résolution de trace :4 destinataires,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques préservés. Synchronisation idempotente et intégrité vérifiées. Les identifiants, la hiérarchie et les inconnues restent identiques en octets ;3 fragments de trace modifiés,42212 conservés.

Revue du graphe courant :42215 exigences,98944 sources,3256 consommateurs ;3256 ancres exactes,zéro divergence constatée.26189 inconnues ouvertes et5517 résolues inchangées. Ce contrôle structurel ne vérifie pas physiquement l’ensemble des98944 sources et ne mesure pas un pourcentage de jeu terminé ; les empreintes des ressources sélectionnées sont contrôlées séparément.

## Manques et limites restant ouverts

- Règles serveur natives effectives : portée de proximité, vraie vision, sources de révélation et cas particuliers.
- Machine de furtivité : entrée, interruption, redémarrage du délai, états au lancement de sort, dégâts reçus/infligés, mort et réapparition.
- Régénération conditionnelle : activation, cadence, composition avec les autres taux, plafond et interactions avec le mana maximum.
- Intégration effective de ces comportements dans le moteur, apprentissage et sorts propres à Evelynn.
- Transmission réseau réelle, HUD, animations, particules, audio et rendu de furtivité, à vérifier séparément.
- Défaut de déplacement V564 toujours ouvert. Aucun manque de modèle ou texture n’est démontré par ces essais.

## Fichiers mis à jour

Registres completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json ; reçu reference_requirement_trace_sources/evelynn-passive-shadow-walk-links-v567.json ; preuve fidelity_evelynn_passive_shadow_walk_links_v567.json. Couverture, plan, checkpoint,CURRENT,HANDOFF et deux bases locales actualisés avec sauvegardes. Détails reproductibles et journaux dans le lot revision567_Evelynn sur F:/OpenLeague-work.

Continuer SYS-01.2-02 depuis revision568_trace_review/REVIEW.json. V567 Evelynn publiée/auditée:3fiches,26sources,78associations,24points/48liens limités. Deux parcours publics:250/environ900unités,360ticks de visibilité et projection adverses chacun,24refus;ni transport réseau ni rendu exécutés. Achat1027 après210ticks:20 incréments égaux au taux de base1.6216,maximum465.6;aucune injection de mana. Le tooltip décrit1%du maximum et6secondes;seuil de proximité,vraie vision,transitions et régime de régénération natifs restent ouverts. Ne pas confondre ancien ShadowWalk/slot2 avec le passif. Préserver INPUTS_BEFORE.previous_artifacts V567,qui conserveV566 et la chaîne antérieure. Les trois essais ne prouvent pas la furtivité historique. Aucun statut/case/inconnu fermé. Reprendre les exigences restant reliées au lecteur générique après inspection des consommateurs réels,par exemple le passif Fiddlesticks si encore non qualifié. Défaut de déplacementV564 ouvert;goal actif.
