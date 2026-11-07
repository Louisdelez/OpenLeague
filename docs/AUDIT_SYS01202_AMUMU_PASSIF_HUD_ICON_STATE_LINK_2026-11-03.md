# SYS-01.2-02 — Amumu, passif : liaison de l’icône et des états au HUD, V1197

3 novembre 2026. Unité `AUD-SYS-01.2-02-AMUMU-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture puis décision racine ; HUD complet, mécanique, rendu et acceptation ouverts.

## 1. Exigence et frontière

`CH-Amumu-PASSIF-PRESENTATION-HUD`, `OLF-349981d6-c25b-5b96-a4f3-d490ba879751`, exige icône, texte, rang et états. Le lot examine les déclarations natives, le HUD propriétaire et l’éventuel indicateur de debuff de cible. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Amumu-PASSIF-NETWORK`. L’inconnue `OLU-8bf80e7e-a210-5377-b7f8-1f55f494fbeb` reste ouverte.

V550 et son supplément clôturaient seulement la fraîcheur source/frontières MR, sans SOURCE ou HUD terminé. Le présent lien de présentation est distinct. Les périmètres communs et le diagnostic ancien sont réutilisés, jamais recomptés en nouveaux audits.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. La trace HUD ne lie directement qu’Amumu.inibin ; huit identités/memberships V550 sont réutilisés, sans redécodage natif.

`Passive1LuaName=CursedTouchMarker` et `Passive1Icon=SadMummy_CorpseExplosion.dds`. CursedTouch et CursedTouchMarker déclarent cette texture ; le CharScript référence séparément AuraofDespair. Trois chunks Lua sans prototype de callback ne fournissent pas un serveur. Les noms et flags client ne déterminent pas le porteur du buff ni les audiences.

Deux fichiers documentaires, sans nouveaux OLS, ont le même contenu :

| Chemin sous DATA | Octets | Release membre |
|---|---:|---|
| `Characters/Amumu/Info/SadMummy_CorpseExplosion.dds` | 4224 | 0.0.0.40 |
| `Spells/Icons2D/SadMummy_CorpseExplosion.dds` | 4224 | 0.0.0.25 |

SHA-256 commun `d1b85ca033180ad6048fb20baec839be16201022929f20c7e897f99a9b5c6a90`, en-têtes 64×64 DXT5. Chemins/tailles/MD5 correspondent au manifeste sélectionné lol_game_client 0.0.1.7. Deux fichiers, un contenu unique ; aucune priorité, sélection runtime ou image rendue qualifiée.

Quatre textes en_GB sélectionnés : CursedTouch1809, Marker1810, description4154, nom4330. Les candidats underscore1808/Self1811 restent non sélectionnés par les bindings inspectés. Texte d’unité affectée et description des attaques d’Amumu sont distingués, sans attribution d’audience. `@f1@` et `@SourceName@` ne sont pas résolus. Valeurs anciennes20/30/40/50, niveaux1/9/17 et régénération de mana40/60/80% ne fixent ni montant actif ni rang. Le miroir F correspond à l’identité native héritée ; texte D non rouvert.

## 3. Consommateurs courants

Le CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` reste `champion_catalog`, appelé par `Simulation::new` : identité/statistiques, sans état passif. Amumu a287.2mana et le type Mana dans les données locales ; leur empreinte dérivée n’est pas celle de l’INIBIN.

Provider/StartupHud et plugins normaux existent. Les sélecteurs standards chargent cadres/textes/QWER-D/F ; le seul Buff0/BuffStack0 identifié dans ces branches est fixé au passif propriétaire d’Ezreal. Les structures Champion/Effects/Snapshot et projections viewer/atomic sont examinées ; aucun champ ou binding CursedTouch/Marker n’y est identifié. Les barres monde utilisent position/PV, sans debuff de cible. Ces constats restent bornés aux corps/configurations inspectés ; ils n’excluent pas tout alias/runtime.

Le manifeste adopte trois icônes Amumu Q/E/R. W1 reste dans `unresolved` car deux candidats diffèrent et la priorité originale est inconnue : ressource native non déclarée absente. Le chargeur itère les entrées indépendamment ; l’update omet l’icône/overlay W manquant sans refus global du HUD. Aucun rendu exécuté ; cet écart adjacent ne crée aucune clôture de passif supplémentaire.

Mana ordinaire, F3, Pyromanie d’Annie, modèle/animation et effets monde restent distincts du passif et de l’éventuel indicateur de cible.

## 4. Attendu, observé et contrôles exécutés

Attendu : ressource déclarée reliée à des états propriétaire/cible qualifiés et aux seules audiences autorisées. Observé : ressources et routes ordinaires établies, aucun binding passif identifié dans ces branches. Sources30/30, consommateurs20/20 contrôles documentaires ; deux DDS lus,8448octets, zéro lecture native exploratoire.

Seize pins et29fenêtres partagés concordent ;1219chemins restent hérités sans recensement. Neuf fichiers/16ancres V550 concordent aujourd’hui, sans requalifier l’ancien binaire. Les neuf attaques sans réduction MR et91ticks suivants restent historiques ; les100dégâts magiques étaient explicitement fournis au diagnostic. Quinze refus de commandes et12d’événements serveur restent séparés. Aucun runtime/build/GPU/audio/réseau/REA exécuté. Gardes et omissions sont lues statiquement, aucun refus HUD Amumu testé.

## 5. Écarts et inconnues

Résolveur, sélection des variantes, substitutions/rang, producteur autoritaire, porteurs et audiences des états, durée/refresh/cumul/expiration/mort/reconnexion et rendu restent ouverts. La mécanique moderne n’est pas substituée à la réduction de MR décrite en4.20. Collision, MR générique, attente post-attaque et anciens tooltips ne démontrent pas ces règles.

## 6. Correction et reprise

Réutiliser `CH-Amumu-PASSIF-PRESENTATION-HUD`, NETWORK→SIMULATION/SOURCE ; aucune nouvelle tâche. Critères : qualifier ressources/textes/paramètres/rang ; définir séparément états propriétaire/cible et audiences ; intégrer de vrais widgets avec refus des entrées ambiguës/manquantes ; vérifier nominal/transitions/confidentialité/fraîcheur/reconnexion/rendu ; conserver les distinctions F3/monde/mana/MR/V550 ; obtenir l’acceptation humaine séparée. Reprise sur source primaire ou modification précise du producteur/consommateur, sans rejeu identique.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_amumu_passive_hud_20261103` : source_worker/sourceproof.json, reçu consommateur, producteurs/journaux et archives exactes, result.json et relecture indépendante. Vérification statique partielle ; fonctionnelle non exécutée ; acceptation À VALIDER. Publication racine limitée à ce rapport et aux ajouts CURRENT/HANDOFF, sauvegardes exactes et sept entrées protégées vérifiées. Une seule clôture bornée ; zéro tâche HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Goal, Plan, application, bases, registres, code et assets inchangés ; SYS-01.2-02 actif/partiel.
