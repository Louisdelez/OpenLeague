# SYS-01.2-02 — Rammus : sources et consommateurs VFX du passif, V1390

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-RAMMUS-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit de liaison documentaire terminé sur ce périmètre. Fonctionnalité, gameplay et acceptation humaine restent ouverts.

## 1. Exigence et frontières

`CH-Rammus-PASSIF-PRESENTATION-VFX`, `OLF-ba3603e7-5cb5-5a1f-83db-fc96582d6554` : relier effets applicables, sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnues VFX `OLU-25eb1e2f-709f-5d61-ad31-bb6e2628c798` et SOURCE `OLU-8158f514-cfea-507c-ae36-d06a70e13f52` ouvertes. Phase/prérequis examinés sans satisfaction revendiquée. Parent et SYS-01.2-02 ouverts.

Avant ce lot, l’audit QuinnV1318 existant a été réutilisé :40identités F concordantes couvrant ses22entrées inspectées, source et rapport vérifiés. Ses47/47 documentaires,52/52 cohérence et16/16 publication sont hérités, non rejoués. Zéro nouvelle clôture Quinn. Reçu : `E:/mapslol3v3/reuse_sys01202_quinn_vfx_20261106/reuse_receipt.json`. La transition conserve le next_lot Quinn gelé et justifie le passage à Rammus.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/rammus-passive-spiked-shell-links-v617.json`,2224846octets,SHA `91fb766ea78232b2f3e226b29cd380718aaf62cc37a46035af0da731cbfbaa3e`, UTC documentaire2026-10-26T13:51:00.044410+00:00, sans heure d’exécution déduite.

Secondaire `rammus-passive-conversion-links-v547.json`,459433octets,SHA `97c31a13ac3a0f92e44c59af87baa7f608d9630297895b87db4547166232490e`. V617 compte31identités natives,V547 six ; union32, pas37. L’identité supplémentaire `OLS-49fe6cdf-3fef-5ace-9788-df9e0d38b8b4` est `DATA/Spells/Spiked Shell.inibin`,44octets/SHAf8905104564fdfe583e638748a7eabb943fd406dce1ee03974a6541594922bd6,membre0.0.0.120. Sélection par observed.path ; ancien résultat vide du filtre source_id conservé, sans absence de fichier déduite. Aucune lecture D.

Définition/BuffName « Spiked Shell », Lua SpikedShell221 et preload spikedshell conservent leurs orthographes, sans alias exécuté. Buff2702 conserve f2%armure et bonusf1 ; description4259 annonce25%armure enAD. Valeurs dynamiques, armure admissible, ordre/caps/arrondis et priorité des noms restent inconnus. DDF W armor×0,1 est distinct du passif25%.

11Lua :six initialisations littérales,28globals,cinq limites NEWTABLE ; zéro prototype enfant selon les reçus, sans serveur original qualifié. CharScript56 vide. Deux chunks QWER portent trois AutoBuff vides ; aucune absence globale d’effets inférée. PersistsThroughDeath/NonDispellable ne prouvent pas le lifecycle.

Sept preloads1355octets/18références typées :six particules,dix sorts,deux personnages. Texte retenu dans discovery759455octets/SHA3c41dbec98a5567e891e862a847146a127cde8901469281f2004391bb62a28b8 ; reconstruction CRLF exacte des sept identités. CharScript précharge spikedshell/apbonusdamagetotowers. Aucun preload dédié SpikedShell parmi ces sept entrées ; pas d’absence globale ou recette/passif rendu déduits.

Deux DDS E relus,4224octets chacun,64×64DXT5,mip brut0 ; SHA commun `0b0b6123410c2242c9f1ad3a301518e69fd395382271941086b4d149cae2b15c`. Characters/Rammus/Info et Spells/Icons2D, membres0.0.0.40/0.0.0.25 hérités du projet0.0.1.7. En-têtes/identités ne prouvent ni lookup,variante ou pixels. Mana source_sha bc5ff42a… est le JSON communautaire6966octets ; INIBIN natif2287octets/SHA25707d0a… distinct. Scripts communautaires QWER restent comparatifs.

## 3. Consommateurs actuels

15fichiers inspectés,dont13Rust/deux lecteurs Python ;30ancres SOURCE/frontières vérifiées. Identités des14fichiers antérieurs et28contextes inchangées. Recherche nominative sans hit dans ces13Rust, sans absence globale revendiquée.

`progression.rs:40` décompose l’AD en base/croissance/objet/autel/ajustement, sans entrée armure. Appel réel90–91 ; armure calculée séparément100–104. Aucun producteur de conversion identifié dans cette route. Attaques/dégâts consomment l’AD courant. Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité ; aucun rendu Spiked Shell qualifié par ces primitives.

## 4. Attendu et observé

Attendu :conversion/recalcul fidèles et présentation applicable attribuable. Hérité V617/HUDV1261 :niveau1,base/Tissu1029+15armure/Épée1036+10AD. AD55,880001/55,880001/65,880005 ; armure31,384001/46,384003/31,384001. Neuf attaques sortantes,neuf impacts physiques entrants,troisQAnnie,81refus,sixtrajets aboutis.

Neuf échantillons de statistiques et six transactions publiques :vente restaure le spawn,rachat restaure l’achat. Tissu ne donne aucun AD ni dégâts sortants supplémentaires≈46,87133 ; Épée monte les coups à≈55,25919. Tissu réduit les dégâts entrants≈38,36845→34,43682. Les18paires physiques attendues/observées concordent à0,002près. Contrôles d’objets acquis, conversion non observée. Totaux AD+25%armure illustratifs63,726/67,476/73,726 non promus ordre natif.

V547 visait Garen,V617 Annie ; ses neuf coups ne sont pas ajoutés. Ancien collecteur Python1 avait comparé double etf32 par égalité exacte ; BUILD/RUN0 et revue f32 qualifiée conservés, sans correction moteur ni nouveau jeu. Contrôles HUD61/61 et51/51 hérités. Ancien amorçage au mauvais prédécesseur et sélecteur de membership sont conservés comme limites de méthode.

Actuel :43/43 documentaires,64/64 cohérence même agent ;six opérations journalisées exit0. Trois JSON et deux reçus bruts anciens BUILD/RUN0 relus. Binaire6127104octets/SHA83c31c91abe6dff8153e3770001756a25012833b4955ae46d17f12f7e9499bf3 inerte,jamais ouvert. Aucun nouveau build/jeu/natif/REA/GPU/réseau.

## 5. Écarts et limites

f1/f2, ordre, armure négative,croissance,W/défenses temporaires,multiplicateurs/caps/arrondis et mort/respawn ouverts. Recette applicable,lookup/variante,owner/attache,horloge/arrêt,pixels et réseau non qualifiés. Niveau1,trois profils ; PV cible/Q sans paires brutes adjacentes,dégâts dérivés hérités ;flags de refus sans snapshots bruts,healing_checked false et absence de garde NPC universelle conservés. Limites V564 et échecs Nami distincts. Pas de nouvelle acceptation gameplay.

## 6. Corrections et reprise

`corrections_and_restart.json` décrit quatre clauses sur IDs existants :politique de conversion ;stats/attaques réelles ;attribution réseau ;présentation/ressources. Chaque clause porte objectif,pré requis,critères de fin et entrée de reprise. Conserver contrôles Tissu/Épée et tolérancesf32. Reprendre sur preuve native/capture précise,dérive ou autorisation distincte d’implémenter ;aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_rammus_passive_vfx_20261106`, deux reçus source,evidence_review/coherence_review,gardes,journaux et réutilisation Quinn. `next_lot.json` cible Renekton après vérification de la couverture ; examiner d’abord ses audits existants. Sept rubriques relues ;une unité de liaison Rammus bornée close,zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER.

Publication limitée au rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ;sept documents protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent,sans revue indépendante.
