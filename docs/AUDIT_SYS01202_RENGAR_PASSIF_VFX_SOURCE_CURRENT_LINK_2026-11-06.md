# SYS-01.2-02 — Rengar : sources et consommateurs VFX du passif, V1391

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-RENGAR-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit de liaison documentaire terminé sur ce périmètre. Fonctionnalité, gameplay et acceptation humaine restent ouverts.

## 1. Exigence et frontières

`CH-Rengar-PASSIF-PRESENTATION-VFX`, `OLF-238e5d8b-7280-5139-b41f-4dfaf19526bd` : relier effets applicables, sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnues VFX `OLU-03ead57d-2ffe-5bf9-a514-8f39762c67e5` et SOURCE `OLU-626f9cfd-2ee0-59a4-811b-00c72cbaf5c1` ouvertes. Phase/prérequis examinés sans satisfaction revendiquée. Parent et SYS-01.2-02 ouverts.

RenektonV1316 était déjà audité :réutilisation après39gardesF couvrant ses21entrées inspectées et source/rapport vérifiés. Ses47/47 contrôles qualifiés,45/45 cohérence et16/16 publication sont hérités,non rejoués. Ancien46/47 et qualification d’un seul prédicat préservés. Zéro nouvelle clôture Renekton. Reçu `E:/mapslol3v3/reuse_sys01202_renekton_vfx_20261106/reuse_receipt.json` ; transition explicite depuis le next_lot gelé vers Rengar.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau/déploiement inconnus,catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/rengar-passive-unseen-predator-links-v619.json`,3809762octets,SHA `e13845fbd27790c4868045258740fbd9b6d1eb038ded11048aebbfb5ef8be369`,UTC documentaire2026-10-26T14:29:52.209558+00:00,sans heure d’exécution déduite.

145identités natives :37INIBIN,66Lua,40preloads,DDF,font.57initialisations littérales,156globals,neuf limites NEWTABLE ;zéro prototype enfant selon les reçus,sans serveur original qualifié. Définition RengarPassive/Rengar_Passive.dds,mais NewPassive134 déclare seulement BuffName RengarNewPassive/PersistsThroughDeath. Priorité inconnue. CharScript114 ne déclare que Wolfman_InnerHunger.dds ;aucune mécanique Warwick ni lecture de son DDS.

Onze chunks portent34AutoBuff :18références Effect,16Bone,zéroEvent. Les contextes Q/E/vitesse conservent noms et bones exacts ;SpeedBonus est un cas bone seul. Talon_Q et Hatred/Volibear ne deviennent pas des mécaniques d’autres champions.25BuffData :18résolutions/17clés distinctes,sept absences exactes. Le tooltip NewPassive reste non résolu,alors que Passive2538 décrit le passif ;aucun alias automatique.

Font2538/description4266 :attaque depuis buisson/furtivité,portée f1 ;gain1Férocité par capacité sur ennemi,seuil5,renforcement immédiatement disponible,reset0 après usage. f1,événements,cibles,ordre et initialisation restent inconnus. PARType=Ferocity,BaseMP chaîne5.0,PARStart/PARMax absents. Métadonnées anciennes Warwick/trophées/Bonetooth/Dominion et DDFQ/R restent distinctes des règles natives.

40preloads12460octets/164références typées :77particules/87sorts. Discovery1369353octets/SHA5718f0c04eb0d4b0c47897209e3ea7ccfc3ce9a89c1df82af0e3d6317ee76fd9 retient le texte ;reconstruction CRLF exacte des40identités. NewPassive mène à newpassivebuff/passivebuffvisible ;NewBuff nomme deux Ring avec casse propre et blank.troy,tandis que Buff nomme les variantes minuscules et passivebuffenhanced. Dash précharge grass/sound/dust ;FerocityManager deux warning. Ne pas fusionner variantes ou transformer ces dépendances en créations rendues.

Trois DDS E relus,64×64/mip7 :deux Rengar_Passive2872DXT1,SHA `ff040fafd72fdcf6f9c9ffcc40304683e467bba068d69acabf69ec69577041e8`,membres0.0.0.163/0.0.0.116 ;RengarPassive5616DXT5 sans underscore,SHA `3fa9eaa4a052ba18ec10991c7a9cfd1e2b0059282fbf20960a792da394fa026e`,membre0.0.0.116. Projet0.0.1.7 hérité ;lookup/variante/pixels ouverts. Sourcehash Ferocity est le JSON communautaire4831octets/SHAae02e8e8…,distinct de l’INIBIN natif1748octets/SHA6bb46f0d… .

## 3. Consommateurs actuels

17fichiers inspectés,dont15Rust/deux lecteurs Python ;34ancres SOURCE/frontières vérifiées.16fichiers antérieurs et29contextes inchangés. Recherche nominative sans hit dans ces15Rust,sans absence globale revendiquée.

`attacks.rs:146` filtre visibilité et portée de définition+rayon cible. `movement.rs:53` utilise vitesse générique+objets ;`vision.rs:45`/48 fournit flags et LOS. Aucun raccord de saut Rengar identifié dans ces routes. Classification Ferocity et autres acquis génériques conservés. Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité ;ils ne qualifient ni clip de saut,recette,owner,bone ou pixels du passif.

## 4. Attendu et observé

Attendu :saut sous conditions natives,Férocité et présentation attribuable. Hérité V619/HUDV1263 :quatre cas buisson/ouvert×sans/avec Bottes1001,cible initialement visible à400,flags1/0.12impacts,108refus,244ticks d’attente,huittrajets aboutis.

464paires brutes X/Z relues et distances recalculées :pas≤vitesse/30+0,003,345/370selon Bottes. Avant premier impact :20/20/18/18pas pleins,total76. Marche ordinaire,aucun saut observé dans ces cas ;f1 inconnu interdit de déclarer400 comme éligible historiquement ou de chiffrer un déficit de saut natif. Hauteur et rendu non qualifiés.

Les12impacts concordent aux dégâts ordinaires à0,002près. Férocité5 dans les464frames et244attentes ;aucun sort accepté ni furtivité exercée. Une jauge pleine et des attaques ordinaires ne testent pas gain sur capacité ennemie,dépense ou renforcement.

Actuel :42/42 documentaires,65/65 cohérence même agent ;six opérations journalisées exit0. Une inspection de métadonnées a traité trace_frames entier comme une liste :TypeError transcrit,pas de faux journal brut,lecture corrigée vers les frames sauvegardées. HUD74/74 et63/63 hérités.

Trois JSON et deux reçus bruts anciens BUILD/RUN0 relus. Binaire6057472octets/SHAcb828f2396f4682b30f83b233835dc6a0ce6539a5ffbdff19812bf9682849aac inerte,jamais ouvert. Aucun nouveau build/jeu/natif/REA/GPU/réseau.

## 5. Écarts et limites

Portéef1,priorité Passive/NewPassive,grâce après buisson,furtivité,cibles,obstacles,interruptions et leap lifecycle ouverts. Génération/caps/renforcement/reset0/initial5 et septbindings non qualifiés. Recette,lookup,bones/owner,durée/arrêt,transport et fidélité visuelle ouverts. Niveau1,une cible,quatre profils ;PV cible adjacents absents,refus avec flags sans snapshots bruts,aucune garde NPC universelle. Limites V564 et échecs Nami conservés. Pas de nouvelle acceptation gameplay.

## 6. Corrections et reprise

`corrections_and_restart.json` décrit cinq clauses sur IDs existants :politique/bindings ;saut buisson/furtivité ;Férocité/renforcement ;état réseau ;présentation/ressources. Chacune porte objectif,pré requis,critères de fin et entrée de reprise. Conserver contrôles marche/Bottes et classification Ferocity. Reprendre sur preuve native/capture précise,dérive ou autorisation distincte d’implémenter ;aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_rengar_passive_vfx_20261106`,evidence_review/coherence_review,gardes,journaux et réutilisation Renekton. `next_lot.json` cible Riven,ligne de couverture vérifiée. Sept rubriques relues ;une unité de liaison Rengar bornée close,zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER.

Publication limitée au rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ;sept documents protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent,sans revue indépendante.
