# Audit borné — frontière du callee de RadsInitialize (4.20)

Date : 2026-11-02  
Lot : AUD-SYS-01.2-02-RADS-INITIALIZE-CALLEE-01  
Périmètre : relier l’export natif RadsInitialize à son callee direct et vérifier si un consommateur équivalent existe dans le client Rust courant. Cet audit ne qualifie pas le montage RADS.

## Source et observations

La source examinée est le RADS/RiotRadsIO.dll fourni avec LoL 4.20, PE x86, SHA-256 60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521.

Analyse statique REA 6.4.0 / Ghidra 12.1.4 :
- preuve de l’export : ev_7c923698f8c8f156486518fccacae1020078df00ce007486d696fdbc3a15cfea;
- preuve du callee 0x1003e250 : ev_41ce9386be41945f8eca41a29dcd84f79705c5eafe739380f3497c6332cb6166;
- l’export RadsInitialize à 0x1003e3d0 est un wrapper de 18 octets qui appelle 0x1003e250 avec ECX=0x1019846c et lui transmet l’argument chemin;
- le callee est une fonction de 379 octets. Ghidra lui attribue le nom provisoire FUN_1003e250 et la signature décompilée undefined __thiscall FUN_1003e250(void * this, CHAR * param_1).

Les noms et la signature du callee sont des inférences du décompilateur, pas un prototype source officiel. Cette observation ferme seulement le lien export → callee; elle ne permet pas d’attribuer au callee une sémantique complète de chargement, de priorité ou d’overlay.

## Consommateur courant et cas observés

Recherche textuelle exacte des noms RiotRadsIO, RadsInitialize, RadsOpenFile, RadsRead et RadsSetLogger dans crates/ et launcher/ : aucun consommateur direct correspondant n’a été trouvé. Les occurrences de GetProcAddress observées dans d’autres modules concernent des services CRT/audio et ne prouvent pas l’appel à ce provider RADS.

Attendu statique : l’export natif entre dans le callee direct identifié ci-dessus. Observé : la relation d’appel et l’identité des deux fonctions sont établies pour le binaire identifié.

Limite d’exécution réutilisée : l’essai natif publié dans docs/FIDELITY_NATIVE_RADS_MANAGED_LAYOUT_4_20.md retourne 0x80004005 lorsque le manifeste core/0.0.1.7 n’est pas exposé au chemin attendu; le manager RADS reste nul et non initialisé. C’est un refus/échec réel, pas un montage réussi. Cet essai est une preuve antérieure, non rejouée pour ce lot.

## Résultat du lot

Audit de la frontière source clos dans ce périmètre. La source, l’export et son callee direct sont reliés; l’absence d’un appel direct correspondant dans le client Rust actuel est consignée comme écart. Aucune fonctionnalité provider, aucun chargement de ressource et aucune acceptation du jeu ne sont déclarés terminés. SYS-01.2-02 reste actif et partiel.

## Écarts et conditions de reprise

Restent inconnus : le rôle complet de FUN_1003e250, les entrées valides et le chemin du manifeste core, la sélection effective du provider, les priorités/base/legacy/overlays, les refus avec données complètes, ainsi que l’intégration à un consommateur Rust de jeu.

Reprendre ce fil seulement si une piste nouvelle fournit au moins un des éléments suivants :
1. le manifeste core exact et ses dépendances de chemin/index dans l’arborescence originale;
2. un reçu qui relie l’entrée native à un consommateur Rust précis, ou un nouveau callsite/ABI vérifiable;
3. une trace REA ciblée sur une branche du callee dont l’entrée et le résultat sont disponibles.

À la reprise, conserver les refus et adaptateurs historiques distincts, puis vérifier l’entrée, le résultat et le consommateur séparément. Ne pas relancer cette même analyse statique sans nouvel input.

## Contrôles effectués dans ce lot

- Analyse statique REA/Ghidra déjà lancée pour l’export et son callee; sortie relue à la reprise. Aucun exécutable historique lancé sous Windows.
- Recherche rg des symboles du provider dans crates/ et launcher/.
- Relecture des preuves antérieures sur l’export, le retour 0x80004005 et le manifeste absent.
- Aucun build, test Cargo, lancement du jeu, installation ou migration exécuté.

Références conservées :
- docs/loading_provider_crt_preparation/rads_next/README.md
- docs/FIDELITY_NATIVE_RADS_MANAGED_LAYOUT_4_20.md
- docs/FIDELITY_PROVIDER_STANDARD_BOUNDARY_V684.md
