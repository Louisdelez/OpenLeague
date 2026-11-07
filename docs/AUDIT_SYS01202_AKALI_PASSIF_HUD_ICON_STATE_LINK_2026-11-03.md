# SYS-01.2-02 — Akali, passif : liaison des icônes et états au HUD, V1195

3 novembre 2026. Unité `AUD-SYS-01.2-02-AKALI-PASSIF-HUD-ICON-STATE-LINK-01`. Un audit statique borné soumis à relecture puis décision racine. La tâche HUD complète, la mécanique, le rendu et l’acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Akali-PASSIF-PRESENTATION-HUD`, `OLF-42bd30d3-7083-51a7-ab91-5d988031f30e`, exige icône, texte, rang et états. Le lot établit les ressources déclarées et leur liaison éventuelle au HUD courant. Le contrat reste requis, `a_faire`, implémentation/acceptation `false`, dépendant de `CH-Akali-PASSIF-NETWORK`. L’inconnue `OLU-0a2755ab-a964-5df7-a493-73c993c21d99` reste ouverte.

L’ancien audit ACCEPTANCE et V557 concernent la liaison générale, les métadonnées et les frontières d’attaques/soins ; leurs clôtures ou exécutions ne sont pas transférées au HUD. V78 et les préflights HUD sont réutilisés. Seule la liaison statique propre à Akali est nouvelle.

## 2. Sources, identité et provenance

Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. La trace HUD ne déclare directement qu’Akali.inibin. Treize identités natives de V557 correspondent aux descripteurs sélectionnés ; elles restent héritées, sans redécodage INIBIN/Lua.

`Passive1LuaName=AkaliTwinDisciplines` et `Passive1Icon=AkaliTwinDisciplines.dds`. Le buff TwinDisciplines déclare pourtant `33.dds`, tandis que TwinAP/TwinDmg déclarent l’icône principale. Les littéraux d’effets L_hand/R_hand et les graphies distinctes `NonDispellable`/`Nondispellable` sont conservés. Quatre chunks Lua sans prototype de callback ne fournissent pas un corps serveur. Les champs passifs/niveaux absents ne deviennent pas des valeurs par défaut.

Deux ressources documentaires, sans nouveaux OLS, sont identifiées :

| Chemin sous DATA | Octets | SHA-256 |
|---|---:|---|
| `Characters/Akali/Info/AkaliTwinDisciplines.dds` | 2872 | `3664dcefd028ccb3993d4d257337d1bb8feb49cfdeb338e95906e7a1a9bdd300` |
| `Spells/Icons2D/33.dds` | 2176 | `9060ac6537e90d8ba811c04fbb1c3fe752e201af36e4513898d42883ea5ef270` |

En-têtes 64×64 DXT1, sept mipmaps déclarés pour la première ; chemin/taille/MD5 concordent avec lol_game_client 0.0.1.7, membre 0.0.0.25. Le manifeste déclare aussi la même taille/MD5 de l’icône principale sous Spells/Icons2D et ZedShadow/HUD/Icons2D ; ces copies ne sont pas relues et ne prouvent aucun fallback. Résolveur, priorité et sélection des variantes restent inconnus.

Cinq textes en_GB : lignes 1672–1674,4151,4327. L’identité du miroir F correspond au reçu D/F hérité ; texte D non rouvert. Les tooltips distinguent dégâts magiques et SpellVamp, mais `@f1@`, `@f2@`, `@SourceName@`, unités et producteurs restent non résolus. Le modulo communautaire et le vol de vie d’objet ne deviennent pas des règles natives.

## 3. Consommateurs courants

Le CID enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` demeure `champion_catalog`, appelé par `Simulation::new` : identité et statistiques de base. La ligne Akali indique 200 de ressource ; le catalogue de ressources distinct indique Energy. Une empreinte d’export ne désigne pas les octets de l’INIBIN.

Le HUD normal est réellement enregistré. Les sélecteurs partagés chargent QWER/D/F et cadres ; les quatre lignes Akali du manifeste concernent Q/W/E/R. Le module passif fixe l’icône et l’état d’Ezreal ; aucun binding de Twin Disciplines n’est identifié dans ces branches. Le renderer existe ; catalogue seul, recherche lexicale et exemples d’autres champions ne prouvent pas une absence globale.

Bars/widgets ne dessinent MP/MPStat que pour Mana ; Energy ne sélectionne pas non plus EmptyPARBar réservé à None. Cette règle V78 est réutilisée, sans nouvel audit de ressource. Modèle monde, billboard HP, effets référencés et label debug F3 restent distincts d’un HUD passif Akali.

## 4. Attendu, observé et contrôles exécutés

Attendu : icône native reliée à un état propriétaire Akali qualifié. Observé : ressources et backend identifiés, mais aucun binding de passif établi dans les sélecteurs examinés. Les contrôles sources, consommateurs, intégration et relecture sont dénombrés séparément dans les reçus. Le producteur source réussit 28/28 contrôles et lit exactement deux DDS, 5048 octets ; aucune lecture native exploratoire.

L’inspection consommateur réussit 20/20 contrôles documentaires : 16 empreintes code/config et 29 fenêtres partagées sont inchangées ; l’inventaire de 1219 chemins Rust est conservé sans nouveau recensement de contenu. Entrées Akali, configurations et appels réels sont examinés. Les occurrences d’identité, énergie, boutique et tests ne sont pas des consommateurs passifs. Les gardes et refus sont lus statiquement ; aucune scène de refus Akali exécutée. Les anciens essais V557 restent datés/non rejoués. Aucun build, runtime, GPU, audio, réseau ou REA exécuté ; aucun binaire requalifié.

## 5. Écarts et inconnues

Chemin résolu et sélection entre les icônes, état combiné ou séparé des disciplines, paramètres, rang éventuel, producteur serveur, audiences, fraîcheur, mort/reconnexion et rendu restent ouverts. Les métadonnées client ou douze attaques historiques ne suffisent pas. La conclusion négative est bornée aux corps/configurations inspectés, sans exclure tout autre alias/runtime.

## 6. Correction et reprise

Réutiliser `CH-Akali-PASSIF-PRESENTATION-HUD`, NETWORK→SIMULATION/SOURCE ; aucune nouvelle tâche. Critères : établir sélection historique des ressources ; résoudre localisation/substitutions ; qualifier l’applicabilité du rang ; identifier état autoritaire/audiences ; brancher un vrai consommateur sans substitution fictive ; vérifier transitions/refus/confidentialité/fraîcheur/rendu et acceptation séparée. Reprendre sur preuve primaire ou changement précis du producteur/consommateur ; ne pas rejouer V557 ou les mêmes décodages inchangés.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_akali_passive_hud_20261103` : source_worker/sourceproof.json, reçu consommateur, producteurs/journaux, result.json et relecture indépendante. Vérification statique partielle ; fonctionnelle non exécutée ; acceptation À VALIDER. Publication racine limitée à ce rapport et aux ajouts CURRENT/HANDOFF, sauvegardes exactes et sept entrées protégées vérifiées. Une clôture bornée seulement ; zéro tâche HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Goal, Plan, application, bases, registres, code et assets inchangés ; SYS-01.2-02 actif/partiel.
