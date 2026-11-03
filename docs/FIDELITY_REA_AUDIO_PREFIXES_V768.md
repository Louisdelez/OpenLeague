# SYS-01.2-02 — Préfixes audio et bootstrap, V768

Projet : F:/OpenLeague. Référence : LoL PUBLIC4.20.0.315 EUW/en_GB. Fiches enrichies : SYS-01.2-02 et SYS-02.2-07 ; leurs objectifs complets restent ouverts.

## Résultat attendu et observé

Les 31 médias ambiants produisent un signal dans le banc natif prolongé. Les 22 auparavant silencieux contiennent des préfixes silencieux ; aucune reconstruction d’asset n’était justifiée par les deux premières frames. Dans leurs WAV, le premier signal apparaît entre environ0,136 et1,396seconde. Ce temps source ne doit pas être assimilé au délai de sortie avec le pitch natif.

| Contrôle | Résultat observé |
| --- | --- |
| Signal | 31/31 médias positifs ;742 frames actives dont61positives |
| Sortie et arrêt | 773 soumissions de1024frames ;31arrêts nuls |
| Décodeur et WAV identifiés | 712 buffers,729088échantillons PCM16 ;écart maximal1unité |
| Conservation V767 | 62 premières frames identiques,empreintes et statistiques |
| Intégrité native | 4566blocs du banc et36blocs du bootstrap identiques au PE |
| Bootstrap | 10profils de succès/refus contrôlés réussis |
| Preuves falsifiées | 8mutations rejetées |

Le banc s’arrête après la première frame positive et une suivante,avec minimum2 et borne80. Un média devient positif à la frame79 et atteint cette borne sans frame supplémentaire. Les122dumps float32 de sortie et74dumps PCM16 sont conservés et relus.3844allocations,2213libérations,1631restantes :aucun teardown global annoncé.

## Source native et consommateurs

REA6.4.0/Ghidra12.1.4 analyse9fonctions,658instructions et9références contre le PE SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Session exportée et fermée sans erreur. AF3810 a une seconde plage B0FC50..B0FCB0 ;l’appel B0FC9C vers B0F550 et le saut AF38A3 restent statiques ici. B3F620 n’est pas résolu comme fonction par REA :instruction inspectée et blocs exécutés conservés,sans prétendre à une dixième décompilation.

Le vrai B0F550 appelle B19E30 avant création de sortie. Le masque demandé est tenté puis le masque3 en secours ;deux refus retournent2. Les refus précoces laissent les listeners vierges,les autres erreurs sont propagées aux étapes testées. B0B380 ne détermine pas le retour final1.

B0F550 et B19E30/B1A0B0/B052B0 s’exécutent réellement dans la sonde. Sept dépendances sont adaptées :B28380,ADA600,B0C830,B0BF30,5EB4B0,B1C100,B0B380. La sortie fournie est une structure du banc,pas un périphérique réel.

Trois consommateurs actuels précis sont ajoutés :enregistrement NativeListener dans main,Default de la table déléguant à Table::native,et listener_position préparant la caméra puis écrivant le slot0. Table::native est réutilisé. Ce sont des liens source ;la comparaison Rust V767 est héritée et aucun nouveau client/Rust n’est exécuté ici.

## Échecs, limites et suite

Le premier essai de capture supposait float32/512frames ;le format natif0x02400004 indique PCM16/1024frames. Une sonde distincte corrige la capture et conserve l’échec. Le premier validateur REA attendait les12fonctions du lot précédent ;un validateur distinct vérifie les9fonctions et exactement la frontière B3F620 non résolue,tous les contrôles d’octets conservés.

Banques,gains,pitch et constructeurs natifs sont conservés. Positions nulles,horloge1000 fixe ;allocateur physique,verrous,TLS et atomiques adaptés. Aucun asset ni code produit modifié. Pas de client historique normal,de scheduler à temps avancé,de sortie physique ni d’écoute acceptée. Streaming,seek,boucles,concurrence,autres médias/locales et intégration complète restent ouverts. La comparaison à une unité PCM16 près ne prouve pas une égalité binaire de fichiers complets ou une équivalence temporelle après rééchantillonnage.

Qualifier bootstrap parent et entrées réelles,puis B06950 et les notifications listener avec horloge avancée et voix actives. Relier cette chaîne au mixer et au transport actuels. Cases,notes,historiques et preuves antérieures conservés.

## Preuves

Preuve intégrée : docs/fidelity_rea_audio_prefixes_v768.json. Dossier de travail : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

- revision768_prefix_checked/OBSERVATIONS.json :banc audio.
- revision768_bootstrap_probe/OBSERVATIONS.json :bootstrap contrôlé.
- revision768_prefix_associations_checked/OBSERVATIONS.json :audit et liens.
- revision768_delivery/VERIFIED.json et INDEPENDENT_READBACK.json :publication et relecture.
