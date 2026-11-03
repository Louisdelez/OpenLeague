# SYS-01.2-02 — Sources Jax élargies et cadence mesurée, V538

25 octobre 2026 — F:/OpenLeague. Les trois fiches Jax **SOURCE, SIMULATION-CONTRAT et SIMULATION** relient des sources précises et des consommateurs actuels. **Le passif n'est pas déclaré implémenté ou terminé.** Référence native PUBLIC 4.20.0.315 EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et date de déploiement inconnus. Le catalogue officiel 4.20.1 reste distinct.

## Résultat intégré

**42 arêtes natives**, issues de 14 sources, sont ajoutées aux trois fiches. Les deux fiches de simulation reçoivent **16 liens vers huit frontières de code**. La fiche SOURCE conserve ses six consommateurs antérieurs : le chargeur de définition et cinq lecteurs d'audit. **Ces cinq lecteurs ne sont pas ajoutés comme mécanique de simulation.** Tous les anciens descripteurs et leurs rôles restent exacts.

Une question ouverte **OLU-42e6eefa-da30-5066-9f67-70555a14cf90** appartient au seul parent **CH-Jax-PASSIF-SIMULATION**. SOURCE et CONTRAT la référencent sans l'adopter. Les trois anciennes questions propres, les 3 occurrences de questions des dépendances, les quatre dépendances, statuts, critères, acceptations et états manuels sont conservés. Les 114 autres contrats/parents restent identiques. Aucune question fermée.

## Recherche native élargie

La recherche ne se limite plus à la première sélection par nom déclaré : **DATA/Spells** et **Characters/Jax/Scripts** contiennent des candidats supplémentaires déjà présents dans le registre. Douze fichiers sont relus : cinq INIBIN et sept chunks Lua, dont JaxPassive, les variantes JaxRelentlessAssault/AS/Speed/Debuff/Attack, RelentlessBarrier et Scripts/CharScriptJax. La définition Jax et le fichier de texte anglais portent le total à **14 payloads natifs**.

Leur taille et SHA sont vérifiés ; leur taille/MD5 sont à nouveau comparés aux deux projets sélectionnés par la solution EUW 68. **14 correspondent au manifeste sélectionné.** Cela ne décide pas le montage ou la priorité historique effective des variantes. Les catalogues et preuves de manifeste antérieurs restent conservés.

Les sept chunks Lua sont entièrement parsés et ne possèdent pas de prototype de callback enfant. Le lecteur littéral refuse toutefois **NEWTABLE au pc6 de JaxRelentlessAttack.luaobj** : les constantes citent SpellFXOverrideSkins et JaxSkin08, sans évaluation de la table. Cette limite n'est pas appelée corruption ou règle de passif manquante. Aucun moteur Lua ni callback du serveur original n'est exécuté ; aucune absence globale de sources n'est déduite.

La piste C# locale CharScriptJax.cs est également contrôlée : sa classe ICharScript est vide dans cette copie communautaire modifiée/non suivie, avec son SHA propre conservé. Cela ne qualifie ni le commit upstream ni toutes les implémentations communautaires. Cette recherche complémentaire reste dans SUPPLEMENTAL_COMMUNITY_REVIEW.json, sans nouveau lien de mécanique canonique.

Les quatre miroirs communautaires de champs nommés sont conservés comme **références séparées**. Leurs données ne deviennent pas une politique du serveur d'origine. Les séries de rangs, anciens textes de troisième frappe, animations et noms voisins ne sont pas choisis silencieusement comme formule de vitesse du passif.

## Lien exact avec les infobulles

L'INIBIN **JaxPassive.inibin**, 42 octets, contient le champ **BuffData.DynamicTooltip** : `game_buff_tooltip_JaxPassive`. Le nom BuffName du chunk JaxPassive est aussi conservé. Le fichier anglais contient cette clé et décrit une hausse de vitesse d'attaque paramétrée par **@f1@**, une durée de 2,5 secondes et un maximum écrit de six cumuls.

**La valeur f1 et son fournisseur restent inconnus.** Ce lien de champs et de texte est une preuve d'auteur, pas une sélection effective ni une exécution du serveur historique. L'ancienne description brute de Jax parle de dégâts supplémentaires via les objets : elle reste intacte et séparée du texte localisé.

Une autre ressource déclare exactement **game_buff_tooltip_JaxRelentless_Assault**, clé absente du fichier anglais inspecté. Les clés voisines existent mais **aucun alias n'est réécrit automatiquement**. C'est un constat limité à cette recherche de clé ; les fichiers sont présents, et les autres locales, overlays ou providers ne sont pas déclarés absents.

## Huit frappes dans le vrai core public

Un nouveau pilote dépend du **vrai crate openleague-core sur F**. Il charge la navigation TT réelle, active Map10, joint Jax et un Garen adverse, puis les déplace uniquement par **Action::Move**. Les identités, équipes, positions et la portée atteinte sont vérifiées. Aucun champ joueur, position, inventaire ou statistique n'est injecté.

L'ordre **Action::Attack** est accepté. Huit frappes normales non critiques réduisent réellement la santé de Garen. Jax reste au niveau 1, sans objet ; Garen n'attaque pas. Leurs préparations et libérations sont enregistrées :

| Frappe | Début | Libération | Cadence de statistique après frappe |
| --- | --- | --- | --- |
| 1 | 782 | 792 | 47 |
| 2 | 829 | 839 | 47 |
| 3 | 876 | 886 | 47 |
| 4 | 923 | 933 | 47 |
| 5 | 970 | 980 | 47 |
| 6 | 1017 | 1027 | 47 |
| 7 | 1064 | 1074 | 47 |
| 8 | 1111 | 1121 | 47 |

Les **sept intervalles réels sont de 47 ticks**, comme la cadence de base. Après Stop, les mesures à 1, 30 et 90 ticks restent à 47. Le contrôle achète une **Dague 1042** réelle : la statistique passe de **47 à 41 ticks**, puis revient à **47 après vente**. Le chemin sait donc observer ce modificateur d'objet dans ces conditions.

**La cadence inchangée ne prouve pas l'absence globale du passif.** Le taux f1 n'étant pas résolu, aucune attente numérique native n'est inventée. La statistique et la planification sont en ticks entiers, avec arrondi et limite minimale ; une petite variation pourrait rester masquée. La question ouverte demande de qualifier la formule et son producteur, puis de comparer avec une attente chiffrée tenant compte de cette résolution. Aucun défaut corrigé ou comportement de Jax accepté n'est déduit de ce seul résultat.

## Consommateurs et refus

Les huit frontières concernent le tick, l'ordre d'attaque, la statistique de cadence, sa lecture par l'attaque, la durée de préparation, la planification suivante, la frappe/dégâts et le bonus de vitesse d'objet. Elles portent toutes **entry_boundary_only**, **provides_feature_consumer=false**, **feature_scope_complete=false**. Leurs identités et lignes exactes sont vérifiées.

Les consommateurs de la fiche SOURCE restent les véritables lecteurs de métadonnées. Leurs succès ne ferment pas la fiche sémantique complète et ne deviennent pas des effets du passif. Le public refuse joueur inconnu, cible inconnue et cible propre avec les erreurs exactes conservées.

## Exécution et identités

La compilation privée utilise **--locked --offline**. Les identités de paquets et checksums sont un sous-ensemble exact du Cargo.lock racine, à l'exception du paquet diagnostic. Le core est réutilisé depuis son cache validé (`fresh=true`) ; seul le nouveau pilote est compilé. Les **1 158 entrées de code/ressources** et les anciens exécutables, sources, manifestes, verrous et artefacts restent exacts.

Binaire : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-jax-passive-cadence-probe.exe ; 5954560 octets ; SHA-256 **6b9faba974fb8f8c9dbbe6a8613c083522d6d4f003e418cc1df6951053ac51ae**.

BUILD et RUN : **codes 0**, collecte et contrôles réussis. Ce résultat n'est pas une acceptation du passif. Aucun serveur, client natif, moteur Lua, GPU, réseau ou multiclient exécuté. Le diagnostic n'est pas relancé pendant la publication. Les anciens tests et observations V534 à V537 restent des preuves distinctes, sans nouvelle exécution déclarée.

## Vérification et conservation

Inspection, préparation, contrôle privé, publication et audit séparé : **codes 0**. **51 faux constats refusés** : mauvais propriétaire, candidat supprimé, chiffre f1 inventé, cadence appelée absence, lecteur SOURCE appelé gameplay, ordre de candidats appelé priorité, clé absente appelée asset absent, miroir appelé règle native, défaut déclaré corrigé, fiche ou passif accepté, exécution native fictive, mesure/SHA altéré, alias réécrit, dépendance retirée et question étrangère adoptée. Quatre refus publics couvrent identifiants absents, acceptation inventée et question du parent adoptée par le contrat.

Trois extraits de trace changent ; **42 212 autres extraits** et **42 211 autres objets tâche/trace** sont exacts. IDs et hiérarchie sont identiques en octets. Les **31 705 anciens objets inconnus** sont identiques, avec un ajout chez le parent Jax uniquement. Anciens objets source/consommateur et preuves de navigation, modèles, rig, textures, matériaux et autres passifs conservés.

Dans chacune des bases projet et application de bureau : **4 destinataires**, **42 603 autres lignes catalogue**, **42 607 états manuels** et **23 historiques exacts**. Store.task, copie des consignes, résolution des questions, dépendances, intégrité et synchronisation normale idempotente sont vérifiés. Les consignes copiables gardent f1, l'arrondi et les limites de priorité explicitement ouverts.

Réexamen courant : **42 215 exigences, 98 827 sources, 2 788 CID**, ancres et identités exactes sur **527 fichiers**, zéro divergence, **26 189 questions ouvertes et 5 517 résolues**, 17 auxiliaires conservés. Les **8 362 fiches CH** au seul chargeur partagé restent une file d'examen, sans pourcentage de complétion ni preuve d'absence. Pas de nouveau recensement physique global des sources.

## Fichiers et suite

- Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json et fidelity_unknowns_4_20.json ; quatre lignes de données/consignes par base. Aucun critère ou état manuel changé.
- Reçu : docs/reference_requirement_trace_sources/jax-passive-source-cadence-links-v538.json ; preuve : docs/fidelity_jax_passive_source_cadence_links_v538.json.
- Sources et diagnostic : revision538_Jax_native_discovery, revision538_Jax_passive_probe et revision538_Jax_inspection. Sauvegardes/candidat/refus/audit : revision538_Jax ; commandes : revision538_Jax_COMMAND_*.json/.log.
- Réexamen : revision539_trace_review/REVIEW.json. Couverture, plan documentaire, reprise, CURRENT et HANDOFF actualisés avec sauvegardes et anciens champs conservés. Aucun code ou asset produit modifié ; aucun stage/reset/commit.

Continuer SYS-01.2-02 depuis revision539_trace_review/REVIEW.json : 8 362 fiches CH au seul chargeur partagé restent une file de recherche, sans absence ou complétion inférée. Examiner les 114 autres contrats de passifs depuis leurs sources exactes et consommateurs réels. Les recherches par déclaration exacte doivent aussi explorer DATA/Spells et Characters/<champion>/Scripts : Jax a montré des candidats supplémentaires enregistrés hors de la première sélection. Ne pas changer les anciennes preuves ni assimiler zéro hit lexical à une absence. V538 Jax est publié/audité : trois fiches, 42 arêtes natives, 14 payloads sélectionnés revérifiés, 16 liens de frontières et huit CID ; une question chez le parent seulement. Huit frappes produisent une cadence47 ticks, Dague47/41/47 ; f1 et attente numérique native restent non qualifiés, limite d’arrondi conservée. Aucune preuve d’absence globale ou acceptation du passif. Les variantes, la clé anglaise JaxRelentless_Assault absente et les miroirs ne donnent pas de priorité effective ni de règle serveur. Priorité suivante : examiner les sources et producteurs de soin sur attaque de Warwick, sans confondre soin du passif,vol de vie d’objet et API générique ; conserver les inconnues si la référence ou le chemin ordinaire manque. Préserver V537/V536/V535/V534 et les autres preuves, sans republier ou relancer les tests sans cause nouvelle. Goal actif.
