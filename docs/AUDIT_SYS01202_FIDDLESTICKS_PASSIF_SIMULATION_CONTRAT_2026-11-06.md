# V1470 — FiddleSticks : contrat connu de Dread

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-FIDDLESTICKS-PASSIF-SIMULATION-CONTRAT-01, tâche CH-FiddleSticks-PASSIF-SIMULATION-CONTRAT, exigence OLF-66f3219c-ef3a-563e-8e29-2fb650ed4ce4, parent SYS-01.2-02. Audit borné de dix-huit branches connues et des consommateurs sélectionnés. SOURCE demeure a_qualifier ; phase D06, six prérequis du lot, dépendance et propriétaires d’inconnues conservés. La tâche complète et la fonctionnalité restent ouvertes.

Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue officiel4.20.1 distinct. Aucune mécanique récente substituée à Dread.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/fiddlesticks-passive-dread-links-v568.json : 554399 octets, SHA256 2269775dff8405699a0bf5c5783cdd29a6c90d359c5f60ed07617d2e11c4d816. Rapport FIDELITY_FIDDLESTICKS_PASSIVE_DREAD_LINKS_V568.md : SHA256 3ff59e6dda2ce2dfc96623266b0655a3e247f33f7ace1166f63cc567a8f0f87e. Preuves V568 du25octobre2026 réutilisées, sans nouvelle publication de leurs anciens liens.

Neuf identités natives retenues parmi dix candidats : définition, miroir en_GB, CharScript/preload, deux INIBIN Paranoia, deux Lua Paranoia et preload associé. Membership hérité des manifestes sélectionnés, sans nouvelle vérification des fichiers natifs ou priorité de montage.

Passive1LuaName désigne Paranoia. Quatre clés en_GB retrouvées, lignes2449/2450/4185/4361 ; deux liaisons de tooltip réelles. Texte : unités ennemies proches perdant dix points de résistance magique. PassLev1Desc1 absent : la description reste candidate, sans liaison inventée. SpellBlock contient la chaîne30.0, BaseSpellBlock est absent ; absence ne vaut pas zéro.

Trois Lua complètement parsés historiquement, six globals littéraux et aucun prototype enfant ; CharScript sans global. PersistsThroughDeath/NonDispellable sont déclaratifs. ParanoiaMissChance déclare BuffName="Paranoia Aura" ; aucun raté déduit du nom de fichier. Fearmonger_marker déclare Drain et reste exclu de Dread ; NocturneParanoia et autres résultats sans liaison ne sont pas adoptés. Deux preloads et huit références communautaires restent distincts d’un serveur natif.

## 3. Consommateurs réels

Vingt-trois entrées concordent avec V568 : dix-huit Rust, deux lecteurs Python, trois JSON. Sélections héritées : définitions/croissance fiddlesticks, Annie, Garen et objet1033. Vingt-quatre identités courantes gardées en incluant le miroir en_GB.

Trente-six fenêtres : 32 communes réutilisées avec identité/lignes exactes, quatre supplémentaires pour défenses Exhaust, TrundleR, Annie et plafonds d’achat. Vingt-cinq ancres enregistrées : catalogue et24frontières entry_boundary_only, provides_feature_consumer=false pour Dread.

stats compose base/croissance/objets, défense Annie, Exhaust et ajustement TrundleR. penetrated_defenses applique les objets de l’attaquant ; ce n’est pas une réduction de résistance de la cible profitant aux alliés. Le calcul négatif/zero-floor est une reconstruction courante explicitement commentée, pas la politique native de Dread.

apply_damage utilise défenses puis mitigation, boucliers et retrait de santé ; mitigate distingue Physical/Magical/True. Aucun terme d’aura Dread n’est identifié dans ces corps inspectés. Recherche littérale FiddleSticks/Dread/Paranoia dans les18Rust : zéro occurrence, sans conclusion d’absence globale ou rejeu des1158dépendances.

Initialisation, dispatch, Learn/Cast/CastAt, tick, snapshot, achats et cycle de vie sont des chemins actuels. Leurs refus ou données de base ne prouvent pas le passif. Les anciens points génériques ne sont pas promus en implémentation de Dread.

## 4. Attendu, observé et contrôles

Attendu documentaire : sources, champs, appels, observations et limites cohérents. Observé :61/61contrôles documentaires,91/91cohérences du même agent ; quatre opérations productrices journalisées réussies. Aucun nouveau build, jeu, REA ou diagnostic exécuté.

V568 hérité : trois phases publiques, cible Annie rouge et voisin bleu, distance250unités,300ticks chacune. Fiddlesticks sans objet : RM30 ; avec achat public1033 : RM55 ; témoin Garen : RM30. L’objet ajoute25RM. Les900ticks et33refus publics avec snapshot conservé restent distincts des diagnostics. Aucune position, santé, ressource, XP ou rang directement injecté dans ces phases selon le rapport antérieur.

250 est une géométrie d’essai, pas le rayon historique établi. Le contrôle objet montre un calcul de statistiques variable ; il ne constitue pas une aura. La comparaison au code délimite le manque actuel sans prouver l’éligibilité native à cette distance.

Trois événements serveur apply_damage(100,Magical), séparés des phases publiques :76.92308044/64.51612854/76.92308044 après mitigation. Ils concordent avec10000/(100+RM), tolérance0.0001 ; neuf refus diagnostiques séparés. Ce ne sont ni des sorts publics réussis, ni des projectiles acceptés, ni une démonstration des dégâts d’un allié sous Dread.

Ancien essai initial build0/run101 : mauvais chemin bonuses.magic_resist ; correction séparée lisant magic_resist sur l’objet. Échec et exécutions antérieures conservés. Exécutable qualifié V568 uniquement identifié en données :6066688octets, SHA256 72b41ff21a6ebc08f85967fb4c344db2d8bfbd46f2ce57cd862f361b062750a0. Aucun accès, hash ou lancement ; chaîne/build/1158entrées non revérifiés ici. Navigation V564 non corrigée ni réauditée.

## 5. Écarts et conclusions ouvertes

Restent : autorité native des valeurs/callbacks, rayon/métrique, classes ennemies admissibles, entrée/pulses/sortie/linger, mort/réapparition, propriétaires et cumul. La réduction cible de dix points, son ordre avec autres modificateurs, les résistances négatives et l’effet sur dégâts alliés ne sont pas qualifiés. Métadonnées de persistance et diagnostics ne ferment pas ces inconnues.

Snapshot générique ne qualifie ni transport réel, HUD, animation, VFX ou audio. Aucun modèle ou texture manquant démontré. Questions propres et SOURCE conservées chez leurs propriétaires, aucune inconnue fermée.

## 6. Corrections et reprise

Treize fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-FIDDLESTICKS-DREAD-, suffixe -01 : AUTHORITY, RADIUS, TARGETS, TIMING, LIFECYCLE, MULTIPLE-OWNERS, TARGET-MR, COMPOSITION, NEGATIVE-MR, ALLY-DAMAGE, WORLD-TARGETS, PROJECTION, VERIFICATION.

Chaque fiche possède objectif unique, tâche liée, prérequis, travail, fin distincte et condition de reprise. Reprendre sur source nouvelle, dérive, appel nouveau ou cas supporté nécessaire non couvert. Les corrections fonctionnelles et essais supplémentaires demandent un périmètre d’exécution distinct ; aucune modification du plan ou de ses bases ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_fiddlesticks_passive_simulation_contract_20261106. Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ;2456entrées groupées préexistantes conservées. Prochaine sélection exacte Fiora depuis122paires ;98candidats hors24unités nommées, sans compte de tâches complètes déduit.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit/assets inchangés ; aucune installation, migration ou nouvel accès D:/F-work/ancien EXE.
