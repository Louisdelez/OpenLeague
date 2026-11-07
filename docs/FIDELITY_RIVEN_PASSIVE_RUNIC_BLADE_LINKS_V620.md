# Riven — sources et consommateurs de Runic Blade, V620

Date UTC : 2026-10-26T14:59:12.730131+00:00. Tâche SYS-01.2-02, projet F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Build littéral du 2014-11-17 à 17:46:45 ; fuseau et date de déploiement non établis.

## Résultat et portée

Les trois fiches CH-Riven-PASSIF-SOURCE, CH-Riven-PASSIF-SIMULATION-CONTRAT et CH-Riven-PASSIF-SIMULATION reçoivent 66 sources natives, 198 associations, 26 points de code et 52 liens supplémentaires pour les deux fiches de simulation. SYS-01.2-02 reçoit le reçu et la synthèse. Aucun gameplay n'est modifié ; les statuts restent ouverts.

Le texte natif décrit des capacités qui chargent la lame, un maximum de trois charges et une charge consommée par attaque, avec des dégâts physiques supplémentaires. Le montant numérique, sa progression et les délais ne sont pas qualifiés par les sources inspectées. L'apprentissage et les lancements de sorts Riven sont refusés dans le moteur actuel : les attaques ordinaires observées ne constituent pas un test nominal de passif chargé.

## Sources natives

Les 66 ressources comprennent 19 INIBIN, 28 Lua, 17 preloads, un DDF et le texte en_GB. Taille, SHA et appartenance au manifeste RADS sélectionné sont vérifiés. Aucun doublon de basename ni variante NightmareBot n'est sélectionné.

Riven.inibin indique PARType=None, BaseMP=0, Passive1LuaName=RivenPassive, icône RivenRunicBlades.dds, attaque mêlée de portée 125, AD 56.0400009155 et vitesse 345. Passive1 et Passive1Desc sont absents. Les niveaux renseignés sont 1/4/7 ; les autres champs lus sont absents. Ces trois niveaux ne sont pas adoptés comme une progression complète du bonus. La ressource mana n'est pas le compteur de charges du passif.

Six bindings BuffData sont résolus exactement : Feint, FengShuiEngine, Passive, PassiveAABoost, TriCleaveBuff et WindScarReady. La description du personnage donne explicitement le maximum de trois charges. Le BuffData du passif utilise f1 pour le pourcentage, f2 pour le bonus affiché et f3 pour le maximum ; les producteurs de f1/f2 ne sont pas établis. Le texte AABoost décrit le bonus sur la prochaine attaque, sans fournir son montant ou ses délais.

Les 28 Lua sont entièrement parcourus, sans sous-fonction. Huit limites NEWTABLE empêchent la qualification complète de leur initialisation : Feint, IzunaBlade, Martyr, PassiveAABoost, QLockout, TriCleaveBufferLock, TriCleaveDamageDebuff et TriCleaveDamageDebuff2. Les 20 initialisations littérales restantes ne sont pas une exécution du serveur historique.

CharScriptRiven.luaobj est vide. RivenPassive.luaobj expose BuffName=RivenPassive, PersistsThroughDeath=true et NonDispellable=true. La persistance de la définition ne prouve pas la conservation des charges à la mort. RivenPassiveAABoost contient les constantes AutoCooldownByLevel et 22/18/14/10/6 ; la limite NEWTABLE est conservée et ces valeurs ne deviennent ni durée de charge ni progression de dégâts.

Le preload du personnage cite apbonusdamagetotowers, rivenpassive et rivenqlockout. Celui du passif cite rivenmartyr et rivenpassiveaaboost. Le preload prouve une dépendance déclarée, pas un callback effectif, un rendu ou un son.

Des métadonnées héritées sont conservées : cinq Lua Sword/Buffer/Buffered/Ghost utilisent RenekthonCleaveReady et AkaliCrescentSlash.dds ; trois variantes Lightsaber utilisent EzrealEssenceFluxDebuff, Ezreal_EssenceFlux.dds et GLOBAL_SLOW.troy. Knockback emploie Minotaur_TriumphantRoar.dds. Ces noms ne sont pas adoptés comme règles Riven. WindSlashReady.luaobj et WindScarReady.inibin restent deux identités distinctes, sans renommage implicite.

Riven.ddf contient 16 lignes, dont six non vides :

| Liaison | Champ | Coefficient |
|---|---|---|
| TriCleave f1 | attackdamage | 0.4/0.45/0.5/0.55/0.6 |
| Martyr f1 | bonusattackdamage | 1.0 |
| Feint f1 | bonusattackdamage | 1.0 |
| FengShuiEngine f1 | bonusattackdamage | 0.6 |
| FengShuiEngine f2 | bonusattackdamage | 1.8 |
| FengShuiEngine f3 | bonusattackdamage | 0.2 |

Les dix autres lignes sont vides. Aucune ligne ne résout le bonus du passif. Le binding f3 de R et sa relation à l'augmentation d'AD restent à qualifier au consommateur historique ; le choix communautaire de l'AD de base n'est pas accepté par défaut.

Quatre chemins candidats sont absents : CharScript dans Scripts, RivenPassive.luaobj dans DATA/Spells, Riven.en_gb.ddf et RivenRunicBlade.inibin. Les ressources correspondantes réellement présentes sous Characters/Riven sont recensées. Ces absences de chemins alternatifs ne prouvent pas un manque global de fichiers.

| Ressource sélectionnée | Identité du registre |
|---|---|
| Riven.inibin | OLS-2aabafc7-d647-5406-95b7-0f6cd5dd3ce4 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Riven.ddf | OLS-2147a034-d0bf-5fbe-901c-510ca63509dd |
| CharScriptRiven.luaobj | OLS-3fe5d3dd-b459-50ff-b96b-e8bc1863a9b2 |
| CharScriptRiven.preload | OLS-63c274d1-6d5d-5d83-bdcc-7896b62d0aca |
| RivenBasicAttack.inibin | OLS-48868316-8213-5c39-9e57-3b2f7ed5da94 |
| RivenBasicAttack2.inibin | OLS-2ff4f601-2663-51db-864b-ff72abe3a2f8 |
| RivenBasicAttack3.inibin | OLS-c645c793-42fd-5e6e-8187-d2e89aa1beb8 |
| RivenCritAttack.inibin | OLS-e3b4db84-ca74-5531-bd97-f0240981cb85 |
| RivenFeint.inibin | OLS-4b690251-72ef-5fef-a801-ecb89eece354 |
| RivenFeint.luaobj | OLS-c9fe00d8-874c-558f-9600-d538db402967 |
| RivenFeint.preload | OLS-d6af71e4-af04-5477-82ab-1f3927c323da |
| RivenFengShuiEngine.inibin | OLS-8f0d28d5-3652-5ba5-876a-89166e518384 |
| RivenFengShuiEngine.luaobj | OLS-0e0faf71-4880-54b0-ba3f-3e5e1a0b1b21 |
| RivenFengShuiEngine.preload | OLS-f065fa13-a02b-5fb7-a6d0-e740aca4e4e7 |
| RivenIzunaBlade.inibin | OLS-37677bb9-fe11-5c84-8c66-3e8eb5361e45 |
| RivenIzunaBlade.luaobj | OLS-72b2937d-240f-5697-8eac-023e33a755fb |
| RivenKnockback.luaobj | OLS-ef671149-7568-5c37-a95d-3571d980efb3 |
| RivenLightsaberMissile.inibin | OLS-8e26674c-45ea-5a30-a0c9-75334284b7f4 |
| RivenLightsaberMissile.luaobj | OLS-d23a8ceb-8dec-5b1c-a9eb-cef5a2b68a92 |
| RivenLightsaberMissile.preload | OLS-f67573a7-f786-5118-b937-f0e53bf78883 |
| RivenLightsaberMissileDebuff.luaobj | OLS-5b744d66-4c94-5105-82cb-05cc336931ae |
| RivenLightsaberMissileDebuff.preload | OLS-e89221a6-fcb6-5a92-824e-7efdacb0f5a7 |
| RivenLightsaberMissileSide.inibin | OLS-c65813db-360a-50c3-ab29-e91c74fbcfb1 |
| RivenLightsaberMissileSide.luaobj | OLS-16a18a4b-bb25-58ab-b0ac-01ce316e16ca |
| RivenLightsaberMissileSide.preload | OLS-68f92e96-294f-5703-87e8-e5e5b73c99e1 |
| RivenMartyr.inibin | OLS-ea154716-a023-5e96-a959-69a7f11829b1 |
| RivenMartyr.luaobj | OLS-0b7aa821-0342-5290-bb5e-fb38f655228d |
| RivenMartyr.preload | OLS-f0fd70e0-eea0-55bc-9dee-deaba3941f31 |
| RivenPassive.inibin | OLS-d8c3d128-e02f-561b-83ba-a06f11bf6468 |
| RivenPassive.luaobj | OLS-b9a99894-9d0a-568f-baba-b4ef2e4b5a10 |
| RivenPassive.preload | OLS-3808d8d3-49a4-510f-8922-0e1b7bfecd83 |
| RivenPassiveAABoost.inibin | OLS-06ae7e68-f2eb-59bf-9f04-52d7454efa57 |
| RivenPassiveAABoost.luaobj | OLS-8ee5cf00-f7fa-5cab-81ca-b34cca8c6379 |
| RivenQLockout.luaobj | OLS-6aaeae9e-576d-548c-b27c-fc5749960952 |
| RivenSword.luaobj | OLS-466b0ee6-b356-54a7-86a4-a0349f716a71 |
| RivenSword.preload | OLS-23054f8c-1826-58a3-b370-24383bfd5fa3 |
| RivenTriCleave.inibin | OLS-bc249531-1c80-5252-ab5a-d97bb455dc68 |
| RivenTriCleave.luaobj | OLS-93f33830-c70d-5cad-908b-3832750b7286 |
| RivenTriCleave.preload | OLS-08e4876e-72a2-5620-8839-6858fdf96b16 |
| RivenTriCleaveBuff.inibin | OLS-e0591833-4082-548d-b7bf-9fbdc21366f4 |
| RivenTriCleaveBuffer.inibin | OLS-bdbb2ad4-9865-5aef-a1f4-be3312835771 |
| RivenTriCleaveBuffer.luaobj | OLS-01ebb710-3682-5e22-9efd-b8a081113022 |
| RivenTriCleaveBuffer.preload | OLS-8deec97b-3e8f-5588-bdc9-d3df4e3c7d41 |
| RivenTriCleaveBufferB.inibin | OLS-7ba0fd19-6c75-5d7f-8803-d2c46af633a8 |
| RivenTriCleaveBufferB.luaobj | OLS-a8f55138-fe93-569e-a777-b279e22dab2d |
| RivenTriCleaveBufferB.preload | OLS-c09431d2-a4dc-57f3-a265-5703369a5f80 |
| RivenTriCleaveBuffered.luaobj | OLS-3c82bf66-aba2-5908-ade1-335cd0cfbae3 |
| RivenTriCleaveBufferLock.luaobj | OLS-18cd9262-9d89-52c0-94ac-1ba76c4d8cb4 |
| RivenTriCleaveCooldown.luaobj | OLS-fdddee15-8c04-5418-ba06-6b80946b831a |
| RivenTriCleaveCooldown.preload | OLS-bade7083-c8d1-5873-acf8-6fcfd68be6f3 |
| RivenTriCleaveDamage.inibin | OLS-0f0b3c5d-0f68-5cc7-88ac-eff28bfa4cbe |
| RivenTriCleaveDamage.luaobj | OLS-cb73fe6b-b64b-5903-b0cf-dc7604e2ea72 |
| RivenTriCleaveDamage.preload | OLS-e92c0965-baff-5a7a-8471-58d81ed7b164 |
| RivenTriCleaveDamageDebuff.luaobj | OLS-db289fda-0953-5de3-9a73-47bc018c88ae |
| RivenTriCleaveDamageDebuff.preload | OLS-21897cb1-a29e-5557-8be4-cfb2530e24eb |
| RivenTriCleaveDamageDebuff2.luaobj | OLS-a5135d4f-bc8a-5775-972a-2f9d6622e7e2 |
| RivenTriCleaveDamageDebuff2.preload | OLS-c2d2429a-e29b-5207-b15c-12003c9d86a1 |
| RivenTriCleaveGhost.luaobj | OLS-706c045a-4d14-5436-bda7-ea650d4a3b33 |
| RivenTriCleaveSoundOne.luaobj | OLS-cfd7fc96-2b80-5e55-973e-6157cacf03af |
| RivenTriCleaveSoundThree.luaobj | OLS-0adb0b23-ad0f-5c4e-a2a6-a2066a8a63f7 |
| RivenTriCleaveSoundTwo.luaobj | OLS-8bde1276-4588-5165-a35c-0e1461a9926e |
| RivenTriCleaveUnlock.luaobj | OLS-775f0741-002c-584c-8a6f-ea749b0bc6f4 |
| RivenTriCleaveUnlock.preload | OLS-a88397ee-b077-5eee-8483-41c8d61c6537 |
| RivenWindScarReady.inibin | OLS-df92806d-0c1a-5323-9653-662be3363dd0 |
| RivenWindSlashReady.luaobj | OLS-4d86f2a8-34ab-5e36-947a-20789611bf28 |

## Références communautaires

Les 24 références sont présentes et identifiées séparément de l'autorité native et du moteur Rust. CharScriptRiven.cs est vide. Les quatre fichiers Q/W/E/R lus ne référencent ni RivenPassive ni Runic ; cela ne prouve pas l'absence de logique dans tous les autres fichiers communautaires.

- Q : dégâts de cône à 260 unités, -10+20×rang+0.6 bonusAD. Le fichier ne qualifie pas le déplacement, les trois usages, le troisième knockup ou les charges. Son commentaire « dash » n'est pas une preuve de déplacement. Le DDF natif lie le ratio variable à l'AD total.
- W : 20+30×rang+0.8 bonusAD et stun 0.75 s. Le DDF natif indique bonusAD×1 ; la présence du stun communautaire ne qualifie pas le sort entier ou les charges.
- E : délégation à RivenShield pendant 2.5 s et particule ; aucun déplacement dans le fichier. Le texte natif décrit un dash et un bouclier de 1.5 s. La valeur du commentaire n'est pas le producteur effectif du bouclier délégué.
- R : ajout de 20 % d'AD de base pendant 15 s, puis Wind Slash immédiatement au lancement si la direction est suffisamment éloignée. Le natif décrit une disponibilité distincte et unique de Wind Slash ainsi qu'une augmentation de portée. Les effets de portée, recast et charges ne sont pas qualifiés par ce fichier.

Aucun script communautaire n'est exécuté comme serveur original ou accepté comme consommateur Rust dans cette livraison.

## Diagnostic du moteur actuel

Le véritable cœur Rust est compilé hors configuration test, avec dépendances verrouillées et vérifiées contre Cargo.lock, en mode offline. BUILD=0, RUN=0, collecte=0, inspection=0. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-riven-passive-runic-blade-probe.exe` ; 6075904 octets ; SHA256 `c0729e20f5f1d3b8968e2cf82776d18ed28c115f259f78e7fcf72392e23b84b7`.

Deux parties publiques Map10, Riven et Annie niveau 1 : base et Épée longue 1036 (+10 AD). Quatre trajets réussis sans réémission. Aucun téléport, injection de PV, de rang, de dégâts ou de charges ; aucun sort Annie ni dégât entrant. Achat, vente et rachat utilisent les commandes publiques et restaurent l'AD attendu.

Chaque cas comporte trois attaques après des refus de sorts, une attente de 181 ticks, de nouveaux refus, puis trois attaques supplémentaires. Total : 12 impacts mêlée, 54 refus et 362 ticks d'attente. Les refus couvrent acteur inconnu, attaque de soi, slot invalide, apprentissage et deux formes de lancement QWER. Le snapshot reste identique pour chaque refus.

| Cas | AD | Impacts | Dégâts observés min–max | Refus | Attente |
|---|---:|---:|---|---:|---:|
| base | 56.04000 | 6 | 47.00552–47.00554 | 27 | 181 |
| Sword10AD | 66.04000 | 6 | 55.39339–55.39340 | 27 | 181 |

Les témoins de windup/release, la cadence et les dégâts ordinaires corrigés de régénération sont vérifiés. L'AD fait 56.04 → 66.04 → 56.04 → 66.04 lors de l'achat/vente/rachat. La jauge courante et son maximum restent 0, les rangs et cooldowns Riven restent à zéro. Les joueurs restent vivants au niveau 1, sans bouclier ou contrôle et sans vainqueur.

### Attendu, observé et limite

| Point vérifié | Attendu dans ce diagnostic | Observé | Portée de la preuve |
|---|---|---|---|
| Identité native | SHA et membre RADS exacts | 66 ressources vérifiées | Sources sélectionnées uniquement |
| Texte du passif | Lien exact vers le texte en_GB | Maximum 3, consommation 1/attaque | Aucun ratio ou délai inventé |
| Commandes non supportées | Refus explicite sans mutation | 54 refus et snapshots identiques | Les sorts ne sont pas implémentés par ces refus |
| Attaques sans sort accepté | Dégâts physiques ordinaires | 12 impacts conformes au chemin actuel | Pas de passif chargé exercé |
| Achat/vente | Bonus AD ajouté puis retiré | Retour exact à l'AD initial | Pas de conversion en bonus Runic Blade |
| Attente | Régénération seule après arrêt | 362 ticks contrôlés | 181 ticks ne définissent pas une durée native |
| Préservation | États manuels et historiques identiques | Deux bases contrôlées | Aucune case cochée automatiquement |

Génération, cap effectif, rafraîchissement, consommation, expiration et dégâts renforcés restent non exercés, car aucun sort Riven n'a été accepté. La présence de la règle textuelle ne permet pas de contourner ce prérequis. Pas de qualification de critiques, lifesteal renforcé, sbires/monstres/structures, mort/respawn, niveaux supérieurs, plusieurs Riven, rendu, audio ou transport réseau.

## Consommateurs réels

La recherche exacte de Riven/Runic Blade ne trouve aucune occurrence dans crates/core/src. Les occurrences de « driven » d'une recherche initiale par sous-chaîne sont hors sujet ; la recherche finale emploie une frontière de mot. Cette recherche est complétée par la lecture des états Effects et des chemins réels de classement, lancement, attaque, dégâts, statistiques, ressource et déplacement.

Sept entrées locales sont liées : catalogue, croissance, ressource, attaques, critiques, collision et boutique. Les 1158 entrées du diagnostic sont identifiées et hachées ; la classification générique None/0 est conservée, sans la confondre avec un compteur de charges.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | current resource0 and initial state |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | ordinary AD56.04/66.04,not charged bonus |
| crates/core/src/progression.rs:150 | unsupported Riven learning |
| crates/core/src/progression.rs:159 | unsupported Riven ranks |
| crates/core/src/spells.rs:101 | unsupported targeted spell |
| crates/core/src/annie_w.rs:29 | unsupported ground spell |
| crates/core/src/lib.rs:685 | 12 ordinary attacks and362idle |
| crates/core/src/lib.rs:744 | state witnesses,not network acceptance |
| crates/core/src/damage.rs:53 | ordinary damage,not RunicBlade bonus |
| crates/core/src/attacks.rs:157 | six ordinary melee impacts per case |
| crates/core/src/lifesteal.rs:4 | physical hit without passive charge consumption |
| crates/core/src/regeneration.rs:32 | generic health regen,no resource |
| crates/core/src/regeneration.rs:10 | per-tick damage correction |
| crates/core/src/shop.rs:261 | public Sword purchase |
| crates/core/src/shop.rs:294 | public sale restores ordinary AD |
| crates/core/src/shop.rs:215 | ordinary Sword AD bonus |
| crates/core/src/world.rs:226 | one enemy champion;other types unexercised |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | melee release witnesses |
| crates/core/src/lifecycle.rs:16 | generic None resource classification |
| crates/core/src/lifecycle.rs:24 | None excluded;not passive charge state |
| crates/core/src/ally_occupancy.rs:635 | four public preparation travels |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564/V606 remain open |
| crates/core/src/spells.rs:5 | current effect states inspected,no Riven charge state |
| crates/core/src/progression.rs:40 | ordinary AD components,not native passive bonus |

## Publication et conservation

Fichiers de registre modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu : docs/reference_requirement_trace_sources/riven-passive-runic-blade-links-v620.json. Preuve : docs/fidelity_riven_passive_runic_blade_links_v620.json. Instructions copiables actualisées pour les trois fiches Riven et SYS-01.2-02.

PREPARE/CHECK/PUBLISH/AUDIT=0. Les contrôles refusent 72 associations altérées et quatre graphes invalides. Trois fragments de traçabilité changent, 42212 restent identiques. Dans chacune des deux bases, quatre destinataires sont actualisés ; les 42603 autres lignes, 42607 états manuels et 23 historiques sont conservés. Synchronisation idempotente vérifiée. Identifiants, hiérarchie et registre des inconnues restent identiques octet par octet. Trois questions propres et quatre dépendances restent ouvertes/conservées.

Revue globale : 99157 sources, 4540 consommateurs, 4540 ancres exactes sans divergence. Cette revue est structurelle (source_hashes_verified=0), distincte des SHA vérifiés sur les sources sélectionnées ; elle ne revendique pas un recontrôle exhaustif de toutes les ressources.

Un premier générateur d'inspection a échoué à l'analyse Python à cause d'une parenthèse supplémentaire, avant toute création ou exécution de l'inspecteur. Sa copie corrigée prepare_revision620_riven_inspection_syntax.py est conservée avec l'original. L'inspection effective passe avec code 0 ; aucun échec de compilation ou d'exécution du diagnostic Rust.

coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md et HANDOFF.md sont actualisés, avec sauvegarde et conservation des preuves antérieures. Aucun stage/reset/commit ni nettoyage. Les inconnues Battle Training et les limites V564/V606 restent ouvertes.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision620_Riven_discovery/OBSERVATIONS.json, revision620_Riven_passive_probe/OBSERVATIONS.json, revision620_Riven_inspection/OBSERVATIONS.json, revision620_Riven/DELIVERY_AUDIT.json et revision621_trace_review/REVIEW.json.

## Travail restant pour le passif

1. Identifier le producteur natif du pourcentage et du bonus f1/f2, leur base AD, progression et arrondis.
2. Qualifier durée, rafraîchissement, cap et états initiaux du compteur de charges.
3. Qualifier les événements de gain pour Q1/Q2/Q3, W, E, R1 et R2 ; distinguer casts acceptés, refusés, annulés et recasts.
4. Implémenter le compteur dans l'état autoritaire réellement utilisé par le moteur.
5. Brancher la génération sur les capacités effectivement implémentées et acceptées.
6. Qualifier et implémenter la consommation au bon moment de l'attaque, avec annulation, esquive, cible disparue et perte de vision.
7. Implémenter le bonus de dégâts et qualifier critique, armure, bouclier, vol de vie, on-hit et surdégâts.
8. Vérifier les cibles champions, sbires, monstres et structures selon leur contrat natif.
9. Vérifier niveaux, objets, R actif, simultanéité et plusieurs Riven.
10. Qualifier mort/respawn, départ et reconnexion ; ne pas déduire ces politiques de PersistsThroughDeath seul.
11. Vérifier séparément HUD des charges, animations, VFX, sons et réplication réseau.
12. Relier les nouvelles preuves et garder chaque tâche ouverte jusqu'à validation de ses propres critères.

## Reprise du goal

Continuer SYS-01.2-02 depuis revision621_trace_review/REVIEW.json. V620 Riven / Runic Blade :66 sources natives,198 associations,26 points et52 liens. Texte natif :les capacités chargent la lame,jusqu’à trois charges,une consommée par attaque avec bonus physique ;producteurs f1/f2 et durée non résolus. Deux cas publics niveau1 base/Épée1036+10AD :12attaques ordinaires,54 refus,362ticks d’attente et quatre trajets sans réémission. Achat/vente/rachat :AD56,04/66,04/56,04/66,04 ;dégâts observés47,0055/55,3934. Aucun sort Riven accepté ;génération,consommation,expiration et bonus de charge non exercés. Ressource None/0 distincte du compteur de charges. BUILD/RUN/inspection0. 28Lua dont8limites NEWTABLE,17preloads,six BuffData résolus. CharScripts natif/communautaire vides. Passive.lua nom,persistence et NonDispellable ;AABoost constantes AutoCooldownByLevel22/18/14/10/6 sans politique qualifiée. Champs niveaux1/4/7 non adoptés comme progression complète. Métadonnées Akali/Renekthon,Ezreal et Minotaur conservées sans acceptation sémantique. DDF16lignes,six nonvides QWER :Q ADtotal0,4→0,6 ;W/E bonusAD1 ;R bonusAD0,6/1,8/0,2. Aucun binding passif numérique. 24références communautaires :Q cône sans combo/dash qualifié,W ratio0,8,E délégation2,5s contre texte natif1,5s,R bonusADbase et Wind Slash immédiat. Aucune référence RivenPassive/Runic dans ces quatre fichiers lus,non absence globale. Quatre candidats de chemins absents ne prouvent pas un manque global de ressources. Acquis génériques et limites V564/V606 conservés. Aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Rumble. Goal actif.
