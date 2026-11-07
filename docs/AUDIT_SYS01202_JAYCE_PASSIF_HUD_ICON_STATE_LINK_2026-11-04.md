# SYS-01.2-02 — Jayce : liaison du Condensateur Hextech au HUD, V1226

4 novembre 2026. Unité `AUD-SYS-01.2-02-JAYCE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné, soumis à relecture puis publication racine. La mécanique, le HUD complet et l’acceptation restent ouverts.

## 1. Exigence et périmètre

`CH-Jayce-PASSIF-PRESENTATION-HUD`, `OLF-673775ac-4499-5899-8fa4-c4851fa9c5f9`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-f5be941b-ed04-5832-a8bd-4b910451aba0` reste ouverte. Six contrats sont conservés : SOURCE, CONTRAT, SIMULATION, NETWORK, HUD, ACCEPTANCE, avec leurs six inconnues propres. PRESENTATION parent reste un contexte distinct.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V581 UTC 2026-10-26T02:57:17.773958+00:00 ; MD UTC 03:04:48.320360. Dates documentaires, sans date d’exécution déduite.

V581 possède 37 identités natives et 111 associations sur trois tâches. SOURCE actuel : 41 relations/37 identités. HUD possède deux relations, définition et CharScript. Les métadonnées, localisation et preuves historiques sont réutilisées, sans nouvelle lecture native font/Lua/INIBIN/DDF/preload. Les observations nécessaires sont capturées exactement sur E avec provenance et empreintes ; les anciens chemins F-work restent des identités documentaires.

La description personnage annonce 40 de vitesse pendant 1,25 seconde et passage à travers les unités lors de Transform. Spell4=JayceStanceHtG ; les preloads GtH/HtG citent JaycePassiveHaste et les formes. Le personnage déclare GarenRecouperate, tandis que CharScript.preload cite Manager, Hammer et RunSpeed. Les niveaux 1/4/7 puis absents ne constituent pas une progression du bonus.

Seize Lua sont entièrement parsés sans prototype enfant ; quatorze initialisations littérales, deux limites NEWTABLE pc14 des transformations, sans corruption démontrée. CharScript est vide. Six bindings de buff donnent cinq correspondances, lignes 2102–2106 ; game_buff_tooltip_JaycePassive reste manquant, sans alias. Persistance/non-dissipation des formes déclarées ne prouvent pas leur cycle effectif.

Haste/Summoner_haste, JaycePassive/JayceManOfTomorrow et personnage/Jayce_Passive sont trois rôles distincts. Haste ne devient pas le contrat Fantôme ; ApolloPassive/ApolloPassiveActive/JarvanIVDemacianStandard/14.dds restent hérités. CastTime=0.115 n’est pas une durée de vitesse. Attaques chargées/dégâts magiques/réduction de défenses restent séparés. Dix preloads, 40 entrées DDF sans entrée de vitesse passive et 14 références communautaires ne prouvent aucun callback ni rendu.

Inventaire avant lectures DDS ciblées :

| Chemin lu | Octets | Format | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Jayce/HUD/Icons2D/Jayce_Passive.dds | 5616 | 64×64, DXT5, mip brut 7 | 0.0.0.174 |
| DATA/Spells/Icons2D/Summoner_haste.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.195 |

Deux payloads, 7 792 octets ; Jayce_Passive.dds : `7711a7f010a64b6bc4b9ef6c145bd41b92ac24a513464d66de38204bac122f14` ; Summoner_haste.dds : `78a4e9549b20333551c47c37cfe914a9dc9b301050df5bca08ebb847607ea798`. Tailles/MD5/membership sont vérifiés. JayceManOfTomorrow.dds n’est retrouvé ni dans le manifeste sélectionné ni dans les sous-arbres physiques Jayce/Spells inspectés. Cela ne démontre aucune absence globale ou corruption. Aucun remplacement automatique, ordre de lookup, pixel ou rendu n’est qualifié. Le miroir en_GB et le témoin Ahri sont identifiés ; locale effective ouverte.

## 3. Consommateurs actuels

Le catalogue appelé par Simulation::new est réel ; les lecteurs SOURCE représentent six sites/trois fichiers. V581 couvre 22 sites/11 fichiers, plus deux lecteurs. Provider/StartupHud, barres, QWER, Buff0 Ezreal, F3/Annie et chemins snapshot/session/horloges existent sans liaison Jayce spécifique établie. Les huit icônes QWER, quatre primaires/quatre variantes et zéro unresolved, ne constituent pas une icône passive intégrée.

Les dispatchs de sorts et de rangs refusent Jayce. La vitesse utilise les modificateurs locaux réels : speed_until est gardé pour GarenQ ; Soin, relique, Trundle, ralentissements et plafonds restent distincts. Occupation/mouvement filtrent les alliés après collecte des corps vivants. Aucune transformation, accélération temporaire ou traversée spécifique Jayce n’est établie dans les corps inspectés ; aucune absence globale n’est déduite.

## 4. Attendu, observé et contrôles

Attendu : ressources et états autoritaires qualifiés, reliés aux widgets et audiences applicables. Observé : déclarations et voies génériques présentes, liaison spécifique non établie. Sources 74/74, relecture E 55/55 ; consommateurs 58/58, relecture 10/10. Seize entrées/29 fenêtres communes, 22 ancres V581, six SOURCE et 15 pins/19 fenêtres directes sont contrôlés. Premier producteur source refusé sur l’agrégation : trois dépendances distinctes, quatre liens ; script/journal/contrôle échoué archivés avant correction, second passage 74/74. Premier collecteur refusé sur une assertion Transform trop large ; neuf originaux archivés, 12 occurrences de géométrie/caméra conservées et classifiées, second passage 58/58. Aucune recapture DDS ni exécution produit ; preuves héritées non rejouées.

V581 hérité : quatre cas vitesse, 70 refus, 240 ticks et 20 pas. Base 335, bottes 360 ; Soin 431,399963/457,399963 puis retour au tick30. Cinq pas/cas suivent vitesse/30, résidu<0,005 ; Stop immobilise. Transform sans cible est refusé avant/après 60 ticks, snapshot inchangé. Cette attente ne qualifie pas l’expiration du passif.

Quatre cas d’occupation Jayce/Garen : alliés bloquent à 65 unités, ennemis traversés chez les deux champions ; deux refus Transform supplémentaires, soit 72 refus publics au total. Ces 65 unités sont des rayons de navigation locaux, sans preuve de portée native ni ghosting temporaire. Les refus de graphes/associations restent des contrôles documentaires séparés.

Binaire historique : 6 056 960 octets, SHA `a039135e06e854df559892923f35fd8de2c1ebe95d4cff11af929e4d7d3ea297`, BUILD/RUN0 hérités. Aucun nouveau build, jeu, VM, REA, GPU, réseau, audio ou rendu exécuté ; V564 et chaînes antérieures restent ouverts.

## 5. Écarts et inconnues

Déclenchement dans les deux sens, durée/arrondi aux ticks, cumul/refresh, cibles/corps traversables, niveaux, objets, ralentissements, annulations, mort/respawn, formes et attaques chargées, lookup/rangs/alias, audiences/reconnexion et rendu restent ouverts. L’icône déclarée non retrouvée et le tooltip manquant sont conservés explicitement.

## 6. Correction et reprise

Réutiliser `CH-Jayce-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION. Qualifier transitions/40vitesse/1,25s/règles d’occupation, ressources manquantes et rôles sans alias arbitraire ; produire états autoritaires et branchements réels ; intégrer HUD avec refus/retrait des données absentes, invalides, périmées ou non autorisées. Vérifier les deux formes, limites temporelles, interactions, mort/reconnexion et rendu sur binaires/ressources identifiés. Préserver les témoins Garen/Soin/bottes et l’acceptation humaine distincte. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_jayce_passive_hud_20261104`, sources/consommateurs/scripts/journaux/archives/result/finalpeer. Préparateur f9 : toutes les entrées et archives imbriquées sont incluses. Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
