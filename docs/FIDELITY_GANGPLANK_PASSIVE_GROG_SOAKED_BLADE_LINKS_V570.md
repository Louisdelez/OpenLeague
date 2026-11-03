# SYS-01.2-02 — Gangplank : Grog-Soaked Blade, V570

Date UTC 2026-10-26T00:13:07.554528+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral du 2014-11-17 17:46:45, fuseau et date de déploiement inconnus. Catalogue officiel4.20.1 distinct.

## Résultat intégré

Trois fiches enrichies : CH-Gangplank-PASSIF-SOURCE, CH-Gangplank-PASSIF-SIMULATION-CONTRAT et CH-Gangplank-PASSIF-SIMULATION. Le registre contient39 associations vers13 sources natives et56 liens vers28 points de code. SYS-01.2-02 référence ce lot. Trois questions propres et quatre dépendances sont conservées. Les points de code gardent la qualification `entry_boundary_only` et `provides_feature_consumer=false` pour le passif. Aucun gameplay ou asset modifié.

Constat : les attaques publiques produisent leurs dégâts physiques, sans poison ou ralentissement observé. Des mécanismes de ralentissement et dégâts périodiques existent pour d’autres sorts ; les essais positifs Embrasement/Épuisement les distinguent de Grog-Soaked Blade, qui reste à intégrer.

## Sources natives et provenance

| Ressource sélectionnée | Identifiant |
|---|---|
| Gangplank.inibin | OLS-e69ab4bf-6fe7-57b3-846a-5e15f96ed21b |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptGangplank.luaobj | OLS-5b1c481f-9bc6-50d3-bf73-ec0a38a60876 |
| CharScriptGangplank.preload | OLS-95cd99e4-1cbc-5a32-88bd-55deb689302c |
| Scurvy.inibin | OLS-adb781b0-be7d-5600-8eaf-6e832d204b2b |
| Scurvy.luaobj | OLS-2e1aaedb-87b1-549e-9d99-3c27246bf64b |
| ScurvyStrike.inibin | OLS-be60dfca-bb13-5b74-b505-2b620daf7661 |
| ScurvyStrike.luaobj | OLS-02ada58d-eaed-5855-93d2-b4c1f0c0a474 |
| ScurvyStrikeParticle.inibin | OLS-d1fdf0a3-4319-5191-b8ef-ca863763232d |
| ScurvyStrikeParticle.luaobj | OLS-2ea3e7c5-56b3-542b-befd-652663ac0791 |
| Parley.inibin | OLS-2b6c98d1-1855-5c5a-b3b7-754046d71270 |
| Parley.luaobj | OLS-9e158447-9468-51e9-8b60-be2c1539c74d |
| Scurvy.preload | OLS-7fcf0d5c-f408-5b2e-b9f8-a36f92f47829 |

17 candidats examinés,13 sélectionnés. Tailles/SHA256 conformes au registre et tailles/MD5 conformes aux manifestes des projets RADS sélectionnés. Cela ne démontre pas la priorité effective du chargement historique. Les17 candidats restent conservés avec leurs identités.

Gangplank.inibin lie Passive1LuaName à **Scurvy**, l’icône à **Pirate_GrogSoakedBlade.dds**, le slot1 à **Parley** et le slot2 à **RemoveScurvy**. Le tooltip natif en_GB ligne2595 indique un ralentissement de **7 %**, des dégâts magiques **@f1@ par seconde**, une durée de **3 secondes** et un maximum de **3 cumuls**. La description du passif ligne4189 cite les attaques de base et **Parrrley**. La description ScurvyStrike mentionne une progression avec le niveau. Le producteur numérique f1 et sa formule exacte ne sont pas qualifiés par ces textes ; ne pas déduire une somme de21 % de ralentissement sans qualifier la combinaison.

ScurvyStrike porte IsDamagingSpell et IsDeathRecapSource ; ScurvyStrikeParticle référence Global_Slow.troy et l’icône du passif. Les cinq Lua sélectionnés sont intégralement lus, sans prototype enfant. Quatre initialisations littérales sont reconnues. Pour Parley, le lecteur littéral refuse **NEWTABLE au pc12** : il s’agit d’une limite du lecteur, pas d’une preuve de fichier corrompu. Aucun bytecode serveur historique exécuté. Deux bindings de tooltip et deux preloads sont conservés ; leur présence ne valide pas les callbacks, le rendu ou le son.

PirateScurvy.inibin/.luaobj et RemoveScurvy.inibin/.luaobj sont exclus de l’autorité du poison. Leurs métadonnées utilisent PirateScurvy et l’icône Pirate_RemoveScurvy.dds ; le W est lié au soin et à la suppression des contrôles. Une ressemblance de nom ne suffit pas pour remplacer Scurvy par ces ressources.

Douze références communautaires sont conservées séparément. Le CharScriptGangplank est vide. Le Q contient un calcul de dégâts physiques/critique, des gains d’or/remboursement de mana et un appel TakeDamage de type ATTACK, mais sa création de projectile est commentée. Cela ne démontre ni le serveur historique ni tous les hooks d’impact. Aucune reconstruction communautaire n’est promue automatiquement en règle native.

## Vérification du moteur courant

Quatre simulations Map10 : Gangplank bleu, Annie rouge, positions atteintes par commandes Move puis Stop. Dans le dernier cas, Annie achète publiquement l’objet1033 (+25 résistance magique). Aucun changement direct de position,santé,mana,XP,rang ou effet ; aucun événement artificiel de dégâts.

| Cas | Impacts de mêlée | Résistance magique cible | Refus publics | Suivi après arrêt |
|---|---:|---:|---:|---:|
| gangplank_1_hits | 1 | 30.0 | 15 | 180 |
| gangplank_3_hits | 3 | 30.0 | 15 | 180 |
| gangplank_4_hits | 4 | 30.0 | 15 | 180 |
| gangplank_4_hits_target_cloak | 4 | 55.0 | 15 | 180 |

Chaque impact est associé à la fin de préparation d’attaque observée au tick précédent. Les12 impacts sont au niveau1, de brut59.0400009155, espacés de46 ticks dans les séries. Les trois premiers couvrent92 ticks : cet essai ne garantit donc pas trois charges simultanées avec une durée native de90 ticks si les expirations sont indépendantes. Il ne valide pas le plafond de cumuls. Les12 impacts non critiques correspondent à la formule physique courante brut×100/(100+armure), régénération prise en compte, avec résidu inférieur à0.002. Aucun ralentissement n’est présent et la vitesse cible reste335. Entre les impacts et pendant les720 ticks après arrêt, aucune perte supplémentaire de santé n’est observée après correction de la régénération. Les cas1/3/4 attaques explorent des contextes où le texte natif prévoit un poison cumulable ; ils ne prouvent pas sa politique native puisqu’aucun poison courant n’apparaît.

Les60 refus atomiques couvrent joueur inconnu, attaque de soi, slot invalide et douze Learn/Cast/CastAt par scénario. Les snapshots restent identiques. Parrrley n’est donc pas exécuté ; son déclenchement du passif reste ouvert. L’objet de résistance ne valide aucune mitigation magique du poison absent.

## Contrôle positif distinct

Une cinquième simulation utilise le chargement public join_with_summoners, puis les commandes **SummonerTarget** pour Épuisement et Embrasement. Aucun champ d’état n’est injecté. Épuisement fait passer la vitesse335→234.5 puis335 au bout de75 ticks. Embrasement produit5 applications de14 dégâts bruts,70 au total, dont la première immédiate ; les applications suivantes et l’expiration sont suivies sur150 ticks. La régénération est corrigée avec la réduction de soin active. Quatre refus atomiques supplémentaires couvrent slot invalide, cible alliée/soi et les deux relances en cooldown.

Ces résultats montrent les mécanismes courants de ces sorts. Ils ne démontrent pas le poison magique, les cumuls ou le déclencheur de Gangplank. La sélection de sorts dans cette API ne qualifie pas les déverrouillages de compte natifs. Aucun transport réseau ou rendu n’a été exercé.

Les consommateurs relient les attaques ordinaires,les dégâts/résistances,la régénération,le choix du ralentissement le plus fort,sa préparation/expiration,les vitesses et le dispatch d’invocateur. grant_slow est une API d’événement serveur, pas une commande client permettant d’accorder un effet arbitraire. Le contrôle public passe par Épuisement.

## Contrôles réellement exécutés et conservation

Le premier diagnostic a échoué à la compilation avec **E0559** : il utilisait Summoner avec un champ target, alors que la commande est SummonerTarget. Aucun essai de ce premier programme n’a été exécuté. Source,verrou,manifestes,commande et journal restent conservés. Le successeur distinct corrige uniquement ce diagnostic et compile/s’exécute avec code0.

Exécutable vérifié : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-gangplank-passive-grog-soaked-blade-probe-qualified.exe`, 6067712 octets, SHA256 `7ad0d1f901bc353b3de406515d9daffa69507027e161db940fa9bafcb85936ed`. Dépendance openleague_core non-test ; identités/checksums du verrou privé alignés avec le verrou racine.1158 entrées core/ressources et chaîne historique V569/précédentes conservées, y compris les échecs antérieurs. Cinq scénarios publics,64 refus atomiques, aucun état directement injecté.

Inspection,prepare,check,publish,audit : code0.72 associations invalides et4 graphes invalides refusés. Deux bases SQLite vérifiées :4 destinataires modifiés,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques conservés. Store.task/copy_text/summary/dépendances, résolution de trace,intégrité et synchronisation idempotente contrôlées. Identifiants,hiérarchie et inconnues inchangés en octets ;3 fragments de trace modifiés,42212 conservés. Les instructions copiées incluent les limites et le travail restant.

Revue globale fraîche :42215 exigences,98956 sources,3336 consommateurs ;3336 ancres exactes,zéro divergence.26189 questions ouvertes et5517 résolues inchangées. Cette revue structurelle ne re-hashe pas toutes les sources et ne mesure pas le pourcentage d’achèvement du jeu. Les sources sélectionnées ont leurs contrôles d’identité propres.

## Manques et travail restant

- Retrouver/qualifier le producteur f1, les valeurs et seuils par niveau.
- Qualifier cadence,premier tick,durée,rafraîchissement,cumuls et combinaison du ralentissement,multiples auteurs,mort,purge,résistances et boucliers.
- Intégrer le poison et son déclenchement par attaque et Parrrley dans le moteur, puis vérifier les interactions et catégories de cibles.
- Qualifier séparément HUD,réplication réseau,animations,VFX et audio. Les références d’icônes/preloads ne prouvent ni leur absence ni leur rendu correct.
- Préserver le défaut de déplacementV564 ; les routes réussies dans ces essais ne le corrigent pas.

Livrables : completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json ; reçu reference_requirement_trace_sources/gangplank-passive-grog-soaked-blade-links-v570.json ; preuve fidelity_gangplank_passive_grog_soaked_blade_links_v570.json. Couverture,plan,checkpoint,CURRENT,HANDOFF et deux bases mis à jour avec sauvegardes. Scripts,journaux et observations : revision570_Gangplank* sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

Continuer SYS-01.2-02 depuis revision571_trace_review/REVIEW.json. V570 Gangplank publiée/auditée :3 fiches,13 sources parmi17 candidats,39 associations,28 points/56 liens limités. Quatre scénarios publics :12 impacts physiques,60 refus,720 ticks après arrêt sans poison ni ralentissement;MR30/55. Contrôle public Embrasement/Épuisement distinct :5 impacts70 dégâts bruts,vitesse335→234.5→335,4 refus. Texte natif7 %,3 secondes,3 cumuls;f1,cadence/rafraîchissement et cumul ouverts. Parley NEWTABLE limite du lecteur,pas corruption;PirateScurvy/RemoveScurvy distincts. Préserver INPUTS_BEFORE.previous_artifacts qualifiedV570 qui conserve le build initial E0559 et V569 avec toute la chaîne précédente. Aucun statut/case/inconnu fermé. Inspecter le prochain passif non qualifié dans la file du lecteur générique avant de choisir le lot. Défaut déplacementV564 ouvert;goal actif.
