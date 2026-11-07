# Amumu — Cursed Touch : sources VFX et consommateurs actuels

6 novembre 2026 · V1437 · AUD-SYS-01.2-02-AMUMU-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence et périmètre

CH-Amumu-PASSIF-PRESENTATION-VFX, OLF-d382ccf7-d480-511b-ad25-7084173474e5. Relier les effets applicables de lancement, trajet et impact aux sources et aux consommateurs réels, ou préciser le manque. D06 et prérequis hérités ; CH-Amumu-PASSIF-NETWORK reste requis. Statut a_faire, implémentation et acceptation conservés.

Audit documentaire de liaison terminé ; fonctionnalité non terminée ; vérification statique et résumés historiques hérités ; acceptation humaine non donnée. SOURCE et HUD existants ne sont pas clôturés à nouveau. Ce lot ne termine ni le passif, ni le champion, ni le goal SYS-01.2-02.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. V550 fait497345 octets, SHA105a430e2ebdb3cb975ef811d339f3443bc3fb7573e65bf847d7a496197bb174. L’identité F concorde avec la copie figée. Huit memberships natifs hérités, sans ouverture des chemins D.

Trois vues Lua littérales, sept globals, aucun prototype enfant ni code natif exécuté ici. CursedTouch158 déclare CursedTouch et SadMummy_CorpseExplosion ; Marker226 déclare CursedTouchMarker, la même icône, PersistsThroughDeath et NonDispellable. CharScript117 déclare séparément SadMummy_AuraofDespair. Aucun champ AutoBuff dans ces vues ; cette absence ne prouve pas l’absence historique de VFX. Persistance du marqueur, durée du debuff et durée d’un effet de scène restent distinctes.

Passive1 demeure absent. Anciennes valeurs20/30/40/50, niveaux1/9/17 et mana40/60/80% ne sont pas adoptés comme contrat actif. Textes1809/1810/4154 distingués : effet sur une unité, description des attaques d’Amumu et durée textuelle3s ; fournisseur f1 inconnu. Les variantes underscore/Self et NightmareBot ne sont pas des alias effectifs qualifiés.

CharScriptAmumu.preload :274 octets, SHA21ed59f1b9a6a3889a15df4b5546f25effc29796caa14c04e41df14604844ac3. Identité seule dans les reçus sélectionnés, sans contenu ou recette passive typée. Deux DDS sous Characters/Amumu/Info et Spells/Icons2D ont le même contenu :4224 octets,64×64 DXT5,mip0,SHA d1b85ca033180ad6048fb20baec839be16201022929f20c7e897f99a9b5c6a90. Memberships hérités0.0.0.40/0.0.0.25, sans priorité de résolution ni pixels rendus prouvés. Deux chemins ne sont pas deux variantes actives démontrées.

## 3. Consommateurs réels

16 Rust courants inspectés,16 ancres V550 retrouvées. La chaîne attaques → basic_attack_hit → apply_damage utilise Physical. Pénétration d’objets, mitigation magique et ajustement TrundleR existent ; ils ne constituent pas un producteur CursedTouch qualifié. Les gardes d’attaque, dégâts et pénétration sont conservées avec leurs fenêtres exactes. API de dégâts serveur et commandes publiques restent distinctes.

Les acquis partagés sont réutilisés : owner arrêtant huit handles existants, registre spatial alimenté par observations du caller, classes/résolveurs et animations ordinaires. HUD QWER et passif Ezreal ne prouvent pas un trajet propriétaire/cible Amumu. L’écart adjacent W du HUD reste hérité, sans déclarer une ressource native absente ni l’assimiler au passif.

43 comparaisons sur40 fichiers concordent :14 éléments partagés, deux animations,16 contextes HUD, dix contextes V550 et le miroir en_GB. Streaming d’identité seulement. Recherche CursedTouch/CorpseExplosion dans les préfixes de production des16 Rust : zéro hit. Conclusion bornée ; aucun chargement dynamique ou alias ailleurs exclu.

## 4. Attendu, observé et contrôles

Attendu : source → impact/état → ressource → porteur/attache/temps → rendu, ou lacune précise. Observé : déclarations et briques génériques identifiées, chaîne spécifique non établie. **31/31 contrôles documentaires,94/94 de cohérence qualifiée du même agent.** HUD hérité :30 source,20 consommateur,18 intégration,16 postpublication, non rejoués.

V550 hérité : trois cas niveau1 contre Ahri, neuf attaques aux ticks828/875/922 ; MR cible30/55/30 inchangée, y compris91 ticks après le dernier coup. Pertes physiques44.162811 ou52.435486 avec+10AD. Les100 dégâts magiques fournis explicitement par API donnent76.923080 ou64.516129 après mitigation ; ce témoin ne déclenche pas le passif. Quinze refus publics et douze refus API restent séparés. Résumés relus, sans nouveaux snapshots, calculs flottants ou runtime. Absence de proc ne qualifie pas l’expiration3s. Ancien EXE6041088/SHA06ded743 et1158 dépendances inertes.

Cinq productions réussies, une cohérence initiale échouée conservée : compteur Alistar39 distincts au lieu de40. La qualification relie les43 comparaisons aux40 chemins exacts ; seul ce prédicat change,93 autres et tous les témoins restent identiques. Les deux brouillons root d’adaptation ont échoué avant création des helpers ; originaux conservés. Tentatives de cache common.pyc absent distinguées des lectures de common.py. Recherche complémentaire AUDIT_*.md hors AUDIT_SYS01202*.md : rg1, zéro candidat, résultat nominal borné. Aucun build, jeu, natif, REA, GPU, installation ou migration exécuté.

## 5. Écarts et inconnues

Porteur/audience du marqueur et du debuff, alias, f1/paliers/ordre/cibles/refresh/fin, recette, owner/attache/temps/arrêt/skins, réseau et rendu restent ouverts. Métadonnées, mitigation générique et attente post-attaque ne les résolvent pas. Identifiants VFX/SOURCE gardés intégralement dans evidence_review. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 reste ouverte ; inventaire secondaire et applicabilité exhaustive non qualifiés. Aucune corruption ou absence d’asset déduite.

## 6. Corrections et reprise

corrections_and_restart.json décrit quatre objectifs : politique marqueur/cible/déclenchement/recette, producteur réel de réduction MR, réseau, intégration VFX. Réutiliser SOURCE, SIMULATION, NETWORK et PRESENTATION-VFX ; aucun ajout au registre. Chaque fiche possède prérequis, fin et reprise. Le chemin d’attaque réel existe ; ne pas lui substituer les100 dégâts du diagnostic ou la pénétration d’objet.

Reprendre sur source/capture/callsite nouveau ou dérive, avec autorisation distincte pour implémenter. Ne pas rejouer les neuf attaques ou les décodeurs inchangés. next_lot.json sélectionne Anivia, schéma exact lu dans son reçu figé ; aucun audit Anivia exécuté ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_amumu_passive_vfx_20261106 : scope, inspection, evidence_review, coherence_review brut/qualified, qualification du compteur, identités, corrections, reprise et journaux. Sept rubriques relues ; même agent, sans revue indépendante ou acceptation humaine nouvelle. Seul le lien borné est clôturable.

Publication limitée au rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes ; sept registres protégés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2423 entrées groupées conservées. Goal, Plan/UI, bases, code, assets et statuts inchangés.
