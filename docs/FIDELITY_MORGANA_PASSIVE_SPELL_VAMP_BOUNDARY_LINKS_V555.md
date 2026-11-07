# SYS-01.2-02 — Morgana : Soul Siphon, V555

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue 4.20.1 distinct.

## Résultat et portée

Les trois fiches CH-Morgana-PASSIF-SOURCE, CH-Morgana-PASSIF-SIMULATION-CONTRAT et CH-Morgana-PASSIF-SIMULATION sont reliées à sept fichiers natifs : 21 associations. Les deux fiches de simulation reçoivent 34 liens vers 17 points du code actuel, tous qualifiés entry_boundary_only et provides_feature_consumer=false pour ce passif. SYS-01.2-02 référence ce lot. Les chargeurs et lecteurs existants sont conservés.

Ce résultat documente des sources et des limites réelles. Il ne termine pas Morgana, son passif ou le jeu. Aucun gameplay ou asset n’a été modifié. Les prérequis de phase et de lot, trois questions propres et quatre dépendances sont conservés dans le reçu ; leur existence ne signifie pas leur achèvement.

## Sources retrouvées

| Fichier | Identifiant |
|---|---|
| Morgana.inibin | OLS-1cb4a668-0445-5185-9217-d7c4935d9294 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptMorgana.luaobj | OLS-a781b676-a4b2-51f0-82f7-e26a83949f76 |
| CharScriptMorgana.preload | OLS-d7575eea-a6f6-5234-9db7-51d7113a7a1f |
| Empathize.inibin | OLS-24a917f4-59ed-5db6-b1ae-659e22f90787 |
| EmpathizeAura.luaobj | OLS-58261c25-a6a9-5b90-bd20-144abbe60139 |
| EmpathizeAura.preload | OLS-f22be836-9a28-5fb7-b48f-51c708711a45 |

Taille/SHA256 conformes au registre ; appartenance taille/MD5 aux projets RADS sélectionnés vérifiée à la découverte, identités recontrôlées à l’inspection. Passive1LuaName Empathize, BuffName Empathize et icône FallenAngel_Empathize.dds concordent. Empathize.inibin lie game_buff_tooltip_Empathize, ligne 1866 : f1% bonus SpellVamp. La description du champion, ligne 4236, décrit un soin lié aux dégâts de sorts.

Deux Lua intégralement parsés, sans fonction enfant, avec initialisations littérales. CharScriptMorgana déclare PersistsThroughDeath et NonDispellable ; EmpathizeAura déclare aussi le nom du buff et sa texture. Ces métadonnées ne sont pas une exécution du serveur historique.

Deux preloads référencent notamment empathizeaura, apbonusdamagetotowers, crestbigmarker et des effets idle/base/skin05. Ces références ne prouvent ni un bonus aux tours, ni un rendu de skin, ni la logique de soin. Trois références communautaires restent identifiées séparément des sources originales.

## Manques et inconnues

- Le fournisseur du paramètre f1, ses valeurs et changements de niveau ne sont pas résolus.
- Les dégâts et cibles admissibles, réductions éventuelles pour dégâts de zone ou persistants, arrondis et ordre des modificateurs ne sont pas qualifiés.
- Les routes publiques actuelles Learn/Cast/CastAt refusent Morgana comme non implémentée : aucune activation de Soul Siphon n’a été testée.
- Passive1 et Passive1Level1/2/3 sont absents de la définition sélectionnée ; aucune valeur par défaut inventée. L’ancien texte de régénération des alliés est conservé mais non adopté comme règle 4.20.
- Mort, réapparition, présentation visuelle et sonore, autres niveaux et catégories de cibles restent ouverts. Aucun client historique, serveur original, VM Lua, GPU ou réseau exécuté.

Il ne s’agit donc pas uniquement d’assets manquants : des ressources sont présentes, mais le producteur de soin et son contrat historique restent à qualifier.

## Contrôles attendus et observés

Trois simulations Map10 utilisent les API publiques ordinaires : Morgana sans objet, Morgana avec Sceptre vampirique 1053, Annie avec 1053 comme contrôle distinct. Achat normal depuis 825 or ; objet courant de 800 or, +10 dégâts d’attaque et environ 8% de vol de vie. Déplacement, quatre coups reçus, arrêt de l’adversaire puis trois attaques normales par cas. Aucun PV, mana, or, XP, dégât, position ou effet directement injecté.

Attendu : distinguer régénération ordinaire, vol de vie sur attaques et soin sur sorts ; garder assez de PV manquants pour observer le soin sans écrêtage. Observé :

| Champion | Objet1053 | PV supplémentaires par attaque | Refus vérifiés |
|---|---|---|---:|
| morgana | False | [0.0, 0.0, 0.0] | 17 |
| morgana | True | [4.10614013671875, 4.10614013671875, 4.10614013671875] | 17 |
| annie | True | [3.78936767578125, 3.78936767578125, 3.78936767578125] | 7 |

Morgana sans objet : aucun soin supplémentaire. Avec 1053 : environ 4.10614 PV par attaque, correspondant aux dégâts physiques après mitigation multipliés par le taux de vol de vie. Annie : environ 3.78937 PV par attaque. Tolérance float32 du contrôle : 0.002 PV. Ce mécanisme est celui de l’objet, pas une validation de Soul Siphon.

Annie apprend et lance W : 70 mana consommés, impact au tick 1087, dégâts nets observés 52.9378662 après l’effet de la régénération de la cible, aucun soin supplémentaire pour Annie. Ce contrôle ne remplace pas un sort de Morgana. Les 90 ticks observés après arrêt des attaques suivent uniquement la régénération ordinaire.

41 refus individuels avec snapshot complet inchangé : cinq gardes communes par cas (joueur inconnu, cible inconnue, cible alliée/soi, objet inconnu, vente hors slots), 24 tentatives Learn/Cast/CastAt de Morgana et deux gardes de W Annie (non appris et lancement déjà en cours).

Points de code reliés : join, stats, Learn/next_rank, commande, Cast/CastAt, achat/vente, attaques/projectiles, basic_attack_hit, apply_damage, heal, régénération/taux, tick, advance_annie_w. Le chemin basic_attack_hit déclenche le vol de vie ; l’appel de dégâts de W Annie ne le fait pas. Le soin générique disponible ne constitue pas un producteur de passif Morgana.

## Exécutions et conservation

Build et run : code 0. Inspection, préparation, contrôle de candidat, publication et audit : code 0. Le binaire réel est `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-morgana-passive-spell-vamp-boundary-probe.exe`, 6047744 octets, SHA256 `7bff74adad2017ee4aa6e7a9f3c2a3b73d8686f4fb3e8089fab85cbe746592ae`. Reçu du runtime : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision555_Morgana_passive_probe\OBSERVATIONS.json`. Logs BUILD/RUN conservés. 1158 entrées de code/ressources et les anciens artefacts sont restés identiques ; verrou privé aligné sur le Cargo.lock racine. Core non-test issu du cache ; ce constat ne vaut pas nouvelle exécution de tous les tests historiques.

72 associations invalides et quatre graphes invalides refusés. Les contrôles rejettent notamment lifesteal présenté comme Soul Siphon, W Annie présenté comme sort Morgana, f1 inventé, anciennes métadonnées adoptées sans preuve, question étrangère et dépendance supprimée.

Deux bases SQLite mises à jour : quatre destinataires chacune, 42603 autres lignes de catalogue, 42607 états manuels et 23 événements historiques inchangés. Store.task/copy_text/summary, dépendances, résolution de sources, intégrité SQLite et synchronisation idempotente vérifiés. Trois fragments de trace changés, 42212 inchangés ; identifiants, hiérarchie et registre des inconnues identiques en octets.

Audit global : 42215 exigences, 98896 sources, 3012 consommateurs ; 3012 ancres et 527 fichiers courants vérifiés, zéro divergence. 26189 questions ouvertes et 5517 résolues. Pas de nouveau contrôle physique de toutes les sources enregistrées. Les 8328 fiches CH avec seulement le chargeur partagé forment une file de recherche, pas un pourcentage d’achèvement.

## Fichiers modifiés et suite

Registres completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json ; reçu docs/reference_requirement_trace_sources/morgana-passive-spell-vamp-boundary-links-v555.json ; preuve docs/fidelity_morgana_passive_spell_vamp_boundary_links_v555.json. Couverture, plan, reprise, CURRENT et HANDOFF actualisés avec sauvegardes. Scripts et preuves antérieures conservés. Aucune case cochée, statut promu ou inconnue fermée.

Continuer SYS-01.2-02 depuis revision556_trace_review/REVIEW.json. Morgana V555 publié/audité :7sources natives,21arêtes,17points actuels/34liens false. Trois cas publics testent9attaques normales,12coups entrants,90ticks après attaque et41refus. Objet1053 soigne sur attaques normales ;W Annie distinct ne soigne pas. Morgana Learn/Cast/CastAt refusés :activation Soul Siphon non qualifiée. Résoudre f1,niveaux,cibles/règles de dégâts et producteur de soin sur sorts ;préserver texte ancien regenalliée et champs absents. Aucun gameplay changé,aucune case/statut/inconnue fermée. Examiner les prochains passifs avec le seul chargeur partagé,à partir des sources natives et des vrais consommateurs. Ne pas republier V555 sans cause nouvelle. Goal actif. Découverte Ahri déjà terminée :revision556_Ahri_discovery/OBSERVATIONS.json,18sources natives,4bindings,8Lua littéraux sans callbacks,4preloads,6références communautaires. Sources dans Characters/Ahri/Spells ;Scripts absent du seul dossier sélectionné. Texte1660/4150 :jusqu à3charges par sort,9charges avant prochain sort soignant chaque cible touchée ;Counter1664 formule9sorts,à conserver distinct. f1/f2 non résolus. Ancien texte critique allié et bonus Attack Rate non adoptés ;Passive1/niveaux absents. SoulCrusher2/3/4 contiennent icône Egitai et effets potions,SoulCrusher5 chaînes vides :ne pas assimiler à des rangs ou effets acceptés. Runtime et inspection qualifiée restent à faire ;ne pas relancer découverte sans cause nouvelle.
