# V1495 — Kog’Maw : contrat connu d’Icathian Surprise

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-KOGMAW-PASSIF-SIMULATION-CONTRAT-01, tâche CH-KogMaw-PASSIF-SIMULATION-CONTRAT, exigence OLF-6078df16-451e-5871-83df-b794b0f4b73d, parent SYS-01.2-02. Audit borné de26 branches connues, distinct de la résolution de toutes les politiques historiques. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/kogmaw-passive-icathian_surprise-links-v590.json du26 octobre2026 :1011796 octets, SHA256 d8cea6207e3bd55e2fa0062e61c3a61fdd45bef47fa965fb40c275723d17e790. Rapport FIDELITY_KOGMAW_PASSIVE_ICATHIAN_SURPRISE_LINKS_V590.md :15142 octets, SHA256 12c1abe69443be9987a8ec1a4aa7b6f873b1123a1f8ebe5f48e89d7f39f5d00c. Cache de rapports vide, MD existant retrouvé au chemin explicite ; aucune fausse absence d’asset ou modification de cache.

18 identités natives, dix références communautaires séparées, quatre preloads. Six Lua entièrement parsés historiquement, zéro prototype enfant ; cinq initialisations littérales,18 globals dont deux CharScript vides. Une limite NEWTABLE pc26 dans Surprise : aucune corruption ou absence de callback déduite. CharScript communautaire vide ; aucune exécution du serveur historique.

Huit clés en_GB présentes vérifiées. Description personnage4217 : mouvement plus rapide après mort, explosion après4 secondes,100+25×niveau en dégâts bruts. Display2186 décrit4 secondes et f1 dégâts bruts. Surprise/Sound liés2187/2188. Les trois champs SpellData Description/DynamicTooltip/DynamicExtended lient9568/11663/10992, annonçant160+30×niveau en dégâts magiques. Les deux familles sont liées ; rôle effectif/obsolescence et priorité restent ouverts. Aucun texte choisi par facilité d’implémentation.

DDF20 lignes QWER sans Icathian ; producteur f1 inconnu, sans formule nulle inventée. CastRadius1000, CastRange1600, Coefficient0,7, projectile, son hérité et IsDisabledWhileDead=1 sont des champs SpellData ; aucun rayon, formule ou refus passif automatiquement adopté.

Vivant : Passive1LuaName=KogMawIcathianDisplay, Q=KogMawQ, vitesse325. KogMawDead et sa base existent : Passive1LuaName=KogMawIcathianSurprise, Q=KogMawCausticSpittle, vitesse330 et statistiques différentes. Ces valeurs ne prouvent ni transformation ni multiplicateur de vitesse. Six niveaux passifs absents, sans défaut inventé.

Ready/Display portent persistance après mort et non-dissipation ; métadonnées distinctes de callbacks. Preloads citent forme morte, untargetable, unlockanimation, avertissement sonore et effets base/skin08, sans qualification runtime/visuelle/audio. Quatre chemins candidats absents limités, fichiers réels conservés sans alias silencieux. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

29 entrées concordent avec V590 :17 Rust, deux lecteurs Python, dix JSON. Avec le miroir en_GB,30 identités gardées.34 fenêtres dont32 communes réutilisées, plus champion_kills1–53 et movement1–81.23 ancres enregistrées dont22 entry_boundary_only/provides_feature_consumer=false ; tous les renvois de branches résolus.

command refuse le joueur mort avant dispatch. cast/cast_at disposent aussi de gardes mortes ; vivant, Learn/Cast/CastAt de Kog’Maw restent non implémentés. apply_damage efface windup/chemin/effets/boucliers/contrôles et pose immédiatement respawn_at au décès. Les appels Trundle et reward_champion_death sont des mécanismes existants préservés.

mitigate distingue True et Magical ; boucliers, crédits/or/XP, vitesse générique et restauration existent. Ces récepteurs ne sont pas une explosion. advance_regeneration exclut les morts. lifecycle utilise Level01=16 secondes, plafond de niveaux1–18 et restauration position/santé/mana ; cette réapparition ordinaire reste distincte du passif4 secondes.

Recherche KogMaw/Icathian sur17 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer mort ordinaire, phase temporaire, formule et rayon qualifiés. Observé :101/101 contrôles documentaires,104/104 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V590 hérité : deux parties publiques Map10, Kog’Maw victime et Annie attaquante. Cas base546,16HP puis Rubis1028 acheté400or, bonus150HP soit696,16HP ;14 puis18 impacts,32 projectiles Annie→Kog’Maw témoins. Deux morts, première élimination400or dans chaque partie neuve, victime niveau1, deux réapparitions ordinaires.

Par cas82 refus dont55 pendant la mort : aux offsets0/1/119/120/121, quatre Cast, quatre CastAt et Move/Attack/Stop renvoient champion dead sans mutation. Total164 refus dont110 morts. Ces frontières encadrent4 secondes à30Hz locaux, sans qualifier l’horloge historique.

Jusqu’à479 ticks : santé0, position/mana/identité kogmaw et échéance inchangés. Ennemi immobile à100 unités du corps et pleine santé ; aucune perte de santé d’explosion pendant960 ticks cumulés. Cette distance ne détermine pas le rayon natif. À480 ticks, santé/mana restaurés, retour base et déplacement à nouveau accepté.480 ticks=16 secondes ordinaires, pas quatre secondes de passif.

Attendu des descriptions : phase mobile puis détonation. Observé : mouvement mort refusé, aucune explosion observée dans ces scénarios. Ni formule ni rayon historiques validés. Snapshots locaux sans transport, rendu ou audio exercés.

Exécutable V590 identifié uniquement en données :6043136 octets, SHA256 3b8eb3abde50f1190def29204d6bc8d734ade0ec1412d9f267c2941d06c5b73f. BUILD/RUN0 hérités ; aucun accès/lancement actuel, toolchain/lock/1158 entrées non requalifiés. Échecs antérieurs conservés.

## 5. Écarts et conclusions ouvertes

Restent contrat bruts/magiques, f1, identités/formes, transition létale, crédit, commandes, vitesse/navigation, ciblabilité, persistance/effets engagés, chronomètre, rayon/cibles/dégâts, attribution/niveaux, simultanéité/résurrection dont Yorick, réapparition, lifecycle, intégration, réseau et présentation.

Question propre OLU-5c2ab9bb-5da0-59d5-86bb-d8b7b52c3aa3 distincte de SOURCE OLU-ee18e3cf-6778-52da-bc73-a2aea053849a. Dépendances/propriétaires conservés, aucune inconnue fermée ; V564/BattleTraining non corrigés.

## 6. Corrections et reprise

26 fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-KOGMAW-ICATHIANSURPRISE-, suffixe -01 : CONTRACT-PRECEDENCE, DYNAMIC-FORMULA, NAME-FORM-BINDINGS, LUA-METADATA, LETHAL-TRANSITION, DEATH-CREDIT, POSTMORTEM-COMMANDS, SPEED-ACCELERATION, NAVIGATION, TARGETABILITY, PERSISTENCE, PENDING-EFFECTS, CLOCK-4SECONDS, EXPLOSION-RADIUS, TARGET-SELECTION, DAMAGE-COMPOSITION, OWNERSHIP-CREDIT, LEVEL-SCALING, SIMULTANEOUS, REVIVAL-YORICK, RESPAWN, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, critère positif distinct et condition de reprise pour chacune.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios : vraie mort publique, phase mobile/explosion, plusieurs niveaux/causes/cibles, frontières spatiales/temporelles et refus. Résoudre d’abord le contrat avant d’adopter des chiffres ; aucune injection d’horloge/dégâts/forme pour déclarer la fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_kogmaw_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2481 entrées groupées préexistantes conservées. Prochain Leblanc depuis122 paires ;73 candidats hors49 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Reçus et32 fenêtres communes réutilisés, lectures groupées ; aucun gain temporel mesuré, aucune installation/migration.
