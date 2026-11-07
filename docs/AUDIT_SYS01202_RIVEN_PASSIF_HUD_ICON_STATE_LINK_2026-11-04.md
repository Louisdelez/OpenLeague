# SYS-01.2-02 — Riven : Runic Blade et HUD, V1264

4 novembre 2026. Unité `AUD-SYS-01.2-02-RIVEN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre. Implémentation, vérification du gameplay et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Riven-PASSIF-PRESENTATION-HUD`, `OLF-a97117b7-9604-5ad0-9374-e18321d210f7` : relier icône, texte, rang applicable, charges/bonus et consommation aux consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-013a4df9-92fe-53f9-98b7-afd909b270ab` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE conservés. Phase D06, lot D06-CH-Riven et prérequis consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/riven-passive-runic-blade-links-v620.json`,2757887octets,SHA `35ef0e912d1e284dcf7297d1bb1c94918f4205b54efef5432a6c56b3974303c5`,UTC documentaire 2026-10-26T14:49:59.674663+00:00,sans attribution à une heure d’exécution.

HUD :deux sources/un catalogue. SOURCE :72relations/66identités,six sites/trois fichiers. V620 :66sources/198associations,26sites/52liens/12fichiers. Union :14fichiers/32ancres. Aucun ID SOURCE supplémentaire. Métadonnées réutilisées sans réouverture D :19INIBIN,28Lua,17preloads,DDF et font.

Définition :RivenPassive/RivenRunicBlades.dds. Buff :RivenPassive,persistance/non-dissipation,sans BuffTextureName déclaré. Description4267 :les capacités chargent la lame,jusqu’à trois charges,une consommée par attaque avec bonus physique. Buff2558 garde f1%,f2bonus,f3plafond ;AABoost2559 décrit prochaine attaque renforcée. Producteurs dynamiques et durée non résolus. Passive1/description absents,niveaux1/4/7 puis absents,non adoptés comme progression complète.

PARType=None,BaseMP0,régen0 :absence de mana,distincte des charges.28Lua :20littéraux/huit limites NEWTABLE ;CharScripts natif56octets/communautaire vides,six BuffData exactement résolus. AABoost595octets conserve constantes AutoCooldownByLevel22/18/14/10/6 et RivenRunicBlades.dds,mais littéraux non qualifiés à NEWTABLE. Ces valeurs ne deviennent ni durée ni bonus. Drapeaux et préchargements ne prouvent pas les callbacks.

Neuf entrées de métadonnées croisées Akali/Renekthon,Ezreal,Minotaur conservées sans mécanique adoptée. DDF16lignes,six liaisons QWER non vides :Q ADtotal0,4→0,6,W/E bonusAD1,R bonusAD0,6/1,8/0,2. Aucun binding numérique du passif. Quatre candidats absents ne prouvent aucun manque global/corruption.

24références communautaires comparatives :Q cône sans combo/dash qualifiés,W ratio0,8 contre DDF1,E délégation2,5s contre texte1,5s,R bonusADbase/WindSlash immédiat. Absence de référence Runic dans les quatre fichiers lus,sans absence globale ni serveur original prouvé.

Deux DDS nécessaires,5744octets/un contenu,2872octets chacun,64×64 DXT1/mip7 :Characters/Riven/HUD/Icons2D membre0.0.0.191 ;Spells/Icons2D membre0.0.0.45. SHA communff0d2eca71182e842cffff3b2fe4f2f2503bd81c52b997dc1a9d8e19d64ea760,MD5 676aeb4336a6351e45038a48fe3015ed. Taille/MD5 concordent au manifeste lol_game_client0.0.1.7,sélection E avant deux lectures SOURCE. Lookup/pixels/variante ouverts. Font miroir inchangé,témoin Ahri réutilisé.

None courant concorde au PARType natif ;source_sha256 est celui du JSON communautaire4092octets/SHAa2880c550a3dad8d16b810b4feb73edf5bdf40114642abc3bc5b993ffa314373,distinct de l’INIBIN natif1155octets/SHA395c34676cc5f64511d94c220b8c5db20e4f947fc2ebce2f3f0f28fac6003a6d (`resource_provenance.json`).

## 3. Consommateurs actuels

32ancres exactes,16entrées communes et27fichiers code/configuration vérifiés. Aucun producteur Riven/Runic identifié dans ces Rust,sans absence globale revendiquée. Attacks/lifesteal/damage consomment l’AD ordinaire,progression/objets expliquent le contrôle Épée. HUD bars/widgets n’affiche de ressource/MPStat que pour Mana :acquis None conservé,ce n’est pas un compteur Runic. Icône/texte/charges et bonus propres non qualifiés ;module Ezreal non substitué.

## 4. Attendu et observé

Attendu :capacités admissibles produisant des charges,bonus physique/consommation et HUD attribuables. V620 :deux cas base/Épée1036+10AD,niveau1. Douze mêlées ordinaires,trois+puis trois par cas,54refus,362ticks d’attente,quatre trajets aboutis sans reprise. Cinq échantillons statistiques,un cycle achat/vente/rachat :AD56,04/66,04/56,04/66,04.

RawAD×100/(100+armureAnnie19,22) concorde aux douze attendus/observés,tolérance0,002PV. Observés47,00552368–47,00553894 ou55,39338684–55,39340210. Écart Épée conforme à l’AD générique. Aucun sort Riven accepté ;production/consommation/expiration et bonus de charges non exercés. Ressource0/max0 ne donne aucun compteur de charges ;181ticks d’attente/cas ne prouvent pas l’expiration d’un état jamais produit.

Premier contrôle documentaire48/50 conservé :deux prédicats exigeaient une égalité stricte entre dégâts dérivés. Toutes les comparaisons individuelles au modèle ordinaire avaient déjà passé0,002 ;variation maximale observée0,00001526PV. Qualification limitée à cette tolérance déjà déclarée,deux prédicats corrigés,autres48contrôles identiques ;script/résultat/logs/entrées initiaux conservés. Libellé ULP remplacé par borne mesurée,sans changement de prédicat ni nouvelle exécution.

PV cible adjacents avant/après non sauvegardés,dégâts dérivés hérités ;refus :flags sans snapshots bruts. Soins/healing_checked false non qualifiés ;aucune garde NPC universelle. Deux profils,une cible,aucune transition de charge démontrée.

Historique15fichiers/10400614octets,13ancienshashes concordants/deux identités de reçus nouvelles. Binaire6075904octets/SHAc0729e20f5f1d3b8968e2cf82776d18ed28c115f259f78e7fcf72392e23b84b7,inerte ;BUILD/RUN bruts0,inspection numérique héritée. Contrôles qualifiés50/50,cohérence séparée50/50,même agent. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Sorts/événements admissibles,Qrecasts/R,plafond/rafraîchissement,producteurs f1/f2/f3,progression/durée et consommation lancement/impact ouverts. Critique/on-hit/boucliers/immunités,cibles multiples,interruptions,mort/respawn,lookup/affichage et transport non qualifiés. QWER distincts ;V564 et deux échecs Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Riven-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-RIVEN-RUNIC-POLICY-01` :qualifier événements,formule/progression,durée,cap/rafraîchissement et consommation. Fin :contrat4.20 sourcé,sans AutoCooldown ou niveaux arbitrairement affectés.

`COR-RIVEN-RUNIC-ONHIT-01` :implémenter génération depuis vrais sorts et consommation/bonus au bon événement. Fin :0/1/2/3/au-delà,attaques successives,refus/interruptions,critique/boucliers/cibles,mort/respawn et échéances vérifiés.

`COR-RIVEN-RUNIC-HUD-01` :afficher compteur propre,icône/texte/bonus/prêt et transport. Fin :transitions0–3 attribuables,f1/f2/f3 résolus,absence de mana conservée. Reprendre sur nouvelle preuve,mapping/callsite,dérive ou autorisation d’implémenter ;aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_riven_passive_hud_20261104` ;evidence_review48/50,qualified50/50,coherence_review50/50,qualification/archives,DDS/histoire,resource_provenance.json,phase_package_prerequisites.json et journaux. Captures avant assertions,hook7/7 réutilisé ;limites Python/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement ;sauvegardes et sept protégés vérifiés avant/après publication. Une unité d’audit bornée close ;zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ;goal/Plan/UI/bases/registres/produit inchangés.
