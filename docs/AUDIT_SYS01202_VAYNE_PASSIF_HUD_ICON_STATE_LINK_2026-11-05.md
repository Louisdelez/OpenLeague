# SYS-01.2-02 — Vayne : Night Hunter et HUD, V1290

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VAYNE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Vayne-PASSIF-PRESENTATION-HUD`, `OLF-e14afba0-8db8-5131-932f-f0d8f86d9e84` : relier icône/textes,condition directionnelle,vitesse de déplacement et HUD aux consommateurs actuels. Contrat a_faire,implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-10c20523-d5bd-5a3f-97dc-d7ff5330d9db` ouverte. Six contrats et prérequis D06/D06-CH-Vayne consultés sans satisfaction revendiquée. SOURCE/SIMULATION,R et parent PRESENTATION restent distincts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/vayne-passive-night-hunter-links-v647.json`,2987012 octets/SHA `ebcda7172cd121d660d404fa667fc91ee74a3055f38d1845b4e546710c80d0bc`,UTC documentaire 2026-10-27T00:05:48.571315+00:00.

HUD enregistré : définition et catalogue. SOURCE15 relations/13 identités/quatre sites ; V64720 frontières,union24 ancres/dix fichiers. Treize directs : deux INIBIN,cinq Lua,quatre preloads,DDF,font ;38 voisins non promus.18 Lua sans prototype enfant,deux limites NEWTABLE. Aucune relecture native des métadonnées.

Définition3333 octets : Passive1LuaName=Focus,icône Vayne_NightHunter.dds,description brute Ashe/critique non promue en règle Vayne. Passive1 et six niveaux non résolus. CharScript/VayneHunted56 vides ; SpeedPart/Normal98 déclarent seulement AutoBuffActivateEffect vide. Preloads désignent deux particules sans preuve de rendu. Deux Focus existent sous Ashe : contexte identifié,aucun producteur Vayne qualifié.

Font miroir d’identité native : nom4476,description4300,+30 de vitesse vers les champions ennemis proches. Tooltip R11989/Effect4=90 ; rangs1/2/3,durées8/10/12,AD30/50/70. Buff2861/SourceName concerne R. Rayon,angle,visibilité et activation historique restent inconnus. DDF Q totalAD.3/.35/.4/.45/.5 et E bonusAD.5 ne donnent pas ces politiques. R communautaire fixe8s divergent,non producteur de vitesse passive.

**Icône présente**, sous `DATA/Characters/Vayne/Info/Vayne_NightHunter.dds`,hors ancien filtre HUD/Icons2D. Qualification `COR-SYS01202-AUDIT-DDS-CHAMPION-INFO-PATH-SCOPE-01` : chemin exact du même champion,nom déclaré et manifeste conservés,avant lecture SOURCE.2176 octets,64×64 DXT1,mip brut1,SHA `f8a20962056ad37103f259da07544372ac2da056497344742f084e42b458934a`,membre30 du projet RADS0.0.1.7 ; taille/MD5 concordants. Aucun DDS étranger/particule lu ; provider,pixels et priorité ouverts.

Onze archives2674028 octets sélectionnées avant lecture F/OpenLeague-work. Échecs initiaux/source/journaux conservés ; aucun binaire ou1158 dépendances copié/rejoué. resource_provenance.json distingue StatsJSON communautaire et INIBIN natif.

## 3. Consommateurs actuels

24 ancres,32 fichiers code/configuration,16 entrées communes et20 identités V647 inchangées. movement calcule vitesse/modificateurs,ally_occupancy le déplacement ; navigation/vision ont leurs frontières. capture_facing ne renseigne pas Vayne selon les sources inspectées. Cosinus diagnostic issu du mouvement,aucune orientation native déduite.

PV/Mana ont des chemins HUD génériques. Maxima ne prend pas Vayne en charge ; recherche Vayne/NightHunter/Hunted/SpeedPart vide dans les sources Rust choisies. Absence bornée,sans conclusion mondiale. Aucun producteur/widget Night Hunter qualifié ; catalogue et chargeurs génériques ne prouvent pas le bonus affiché.

## 4. Attendu, observé et contrôles

Archives V647,L1/L18 : quatre trajets publics de préparation Vayne/Annie,arrivées recalculées à moins d’une unité du but,sans réordre. Trois directions dix frames chacune par niveau : **60 métriques de déplacement recalculées depuis les positions brutes**,distances et cosinus float32 concordants. Vers l’ennemi :300→190,cosinus≈1 ; opposé≈−1 ; latéral≈0 à−.313. Ennemi localement visible dans chaque frame,vitesse330,pas≈11unités/tick.

Vingt mesures immobiles à330 après Stop. Aucun bonus30 supplémentaire observé dans ces cas ; rayon/angle natifs et autres parcours non qualifiés. R refusé/non activé,même L18 ; pas de mesure du bonus90.

Témoin Garen Q distinct appris/lancé/déplacé publiquement :345→455.6→345,15vecteurs bruts recalculés,échantillons relatifs44/45/46,expiration45. Aucun transfert de sa politique à Night Hunter.60 refus flags (58Vayne,deux Garen),toutes les paires de snapshots individuelles non archivées.4952ticks archivés,un apport diagnostique100000XP,pas progression naturelle complète ; aucune mort/fin de partie.

RUN corrigé contient dix lignes diagnostiques conservées et un JSON égal OBS ; BUILD/RUN hérités0. Premier BUILD0/RUN1 « destination unreachable » conservé,branche non attribuable au journal. Première assertion Focus erronée et script corrigé conservés ; aucun replay. Binaire corrigé inerte6086656 octets/SHA `53a17239d46a747a0f6388ff89d5fac80fdd6f399d4a86eb7053ed00b02816be`,identité non fraîchement rehashée.

128/128 contrôles corrigés et132/132 cohérence corrigée séparée du même agent. Aucun nouveau build/jeu/VM/REA/rendu/réseau ni revue indépendante/humaine. Échecs actuels conservés : filtre Info trop étroit ; indicateur négatif attendu à l’envers (127/128,puis127 autres identiques) ; référence Focus prise pour booléen (131/132,puis131 autres identiques). Qualifications par données/empreintes,aucun moteur modifié.

## 5. Écarts et inconnues

Producteur effectif,rayon/angle/visibilité,sélection de cible,pets/clones,cumul/ordre avec caps/ralentissements,arrêt/perte de vue,mort et reconnexion restent ouverts. R séparé : activation/bonus90 non qualifiés. Transport du statut,HUD,tooltip,pixels,animation et audio non qualifiés. Points testés et cosinus ne deviennent pas un contrat historique.

## 6. Corrections et reprise

`COR-VAYNE-NIGHT-HUNTER-POLICY-01` : sourcer rayon,angle,visibilité,cibles,ordre/caps et interactions. Fin : contrat historique établi ou reconstruction explicitement séparée ; Focus/Ashe et points locaux non substitués.

`COR-VAYNE-NIGHT-HUNTER-MOVEMENT-01` : produire/consommer l’état directionnel selon ce contrat. Fin : nominal,+30 où applicable,bords distance/angle,arrêt/cible invisible,invalides,lifecycle et déplacements observés ; préserver navigation/vision/ralentissements. R dans sa tâche propre.

`COR-VAYNE-NIGHT-HUNTER-HUD-BINDINGS-01` : relier statut,icône/nom/texte,durée éventuelle et audiences. Fin : chemin Info/variante/provider explicités,transport,transitions,tooltip et pixels observés. Reprendre sur source/callsite nouveau,dérive ou autorisation fonctionnelle.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_vayne_passive_hud_20261105` : evidence_review_corrected,coherence_review_corrected,qualifications,archives,DDS,resource_provenance.json,prérequis et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes et sept protégés contrôlés à publication. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
