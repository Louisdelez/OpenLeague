# SYS-01.2-02 — Twisted Fate / Loaded Dice, V643

Date UTC 2026-10-26T22:43:31.113238+00:00. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et date de déploiement non établis. Catalogue 4.20.1 distinct.

V643 Twisted Fate / Loaded Dice : sept sources natives reliées aux trois fiches (21 associations),12 points actuels et24 liens de frontière. Le texte localisé natif indique1 à6 pièces supplémentaires par unité tuée ;le vieux Passive1Desc parle encore de critique. Tirage,pondérations etproducteur du compteur f1 non établis. Diagnostic du vrai moteur par API serveur de dégâts :six monstres tués par Twisted Fate,puis six par Garen témoin ;récompenses de base33/18/18/48/38/28,aucun bonus additionnel. 22 refus sans mutation ;6000ticks avancés sans injection d’état. Ce diagnostic ne passe pas par une attaque ordinaire du client. BUILD/RUN0,1158entrées du moteur conservées. Aucun code de jeu modifié,aucune case ou question fermée.

## Résultat intégré

Trois fiches CH-TwistedFate-PASSIF-SOURCE, CH-TwistedFate-PASSIF-SIMULATION-CONTRAT et CH-TwistedFate-PASSIF-SIMULATION reçoivent des liens précis, preuves et instructions détaillées. SYS-01.2-02 reçoit la synthèse. Sept sources natives donnent21 associations ;12 points courants donnent24 liens sur les deux fiches de simulation. Ces points sont qualifiés comme frontières, pas comme implémentation de Loaded Dice. Les cinq lecteurs historiques de sources de la fiche SOURCE conservent leur rôle.

Les statuts, critères, dépendances, anciennes preuves et acceptations restent conservés. Trois questions propres et quatre dépendances ne sont pas fermées. Registres des inconnues, identifiants et hiérarchie inchangés octet par octet. Les prérequis de phase, de lot et de tâche figurent dans le reçu ; cette analyse ne les déclare pas achevés.

## Sources vérifiées et contradiction

La découverte inspecte28 fichiers natifs et15 références communautaires, avec taille/SHA du registre et appartenance au manifeste RADS sélectionné pour les fichiers natifs. Quatre configurations hors périmètre sont conservées comme exclusions. Seuls sept fichiers directement utiles au passif ou à sa distinction avec les sorts sont reliés ici. Les21 autres restent des contextes voisins dans la preuve de découverte.

| Fichier natif relié | Octets | SHA-256 |
|---|---:|---|
| TwistedFate.inibin | 3123 | 49d84ea98bbdd044c1d6e04f621f06e32427c31e39c70be4f2a71e4e8307d383 |
| TwistedFate.ddf | 857 | aac43ea484fdd9e97803bd436b2fd3b1e5a096941ab1d746f92195d8702e3399 |
| CharScriptTwistedFate.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptTwistedFate.preload | 218 | 533866aea329d62228dd4e83add5c512a8db12eb663679889f59fcb9758efda5 |
| Second Sight.inibin | 44 | bb13e8df861179a4ecbe380f983e7cd3a56a59e848d777a9dbb3774d88492bc6 |
| SecondSight.luaobj | 188 | 6b63ba091c74f986fe2ae0e3503ab84face5c0d4c58c0345a96a7f888ba39e59 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |

TwistedFate.inibin donne Passive1LuaName=Second Sight et l’icône Cardmaster_SealFate.dds. PassLev1Desc1 renvoie à game_character_passiveDescription_TwistedFate ; le texte anglais décrit1 à6 pièces supplémentaires quand une unité est tuée. Second Sight.inibin lie exactement game_buff_tooltip_Second_Sight, ligne2598 du fontconfig, qui décrit le même gain et affiche Total Gold Hustled via @f1@. La description de personnage est à la ligne4293. En revanche Passive1Desc contient encore « Increases all friendly Champions' critical strike chance ». Cette contradiction est conservée ; la sélection effective historique de l’ancien champ n’est pas démontrée et il n’est pas utilisé comme règle de critique par défaut.

Passive1 et six champs Passive1Level sont absents, pas zéro. SecondSight.luaobj déclare seulement BuffName=Second Sight, la même texture et PersistsThroughDeath=true. CharScriptTwistedFate.luaobj a une initialisation vide. Les12 Lua inspectés n’ont pas de fonction enfant ; sept lectures de littéraux s’arrêtent sur NEWTABLE dans les ressources voisines d’attaque ou Stacked Deck. Les deux Lua directs du passif n’ont pas cette limite, mais ne fournissent pas le corps serveur du tirage.

Le preload CharScript nomme secondsight, apbonusdamagetotowers et cardmasterstack. Une dépendance de préchargement ne prouve pas l’appel d’un calcul d’or. Le DDF contient20 lignes ; seule PickACard;f1 est renseignée avec @special.twistedfatew et0.65. Ce calcul de W ne résout pas le passif. Le CharScript communautaire est vide. Les recherches bornées TwistedFate/LoadedDice/SecondSight dans les sources Rust, puis LoadedDice/SecondSight dans les scripts C#, n’ont donné aucune occurrence ; elles ne prouvent pas une absence dans toute archive possible. Aucun code communautaire n’a été exécuté ou élevé au rang de source native.

## Consommateurs et diagnostic

| Point courant | Ancre vérifiée |
|---|---|
| crates/core/src/lib.rs:533 | pub fn join( |
| crates/core/src/lib.rs:598 | pub fn command( |
| crates/core/src/lib.rs:685 | pub fn advance( |
| crates/core/src/lib.rs:744 | pub fn snapshot( |
| crates/core/src/attacks.rs:157 | pub(crate) fn advance_attacks( |
| crates/core/src/lifesteal.rs:4 | pub(crate) fn basic_attack_hit( |
| crates/core/src/damage.rs:53 | pub fn apply_damage( |
| crates/core/src/world.rs:355 | pub(crate) fn damage_unit( |
| crates/core/src/annie_r.rs:20 | pub(crate) fn combat_owner( |
| crates/core/src/champion_kills.rs:32 | pub(crate) fn reward_champion_death( |
| crates/core/src/passive_gold.rs:16 | pub(crate) fn advance_passive_gold( |
| crates/core/src/altars.rs:125 | pub(crate) fn altar_kill_bonus( |

Le chemin observé est apply_damage → damage_unit → combat_owner → attribution de gold + altar_bonus, puis global_gold. La récompense de champion, les attaques et le revenu ambiant sont des chemins voisins inspectés statiquement ; ils ne valent pas un consommateur spécifique de Loaded Dice.

Deux simulations neuves utilisent la carte10 et le vrai moteur non-test : l’une avec twistedfate, l’autre avec garen témoin. Chacune avance naturellement3000ticks puis sélectionne six vrais monstres vivants. Aucun état de position, niveau, PV, or ou horloge n’est modifié directement. Les mises à mort sont explicitement demandées par l’API serveur apply_damage avec dégâts bruts ; il ne s’agit pas de commandes d’attaque du client et cela ne qualifie ni portée ni déplacement ni animation. Aucun tick ne passe entre ces appels. Les autels possédés et les récompenses globales sont vérifiés à zéro, isolant l’or de base du supplément attendu.

| Cas | Victimes | Récompenses observées | Supplément après soustraction de la récompense normale |
|---|---:|---|---|
| Twisted Fate | 6 monstres | 33,18,18,48,38,28 | 0,0,0,0,0,0 |
| Garen témoin | 6 monstres | 33,18,18,48,38,28 | 0,0,0,0,0,0 |

Attendu du chemin actuel : l’or normal est distribué une fois. Observé : conforme. Attendu du texte natif pour une mise à mort admissible :1 à6 pièces supplémentaires. Observé dans ce diagnostic : aucun supplément ; le filtre natif précis des cibles reste à établir. Cela identifie un écart et non une réussite du passif.

22 refus avec snapshot inchangé : source inconnue, cible inconnue, dégâts négatifs, NaN, infini et six victimes déjà mortes dans chaque cas. Les deux cas zéro dégât ne mutent pas le snapshot ; les deux dégâts non létaux ne versent pas d’or. Le témoin démontre que le chemin de récompense fonctionne, pas que le passif natif fonctionne. Les6000ticks,12 mises à mort et22 refus sont fraîchement exécutés.

Binaire :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-twistedfate-loaded-dice-probe.exe ; 5703168 octets ; SHA-256 01335653fd65a24669d9748b9cfbfe5304a7ac2d4b024e5c4aecd729f96e8b1b. Le manifeste et le verrou privés correspondent aux identités/checksums de Cargo.lock du projet ; l’artifact compilateur identifie F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false. Les1158 entrées du moteur et ressources littérales sont identiques avant/après. Aucun code de jeu ou asset modifié.

## Contrôles de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 89cfc7476d0f7196f27fd54df95b185fb6d9b931ed9b3c6e6e994c30063e73a5 |
| RUN | 0 | 03f1697a44b814bb2bb7fc6c6659668d98650757821a6f07bc9965071cfcaf30 |
| prepare | 0 | 6d5660296ccffcc3f8c06092d03033a769dcd39618f1710cd5c4dbeb296dd822 |
| check | 0 | 6f06f720b4544fd42fbf86f01ce870f89cd5024e28f2150932873dc8ef3e603f |
| publish | 0 | 663d51ba9c576e7c3b651cfde43ca0f07328323846a772b80d106e53da52d3c1 |
| audit | 0 | 3a35ee544db1a732175060cbdbc416847df2552a000ab4fd357611fae2a8420c |

Les60 variantes d’associations invalides sont rejetées par la garde de livraison et quatre variantes de graphe par le vrai validateur. Les instructions complètes sont relues via Store.task et Store.copy_text, puis la résolution des sources, questions et dépendances est vérifiée. Trois fragments courts changent,42212 restent identiques.

Les deux bases sont vérifiées : quatre destinataires actualisés,42603 autres lignes de catalogue,42607 états manuels et23 historiques conservés ; synchronisation ordinaire idempotente. Revue indépendante :5055 ancres et empreintes de fichiers consommateurs sans divergence,99247 sources enregistrées. Elle ne rehache pas l’intégralité des99k sources et n’exprime pas un pourcentage d’achèvement du jeu.

## Livrables et preuves

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/twistedfate-passive-loaded-dice-links-v643.json. Vérification : docs/fidelity_twistedfate_passive_loaded_dice_links_v643.json. Bases : runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision643_TwistedFate_discovery\OBSERVATIONS.json. Diagnostic :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision643_TwistedFate_passive_probe\OBSERVATIONS.json. Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision643_TwistedFate_inspection/OBSERVATIONS.json. Audit de livraison :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision643_TwistedFate/DELIVERY_AUDIT.json. Revue globale :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision644_trace_review\REVIEW.json. Scripts et journaux conservés sousF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20. Deux lectures exploratoires ont visé les noms inexistants world_map10.json et kill_rewards.rs ; les consommateurs réels map10_world.json et champion_kills.rs ont ensuite été identifiés et utilisés. Ces lectures n’ont rien modifié.

Après audit, neuf copies de validation privées ont été archivées en gzip avec vérification de l’empreinte du contenu décompressé avant retrait des seuls doublons bruts. Gain logique :2397986911 octets. Archives et reçu :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision643_TwistedFate/snapshot-archives/VERIFIED.json. Les sources enregistrées, binaires, preuves et bases actives sont conservés. Pour rejouer les lecteurs V643 qui attendent les copies brutes, utiliser explicitementF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision643_restore_validation_snapshots.py ; la restauration n’a pas été exécutée après archivage, la décompression a été vérifiée par l’archiveur.

## Manques précis et limites

- Source du tirage natif, pondérations, générateur et état aléatoire ; aucune distribution uniforme inventée.
- Filtre exact des victimes, crédit des familiers et clones, structures, champions, morts simultanées et interactions avec les autres revenus.
- Producteur du total f1, maintien ou remise à zéro après mort, affichage et réplication ; le flag de persistance n’en fait pas preuve.
- Implémentation spécifique actuelle et tests d’attaques/sorts ordinaires, sbires, champions, crédits indirects et reprise réseau.
- Sélection historique effective entre la description brute de critique et les textes localisés d’or.
- Rendu, icône, effets, audio, client graphique, réseau et serveur historique non exécutés ici.

Continuer SYS-01.2-02 depuis revision644_trace_review/REVIEW.json. V643 TwistedFate publié et audité : sept sources natives,21 associations,12 frontières et24 liens ;six récompenses de monstres sans bonus dans le diagnostic serveur,TwistedFate etGaren témoin,22refus sans mutation,6000ticks. Distribution native,filtre exact de cibles etcompteur f1 ouverts ;ancienne description critique contradictoire conservée ;aucune attaque ordinaire testée. Prochain lot :Udyr PASSIF,dont contrat reste au chargeur partagé seul ;inspecter sources etconsommateurs avant de conclure. Ne pas dupliquer Tryndamere V537,Trundle V534/V535/V641,Twitch V642. Snapshots de validation V643 archivés en gzip vérifiés ;restaurer explicitement via revision643_restore_validation_snapshots.py uniquement pour rejouer les lecteurs qui attendent leurs chemins bruts. Sources etbases actives conservées. Goal actif.
