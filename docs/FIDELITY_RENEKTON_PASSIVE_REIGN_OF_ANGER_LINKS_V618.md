# Renekton — sources et consommateurs de Reign of Anger, V618

Date UTC : 2026-10-26T14:19:47.772717+00:00. SYS-01.2-02, F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ;catalogue4.20.1 distinct. Build littéral2014-11-17 à17:46:45,fuseau et déploiement non établis.

## Résultat et portée

Les fiches CH-Renekton-PASSIF-SOURCE, CH-Renekton-PASSIF-SIMULATION-CONTRAT et CH-Renekton-PASSIF-SIMULATION reçoivent59 ressources natives,177 associations,24 points de code et48 liens supplémentaires pour les deux fiches de simulation. Aucun gameplay modifié,aucune tâche clôturée.

Le moteur classe déjà la ressource comme Rage,exclut sa régénération générique et la remet à zéro au respawn. Ces acquis sont préservés. Les essais n'observent ni gain de Fureur après les attaques depuis zéro,ni bonus de gain sous50%PV,ni baisse pendant les attentes à jauge pleine. Le renforcement et la consommation des sorts restent non implémentés dans le chemin inspecté ;les commandes de sorts Renekton sont explicitement refusées.

## Sources natives

59 ressources :18 INIBIN,25 Lua,14 preloads,un DDF,un texte en_GB. Identités/appartenance au manifeste sélectionné vérifiées. Les25 Lua sont entièrement parcourus,sans sous-fonction ;huit limites NEWTABLE :BasicAttack,BasicAttack2,Cleave,CritAttack,Execute,PreExecute,ReignOfTheTyrant,SliceAndDice. Les17 initialisations littérales ne constituent pas une exécution du serveur.

Renekton.inibin lie RenektonPredator et Renekton_Predator.dds. PARType=Rage,BaseMP=100,MPPerLevel=0,BaseStaticMPRegen=0. **PARStart et PARMax absents** :le démarrage à100 dans notre moteur n'est pas une valeur initiale historique qualifiée. Passive1 et Passive1Level1..6 sont absents.

Le BuffData exact de RenektonPredator décrit :

- 5 Fureur par attaque ;
- à50 ou davantage,renforcement des capacités avec dépense50 ;
- perte de5 Fureur toutes les2s hors combat ;
- gains augmentés de50% sous50% des PV.

L'événement exact de gain,les cibles éligibles,le plafond,les arrondis,la frontière exacte50%PV,le délai d'entrée hors combat et le producteur du timer restent à qualifier. Une attente donnée dans notre moteur ne prouve pas la temporisation native.

Deux textes hérités sont conservés séparément :Passive1Desc et game_spell_tooltip_RenektonPredator parlent de dégâts supplémentaires aux cibles sous50%PV. PassLev1Desc2..4 décrivent de la régénération de mana40/60/80%. Ils ne remplacent pas le BuffData de Fureur ni la description du personnage.

CharScript natif à la racine du personnage et CharScript communautaire vides. RenektonPredator.luaobj expose nom,icône,PersistsThroughDeath et NonDispellable ;aucun callback de génération/décroissance n'est qualifié par ces littéraux.

RenektonInCombat.luaobj expose BuffName=**RenekthonPredator** et BuffTextureName=**Corki_RapidReload.dds**. RenektonRageReady expose **RenekthonCleaveReady**,SpellToggleSlot=1. Les noms RenekthonCleaveReady,RenekthonSliceAndDiceDelay,RenekthonTyrantForm sont conservés exactement. Ces graphies et cette icône ne sont ni corrigées silencieusement ni assimilées à une preuve de provider/rendu fonctionnel.

Le preload du personnage cite renektonpredator et apbonusdamagetotowers ;celui du passif cite renektonincombat et renektonrageready. Ce sont des dépendances,pas des producteurs de règles démontrés.

Six BuffData sont résolus :CleaveReady,SliceAndDiceDelay,TyrantForm,ExecuteReady,Predator,SliceAndDiceShred. Pas de doublon de basename ni variante NightmareBot sélectionnée. OdinPlayerBuffRenekton global est hors de la sélection de ce passif normal ;la présence de variantes ne qualifie pas leur application sur Map10.

Renekton.ddf contient12 lignes,dont six non vides :PreExecute f1/f2→attackdamage1.5/2.25 ;SliceAndDice f1/f2→bonusattackdamage0.9/1.35 ;Cleave f1/f2→bonusattackdamage0.8/1.2. Ces liaisons de valeurs QWE ne produisent pas la Fureur et ne qualifient pas,à elles seules,leur application côté serveur.

Cinq chemins candidats absents :CharScript dans Scripts au lieu de la racine,Predator.inibin et Predator.luaobj globaux au lieu du répertoire personnage,Renekton.en_gb.ddf et RenektonRage.inibin. Aucune absence globale d'assets ni corruption déduite.

| Ressource | Identité du registre |
|---|---|
| Renekton.inibin | OLS-5080805b-30a5-55e3-92dc-00477d76cc76 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Renekton.ddf | OLS-c4bff741-86ff-59b0-88fc-872fdc7e12d6 |
| CharScriptRenekton.luaobj | OLS-abbf7ce4-04d9-5f31-8479-8b7fd5809f00 |
| CharScriptRenekton.preload | OLS-9a9936f5-828d-539a-8cf1-3a86f8d241a0 |
| RenekthonCleaveReady.inibin | OLS-0657b029-3965-5da5-8574-12f08a1a7f0b |
| RenekthonSliceAndDiceDelay.inibin | OLS-65150f2a-c662-56a7-90c8-f61596bf0f87 |
| RenekthonTyrantForm.inibin | OLS-c8fd8e1e-d1a4-5b1e-beb0-38dd4ab2ae3e |
| RenektonBasicAttack.inibin | OLS-7ed5f1eb-d5ce-5c5e-b5e8-16f7e0d8822a |
| RenektonBasicAttack.luaobj | OLS-c0f6e407-e4e1-5dae-94a6-cb30a5fcc1ee |
| RenektonBasicAttack2.inibin | OLS-509fe3cc-baa7-5201-8ea9-0c7965e9ebde |
| RenektonBasicAttack2.luaobj | OLS-20114827-d514-5cc6-9510-5a4bc4fcc66d |
| RenektonBloodSplatterTarget.luaobj | OLS-b1589170-6e9f-588b-8bce-a64cf18183de |
| RenektonBloodSplatterTarget.preload | OLS-51bbb7a6-775f-51c9-bc0a-4f5132d42c1b |
| RenektonCleave.inibin | OLS-9389ff79-1d00-57b0-ae38-46d080662e86 |
| RenektonCleave.luaobj | OLS-e6e27d9c-dced-5829-b7dd-86913fd3828d |
| RenektonCleave.preload | OLS-f5647cf9-31e9-56f0-b2c1-08072cf50ae4 |
| RenektonCleaveDrain.luaobj | OLS-a762bb78-14e0-5a78-b1b1-e1287edffba0 |
| RenektonCritAttack.inibin | OLS-e32579a5-4fe8-5132-99b2-07beeef10328 |
| RenektonCritAttack.luaobj | OLS-d38f462a-4f7b-5d07-9f76-ce30bd0598be |
| RenektonDice.inibin | OLS-b50c0e97-01a8-5aee-be2a-90ce2d92b942 |
| RenektonDice.luaobj | OLS-ad141d6b-1310-5e89-8c78-95ea586a9c1d |
| RenektonDice.preload | OLS-2ac397a5-ab9d-58a9-aed1-a9ad900756e4 |
| RenektonExecute.inibin | OLS-840122e8-09c8-5487-9b88-b5effaf5bf75 |
| RenektonExecute.luaobj | OLS-eb2e249d-e2dd-5cd2-be28-1c0204922104 |
| RenektonExecute.preload | OLS-a3863578-f79f-5be9-90dd-39c5d4828348 |
| RenektonExecuteAttack.inibin | OLS-c15c8a94-7ae3-58dc-a231-aa17c7ee66e3 |
| RenektonExecuteAttack.luaobj | OLS-a021c43d-c058-54c2-814c-4c0715b68232 |
| RenektonExecuteAttack.preload | OLS-e4093219-c520-5fd2-99b9-13b58dfc8add |
| RenektonExecuteReady.inibin | OLS-726292b6-1214-5f0b-a2e4-425a6089e5a5 |
| RenektonInCombat.luaobj | OLS-9a585bc5-ae1e-5caa-abc1-4d06bf88ea18 |
| RenektonPredator.inibin | OLS-a6371db6-6c06-5801-ada9-a9730834e4bf |
| RenektonPredator.luaobj | OLS-6c8ebc20-aeed-5610-9dc5-b8682cbc48eb |
| RenektonPredator.preload | OLS-16341823-0488-5c13-bef5-9c49dfbdecd6 |
| RenektonPreExecute.inibin | OLS-3d024176-3013-56ed-b138-d22fc2adcffe |
| RenektonPreExecute.luaobj | OLS-3cc2ca50-7939-564e-8d4a-84dfad1a0c8e |
| RenektonPreExecute.preload | OLS-990ba866-8d71-50fe-af92-3689d2f6ed29 |
| RenektonRageReady.luaobj | OLS-8dea6aa0-d4d1-598d-8c1e-79208df0c254 |
| RenektonRageReady.preload | OLS-9d846e4e-5221-5fd3-b9b5-db344970ecc5 |
| RenektonReignOfTheTyrant.inibin | OLS-8228350c-d2b6-52b4-8ddc-3f722551f700 |
| RenektonReignOfTheTyrant.luaobj | OLS-78d4e05d-dc92-5370-b43b-956b110fd7df |
| RenektonReignOfTheTyrant.preload | OLS-6dcb74d4-6f54-59e6-ad5f-ea00c0d173c6 |
| RenektonSliceAndDice.inibin | OLS-b23b7bfe-4be0-5c21-943a-fca21ea921cb |
| RenektonSliceAndDice.luaobj | OLS-bd654c4d-41d8-564c-bf94-fbc7c1e8a44f |
| RenektonSliceAndDice.preload | OLS-54ae2194-c4bd-5b5c-bb39-94f982e16aef |
| RenektonSliceAndDiceDebuff.luaobj | OLS-923be9d5-9669-5a13-a633-7ff553eb951c |
| RenektonSliceAndDiceDelay.luaobj | OLS-e4ebf16d-a679-53f1-b542-ac994bc036d2 |
| RenektonSliceAndDiceDelay.preload | OLS-6c376715-ceb4-5234-915c-0c894d42941a |
| RenektonSliceAndDiceShred.inibin | OLS-533019a8-cf2e-53f1-b6c4-910da8f96d52 |
| RenektonSliceAndDiceTimer.luaobj | OLS-9772b8c4-c86e-5ab8-85ef-6c9506f2fe46 |
| RenektonSuperExecute.inibin | OLS-dd350c5a-5b9e-5ce2-9b30-fb2b312d18b7 |
| RenektonSuperExecute.luaobj | OLS-2c7ae156-33d3-54cc-afce-ee51add04063 |
| RenektonSuperExecute.preload | OLS-0cc331e0-9c23-54e2-adaf-d14eefe9384f |
| RenektonTargetSliced.luaobj | OLS-1983944c-eacf-5d8a-aff8-aa5f69572b05 |
| RenektonUnlockAnimation.luaobj | OLS-9ef0a28e-0273-50f0-ab97-f3f3ee83484e |
| RenektonUnlockAnimationAttack.luaobj | OLS-5ceb5a8d-6071-5592-8eed-db32322270e0 |
| RenektonUnlockAnimationCleave.luaobj | OLS-6c83fb2a-f846-52d1-b57e-97870bd55829 |
| RenektonWeaponGlowFade.luaobj | OLS-c9d44b6c-2109-5a50-a244-a368b23eb5d6 |
| RenektonWeaponGlowFade.preload | OLS-3660eb71-a1e1-5207-9600-2f2980d3b597 |

## Sorts liés et références communautaires

23 références présentes,séparées de l'autorité historique et des consommateurs Rust.

Le Q natif décrit dégâts bonusAD,soin proportionnel aux dégâts avec différence champions et plafonds,version renforcée à50Fureur. Le fichier communautaire utilise0.8AD total et soins fixes5/15 par cible. Il ne qualifie ni les plafonds natifs ni la version renforcée.

Le W natif est lié par Spell2 à **RenektonPreExecute** :prochaine attaque double,triple renforcée,on-hit à chaque frappe,stun0.75/1.5s. Le fichier W communautaire définit une classe **RenektonPredator**,nom également employé par le passif natif,et applique immédiatement30×rang+0.75AD total avec stun0.75s. Cette collision de noms ne démontre pas le binding du sort ni son contrat natif.

Le E natif est un dash ;un ennemi touché autorise Dice pendant4s. Le renforcement concerne Dice et réduit l'armure4s. Le fichier communautaire sélectionne un cône par produit scalaire et inflige des dégâts avec0.9AD total ;aucun SetPosition,recast ou branche Fureur n'y est qualifié.

Le R natif est **RenektonReignOfTheTyrant**,15s,PV bonus,dégâts de proximité et5Fureur/s. Le fichier communautaire définit **RenektonDominus**. Son code calcule100+200×rang+0.1AP puis divise en15impulsions,soit300/500/700 avant AP,alors que son commentaire annonce d'autres totaux. Les commentaires ne remplacent pas le code,ni le code communautaire le natif. Aucun gain de Fureur n'est présent dans ce fichier.

Les quatre fichiers QWER lus ne contiennent aucune gestion de Fureur/CurrentMana. Cela ne prouve pas une absence dans tout le projet communautaire ;leur intégration comme règles complètes ou consommateurs Rust n'est pas acceptée ici.

## Diagnostic du moteur courant

Véritable cœur Rust compilé hors configuration test,offline/locked,dépendances alignées sur Cargo.lock. BUILD0,RUN0,collecte0,inspection0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-renekton-passive-reign-of-anger-probe.exe` ;6095872 octets ;SHA256 `19b9b86aa8e3dfb8b95c4938510e0f07e4f40a5aa0f4f8a3344a09a9c58d716a`.

Deux parties publiques niveau1 :sans objet et Saphir1027(+200mana). Aucun changement direct de position,PV,ressource,rang ou dégâts. Le Saphir ne modifie pas le maximum de Rage100,conformément au filtrage actuel des objets de mana.

Déroulement par partie :

1. Join avec jauge100,puis deux trajets publics au centre.
2. Trois attaques mêlée à jauge pleine,puis301ticks d'attente :jauge toujours100. Le gain par attaque au plafond n'est pas qualifié par cette phase.
3. Mort provoquée par16attaques publiques d'Annie,puis respawn après480ticks :jauge0.
4. Retour public au centre,trois attaques depuis0,puis301ticks :jauge toujours0.
5. Neuf impacts entrants pour descendre sous45%PV,trois nouvelles attaques en restant sous50%PV :jauge toujours0.

Total :18attaques mêlée,12depuis zéro dont6sous50%PV,50impacts physiques entrants,deux morts,deux respawns,1204ticks d'attente,54refus et six trajets réussis sans réémission. Aucun sort Renekton accepté,aucun Q Annie utilisé. Les champions restent niveau1 ;pas de contrôle,bouclier ou vainqueur. Les dégâts entrants létaux sont vérifiés avec plafonnement aux PV disponibles et régénération séparée.

| Cas | Maximum courant | Join | Respawn | Attaques depuis0 | Dont sous50%PV | Jauge finale | Refus |
|---|---:|---:|---:|---:|---:|---:|---:|
| base | 100.0 | 100 | 0 | 6 | 3 | 0.0 | 27 |
| Sapphire200Mana | 100.0 | 100 | 0 | 6 | 3 | 0.0 | 27 |

AD courant58,327999115 ;tous les impacts sortants observés48,924682617 correspondent aux dégâts physiques génériques. Les attaques blessées commencent à233,39587/235,78403/238,17218PV sur572,15997PVmax,toutes sous50%,sans gain de ressource.

Le texte natif décrit un gain après attaque et une augmentation à faiblesPV ;le moteur n'en produit aucun depuis zéro. Pour la décroissance,les observations à100 restent distinctes de la qualification du délai natif hors combat :ce délai et ses événements d'entretien ne sont pas établis par les301ticks.

Les refus sont vérifiés à ressource100 et0 :apprentissage/lancement ciblé/au sol QWER non supportés ;acteur inconnu,attaque de soi et slot invalide. Snapshots inchangés. Les seuils49/50/51 et la dépense atomique ne sont pas qualifiés,puisque les capacités restent refusées.

## Acquis et consommateurs réels

Le seul résultat lexical Renekton dans crates/core/src est un test générique de régénération. La lecture des consommateurs confirme des comportements génériques réels :

- join initialise le champ nommé mana à partir du catalogue,100 pour Renekton ;
- champion_resources.json le classe Rage ;
- uses_mana filtre les bonus de mana,restores_resource exclut Rage de la restauration automatique ;
- advance_respawns remet cette ressource à0 ;
- attaques et régénération ne contiennent pas de producteur de gain/décroissance Renekton identifié.

Ces acquis partiels ne sont pas présentés comme absents,ni comme le passif terminé. Le reset actuel au respawn n'est pas une qualification complète du lifecycle natif. Sept ressources locales liées :catalogue,croissance,ressources,attaques,critiques,collision,boutique ;1158 entrées du diagnostic identifiées et hachées.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | current initial resource100,distinct from respawn0 |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | ordinary maximum100,not Fury generation |
| crates/core/src/progression.rs:150 | unsupported Renekton learning |
| crates/core/src/progression.rs:159 | unsupported Renekton ranks |
| crates/core/src/spells.rs:101 | unsupported targeted spell |
| crates/core/src/annie_w.rs:29 | unsupported ground spell |
| crates/core/src/lib.rs:685 | 18outgoing50incoming,1204idle,death/respawn |
| crates/core/src/lib.rs:744 | state witnesses,not network acceptance |
| crates/core/src/damage.rs:53 | generic damage,not passive stat conversion |
| crates/core/src/attacks.rs:157 | 18melee impacts,12fromzero incl6below50percentHP |
| crates/core/src/lifesteal.rs:4 | ordinary physical hit,no Fury gain observed |
| crates/core/src/regeneration.rs:32 | Rage generic regeneration excluded,not native decay timer |
| crates/core/src/regeneration.rs:10 | per-tick damage correction |
| crates/core/src/shop.rs:261 | public Sapphire1027 purchase |
| crates/core/src/shop.rs:215 | mana item filtered for Rage in stats |
| crates/core/src/world.rs:226 | one enemy champion;other target types unexercised |
| crates/core/src/damage.rs:38 | ordinary incoming damage and public death,not Fury rule |
| crates/core/src/attacks.rs:26 | melee hit witness |
| crates/core/src/lifecycle.rs:16 | Sapphire does not increase Rage maximum |
| crates/core/src/lifecycle.rs:24 | Rage excluded from generic resource restoration;existing partial behavior |
| crates/core/src/lifecycle.rs:33 | two public deaths/respawns,Rage reset0 |
| crates/core/src/ally_occupancy.rs:635 | six preparation travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564 remains open |

## Publication et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_sources_4_20.json,docs/fidelity_requirement_trace_4_20.json. Reçu :docs/reference_requirement_trace_sources/renekton-passive-reign-of-anger-links-v618.json. Preuve :docs/fidelity_renekton_passive_reign_of_anger_links_v618.json. Instructions copiables des trois fiches et de SYS-01.2-02 actualisées.

PREPARE/CHECK/PUBLISH/AUDIT0. 72 associations altérées et quatre graphes invalides refusés. Trois fragments de traçabilité changés,42212 identiques. Deux bases :quatre destinataires,42603 autres lignes,42607 états manuels,23 historiques conservés ;synchronisation idempotente. Identifiants,hiérarchie et inconnues inchangés octet par octet. Trois questions propres et quatre dépendances conservées.

Revue globale99149sources/4486consommateurs,4486ancres exactes sans divergence. Contrôle structurel global (source_hashes_verified=0),distinct des hashes sélectionnés ;pas de recontrôle exhaustif de toutes les sources revendiqué.

Un contrôle du générateur d'inspection a détecté un libellé résiduel relatif au Tissu avant d'écrire l'inspecteur ;générateur initial1,puis copie refusée faute de fichier. La variante de génération corrige le rôle avant toute inspection,qui passe ensuite0. Le premier générateur de finalisation s'est arrêté avant écriture sur le nom d'encodage invalide utf8-sig ;la variante utf-8-sig passe. Une commande PowerShell de préparation du rapport a été refusée au parsing sur une apostrophe ;la correction est appliquée au fichier par patch. Les générateurs initiaux sont conservés ;aucune mutation de source native ou de jeu. Ces incidents sont distincts du diagnostic Rust réussi.

coverage.json,completion_plan.json,resume_checkpoint.json,CURRENT.md,HANDOFF.md actualisés avec conservation des preuves précédentes. Aucun stage/reset/commit/nettoyage. Les112 questions antérieures de priorité de configuration Renekton ne sont pas résolues par cet audit du passif ;Battle Training,V564,V606 restent ouverts.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :revision618_Renekton_discovery/OBSERVATIONS.json,revision618_Renekton_passive_probe/OBSERVATIONS.json,revision618_Renekton_inspection/OBSERVATIONS.json,revision618_Renekton/DELIVERY_AUDIT.json et revision619_trace_review/REVIEW.json.

## Travail restant

1. Qualifier la valeur initiale native,le plafond et le traitement de la ressource au lifecycle.
2. Relier le gain par attaque à son événement exact,cibles,annulations et attaques multiples.
3. Qualifier le bonus sous50%PV,égalité du seuil et arrondis.
4. Qualifier l'état combat,le délai avant perte,la cadence et les événements qui l'entretiennent.
5. Implémenter gains/décroissance dans le consommateur courant en conservant les acquis Rage.
6. Implémenter seuil et consommation atomique50,versions normales/renforcées QWE,gains de R.
7. Tester49/50/51,cap,gain/dépense simultanés,sorts refusés,mort/respawn et plusieurs Renekton.
8. Qualifier HUD,icône,glow,animations,audio et réseau séparément.

Pas de serveur historique,rendu,audio ou transport réseau qualifié ici. Goal actif.

Suite : Continuer SYS-01.2-02 depuis revision619_trace_review/REVIEW.json. V618 Renekton / Reign of Anger :59 sources natives,177 associations,24 points et48 liens. BuffData natif :5 Fureur par attaque,renforcement à50 avec dépense50,perte5 toutes les2s hors combat,+50% de gains sous50%PV. Deux cas publics base/Saphir1027+200mana :18attaques mêlée dont12 depuis zéro et6 sous50%PV,50impacts physiques entrants,deux morts/deux respawns,1204ticks d’attente et54 refus. Jauge initiale100,respawn0 ;les attaques depuis zéro restent à0,y compris blessé ;attentes301ticks sans baisse depuis100. Saphir ne change pas le maximum100. Aucun sort Renekton accepté. Acquis génériques Rage,absence de régénération et reset au respawn conservés ;valeur initiale native et temporisation hors combat non qualifiées. BUILD/RUN/inspection0. Préparation initiale de l’inspecteur arrêtée avant exécution pour libellé résiduel,version corrigée conservée. 25Lua dont8limites NEWTABLE,14preloads,six BuffData résolus,douze lignes DDF dont six liaisons AD QWE. CharScripts natif/communautaire vides ;ancien texte bonus dégâts sous50%PV et régénération mana non adoptés. Renekthon et icône Corki_RapidReload.dds conservés sans acceptation du provider ou du rendu. 23références communautaires :Q ADtotal/soins fixes,W attaque immédiate,E cône sans dash,R dégâts/commentaire divergents ;aucune gestion de Fureur dans les quatre fichiers lus. Cinq candidats absents ne prouvent pas un manque global d’assets. Six trajets réussis ;V564/V606 et112priorités Renekton antérieures conservés. Aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Rengar. Goal actif.
