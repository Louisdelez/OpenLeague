# Passifs — couverture des reçus de sources secondaires

2026-11-05 · V1322 · AUD-SYS-01.2-02-PASSIF-VFX-SECONDARY-SOURCE-COVERAGE-01

## 1. Exigence et périmètre

SYS-01.2-02, OLF-3a11ace9-485c-55ae-8dff-2533902a5839. Rapprocher les122IDs CH-*-PASSIF-PRESENTATION-VFX de leurs reçus SOURCE existants et recenser les déclarations reconnues Effect/Event/attaches, ou une limite explicite du format. Exclusions : inventaire natif exhaustif, applicabilité,122audits individuels, ouverture des ressources et rendu. Phases, lots, dépendances et contrats hérités du snapshot gelé conservés ; aucun prérequis accepté implicitement.

Audit de cette consolidation clôturable après publication vérifiée. Implémentation non modifiée ; vérification documentaire ; acceptation humaine non donnée. Source, tâche VFX, fonctionnalité et goal restent ouverts.

## 2. Sources, identités et provenance

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement non établis, catalogue4.20.1 distinct. V1314 fournit122IDs et les frontières V669121+V668Annie ; V1321 fournit le dernier périmètre Aatrox vérifié. Aucun accès au corpus natif D.

Les recherches SOURCE enregistrées désignent125JSON spécifiques pour115champions. Sept cas anciens suivent des preuves nommées : AatroxV456, Annie/source+V668, Ashe/TryndamereV537, EzrealV665 réseau/contextuel, Garen/source_audit, YasuoV536. Ils ne sont pas promus arbitrairement en inventaires complets. Neuf champions ont plusieurs reçus ; toutes les versions sélectionnées sont conservées.

Résultat :132documents distincts,133associations,240276124octets, tous JSON analysables. Lecture F une fois par document avec rétention avant consommation. Relecture sémantique sur les mêmes132copies E, SHA vérifié avant interprétation, sans seconde copie de ces240Mo. Provenance et pointeurs exacts dans coverage_result.json et captured_receipt_views.json.

## 3. Consommateurs et acquis réutilisés

Les consommateurs enregistrés de chaque ID sont conservés dans chaque ligne ; aucune association ajoutée au registre. Quatorze identités courantes des mécanismes V1315 sont inchangées : résolution/classe, propriété/stop, attache/spatial, projection, Annie et catalogues Map10. Réutilisation des observations bornées, sans nouveau recensement des498Rust ni réaudit individuel.

Le résolveur de noms n’est pas un ouvreur universel Troybin ; matrice fournie par l’appelant, owner/stop et catalogue ne produisent pas les états passifs. Route Annie partielle conservée. V669 décrit des champs primaires, pas toutes les recettes de buffs ; les acquis Maokai/Quinn/Thresh et les limites Yasuo/Aatrox ne sont pas effacés.

## 4. Attendu, observé et vérifications

Attendu :122lignes identifiables avec toutes les versions, valeurs typées, provenance, limites et reprise. Observé :103lignes avec vues reconnues partielles, six avec vues reconnues et contexte supplémentaire non mappé,13sans vue mappée par ces adaptateurs. Aucun de ces états ne prouve une absence native.

2348vues de chunks reconnues ;695champs AutoBuff sur72champions :417Effect,267attaches,11Event. Ce sont des vues de reçus, parfois QWER/contextuelles, pas695assets ni effets appliqués.29groupes de vues de même chemin/identité fournie se recouvrent, sans divergence de globals ; identités manquantes non dédupliquées comme faits natifs.

16/16contrôles de consolidation et28/28de cohérence séparée du même agent réussissent. La relecture contrôle les132SHA,2348pointeurs et les valeurs/types ; cas Maokai, Event Quinn, attache3 Thresh sans Effect3 inventé, limite Yasuo et ancien format Aatrox conservés. Zéro erreur de mapping dans les chunks reconnus ;20vues de reçus non mappées restent explicitement partielles.14/14identités communes concordent. Aucun build, test Rust, jeu, GPU, REA, sonde, décodage natif ou réseau rejoué.

## 5. Écarts et limites

Sans vue mappée ici : Annie, Ashe, Blitzcrank, DrMundo, Ezreal, Galio, Garen, Trundle, Tryndamere, Vladimir, Volibear, Warwick, Yasuo. Le document existe mais son format ne fournit pas à cet adaptateur un inventaire qualifié. Pour les109autres, les déclarations reconnues restent partielles ; absence d’AutoBuff ne signifie pas absence d’effet. Les limites des lecteurs, globals, champs Event seuls et attaches seules sont conservés. Métadonnées ne prouvent ni trigger, application au passif, priorité de skin, ressource physique, montage, rendu ou acceptation.

Zéro clôture individuelle, SOURCE complète, tâche VFX complète, inconnue ou fonctionnalité. Seule la table de couverture bornée est clôturée. Identités vérifiées aux lectures, sans garantie globale contre toute modification concurrente. Aucun facteur de vitesse avant/après mesuré.

## 6. Corrections et reprise précise

Réutiliser COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 et les tâches existantes par champion. La table et les pointeurs suppriment la nécessité de relire chaque reçu pour retrouver les mêmes déclarations. Les écarts fonctionnels déjà décrits restent ouverts, sans nouvelle tâche de remplacement ni modification des bases.

Prochain lot : CH-Annie-PASSIF-PRESENTATION-VFX, projection documentaire des formats annie_passive_sources.json et V668. Fin : qualifier leurs enregistrements explicitement retenus, séparer base/ready2 et lecture partielle, relier aux acquis consumers existants ; source introuvable ou portée insuffisante décrite précisément. Réutiliser les copies E épinglées ; aucun inventaire natif complet inventé. Ensuite sélectionner une seule question de consommateur/applicabilité à partir de la table. Une nouvelle source, dérive, anomalie ou hypothèse nommée justifie seule une recherche inchangée.

## 7. Livrables et cohérence

Preuves E:/mapslol3v3/audit_sys01202_passive_vfx_secondary_coverage_20261105 :coverage_122.md, coverage_result.json, source_receipt_selection.json, captured_receipt_views.json, coherence_review.json, journaux et témoins. Sept rubriques relues ; contrôle séparé du même agent, non revue indépendante ni acceptation humaine.

Publication limitée au présent rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes. Sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2309entrées sales groupées préexistantes conservées. Goal/Plan/UI/bases/produit/assets inchangés. Aucune installation, migration, relance, nettoyage ou mutation Git.
