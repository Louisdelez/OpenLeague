# V1468 — Evelynn : contrat connu de Shadow Walk

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-EVELYNN-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Evelynn-PASSIF-SIMULATION-CONTRAT, exigence OLF-e873c507-b141-55c8-8170-5126d530b8c6, parent SYS-01.2-02. Audit borné de vingt branches connues et des consommateurs sélectionnés. Tâche complète, fonctionnalité et goal restent ouverts ; SOURCE a_qualifier, phases, lots, dépendances et inconnues conservés.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue 4.20.1 distinct. Aucune mécanique récente substituée.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/evelynn-passive-shadow-walk-links-v567.json : 748345 octets, SHA256 c060a6870a7f4705c35521352c54eca24920f2304b19c146c9c7f6f1fd729545. Rapport FIDELITY_EVELYNN_PASSIVE_SHADOW_WALK_LINKS_V567.md : SHA256 d222a7c5fa543ae8d517d1f4d8ff066d1867eead5a89d4f1187f8b379f4b2750. V567 réutilisé ; aucun audit SOURCE daté distinct fourni par la projection candidate, sans conclusion d’absence globale.

Vingt-six identités natives ; dix Lua complètement parsés historiquement, 39 globals littéraux, sans prototypes enfants. CharScript vide qualifié. Dix preloads et dix références communautaires restent distincts du gameplay. Le listener communautaire OnTakeDamage appelle un corps vide ; aucune machine de furtivité déduite de cette inscription.

Six clés en_GB retrouvées : quatre tooltips, description, nom ; cinq bindings V567 conservés. Ligne1879 : visibilité par champions ennemis proches ou vraie vision, 1% du mana maximum par seconde en furtivité ; lancement de sort, dégâts reçus/infligés interrompant la furtivité six secondes. Description4183 : entrée hors combat. Portée, exceptions, cadence et composition des taux inconnues ; aucun remplacement par mana manquant ou soin moderne.

Les tooltips EvelynnPassive/StealthMarker et anciens ShadowWalk/RevealedDebuff restent distincts. ShadowWalk déclare slot2 et CastTime0.5, alors que Spell2 désigne EvelynnW : aucune substitution automatique. Casse Nondispellable du passif et NonDispellable de ShadowWalk conservée. Icônes ReadyToBetray, marqueurs et flags ne prouvent pas leurs callbacks.

BaseMPRegen absent ne vaut pas zéro : BaseStaticMPRegen vaut1.6216000318527222, hash619143803. Le classement Scripts/DATA-Spells relevé dans V567 n’est pas un manque de ressources. Aucun nouvel accès natif, D/F-work ou ancien EXE.

## 3. Consommateurs réels

Vingt-huit entrées — dix-huit Rust, deux lecteurs Python, huit JSON — concordent avec V567 ; 31 identités courantes gardées. Sélections héritées : définitions/croissance, cristal1027, type de ressource, rayons/vision, interactions et spawns Map10.

Trente-sept fenêtres : 32 communes réutilisées et cinq supplémentaires pour vision, projection par joueur, plafonds de mana, impulsion de fontaine et appel serveur. Vingt-cinq ancres couvrent catalogue et 24 frontières génériques ou appel statique, sans producteur Shadow Walk qualifié.

visible_to utilise équipe, cible, révélation Ignite et visible_point_to. Cette dernière compose sources alliées, autels, unités, rayons et ligne de vue/terrain ; aucun état Evelynn dans ces corps inspectés. Le rayon général1350 ne devient pas un rayon natif de détection du camouflage.

snapshot_for filtre joueurs, unités et projectiles. Le serveur appelle cette fonction, forme les datagrammes et appelle send_to ; lecture statique, sans exécution du transport. La projection omnisciente est un instrument de diagnostic distinct.

stats/refresh_item_caps conservent et plafonnent le mana courant. regeneration_rates/advance_regeneration produisent base/croissance/objets via restores_resource. La fontaine ajoute sa propre impulsion ; aucun état furtif ni supplément conditionnel qualifié dans ces chemins.

Recherche bornée aux dix-huit Rust : zéro occurrence Evelynn/ShadowWalk/Shadow_Walk, sans preuve d’absence globale ni rejeu des 1158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : identités, lignes, règles écrites et limites cohérentes. Observé : 57/57 contrôles documentaires, 67/67 cohérences du même agent ; quatre opérations journalisées réussies. Aucun build ni essai de jeu relancé.

V567 hérité : deux parcours publics à250 et899.9995117unités, chacun360ticks sans combat, visible et projeté pour l’adversaire à chaque tick ; 24 refus Learn/Cast/CastAt atomiques. Les projections initiales aux bases et les refus cible/équipe/observateur invalides restent dans la portée du rapport antérieur. Aucun seuil historique ne se déduit de ces deux distances ; environ900 visible ne prouve pas seul une violation du rayon inconnu.

Troisième parcours : achat1027 après210ticks. Mana courant265.6000061 conservé, maximum265.6000061→465.6000061, déficit200 créé par la boutique publique ; coût400, +200mana, 0%régénération. Les vingt incréments211..230 correspondent à la base1.62160003mana/s selon le rapport. Ils sont entre les impulsions de fontaine courante à30ticks ; aucune impulsion n’est promue en passif.

1% de ce maximum représente4.65600014mana/s. Aucun état furtif établi ou injecté : cette comparaison ne qualifie ni bonus conditionnel ni addition/remplacement du taux de base. Les sémantiques natives d’achat et de modification des réserves restent ouvertes.

Binaire historique uniquement identifié en données : 6112768 octets, SHA256 f7aaacde45883b6a7b4c9340972c43139febabb432a9ad773269737b44ab3a9c. Aucun accès, hash ou lancement.

## 5. Écarts et conclusions ouvertes

Manquent : entrée/initialisation hors combat, événements de révélation et exceptions, refresh/limites des six secondes, proximité exacte/vraie vision et leur composition avec la vision générale, mana conditionnel/composition/cadence/plafonds, cycle de vie, audiences et présentation.

Les observations de visibilité générale et de régénération sans état furtif restent des témoins limités. Appel de snapshot_for ne qualifie ni transport, ni brouillard rendu, ni effets visuels/audio. Les deux inspections V567 et la correction de seule mention V566 dans un sélecteur restent conservées, sans remplacement d’observation native/runtime. Navigation V564 non corrigée et non réauditée.

## 6. Corrections et reprise

Seize fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-EVELYNN-SHADOW-WALK-, suffixe -01 : AUTHORITY, STATE-ENTRY, REVEAL-CAST, REVEAL-INCOMING, REVEAL-OUTGOING, SIX-SECONDS, PROXIMITY, TRUE-SIGHT, VISION-COMPOSITION, MANA-RATE, MANA-COMPOSITION, MANA-CAPS, MANA-TIMING, LIFECYCLE, PROJECTION, VERIFICATION.

Chaque fiche possède objectif, tâche V567 réellement associée, prérequis, travail, fin distincte et condition de reprise. Reprendre sur source précise, dérive, contradiction ou comportement supporté non vérifié ; correction fonctionnelle et nouvelle exécution sous autorisation distincte. Conserver les témoins et leurs limites.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_evelynn_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2454 entrées groupées modifiées conservées. Prochaine sélection Ezreal depuis les 122 paires existantes ; préserver son producteur partiel, sélection distincte d’une clôture.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité, inconnues et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit et assets inchangés ; aucun nouveau runtime, REA, rendu, audio, réseau ou logiciel installé.
