# SYS-01.2-02 — Karma : liaison de Gathering Fire au HUD, V1228

4 novembre 2026. Unité `AUD-SYS-01.2-02-KARMA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture puis publication racine. Mécanique, HUD complet et acceptation restent ouverts.

## 1. Exigence et périmètre

`CH-Karma-PASSIF-PRESENTATION-HUD`, `OLF-dfae7de8-e69d-5289-82d2-41553d3cd6f4`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-4e043f2a-cd65-55b9-8e23-b131ba28e419` reste ouverte. Six contrats HUD, NETWORK, SIMULATION, CONTRAT, SOURCE, ACCEPTANCE et leurs six inconnues propres sont conservés ; PRESENTATION parent reste distinct.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V583 UTC 2026-10-26T03:42:06.705625+00:00 ; MD UTC 03:49:43.704670. Dates documentaires, sans date d’exécution déduite.

V583 possède 12 identités natives/36 associations sur trois tâches. SOURCE actuel :16 relations/12 identités. HUD possède une relation, définition. Captures historiques conservées exactement sur E avec provenance/empreintes ; chemins F-work inertes. Métadonnées/font/INIBIN/Lua/DDF/preload ne sont pas relus sur D.

KarmaPassive et R=KarmaMantra sont distincts. PassLev1Desc1 lie4210 : dégâts de capacités à un champion ennemi, moitié de l’effet sur attaques de base. Six champs de rangs passifs absents, sans défaut inventé. Buffs2145/2139 et textes9534/11629 sont liés ; f1/f2 restent non résolus. Mantra9533 annonce disponibilité niveau1 sans point ;11628 décrit huit secondes d’amélioration ; délais natifs45/42/39/36s. Disponibilité, délai, fenêtre et remboursement restent quatre contrats distincts.

DDF28 dont quatre lignes KarmaPassive à liens/coefficients vides ne résout pas f1/f2. Chakra30/25/20, ancien compteur une/deux charges, SpellData passif cooldowns8/7/6/5 et effets18/36/54/72–30/60/90/120 ne deviennent pas des remboursements. Anciennes descriptions d’auras HP/mana sont conservées sans remplacer la description liée.

Quatre Lua entièrement parsés sans prototype enfant ; trois initialisations littérales et une limite NEWTABLE pc6 pour Mantra, sans corruption démontrée. CharScriptKarma.luaobj déclare PersistsThroughDeath/NonDispellable=true ; il n’est pas vide. Trois preloads/particules activation-refresh et flags IsDamagingSpell/DoesntTriggerSpellCasts/persistance/non-dissipation restent déclaratifs, sans politique serveur/rendu déduit. Huit références communautaires et la classe CharScriptKarma.cs vide restent secondaires.

Inventaire exact avant lecture ciblée :

| Chemin lu | Octets | Format | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Karma/HUD/Icons2D/Karma_Passive.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.155 |

Un DDS/2176octets ; Karma_Passive.dds : `6dc557f974acbac8b2f68d3933b48c78858ecedb0312d26d950e921a16589ec4`. Taille/MD5/membership vérifiés. KarmaInnerFlame.dds déclaré par le buff n’est pas retrouvé dans le manifeste sélectionné ni les sous-arbres physiques Karma/Spells inspectés. Cela ne démontre aucune absence globale/corruption et n’autorise aucun alias avec Karma_Passive. Lookup/variante/pixels/rendu restent ouverts. Localisation en_GB et témoin Ahri identifiés sur miroir F ; aucune relecture font D, locale effective ouverte.

## 3. Consommateurs actuels

Le catalogue est appelé par Simulation::new. SOURCE couvre six sites/trois fichiers ; V58319sites/11fichiers, plus deux lecteurs. Apprentissage, cast, attaques/projectiles, dégâts/lifesteal, CDR, remboursements spécifiques et lifecycle sont inspectés.

Karma est refusée avant rang/délai. La grille générique d’ultime6/11/16 ne qualifie pas Mantra niveau1. CDR/cap/clamp/minimum/ceil à la création et décompte des délais absolus sont réels ; ils ne constituent pas un remboursement sur hit. Le remboursement EzrealQ existe avec ses gardes/propriétaires, sans transfert vers Karma ni nouvelle qualification runtime. Aucun producteur Gathering Fire identifié dans les corps inspectés ; aucune absence globale déduite.

Provider/StartupHud, barres, QWER, Buff0 Ezreal, F3/Annie et snapshot/session/horloges existent sans liaison Karma icône/texte/rang/état autoritaire établie. Dix icônes QWER, quatre primaires/six variantes QWE et zéro unresolved ne constituent pas l’icône passive intégrée. Délai nul n’est pas une preuve de disponibilité native.

## 4. Attendu, observé et contrôles

Attendu : Mantra disponible et état de remboursement qualifié, ressources reliées aux widgets/audiences applicables. Observé : déclarations et voies génériques réelles, refus courant, liaison spécifique non établie. Sources 69/69, relecture E 70/70 ; consommateurs 64/64, relecture 10/10. Seize entrées/29 fenêtres communes,19 ancres V583,six SOURCE et 9 pins/15 fenêtres directes sont vérifiés. Un producteur source, une relecture E, un collecteur et une relecture consommateurs : premiers passages réussis, sans échec, correction ou retry. Entrées/manifestes et journaux effectifs sont conservés ; diagnostics historiques non rejoués. Le brouillon racine est archivé avant ajout de ces résultats réels, sans modifier les composants gelés.

V583 hérité : deux cas Karma/Annie, base et Codex3108, douze impacts physiques non critiques avec projectiles source/cible témoins,34 refus sans mutation et180ticks après attaques. Dégâts corrigés de régénération, résidu<0,002 ; autres ticks régénération seule, deux champions vivants/sans kill. Karma niveau1, rangs/délais[0,0,0,0]. Mantra sans cible est refusé avant/après attaques ; ce n’est pas un simple mauvais type de cible. Sans délai de Mantra activé, aucun montant ni échec isolé du remboursement n’est mesuré.

Deux contrôles GarenQ séparés : apprentissage/cast acceptés, relance refusée, délais240/216ticks avec0/10%CDR ; Codex30AP. Deux refus et180ticks de suivi, échéance absolue constante pendant décompte naturel. Total :36 refus publics,180ticks Karma+180ticks Garen. CDR à la création est qualifiée seulement dans ces témoins, sans transfert vers Gathering Fire. Aucun hit de capacité Karma ni lifecycle/réseau/rendu qualifié.

Binaire historique6049792octets, SHA`f0f2927e2383981625873442b3a45169212159eaf776716083d7dc2df2a7266e`, BUILD/RUN0 hérités. Ancienne erreur de citation avant modification/inspection corrigée par patch, journaux conservés. Aucun nouveau build, jeu, VM, REA, réseau, GPU, audio ou rendu ; Jinx/stockage/Jax/V564 restent conservés, sans replay de récupération/nettoyage ni copie de bases.

## 5. Écarts et inconnues

Disponibilité/progression Mantra, f1/f2/niveaux, hits/cibles éligibles, persistants/multicibles/invocations/absorption, plancher/ordre CDR/arrondis/simultanéité, refresh, mort/respawn/session/reconnexion, lookup/alias/rangs/états/audiences et rendu restent ouverts. Absence de callbacks n’établit aucun asset3D manquant.

## 6. Correction et reprise

Réutiliser `CH-Karma-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION. Qualifier disponibilité native niveau1, rangs/délais/fenêtre8s et f1/f2 sans substituer valeurs héritées ; lancer un vrai Mantra puis relier les hits éligibles à l’état autoritaire de réduction. Intégrer le HUD avec refus/retrait des données absentes, invalides, périmées ou non autorisées. Vérifier catégories, valeurs/planchers, ordre avec CDR, limites temporelles, invocations/multicibles/simultanéité, mort/reconnexion et rendu sur binaires/ressources identifiés. Préserver témoins Garen/Ezreal distincts et acceptation humaine. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_karma_passive_hud_20261104`, sources/consommateurs/scripts/journaux/archives/result/finalpeer. Préparateur f9/vérificateur racine V1226 réutilisés ; toutes entrées/archives incluses. Publication : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture bornée après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
