# SYS-01.2-02 — Darius : Hemorrhage, V562

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral du 17 novembre 2014 à 17:46:45, fuseau et date de déploiement inconnus. Catalogue officiel 4.20.1 distinct.

**Résultat : traçabilité enrichie et absence du saignement dans les essais courants. Aucun passif, champion ou jeu déclaré terminé. Aucun gameplay ni asset modifié.**

## Intégration dans le plan

Les fiches CH-Darius-PASSIF-SOURCE, CH-Darius-PASSIF-SIMULATION-CONTRAT et CH-Darius-PASSIF-SIMULATION reçoivent 42 associations vers 14 fichiers natifs. Les deux fiches de simulation reçoivent 44 liens vers 22 points de code, qualifiés entry_boundary_only et provides_feature_consumer=false pour Hemorrhage. Le chargeur générique et les fonctions ordinaires ne sont pas présentés comme un passif achevé. SYS-01.2-02 référence le lot.

Les prérequis de phase et de lot sont relevés dans le reçu. Les trois questions propres et quatre dépendances sont conservées, ainsi que les statuts, critères, identifiants et données manuelles.

## Sources et contrat

| Fichier natif | Identifiant du registre |
|---|---|
| Darius.inibin | OLS-ff079866-0bd8-5a42-8803-2df93d4ad59e |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptDarius.luaobj | OLS-10ef20eb-2d3e-57d4-944f-f3705a1a13a1 |
| CharScriptDarius.preload | OLS-06a43490-7275-5319-8baf-1eb2efbfce3c |
| DariusHemo.inibin | OLS-63b7b4d2-f23a-5c2b-bb96-ffb3b7d6a49e |
| DariusHemo.luaobj | OLS-8a30f566-2485-5d54-8064-b52d2a299c97 |
| DariusHemoInternal.inibin | OLS-130f6236-8818-50c0-97da-a02e135bec7d |
| DariusHemoInternal.luaobj | OLS-a22b9eb2-d648-5beb-af12-f7c2ebf5bd34 |
| DariusHemoMarker.inibin | OLS-e2c64173-ca71-5912-b1b2-7a00dfb7eeb1 |
| DariusHemoMarker.luaobj | OLS-787b6046-dde5-517e-9076-5dcaee7719f6 |
| DariusHemoSpeedKuoManager.luaobj | OLS-9b61e290-d446-5e4d-a411-1f46ae65ecf3 |
| DariusHemoVisual.inibin | OLS-d1e54787-51c0-5ef7-9c8a-121aeabaeb7e |
| DariusHemoVisual.luaobj | OLS-a261078a-3048-5227-b8dc-2632a85d0a01 |
| DariusHemoVisual.preload | OLS-423d9fb5-6691-512f-94b8-2ada130447bf |

Les tailles et SHA256 concordent avec le registre ; les tailles et MD5 concordent avec les manifestes RADS sélectionnés lors de la découverte. La présence dans un manifeste ne démontre pas la priorité de chargement historique. Les sources ont été revérifiées pour ce lot.

Le CharScript est à la racine du répertoire Darius, les fichiers Hemo dans Spells. Darius.inibin lie Passive1LuaName à DariusHemoMarker et l’icône Darius_Icon_Hemorrhage.dds. Deux liaisons de tooltip sont exactes : DariusHemo et DariusHemoMarker.

Le texte natif à la ligne 1816 décrit des dégâts magiques sur cinq secondes, jusqu’à cinq cumuls, déclenchés par attaques et capacités infligeant des dégâts ; il indique 5% de vitesse par champion ennemi ensanglanté. Les variables f1/f2 ne sont pas résolues par ce texte. La description à la ligne 4177 confirme les cinq cumuls.

Six Lua sont entièrement parsés, leurs initialisations littérales sont lisibles et aucun ne contient de prototype enfant de callback. Le CharScript est vide. Le marker expose PersistsThroughDeath et NonDispellable ; d’autres fichiers exposent DoesntTriggerSpellCasts ou IsDeathRecapSource. Ces déclarations ne démontrent ni ordre serveur, ni persistance, ni récapitulatif de mort effectif.

Deux preloads nomment sorts et particules, dont des compteurs visuels de cumul. Ils ne prouvent pas le chargement, le rendu ou la fidélité des skins. Six références communautaires restent distinctes des sources natives ; le CharScript communautaire est une classe vide.

Passive1 et les champs Passive1Level1 à Passive1Level6 sont absents. PassLev1Desc2 à 4 contiennent des descriptions héritées de régénération de mana : elles ne sont pas adoptées comme règles du passif Darius.

## Moteur courant et essais exécutés

Les liens couvrent initialisation, statistiques, actions, apprentissage et refus de sorts, attaques, impact physique, dégâts et mitigation, tick global, vitesse et caps, régénération, achats et bonus, cibles, carte et sorts temporisés. Leur portée est explicitement limitée à Darius ; aucun rôle global existant n’est rétrogradé.

Les essais utilisent le core courant non-test, Map10 et les ressources littérales. Achats depuis l’or initial, déplacements, attaques et arrêt passent par les API publiques. Aucun PV, mana, or, XP, dégât, position ou effet n’est injecté directement. Darius reste niveau 1, aucun décès ni fin de partie.

| Cas | Impacts | Résistance magique cible | Vitesse de Darius | Ticks suivis après Stop |
|---|---:|---:|---:|---:|
| single_attack | 1 | 32.1 | 340 | 180 |
| five_attacks | 5 | 32.1 | 340 | 180 |
| five_attacks_target_cloak | 5 | 57.1 | 340 | 180 |
| five_attacks_boots | 5 | 32.1 | 365 | 180 |

Attendu : distinguer les attaques physiques ordinaires, un éventuel saignement sur cinq secondes et un bonus de vitesse lié à la cible. Observé : les 16 impacts correspondent à AD × 100 / (100 + armure), après compensation de régénération plafonnée aux PV maximum. AD = 55.880001, armure cible = 27.535999 ; résidu maximal = 0.0000190735. Les coups successifs sont espacés de 44 ticks. Les ticks sont 810,854,898,942,986 sans bottes et 797,841,885,929,973 avec bottes ; le cas à un coup s’arrête au tick 810.

Entre les coups et pendant les 180 ticks suivant Stop dans chaque cas, la variation de PV correspond uniquement à la régénération de base. Aucun dégât périodique supplémentaire n’est observé. Les 720 ticks après arrêt représentent quatre fenêtres de six secondes à 30 Hz, pas une qualification de toutes les durées possibles. La cible Garen ne reprend pas son passif dans cette fenêtre ; la compensation utilise les taux de base du core.

La vitesse reste 340, ou 365 après l’achat de bottes 1001 à 325 or. La cape 1033 à 500 or ajoute 25 de résistance magique à la cible. Ces contrôles confirment les bonus ordinaires des objets ; l’absence de saignement ne permet pas de qualifier sa réduction par la résistance magique. Les cinq coups ne prouvent pas la création de cinq cumuls : aucun état Hemorrhage effectif n’est observé ou revendiqué.

Soixante refus atomiques sont contrôlés avec snapshot inchangé : par cas, joueur inconnu, cible inconnue, cible propre et douze Learn/Cast/CastAt sur quatre slots. Ces refus ne prouvent pas un déclenchement de passif par sort.

## Manques et limites

- Qualifier le producteur des valeurs f1/f2, la formule et ses coefficients, la cadence des dégâts, le rafraîchissement et l’expiration des cumuls.
- Relier les déclencheurs d’attaque et de sort à un consommateur effectif, puis tester une à cinq charges, plusieurs cibles, annulation, mort, boucliers et dissipation.
- Qualifier durée, portée, empilement et caps du bonus de vitesse par champion ensanglanté.
- Vérifier séparément sbires, monstres, structures, cas multijoueurs, HUD, animations, particules et audio. Aucune exécution du serveur historique, VM Lua complète, GUI, GPU ou réseau dans ce lot.
- Ne pas confondre les données présentes avec une implémentation complète. Les recherches locales ne prouvent pas l’absence de sources ailleurs.

## Vérification et conservation

Build, exécution, inspection, préparation, contrôle du candidat, publication et audit ont terminé avec code 0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-darius-passive-hemorrhage-bleed-speed-probe.exe` ; 6030848 octets ; SHA256 `f7670efc4fe7236085b3f25f9190a1db96e0e203613209347d97bb182b062754`. Reçu runtime `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision562_Darius_passive_probe\OBSERVATIONS.json`. Les 1158 entrées de code/ressources et les anciens artefacts sont conservés exactement. Le verrou du projet de test est aligné sur Cargo.lock ; le core en cache a été utilisé, sans réexécuter la suite historique entière.

72 associations invalides et quatre graphes invalides sont refusés : validation inventée, assimilation des bonus d’objet au passif, métadonnée présentée comme exécution, source manquante, question étrangère ou dépendance supprimée.

Dans chacune des deux bases SQLite, quatre destinataires sont vérifiés ; 42603 autres lignes de catalogue, 42607 états manuels et 23 événements historiques restent exacts. Store.task, copie des instructions, résumé, dépendances, références, intégrité SQLite et synchronisation idempotente sont vérifiés. Trois fragments de trace changent ; 42212 restent identiques. Les registres des identifiants, de hiérarchie et d’inconnues sont identiques en octets.

Graphe : 42215 exigences, 98924 sources, 3157 consommateurs ; 3157 ancres exactes et aucune divergence sur les fichiers courants. 26189 questions ouvertes et 5517 résolues restent inchangées. Ce contrôle structurel ne recalcule pas toutes les empreintes des sources. Les 8314 fiches CH associées seulement au chargeur partagé constituent une file de recherche, pas un taux d’achèvement.

## Fichiers modifiés et reprise

Les registres completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json sont enrichis ; le reçu docs/reference_requirement_trace_sources/darius-passive-hemorrhage-bleed-speed-links-v562.json et la preuve docs/fidelity_darius_passive_hemorrhage_bleed_speed_links_v562.json sont ajoutés. Couverture, plan et documents de reprise sont sauvegardés puis complétés. Scripts et preuves antérieures conservés. Aucun stage, reset ou commit.

Continuer SYS-01.2-02 depuis revision563_trace_review/REVIEW.json. Lot Darius V562 publié et audité : 3 fiches, 14 sources natives, 42 associations, 22 points de code et 44 liens de portée limitée. Quatre essais publics : un coup, cinq coups, cape cible 1033, bottes 1001. 16 coups physiques ordinaires ; 720 ticks après Stop sans saignement, vitesse 340 ou 365 avec bottes, MR cible 32.1 ou 57.1 avec cape ; 60 refus atomiques. Build/run/inspection/prepare/check/publish/audit réussis ; aucune injection, aucun code du jeu modifié. Les 2 tooltips et 6 Lua littéraux sans callbacks ne qualifient pas la logique serveur ; 2 preloads et 6 références communautaires conservés. Formule f1/f2, cadence, rafraîchissement, sorts, multicibles, expiration, morts, présentation et réseau restent ouverts. Champs hérités de régénération de mana non adoptés, niveaux 1 à 6 absents. Ajouter revision562_Darius_passive_probe à la conservation des anciens artefacts au prochain probe. Conserver également Corki qualifié avec original_execution_wrapper et vérificateur, et les échecs/analyses qualifiées antérieurs. Examiner ensuite dans la file courante les fiches du passif Diana : vérifier sources et consommateurs existants avant tout constat de manque. Aucun statut, case ou inconnue fermé. Ne pas republier V562 sans nouvelle preuve. Goal actif. Découverte Diana déjà exécutée : revision563_Diana_discovery/OBSERVATIONS.json, 13 sources natives, deux liaisons au même tooltip DianaPassive, quatre Lua littéraux sans callbacks, deux preloads, sept références communautaires. Le CharScript natif et DianaCombatBuff sont vides ; la classe communautaire contient du code de posture/animation et ne doit pas être présentée comme vide ou comme une implémentation du passif. DianaPassive et DianaPassiveDeathRecap ont les mêmes octets Lua et métadonnées, sans preuve de dispatch. Niveaux 1/4/7 présents mais non adoptés comme règle. Texte 1838 : vitesse attaque f3, tous les trois coups bonus magique f1/f2 en zone ; valeurs, compteur et géométrie à qualifier. Aucune exécution Diana encore. Préparer six attaques publiques avec une seconde cible ennemie proche, comparer AD/armure/régénération et cadence ; utiliser Tome AP ou Dague comme contrôles ordinaires distincts. Ne pas refaire la découverte sans cause nouvelle.
