# Gnar — Rage Gene, icône et état vers le HUD

2026-11-05 · V1310 · AUD-SYS-01.2-02-GNAR-PASSIF-HUD-ICON-STATE-LINK-01

## 1. Exigence et périmètre

CH-Gnar-PASSIF-PRESENTATION-HUD ; OLF-0a06c22c-2d6f-5903-afa6-ab1bac64b211 ; inconnue OLU-c28fb370-4241-57d2-b601-a62b98da17ec. Parent SYS-01.2-02 actif. Audit documentaire de liaison uniquement : icône, texte, ressource et états Mini/Mega vers les consommateurs courants. Les six contrats SOURCE, SIMULATION-CONTRAT, SIMULATION, NETWORK, PRESENTATION-HUD et ACCEPTANCE restent ouverts. Phase D06, lot D06-CH-Gnar ; dépendance HUD → NETWORK non déclarée satisfaite. Voir phase_package_prerequisites.json.

Audit : clôturable pour cette liaison après décision et publication vérifiée. Implémentation : partielle ; vérification : statique et preuves historiques bornées ; acceptation humaine : non donnée. Aucun jeu ou champion déclaré terminé.

## 2. Sources, provenance et limites

Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus ; catalogue 4.20.1 distinct. V571 daté 2026-10-26T00:18:17.004631+00:00, 752263 octets, SHA-256 81a7e3ead5505fba27a315e28af96f2014490bd4a0f0336c0172360d35ee0936. Supplément V572 : 960202 octets, SHA-256 c3e80b2a3fdaffaa14b9f121e8492c30cbfc8c239dbae3e4bb9389f880fd72da. Identités complètes dans initial_scope.json et supplement_scope.json.

24 ressources natives déjà examinées : 7 INIBIN, 9 Lua, 7 preloads, font. Mini et Mega déclarent GnarPassive/Gnar_Passive.dds, Gnarfury et BaseMP «100.0» ; PARStart absent, donc rage initiale native inconnue. Définitions et différences de statistiques ne fournissent ni bonus dynamiques ni transition. Les quatre noms QWER déclarés sont identiques entre formes.

GnarPassive.luaobj déclare texture, nom et PersistsThroughDeath, sans exécution de callback. Neuf chunks consommés, aucun enfant ; cinq limites NEWTABLE conservées. Constantes AutoCooldownByLevel et RocketTristana ne sont pas adoptées comme règles de fatigue. GnarWProc appartient au W.

Font en_GB vérifiée par identité du miroir F : lignes 1950/1951/1954/1955/1956 et description 4193. Le texte fournit génération en combat/attaque, transformation au prochain sort à rage maximale, durée 15s et paramètres f1/f2/f3/f4/f5/f7/f8 ; leurs producteurs restent inconnus.

Une DDS propre au HUD Gnar, membre 0.0.0.244 : 2176 octets, 64×64 DXT1, mipmap_count=0, SHA-256 f923dc37f1e82479e6851befbb6c6fd05bfd9087060fbbb95da095913b35409b. Sélection E antérieure à l'unique stat/lecture native. Aucun nouveau décodage INIBIN/Lua/font natif. Pas de priorité provider, de fallback partagé ou de rendu déduit.

## 3. Consommateurs réels

SOURCE : 30 relations/24 IDs, six sites sur trois fichiers ; V571 : 24 frontières sur douze fichiers. Union : 30 ancres sur quatorze fichiers. 33 fichiers code/configuration contrôlés ; 16 communs et 21 identités de chacune des références V571/V572 inchangés. V572 réutilise les 24 consommateurs sans ajout.

lib.rs initialise mana depuis def.mana ; regeneration.rs délègue à restores_resource, limité à Mana/Energy. lifecycle.rs remplit Mana/Energy/Wind à la réapparition et met les autres à zéro. champion_resources.json classe Gnar Gnarfury. Son source_sha256 embarqué reste une provenance historique distincte de l'identité native sélectionnée.

native_hud_bars.rs affiche les PV mais crée une fraction de ressource uniquement pour Mana ; native_hud_widgets.rs applique la même garde à MPStat. Gnarfury n'est donc pas alimenté par ces voies. Le catalogue comporte quatre InventoryIcon QWER et huit variantes explicites, aucune Gnar_Passive. La voie Buff0 d'Ezreal est spécifique. Recherche bornée : une occurrence Gnar dans un test de catalogue d'animation spell4/Ashe, sans producteur Rage Gene ni binding HUD établi ; aucune absence globale déduite.

## 4. Attendu, observé et contrôles

Attendu : sources et consommateurs reliés, écarts et refus conservés. Observé : 73/73 contrôles documentaires qualifiés, 60/60 cohérence séparée du même agent ; identités, ancres, six bindings font et DDS vérifiés. Aucun test Rust/Bevy, jeu, build, REA, VM, réseau ou GPU nouvellement exécuté.

V571 hérité : trois cas idle/attaques émises/reçues, 12 impacts, ressource 100/100 avant/après, 48 refus atomiques, 1800 ticks de suivi. La saturation empêche de mesurer le gain. V572 hérité : 42 impacts publics préparent trois morts ; réapparition après 480 ticks, ressource 0/100. Puis 0/6/6 impacts : zéro maintenu, 54 refus, 1800 ticks. Ces cas établissent l'absence de gain observé dans le Rust testé, pas la politique native.

Trois archives sélectionnées, 1425091 octets, identités conservées. Binaires historiques 6035456/ec128b08… et 6059520/94b11682… : SHA complets dans evidence_review_corrected.json, non relus ni rejoués. Anciennes captures brutes/RUN et dépendances non réexaminées. Deux essais antérieurs BUILD0/RUN101 conservés : origine de dégâts ambiguë ; le successeur change de zone via déplacements publics, sans démontrer une correction de navigation.

## 5. Écarts et inconnues

Rage native initiale, génération/décroissance, événements, seuils, ordre du sort déclencheur, formes, statistiques, synchronisation, fatigue et minuterie 15s non qualifiés. Aucun état valide de transformation atteint ne prouve son expiration. Icône présente ne signifie pas montage ou affichage. Les refus hérités ne prouvent pas tout parcours intégré.

## 6. Corrections et reprise

Réutiliser les six contrats existants ; propositions documentaires sans modification de registre :

- COR-GNAR-NATIVE-RAGE-POLICY-01 → SOURCE : qualifier source serveur/mapping natif des gains, décroissance, état initial et fatigue ; conserver les paramètres inconnus autrement.
- COR-GNAR-RAGE-STATE-01 → SIMULATION-CONTRAT : définir événements, bornes, ordre, ownership et cas de refus à partir de cette politique ; séparer contrôles saturés et zéro.
- COR-GNAR-FORM-TRANSITIONS-01 → SIMULATION : produire transitions autoritaires, stats, sorts, collision et retour ; vérifier seuils et début/expiration des 15s, sans soustraire les deux définitions.
- COR-GNAR-LIFECYCLE-01 → SIMULATION-CONTRAT : qualifier mort/réapparition, persistance, fatigue et entrées invalides ; réutiliser les trois cas publics existants et leurs échecs conservés.
- COR-GNAR-ICON-PROVIDER-PATH-01 → PRESENTATION-HUD : prouver montage, chemin, identité et sélection effective de la DDS en Mini/Mega, puis rendu ; vérifier resource_provenance sans déduire une corruption du pin embarqué.
- COR-GNAR-HUD-BINDINGS-01 → PRESENTATION-HUD : après état réseau qualifié, afficher Gnarfury, états, temporisations et paramètres résolus ; vérifier seuil, transformation, retour, refus et absence de données. NETWORK et ACCEPTANCE restent des dépendances distinctes.

Reprendre seulement après nouvelle source, modification pertinente, anomalie ou binding précis manquant. Réutiliser V571/V572, DDS et 16 communs après identité ; ne pas répéter les probes inchangées.

## 7. Livraison et cohérence

Preuves E:/mapslol3v3/audit_sys01202_gnar_passive_hud_20261105. Premier contrôle 72/73/code1 conservé : attente de zéro occurrence Gnar trop stricte ; une occurrence est un test d'animation. Qualification d'un prédicat sur capture E, 72 autres contrôles et autres champs identiques, aucun code produit modifié. evidence_review_corrected.json fait foi avec evidence_qualification.json ; original et journaux restent conservés.

Sept rubriques à relire ; publication limitée au présent rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes. Les sept registres protégés doivent rester identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2297 entrées sales groupées conservées ; dernier resume recontrôlé. Goal, Plan, UI, bases, produit et assets inchangés. V1308 demeure historique ; après ce lien restent Kalista et TwistedFate dans cette liste ciblée, sans pourcentage global. Prochain lot unique : CH-Kalista-PASSIF-PRESENTATION-HUD, V663 à réutiliser.
