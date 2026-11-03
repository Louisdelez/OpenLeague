# SYS-01.2-02 — Nasus : sources du passif et vol de vie, V540

25 octobre2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45. Fuseau et date de déploiement inconnus ; catalogue4.20.1 distinct. **Traçabilité partielle : le passif et le jeu ne sont pas déclarés terminés.**

## Résultat intégré au plan

Les trois fiches CH-Nasus-PASSIF-SOURCE, CH-Nasus-PASSIF-SIMULATION-CONTRAT et CH-Nasus-PASSIF-SIMULATION reçoivent18 arêtes vers six sources natives. Les deux fiches de simulation reçoivent18 liens vers neuf frontières du code, qualifiées `provides_feature_consumer=false`. Les lecteurs d’audit de SOURCE restent conservés sans promotion en gameplay. SYS-01.2-02 référence la livraison.

Les trois questions propres déjà ouvertes, les questions des dépendances et les quatre dépendances sont conservées. Aucun inconnu ajouté ou fermé. Les phases D01/D06 et lots réels ont été consultés : leurs critères de sortie ne sont pas déclarés atteints par ce lot. Tous statuts, critères, acceptations, cases, notes et historiques restent exacts. Les résultats et limites figurent dans les consignes copiables des tâches.

## Sources natives et textes divergents

| Fichier | Source enregistrée |
|---|---|
| Nasus.inibin | OLS-cce8ca14-9c27-5840-ab21-ff57c6b85f46 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptNasus.luaobj | OLS-86bebe63-f1b3-508e-996a-3a4c500873d8 |
| CharScriptNasus.preload | OLS-526521c3-f102-5657-9379-f8da62ff2641 |
| NasusPassive.luaobj | OLS-645e84b5-8b61-563c-b5ba-41baa34edbce |
| NasusPassive.inibin | OLS-8c90bb98-70c4-5c98-a78b-d4b8153e6c22 |

Six payloads vérifiés en taille/SHA et contre le manifeste RADS sélectionné. Leur présence ne détermine pas à elle seule une priorité d’alias ou une règle serveur. La recherche a couvert les noms pertinents dans le deploy, puis les dossiers Nasus/Spells, Nasus/Scripts et la racine du champion. La seule recherche DATA/Spells aurait omis les scripts propres au champion ; aucune absence n’est déduite de ce résultat lexical borné.

Nasus.inibin déclare `Passive1LuaName=NasusPassive`, `Passive1Name=game_character_passiveName_Nasus` et `PassLev1Desc1=game_character_passiveDescription_Nasus`. Le nom anglais ligne4414 est Soul Eater ; la description ligne4238 annonce du vol de vie. Le champ brut Passive1Desc parle pourtant de la santé de **Singed** liée au mana. Ce champ est conservé comme divergence historique, sans remplacement des octets ni utilisation comme règle Nasus.

NasusPassive.inibin lie directement `game_buff_tooltip_SoulEater`, ligne2691 : `@f1@%` de vol de vie. **Le fournisseur de f1 et sa loi par niveau restent inconnus.** Les lignes voisines SoulNexus/SoulNexusCounters décrivent un autre mécanisme à âmes et régénération ; elles ne sont pas adoptées comme règle active.

CharScriptNasus.luaobj contient seulement un retour ; NasusPassive.luaobj contient des déclarations BuffTextureName, BuffName, PersistsThroughDeath et NonDispellable. Les deux chunks sont parsés intégralement, sans prototype de callback enfant. Aucun callback ou moteur Lua du serveur original n’est exécuté. Les métadonnées ne prouvent pas les règles de mort, dissipation ou calcul.

Le preload CharScript mentionne nasuspassive, nasus_base_p_lifesteal.troy et d’autres ressources de déplacement, skin et forme ultime. Leur référencement n’est pas une preuve d’exécution du soin ou du rendu. Aucun fichier de bot n’est utilisé comme source de passif.

Deux miroirs communautaires (Stats/Nasus et Spells/NasusPassive) et CharScriptNasus.cs sont conservés avec leurs identités et provenances enregistrées. La classe C# de cette copie est vide. Ces constats ne donnent pas une autorité native à la copie ni une preuve d’absence mondiale de sources.

## Attaques et soin réellement observés

Le driver séparé utilise le vrai core non-test, Map10 et sa navigation. Dans deux parties distinctes, il déplace Nasus et Garen adversaires par commandes publiques, fait subir trois frappes de Garen à Nasus, arrête Garen, puis fait attaquer Nasus six fois. Un cas n’a aucun objet ; l’autre achète publiquement le Sceptre vampirique1053. Aucun champ de joueur, dégât ou soin n’est injecté ; aucun appel direct à heal pour imiter Soul Eater.

Nasus reste vivant, niveau1, sous sa vie maximale et sans critique. Garen est arrêté sans cible ni windup lors des frappes. La régénération vaut1.80239999294281 PV/s. Chaque résultat ci-dessous est la différence entre la vie observée après la frappe et la vie calculée en f32 après **la seule régénération**.

| Frappe | Tick, chaque partie | PV supplémentaires sans objet | PV supplémentaires avec Sceptre |
|---|---:|---:|---:|
| 1 | 899 | 0 | 4.3394775390625 |
| 2 | 946 | 0 | 4.3394775390625 |
| 3 | 993 | 0 | 4.3394775390625 |
| 4 | 1040 | 0 | 4.3394775390625 |
| 5 | 1087 | 0 | 4.3394775390625 |
| 6 | 1134 | 0 | 4.3394775390625 |

Les cinq échantillons hors frappe de chaque partie correspondent aussi à la régénération seule. Le taux de vol de vie vaut0 sans objet et0.07999999821186066 avec Sceptre. Le chemin courant progression::stats prend ce taux dans les objets ; basic_attack_hit applique le dégât physique puis soigne le produit du dégât après réduction et du taux. heal applique les contrôles et modificateurs génériques. **Aucun vol de vie propre à Nasus n’est observé dans ce scénario.** Cela ne qualifie pas tous les niveaux, cibles ou interactions de soin en combat.

Refus Attack exécutés dans chaque cas : unknown player, unknown target, invalid enemy target. Les trois refus correspondent au joueur absent, à la cible absente et à l’attaque de son propre champion.

## Statistiques des niveaux1 à18

Deux autres simulations contrôlées utilisent l’API publique serveur `award_experience`, à raison d’un point par appel, et relèvent chaque niveau de1 à18 : 19245 événements d’expérience dans chaque cas. Aucun champ n’est modifié directement. Le taux reste0 à chacun des18 niveaux sans objet et0.07999999821186066 avec Sceptre.

Les refus d’expérience0, négative et NaN donnent invalid experience award ; un joueur absent donne unknown player. Ces huit refus sont réellement exécutés. **Ce contrôle utilise un événement serveur de diagnostic : il ne teste pas la progression par éliminations, ne constitue pas une action réseau et ne mesure pas les soins de combat aux niveaux2 à18.** Il vérifie seulement le producteur statistique courant sous changements de niveau contrôlés.

## Identité et contrôles

Build et exécution terminés avec codes0. Dépendances et checksums alignés sur Cargo.lock racine ; core en cache, src_path F:/OpenLeague/crates/core/src/lib.rs, non-test.1 158 entrées source/ressource et les anciens exécutables/manifests/locks sont identiques avant/après. Le diagnostic Warwick n’est pas relancé.

Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-nasus-passive-healing-probe.exe` — 5963264 octets — SHA256 `7fe349edde04453d0d42ac0b35a9aa6bfefa96c24ed245c6074579ad540c1db3`. Le manifeste privé, le lock, le code du driver, les outils et journaux sont identifiés dans revision540_Nasus_passive_probe/OBSERVATIONS.json. Aucune exécution du client original, serveur original, Lua, GPU ou réseau ; aucun ancien ensemble de tests relancé.

Inspection/prepare/check/publish/audit réussis.57 associations volontairement invalides sont refusées, dont l’assimilation soin générique/passif, l’acceptation de f1, la promotion des lecteurs SOURCE, une fausse progression par éliminations, le texte Singed ou SoulNexus adopté comme règle, les métadonnées prises pour callbacks, la fausse acceptation et les identités/résultats altérés. Quatre refus du lecteur public couvrent source absente, consommateur absent, fausse acceptation et adoption d’une question appartenant au parent.

Les deux bases réelles sont vérifiées via Store.task/copy_text/summary, dépendances, résolution des inconnus, integrity_check et sync_catalog idempotent. Par base :4 destinataires actualisés,42 603 autres lignes de catalogue exactes,42 607 états manuels et23 historiques exacts. Trois fragments de consignes changent,42 212 restent exacts ;42 211 autres objets tâche/trace exacts. Identifiants, hiérarchie et inconnus restent identiques en octets ; anciens descripteurs de source/consommateur conservés.

Réexamen courant :42 215 exigences,98 835 sources,2 805 consommateurs,26 189 questions ouvertes et5 517 résolues. Les2 805 ancres et identités de527 fichiers correspondent, zéro divergence ;17 auxiliaires conservés. Aucun nouveau census physique global des98k sources.8 358 fiches CH au seul chargeur partagé sont une file de recherche, pas un compteur de fonctionnalités absentes.

## Fichiers modifiés et reste à faire

Registres : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Inconnus inchangés. Reçu : docs/reference_requirement_trace_sources/nasus-passive-healing-links-v540.json ; preuve : docs/fidelity_nasus_passive_healing_links_v540.json. Quatre lignes de données/consignes actualisées dans chaque base du plan. Couverture, plan documentaire, reprise, CURRENT et HANDOFF mis à jour avec sauvegardes et conservation des anciens champs. Aucun code produit ou asset changé ; aucun stage/reset/commit.

Scripts préparés dans E:/mapslol3v3 et exécutés avec les entrées de F:/OpenLeague ; copies exactes archivées dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision540_Nasus/scripts. Les chemins réels d’exécution restent dans les reçus ; aucune portabilité de ces outils de diagnostic n’est déduite.

Restent ouverts : valeur native de f1, loi par niveau, producteur du bonus passif, cumul avec objets, réduction de soin, cibles particulières, dégâts absorbés et autres interactions. Le diagnostic établit l’écart local décrit, sans corriger ou accepter Soul Eater. Les112 autres contrats/parents restent à examiner.

Continuer SYS-01.2-02 depuis revision541_trace_review/REVIEW.json. V540 Nasus est publié et audité : trois fiches, six sources natives,18 arêtes et18 liens vers neuf frontières. Sans objet, six frappes ne produisent aucun soin au-delà de la régénération ; Sceptre1053 ajoute4.3394775390625 PV/frappe. Taux0/8% aux niveaux1..18 par API d’expérience, sans preuve de progression par éliminations. NasusPassive.inibin lie SoulEater avec f1 inconnu ; le texte brut Singed et les anciens SoulNexus ne sont pas des règles adoptées. Inconnus/statuts/cases conservés ; aucun passif accepté ou corrigé. Ne pas republier V540 ni relancer ces diagnostics sans cause nouvelle. Examiner ensuite Volibear : sources de régénération déclenchée à faible vie, condition/seuil/recharge et véritable chemin de dégâts/régénération, distinct de la régénération de base. Conserver les inconnues et qualifier les éventuelles sources communautaires.112 autres contrats/parents restent à examiner ;8358CH au seul chargeur partagé restent une file de recherche, pas un taux de complétion ou une preuve d’absence. Goal actif.
