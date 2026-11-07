# Alistar — Trample : sources VFX et consommateurs actuels

6 novembre 2026 · V1436 · AUD-SYS-01.2-02-ALISTAR-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence et périmètre

CH-Alistar-PASSIF-PRESENTATION-VFX, OLF-eee79217-04d4-53a0-9f6d-13ab9540633f. Relier les effets applicables de lancement, trajet et impact à leurs sources et aux consommateurs réels, ou préciser le manque. D06 et prérequis hérités ; dépendance CH-Alistar-PASSIF-NETWORK conservée. Statut a_faire, implémentation et acceptation inchangés.

Audit documentaire de liaison terminé ; fonctionnalité non terminée ; vérification statique et résumés historiques hérités ; acceptation humaine non donnée. SOURCE/HUD ne sont pas clôturés à nouveau. Ce lot ne termine pas le passif, le champion ou SYS-01.2-02.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Le reçu V552 conservé fait496595 octets, SHA3a29ec4ae56390affd872a54217244bb8816168a6511b176fa05d23f3498c8ef. Son identité courante concorde avec la copie figée. Huit memberships natifs hérités ; aucun chemin D rouvert.

Deux vues Lua littérales, sept globals, sans callback enfant exécuté. AlistarTrample192 déclare Trample Buff, l’icône Minotaur_ColossalStrength et IsDeathRecapSource. ColossalStrength227 déclare Colossal Strength, la même icône, PersistsThroughDeath et NonDispellable. Les noms restent distincts ; la persistance du marqueur ne détermine pas la durée d’un effet de scène. Aucun champ AutoBuff dans ces deux vues ne prouve une absence historique d’effet.

Passive1 reste absent. Les niveaux6/12/18 et anciens textes tourelle/HP restent des métadonnées non adoptées comme contrat Trample. Texte1791 : après un sort, traversée des unités, dégâts magiques proches pendant3s, double dégâts aux sbires ; f1/f2/f3 non résolus. Les textes2782/4152 gardent leurs rôles distincts. CharScript absent du seul emplacement antérieur ne vaut pas absence globale de serveur.

AlistarTrample.preload :326 octets, SHA55ce3f5c5a0c9d83d80cea214c8a656ecd7ce2576c4cfd3646b8da0d8974407e ; identité seule dans les reçus sélectionnés, contenu et dépendances typées non disponibles ici. Deux DDS homonymes distincts sous Characters/Alistar/HUD et Spells/Icons2D :4224 octets chacun,64×64 DXT5,mip0. Les memberships hérités portent les versions0.0.1.7 et0.0.0.25 ; priorité de résolution et pixels inconnus. Aucun asset déclaré corrompu ou absent.

## 3. Consommateurs réels

16 Rust courants inspectés,18 ancres V552 retrouvées. next_rank,cast et cast_at conservent les refus Alistar dans leurs branches d’admission. Le catalogue de statistiques, les dégâts communs, le déplacement/collision et l’occupation alliée reconstruite ne fournissent pas un producteur Trample qualifié. L’état de traversée conditionnelle et son application aux unités/NPC ne sont pas démontrés par la collision ordinaire.

Dans les corps/configurations HUD déjà examinés, les sélecteurs QWER et le passif Ezreal n’établissent pas de binding Alistar. Les acquis Akali V1315 sont conservés : registre spatial alimenté par observations du caller, arrêt de huit handles d’un propriétaire actif, résolveurs/classes de particules. Ces briques et les animations ordinaires ne constituent pas un déclencheur ou renderer Trample.

43 comparaisons sur39 fichiers concordent :14 éléments partagés, deux animations,16 contextes HUD, dix contextes V552 et le texte en_GB. Streaming d’identité seulement, sans nouvelle interprétation des ressources partagées. Recherche AlistarTrample/Colossal Strength/Trample Buff/Trample dans les préfixes de production des16 Rust : zéro hit. Conclusion bornée ; un chemin dynamique ou un alias ailleurs n’est pas exclu.

## 4. Attendu, observé et contrôles

Attendu : source → état/déclencheur → ressource → attache/temps → rendu, ou lacune précise. Observé : déclarations et briques génériques identifiées, chaîne spécifique non établie dans les routes inspectées. **31/31 contrôles documentaires,94/94 de cohérence séparée du même agent.** HUD hérité :28 source,20 consommateur,15 intégration,16 postpublication, non rejoués.

V552 hérité : Alistar817→908,91 ticks après refus, rangs zéro et aucun impact ;17 refus Alistar et sept Annie. AnnieW positif au813 reste distinct de Trample. Sa baisse nette52.937927 diffère du dommage52.990158 avant régénération du tick. Résumés relus, pas de nouvelles paires de snapshots, recalcul arithmétique, mesure de3s ou test de phasing. Ancien EXE6002176/SHA08a61924 et1158 dépendances inertes.

Cinq productions réussies et un échec conservé : capture01 demandait finalpeer_review dans les stage_pins HUD, qui ne l’épinglent pas. Capture02 omet cette entrée inutile ; aucun pin inventé ni transfert de validation indépendante. Les journaux initiaux et la qualification sont conservés. L’empaquetage initial refuse de confondre les deux versions de ce script : seule l’ancienne version capture01 est reliée à sa copie conservée et au journal, sans modifier les autres gardes. Cet échec root et le script initial sont conservés. Les tentatives de cache common.pyc absent sont distinguées des lectures effectives de common.py. Recherche complémentaire AUDIT_*.md hors AUDIT_SYS01202*.md : rg1, zéro candidat, résultat nominal borné. Aucun build, jeu, natif, REA, GPU, installation ou migration exécuté.

## 5. Écarts et inconnues

Alias effectifs, déclenchement,3s/refresh, rayon/cadence/f1f2f3/cibles, traversée, recette/preload, owner/pose/temps/arrêt/skins, réseau et rendu restent ouverts. Persistance, absence AutoBuff et attente après refus ne les résolvent pas. Identifiants VFX/SOURCE conservés intégralement dans evidence_review. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 reste ouverte ; inventaire secondaire et applicabilité exhaustive non qualifiés.

## 6. Corrections et reprise

corrections_and_restart.json décrit quatre objectifs : politique des alias/déclenchement/recette, producteur Trample et traversée, réseau, intégration VFX. Réutiliser SOURCE, SIMULATION, NETWORK et PRESENTATION-VFX ; aucun ajout au registre. Chaque fiche précise prérequis, critères de fin et reprise. Un premier cas exige un vrai sort accepté, sans imposer tout le kit.

Reprendre sur source/capture/callsite nouveau ou dérive ; toute implémentation nécessite son autorisation distincte. Ne pas rejouer les refus, le census ou les décodeurs inchangés. next_lot.json sélectionne Amumu, avec schéma exact de son reçu figé ; aucun audit Amumu exécuté ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_alistar_passive_vfx_20261106 : scope, inspection, evidence_review, coherence_review, gardes d’identité, corrections, reprise, journaux et échec conservé. Sept rubriques relues ; même agent, pas de revue indépendante ou acceptation humaine nouvelle. Seul l’audit de liaison borné est clôturable.

Publication limitée au rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes ; sept registres protégés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2422 entrées groupées conservées. Le compte dégroupé13556 d’Ahri employait un autre mode Git. Goal, Plan/UI, bases, code, assets et statuts inchangés.
