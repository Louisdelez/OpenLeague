# Passifs VFX — douze projections documentaires rapprochées

6 novembre 2026 · V1444 · AUD-SYS-01.2-02-PASSIF-VFX-REMAINING-PROJECTION-FRESHNESS-01

## 1. Exigence et périmètre

SYS-01.2-02, OLF-3a11ace9-485c-55ae-8dff-2533902a5839. Contrat V1443 : comparer les douze classes restantes « sans vue mappée » aux preuves individuelles déjà publiées ; une correspondance ou un manque précis par ID, sans nouveau décodage natif. Les122paires d’IDs et les décisions fonctionnelles restent conservées.

Rapprochement documentaire terminé ; implémentation non modifiée ; vérification de métadonnées/identités ; acceptation humaine non donnée. Aucun des douze audits individuels n’est clôturé à nouveau. Les fonctionnalités VFX et le goal restent ouverts.

## 2. Sources et provenance

Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Base V1443result208cf755,overlay documentaire104partielles/12sansmapping/6contextesadditionnels,avec Annie déjà rapprochée. Snapshots V1322/V1442/V1443 conservés.

Douze couples source/preuve attribués :Ashe,Blitzcrank,DrMundo,Ezreal,Galio,Garen,Trundle,Tryndamere,Vladimir,Volibear,Warwick etYasuo. initial_scope.json contient les IDs,SHA,pointeurs,rapports et reçus exacts. Pour chacun,publication/rapport/preuves actives et gates historiques relus ;les analyses natives et scènes historiques ne sont pas rejouées.

Les origines sont distinctes :certaines vues sont relues dans le reçu sélectionné ;d’autres sont présentes seulement dans la projection individuelle publiée,avec identité chemin/SHA concordante dans l’ancien reçu. Cette seconde origine n’est pas présentée comme une affectation relue dans le reçu ancien. Aucun D,F-work ou EXE ouvert.

## 3. Consommateurs et vues réutilisées

Le normaliseur documentaire reconnaît les formes déjà qualifiées :Focus/CharScript,globals plats,client_lua normalisé,selected_chunks et contextes de constantes. Il ne décode ni n’exécute de Lua. Les producteurs individuels et le projecteur V1322 sont identifiés ;leurs fichiers restent conservés.

Résultat :26vues,62globals qualifiés dans leur périmètre,avec identités et pointeurs. Garen apporte quatre contextes de constantes,avec globals inconnus,et non quatre règles serveur. Blitzcrank ManaBarrier actif conserve la limite NEWTABLE atpc8 ;son dictionnaire vide issu du lecteur ne devient pas une preuve d’absence d’affectations. Les deux autres vues de Blitzcrank restent distinctes.

Vingt-huit correspondances de pointeurs sont vérifiées :15renvois vers une projection publiée,5vues plates,1contexte limité du lecteur,4contextes de constantes et3références littérales/normalisées. Ce sont des références,avec répétitions possibles d’une même vue ;pas28vues natives nouvellement acquises. Noms,casse et chaînes restent littéraux.

Quarante-quatre fichiers courants sélectionnés,5005910octets,correspondent sans dérive ou conflit :reçus et consommateurs hérités. Ce contrôle d’identité ne démontre pas une exécution actuelle ou une absence globale de producteur VFX.

## 4. Attendu, observé et contrôles

Attendu :supprimer les faux manques de cartographie en réutilisant les preuves,et conserver les vrais manques de contenu. Observé :onze lignes référencent des vues partielles d’affectations ;Garen est explicitement classé « contexte sans affectations ». **44/44 contrôles documentaires,107/107 cohérences du même agent.** Un pointeur invalide est refusé ;un SHA altéré ne rejoint pas l’identité originale.

L’overlay devient115vues partielles,1contexte sans affectations et6contextes additionnels non mappés. Les110autres classes sont exactement conservées,Annie comprise. Zéro classe initiale « sans vue mappée » ne signifie pas couverture native exhaustive.

Sept productions journalisées :quatre réussies,trois arrêts conservés. Bootstrap01 supposait deux champs d’inconnues absents de l’ancien schéma Yasuo :les IDs sont joints à la ligne V1442 exacte,le registered_trace Yasuo confirme les IDs VFX. Projection01 supposait les globals présents dans le reçu Ashe ;projection02 supposait le chunk Blitzcrank plat. Les versions corrigées attribuent la provenance et la limite explicitement. Scripts,erreurs,journaux et différences exactes sont conservés ;aucun échec réécrit en succès.

Aucun build,jeu,décodeur natif,REA,GPU,capture graphique,installation ou migration. Les gates individuelles historiques ne sont pas exécutées à nouveau.

## 5. Écarts et inconnues

Les limites et inconnues des douze unités restent intégralement conservées. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 reste ouverte. Les six contextes additionnels,les affectations/politique natives de Garen,recettes,callbacks,états/réseau,variants,attaches,audiences,rendu et acceptation restent à qualifier dans leurs périmètres.

Une identité n’est pas un corps serveur ;un global déclaré n’est pas une sélection de ressource ;une constante n’est pas une affectation. Le supplément publié ne complète pas rétroactivement le contenu de l’ancien reçu. Aucun asset n’est déclaré manquant ou reconstruit depuis ces classifications.

## 6. Corrections et reprise

corrections_and_restart.json conserve les limites par ID et réutilise les corrections individuelles. Deux objectifs restent précis :les contextes secondaires additionnels et la vue d’affectations Garen. Cette dernière nécessite une source attribuable avec affectations/corps serveur ou un contrat explicite ;les constantes seules ne suffisent pas.

next_lot.json sélectionne les six contextes additionnels :Jax,Malphite,Nasus,Rammus,Shen,Singed. Comparer leurs schémas et preuves publiées en un lot,une ligne par ID ;conserver les116autres classes. Réutiliser d’abord les vues existantes ;reprise sur dérive,nouveau callsite/source/capture ou différence de schéma nécessaire. Aucun statut fonctionnel ou registre modifié.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_remaining_passive_vfx_projections_20261106 :contrat,scope,12résultats,overlay122classes,identités,contrôles,cohérence,qualifications des schémas,corrections et reprise. Rapport relu en sept rubriques par le même agent,sans revue indépendante ou acceptation humaine.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF avec sauvegardes exactes ;sept registres protégés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2430entrées groupées conservées. Goal,Plan/UI,bases,code,assets et statuts inchangés. Seul ce rapprochement de projections est clôturable ;aucun pourcentage de jeu terminé ou gain de vitesse déduit.
