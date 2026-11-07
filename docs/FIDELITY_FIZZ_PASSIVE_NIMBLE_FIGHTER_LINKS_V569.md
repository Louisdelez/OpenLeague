# SYS-01.2-02 — Fizz : Nimble Fighter, attaques reçues et collision, V569

Date UTC 2026-10-25T23:54:34.077912+00:00. F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau et date de déploiement inconnus ; catalogue officiel4.20.1 distinct.

## Résultat intégré

Trois fiches : CH-Fizz-PASSIF-SOURCE, CH-Fizz-PASSIF-SIMULATION-CONTRAT et CH-Fizz-PASSIF-SIMULATION.21 associations vers7 sources natives ;56 liens vers28 points de code couvrent les deux composantes du passif. SYS-01.2-02 référence le lot. Les consommateurs restent `entry_boundary_only`, `provides_feature_consumer=false` pour Nimble Fighter. Trois questions propres et quatre dépendances conservées. Aucun gameplay ni asset modifié.

Les essais montrent deux écarts actuels : les attaques reçues suivent la mitigation physique ordinaire sans réduction supplémentaire observée, et Fizz reste soumis à l’évitement des champions alliés. La traversée des ennemis se produit aussi pour Garen ; ce comportement général ne valide pas une immunité propre à Fizz.

## Sources et limites natives

| Ressource retenue | Identifiant |
|---|---|
| Fizz.inibin | OLS-1d8804d0-6be3-5a6e-a6ff-80980a6c50d4 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptFizz.luaobj | OLS-1a784601-175b-5d58-86c2-606ffe6c4cd2 |
| CharScriptFizz.preload | OLS-944232dd-19b5-544c-9885-b206a7d76172 |
| FizzPassive.inibin | OLS-525ffb67-8c06-5037-b429-b86073191541 |
| FizzPassive.luaobj | OLS-bd291edc-cbe3-5173-809e-343bfebe535f |
| FizzPassive.preload | OLS-d6fd725c-329e-5d2f-8e11-f8814af7d54a |

Huit candidats examinés, sept retenus. Tailles/SHA256 conformes au registre et tailles/MD5 conformes aux projets RADS sélectionnés ; cela ne prouve pas la priorité effective du chargement historique. Les identités détaillées, lecteurs et prérequis sont enregistrés dans le reçu et les observations.

Fizz.inibin lie Passive1LuaName à FizzPassive, l’icône à FizzPassive.dds et PassLev1Desc1 à game_character_passiveDescription_Fizz. Passive1Desc mentionne explicitement l’absence de collision avec les unités et la réduction des dégâts physiques des attaques de base. Le tooltip en_GB ligne1911 décrit la traversée et une réduction **@f1@** ; la description ligne4187 précise les dégâts physiques d’attaques de base. Le producteur de f1, les seuils par niveau et l’ordre de mitigation ne sont pas établis par ces textes. Les six champs Passive1Level sont absents, sans valeur de substitution.

Deux Lua retenus sont entièrement lus : initialisations littérales reconnues, aucun prototype enfant. Deux preloads et une liaison de tooltip sont conservés. FizzPassive déclare BuffName,PersistsThroughDeath et NonDispellable ; aucun BuffTextureName n’y est déclaré. Le champ d’icône du personnage reste une source distincte : cette absence de global ne prouve pas une texture manquante.

Le candidat FizzPassiveDisplayIcon.luaobj déclare **FizzSeastoneTrident** et l’icône FizzSeastonePassive.dds. Le slot2 du personnage désigne FizzSeastonePassive. Ces références liées à Seastone restent distinctes ; DisplayIcon n’est pas promu automatiquement en présentation de Nimble Fighter. Il est conservé dans les recherches et empreintes, avec son exclusion motivée.

Le rayon de navigation natif est littéralement "30" ; GameplayCollisionRadius est absent. Un rayon de navigation, un rayon de corps et une règle d’immunité à la collision sont des contrats différents. Huit références communautaires sont conservées séparément ; le CharScript est vide et ne fournit pas les callbacks du passif.

## Attaques entrantes ordinaires

Deux simulations Map10 : Fizz bleu, Annie rouge, déplacements publics vers deux points proches puis attaque publique d’Annie. Le second cas achète publiquement l’Armure d’étoffe1029. Aucun changement direct de position,santé,mana,or,XP,rang ou effet ; aucun événement artificiel de dégâts.

| Cas | Armure de Fizz | Impacts reçus isolés | Refus publics |
|---|---:|---:|---:|
| fizz_incoming_attacks_base | 22.41200065612793 | 6 | 15 |
| fizz_incoming_attacks_cloth1029 | 37.41200256347656 | 6 | 15 |

Les12 impacts sont reçus au niveau1. Chaque impact est associé à un projectile d’Annie présent dans le snapshot précédent. Le brut vaut50.40999985 ; après prise en compte de la régénération de base, les pertes sont41.18060303 sans objet et36.68530273 avec objet. Elles correspondent à la formule physique courante brut×100/(100+armure), avec résidu inférieur à0.002. L’objet apporte15 d’armure : ce contrôle distingue mitigation par armure et réduction propre au passif. Aucun effet additionnel de Nimble Fighter n’est observé sur ces impacts ; cela ne fournit pas la valeur native manquante de f1.

Les30 refus atomiques couvrent joueur inconnu, attaque de soi, slot invalide et douze Learn/Cast/CastAt par scénario. Les snapshots restent inchangés. Autres niveaux, coups critiques, attaques de sbires/monstres et autres composantes de dégâts restent à qualifier.

## Déplacements alliés et ennemis

Quatre simulations publiques supplémentaires comparent Fizz à Garen. Pour l’allié, une Annie bleue reste à sa position de départ et le joueur reçoit l’ordre de rejoindre son centre. Pour l’ennemi, une Annie rouge est déplacée puis arrêtée ; le joueur reçoit l’ordre de traverser sa position vers un point situé250 unités plus loin.

| Acteur | Unité stationnaire | Somme des rayons de navigation | Distance minimale | Destination demandée atteinte |
|---|---|---:|---:|---|
| fizz | alliée | 60.0 | 60.0 | False |
| garen | alliée | 65.0 | 65.0 | False |
| fizz | ennemie | 60.0 | 4.3369140625 | True |
| garen | ennemie | 65.0 | 3.0 | True |

Les centres alliés restent inaccessibles : Fizz s’arrête à60 unités et Garen à65, exactement les sommes des rayons de navigation des profils concernés. Les essais durent300 ticks. Contre l’ennemi, les deux champions atteignent la destination ; ils passent respectivement à4.336914 et3 unités du centre adverse. Ce second résultat est commun aux deux champions et ne constitue pas une preuve de passif Fizz.

Les points de code relient la sélection des seuls alliés comme obstacles, les corps vivants, les positions occupées, le routage, les réservations de mouvements et le dispatch courant. Fizz ne possède pas d’exception dans ce chemin inspecté. Les contrôles ne couvrent pas les sbires,monstres,familiers,structures ni toutes les interactions avec le terrain. Le défaut de déplacementV564 demeure ouvert ; les routes réussies ici ne le corrigent pas.

## Contrôles, identité et conservation

Exécutable `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-fizz-passive-nimble-fighter-probe.exe` ; 6047744 octets ; SHA256 `09787d54f6ef4adbfc96946b7b4bfa916a6dc8865414e77a5676888fdaf06e16`. Compilation/exécution code0 ; six cas publics sans injection. Dépendance openleague_core non-test, verrou privé aligné avec les identités/checksums du verrou racine ;1158 entrées core/ressources et chaîne historique inchangées. V568 corrigée et son échec initial sont conservés, avec V567 et les preuves précédentes. Aucun client ou serveur historique exécuté.

Inspection/prepare/check/publish/audit code0.72 associations invalides et4 graphes invalides refusés. Deux bases SQLite :4 destinataires,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques préservés. Store.task/copy_text/summary/dépendances et résolution de trace vérifiés ; intégrité et synchronisation idempotente contrôlées. Identifiants,hiérarchie,inconnues identiques en octets ;3 fragments de trace modifiés,42212 conservés.

Revue fraîche :42215 exigences,98952 sources,3308 consommateurs ;3308 ancres exactes,zéro divergence constatée.26189 questions ouvertes/5517 résolues inchangées. Cette revue ne re-hashe pas toutes les98952 sources et ne mesure pas un pourcentage d’achèvement du jeu. Les fichiers sélectionnés possèdent leurs contrôles d’identité séparés.

## Travail restant

- Qualifier le producteur de f1,les valeurs et seuils de niveau,les attaques éligibles,l’ordre par rapport à armure,boucliers,on-hit et composantes de dégâts.
- Intégrer et qualifier la réduction propre au passif dans le traitement des attaques reçues.
- Définir et intégrer l’immunité de collision pour les catégories d’unités concernées, sans confondre navigation,corps et terrain.
- Vérifier réseau,HUD,animations,VFX et audio séparément. Aucun rendu ni transport réseau qualifié dans ce lot.
- Conserver le défautV564 ouvert ; aucune texture ou géométrie manquante n’est démontrée par ces essais.

Registres completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json enrichis ; reçu reference_requirement_trace_sources/fizz-passive-nimble-fighter-links-v569.json ; preuve fidelity_fizz_passive_nimble_fighter_links_v569.json. Couverture,plan,checkpoint,CURRENT,HANDOFF et deux bases actualisés avec sauvegardes. Scripts et journaux :revision569_Fizz sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun statut ni case fermé automatiquement.

Continuer SYS-01.2-02 depuis revision570_trace_review/REVIEW.json. V569 Fizz publiée/auditée:3fiches,7sources parmi8candidats,21associations,28points/56liens limités. Six essais publics sans injection:12autoattaques Annie reçues au niveau1,armure22.412/37.412,mitigation ordinaire sans réduction additionnelle,30refus. Fizz/Garen bloqués aux centres alliés à60/65unités;traversée ennemie pourlesdeux àminimum4.3369/3unités,donc pas preuve de passif Fizz. f1,échelle de niveau,ordre de réduction et catégories d’unités ouverts. DisplayIcon lié SeastoneTrident/SeastonePassive exclu de Nimble Fighter. Rayon navigation30 distinct du rayon gameplay absent. Préserver INPUTS_BEFORE.previous_artifacts V569,qui conservequalifiedV568 et son échec initial ainsi que la chaîne antérieure. Aucun statut/case/inconnu fermé. Reprendre le prochain passif non qualifié dans la file du lecteur générique,par exemple Gangplank,après inspection réelle. Défaut déplacementV564 ouvert;goal actif.
