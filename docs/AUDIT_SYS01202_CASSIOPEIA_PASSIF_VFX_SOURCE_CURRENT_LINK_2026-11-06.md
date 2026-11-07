# Cassiopeia — Aspect of the Serpent : sources VFX et consommateurs actuels

6 novembre 2026 · V1440 · AUD-SYS-01.2-02-CASSIOPEIA-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence et périmètre

CH-Cassiopeia-PASSIF-PRESENTATION-VFX, OLF-d1d847c4-4dca-59b8-83f2-bc2aa649b496. Relier les effets applicables de lancement, trajet et impact aux sources, états et consommateurs réels, ou préciser le manque. D06 et prérequis hérités ; CH-Cassiopeia-PASSIF-NETWORK reste requis. Statut a_faire, implémentation et acceptation conservés.

Audit documentaire de liaison terminé ; fonctionnalité non terminée ; vérification statique et résumés historiques hérités ; acceptation humaine non donnée. SOURCE V661 et HUD V1204 ne sont pas clôturés à nouveau. Ce lot ne termine ni le passif, ni Cassiopeia, ni SYS-01.2-02.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. V661 fait2853213octets, SHA070af8e81ca39031051eff9725d9442e7055b1547583304191dcc629ffe865ed. L’identité F concorde avec la copie figée. Trente et un memberships natifs hérités, distincts des37relations SOURCE et22identités liées non promues. Aucun chemin D rouvert.

Dix-huit vues Lua littérales/124globals, sans prototype enfant ni limite NEWTABLE ; onze directement rattachées aux31sources. CharScript56 est vide. DeadlyCadence398 et PoisonTicker1–4 déclarent noms/icônes/persistance ; les quatre textures suffixées restent des sélecteurs déclarés, sans ordre de paliers exécuté. ParticleManager/Lockout/Haste378 ont le même contenu et BuffName NoxiousBlastHaste ; aucun alias runtime automatiquement déduit.

Sept contextes du passif ne déclarent aucun AutoBuff reconnu, sans preuve d’absence historique de VFX. Cinq contextes Q/W/R portent neuf champs AutoBuff : Miasma/AcidTrail, poisons Q/W/Global_Poison attaché à HEAD_LOC, R/LOC_Stun à CENTER_LOC. Ces déclarations ne deviennent pas la recette des paliers. Ni ancien passif de réduction de mana ni passif moderne adopté ; six rangs absents restent absents.

Six preloads975/99/172/172/172/280, total1870octets, sont identifiés. Ticker2/3/4 partagent leurs172octets ; identité ne prouve ni seuil ni ordre. Contenu brut et recette typée non disponibles dans les reçus sélectionnés. Six DDS109992octets/64×64 RGB32 donnent cinq contenus : base21972/mip7, quatre Tickers16512/mip1, copie Zyra identique à la base. FourCC vide est cohérent avec RGB32, sans corruption inférée. Memberships hérités ; priorité et pixels rendus inconnus.

Douze textes présents et deux clés absentes restent distincts. f1..f11 ne désignent pas un fournisseur global : f7 signifie prochain palier dans Ticker2, CDR dans Ticker3/4. Deux DDF de chemins/contenus distincts conservent un seul lien peuplé TwinFang/f1/spelldamage0.55. Ce lien ne résout pas f2 du bonus de dégâts de Twin Fang11451 ni f5/f6 du soin décrit dans Ticker2.

## 3. Consommateurs réels

19 Rust courants inspectés,25ancres V661 retrouvées. Learn/Cast/CastAt conservent les refus Cassiopeia. Stats/shop calculent AP et CDR génériques ; heal valide un soin discret et le plafonne aux PVmax ; cooldown applique ses règles. Ces voies ne produisent pas les événements poison/kill/TwinFang ni les compteurs/paliers qualifiés du passif.

Les acquis partagés sont réutilisés : owner arrêtant huit handles, registre spatial alimenté par observations du caller, classes/résolveurs et animations ordinaires. HUD QWER/Ezreal, HP/Mana et transport d’effets génériques ne prouvent pas un trajet Aspect. Les anciens auxiliaires HUD et six JSON locaux restent dans leur périmètre hérité.

46comparaisons sur42fichiers concordent :14éléments partagés, deux animations,16contextes HUD, treize contextes V661 et le miroir en_GB. Streaming d’identité seulement. Recherche DeadlyCadence/PoisonTicker/PoisonParticleManager/Aspect dans les préfixes de production des19Rust : zéro hit. Conclusion bornée, sans exclure tout alias ou chargement dynamique ailleurs.

## 4. Attendu, observé et contrôles

Attendu : événement éligible → compteur/palier → ressource → owner/cible/attache/temps → rendu, ou lacune précise. Observé : déclarations et briques génériques identifiées, chaîne spécifique non établie. **33/33contrôles documentaires,139/139de cohérence du même agent.** HUD hérité :46source,24consommateur,26intégration,16postpublication, non rejoués.

V661 hérité : quatre cas Cassiopeia/Annie niveaux1/18, quatre achats Codex, quatre attaques, huit API magiques, quatre contrôles de soin API, deux AnnieQ, six XP serveur,70refus publics/40API et9274ticks. Codex30AP/10%CDR, soin API25/plafond55/zéro et AnnieQ ne démontrent ni poison, ni gain de charges, ni bonus/soin natif. Résumés relus, sans snapshots bruts, calcul flottant ou runtime nouveau. Ancien EXE6129152/SHA0196f6a7 et1158dépendances inertes.

Six productions Python journalisées réussies. Une précision documentaire corrige le mot « heal » accolé au f2 de TwinFang dans un brouillon de limite : le texte11451 désigne des dégâts, Ticker2 décrit le soin en f5/f6. Originaux conservés ;33prédicats et139cohérences/témoins inchangés, aucun fournisseur résolu. Le dispatch exploratoire initial a eu une erreur de syntaxe avant tout appel imbriqué/I/O, conservée dans root_context. Cache common.pyc optionnel absent distingué de common.py retenu. Recherche complémentaire AUDIT_*.md hors AUDIT_SYS01202*.md : rg1, zéro candidat, résultat nominal borné. Aucun build, jeu, natif, REA, GPU, installation ou migration exécuté.

## 5. Écarts et inconnues

Gains/porteurs de poison, seuils/cap/ordre/paliers, paramètres AP/CDR/soin, recettes/variants/lookup/skins, owner/attache/arrêt, audiences/réseau et rendu restent ouverts. Identités, textes, bonus d’objet et API ne les résolvent pas. Identifiants VFX/SOURCE intégralement conservés dans les preuves. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 reste ouverte ; inventaire secondaire et applicabilité exhaustive non qualifiés. Aucun besoin de reconstruction graphique démontré.

## 6. Corrections et reprise

corrections_and_restart.json sépare quatre objectifs : politique poison/charges/paliers/recettes, producteur réel et bonus/soin, réseau/owner/compteur, intégration VFX. Réutiliser SOURCE, SIMULATION, NETWORK et PRESENTATION-VFX ; aucun ajout au registre. Chaque fiche précise prérequis, fin et reprise. Un premier cas exige un événement réellement éligible, sans attendre tout le kit.

Reprendre sur source/capture/callsite nouveau ou dérive, avec autorisation distincte pour implémenter. Ne pas rejouer les contrôles non éligibles ou les décodeurs inchangés. next_lot.json sélectionne Chogath, schéma exact lu dans son reçu figé ; aucun audit Chogath réalisé ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_cassiopeia_passive_vfx_20261106 : scope, inspection, evidence_review brut/qualified, coherence_review brut/qualified, qualification narrative, identités, corrections, reprise et journaux. Sept rubriques relues ; même agent, sans revue indépendante ou acceptation humaine nouvelle. Seul l’audit de liaison borné est clôturable.

Publication limitée au rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes ; sept registres protégés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2426entrées groupées conservées. Goal, Plan/UI, bases, code, assets et statuts inchangés.
