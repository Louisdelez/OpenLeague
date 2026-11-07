# SYS-01.2-02 — Cassiopeia : liaison du passif au HUD, V1204

3 novembre 2026. Unité `AUD-SYS-01.2-02-CASSIOPEIA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Cassiopeia-PASSIF-PRESENTATION-HUD`, `OLF-373e8679-f884-56c2-91d6-2ea1d0a31999`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Cassiopeia-PASSIF-NETWORK`. L’inconnue `OLU-f22d9879-6dd8-5b2d-bb23-7a3e5fdb7a85` reste ouverte.

Le lot rapproche les ressources Aspect of the Serpent/DeadlyCadence et PoisonTicker des consommateurs HUD inspectés, sans décider gains, seuils, paliers ou audiences. V661 reste une preuve datée distincte ; ses diagnostics et frontières ne deviennent pas de nouveaux essais ni une clôture HUD.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Trente et une identités V661 sont réutilisées, non rouvertes : empreinte documentaire fraîche distincte d’un hash natif frais. SOURCE porte 37 relations/31 identités ; HUD deux relations, définition et métadonnées Lua : `OLS-912b50dc-3ef0-57d2-add6-edd509204af7`, `OLS-f5ddbe3a-76ea-542f-bcbf-491810ac33d2`.

La définition déclare `Passive1LuaName=CassiopeiaDeadlyCadence` et `Passive1Icon=Cassiopeia_DeadlyCadence.dds`, tandis que les textes nomment Aspect of the Serpent. Ni ancien passif de réduction de mana ni passif moderne adopté. PoisonTicker1..4 déclarent les textures suffixées1..4 ; ce lien littéral ne qualifie pas l’ordre des états ou leurs seuils. Dix-huit chunks Lua qualifiés sans prototype enfant, CharScript vide et six preloads ne prouvent pas le serveur. PersistsThroughDeath/NonDispellable restent métadonnées ; six champs de rang interrogés absents, sans défaut inventé.

Six DDS, 109992 octets, donnent cinq contenus. Sous `DATA/Characters/Cassiopeia/HUD/Icons2D`, leurs identités sont :

| Texture | SHA-256 | Octets / membre |
|---|---|---|
| Cassiopeia_DeadlyCadence.dds | `45da2fa9924c468b5222a4c9143b0b66a3054ed3f4600a903829a8d8ad0b17cc` | 21972 / 0.0.0.248 |
| Cassiopeia_DeadlyCadence1.dds | `97cfad87444f2a9c6568bbb48f87ac93dcb59f27d51419c49c32f52b1692eadf` | 16512 / 0.0.0.249 |
| Cassiopeia_DeadlyCadence2.dds | `85078d8e88b23972f88c39417edd0eb815977df97031ebf4f447494a7bd8315b` | 16512 / 0.0.0.249 |
| Cassiopeia_DeadlyCadence3.dds | `9975b44cf3960d0d1715f23638ccc1061ef52d2031f16c3e5a3673965307a03d` | 16512 / 0.0.0.249 |
| Cassiopeia_DeadlyCadence4.dds | `b92a6680b54ca0e727c717232f57c09842a35cabe75d60f4f628b5e63d442d2b` | 16512 / 0.0.0.249 |

Une copie primaire identique existe sous `DATA/Characters/Zyra/Info`, membre0.0.0.111, sans règle Zyra adoptée. Tous sont 64×64 RGB32, FourCC vide ; base sept mipmaps, Tickers une. Taille/MD5 concordent au manifeste sélectionné lol_game_client0.0.1.7. Aucun OLS créé ; priorité, sélection par état et pixels rendus inconnus.

Douze clés présentes sont distinguées : sept textes passif/paliers, deux buffs poison, trois QWE contextuels ; deux absences séparées concernent PoisonParticleManager/PoisonTickerLockout. Les références NoxiousBlastHaste sont conservées sans réécriture. `f1..f11` restent propres à chaque infobulle : `f7` signifie prochain palier dans Ticker2, CDR dans Ticker3/4, sans fournisseur commun qualifié. SourceName, locale effective, rangs et audiences restent ouverts. Deux DDF distincts ne résolvent pas ces paramètres : TwinFang f1/spelldamage0.55 ne qualifie pas le bonus f2 de son texte. Font D non relu.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et cinq lecteurs SOURCE ne deviennent pas des producteurs de capacité ou de présentation.

Provider/StartupHud et plugins ordinaires existent. Quatre icônes QWER NoxiousBlast/Miasma/TwinFang/PetrifyingGaze sont configurées, zéro unresolved ; cela ne prouve pas leurs capacités implémentées. Les 18 textes, 11 barres/fonds et 14 widgets QWER/D-F sélectionnés n’identifient aucun binding compteur/palier Aspect/DeadlyCadence/PoisonTicker. Buff0/texture BuffIcon0/BuffStack0 restent liés à Ezreal ; Annie4, F3 et stun QWER conditionnel restent distincts. Conclusion bornée aux corps/configurations lus, sans absence globale de code, alias ou assets.

Les voies génériques existent : stats/shop calculent AP d’inventaire/autel et CDR d’objets plafonnée ; heal valide un soin discret plafonné aux PVmax ; regeneration, Effects, Snapshot et advance transportent leurs états/cadenceurs. HP/Mana ordinaires ne prouvent pas charges ou soin TwinFang. Aucun producteur Cassiopeia n’est identifié dans ces corps. Six JSON compilés sont des entrées locales/dérivées sélectionnées, pas des paramètres natifs du passif.

## 4. Attendu, observé et contrôles

Attendu : compteur/paliers et ressources reliés à une autorité et des audiences qualifiées, avec affichage vérifié. Observé : déclarations identifiées et voies génériques réelles, sans liaison spécifique dans le HUD inspecté. Sources46/46, consommateurs24/24 contrôles documentaires. Première garde DDS≤16Kio refusée avant lecture ; ancien producteur/refus conservés, garde remplacée par liste exacte six fichiers/109992octets. Trois parses manifeste journalisés, une seule passe DDS ; aucune corruption inférée.

Seize pins/29 fenêtres communs, treize fichiers/25 ancres V661 et deux readers/six sites SOURCE concordent. Auxiliaires hérités V1200 2/11, V1202 2/3, V1203 2/9 ; six JSON/11 fenêtres sélectionnés. Inventaire1219 hérité sans census. Gardes/omissions et refus Learn/Cast/CastAt lus statiquement, aucun nouveau nominal/refus HUD exécuté.

V661 conserve quatre simulations : achats Codex3108 donnant30AP/10%CDR, attaques ordinaires, six XP serveur, contrôles API de soin25/plafond55/zéro et AnnieQ104bruts/60mana/8ticks/108ticks. Ce ne sont ni poison, charges, paliers ni TwinFang. Les70refus publics/40API et9274ticks restent historiques. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté.

## 5. Écarts et inconnues

Ressources/variants/lookup, substitutions par infobulle, gains, seuils/cap, propriété du poison, ordre, AP/CDR/soin natifs, compteur/paliers, rangs, persistance, audiences, confidentialité, fraîcheur/reconnexion et rendu restent ouverts. Présence DDS, bonus d’objet, soin API ou AnnieQ ne les remplacent pas. Aucun besoin de reconstruction graphique démontré.

## 6. Correction et reprise

Réutiliser `CH-Cassiopeia-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/rangs/lookup par rôle ; qualifier états/gains/paliers/audiences autoritaires ; intégrer widgets et refus sans faux zéro/palier ; vérifier nominal, limites, multi-cibles/poisons/kill/TwinFang, seuils, mort/reconnexion et confidentialité avec rendu identifié ; séparer objets/autel/soinAPI/AnnieQ/QWER/F3/Ezreal/monde des paliers ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, producteur/consommateur ou contrat pertinent, ou dérive précise, sans rejeu inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_cassiopeia_passive_hud_20261103` : source_worker/sourceproof.json, reçu consommateur, scripts/journaux et préparations conservées, result.json, finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes et sept protégés contrôlés avant/après puis relus.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
