# Annie — rapprochement de la projection VFX existante

6 novembre 2026 · V1443 · AUD-SYS-01.2-02-ANNIE-PASSIF-VFX-PROJECTION-FRESHNESS-01

## 1. Exigence et périmètre

CH-Annie-PASSIF-PRESENTATION-VFX, OLF-7d6d534a-366c-55eb-b072-5e8696c2a0d4, parent SYS-01.2-02. Contrat de reprise V1442 : comparer la classe V1322 « sans vue mappée » aux preuves individuelles publiées ; produire une correspondance par identité/pointeur ou un manque exact. D06 et ses prérequis restent hérités.

Rapprochement documentaire terminé ; implémentation non modifiée ; vérification de métadonnées/identités ; acceptation humaine non donnée. L’audit individuel Annie était déjà terminé dans son périmètre borné : aucune nouvelle clôture individuelle, de VFX complet ou du goal.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Deux reçus figés et leurs miroirs F concordent :annie_passive_sources.json5332/SHA0f0692ec828277c332db1c32e9719147af900cdf7f32bd617953694896b4dc10 ;annie-passive-vfx-links-v668.json89618/SHA1c10e5a7e5ff026f759c98fd0798578bdf33369aeb47c5592ac2131cdd81c6f9.

La preuve publiée Annie b87c1eb6 et sa cohérence928a1473 fournissent déjà trois vues. Contrôles52/49,sept rubriques et post16 hérités, non rejoués. Leurs huit limites sont conservées intégralement. Les chemins natifs restent des métadonnées inertes ; aucun D,EXE ou runtime ouvert.

## 3. Consommateurs et cause du mapping manquant

Le producteur V1322 capture_sources.project reconnaît native_metadata.client_lua,associations[].native_metadata.client_lua et lua_prototypes_as_data. Il ne reconnaît pas les deux formes Annie :/native_lua et /associations/0/field/native_metadata.

Le consommateur documentaire individuel collect_evidence gère déjà ces deux formes. Ses trois correspondances sont réutilisées :Pyromania146/SHA cdd6e5a4,Pyromania_marker214/SHA76c18bfa etPyromania_particle201/SHA5486fbc7. Chemins/SHA,identifiants source,pointeurs et globals concordent. L’ancien reçu ne fournit pas la taille ;celle-ci est héritée de V668, sans champ inventé.

Neuf globals conservés :nom/icônes,PersistsThroughDeath/NonDispellable du marker et une AutoBuffActivateEffect=StunReady.troy sur Pyromania_particle. C’est une déclaration, pas un callback serveur, une sélection effective ou un rendu accepté. Consommation de tous les octets non fournie, donc inconnue.

Huit fichiers consommateurs courants et deux reçus sources correspondent à leurs identités, soit10comparaisons/10fichiers. Contrôle d’octets uniquement ; conditions de rendu héritées, sans nouveau replay sémantique ou graphique.

## 4. Attendu, observé et contrôles

Attendu : retrouver les vues déjà qualifiées sans nouvelle acquisition. Observé :les trois vues étaient présentes ;la classe de famille était restée celle du snapshot antérieur. **18/18 contrôles documentaires,28/28 cohérences du même agent.** Deux pointeurs invalides sont refusés explicitement,IndexError/KeyError ;un SHA altéré en mémoire est distingué, sans mutation des sources.

Cinq productions journalisées :quatre réussies,projection01 arrêtée sur KeyError:bytes et conservée. projection02 modifie une seule expression de schéma :chemin/SHA ancien requis,absence de taille explicite,identité complète V668 toujours requise. Aucun résultat de preuve n’avait été émis par l’essai interrompu ;les deux scripts et journaux restent conservés.

projection_overlay.json référence les trois vues et ne change que la classe Annie en recognized_partial_views. Les121autres lignes sont identiques. Le snapshot V1322 reste103partielles/13sansmapping/6contextesadditionnels ;la vue documentaire corrigée devient104/12/6. Ce ne sont ni des comptes d’assets manquants ni un pourcentage de jeu terminé.

## 5. Limites et inconnues

COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 reste ouverte. Aucun inventaire natif exhaustif,callback,recette complète,audience,attache,phase,blend ou texture rendue qualifié par ce lot. ready2 absent de la définition retenue ne prouve pas son absence de tous les providers ;ready1 sélectionné par le renderer nommé ne qualifie pas les variantes Freljord ou la politique de readiness.

Les limites d’Annie et les121autres décisions restent conservées. L’overlay ne réécrit ni le snapshot,ni les registres,ni les preuves publiées. Les huit identités de consommateurs ne remplacent pas une exécution actuelle. Aucun décodeur,build,jeu,REA,GPU ou outil installé/exécuté pour de nouvelles analyses.

## 6. Corrections et reprise

corrections_and_restart.json relie le manque documentaire résolu à la correction et aux limites déjà publiées. Les corrections fonctionnelles d’Annie restent dans leur rapport d’origine, sans nouvelle clôture.

next_lot.json contient les douze paires d’IDs encore classées sans vue mappée,avec leurs sources et preuves individuelles. Les comparer en un lot de schémas partagés :une ligne de correspondance ou refus précis par ID,aucune nouvelle extraction native inchangée. Reprendre sur divergence de schéma/source,preuve nouvelle ou dérive ;ne pas confondre absence de mapping et absence native.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_annie_passive_vfx_projection_20261106 :scope,reçus,projection_overlay,projection_review,qualification du schéma,identités,cohérence,corrections,reprise et journaux. Rapport relu en sept rubriques par le même agent ;aucune revue indépendante ou acceptation humaine.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF avec sauvegardes exactes. Sept registres protégés ;main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2429entrées groupées conservées. Goal,Plan/UI,bases,code,assets et statuts inchangés. Seul ce rapprochement de projection est clôturable.
