# SYS-01.2-02 — Corki : RapidReload, V561

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré

CH-Corki-PASSIF-SOURCE, CH-Corki-PASSIF-SIMULATION-CONTRAT et CH-Corki-PASSIF-SIMULATION reçoivent18associations vers6fichiers natifs. Deux fiches de simulation reçoivent44liens vers22points de code, entry_boundary_only et provides_feature_consumer=false pour RapidReload. SYS-01.2-02 référence le lot. Les lecteurs et liens antérieurs sont conservés.

Prérequis de phase et de lot relevés. Trois questions propres et quatre dépendances conservées. Aucun statut,critère,identifiant,case,note ou historique manuel modifié. Aucun code du jeu ni asset modifié.

## Sources natives

| Fichier | Identifiant |
|---|---|
| Corki.inibin | OLS-bba4fe4b-1b38-5fb0-9ece-32f2c210f881 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptCorki.luaobj | OLS-c5c7ec41-3f4d-5c70-9850-9467cb9efbb8 |
| CharScriptCorki.preload | OLS-5b3ee18b-35b9-542a-b157-35562e2625d8 |
| RapidReload.inibin | OLS-a45fbb4e-037d-57c8-8067-824a2d592a9e |
| RapidReload.luaobj | OLS-a2761aa1-d3c1-5f43-82be-18037ff46c9d |

Identités taille/SHA256 conformes au registre ; taille/MD5 conformes aux projets RADS sélectionnés lors de la découverte, sources revérifiées à l’inspection. RapidReload INIBIN/Lua sont dans DATA/Spells ; le CharScript est dans Corki/Scripts.

Le tooltip2510 décrit un supplément de dégâts vrais égal à10% de l’AD total, hors structures. La description4176 mentionne sbires,monstres,champions. Passive1LuaName=RapidReload et l’icône Corki_RapidReload.dds concordent avec les globals du Lua. Deux Lua entièrement parsés et littéraux, sans prototype enfant ; le CharScript expose des globals vides. PersistsThroughDeath=true et NonDispellable=true restent des déclarations, pas un test serveur. Un preload et trois références communautaires sont conservés ; le CharScript communautaire est vide.

Passive1Desc contient «Every 5 spell casts, Annie stuns the target(s).». Ce champ hérité n’est pas adopté comme règle Corki. Les niveaux1/4/7/texte10/13/16 sont présents mais aucune politique de progression n’en est déduite. Passive1 est absent et n’est pas remplacé par une valeur inventée.

## Consommateurs actuels

Points inspectés :join/stats, commandes, Learn/next_rank, Cast/CastAt, lancement et impact des attaques, basic_attack_hit, apply_damage, mitigate, profil critique, initialisation du monde, description/protection des cibles, damage_unit, classification structure, régénération, shop_guard, achat/vente et bonus d’objets.

Le chemin d’attaque courant fournit un projectile physique et basic_attack_hit appelle DamageKind::Physical ; aucun déclenchement RapidReload n’est qualifié dans cette route. La formule générique DamageKind::True existe séparément. Son test arithmétique ne prouve ni un événement True appliqué au monde ni le déclenchement automatique du passif.

## Quatre cas publics exécutés

Corki contre Garen sans objet ; Corki avec Épée longue1036 à360or ; Garen avec Armure d’étoffe1029 à300or ; Corki contre Turret_T2_R_02 avec Cristal de rubis1028 et Armure d’étoffe1029 achetés pour700or. Ces derniers objets fournissent de la défense, pas d’AD. Achats depuis825or, déplacements et attaques par API publique ; aucun PV,mana,or,XP,dégât,position ou effet directement injecté. Aucun décès ou match terminé ; Corki reste niveau1.

| Cas | Impacts | AD | Armure cible | Dégât observé au premier impact | Bonus prévu par le texte seul |
|---|---:|---:|---:|---:|---:|
| base | 6 | 51.240 | 27.536 | 40.176880 | 5.124 |
| long_sword | 6 | 61.240 | 27.536 | 48.017822 | 6.124 |
| target_cloth | 6 | 51.240 | 42.536 | 35.948792 | 5.124 |
| outer_turret | 2 | 51.240 | 67.000 | 30.682617 | 0.000 |

Attendu : séparer les dégâts physiques ordinaires du supplément10%AD décrit par la source et de son exclusion des structures. Observé :18impacts sur champion, aux ticks844/892/940/988/1036/1084 dans chaque cas, correspondent uniquement à AD×100/(100+armure), après compensation de régénération plafonnée aux PV maximum. Le résidu maximal vaut0.0000228882 ; aucun supplément5.124 ou6.124 n’est observé. Le bonusAD et l’armure modifient correctement la composante physique courante.

Deux impacts sur la tourelle extérieure non protégée TT_ChaosTurret2, aux ticks1102/1150, retirent chacun30.682617PV avec67armure. L’identité de cible provient du snapshot courant. Cette attaque physique est compatible avec l’exclusion décrite des structures, mais ne prouve pas le passif complet puisqu’aucun supplément n’est observé non plus sur champion. Autres structures,sbires et monstres non testés dans ce lot.

## Contrôles et erreur d’analyse conservée

68refus atomiques : par cas, joueur inconnu,cible inconnue,cible propre,deux tentatives Buy/Sell hors boutique et12Learn/Cast/CastAt sur quatre slots. Snapshot complet inchangé. Les8refus boutique interviennent avant l’inspection de l’objet ou du slot ; ils ne démontrent pas ces gardes internes.

La compilation et les combats ont terminé avec code0. Le premier vérificateur Python a ensuite échoué : il attendait les messages «item behavior not implemented» et «invalid inventory slot», alors que les commandes avaient été envoyées hors boutique. Le code shop_guard et les8observations montrent «outside allied shop». Le script initial est conservé, avec les écarts attendus/observés. La correction porte **uniquement sur l’analyse**, dans revision561_corki_verify_existing.py ; aucun combat ni build relancé. Le reçu qualifié conserve le wrapper initial et ses empreintes.

Contrôle arithmétique distinct : mitigate(100,True) rend100 pour armure0/100/1000 même avec facteur de réduction0.7 ; les dégâts physiques rendent100/50/environ9.09. Trois entrées invalides sont refusées : montant négatif,NaN,réduction2. Aucun appel apply_damage direct ni événement True en jeu n’est revendiqué par ce contrôle.

## Travail restant

- Qualifier puis intégrer le déclencheur et le supplément10%AD total : moment d’échantillonnage,ordre des dégâts,critique,vol de vie,boucliers et réductions.
- Vérifier sbires,monstres et autres structures, annulation,cible morte,projectile déjà parti,réinitialisation et persistance au décès.
- Qualifier projection réseau,HUD,animations,effets et sons. Aucun client original,VM Lua complète,GUI,GPU,audio ou réseau exécuté ici.
- Conserver les champs hérités distincts des règles adoptées et ne pas assimiler calcul générique ou métadonnée à une mécanique terminée.

## Vérification et conservation

Build/run0 ; première analyse échouée conservée ; analyse corrigée,inspection,préparation,contrôle du candidat,publication,audit0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-corki-passive-rapidreload-true-damage-probe.exe` ; 6067712octets ; SHA256 `e1c15164c521ade9502f606329fa99594b91d42915366c370539f7571c3a1efe`. Reçu qualifié `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision561_Corki_passive_probe_qualified\OBSERVATIONS.json`.1158entrées de code/ressources et anciens artefacts exacts ; verrou privé aligné au Cargo.lock racine. Core non-test en cache ; la suite historique complète n’a pas été réexécutée.

72associations invalides et4graphes invalides rejetés : activation inventée,formule True assimilée au passif,persistance déduite des métadonnées,description Annie adoptée,ancienne analyse présentée comme réussie,source manquante,question étrangère ou dépendance retirée.

Deux bases SQLite :4destinataires chacune ;42603autres lignes de catalogue,42607états manuels,23événements historiques exacts. Store.task/copy_text/summary,dépendances,références,intégrité et synchronisation idempotente vérifiés. Trois fragments changés,42212inchangés. IDs,hiérarchie et inconnues identiques en octets.

Graphe42215exigences,98920sources,3135consommateurs ;3135ancres et527fichiers courants exacts,zéro divergence.26189questions ouvertes/5517résolues. Pas de nouveau recensement physique de toutes les sources.8316fiches CH à chargeur partagé seulement restent une file de recherche,pas un taux d’achèvement.

## Fichiers et suite

completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json ; reçu docs/reference_requirement_trace_sources/corki-passive-rapidreload-true-damage-links-v561.json ; preuve docs/fidelity_corki_passive_rapidreload_true_damage_links_v561.json ; couverture,plan,reprise,CURRENT et HANDOFF sauvegardés puis complétés. Scripts et anciennes preuves conservés. Aucun stage/reset/commit.

Continuer SYS-01.2-02 depuis revision562_trace_review/REVIEW.json. Corki V561 publié/audité :6sources natives,18arêtes,22points/44liens false. Quatre cas publics :base,Épée longue1036,cible armure1029,tourelle extérieure Turret_T2_R_02.18impacts champion et2tourelle physiques seulement,68refus,aucune injection. AD51.24/61.24,armure27.536/42.536/67,bonus vrais10% non observé. Pure fonction mitigate True contrôlée séparément,3valeurs/3refus,pas un événement ou un passif. Build/run0 ;analyse initiale échouée car8refus Buy/Sell étaient hors boutique avant validation objet/slot. Analyse corrigée seule via revision561_corki_verify_existing.py,aucun combat rejoué,ancien wrapper/logs conservés.1binding,2Lua littéraux sans callbacks,1preload,3références communautaires. Phrase Annie et niveaux1/4/7/texte10/13/16 conservés sans adoption ;persistance métadonnée. Minions/monstres,critique,ordre,boucliers,réseau/présentation restent ouverts. Aucun gameplay changé,statut/case/inconnue fermé. Examiner ensuite Darius/Hemorrhage :dégâts magiques périodiques5secondes,5cumuls et5%MS par champion ensanglanté,avec sources4.20 et consommateurs distincts. Ne pas republier V561 sans nouvelle cause. Goal actif. Découverte Darius déjà exécutée avec succès : revision562_Darius_discovery/OBSERVATIONS.json, 14 sources natives vérifiées, 2 liens de tooltip, 6 Lua entièrement parsés et littéraux sans callbacks, 2 preloads, 6 références communautaires. CharScript à la racine du champion ; DariusHemoMarker et icône concordants. Le texte 1816 décrit dégâts magiques sur 5 secondes, 5 cumuls et 5% de vitesse par champion ensanglanté. f1/f2, cadence, scaling et politique de rafraîchissement restent à qualifier. Niveaux 1 à 6 absents ; descriptions héritées de régénération de mana non adoptées. Métadonnées persistance/récapitulatif de mort et préchargement de particules ne prouvent pas leur exécution. Aucun runtime Darius exécuté. Préparer des attaques publiques puis Stop, observer les PV au-delà de 5 secondes avec compensation de régénération et la vitesse, comparer un puis cinq coups et une résistance magique cible. Préserver les artefacts Corki qualifiés avec original_execution_wrapper et script du vérificateur ; ne pas reprendre le dossier initial sans OBSERVATIONS ni refaire les combats. Ne pas refaire la découverte Darius sans cause nouvelle.
