# Corki — sources et consommateurs des VFX de RapidReload

2026-11-05 · V1334 · AUD-SYS-01.2-02-CORKI-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Corki-PASSIF-PRESENTATION-VFX, OLF-623c38da-64f8-5c9d-8b63-4874e554dd92. Relier les déclarations RapidReload et les consommateurs courants, en distinguant tirs ordinaires, dégâts vrais, HUD et QWER. Contrat : lancement/trajet/impact applicables ; dépendance CH-Corki-PASSIF-NETWORK et prérequis D06/lot conservés, sans satisfaction implicite.

Fin du présent audit : source/identité/portée, chemin actuel ou manque borné, contrôles et corrections précis. Audit documentaire terminé après publication vérifiée ; acquis génériques conservés, déclencheur/rendu spécifique non établi dans ce périmètre ; vérification statique, acceptation humaine non donnée. Inventaire VFX complet et exécution graphique exclus. HUD et diagnostics antérieurs non recomptés.

## 2. Sources, déclarations et limites

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Reçu V1322 corki-passive-rapidreload-true-damage-links-v561.json : 534532 octets, SHA 596b85754104799c2e5ae085536e11f9b01cae9ef9a20ca92694c9efa561a21a. Copie externe immuable vérifiée avant chaque interprétation ; document complet accessible sans incorporation au cadrage de 45698 octets. Même hook, aucun facteur de vitesse mesuré.

/native_metadata/client_lua conserve deux chunks entièrement lus structurellement/littéralement, sans prototype enfant. RapidReload.luaobj : 213 octets, SHA 7ccb2efbdd14c9859a94857420cafb7a23ce0804d57bede2890d5e9eca582ad0, neuf instructions. Quatre globals qualifiés : BuffTextureName=Corki_RapidReload.dds, BuffName=RapidReload, PersistsThroughDeath=true, NonDispellable=true, témoins PC1/3/5/7. Symboles moteur non résolus, aucun corps serveur exécuté. CharScriptCorki, sous Scripts : 56 octets, une instruction, globals vides qualifiés. Aucun AutoBuff dans ces vues, sans absence native d’effet déduite.

La définition et le buff concordent. Passive1 absent reste absent ; Passive1Desc contient l’ancienne phrase Annie « Every 5 spell casts… ». Valeurs 1/4/7/"10"/13/16 conservées avec leur type, sans politique de rang Corki déduite. Déclarations de persistance/dissipation et preload ne prouvent aucune exécution ou recette visuelle.

V1206 identifie deux DDS Info/Spells, même contenu SHA 9858f3f2ad8518e0c21d0ff4e7fec9799deb3e313910aec10278713c2e108ba1, 4224 octets, 64×64 DXT5, membre0.0.0.25 du projet0.0.1.7. Identités/membership hérités, non relus sur D ni redécodés ; priorité, sélection et pixels restent ouverts. Trois textes en_GB 2510/4176/4352 décrivent le bonus vrai de 10 % AD total, structures exclues, puis sbires/monstres/champions et le nom. Ce texte ne détermine pas un effet ou le moment d’échantillonnage AD.

## 3. Consommateurs actuels conservés

Six Rust relus : crates/core/src/attacks.rs, lifesteal.rs, damage.rs, critical.rs, spells.rs ; crates/client/src/projected_live.rs. Douze ancres exactes. Seize entrées héritées concordent : onze core, deux lecteurs SOURCE, trois entrées HUD ; quatorze identités communes VFX inchangées. Ce ne sont pas seize nouveaux producteurs.

L’attaque et basic_attack_hit transmettent le tir Physical ordinaire ; profils/critique et branches d’autres champions ne produisent pas RapidReload dans les corps inspectés. mitigate possède DamageKind::True→raw, avec gardes d’entrées ; apply_damage applique génériquement les dégâts et capture/commit le récapitulatif. Ni la fonction arithmétique, ni l’API d’événement, ni le récapitulatif ne réalisent le déclencheur Corki ou une particule du passif.

La première fenêtre damage s’arrêtait sur cfg(test) d’un helper précoce. Collecte/relecture utilisent explicitement le texte complet, dont mitigate/apply_damage au-delà de cette annotation ; aucune absence déduite du préfixe court. Effects reste générique, projected_live sélectionne Annie Q. Recherche Corki/RapidReload nulle dans les six textes complets, sans absence globale affirmée. Contexte du recap HUD V1206 conservé, sans nouvelle qualification UI/rendu.

## 4. Attendu, observé et contrôles

Attendu nominal statique : qualifier quatre littéraux et limites, préserver chemins True/Physical, borner le manque visuel. Observé : 61/61 contrôles documentaires, 48/48 cohérences séparées du même agent, douze ancres et gardes 16/14 concordantes. Gardes de dégâts/cibles et routes lues, jamais invoquées ce lot. V1206 source49/consommateur33/intégration30 hérités, non rejoués.

V561 conserve quatre cas : 18 impacts champion et deux tourelle physiques seulement, 68 refus. AD51.24/61.24 et armure27.536/42.536/67 expliquent la composante ordinaire ; bonus attendu du texte non observé. Le cas structure ne prouve pas l’exclusion d’un passif absent aussi sur champion. Sbires/monstres/autres structures restent non exercés dans ce diagnostic.

Huit anciens écarts de messages boutique sont préservés : outside allied shop précède objet/slot. Leur correction est une analyse seule, commandes non réexécutées ; wrapper et échec antérieurs conservés comme données inertes. Trois contrôles mitigate100True et trois refus sont pure arithmétique, sans apply_damage ni déclenchement Corki revendiqué. Aucun replay, build, test Rust, jeu, natif D/stat/résolution, VM/décodeur, GPU, REA, réseau ou pixels nouveau.

## 5. Écarts et inconnues

Applicabilité, inventaire secondaire complet, recette, déclencheur/AD/ordre/cibles/critique, owner/skin, audiences, pose/attache, cadence, montage, persistance et cycle rendu ouverts. Dégâts vrais, icône, preload ou montant « Brut » du recap ne suffisent pas à clore ces clauses. Inconnues VFX/SOURCE et consommateurs inscrits conservés exactement.

V1322 immuable ; zéro tâche SOURCE/SIMULATION/NETWORK/VFX complète, feature, inconnue, acceptation ou goal clos. Aucun pourcentage du jeu déduit ; contrôles aux lectures, sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Corki-PASSIF-PRESENTATION-VFX : rapidreload-visual-applicability-source, passive-hit-true-damage-world-link et resource-lifecycle-render-acceptance. Objectifs, prérequis, fins et reprises dans corrections_and_restart.json ; SOURCE/NETWORK/HUD gardent leurs critères distincts.

Reprendre sur source/copie attribuable, lecteur, appel, pose, capture ou dérive pertinente. Ne pas substituer une texture générée à une recette inconnue. Prochain lot : CH-Darius-PASSIF-PRESENTATION-VFX, reçu V562 conservé, distinguer Hemorrhage, dégâts périodiques/vitesse et présentation.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_corki_passive_vfx_20261105 : initial_scope compact, inspection, current_inspection, evidence_review, coherence_review, gardes et journaux. Le sous-reçu HUD courant est choisi par chemin exact ; archive homonyme conservée séparément. Sept rubriques examinées ; relecture séparée du même agent, ni revue indépendante ni acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes, sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2321 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
