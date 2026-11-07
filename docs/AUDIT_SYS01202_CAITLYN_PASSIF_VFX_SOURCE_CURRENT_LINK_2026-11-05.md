# Caitlyn — sources et consommateurs des VFX de Headshot

2026-11-05 · V1333 · AUD-SYS-01.2-02-CAITLYN-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Caitlyn-PASSIF-PRESENTATION-VFX, OLF-fcd3854f-12a1-523a-9b75-d404f3a444b6. Relier les déclarations disponibles et les consommateurs courants pour Count, Ready, Marker et missile, en distinguant tirs ordinaires, buisson, HUD et QWER. Contrat : lancement/trajet/impact applicables ; dépendance CH-Caitlyn-PASSIF-NETWORK et prérequis D06/lot conservés, sans satisfaction implicite.

Fin du présent audit : source/identité/portée, chemin actuel ou manque borné, contrôles et corrections précis. Audit documentaire terminé après publication vérifiée ; acquis génériques conservés, producteur/rendu spécifique non établi dans ce périmètre ; vérification statique, acceptation humaine non donnée. Inventaire VFX complet et exécution graphique exclus. HUD et diagnostics antérieurs non recomptés.

## 2. Sources, littéraux et limites

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Reçu V1322 caitlyn-passive-headshot-brush-minion-links-v560.json : 593744 octets, SHA 50199459f84f29eb1107729191bee705c801d1624aec06fcebe6232dd2f9a27c, vérifié avant usage.

/native_metadata/client_lua conserve cinq chunks entièrement lus structurellement, zéro enfant. Trois vues qualifiées : CharScript56/globals vides ; Count159, SHA 67981e2cfc55ca91ba5646e233d34ce1b603f0b9481baa528a55ccd2cdd2601e ; Marker216, SHA c7331a4516e8da3e010d3158bd9288b7ffca2ea127f4361a3dec23b0f718db13. Count nomme CaitlynHeadshotCount/Caitlyn_Headshot.dds. Marker nomme Headshot Marker, même icône, PersistsThroughDeath=true et NonDispellable=true, témoins PC1/3/5/7. Six globals qualifiés au total ; aucun AutoBuff dans ces vues, sans absence native d’effet déduite.

Deux limites conservées : CaitlynHeadshot, 221 octets/SHA 9750f0a7d84b97effd3adbaa6d02106f0fedc51e6ea7f5748b1ad84d962e516c, NEWTABLEpc4 ; missile, 117 octets/SHA 6b2101ec944c8b4043dec041ca6be6b5eefbecbd7371cf9ca7b1cabbeab7351c, NEWTABLEpc0. Caitlyn_Headshot2.dds/CaitlynHeadshotReady et CaitlynSkin06 restent des constantes candidates, sans affectation complète ou règle de skin qualifiée. Limites de lecteur, pas corruption ; flags de persistance/dissipation ne démontrent aucune exécution serveur.

V1203 identifie quatre DDS, deux contenus, 2872 octets, 64×64 DXT1/sept mips. Headshot existe sous Caitlyn, LuluFaerie et Spells avec mêmes octets ; Headshot2 a un autre contenu. Ces identités/memberships sont hérités, non redécodés. Présence de Headshot2 ne prouve pas Ready ; aucune priorité ou règle Lulu transférée. Quatre preloads ne prouvent pas ouverture, activation ou rendu.

La définition garde Headshot Marker avec espace, icône primaire et niveaux interrogés absents. Six textes en_GB hérités aux lignes 1762/1763/1979/4169/4345/9345 : @f1@, SourceName, contribution doublée en buisson, 150 % champion/250 % sbire et texte distinct « huit attaques ». Fournisseurs, articulation, catégories et politique serveur restent ouverts ; aucune valeur absente remplacée par zéro.

## 3. Consommateurs réels conservés

Six Rust relus : crates/core/src/attacks.rs, lifesteal.rs, critical.rs, vision.rs, spells.rs ; crates/client/src/projected_live.rs. Douze ancres exactes. Seize entrées réutilisées concordent : douze frontières core, deux lecteurs SOURCE, deux profils JSON ; ce ne sont pas seize nouveaux producteurs. Quatorze identités communes VFX inchangées.

advance_attacks utilise AD et critique ordinaire, avec branches Garen/Trundle, préparation et projectile ; basic_attack_hit applique Physical, vol de vie et réplique distincts. Profil et SplitMix64 reconstruit ne réalisent pas le compteur Headshot. Navigation.flags et line_of_sight exploitent le bit buisson pour la visibilité ; snapshot filtre sources/cibles selon audience. Aucun lien de comptage Headshot qualifié dans ces corps.

Effects reste générique, projected_live sélectionne Annie Q ; le compteur privé Ezreal ne devient pas Caitlyn. Recherche Caitlyn/Headshot nulle dans les six textes complets sélectionnés, sans absence globale affirmée. Les états et audiences de Headshot restent distincts du projectile ordinaire et de la visibilité générique.

## 4. Attendu, observé et contrôles

Attendu nominal statique : qualifier vues et limites, préserver routes actuelles, borner le manque d’activation/rendu. Observé : 63/63 contrôles documentaires, 44/44 cohérences séparées du même agent, douze ancres, gardes 16/14 concordantes. Refus/gardes physiques, critiques et visibilité lus, jamais invoqués ce lot. V1203 source37/consommateur23 et ancienne intégration24 hérités, non rejoués.

V560 conserve 36 lancements ordinaires, 24 impacts champion contrôlés, douze ouverts/douze depuis buisson ; flags0/1 distincts, AD brut ordinaire conservé. Douze lancements vers sbires ne sont pas douze impacts qualifiés : onze retraits/dernier en vol, dégâts nets non isolés. Les 51 refus demeurent historiques ; aucun compteur/Headshot natif qualifié. Aucun replay, build, test Rust, jeu, natif D/stat/résolution, VM/décodeur, GPU, REA, réseau ou pixels nouveau.

Réemploi documentaire ajusté : initial_scope fait 55133 octets et référence la copie externe immuable au lieu d’y incorporer tout le reçu. Identité vérifiée avant chaque lecture sémantique, témoin conservé avant consommation, même hook. Source complète accessible et contrôlée à la publication ; aucun fait supprimé pour obtenir un succès, aucun facteur d’accélération mesuré.

## 5. Écarts et inconnues

Tables Ready/missile, applicabilité, inventaire secondaire complet, recette, f1 versus huit, compteur/prêt/consommation, buisson, multiplicateurs/cibles, critique/annulation, owner/skin, audiences, pose/attache, cadence, montage et rendu ouverts. Déclarations, DDS et tirs ne suffisent pas à clore ces clauses. Inconnues VFX/SOURCE et consommateurs inscrits conservés exactement.

V1322 immuable ; zéro tâche SOURCE/SIMULATION/NETWORK/VFX complète, feature, inconnue, acceptation ou goal clos. Aucun pourcentage du jeu déduit ; contrôles aux lectures, sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Caitlyn-PASSIF-PRESENTATION-VFX : headshot-visual-source-selection, count-ready-brush-world-state-link et resource-lifecycle-render-acceptance. Objectifs, prérequis, fins et reprises dans corrections_and_restart.json ; SOURCE/NETWORK/HUD gardent leurs critères distincts.

Reprendre sur source/copie attribuable, lecteur, appel, pose, capture ou dérive pertinente. Ne pas substituer une texture générée à une recette inconnue. Prochain lot : CH-Corki-PASSIF-PRESENTATION-VFX, reçu V561 déjà conservé, distinguer RapidReload/dégâts vrais et présentation applicable.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_caitlyn_passive_vfx_20261105 : initial_scope compact, inspection, current_inspection, evidence_review, coherence_review, gardes et journaux. Sept rubriques examinées ; relecture séparée du même agent, ni revue indépendante ni acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes, sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2320 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
