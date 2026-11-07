# SYS-01.2-02 — Singed : Empowered Bulwark et HUD, V1271

4 novembre 2026. Unité `AUD-SYS-01.2-02-SINGED-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Singed-PASSIF-PRESENTATION-HUD`, `OLF-d46b492c-9e0b-5607-9323-5c16d8c70284` :relier icônes/texte et conversion mana→PV aux consommateurs statistiques/HUD. Contrat a_faire,implémentation/acceptation false,dépendance NETWORK ;inconnue `OLU-d21b3a35-bf78-57a2-b8e9-29ac0bdc29a7` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/lot D06-CH-Singed consultés,sans satisfaction revendiquée. Parent PRESENTATION,goal etQWER distincts restent ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315,EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus,catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/singed-passive-empowered_bulwark-links-v628.json`,5800797octets,SHA `56ac3b2da2856a917b7b7d2344f59f5b65ffa760c961d112d5d0470b62024d67`,UTC documentaire 2026-10-26T17:13:41.756911+00:00. V627 conservé,3423295octets,SHA `47e1751e8bb30ba73a6b236ec708328a400485d03a140f9bd7a144ddccecda3d`,UTC 2026-10-26T16:58:44.934328+00:00. Ces dates ne sont pas celles d’exécution.

HUD enregistré :une définition/un catalogue. SOURCE42relations/33identités,six sites/trois fichiers. V62732membres/26consommateurs,V628ajoute un membre/un consommateur ;union27entrées de frontière,14fichiers/32ancres uniques,33entrées avec répétition inter-scope. Aucun ID SOURCE supplémentaire. Le delta V628 seul n’est pas l’inventaire complet.

Définition Passive1LuaName="Empowered Bulwark",icône Singed_Passive.dds ;buff même nom,icône ChemicalMan_EmpoweredBulwark.dds,persistant/non-dispellable déclarés. PARType et Passive1/six niveaux absents ;héritage réduction magique10% non adopté. BaseHP542.7600098,MP290.6000061,AD62.3199997.

`DATA/Spells/Empowered Bulwark.inibin` avec espace :49octets,SHA `eb11bb5565c765bfc640a20a7c01748247d05ddc034604fb6b31f2a584b33809`,MD5 `47e4330dece12bb276e6803e2bc98716`,OLS-3fb3ed7a-abfc-5330-bb2e-5e54f6dd709a,manifeste0.0.1.7/membre0.0.0.120. Champ2287725201 lie exactement game_buff_tooltip_Empowered_Bulwark. V628 corrige le filtre V627 ;fichier déjà cité dans V543,aucune nouvelle absence globale résolue.

Font1867 :f2PV pour f3mana,bonus affiché f1. Description4277 :25PV pour100mana. Producteurs f1/f2/f3,assiette mana courant/maximal/bonus,arrondis et adaptation des PV courants inconnus ;texte ne prouve pas la formule serveur complète. Deux BuffData exactement résolus,aucun alias automatique.

Métadonnées héritées :10INIBIN,14Lua dont trois limites NEWTABLE,huit preloads,font,aucun DDF dans le dossier sélectionné. CharScript vide56octets dans Scripts ;sorts globaux DATA/Spells. Cinq chemins candidats absents,dont EmpoweredBulwark.inibin sans espace,ne contredisent pas le fichier avec espace. Persistance/preload/noms ne prouvent pas callbacks/provider/lifecycle. Quinze références communautaires comparatives V62714+V6281,divergences Qcinq pulses/Wslow/Ethrow-root/Rcommentaire-formule conservées ;EFlashLock/Haste ne qualifie pas Flash.

Deux DDS nécessaires,6400octets/deux contenus :

- `DATA/Spells/Icons2D/ChemicalMan_EmpoweredBulwark.dds` :4224octets,64×64 DXT5/mipbrut0,membre0.0.0.25,SHA `41d0b90ca53bbfd79c93d0c6fe94cae3ffabdf9af9879c8ef52f6f22f7afbf15`.
- `DATA/Spells/Icons2D/Singed_Passive.dds` :2176octets,64×64 DXT1/mipbrut0,membre0.0.1.2,SHA `709a45fffa244c96a2e21ab16397fb48418ebe754033d227cb104c88614c07b4`.

Tailles/MD5 concordent au manifeste ;sélection E avant deux lectures SOURCE,Icons2D partagé uniquement. Aucun autre DDS ni métadonnée native relu,font miroir inchangé/témoin Ahri réutilisé. Lookup/provider/pixels ouverts.

Ressource courante Mana :source_sha256 correspond au StatsJSON communautaire 8122octets/SHA `1b1345f657040666e5231ac1bef7b5d07ad64d240c0332499521527ca0398350`,distinct de Singed.inibin 3060octets/SHA `584bdbd039a18e0d4cd1607fcb1e30e50c60e993859033ae3891157432b451cc` (`resource_provenance.json`). PARType natif absent n’est pas une chaîne Mana.

## 3. Consommateurs actuels

33entrées d’ancre concordantes/32uniques,16entrées communes et27fichiers code/configuration vérifiés. Aucun producteur nommé Singed/EmpoweredBulwark dans les Rust sélectionnés,recherche bornée. Progression.rs:117 calcule max_health=base.health+croissance+items.health ;mana calculé séparément,aucune conversion trouvée sur cette route. Boutique/synchronisation/snapshot et régénération génériques conservés.

Native_hud_bars.rs:10–11 calcule fractions santé et Mana depuis capacités snapshot ;widgets.rs:91 produit MPStat. Ces chemins génériques affichent les pools transmis,sans établir bonus passif,icône/texte/paramètres ni fidélité visuelle.

## 4. Attendu et observé

Attendu :conversion sourcée,variation PV attribuable au mana,bindings HUD corrects. Réutilisation V627 :profils base/Rubis1028+150PV/Saphir1027+200mana,18mêlées,543ticks d’attente,81refus,six trajets sans reprise,neuf relevés boutique/six transactions achat/vente/rachat.

MaxPV/mana :542.7600098/290.6000061 ;692.7600098/290.6000061 ;542.7600098/490.6000061. Rubis augmente les PV,Saphir augmente le mana sans hausse PV dans ces cas. Achats n’emplissent pas immédiatement les pools courants ;trajet remplit le mana avant idle. Les181échantillons/cas sont déjà au plafond :régénération sous plafond non exercée. Dégâts52.2731018 ordinaires recalculés,tolérance0.002. Aucun sort Singed accepté,rangs/délais propres zéro ;formule/lifecycle non qualifiés.

Deux relectures V627/V628 égales au JSON brut du même RUN. BUILD/RUN bruts0,binaire 6093824octets/SHA `3df7aa3c4b60261180b36d1f8331e2be7f37dbec7f78b22635c12a0cad572438` inerte. Collecteur initial1 :hypothèse erronée de mana sous plafond ;ancien script/échec conservés,lecture corrigée sans nouveau jeu. Anciens CHECK/CHECK_PREVIEW1 conservés,sans nouvelle mutation du suivi. Historique20fichiers/19183095octets,18anciennes empreintes concordantes/deux identités nouvelles.

Contrôles72/72,cohérence séparée60/60,même agent ;pas revue indépendante. Dégâts dérivés sans paires PVcible adjacentes brutes,soin nonqualifié,refus par flags ;aucune garde NPC universelle. Aucun nouveau build/jeu/VM/REA/rendu/GPU/réseau ni validation humaine.

## 5. Écarts et inconnues

Conversion absente de la route maxPV inspectée ;f1/f2/f3,assiette/arrondis/croissance/ordre/overflow,PVcourants et lifecycle,provider espace/non-espace,bindings/rendu/transport restent ouverts. QWER,V564/Nami distincts.

## 6. Corrections et reprise

Réutiliser les tâches existantes SOURCE/SIMULATION/NETWORK/HUD. `COR-SINGED-BULWARK-POLICY-01` :qualifier assiette,ratio/paramètres,arrondis,ordre et lifecycle. Fin :contrat4.20 sourcé,inconnues explicitement bornées,sans transformer le texte25/100 en exécution serveur.

`COR-SINGED-BULWARK-HEALTH-01` :produire la conversion dans la route autoritaire. Fin :base,bonusmana,achat/vente/rachat,croissance,variation des PVcourants,mort/réapparition et frontières vérifiés selon politique qualifiée ;conserver Rubis et Saphir comme contrôles,aucun doublebonus.

`COR-SINGED-BULWARK-HUD-BINDINGS-01` :relier les deux icônes,texte et f1/f2/f3 à l’état autoritaire. Fin :noms/providers exacts,transitions/transport et pixels observés. Reprendre sur nouvel artefact serveur/mapping/callsite,dérive ou autorisation fonctionnelle ;aucune correction produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_singed_passive_hud_20261104` :evidence_review/coherence_review,resource_provenance.json,phase_package_prerequisites.json,DDS/histoire et journaux. Recherche utilisateur appliquée :cache partagé et exécution héritée réutilisés,pas de nouvelle consolidation globale ni installation ;gain global non mesuré. Hook7/7 réutilisé,limites Python/contexte/TOCTOU déclarées.

Rapport et deux ajouts CURRENT/HANDOFF uniquement,sauvegardes exactes/sept fichiers protégés contrôlés. Une unité documentaire close ;zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés,SYS-01.2-02 actif.
