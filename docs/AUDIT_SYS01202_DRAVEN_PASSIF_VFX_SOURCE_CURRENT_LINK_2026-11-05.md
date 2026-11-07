# Draven — sources et consommateurs des VFX d’Adoration

2026-11-05 · V1337 · AUD-SYS-01.2-02-DRAVEN-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Draven-PASSIF-PRESENTATION-VFX, OLF-44421749-b39e-5883-a8cf-ddd9ba7cab51. Relier déclarations et consommateurs courants ; distinguer charges/cashout/or, rattrapage/Q, HUD et effets du passif. Contrat : lancement/trajet/impact applicables ; dépendance CH-Draven-PASSIF-NETWORK et prérequis D06/lot conservés, sans satisfaction implicite.

Fin du lot : identité/portée des sources, chemins réels ou manque borné, contrôles et corrections précis. Après publication vérifiée, seul le lien documentaire est clos. Mécanismes ordinaires conservés ; compteur et rendu spécifiques non établis dans les corps inspectés. Vérification statique, acceptation humaine non donnée ; inventaire VFX complet exclu.

## 2. Sources, déclarations et limites

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Reçu V1322 draven-passive-adoration-gold-links-v565.json :612571octets, SHA45becb8239bd71692b26fc6d61069ba90cdbac466f179a8fdb75f04af408b691. Source externe retenue vérifiée avant interprétation ; cadrage54172octets sans incorporation du document complet, hook inchangé, gain de temps non mesuré.

/native_metadata/client_lua conserve cinq vues entièrement lues structurellement, sans prototype enfant ni serveur exécuté. Quatre initialisations qualifiées/neuf affectations : CharScript vide56octets ; Passive212 et Stacks218 chacun nom/icône/PersistsThroughDeath/NonDispellable ; ReturnCatch90 déclare PersistsThroughDeath. Flags ne prouvent pas persistance, demi-perte, compteur ou rattrapage. Aucun AutoBuff dans ces globals qualifiés, sans absence native d’effet déduite.

Spinning308octets/16instructions reste limité par NEWTABLEpc10 : globals non qualifiés, sans corruption inférée. SpellFXOverrideSkins/Draven_Gladiator/DravenSkin03 sont des constantes, pas affectations ou règle de skin du passif.

Définition : DravenPassive/Draven_passive.dds ; Passive1/description et six niveaux absents sans defaults. Trois bindings conservés : Passive, Stacks, Spinning ; ce dernier reste contexte Q. Les références brutes absentes ne sont pas réécrites.

Découverte exacte capturée V1209 sur E :303109octets, SHAdc42a110f766b8eeaa5cec7ba7225d0014d9978d76f11908cc0c8c346b4655ff ; original F/OpenLeague-work inerte. Preloads215/601octets vérifiés contre cette copie :3/8références, dont draven_base_p.troy/base_p_lesser, Stacks, SpinningAttack2/Crit et sons de rappel. Ce mélange ne qualifie pas sélection, événement, rendu ou audio. Sept références communautaires : CharScript vide, Q simplifié AddBuff/particule ; aucun rattrapage/Adoration natif prouvé.

Deux DDS V1209 de même basename restent distincts : Characters/HUD4224octets/1mip/SHA8b76dfdd72ae0ff38590d8f120401c1158ac7a7c3a09e3306b883c9a51ee7888 ; Spells5616octets/7mips/SHA00134909f6d0d7a894b1d41f0528b81702960df01a7c41a3f333c34caa69bafd. Tous deux64×64 DXT5, membres0.0.0.235/0.0.0.169 du projet0.0.1.7. Identités/header/membership hérités ; sélection/priorité/pixels ouverts, aucune corruption ou reconstruction déduite.

Cinq textes en_GB1848/1849/1850/4180/4356 : charges au catch ou kill sbire/monstre/tour, kill champion consommant les charges pour f4+f1parcharge, mort retirant la moitié, f2/f3 statistiques d’or ; SourceName et Q gardent leurs rôles. Valeurs/fournisseurs/arrondi restent ouverts.

## 3. Consommateurs actuels conservés

Neuf Rust relus : crates/core/src/attacks.rs, lifesteal.rs, champion_kills.rs, world.rs, passive_gold.rs, lifecycle.rs, damage.rs, spells.rs ; crates/client/src/projected_live.rs. Vingt ancres exactes. Dix-sept entrées antérieures concordent : treize core, deux lecteurs SOURCE, deux règles ; quatorze identités communes VFX inchangées.

Attaques Physical et apply_damage appellent les chemins ordinaires. reward_champion_death calcule base/premier sang, attribue or/score et publie l’événement ; world crédite unités/bonus/global. passive_gold paie aux frontières locales ; effets/mort/réapparition restent génériques. Damage est lu au-delà du cfg(test) d’un helper précoce. Ces chemins ne réalisent pas charges/cashout/demi-perte ou effets Adoration.

La liaison d’animation ordinaire V1336 est réutilisée après contrôle des deux fichiers attack_animation.rs/animation.rs, sans relecture sémantique : faits→attack/crit→lookup/play/seek, pas catch/passif ou pixels. projected_live filtre Annie. Recherche Draven/Adoration nulle dans les neuf textes complets, sans absence globale. GoldStat floor/guard antérieur reste portefeuille, pas statistiques du passif ; aucune nouvelle qualification UI.

## 4. Attendu, observé et contrôles

Attendu statique : qualifier déclarations/frontières, conserver voies ordinaires et borner le manque visuel. Observé :87/87 contrôles documentaires,62/62 cohérences séparées du même agent,20ancres et gardes17/14/2 concordantes. Refus/gardes lus seulement. V1209 source59/consommateur43/intégration34 hérités, non rejoués.

V565 : Draven frais, Caitlyn témoin, Draven après trois sbires crédités ; six kills400/300or nets ordinaires, supplément0 après retrait des paiements ambiants8 aux frontières locales75s/5s. Trois récompenses de sbires ne sont pas trois charges internes. Les123valeurs du champ historique hits sont des baisses de santé :71avec projectile au snapshot précédent,52sans ; aucun123impacts attribués revendiqué. Preuve des récompenses fondée sur événements/or, qualification antérieure préservée exactement.

Quarante-cinq refus historiques et réapparitions naturelles des victimes ne prouvent ni catch ni décès propre de Draven/perte de moitié. Échecs de mouvement V564 et chaîne V563 conservés, non résolus ici. Aucun nouveau replay, build, test Rust, jeu, natif D/stat/résolution, décodeur/VM, GPU, REA, réseau ou pixels ; aucune préparation de ce lot échouée.

## 5. Écarts et inconnues

Applicabilité/inventaire/recette, f1/f2/f3/f4/SourceName, compteur/catch/crédits/consommation/arrondi, propre mort, simultanéité, statistiques, owner/skin/audiences, pose/attache, montage et cycle rendu ouverts. Preload, DDS, or, animation ordinaire ou Q communautaire ne clôturent pas ces clauses.

Inconnues VFX/SOURCE et consommateurs inscrits conservés exactement. V1322 immuable ; zéro tâche complète, feature, inconnue, acceptation ou goal clos. Aucun pourcentage du jeu déduit ; pas de garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Draven-PASSIF-PRESENTATION-VFX : adoration-visual-applicability-source, stack-cashout-owner-world-link et resource-lifecycle-render-acceptance. Objectifs/prérequis/fins/reprises dans corrections_and_restart.json ; SOURCE/NETWORK/HUD/mouvement gardent leurs critères distincts.

Reprise sur source/copie attribuable, lecteur, appel, producteur, pose, capture ou dérive pertinente ; pas de recherche globale ou replay inchangé. Prochain lot CH-Elise-PASSIF-PRESENTATION-VFX : reçu V566 retenu, distinguer formes, essaim/pets et présentation.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_draven_passive_vfx_20261105 : cadrage, inspections, gardes dont animation réutilisée, evidence_review, coherence_review et journaux. Sept rubriques examinées ; relecture séparée du même agent, ni revue indépendante ni acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
