# Elise — sources et consommateurs des VFX de Spider Swarm

2026-11-05 · V1338 · AUD-SYS-01.2-02-ELISE-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Elise-PASSIF-PRESENTATION-VFX, OLF-f4ba7e18-cec1-5e5f-b2d1-4820be19ed96. Relier déclarations et consommateurs courants ; distinguer formes humaine/araignée, réserve, araignées vivantes, familiers, QWER, HUD et effets. Contrat : lancement/trajet/impact applicables ; dépendance CH-Elise-PASSIF-NETWORK et prérequis D06/lot conservés, sans satisfaction implicite.

Fin du lot : identité/portée des sources, chemins réels ou manque borné, contrôles et corrections précis. Après publication vérifiée, seul le lien documentaire est clos. Mécanismes ordinaires partiels conservés ; passif/rendu spécifique non établis dans les corps inspectés. Vérification statique, acceptation humaine non donnée ; inventaire VFX complet exclu.

## 2. Sources, déclarations et limites

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Reçu V1322 elise-passive-spider-swarm-links-v566.json :931402octets, SHA5b5889504979d6e212461a79aed53daa7aed2ef79b3b04c6572f88825f1b18d7. Source externe retenue vérifiée avant interprétation ; cadrage99654octets sans incorporation du document complet, hook inchangé, gain temporel non mesuré.

/native_metadata/client_lua conserve25vues entièrement lues structurellement/littéralement,96affectations,cinq vues vides, sans prototype enfant ni serveur exécuté. CharScriptElise n’est pas vide :118octets,deux flags. Passive181octets déclare nom/icône/PersistsThroughDeath. Spawn/IsSpiderling et trois Fade sont vides dans ces vues, sans événements ou absence native inventés.

Deux contextes ont quatre champs AutoBuff qualifiés : SpiderWSpiderling371octets déclare Elise_spiderling_W_move_buf.troy/C_BUFFBONE_GLB_LAYOUT_LOC aux PC9/11 ; HumanE437octets déclare LOC_Stun.troy/C_BUFFBONE_GLB_CENTER_LOC aux PC11/13. PopupMessage1=game_floatingtext_Stunned est séparé. Ce sont déclarations W/E, pas applicabilité au passif, activation, pose ou rendu.

Définitions Elise/EliseSpider/EliseSpiderling distinctes : portées typées«550»/125/175, vitesses335/345/345, slots humains/araignée conservés. Passive1 et six niveaux explicitement interrogés restent nuls, sans defaults. Régénération alliée/+40/+60/+80%mana, Morgana et littéraux Swain/Akali/Twitch sont préservés sans adoption/réécriture ou corruption déduite. Spider1..5, identités Lua égales, ne prouve pas plafond5 ; SpellToggleSlot4 et flags ne prouvent pas transition/persistance.

Découverte exacte V1211 capturée E :570981octets, SHA8137c959bc411ae781af2fdabee509fdfe5915469300e4b127ffc36c471da6cf ; original F/OpenLeague-work inerte. Six preloads1602octets/22références vérifiés contre cette copie : spells, personnage elisespiderling, Fade/Stats, Spider1..5 et elise_spiderling_cas.troy. Déclaration de chargement ne démontre ni invocation ni effet.

Deux DDS V1211 : HUD128×128/8320octets/SHA342dfeed57d2e1d99070d3ffba20f66a19ff9a6a0537a0aabfa71ab949450164 ; HUD/Icons2D64×64/2176octets/SHA68b6a22c512ab1b7fca8ebe9615f14549f2f74709a1a9a9f6bc5c20771dbbcc4. DXT1/champ mip brut1, membres0.0.0.130 du projet0.0.1.7. Identités/header/membership hérités ; sélection/priorité/pixels ouverts, aucune reconstruction nécessaire démontrée.

Textes en_GB1853/4182/4358 : touche d’un sort humain prépare une araignée, plafondf3 ; forme araignée invoque pour attaquer les ennemis proches. f3/fournisseur/transitions ouverts ; fermeture brute </postScriptLeft> préservée, rendu non normalisé. Quatorze références communautaires : CharScript vide, R simplifié marqueur EliseSpiderForm/particule ; aucune transformation native prouvée.

## 3. Consommateurs actuels conservés

Huit Rust relus : crates/core/src/attacks.rs, lifesteal.rs, spells.rs, progression.rs, lib.rs, world.rs, annie_r.rs ; crates/client/src/projected_live.rs. Vingt ancres exactes. Quatorze entrées antérieures concordent : neuf core,deux lecteurs SOURCE,trois auxiliaires ; quatorze identités communes VFX inchangées.

join initialise rangs[0;4] ; Learn/next_rank refuse les champions hors schémas qualifiés, sans règle spéciale Elise. Cast et autoattaques Physical restent distincts des touches humaines du texte. world inscrit annietibbers et possède spawn_unit avec refus unknownNPC ; annie_r porte cast validé, invocation, Pet owner/expiration/ordres/aura. advance appelle ces voies existantes, sans réserve/forme/cycle Elise identifié dans ces corps. Tibbers n’est pas une araignée Elise.

Présentation d’attaque ordinaire V1336 via V1337 réutilisée après deux gardes exactes attack_animation.rs/animation.rs, sans relecture sémantique : faits→attack/crit→lookup/play/seek, pas transformation/familier/passif ou pixels. projected_live filtre Annie. Recherche Elise/SpiderSwarm/spiderling nulle dans les huit textes complets, sans absence globale. Contexte HUD/projection antérieur conservé, aucune nouvelle qualification d’audiences/UI.

## 4. Attendu, observé et contrôles

Attendu statique : qualifier déclarations/frontières et préserver chemins existants en bornant le manque spécifique. Observé :91/91 contrôles documentaires,73/73 cohérences séparées du même agent,20ancres et gardes14/14/2 concordantes. Refus/gardes lus seulement. V1211 source56/consommateur43/intégration34 hérités, non rejoués.

V566 public : deux parcours AP0/20,12impacts physiques isolés par projectile précédent,34refus, zéro familier. Aucun sort humain touché ni forme araignée atteinte : zéro araignée pendant ces autoattaques ne qualifie pas seul le passif.

Diagnostics distincts : award_experience2525 donne niveau6 ; Elise12Learn/Cast/CastAt refusés et zéro invocation ; AnnieRnonappris refusé puis apprentissage/cast accepté, un annietibbers. XP préparée non progression ordinaire ; témoin positif non validation Elise. Mouvement V564/chaîne V565/V563 conservé, non résolu. Aucun nouveau replay, build, test Rust, jeu, natif D/stat/résolution, décodeur/VM, GPU, REA, réseau ou pixels ; aucune préparation actuelle échouée.

## 5. Écarts et inconnues

Applicabilité/inventaire/recette, f3/plafond, touches multiples, réserve/formes/rangs/slots, apparitions/retours, owner/skin, statistiques/IA/cibles/soins/mort, audiences, pose/attache, montage et cycle rendu ouverts. Familiers génériques, flags, DDS, effets W/E et marqueur communautaire ne clôturent pas ces clauses.

Inconnues VFX/SOURCE et consommateurs inscrits conservés exactement. V1322 immuable ; zéro tâche complète, feature, inconnue, acceptation ou goal clos. Aucun pourcentage du jeu déduit ; pas de garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Elise-PASSIF-PRESENTATION-VFX : spider-swarm-visual-source-and-selection, reserve-form-spiderling-world-link et bone-resource-lifecycle-render-acceptance. Objectifs/prérequis/fins/reprises dans corrections_and_restart.json ; SOURCE/NETWORK/HUD/R/IA/animation/mouvement gardent leurs critères distincts.

Reprise sur source/copie attribuable, lecteur, appel, producteur, pose, capture ou dérive pertinente ; pas de recherche globale/replay inchangé. Prochain lot CH-Evelynn-PASSIF-PRESENTATION-VFX : reçu V567 retenu ; camouflage/visibilité et présentation à distinguer.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_elise_passive_vfx_20261105 : cadrage, inspections, gardes dont animation réutilisée, evidence_review, coherence_review et journaux. Sept rubriques examinées ; relecture séparée du même agent, ni revue indépendante ni acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
