# SYS-01.2-02 — Amumu : Cursed Touch, V550

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 à17:46:45, fuseau et déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré

CH-Amumu-PASSIF-SOURCE, CH-Amumu-PASSIF-SIMULATION-CONTRAT et CH-Amumu-PASSIF-SIMULATION reçoivent24 arêtes vers8 sources natives. Les deux fiches de simulation reçoivent32 liens vers16 points réels du code, qualifiés `entry_boundary_only` et `provides_feature_consumer=false`. SYS-01.2-02 référence le lot. Le chargeur et les lecteurs de sources restent conservés sans promotion en implémentation du passif.

Phases, lots et prérequis sont relevés dans le reçu. Trois questions propres et quatre dépendances restent exactes ; aucune question ajoutée ou fermée, aucun statut, critère, case, note ou historique manuel modifié.

## Sources et limites natives

| Fichier | Identifiant |
|---|---|
| Amumu.inibin | OLS-47bc1fe6-2f9d-5ea7-b957-7145ceda3f86 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CursedTouch.inibin | OLS-0100a07d-e6db-5cf6-b03a-f897058f447c |
| CursedTouch.luaobj | OLS-d4644881-45e2-54c2-b474-e83363180193 |
| CursedTouchMarker.inibin | OLS-e32c25b2-40be-5e8e-8e57-04933806d44f |
| CursedTouchMarker.luaobj | OLS-a7993182-cbe2-5b67-bb29-f209e1082b5b |
| CharScriptAmumu.luaobj | OLS-fb2bd742-0915-522c-8600-5791567ea6d7 |
| CharScriptAmumu.preload | OLS-fd70c34c-b7fc-597f-b594-b60877a46a85 |

Ces8 fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets RADS sélectionnés. La découverte du tour précédent est revalidée et réutilisée. Elle ne constitue pas une recherche exhaustive de tout code serveur historique.

La définition et le BuffName du marker concordent sur `CursedTouchMarker`. Son INIBIN lie `game_buff_tooltip_CursedTouchMarker` ligne1810 : réduction de résistance magique de f1 pendant **3 secondes** après les attaques de base. `CursedTouch.inibin` lie le texte d’effet **1809**, qui constate une résistance magique réduite. La description du champion4154 décrit une réduction temporaire. Les variantes textuelles `Cursed_Touch_Marker`1808 et `CursedTouchSelf`1811 ne sont pas sélectionnées par les deux bindings inspectés ; aucun alias ou ordre de chargement n’est inventé.

La description littérale `Passive1Desc` mentionne20/30/40/50, avec niveaux déclarés1/9/17. Ces champs ne résolvent pas le fournisseur f1 ou la règle active. Passive1 absent reste absent. Les textes +40/+60/+80% de régénération de mana restent conservés sans adoption. L’icône déclarée est `SadMummy_CorpseExplosion.dds`.

Trois Lua sont entièrement parsés, sans prototype de callback enfant. CursedTouch déclare nom/icône ; le marker ajoute PersistsThroughDeath et NonDispellable. CharScriptAmumu déclare l’icône AuraofDespair, sans corps serveur du passif. Le preload cite cursedtouch, cursedtouchmarker, apbonusdamagetotowers et tantrum. Ces métadonnées ne prouvent ni exécution serveur ni rendu. Les quatre références communautaires restent séparées ; leur CharScript C# est vide. Aucun fichier NightmareBot n’est adopté comme passif standard.

## Diagnostic du consommateur actuel

Chemin inspecté : join, stats, bonus d’objets, achats/ventes et plafonds, commande Attack, tick d’attaque, libération mêlée, basic_attack_hit, apply_damage, régénération, tick général, pénétration, mitigation et ajustement défensif de Trundle. Le dernier est un mécanisme d’un autre champion ; il n’est pas déclaré producteur de CursedTouch.

Trois parties Map10 réelles au niveau1, Amumu contre Ahri : sans objet ; objet1033 sur Ahri ; Épée longue1036 sur Amumu. Achats/ventes/rachats, déplacements, arrêts et attaques passent par l’API publique. Aucun or, XP, stat, ressource ou position injecté. Les acteurs restent vivants, au niveau1, sans victoire. **Un événement de dégâts magiques est fourni séparément et explicitement pour le seul contrôle générique.**

Trois attaques ordinaires non critiques par cas, aux ticks828,875,922. La résistance magique de la cible reste30 ou55 avant/après chaque attaque et pendant chacun des91ticks suivants,923..1013. Cela couvre des échantillons au90e et91e tick après le dernier impact, sans qualifier l’expiration d’un effet qui n’a pas été observé.

| Cas | MR de la cible | AD d’Amumu | Perte physique par attaque |
|---|---:|---:|---:|
| Sans objet |30|53.3839989|44.1628113|
| Objet1033 sur cible |55|53.3839989|44.1628113|
| Épée1036 sur Amumu |30|63.3839989|52.4354858|

Les neuf pertes correspondent à la mitigation physique courante et à la régénération du tick ; tolérance0.002PV, résidu maximal1.1444091796875e-05PV. L’objet1033 ajoute25MR ; l’Épée ajoute10AD ; les ventes/rachats vérifient la réversibilité. Aucune réduction de MR par le passif n’est observée dans ces cas. Ce constat borné ne fixe pas le montant natif manquant.

Après le troisième impact, au même tick922, le diagnostic appelle `apply_damage(Some(Amumu),Ahri,100,Magical)`. Ce sont **100 dégâts fournis par le diagnostic**, pas un sort, un paquet client ou un déclenchement natif. Les valeurs post-mitigation sont76.92308044433594 à30MR et64.51612854003906 à55MR. Les retraits de vie conservent leurs arrondis float32 :76.92306518554688 /64.51614379882812 /76.923095703125 selon le cas. Aucun bouclier ou décès. Le contrôle prouve la consommation de la MR courante par les dégâts magiques génériques ; il ne prouve pas Cursed Touch.

Quinze refus de commandes : joueur/cible inconnus, cible soi-même, objet inconnu, emplacement de vente invalide, dans chaque partie. Douze refus d’événements serveur : source/cible inconnues, montant négatif et NaN, dans chaque partie. Chaque refus possède sa propre comparaison de snapshot complet, inchangé. Ce sont15 commandes et12 événements, pas27 commandes client.

## Vérifications et conservation

Build/run0, core non-test en cache Cargo.1158 entrées source/ressource et tous les anciens artefacts sélectionnés restent identiques. Identités/checksums des dépendances du verrou privé alignés sur le Cargo.lock racine. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-amumu-passive-mr-probe.exe` ;6041088octets ; SHA-256 `06ded743b0595f7836567f72cb455cad3574e3edf3ac018011aa010b4ab8eb8b`. Commandes, sources, manifestes, verrous, outils et logs sont identifiés dans `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision550_Amumu_passive_probe\OBSERVATIONS.json`. Aucun processus historique, VM originale, GPU, réseau, audio ou contrôle visuel exécuté.

Inspection,prepare,check,publish,audit réussis.72 associations invalides et4 graphes invalides refusés, dont témoin présenté comme passif, valeurs/niveaux/alias adoptés sans preuve, source/binaire modifié, question étrangère et dépendance retirée. Ces vérifications concernent la traçabilité et la conservation, pas une acceptation de gameplay.

Par base réelle :4 destinataires actualisés,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques exacts. Store.task/copy_text/summary, questions/dépendances, intégrité et synchronisation idempotente vérifiés.3 fragments changent,42212 restent exacts ;42211 autres objets tâche/trace conservés. IDs, hiérarchie et inconnus identiques en octets.

Graphe42215 exigences,98876 sources,2925 consommateurs ;26189 questions ouvertes/5517 résolues.2925 ancres et527 fichiers actuels exacts, zéro divergence,17 auxiliaires conservés. Aucun nouveau recensement physique des98k sources.8338CH au seul chargeur partagé reste une file de recherche, pas un pourcentage d’achèvement.

## Fichiers et travail restant

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/amumu-passive-mr-links-v550.json ; preuve docs/fidelity_amumu_passive_mr_links_v550.json. Couverture, plan documentaire, reprise, CURRENT et HANDOFF actualisés avec sauvegardes et anciens champs conservés. Scripts de diagnostic et de livraison archivés. Aucun code de jeu ou asset modifié, aucun stage/reset/commit.

Restent ouverts : producteur autoritaire, fournisseur f1, valeurs/niveaux effectifs, initialisation, durée/refresh, cumul et ordre, cibles autres que champion, mort, alias et présentation. Les réductions de résistance d’autres champions et le témoin magique ne résolvent pas ces inconnues. V549 et tous les artefacts antérieurs sont conservés.

Continuer SYS-01.2-02 depuis revision551_trace_review/REVIEW.json. V550 Amumu publié/audité :3 fiches,8 sources natives,24 arêtes,32 liens vers16 frontières ;3 questions propres/4 dépendances conservées. Trois parties niveau1 Amumu/Ahri :MR cible30/55 inchangée pendant9attaques et91ticks après le troisième. Objet1033 sur cible+25MR ;1036 sur Amumu+10AD. Impacts828/875/922,pertes44.16281/52.43549PV. Témoin serveur100magiques explicitement fourni au922 :mitigation76.92308/64.51613 ;pas un sort ni passif.15refus commandes/12événements,snapshots individuels exacts. Trois Lua sans callbacks,texte3s avec f1 non résolu ;20/30/40/50,niveaux1/9/17,mana,Passive1 absent,alias underscore/Self et NightmareBot non adoptés. Aucune acceptation de durée/refresh ou de cible hors champion. Aucun gameplay modifié. Ne pas republier ni relancer sans cause nouvelle. Examiner ensuite Chogath/Carnivore :texte1774 f1PV/f2mana sur kill,description4175 croissance selon niveau. Identifier définition,binding,Lua/preloads et consommateurs actuels de morts/récompenses/soin/ressource avant diagnostic ;ne pas inventer les valeurs natives.102 autres contrats/parents de passifs restent à examiner ;8338CH au seul chargeur partagé est une file de recherche,pas un taux de complétion. Goal actif. Découverte Chogath déjà effectuée et revalidée dans revision551_Chogath_discovery/OBSERVATIONS.json :7 sources natives,1 binding de buff,2 Lua sans callbacks enfants,2 preloads et3 références communautaires. Définition et BuffName Carnivore ;f1PV/f2mana,scaling selon niveau non résolu. Passive1/description littérale/niveaux absents conservés ;particles battlecast_heal/globallifesteal ne prouvent pas un soin ni un skin rendu. Chemins world.damage_unit,champion_kills,award_experience,healing/regeneration et trundle_passive relevés. Séparer le soin de passage de niveau et la régénération du tick,éviter de qualifier une restauration sur pool déjà plein. Runtime,inspection qualifiée et publication restent à faire ;ne pas relancer la découverte sans cause nouvelle.

## Supplément de fraîcheur — contrôle source/consommateur au 2026-11-02

Le reçu V550 et sa preuve de vérification sont toujours byte-identiques (SHA-256 du reçu : 105a430e2ebdb3cb975ef811d339f3443bc3fb7573e65bf847d7a496197bb174; preuve passed=true). L’INIBIN propriétaire Amumu.inibin rehashé conserve 2 952 octets et SHA-256 e75b90750a8f2a0a1ce555029852d2927667b883198061eb0e90c7125dc4c802. Les 16 ancres de consommateurs du reçu sont présentes aux lignes enregistrées et les empreintes des 16 fichiers Rust correspondent encore aux pins V550.

Ce contrôle réutilise, sans le relancer, le diagnostic V550 : neuf attaques ordinaires réparties sur trois scénarios ont laissé la MR de cible inchangée, tandis que le contrôle séparé de dégâts magiques génériques suit la MR courante. Cela établit que le lien vers les frontières actuelles est encore valable et que ces voies ordinaires ne démontrent pas Cursed Touch. Ce n’est pas une exécution du client ou serveur historique. Fournisseur f1, montants effectifs, niveaux, cibles et ordre restent ouverts; CH-Amumu-PASSIF-SOURCE et les tâches de mécanique ne sont pas déclarées terminées. Aucun test ni build relancé dans ce supplément.