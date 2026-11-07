# V1463 — Darius : contrat connu de Hemorrhage

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-DARIUS-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Darius-PASSIF-SIMULATION-CONTRAT, exigence OLF-e52ef526-615b-5a63-8c77-8cce3f5a8712, parent SYS-01.2-02. Audit borné de seize branches connues et des consommateurs sélectionnés. Tâche complète, fonctionnalité et goal restent ouverts. SOURCE reste a_qualifier ; phases, lots, dépendances et inconnues conservés.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue 4.20.1 distinct. Aucun passif récent substitué.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/darius-passive-hemorrhage-bleed-speed-links-v562.json : 564365 octets, SHA256 902daf8d92e263b089deeba3d6dd6ab61a0a68614a20e36560c3eae8291a83ef. Rapport FIDELITY_DARIUS_PASSIVE_HEMORRHAGE_BLEED_SPEED_LINKS_V562.md : SHA256 3fdd322f1d2974569884dedd2195abd5bf792e6c7670ea00989132d5d785f0e1. Preuves antérieures réutilisées ; aucun audit SOURCE daté distinct fourni par la projection candidate, sans conclusion d’absence globale.

Quatorze identités natives, six Lua entièrement parsés historiquement, six vues littérales/douze globals sans callback enfant. CharScriptDarius vide qualifié. Hemo et Internal partagent BuffName sans être un même chunk ; Marker, SpeedKuoManager et Visual restent distincts. DoesntTriggerSpellCasts, PersistsThroughDeath, NonDispellable et IsDeathRecapSource sont des métadonnées, pas des règles d’exécution démontrées. Deux preloads et six références communautaires ne prouvent pas le gameplay ou le rendu.

Quatre clés en_GB retrouvées dans le miroir F identifié : trois bindings V562 et le nom déclaré. Ligne1816 : attaques et capacités infligeant des dégâts, @f1@(+@f2@) dégâts magiques sur cinq secondes, cinq charges maximum ; vitesse +5% par champion ennemi ensanglanté. Ligne1815 : unité saignante ; description4177 : cinq charges. La vitesse dépend du nombre de champions admissibles, pas des charges sur une cible. Lookup ne qualifie pas le fournisseur actif.

Passive1 et niveaux1..6 absents restent inconnus ; anciennes descriptions +40/+60/+80% régénération de mana conservées sans adoption. Aucun montant f1/f2, ratio AD ou calendrier déduit des couleurs. Aucun nouvel accès natif, D/F-work ou ancien EXE.

## 3. Consommateurs réels

Vingt-quatre entrées — seize Rust, deux lecteurs Python, six JSON — concordent avec les identités V562 ; vingt-sept identités courantes gardées. Cinq sélections JSON proviennent de V562. movement_rules.json est une dépendance courante directe d’identité concordante, pas une règle native Hemorrhage.

Trente-trois fenêtres : 31 communes réutilisées, deux supplémentaires movement_speed et periodic_dispatch_Garen. Vingt-trois ancres enregistrées couvrent catalogue et 22 frontières génériques, sans producteur Hemorrhage qualifié.

lib.rs porte commandes/état/tick/snapshot ; progression.rs les stats ; attacks.rs les attaques ; lifesteal.rs la réception Physical ; damage.rs mitigation et réception ; world.rs catégories et dégâts ; spells.rs dispatch et périodiques ; movement.rs composition des vitesses ; shop.rs objets ; lifecycle.rs cycles de vie. Critique, pénétration, boucliers, soin et régénération restent des mécanismes communs.

Le préfixe de production movement.rs est inspecté jusqu’à sa frontière de tests : base et bonus boutique, états génériques et ralentissements, puis soft caps. Aucun compteur de champions ensanglantés qualifié. Les impulsions physiques Garen toutes les quinze ticks ne fournissent pas la cadence Darius. Recherche bornée aux seize Rust : zéro occurrence Darius/Hemorrhage, sans preuve d’absence globale. Aucun rejeu des 1158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : identités, lignes, rôles, valeurs et limites concordants. Observé : 49/49 contrôles documentaires, 60/60 cohérences du même agent ; quatre opérations journalisées réussies. Aucun build ni essai de jeu relancé.

V562 hérité : une attaque, cinq attaques, cinq contre Cape1033, cinq avec Bottes1001 ; seize impacts Physical, AD55.8800011, armure27.5359993, espacement44ticks, résidu maximal0.0000190735. Chaque cas observe180ticks après Stop : quatre fenêtres de six secondes,720ticks cumulés, sans dégâts inexpliqués. Cinq attaques ne démontrent pas cinq charges ; ces fenêtres ne qualifient pas un calendrier natif de cinq secondes.

Cape1033 : résistance magique32.0999985→57.0999985 ; Bottes1001 : vitesse340→365. Les +25 ordinaires ne prouvent ni mitigation d’un saignement positif ni bonus natif5%. Les données boutique sont respectivement500/+25RM et325/+25vitesse.

Soixante refus publics hérités, dont48 Learn/Cast/CastAt et12 joueur/cible invalide/soi ; snapshots inchangés hérités. Aucun déclencheur de sort Darius qualifié. Binaire historique uniquement identifié en données : 6030848 octets, SHA256 f7670efc4fe7236085b3f25f9190a1db96e0e203613209347d97bb182b062754 ; aucun accès ou lancement.

## 5. Contrat connu et écarts

Durée cinq secondes, plafond cinq charges, dégâts magiques et vitesse5% par champion ensanglanté sont écrits. Restent ouverts : montants/scaling, application par attaque et sort, éligibilité, propriété, refresh/expiration, première/dernière impulsion, cumul et cadence, compte des champions, portée, composition des vitesses, catégories, critique, boucliers, ordre létal, crédit et cycles de vie.

Ni le tick courant30Hz ni Garen15ticks ne résolvent cette temporisation. Persistance et recap déclarées ne démontrent pas conservation des états ou attribution des morts. Aucun changement de type magique vers physique moderne.

## 6. Corrections et reprise

Treize fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-DARIUS-HEMORRHAGE-, suffixe -01 : AUTHORITY, ATTACK-TRIGGER, SPELL-TRIGGER, STACKS, TICK-TIMING, MAGIC-DAMAGE, SPEED-COUNT, SPEED-COMPOSITION, TARGETS, PROC-ORDER, LIFECYCLE, PROJECTION, VERIFICATION.

Chaque fiche possède objectif, tâche V562 existante associée, prérequis, travail, critère de fin propre et condition de reprise. Reprendre sur source précise, nouveau callsite, dérive ou contradiction ; correction fonctionnelle sous autorisation distincte. Conserver inconnues, dépendances et SOURCE a_qualifier. Les contrôles futurs doivent produire un saignement positif avant de qualifier RM, charges ou vitesse.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_darius_passive_simulation_contract_20261106. Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2449 entrées groupées modifiées au resume, conservées. Prochaine sélection : Diana depuis les122paires existantes, sélection distincte d’une clôture.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité et inconnues ouvertes. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit et assets inchangés. Aucun nouveau runtime, REA, rendu, audio ou réseau ; aucun logiciel installé.
