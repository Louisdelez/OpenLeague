# SYS-01.2-02 — Warwick : sources du passif et soin sur attaque, V539

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45. Fuseau et déploiement inconnus ; catalogue4.20.1 distinct. **Livraison de traçabilité partielle, aucune acceptation du passif ou du jeu.**

## Résultat intégré

Les fiches CH-Warwick-PASSIF-SOURCE, CH-Warwick-PASSIF-SIMULATION-CONTRAT et CH-Warwick-PASSIF-SIMULATION reçoivent27 arêtes vers neuf sources natives. Les deux fiches simulation reçoivent16 liens vers huit frontières du code courant, toutes `provides_feature_consumer=false`. Les lecteurs d’audit existants de SOURCE sont conservés, sans être promus en gameplay. SYS-01.2-02 référence le reçu complet.

Les trois questions propres déjà ouvertes et leurs références de dépendances sont conservées : aucune question fermée ou ajoutée artificiellement. Les quatre dépendances, les statuts, critères, acceptations, cases et historiques sont exacts. Le résultat runtime précise l’écart dans le contexte copiable de chaque fiche. Les113 autres contrats/parents ne sont pas changés.

## Sources exactes

| Fichier | Source enregistrée |
|---|---|
| Warwick.inibin | OLS-2828ef9d-a070-5db6-a373-aa723ef487ba |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Eternal Thirst.inibin | OLS-c052162b-6686-5c1b-9a5b-51fc21030a92 |
| EternalThirstBuff.inibin | OLS-3924d1b7-03b5-51c8-8383-d50285a99cb5 |
| EternalThirstBuff.luaobj | OLS-169903fe-9624-5183-8792-48915ee9c977 |
| EternalThirstIcon.luaobj | OLS-4cbc9a62-220c-545d-a8e1-9e83dd22ccbd |
| EternalThirstIcon.preload | OLS-bd8297b2-68e6-5468-a7cb-ff8ea65c76c5 |
| CharScriptWarwick.luaobj | OLS-85895e34-2c44-5eb1-b420-e641990686e3 |
| CharScriptWarwick.preload | OLS-ec2c63f1-f9e0-5dcd-8b63-b3cbc7a4f313 |

Quinze fichiers natifs découverts ont été relus et comparés en taille/SHA et au manifeste RADS sélectionné. Neuf sont pertinents pour le passif ; six fichiers WarwickBot restent dans la preuve de recherche et ne sont pas reliés comme règles du passif. La sélection de manifeste ne prouve pas la priorité historique effective des alias.

Warwick.inibin déclare `Passive1LuaName=Eternal Thirst` et décrit un soin croissant sur les attaques successives contre la même cible. `Eternal Thirst.inibin` lie exactement `game_buff_tooltip_Eternal_Thirst`, ligne1874 du fichier anglais : bonus magique et soin de même montant, valeur `@f1@`, cumul jusqu’à trois frappes. `EternalThirstBuff.inibin` lie `game_buff_tooltip_EternalThirstBuff`, ligne1876, qui décrit le bonus croissant sur la même cible. La clé voisine EternalThirsted est conservée comme texte voisin, sans substitution silencieuse.

Les trois Lua présents sont parsés jusqu’au dernier octet, sans prototype de callback enfant. Les déclarations BuffName, icône, PersistsThroughDeath et NonDispellable sont des métadonnées ; elles ne qualifient pas les règles d’expiration ou de mort du serveur original. Le preload CharScript cite eternalthirsticon, apbonusdamagetotowers et bloodscent_internal ; le preload d’icône cite globallifesteal_buf.troy. Ces références ne prouvent ni rendu ni soin fonctionnel.

Deux miroirs JSON communautaires et CharScriptWarwick.cs sont identifiés avec leurs SHA et leur provenance enregistrée. La classe C# de cette copie est vide. Ce constat borné ne prouve pas une absence globale de sources communautaires et ne transforme pas cette copie en serveur original.

## Diagnostic effectivement exécuté

Le driver séparé utilise le vrai `openleague-core`, Map10 et sa navigation. Il crée Warwick et Garen adversaires, les déplace par commandes publiques vers des cellules praticables et fait blesser Warwick par trois attaques de Garen. Il arrête ensuite Garen, puis exécute six attaques normales de Warwick. Deux parties distinctes sont observées : sans objet et avec achat public du Sceptre vampirique1053. Aucun champ de joueur, dégât ou soin n’est injecté ; pas d’appel direct à `heal` pour simuler un passif.

Warwick reste vivant, niveau1 et en dessous de sa vie maximale lors des six frappes de chaque cas. Il ne critique pas. La cible arrêtée ne possède ni cible d’attaque ni windup. La régénération vaut1.6787999868392944 PV/s. À chaque frappe, le diagnostic calcule en f32 la vie après régénération seule, puis soustrait cette attente de la vie observée.

| Frappe | Tick, chaque partie | PV supplémentaires sans objet | PV supplémentaires avec Sceptre |
|---|---:|---:|---:|
| 1 | 899 | 0 | 4.5433349609375 |
| 2 | 943 | 0 | 4.5433349609375 |
| 3 | 987 | 0 | 4.5433349609375 |
| 4 | 1031 | 0 | 4.5433349609375 |
| 5 | 1075 | 0 | 4.5433349609375 |
| 6 | 1119 | 0 | 4.5433349609375 |

Les cinq échantillons hors frappe de chaque partie correspondent également à la régénération seule. Le taux de vol de vie est0 sans objet et0.07999999821186066 avec le Sceptre. Le code `progression::stats` tire ce taux des objets ; `basic_attack_hit` applique le dégât physique puis soigne selon le dégât après réduction multiplié par ce taux. Le soin générique applique ses gardes et modificateurs. **Aucun soin supplémentaire du passif n’est observé dans ce scénario précis.** La valeur native f1, le bonus magique, le cumul et leur producteur restent à qualifier ; ce diagnostic ne prouve pas une absence globale dans tous les scénarios.

Refus publics exécutés dans les deux cas : joueur inconnu → `unknown player`, cible inconnue → `unknown target`, propre champion → `invalid enemy target`.

Compilation et exécution : codes0. Dépendances identiques au Cargo.lock racine en identité/version/checksum ; core non-test en cache, source F:/OpenLeague/crates/core/src/lib.rs.1 158 entrées source/ressource, anciens exécutables et verrous conservés. Le driver seul est nouveau.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-warwick-passive-healing-probe.exe` — 5943808 octets — SHA256 `7a117a4f96b37574cde33efb760f431f1177b2380d5bc958293e32fd563719b0`. Manifestes, lock privé, code du driver, compilateur, Python et journaux sont identifiés dans revision539_Warwick_passive_probe/OBSERVATIONS.json. Aucun client original, serveur original, moteur Lua, GPU, réseau ou ancien ensemble de tests n’est exécuté par cette livraison.

## Contrôles de publication

Prepare/check/publish/audit : codes0.45 associations volontairement fausses refusées (soin générique appelé passif, vol de vie d’objet assimilé au passif, f1 inventé, bots promus, faux correctif/acceptation, source retirée, binaire changé, résultat de soin altéré, dépendance retirée, question étrangère). Quatre refus du lecteur public : consommateur absent, source absente, fausse acceptation, question du parent adoptée par une autre fiche.

Les deux vraies bases SQLite sont relues avec Store.task, copy_text, summary, dépendances et résolution des questions ; intégrité et synchronisation ordinaire idempotente réussies. Par base :4 lignes de données/consignes mises à jour,42 603 autres lignes de catalogue exactes,42 607 états manuels et23 événements d’historique exacts. Trois fragments de consignes changent,42 212 restent exacts ;42 211 autres objets tâche/trace exacts. Identifiants, hiérarchie et registre des inconnus inchangés en octets. Tous les anciens descripteurs de source/consommateur sont conservés.

Réexamen courant :42 215 exigences,98 831 sources,2 796 consommateurs,26 189 questions ouvertes et5 517 résolues. Les2 796 ancres et octets de527 fichiers correspondent ; zéro divergence,17 auxiliaires conservés. Ce contrôle n’est pas un nouveau census physique des98k sources.8 360 fiches CH n’ont encore que le chargeur partagé applicable : file de recherche, pas compteur de fonctionnalités absentes.

Premier contrôle d’inspection refusé : l’expression attendue `let _ = self.basic_attack_hit(...)` n’était pas présente à l’appel mêlée. Le code a été relu et l’ancre réelle enregistrée ; l’inspection qualifiée a réussi dans un dossier séparé. L’essai initial et son script sont conservés. Aucun code du jeu n’a été modifié pour satisfaire cette vérification.

## Fichiers et suite

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Registre des inconnus inchangé. Reçu : docs/reference_requirement_trace_sources/warwick-passive-healing-links-v539.json ; preuve : docs/fidelity_warwick_passive_healing_links_v539.json. Rapports détaillés et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision539_Warwick et dossiers discovery/passive_probe/inspection_qualified. Scripts préparés dans E:/mapslol3v3, copies exactes archivées avec la livraison.

Couverture, plan documentaire, reprise, CURRENT et HANDOFF mis à jour avec sauvegardes et conservation des anciens champs. Aucun asset ou code produit changé, aucun stage/reset/commit. La source de la formule native et la mise en œuvre du passif restent ouvertes.

Continuer SYS-01.2-02 depuis revision540_trace_review/REVIEW.json. V539 Warwick est publié et audité : trois fiches, neuf sources pertinentes,27 arêtes natives,16 liens vers huit frontières. Six frappes sans objet ne restaurent rien au-delà de la régénération ; Sceptre1053 ajoute4.5433349609375 PV/frappe. Les deux infobulles et leurs liens INIBIN sont établis, mais f1, producteur de soin et dégâts magiques, cumul/expiration/changement de cible restent ouverts. Les anciens inconnus/statuts/cases restent exacts ; aucun passif corrigé ou accepté. Ne pas republier V539 ni relancer ses diagnostics sans cause nouvelle. Examiner ensuite Nasus : sources natives du vol de vie du passif, valeur par niveau et véritable producteur statistique/soin, distinct des objets et des lecteurs SOURCE. Les113 autres contrats/parents encore à examiner et8360 fiches CH au seul chargeur partagé sont une file de recherche, pas une mesure de complétion ou preuve d’absence. Goal actif.
