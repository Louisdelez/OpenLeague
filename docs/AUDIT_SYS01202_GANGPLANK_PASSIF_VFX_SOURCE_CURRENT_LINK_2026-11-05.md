# Gangplank — sources et consommateurs des VFX de Grog-Soaked Blade

2026-11-05 · V1343 · AUD-SYS-01.2-02-GANGPLANK-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Gangplank-PASSIF-PRESENTATION-VFX, OLF-bcbde325-62f7-5b07-9b21-2b283a4e13b6. Relier déclarations et consommateurs courants ; distinguer propriétaire Scurvy, cible ScurvyStrike, poison/ralentissement/cumuls, Parley/RemoveScurvy, invocateurs et effets du passif. Contrat lancement/trajet/impact applicable, dépendance CH-Gangplank-PASSIF-NETWORK et prérequis D06/lot conservés sans satisfaction implicite.

Fin : provenance/déclarations, chemins réels ou manque borné, contrôles et corrections précis. Après publication vérifiée, seul ce lien documentaire est clos ; inventaire, mécanique complète, tâche VFX et acceptation restent ouverts.

## 2. Sources et déclarations

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Reçu V570 retenu par V1322 :677612 octets, SHA f93dd62f9d85ec5abc4b34fa56215a5111d99aa7d554e653015f99c8a027ce11. Source externe E vérifiée avant interprétation ; cadrage56719 octets sans incorporation complète, hook inchangé, accélération non mesurée.

Treize identités natives parmi17 candidats. Cinq Lua entièrement lus structurellement, aucun prototype enfant ni exécution serveur ; quatre initialisations qualifiées/20 affectations, CharScript56 vide. Parley331 conserve la limite NEWTABLE PC12 : ni corruption ni extraction arbitraire de politique depuis ses constantes.

Scurvy379 propriétaire déclare neuf globals, dont IsDamagingSpell=false et persistance/non-dissipation ; ScurvyStrike294 cible déclare sept globals, IsDamagingSpell/IsDeathRecapSource=true. Ces flags ne prouvent pas les callbacks ni la persistance/purge de la cible. ScurvyStrikeParticle265, SHA7652cf53a9d2ffcedb5ec9eed6cf0fbac51216a95ef6a8e28d5e6ae190d59d58 :Global_Slow.troy et attache vide aux PC5/7 ; invocation, pose, bone par défaut et rendu non qualifiés.

Définition Scurvy/Pirate_GrogSoakedBlade.dds ; Passive1=1, niveaux1/9/17 puis trois null conservés sans politique de rang déduite. Quatre descriptions identiques ; slots Parley/RemoveScurvy séparés. Quatre candidats PirateScurvy/RemoveScurvy restent exclus du poison.

Deux captures E exactes V1216 : découverte466909 octets/SHA42de36a4c3d40fb6741e3b54567e7d970f8820389294459ffddf1d97a7184b6a ; inspection qualifiée571530/SHA521bf8f68e937e05f78a5f8228f48a995432b09b38d1a43cfbb07fb47be707d2. Métadonnées concordantes, originaux F/OpenLeague-work inertes. Deux preloads479 octets/sept références de sorts, dont scurvystrikeparticle/scurvystrike ; deux bindings de tooltips vérifiés contre les champs bruts. Préchargement ne prouve pas déclenchement/recette.

Douze références communautaires non natives : CharScript129 vide ; Q2372 contient dégâts physiques/critique, crédit ATTACK, or/mana et création de projectile commentée. Ni callback de poison natif ni exécution de ce code déduits.

Un DDS HUD/Icons2D hérité :4224 octets, SHA36c57745c0282476bc6f9921ac305307d8cae0b1ed4085b3031ddd55478c1a0b ;64×64 DXT5/mip1, membre0.0.0.169 du projet0.0.1.7. Header/membership hérités ; provider, priorité, sélection, pixels et rendu ouverts.

Cinq textes en_GB2595/2596/4189/4365/9750 :7%, dégâts magiques @f1@ chaque seconde pendant3s, maximum3 cumuls, cible @SourceName@ et déclencheurs attaques/Parrrley. f1, niveaux et combinaison ouverts ; aucun21% déduit. Date primaire26octobre00:06:19.737953 distincte du MD00:13:07.554528 ; inspection qualifiée sans propriété UTC conservée, sans date d’exécution inventée.

## 3. Consommateurs actuels

Dix Rust relus : core attacks.rs, damage.rs, lifesteal.rs, slows.rs, movement.rs, summoner_ignite.rs, summoner_exhaust.rs, lib.rs, spells.rs ; client projected_live.rs. Vingt-trois ancres exactes.18 entrées sélectionnées et77 entrées de contexte V1216 concordent, avec chevauchement :77 ne signifie pas77 nouveaux consommateurs. Le contexte inclut le reçu préparatoire Galio jadis omis du gate.14 identités communes VFX et deux animations ordinaires concordent.

Attaques physiques et mitigation sont des mécanismes réels. slows sélectionne le maximum actif et remplace un même tag ; preflight/commit/expiration et admission NPC sont des contrats génériques reconstruits, pas la politique Scurvy. grant_slow est une API d’événement serveur ; les commandes réseau ne créent pas un ralentissement arbitraire.

movement_speed applique les ralentissements génériques. Épuisement appelle grant_slow avec son tag ; Embrasement maintient un Burn et applique des dégâts True, distincts du poison magique. Effects/advance/cast gardent leurs voies existantes ; le chemin champion non implémenté est refusé. projected_live sélectionne Annie.

Recherche Gangplank/Scurvy/Parley nulle dans les dix textes complets, sans absence globale. Animation ordinaire V1336 réutilisée via V1342 et deux gardes, sans nouvelle sémantique/pose/pixels ; HUD/transport antérieurs non requalifiés.

## 4. Attendu, observé et contrôles

Attendu : déclarations/frontières qualifiées, acquis conservés, manque spécifique borné. Observé :77/77 contrôles documentaires,81/81 cohérences séparées du même agent,23 ancres et gardes18/77/14/2 concordantes. V1216 source55/consommateur53/intégration40 hérités, non rejoués.

V570 hérité : quatre cas publics1/3/4/4 attaques,12 impacts physiques non critiques,60 refus,720 ticks après arrêt ; brut59.04 et résidu physique ordinaire<0.002 après régénération selon preuve héritée. Cible vitesse335, MR30/55 sans poison observé : aucune mitigation magique du poison absent qualifiée. Trois coups espacés de46ticks couvrent92ticks ; trois charges simultanées non garanties. Parley refusé ; mouvement V564 distinct.

Cinquième cas public séparé : Épuisement335→234.5→335 sur75ticks ; Embrasement5 applications de14 bruts,70 total, première immédiate, suivi150ticks ; quatre refus supplémentaires. Ces positifs ne valident ni poison ni cumul. Premier diagnostic compilé refusé E0559, Summoner/target au lieu de SummonerTarget ; aucun essai exécuté alors. Successeur qualifié build/run0, binaire6067712/SHA7ad0d1f901bc353b3de406515d9daffa69507027e161db940fa9bafcb85936ed inerte, non relu/rejoué.

Deux requêtes d’affichage actuelles ont échoué sur des noms de champs supposés ; root_context_failures.json conserve les KeyErrors et la reprise sur tooltip_binding et records/copy_pin réels. Aucune source manquante déduite. Six opérations documentaires journalisées réussies ; aucun nouveau build, jeu, natif D/stat/résolution, décodeur/VM, GPU, REA, réseau ou rendu.

## 5. Écarts et inconnues

Applicabilité/recette/inventaire, f1/niveaux/rangs, premier tick/cadence/durée, cumul/refresh/expiry/multi-auteurs, poison/ralentissements combinés, purge/mort/réapparition, résistances/boucliers, Parrrley, owner/skin/audiences, pose/attache et rendu ouverts. Invocateurs et compteurs génériques ne clôturent pas ces clauses.

Inconnues VFX/SOURCE, consommateurs inscrits et V1322 conservés exactement. Zéro tâche complète, feature, inconnue, acceptation ou goal clos ; aucun pourcentage du jeu ni garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Gangplank-PASSIF-PRESENTATION-VFX :grog-visual-applicability-source, poison-slow-stack-world-link, resource-attachment-render-lifecycle. Objectifs/prérequis/fins/reprises dans corrections_and_restart.json ; SOURCE/NETWORK/HUD/animation gardent leurs critères.

Reprendre sur nouvelle source/copie attribuable, lecteur, appel, producteur, pose, capture ou dérive pertinente ; pas de recherche globale/replay inchangé. Prochain lot CH-Gnar-PASSIF-PRESENTATION-VFX via next_lot.json, en conservant chaque version sans préférence automatique.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_gangplank_passive_vfx_20261105 :cadrage, inspections, gardes, evidence_review, coherence_review, erreurs de contexte et journaux. Sept rubriques examinées ; relecture du même agent, sans revue indépendante/acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2330 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
