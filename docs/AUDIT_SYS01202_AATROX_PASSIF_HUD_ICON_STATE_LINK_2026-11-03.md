# SYS-01.2-02 — Aatrox, passif : liaison des icônes et états au HUD, V1194

3 novembre 2026. Unité `AUD-SYS-01.2-02-AATROX-PASSIF-HUD-ICON-STATE-LINK-01`. Un audit statique borné soumis à relecture puis clôture racine. La tâche HUD complète, la mécanique, le rendu et l’acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Aatrox-PASSIF-PRESENTATION-HUD`, `OLF-59a1edd8-e924-5651-892c-cf3f2f77b957`, exige icône, texte, rang et états. Question du lot : quelles ressources du passif sont déclarées, et quelle liaison vers le HUD courant est établie pour Aatrox ? Le contrat demeure `a_faire`, requis, implémentation/acceptation `false`, dépendant de `CH-Aatrox-PASSIF-NETWORK`. L’inconnue `OLU-8e0eb136-26d1-56e4-82ad-dc2b2b854d2c` reste ouverte.

L’ancien audit ACCEPTANCE identifiait les sources et le catalogue ; V456 liait les métadonnées aux dégâts et au retour normal ; V664 bornait le réseau ; V78 décrivait les ressources. Aucun n’est recompté. Le présent lot examine spécifiquement les sélecteurs HUD, leurs appels et la liaison icône/état.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. V456 conserve dix identités natives, sans nouveau décodage INIBIN/Lua : `Passive1LuaName=AatroxPassive`, `Passive1Icon=Aatrox_Passive.dds`, `PARType=BloodWell`. Les assignations client déclarent l’icône normale pour Base/Ready et l’icône Cooldown pour Activate ; elles ne prouvent aucun callback serveur. Death/Ready ont le même chunk et le nom Ready ; les libellés Disintegrate du Death INIBIN restent non attribués, sans verdict de corruption.

Deux ressources documentaires nouvelles, sans création d’OLS, sont identifiées sous `DATA/Characters/Aatrox/HUD/Icons2D/` :

| DDS | Octets | SHA-256 |
|---|---:|---|
| `Aatrox_Passive.dds` | 2176 | `23105fdba188ec7b59dfc8851df4e20b7b6bf6f6e5c37e80bbedcdfb0a95d416` |
| `Aatrox_Passive_Cooldown.dds` | 2176 | `8d1087d72b8c7f72fde363e459dbfc357749544f21a5610b2516d4f9ad0377bc` |

En-têtes 64×64 DXT1 ; chemin, taille et MD5 correspondent au manifeste sélectionné lol_game_client 0.0.1.7, membre 0.0.0.166. Le dossier deploy 0.0.1.68 et la release du membre restent distincts. Ni priorité runtime ni pixels rendus qualifiés.

Cinq chaînes en_GB sont relevées dans la copie F : tooltips Base/Activate/Ready, description et nom Blood Well, lignes 1644–1646/4149/4325. L’identité D/F réutilise le reçu Ahri, sans rouvrir le texte D. `@f2@` et `@SourceName@` restent non résolus ; le texte ne remplace pas un contrat serveur.

## 3. Consommateurs courants

`Simulation::new` appelle `champion_catalog` ; la définition Aatrox contient identité et statistiques, pas un passif. Le seul CID enregistré, `OLC-93924678-ea15-5516-8f55-08616c5450cc`, conserve sa portée de chargeur. Son ancien chemin E est une référence historique ; les octets courants sont contrôlés sur F.

`main.rs` enregistre réellement Provider/StartupHud et les plugins. Les corps `native_hud_spells` sélectionnent QWER/D/F ; `native_hud_panels` charge des cadres statiques ; `native_ezreal_passive_hud` fixe l’icône et lie les compteurs d’Ezreal. Aucun binding Aatrox du passif n’est identifié dans ces branches. L’existence du renderer partagé est conservée ; une inscription au catalogue seule ne prouve pas une absence globale.

La ressource primaire BloodWell est effectivement lue : bars/widgets dessinent MP/MPStat pour Mana seulement. La règle générique V78 est réutilisée, sans nouvelle clôture de ressource. Une jauge primaire demeure distincte d’un indicateur de passif. Modèle monde, billboard HP, clip `Aatrox_Passive_Death` non sélectionné comme résurrection et label debug F3 ne remplacent pas ce HUD.

## 4. Attendu, observé et contrôles exécutés

Attendu : ressource déclarée, provenance et véritable liaison à un état propriétaire Aatrox. Observé : ressources identifiées, backend normal présent, liaison passive Aatrox non établie dans les sélecteurs examinés. 25/25 contrôles sources et 22/22 contrôles documentaires consommateurs réussissent ; les 71/49 contrôles du préflight partagé restent hérités.

Le collecteur inspecte 1219 fichiers Rust : les trois occurrences Aatrox/BloodWell nommées sont des tests. La conclusion repose également sur les corps, appels et cinq configurations sélectionnés, pas sur ce seul résultat lexical. Les gardes d’identité/état et masquages sont lus statiquement, sans scénario de refus exécuté. Deux DDS, 4352 octets, ont été lus en exploration puis par le producteur source final ; aucune autre ressource native ouverte par ce producteur. Aucun build, jeu, GPU, réseau, écoute ou REA lancé ; aucun binaire qualifié.

## 5. Écarts et inconnues

Sélection historique effective Base/Cooldown/Ready, paramètres, applicabilité du rang, producteur autoritaire BloodWell, audiences, réserve, activation, recharge, mort/résurrection et reconnexion restent non qualifiés. Mana générique, retour normal et clip nommé ne les démontrent pas. L’absence constatée reste bornée au code/configurations inspectés ; aucun autre runtime ou alias n’est exclu globalement.

## 6. Correction et reprise

Réutiliser `CH-Aatrox-PASSIF-PRESENTATION-HUD` et ses prérequis NETWORK→SIMULATION/SOURCE ; aucun doublon de tâche. Critères : établir la sélection historique des variantes ; résoudre les textes/substitutions ; qualifier l’applicabilité du rang ; identifier producteur et audiences ; brancher un consommateur HUD réel ; vérifier transitions/refus/confidentialité/fraîcheur/rendu avec binaires et ressources identifiés. L’acceptation humaine reste séparée. Reprendre sur preuve primaire précise ou changement du producteur/consommateur, sans répéter les mêmes lectures INIBIN/Lua ou analyses natives.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_aatrox_passive_hud_20261103/source_worker/sourceproof.json`, reçu consommateur, producteurs/journaux, correction archivée, `result.json` et relecture indépendante. Vérification statique partielle, fonctionnelle non exécutée ; acceptation humaine À VALIDER. Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF, avec sauvegardes exactes et sept entrées protégées vérifiées. Une seule clôture bornée après décision racine ; zéro tâche HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Goal, Plan, application, bases, registres, code et assets inchangés. SYS-01.2-02 reste actif et partiel.
