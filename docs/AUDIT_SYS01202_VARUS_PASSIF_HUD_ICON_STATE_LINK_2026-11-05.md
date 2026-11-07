# SYS-01.2-02 — Varus : Living Vengeance et HUD, V1289

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VARUS-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Varus-PASSIF-PRESENTATION-HUD`, `OLF-f9c3a784-68d5-5518-baf4-f1ac0590289a` : relier icônes/textes, événements létaux, état temporaire et vitesse d’attaque aux consommateurs actuels/HUD. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-09d102a1-97b7-523d-a271-19eb792b2cf5` ouverte. Six contrats et prérequis D06/D06-CH-Varus consultés sans satisfaction revendiquée. SOURCE/SIMULATION et parent PRESENTATION restent distincts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/varus-passive-living-vengeance-links-v645.json`, 3632759 octets/SHA `7b58b9f3cd911657a1a0ed8d08631a35ebe31535fe8965a423d43ba09c738e54`, UTC documentaire 2026-10-26T23:32:13.857244+00:00. Suffixe v645 hérité erroné conservé ; schéma/lot V646, sans confusion avec Urgot.

HUD enregistré : définition et catalogue. SOURCE17 relations/15 identités/quatre sites ; V64619 frontières, union23 ancres/dix fichiers. Quinze directs : quatre INIBIN,cinq Lua,quatre preloads,DDF,font ;94 voisins non promus.48 Lua sans prototype enfant,31 limites littérales. Trois préfixes PC0..17 qualifiés séparément ; tables finales,callbacks et serveur non exécutés.

Définition3179 octets : VarusPassiveBuff et VarusPassive.dds. Passive1Desc décrit pourtant Ashe/critique ; anomalie conservée, pas règle Varus. Passive1 et six niveaux non résolus. CharScript56 vide. Trois préfixes : marqueur12.dds ; Display et DisplayMinion partagent BuffName VarusPassiveBuffDisplay/icône VarusPassive, avec particules différentes. VarusPassiveTracker déclare VarusQ/slot1 : contexte Q, pas producteur du passif.

Font miroir d’identité native :2853, champion tué/assistance → @f2@% AS six secondes ; sbire/monstre tué → @f1@% trois secondes. **Valeurs f1/f2 non résolues.** Display2854 contient SourceName ; clé DisplayMinion absente dans ce font sans réécriture d’alias. Nom4475/description4299 résolus. DDF Q totalAD1/1.6,E bonusAD.6 et champs Disintegrate/Ziggs des SpellData ne définissent pas le bonus.

Deux DDS partagés64×64,7792 octets lus SOURCE après sélection E :12.dds2176 DXT1,mip brut0,membre25,SHA `79c8851830454fcbe613ed846e2e16d6e83c4f9c0a706f1df86e67499ef915fb` ; VarusPassive5616 DXT5,sept mips,membre91,SHA `19ea4cec1cf03bc6a67047fad0ade5d2bed8cb7f6c4fbd688e2549acb93cf963`. Tailles/MD5 concordants au projet RADS0.0.1.7. Q/Ziggs/particules non lus ; priorité,provider et pixels ouverts.

Quatre archives4908272 octets sélectionnées avant lecture F/OpenLeague-work. Aucun binaire ou1158 dépendances copié/rejoué. resource_provenance.json distingue StatsJSON communautaire et INIBIN natif.

## 3. Consommateurs actuels

23 ancres,32 fichiers code/configuration,16 entrées communes et20 identités V646 inchangées. damage/champion_kills/world traitent contributions,morts et récompenses ; progression calcule croissance,objets,Trundle W,Ezreal et Épuisement. Aucun terme Varus identifié dans cette composition.

PV/Mana possèdent des chemins génériques. Maxima ne prend pas Varus en charge ; recherche Varus/VarusPassive/Living Vengeance vide dans les sources Rust sélectionnées. Absence bornée, sans conclusion mondiale. Aucun état temporaire/widget spécifique qualifié ; catalogue et chargeurs génériques ne prouvent pas le buff affiché.

## 4. Attendu, observé et contrôles

V646 : huit scènes L1/L18 × champion tué/assistance/monstre/sbire. Dégâts par **API diagnostique**, à distance des positions de naissance ; aucune attaque ordinaire,portée ou acquisition de cible validée. Après contribution non létale, huit morts vérifiées par paires PV brutes avant/après et Outcome. Crédits kill/assist,or et XP sont distingués ; assistance immédiatement avant le kill allié, sans test de fenêtre.

Périodes calculées reconstituées depuis base/croissance :46ticks L1,30 L18, avant/après non-létal et aux temps0/89/90/91/179/180/181 après mort.56 échantillons postévénement sans bonus supplémentaire ; aucun rythme de tirs successifs mesuré. Absence de bonus ne valide ni valeurs natives ni expiration3/6secondes.

Témoin Trundle W distinct appris/lancé publiquement : stat45→38→45,bonus local20%,échantillons0/239/240/241. Ni politique Varus ni durée native déduites.146 refus flags (96 commandes,48 dégâts,deux Trundle),zéro dommage sans mutation déclaré ; toutes les paires individuelles non archivées.25689 ticks archivés et quatre apports diagnostiques100000 XP, pas progression naturelle complète ; aucune fin de partie.

BUILD/RUN hérités0, RUN brut égal OBS. Binaire inerte6073856 octets/SHA `23c414eca110dc7f790b20d9a0121f7cf5159043e9ee0db1a1a59e3739103b72`, identité non fraîchement rehashée.225/225 contrôles et152/152 cohérence séparée du même agent ; aucune revue indépendante/humaine. Aucun nouveau build/jeu/VM/REA/rendu/réseau.

Précontrôle initial échoué : pointeur de prédécesseur transformé en chemin du lot courant. Échec conservé ; reprise sur Urgot,extraits existants préservés,sans recharger le graphe global. Une exploration E seule a supposé un dictionnaire au lieu de la liste champions.json ; requête corrigée. Aucun produit modifié.

## 5. Écarts et inconnues

Valeurs f1/f2,alias effectifs,classification des morts,fenêtre d’assistance,source d’un pet,refresh/cumul/chevauchement,ordre AS/caps et lifecycle restent ouverts. Ni cadence d’attaques ordinaires,multiclient,transport du buff,HUD,tooltip,pixels,animation ou audio qualifiés. Durée textuelle ne démontre pas un timer exécuté.

## 6. Corrections et reprise

`COR-VARUS-LIVING-VENGEANCE-POLICY-01` : sourcer f1/f2,événements,refresh/overlap et lifecycle. Fin : contrat historique établi ou reconstruction explicitement séparée ; aucun emprunt à Q/E,Ashe,Ziggs ou Trundle.

`COR-VARUS-LIVING-VENGEANCE-KILL-STATE-01` : relier morts/assistances qualifiées à état autoritaire. Fin : quatre familles nominales,invalides,fenêtres,réactivation/expiration/mort/pets selon contrat ; conserver récompenses existantes.

`COR-VARUS-LIVING-VENGEANCE-ATTACK-SPEED-01` : consommer le bonus qualifié dans stats et attaques. Fin : L1/L18,bords3/6secondes,ordre/caps,API et cadence ordinaire vérifiés séparément,Trundle/Ezreal/Épuisement préservés.

`COR-VARUS-LIVING-VENGEANCE-HUD-BINDINGS-01` : lier statut,variantes,icône/nom/texte/SourceName/durée et audiences. Fin : transport,tooltip et pixels observés ; résoudre DisplayMinion sans alias inventé. Reprendre sur source/callsite nouveau,dérive ou autorisation fonctionnelle.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_varus_passive_hud_20261105` : evidence_review,coherence_review,archives,DDS,resource_provenance.json,prérequis,qualification et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes et sept protégés contrôlés à publication. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
