# SYS-01.2-02 — Rammus : Carapace cloutée, V547

25 octobre2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 à17:46:45 ; fuseau et déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré et prérequis

CH-Rammus-PASSIF-SOURCE, CH-Rammus-PASSIF-SIMULATION-CONTRAT et CH-Rammus-PASSIF-SIMULATION reçoivent18 arêtes vers six sources natives. Les deux fiches de simulation reçoivent28 liens vers14 frontières effectives, toutes `entry_boundary_only` et `provides_feature_consumer=false`. SYS-01.2-02 référence ce lot ; lecteurs de sources et chargeur partagé conservés sans promotion en producteur du passif.

Phases, lots et prérequis effectifs sont consignés dans le reçu, sans déclarer leurs sorties achevées. Trois questions propres et quatre dépendances restent exactes, ainsi que les propriétaires des questions référencées. Aucun inconnu ajouté ou fermé ; statuts, critères, cases, notes et historiques conservés.

## Sources natives

| Fichier | Identifiant |
|---|---|
| Rammus.inibin | OLS-818ca10f-c794-50f6-a6ef-2a74596b9272 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Spiked Shell.inibin | OLS-49fe6cdf-3fef-5ace-9788-df9e0d38b8b4 |
| SpikedShell.luaobj | OLS-22313b73-94f8-570b-b5ed-f5b6cf2161a1 |
| CharScriptRammus.luaobj | OLS-978af507-f1c9-5ba8-91c8-6f1b7742dd06 |
| CharScriptRammus.preload | OLS-967ac418-6b6d-5fed-a366-811f1f91eec0 |

Les six fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets sélectionnés du manifeste RADS. Le périmètre porte sur la définition, Spells/Spiked Shell ou SpikedShell, et CharScriptRammus. Il ne prouve pas une absence mondiale de code serveur.

Passive1LuaName et BuffName valent exactement `Spiked Shell`. L’INIBIN porte un espace ; le fichier Lua `SpikedShell.luaobj` n’en porte pas. BuffData.DynamicTooltip lie directement la clé `game_buff_tooltip_Spiked_Shell`, avec soulignement, ligne2702 du font anglais. La description du champion, ligne4259, annonce **25% de l’armure convertie en dégâts d’attaque**. L’infobulle garde f2 pour le pourcentage et f1 pour le bonus ; la valeur25 du texte ne qualifie pas leurs producteurs effectifs. Aucune politique de résolution des variantes de nom n’est déduite.

Les deux Lua sont parsés jusqu’à leur fin, sans prototype de callback enfant. Le buff de221octets contient nom, texture Armordillo_ScavengeArmor.dds et booléens de persistance/non-dissipation ; CharScript de56octets ne contient qu’un RETURN. Le preload déclare spikedshell et apbonusdamagetotowers. Ni une VM originale, ni l’effectivité des booléens, ni un rendu ne sont validés. Passive1, Passive1Desc, descriptions supplémentaires et niveaux1..3 sont absents et restent absents. Armor vaut31.384000778198242 et BaseDamage55.880001068115234.

Deux JSON communautaires et le CharScriptRammus.cs vide de cette copie sont relus avec provenance ; ils ne deviennent pas le serveur original. Les ressources courantes champions, croissance, boutique, autels et profils d’attaque sont pinées séparément. Les références natives contenues dans les profils ne constituent pas une nouvelle qualification complète des attaques historiques.

## Consommateurs et essai réel

Le chemin inspecté relie join, stats, ad_components, shop::bonuses, achat/vente/refresh_item_caps, ordre Attack, advance_attacks, libération mêlée, basic_attack_hit, apply_damage, régénération et tick. ad_components combine base/croissance, objet, autels et ajustement AD courant. Les armures temporaires et les ajustements de défense sont identifiés comme contexte ; leur ordre natif avec le passif reste ouvert. Les attaques ordinaires consomment les dégâts courants ; cela n’en fait pas le producteur de Spiked Shell.

Trois parties Map10 avec navigation réelle : aucun objet, Armure d’étoffe1029 (+15armure), Épée longue1036 (+10AD). Les deux cas équipés achètent, revendent puis rachètent au point de départ ; la vente rétablit les valeurs initiales. Déplacements publics de Rammus et Garen vers deux positions praticables, Stop, puis trois attaques ordinaires de Rammus dans chaque cas. Aucun or, expérience, position, dégât, statistique ou état de passif injecté. Les deux champions restent vivants au niveau1, sans victoire ; Garen n’attaque pas, n’a pas de bouclier et les neuf impacts sont non critiques.

| Objet | Armure Rammus | AD observé | Bonus AD selon texte25% | Premier impact observé, régénération corrigée | Prédiction conditionnelle avec bonus textuel |
|---|---:|---:|---:|---:|---:|
| sans objet | 31.384000778198242 | 55.880001068115234 | 7.8460001945495605 | 43.8150634765625 | 49.967071533203125 |
| 1029 | 46.384002685546875 | 55.880001068115234 | 11.596000671386719 | 43.8150634765625 | 52.907413482666016 |
| 1036 | 31.384000778198242 | 65.8800048828125 | 7.8460001945495605 | 51.656005859375 | 57.80799865722656 |

Les impacts surviennent aux ticks817,865,913 dans les trois cas. Les neuf pertes de vie correspondent aux dégâts courants après mitigation par l’armure de Garen ; la régénération précédant l’attaque dans le tick est comptabilisée avec clamp à la vie maximale. Le modèle comparatif utilise la mitigation **actuelle** et ne constitue pas un oracle serveur historique. L’armure supplémentaire ne change ni AD ni dégâts infligés ; l’épée témoin augmente les deux.

Résidus numériques conservés : AD au-delà de base+objet0 dans les deux premiers cas,3.814697265625e-06 avec l’épée ; plus grand écart entre impact et prédiction générique1.9073486328125e-05PV. Tolérances déclarées :0.001AD et0.002PV. Ces résidus float32 ne sont pas promus en bonus du passif. Les prédictions textuelles de totalAD sont63.72600173950195,67.47599792480469 et73.72600555419922 ; elles ne sont pas observées dans ces cas.

Quinze refus publics, chacun avec snapshot complet avant/après identique : joueur inconnu, cible inconnue, soi-même comme cible, objet inconnu et case de vente hors limites, dans chaque partie. Achat/vente/rachat, armure, AD et attaques témoins passent les contrôles. La réussite du diagnostic démontre l’écart mesuré, pas la fidélité du passif.

Compilation et exécution retournent0. Core non-test en cache Cargo ;1158 entrées source/ressource, anciens artefacts et identité/checksums des paquets du Cargo.lock racine restent exacts. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-rammus-passive-conversion-probe.exe` ;6028800octets ; SHA-256 `6329e0195b392203e19c6d7ddbe265f2395f4f0261af1a59dcaab0eb66965f09`. Source, outils, manifestes, verrous, logs et commandes pinés dans `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision547_Rammus_passive_probe\OBSERVATIONS.json`. Aucun client historique, serveur natif, GPU, réseau, audio ou validation visuelle exécuté.

## Livraison vérifiée

Discovery, inspection, prepare, check, publish et audit réussis.60 associations invalides et quatre graphes invalides refusés : faux bonus, prédiction courante présentée comme acceptation native, fournisseurs dynamiques ou alias faussement résolus, source/binaire modifié, question étrangère ou dépendance retirée. Quatre preuves ajoutées et anciens descripteurs conservés.

Par base réelle : quatre destinataires actualisés,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques exacts. Store.task/copy_text/summary, questions/dépendances, integrity_check et sync_catalog idempotent vérifiés. Trois fragments de traçabilité changent,42212 restent exacts ;42211 autres objets tâche/trace préservés. IDs, hiérarchie et registre des inconnus restent identiques en octets.

Réexamen :42215 exigences,98864 sources,2879 consommateurs ;26189 questions ouvertes et5517 résolues.2879 ancres et527 fichiers actuels exacts,zéro divergence ;17 auxiliaires conservés. Ce n’est pas un nouveau census physique de toutes les sources.8344CH au seul chargeur partagé désigne une file de recherche,pas un taux de complétion.

## Livrables, limites et suite

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/rammus-passive-conversion-links-v547.json ; preuve docs/fidelity_rammus_passive_conversion_links_v547.json. Quatre lignes données/consignes changent par base. Couverture, plan documentaire, reprise, CURRENT et HANDOFF actualisés avec sauvegardes et anciens champs conservés. Scripts exécutés sur F et archivés. Aucun gameplay/asset modifié ni stage/reset/commit.

Restent à qualifier : producteurs f1/f2, alias effectifs, autres niveaux, W et armure temporaire, multiplications/réductions, arrondis natifs, mort, présentation et corps serveur original. Le cas d’armure positive fixe ne couvre pas toutes ces règles. V546 et antérieurs sont conservés.

Continuer SYS-01.2-02 depuis revision548_trace_review/REVIEW.json. V547 Rammus publié/audité : trois fiches,six sources natives,18arêtes,28liens vers14frontières ;3questions propres/4dépendances conservées. Trois scénarios niveau1 sans objet/Armure1029/Épée1036. Armure31.384→46.384 sans AD supplémentaire ; bonus textuels7.846/11.596absents au-delà des résidus float32. Épée+10AD positive. Neuf attaques ordinaires aux ticks817/865/913 :43.815PV sans objet/armure contre51.656épée,conformes à la mitigation courante avec régénération,celles-ci ne qualifient pas le serveur natif. Quinze refus individuels,ventes/rachats,déplacements publics ; pas d’injection. f1/f2,alias,W/armure temporaire,niveaux,multiplicateurs,mort ouverts. Champs absents conservés. Aucun gameplay modifié/passif accepté. Ne pas republier ni relancer sans cause nouvelle. Examiner ensuite Malphite : Granite Shield/MalphiteShield/Obduracy,10%maxPV et recharge après10s sans dégâts. Identifier sources exactes,variantes/markers/cooldowns et producteurs de bouclier avant diagnostic ; le lookahead des textes2254/2256/2630/4228 ne qualifie pas leurs providers.105autres contrats/parents de passifs restent à examiner ;8344CH au seul chargeur partagé reste une file de recherche,pas un taux de complétion. Goal actif. Découverte Malphite déjà effectuée dans revision548_Malphite_discovery/OBSERVATIONS.json :14sources natives,3liens directs de tooltip,5Lua sans callbacks enfants,4preloads et5références communautaires. ShieldEffect entièrement parsé mais initialisation littérale non qualifiée à NEWTABLEpc8,pas une corruption. Ancien texte Jax/mana/niveaux conservé ; Obduracy/Shield_Marker textuels non liés par les trois INIBIN inspectés. Diagnostic runtime et publication Malphite restent à faire ; ne pas relancer la découverte sans cause nouvelle.
