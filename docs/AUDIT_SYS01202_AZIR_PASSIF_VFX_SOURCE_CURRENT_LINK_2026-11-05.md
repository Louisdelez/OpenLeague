# Azir — sources et consommateurs des VFX du passif

2026-11-05 · V1331 · AUD-SYS-01.2-02-AZIR-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Azir-PASSIF-PRESENTATION-VFX, OLF-b8117483-373e-5ef3-b264-5318790cbf7e. Qualifier les vues V559 et les consommateurs pertinents, en séparant conversion CDR→AS, Disque solaire et contexte QWER. Contrat : effets de lancement, trajet et impact applicables ; dépendance CH-Azir-PASSIF-NETWORK et prérequis D06/lot conservés, sans satisfaction implicite.

Fin du présent audit : provenance/portée, chemin actuel ou manque borné, vérifications et corrections précises. Audit documentaire terminé après publication vérifiée ; acquis génériques conservés, comportement visuel spécifique non établi dans ce périmètre ; vérification statique, acceptation humaine non donnée. Inventaire VFX exhaustif, nouvelle interprétation de tables et rendu exécuté exclus. SOURCE/HUD et anciens diagnostics ne sont pas recomptés.

## 2. Sources et limites de lecture

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Copie V1322 de azir-passive-cdr-attack-speed-sundisc-links-v559.json : 658239 octets, SHA 4c221c14dd3b9ed0c70c822f8963a7925f3148cdbe2c0bccc473250bd86f35b0, vérifiée avant lecture.

/native_metadata/client_lua conserve onze chunks structurellement lus entièrement, sans prototype enfant. Huit lectures de littéraux restent non qualifiées : IsChannelingPassive pc6, Passive pc10, Available pc12, TeleportBlocker/Unavailable pc8, TowerBuff/TowerBuffChaos/TurretStatIncrease pc6. Les globals vides de ces huit vues ne sont pas des affectations établies. BuffName, BuffTextureName et PersistsThroughDeath dans les constantes ne deviennent pas des états interprétés. NEWTABLE est une limite du lecteur, pas une corruption.

Les trois CharScripts SunDisc/SoldiersTowerClicker/TowerClicker ont chacun 56 octets, une instruction, globals vides qualifiés et SHA 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0. Chemins/identités distincts, aucun callback serveur récupéré. Ni ces vues ni les huit limites ne prouvent une absence native d’effet.

Sept tables de constantes contiennent CyberEzreal, une AzirSkin01 : contextes conservés sans règle de skin, alias ou sélection déduits. Cinq preloads natifs ne prouvent ni ouverture de particule ni rendu. V1185 réutilise 23 memberships V559 ; SOURCE comporte 29 relations/24 identités, incluant CharScriptAzir à la racine. Ce membre supplémentaire reste une identité réutilisée, pas un douzième chunk V559 nouvellement décodé, et ne contredit pas l’ancienne recherche locale du sous-dossier Scripts.

La définition conserve AzirPassive/Azir_Passive.dds, niveaux passifs absents ; TowerClicker 1/4/7 non transférés. Les textes en_GB décrivent 1,25 % AS pour 1 % CDR et le bonus courant @f1@, pas un taux d’accumulation. SunDisc : ruine cliquable, trois minutes, désintégration d’une minute et exclusions ennemies Nexus/inhibiteur restent des textes, sans chronométrage serveur. Le DDS HUD identifié V1199 demeure une icône, sans preuve d’effet en monde.

## 3. Consommateurs réels et réemploi

Six entrées relues : crates/core/src/progression.rs, shop.rs, world.rs, spells.rs ; crates/client/src/projected_live.rs ; data/4.20/map10_world.json. Neuf ancres exactes. Les 21 entrées SOURCE V1185 et les 14 identités communes VFX concordent ; leurs conclusions détaillées sont réutilisées, sans nouveau scan global.

Les bonus objets CDR/AS restent séparés. stats plafonne la CDR ; le dénominateur de cadence ne lit pas cooldown_reduction. La conversion Azir reste un écart de la formule inspectée ; attaque/projectile ordinaire et AS d’objet ne sont pas soldats ou passif.

Map10 conserve 27 définitions/18 structures et l’ajout explicite Tibbers ; pas de clé AzirSunDisc dans cette configuration. spawn_unit refuse une définition inconnue avant allocation. Les corps clic/commandes/spawn/mort/tick examinés V1185 restent sans producteur SunDisc qualifié : ruine conservée, tour vivante et spawn générique ne réalisent pas son activation.

Le sélecteur Annie de projected_live est vérifié dans le texte complet, au-delà d’un préfixe interrompu par cfg(test). Recherche Azir/SunDisc/Shurima/TowerClicker nulle dans les six textes complets sélectionnés. Limite locale explicite, aucune absence globale d’assets ou de producteurs affirmée. HUD Ezreal et QWER restent distincts.

## 4. Attendu, observé et contrôles

Attendu nominal statique : reconnaître vues qualifiées/non qualifiées, préserver sources et consommateurs, borner le manque visuel. Observé : 57/57 contrôles documentaires, 44/44 cohérences séparées du même agent ; neuf ancres et gardes 21/14 concordantes.

Refus lus : définition NPC inconnue et sélection Annie spécialisée ; aucun scénario exécuté. V559 conserve trois cas sans objet/Codex/Dague : cadences 58/58/50 ticks, 18 impacts, 51 refus. Codex apporte CDR sans accélération observée, Dague AS distinct ; aucune activation de ruine/SunDisc testée. Ces preuves restent héritées, non rejouées ou nouvellement qualifiées par le code actuel.

Une préparation échouée est conservée : le publisher SOURCE ancien expose reviewed_stage_hashes[result.json], pas result_sha256. La reprise vérifie le champ réel et le SHA exact, sans modification des preuves anciennes. Aucun build, test Rust, jeu, natif D/stat/résolution, décodeur/VM, GPU, REA, réseau ou comparaison de pixels nouveau.

## 5. Écarts et inconnues

Tables et champs non qualifiés, applicabilité, inventaire secondaire complet, recettes, état/activation, owner/skin, audiences, attache, cadence, montage et rendu restent ouverts. Préloads, noms d’acteurs, modèle/clip, compteur HUD et cadence mécanique n’y répondent pas seuls. Questions VFX/SOURCE et consommateurs inscrits conservés exactement.

V1322 demeure immuable ; zéro tâche SOURCE/SIMULATION/NETWORK/VFX complète, feature, inconnue, acceptation ou goal clos. Aucun pourcentage du jeu déduit ; contrôles aux lectures, sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Azir-PASSIF-PRESENTATION-VFX : source-reader-and-applicability, passive-sundisc-state-world-link, resource-lifecycle-render-acceptance. Objectifs, prérequis, fins et reprises dans corrections_and_restart.json ; SOURCE et NETWORK gardent leurs critères distincts.

Reprendre uniquement sur source/copie attribuable, lecteur, appel, capture ou dérive pertinente. Ne pas remplacer une recette inconnue par une texture générée. Prochain lot : CH-Braum-PASSIF-PRESENTATION-VFX, reçu secondaire conservé et consommateurs nécessaires, en distinguant son passif des sorts.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_azir_passive_vfx_20261105 : initial_scope, inspection, current_inspection, evidence_review, coherence_review, gardes et journaux, échec original inclus. Sept rubriques examinées ; relecture séparée du même agent, ni revue indépendante ni acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes, sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2318 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
