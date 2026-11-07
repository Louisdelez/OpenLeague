# Fizz — sources et consommateurs des VFX de Nimble Fighter

2026-11-05 · V1342 · AUD-SYS-01.2-02-FIZZ-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Fizz-PASSIF-PRESENTATION-VFX, OLF-cd5f2044-2bcd-59a3-9e4b-8210ff2b48bb. Relier déclarations et consommateurs courants ; distinguer réduction des attaques reçues, mitigation physique, immunité à la collision, rayons de navigation/corps, états, QWER et effets du passif. Contrat lancement/trajet/impact applicable, dépendance CH-Fizz-PASSIF-NETWORK et prérequis D06/lot conservés sans satisfaction implicite.

Fin : source/provenance, déclarations, chemins réels ou manque borné, contrôles et corrections précis. Après publication vérifiée, seul ce lien documentaire est clos ; inventaire, mécanique complète, tâche VFX et acceptation restent ouverts.

## 2. Sources et déclarations

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Reçu V569 retenu par V1322 :575400 octets, SHA21c26224a0450f8269fded9d57300b371a7ce564856b163f85710f99501b0b04. Source complète externe E vérifiée avant interprétation ; cadrage45832 octets sans incorporation complète, hook inchangé, accélération non mesurée.

Sept identités parmi huit candidats. Deux Lua entièrement lus structurellement/littéralement, trois affectations, aucun prototype enfant ni exécution serveur. CharScript56 vide ; FizzPassive157/SHA b122e20b06dd414fa54a98c8f3291ead1cd0987e1ea37d4fb18f15a2bb80233c déclare BuffName/PersistsThroughDeath/NonDispellable. Ni BuffTextureName ni AutoBuff dans ces globals ; cela ne prouve pas une texture ou un effet manquant.

Définition FizzPassive/FizzPassive.dds ; description et PassLev1Desc1 liées à la description Fizz. Passive1/six niveaux nuls conservés ; PassLev1Desc2..4 « +40/+60/+80% Mana Point regeneration » restent des littéraux, pas des rangs Nimble. PathfindingCollisionRadius="30" et GameplayCollisionRadius absent restent distincts.

Découverte V1214 capturée E :360364 octets, SHAe6bd65f6c3ca27bd1960b723823ce50e79e34ca7bc5263524d52c96f2fef25b8 ; original F/OpenLeague-work inerte. Deux preloads321 octets/quatre références de sorts, dont fizzpassive/fizzpassivedisplayicon/fizzseastonetrident. Préchargement ne prouve pas invocation, recette ou absence de particules. Binding brut du tooltip conservé ; huit autres champs INIBIN Seastone restent un contexte non promu. FizzPassiveDisplayIcon223 déclare FizzSeastoneTrident/FizzSeastonePassive.dds et reste explicitement exclu ; Spell2 Seastone distinct du passif. Huit références communautaires, CharScript124 vide, sans politique native qualifiée.

Un DDS Info hérité :5616 octets, SHA3e6dc513fa5d9a009483969b0a3596f5bd565d57d6e9d6949484dcb37c01740f ;64×64 DXT5/mip7, membre0.0.0.59 du projet0.0.1.7. Header/membership hérités ; provider, variante, priorité, pixels et rendu ouverts.

Trois textes en_GB1911/4187/4363 : déplacement à travers les unités, réduction des attaques de base, précision physique dans la description, @f1@ non résolu. Montant, niveaux, ordre de réduction et classes d’unités ouverts. Date primaire V56923:47:40.428274 distincte de la date MD23:54:34.077912 du25octobre ; date documentaire non promue en exécution. Aucun comportement récent importé.

## 3. Consommateurs actuels

Neuf Rust relus : core attacks.rs, damage.rs, lifesteal.rs, movement.rs, ally_occupancy.rs, collision.rs, lib.rs, spells.rs ; client projected_live.rs. Vingt-et-une ancres exactes ;16 entrées antérieures,14 identités communes VFX et deux animations ordinaires concordantes.

Attaques ordinaires, apply_damage, armure/pénétration/mitigation et boucliers sont des voies réelles, sans producteur Nimble identifié dans les corps inspectés. Lifesteal appelle la voie physique puis le soin générique ; cela ne qualifie pas une réduction des attaques reçues.

movement_speed compose vitesse, objets et modificateurs ; spin_crossing_multiplier appartient à Garen. La géométrie reconstruite ally_occupancy sélectionne des champions vivants de même équipe et des rayons de navigation ; placement/route/réservations restent distincts du rayon de corps et du terrain. advance appelle advance_allied_motion ; les autres champions ne deviennent pas automatiquement des cibles autorisées de traversée Fizz.

collision::pathfinding_radius refuse un profil invalide ; body_radius emploie les defaults communautaires65/40, sans remplacer le champ natif absent par une preuve historique. Effects/cast gardent leurs voies existantes ; le chemin champion non implémenté est refusé. projected_live sélectionne Annie.

Recherche Fizz/Nimble nulle dans les neuf textes complets, sans absence globale. Animation ordinaire V1336 réutilisée via V1341 et deux gardes, sans nouvelle sémantique/pose/pixels. HUD/QWER antérieurs conservés, sans nouvelle qualification UI/réseau.

## 4. Attendu, observé et contrôles

Attendu : déclarations/frontières qualifiées, voies existantes conservées et manque spécifique borné. Observé :71/71 contrôles documentaires,75/75 cohérences séparées du même agent,21 ancres et gardes16/14/2 concordantes. V1214 source63/consommateur49/intégration38 hérités, non rejoués.

V569 hérité :deux cas d’attaques publiques entrantes, six impacts chacun et30 refus atomiques ; armures22.41200066/37.41200256 après1029(+15). Brut50.41 ; pertes corrigées de régénération41.180603/36.685303, résidu ordinaire<0.002 selon preuve héritée, sans nouveau calcul. Aucun supplément observé ne fournit f1 natif.

Quatre mouvements publics :Fizz/Garen bloqués par Annie alliée à60/65 unités ; Annie ennemie traversée par tous deux, destination atteinte, minima4.336914/3. Ces distances ne valident ni immunité Fizz ni toutes les unités/terrains. Mouvement V564 distinct.

Binaire historique6047744 octets/SHA09787d54f6ef4adbfc96946b7b4bfa916a6dc8865414e77a5676888fdaf06e16 inerte, non relu/rejoué. Ancien gate shop.rs non piné et bornage source hors phase_headers conservés, pas de nouveau défaut produit déduit. Six opérations documentaires journalisées réussies ; aucun nouveau build, jeu, natif D/stat/résolution, décodeur/VM, GPU, REA, capture, réseau ou rendu.

## 5. Écarts et inconnues

Applicabilité/inventaire/recette, f1/niveaux/attaques éligibles/ordre, unités et alliances autorisées, activation/retrait/mort/réapparition/reconnexion, owner/skin/audiences, pose/attache et cycle rendu ouverts. Armure/objets et géométrie génériques ne clôturent pas ces clauses ; sources Seastone non substituées.

Inconnues VFX/SOURCE, consommateurs inscrits et V1322 conservés exactement. Zéro tâche complète, feature, inconnue, acceptation ou goal clos ; aucun pourcentage du jeu ni garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Fizz-PASSIF-PRESENTATION-VFX :nimble-visual-applicability-source, incoming-attack-collision-world-link, resource-lifecycle-render-acceptance. Objectifs/prérequis/fins/reprises dans corrections_and_restart.json ; SOURCE/NETWORK/HUD/animation et autres médias gardent leurs critères.

Reprendre sur nouvelle source/copie attribuable, lecteur, appel, producteur, pose, capture ou dérive pertinente ; pas de recherche globale/replay inchangé. Prochain lot CH-Gangplank-PASSIF-PRESENTATION-VFX via next_lot.json ; Galio/Garen possèdent déjà leur lien borné.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_fizz_passive_vfx_20261105 :cadrage, inspections, gardes, evidence_review, coherence_review et journaux. Sept rubriques examinées ; relecture du même agent, sans revue indépendante/acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2329 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
