# Annie — contrat connu de Pyromania et limites de la reconstruction

6 novembre 2026 · V1453 · AUD-SYS-01.2-02-ANNIE-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et frontière

CH-Annie-PASSIF-SIMULATION-CONTRAT, OLF-85ac147c-f5bc-530f-b68f-13154bbc9b71, parent SYS-01.2-02. Décrire les branches connues, l’implémentation partielle réellement présente et les écarts restants. **Audit borné terminé ; tâche complète et fonctionnalité ouvertes.** Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Aucune modification du produit ou des registres.

## 2. Sources et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et déploiement inconnus ; catalogue 4.20.1 distinct.

La tâche était déjà associée au reçu docs/reference_requirement_trace_sources/four-passive-local-branch-links-v534.json : 443091 octets, SHA c9116863627812751fdde3f6f38cd75bc63d962b9304de9aee2896592bf3f9ed. Seule son association Annie est qualifiée ici ; les trois autres sont conservées. Ses cinq contrats locaux restent identiques, sans promotion en règles du serveur historique.

Le rapport docs/AUDIT_SYS01202_ANNIE_PASSIVE_LINK_2026-11-02.md et la revue VFX de 52 contrôles sont réutilisés. Trois vues Lua héritées, neuf globals, sont rapprochées du reçu V668 épinglé : noms Pyromania, Pyromania Marker et Energized ; icônes Annie_Passive2.dds/Annie_Passive.dds ; effet StunReady.troy. Aucun décodage natif nouveau. La projection héritée ne fournit pas la consommation de tous les octets ; aucun callback serveur récupéré n’en est déduit.

Six chaînes exactes sont relues dans le miroir en_GB : lignes 2488–2491, 4158 et 4334 ; 2220957 octets, SHA 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3. Elles décrivent quatre sorts puis le prochain sort offensif étourdissant, avec durée @f1@ non résolue. Cette recherche lexicale complète l’ancienne limite de locale ; elle ne prouve ni binding actif, ni fournisseur, ni locale du runtime.

## 3. Consommateurs et comportement actuel

Dix ancres enregistrées sont retrouvées : un contexte catalogue et neuf consommateurs partiels spécifiques. Dix-neuf fenêtres statiques sont reliées aux treize branches du contrat ; neuf fenêtres communes sont réutilisées après contrôle d’identité et de lignes.

annie_passive.rs protège propriétaire absent, mauvais champion ou mort ; incrémente au plus quatre charges ; un événement offensif préparé remet à zéro et retourne une durée. Le code local utilise 1,25/1,5/1,75 seconde aux niveaux 1/6/11, soit 38/45/53 ticks par arrondi supérieur à 30 Hz. Ces nombres ne deviennent pas des valeurs natives établies.

Q charge à l’impact sur cible vivante après apply_damage accepté, pas à l’acceptation initiale. E charge à l’acceptation et peut préparer un Q déjà en vol. W consomme une fois à la libération avant sélection des cibles ; il peut donc consommer sans toucher. R consomme après apparition réussie de Tibbers ; le guidage emprunte un chemin distinct. Une durée est réutilisée pour les cibles de zone.

pyromania_hit ignore durée nulle ou cible absente/morte, puis ignore le résultat de grant_stun. Une Q létale acceptée peut consommer la préparation avant rejet de l’étourdissement sur cible morte. Le filtrage allié appartient aux appelants. Le récepteur commun applique sa réduction de contrôle une fois, refuse structures et politique boss non qualifiée, gère remplacement et expiration.

Mort et réapparition génériques effacent les effets transitoires. Le flag PersistsThroughDeath du marqueur ne prouve pas la persistance du compteur. Réseau, présentation et acceptation gardent leurs propres frontières.

## 4. Attendu, observé et contrôles

Attendu : chaque branche connue relie source, comportement courant, limite et correction précise. Observé : treize branches, dix-neuf fenêtres, dix ancres, vingt-et-une identités courantes ; **43/43 contrôles documentaires et 36/36 cohérences du même agent**. Dix-sept entrées sélectionnées, douze Rust et cinq JSON de règles, concordent avec V534. Aucune qualification globale des 1147 dépendances historiques.

V534 conserve 37 tests filtrés réussis dont 27 spécifiques à quatre politiques et **six Annie**. Leurs noms et code courant sont présents ; les fixtures modifient directement niveaux, ressources, compteur, positions, vie ou ticks. Ni session ordinaire complète, ni couverture instrumentée de chaque branche/appel, ni équivalence native établie.

Ancien binaire inerte : 787789824 octets, SHA 8ba219f17d8e5a17202514971497f54e743c867a93ebc5a55b87c9fa31696c97. Aucun accès à ce payload, nouveau build, test Rust, REA, runtime, réseau, GPU ou capture. L’ancienne dérive des preuves d’octobre n’est pas effacée par la concordance sélectionnée avec V534.

bootstrap01, contract02, coherence01 et documentation01 réussissent. contract01 échoue sur shop.rs, fenêtre commune inutilisée hors du périmètre capturé ; script et erreur restent conservés. La correction retire uniquement ce nom, sans changement des treize branches ou du produit.

## 5. Écarts et inconnues

Restent ouverts : fournisseur de durée et niveaux historiques ; éligibilité et ordre cast/impact/libération ; coups à vide, annulation, immunités, dégâts bloqués, mort du lanceur, cibles particulières, remboursement après refus, cumul/réduction des contrôles ; initialisation, mort/reconnexion et audiences ; liaison visuelle effective ; couverture runtime exhaustive.

Les cinq contrats locaux sont conservés, avec leurs limites natives explicites. Inconnue propre OLU-705ee229-6830-5a3d-ad70-9340caeba8cc et inconnue SOURCE OLU-cf2be2fe-aba9-54d4-b836-24578660f62b inchangées. Une limite de lecteur ne prouve ni absence ni corruption. Aucun constat d’implémentation entièrement absente : Pyromania possède bien une reconstruction partielle.

## 6. Corrections et reprise

corrections_and_restart.json contient cinq propositions non enregistrées COR-SYS-01.2-02-ANNIE-PYROMANIA : SEMANTICS-01, EVENTS-01, DELIVERY-01, LIFECYCLE-01 et VERIFICATION-01. Chaque fiche décrit objectif, tâche existante liée, entrée nécessaire, travail, fin et reprise.

Reprendre uniquement sur nouvelle autorité native, fournisseur, trace, appel, dérive ou observation précise. Modifier le produit exige une autorisation adaptée. Les tests ciblés seront pertinents sur changement ou cas courant indispensable encore non prouvé ; ne pas relancer les fixtures inchangées par défaut. Prochaine paire réelle : Ashe SIMULATION-CONTRAT, preuves conservées d’abord.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_annie_passive_simulation_contract_20261106 : contrat, branches, identités, cohérence, journaux, échec conservé et corrections. Projection existante de 122 paires réutilisée ; aucun grand registre chargé. Neuf fenêtres communes et dix-sept identités concordantes évitent des acquisitions répétées ; aucun gain temporel global mesuré.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF avec sauvegardes exactes. Sept registres, goal, Plan/UI, bases, code et assets inchangés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2439 entrées groupées conservées. Relecture par le même agent, sans revue indépendante ou acceptation humaine. Une unité d’audit bornée close ; aucune tâche complète ou fonctionnalité déclarée terminée.
