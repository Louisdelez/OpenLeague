# Twisted Fate — Loaded Dice, icône et compteur vers le HUD

2026-11-05 · V1312 · AUD-SYS-01.2-02-TWISTEDFATE-PASSIF-HUD-ICON-STATE-LINK-01

## 1. Exigence et périmètre

CH-TwistedFate-PASSIF-PRESENTATION-HUD ; OLF-685c888a-ac86-5dd2-af0d-b5682df86ba8 ; inconnue OLU-88a1c2b8-82c0-5eea-97df-75e1628cf67b. Parent SYS-01.2-02 actif. Audit documentaire de liaison de Second Sight/Loaded Dice, son icône, ses textes et son compteur f1 aux consommateurs actuels. Six contrats SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/PRESENTATION-HUD/ACCEPTANCE ouverts. D06, lot D06-CH-TwistedFate ; HUD dépend de NETWORK, sans prérequis déclaré accepté. Voir phase_package_prerequisites.json.

Audit clôturable pour cette liaison après décision et publication vérifiée ; implémentation partielle, vérification statique/historique bornée, acceptation humaine non donnée. Aucun champion, HUD complet ou jeu terminé.

## 2. Sources, provenance et limites

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue4.20.1 distinct. V643 daté 2026-10-26T22:32:26.179491+00:00 :2613515octets, SHA-256 d62e957905bd415875adbeccbefde687cc6a0e84e69d1ac8dc9c8deebabfaee0. Identités et recherches conservées dans initial_scope.json.

Sept ressources sélectionnées :2INIBIN,2Lua,1preload,DDF,font. Alias déclaré «Second Sight», fichier SecondSight.luaobj, texture Cardmaster_SealFate.dds ; pas de réécriture automatique. Passive1 et six Level absents, pas zéro. Passive1Desc conserve «Increases all friendly Champions' critical strike chance», contradictoire avec les textes localisés d'or ; sélection historique effective inconnue.

Miroir font F de l'identité native vérifiée :buff2598,nom4469,description liée4293. Textes :1 à 6 pièces supplémentaires après une unité tuée, total cumulé @f1@. Ni distribution uniforme, ni RNG/seed/pondérations, ni filtre exact des cibles déduits. Douze Lua antérieurement consommés sans enfants, sept limites NEWTABLE voisines ; deux chunks directs qualifiés en littéraux, pas en callbacks. SecondSight donne nom/texture/persistance ; CharScript vide. DDF20lignes, seul PickACard;f1 renseigné @special.twistedfatew/0.65 :W distinct du passif.

Le registre SOURCE conserve huit IDs :sept ressources V643 et le candidat antérieur OLS-aada795c-e1da-5417-81fd-f917699cdd13, S5Test_DragonBuff.luaobj. Son lien est explicitement candidat de métadonnées BuffName, pas corps serveur. Identité/chemin retrouvés par lookup exact du snapshot gelé ; aucun payload Dragon relu ou promu, aucun registre corrigé implicitement.

Deux DDS own Info/shared Icons2D :4224octets chacune,64×64 DXT5,mipmap_count0, même SHA-25689fe52b4066189209d36f33cbc5b6dc3f235994482214827d6e62b2403995ee1 ; membres0.0.0.40/0.0.0.25. Sélection E avant deux stats/lectures natives, taille/MD5 concordantes. Aucun INIBIN/Lua/font natif relu. Égalité ne qualifie ni priorité provider ni affichage.

## 3. Consommateurs réels

SOURCE11relations/8IDs, six sites sur trois fichiers ; V64312frontières sur neuf fichiers. Union18ancres/onze fichiers ;31fichiers code/configuration vérifiés.16communs et19identités V643 concordent. Le chemin serveur inspecté passe par apply_damage/damage_unit/combat_owner :gold+altar_bonus, puis global_gold. Revenu ambiant dans advance_passive_gold distinct. Ces chemins génériques ne sont pas un producteur du tirage ou du compteur.

native_hud_widgets affiche GoldStat=floor(player.gold), donc portefeuille courant, pas total Loaded Dice f1. HP/Mana génériques présents. Le catalogue QWER comporte quatre InventoryIcon, aucune Cardmaster_SealFate. La voie Buff0 d'Ezreal reste spécifique. Aucun binding littéral du passif dans les sept modules HUD inspectés ; recherche nommée bornée sans occurrence Rust, sans conclure à l'absence de tout mécanisme générique.

## 4. Attendu, observé et contrôles

Attendu :sources et consommateurs reliés, contradiction, manques et refus explicites. Observé :68/68 contrôles documentaires,64/64 cohérence séparée du même agent ; identités, ancres, font et DDS vérifiés. Le lookup supplémentaire du snapshot répond précisément aux huit IDs contre sept ressources sélectionnées ; aucun registre global F reparsé.

V643 hérité sans replay/recalcul :deux cas TwistedFate/Garen, six vrais monstres chacun,3000ticks chacun, récompenses33/18/18/48/38/28, supplément zéro dans les douze mises à mort.22refus API avec invariance documentée. Base reward distribuée, bonus absent dans ce diagnostic ; admissibilité native exacte des victimes non établie. API serveur de dégâts explicite, aucune attaque ordinaire, parcours de déplacement ou élimination de champion qualifiée.

Deux archives sélectionnées1134350octets. Ancien probe216886octets/RUN non ouverts. Binaire historique5703168octets, SHA01335653fd65a24669d9748b9cfbfe5304a7ac2d4b024e5c4aecd729f96e8b1b, non relu/rejoué ;1158dépendances non requalifiées. Aucun nouveau build,testRust/Bevy,jeu,REA,VM,réseau ou GPU. L'ancienne livraison de registres/bases V643 n'est pas rejouée.

## 5. Écarts et inconnues

Producteur natif du tirage, distribution/état aléatoire, attribution des kills/familiers/clones, catégories de victimes, simultanéité et interactions de revenus inconnus. Compteur f1, persistance/remise à zéro, réplication et présentation non qualifiés. Le texte brut de critique n'est pas adopté comme règle par défaut ; le candidat Dragon n'est pas un alias runtime prouvé. Deux DDS identiques et GoldStat présent ne prouvent pas le HUD du passif.

## 6. Corrections et reprise

Réutiliser les six contrats existants ; propositions documentaires sans modification de registre :

- COR-TWISTEDFATE-NATIVE-LOADED-DICE-POLICY-01 → SOURCE :qualifier formule/pondérations/RNG/seed et filtre/attribution natifs, sans inventer une loi uniforme.
- COR-TWISTEDFATE-LOADED-DICE-REWARD-STATE-01 → SIMULATION :produire un bonus distinct et le cumul f1 selon contrat qualifié ; comparer récompense normale et supplément, vérifier absence de double attribution.
- COR-TWISTEDFATE-TARGET-CREDIT-LIFECYCLE-01 → SIMULATION-CONTRAT :borner victimes/killcredit, concurrence, mort/réapparition et interactions ; tester attaques/sorts ordinaires séparément de l'API diagnostique.
- COR-TWISTEDFATE-LEGACY-ALIAS-AND-TEXT-SELECTION-01 → SOURCE :résoudre sélection critique/or et association candidate S5Test_DragonBuff par callsite/provider précis ; conserver les sources si indéterminé.
- COR-TWISTEDFATE-ICON-PROVIDER-PATH-01 → PRESENTATION-HUD :qualifier resource_provenance,montage et priorité own/shared ; vérifier identité puis rendu, sans arbitrage automatique par basename.
- COR-TWISTEDFATE-HUD-BINDINGS-01 → PRESENTATION-HUD :après état NETWORK qualifié, afficher icône,nom/texte et f1 autoritaire, distinct du portefeuille ; vérifier gains,refus,absence de données et lifecycle. ACCEPTANCE demeure distincte.

Reprendre sur source nouvelle, changement pertinent, anomalie ou binding précis manquant ; réutiliser V643 et16communs après identité. Aucun nouveau probe inchangé requis.

## 7. Livraison et cohérence

Preuves E:/mapslol3v3/audit_sys01202_twistedfate_passive_hud_20261105 :evidence_review.json,coherence_review.json,journaux/captures. Sept rubriques relues avant décision. Publication limitée au rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes ; sept registres protégés à maintenir identiques. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2299entrées sales groupées conservées. Goal/Plan/UI/bases/produit/assets inchangés.

V1308 demeure historique. Après cette seule liaison, consolider ses122IDs HUD avec les quatre reçus Fiora/Gnar/Kalista/TwistedFate, sans refaire les audits ;1098autres rôles et reste du goal exclus de ce dénominateur. Aucun pourcentage de jeu terminé. Prochain lot :AUD-SYS-01.2-02-PASSIF-HUD-COVERAGE-DELTA-01.
