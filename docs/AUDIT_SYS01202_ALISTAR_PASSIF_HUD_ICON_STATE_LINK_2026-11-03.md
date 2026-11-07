# SYS-01.2-02 — Alistar, passif : liaison de l’icône et des états au HUD, V1196

3 novembre 2026. Unité `AUD-SYS-01.2-02-ALISTAR-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture puis décision racine ; tâche HUD complète, mécanique, rendu et acceptation ouverts.

## 1. Exigence et frontière

`CH-Alistar-PASSIF-PRESENTATION-HUD`, `OLF-17c70eff-d8de-5f66-9fa3-f3e04dc65b0f`, exige icône, texte, rang et états. Le lot établit les ressources déclarées et leur liaison au HUD courant. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Alistar-PASSIF-NETWORK`. L’inconnue `OLU-cfb5fee4-852c-5161-9aed-b046580e502b` reste ouverte.

V552 reliait les sources et frontières de cast/Trample ; son supplément du 2 novembre clôt seulement leur fraîcheur. SOURCE et présentation restent ouvertes. Aucun de ces acquis n’est recompté ; la question nouvelle porte sur les sélecteurs HUD et le binding propre à Alistar.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Les huit identités natives de V552 sont réutilisées, sans redécodage INIBIN/Lua. `Passive1LuaName=Colossal Strength` et `Passive1Icon=Minotaur_ColossalStrength.dds`. AlistarTrample déclare séparément `BuffName=Trample Buff` ; les deux scripts référencent la même icône. Leurs flags restent attribués à leurs chunks respectifs, sans alias ni ordre inventés. Deux Lua sans prototype de callback ne fournissent pas de corps serveur.

Deux ressources documentaires de même basename sont distinguées, sans création d’OLS :

| Chemin sous DATA | Octets | Release du membre | MD5 |
|---|---:|---|---|
| `Spells/Icons2D/Minotaur_ColossalStrength.dds` | 4224 | 0.0.0.25 | `7f5a06a4ef16559279814329a41a67a7` |
| `Characters/Alistar/HUD/Icons2D/Minotaur_ColossalStrength.dds` | 4224 | 0.0.1.7 | `38d6c085d2ceb290af468beb6e9c9233` |

Le reçu source conserve SHA-256, en-têtes 64×64 DXT5 et comparaison chemin/taille/MD5 au manifeste sélectionné lol_game_client 0.0.1.7. Le dossier deploy 0.0.1.68 et les versions de membres restent distincts. Les contenus diffèrent ; priorité de résolution, sélection effective et pixels rendus restent inconnus.

Quatre textes client en_GB sont relevés aux lignes 1791/2782/4152/4328 : Colossal Strength, Trample Buff, description et nom. Le miroir F et l’identité native héritée sont vérifiés sans rouvrir le texte D. `@f1@`, `@f2@`, `@f3@`, `@SourceName@` restent sans fournisseurs qualifiés. Les anciens libellés tourelle/HP et niveaux 6/12/18 ne sont pas adoptés comme règles ou rangs de Trample. L’absence de CharScript dans un répertoire historique choisi demeure locale.

## 3. Consommateurs courants

Le seul CID HUD enregistré, `OLC-93924678-ea15-5516-8f55-08616c5450cc`, est le chargeur `champion_catalog`, appelé par `Simulation::new` : identité/statistiques, pas un passif. La ligne Alistar donne 278.84 de mana ; le catalogue de ressources distinct indique Mana. Son `source_sha256` dérivé ne désigne pas l’INIBIN natif.

Le HUD normal est réellement enregistré. Les sélecteurs partagés chargent cadres et QWER/D/F ; quatre InventoryIcon Alistar concernent Q/W/E/R. Le module passif lie une icône et un état propriétaire d’Ezreal à Buff0/BuffStack0. Aucun binding de Trample Alistar n’est identifié dans ces corps. Renderer et helpers génériques restent présents ; catalogue seul ou recherche nominale ne prouvent pas une absence globale.

Le snapshot fournit max_mana, bars/widgets sélectionnent MP et MPStat pour Mana, avec une fraction si l’entrée est valide. Ce parcours ordinaire est distinct du passif ; aucune barre n’est rendue ici. F3, Pyromanie d’Annie, modèle/animation, effets monde et billboard HP ne fournissent pas le HUD Trample.

## 4. Attendu, observé et contrôles exécutés

Attendu : icône déclarée reliée à un état propriétaire Trample qualifié. Observé : ressources et HUD normal identifiés, aucun binding passif établi dans les branches examinées. Le producteur source réussit 28/28 contrôles et lit deux DDS, 8448 octets, sans lecture native exploratoire. Le consommateur réussit 20/20 contrôles documentaires ; 16 empreintes code/config et 29 fenêtres communes concordent. Le résultat V1195 sur 1219 chemins est hérité, sans nouveau recensement de chemins ou de contenu.

Les 18 frontières V552 restent `entry_boundary_only`/`provides_feature_consumer=false`. Ses 17 refus Alistar, 7 refus Annie et 91 ticks après refus sont hérités/non rejoués ; ni déclenchement, ni durée effective, ni phasing de Trample prouvés. Le W positif d’Annie reste distinct. Masquages et gardes sont lus statiquement, sans refus HUD Alistar exécuté. Aucun build, runtime, GPU, audio, réseau ou REA ; aucun binaire requalifié.

## 5. Écarts et inconnues

Résolveur des deux textures, alias Colossal Strength/Trample Buff, sélection des états, paramètres/rang, producteur autoritaire, audiences, fraîcheur, mort/reconnexion et rendu restent ouverts. Métadonnées, mana ordinaire, collision commune et attente post-refus ne les démontrent pas. La conclusion négative reste bornée aux corps/configurations inspectés, sans exclure tout alias/runtime.

## 6. Correction et reprise

Réutiliser `CH-Alistar-PASSIF-PRESENTATION-HUD`, NETWORK→SIMULATION/SOURCE ; aucune nouvelle tâche. Critères : qualifier ressources/sélection/textes/substitutions/rang ; établir producteur et audiences ; intégrer un vrai widget avec refus des entrées ambiguës/manquantes ; vérifier transitions/lifecycle/confidentialité/fraîcheur/reconnexion/rendu ; maintenir la distinction F3/monde/mana/V552 ; obtenir l’acceptation humaine séparément. Reprise sur preuve primaire de sélection ou nouveau producteur/consommateur précis, sans refaire V552 ni les analyses inchangées.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_alistar_passive_hud_20261103` : source_worker/sourceproof.json, reçu consommateur, producteurs/journaux, result.json et relecture indépendante. Vérification statique partielle, fonctionnelle non exécutée, acceptation À VALIDER. Publication racine limitée à ce rapport et aux ajouts CURRENT/HANDOFF ; sauvegardes exactes et sept entrées protégées vérifiées. Une seule clôture bornée ; zéro tâche HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Goal, Plan, application, bases, registres, code et assets inchangés ; SYS-01.2-02 actif/partiel.
