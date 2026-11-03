# SYS-01.2-02 — Malphite : Bouclier de granit, V548

25 octobre2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 à17:46:45 ; fuseau et déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré

CH-Malphite-PASSIF-SOURCE, CH-Malphite-PASSIF-SIMULATION-CONTRAT et CH-Malphite-PASSIF-SIMULATION reçoivent42 arêtes vers14 sources natives. Les deux fiches de simulation reçoivent28 liens vers14 frontières effectives, toutes `entry_boundary_only` et `provides_feature_consumer=false`. SYS-01.2-02 référence ce lot. Les lecteurs de sources et le chargeur partagé sont conservés sans promotion en déclencheur du passif.

Phases, lots et prérequis effectifs sont relevés dans le reçu ; leurs sorties ne sont pas déclarées achevées. Trois questions propres et quatre dépendances restent exactes avec les propriétaires de leurs questions. Aucun inconnu ajouté ou fermé ; statuts, critères, cases, notes et historique préservés.

## Sources natives

| Fichier | Identifiant |
|---|---|
| Malphite.inibin | OLS-04a57042-a14d-5eee-83e5-1a91781a1949 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Malphite Shield Cooldown.inibin | OLS-0d9d1bb9-b225-56b8-bac4-a62acab812dc |
| MalphiteObduracyEffect.inibin | OLS-e3fbfc8d-daac-54cc-a52e-2062a858478a |
| MalphiteShield.inibin | OLS-3b8e4f47-0673-502a-a28b-2cab715bf23b |
| MalphiteShield.luaobj | OLS-9540dba7-d544-5d7a-958b-2c4529ce92bd |
| MalphiteShieldBeenHit.luaobj | OLS-03202627-ed9d-5f14-a900-e0bdfb3827cb |
| MalphiteShieldBeenHit.preload | OLS-acd499c4-56ba-508f-9e8d-a34b15af7708 |
| MalphiteShieldEffect.luaobj | OLS-f477368e-081e-5800-952f-24f1936e4997 |
| MalphiteShieldEffect.preload | OLS-2d85e5d9-5de2-519f-90cb-4a2335953d18 |
| MalphiteShieldRemoval.luaobj | OLS-694b61e5-18bb-596b-9682-deaf1f8178e3 |
| MalphiteShieldRemoval.preload | OLS-36ce8568-37d2-5054-9b81-699a4c0d868e |
| CharScriptMalphite.luaobj | OLS-117643d1-4e8a-5a9e-acf7-630df79dbaa5 |
| CharScriptMalphite.preload | OLS-e35634d2-34f3-55b6-a6ab-9304c931a650 |

Les14 fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets sélectionnés du manifeste RADS. La découverte V548, déjà effectuée au tour précédent, est revalidée et réutilisée sans la relancer. Son périmètre couvre définition, MalphiteShield et variantes, Malphite Shield Cooldown, MalphiteObduracyEffect et CharScript. Il ne démontre pas une absence mondiale de code serveur.

La définition et le BuffName de MalphiteShield concordent. Trois INIBIN lient exactement les infobulles de recharge2251, effet2255 et MalphiteShield2256. Cette dernière donne **10% de la vie maximale**, avec f1 pour le montant et f2 pour le délai. La description du champion4228 indique **10secondes sans avoir été touché**. Les fournisseurs effectifs f1/f2 restent inconnus. Les textes MalphiteObduracy2254 et Shield_Marker2630 sont conservés comme contexte ; aucun des trois bindings inspectés ne les sélectionne. Ils ne sont pas promus en chemin de chargement effectif.

Cinq Lua sont entièrement parsés et sans prototype de callback enfant. MalphiteShield déclare nom, texture et booléens ; BeenHit déclare BuffName=Malphite Shield Cooldown et texture grise. ShieldRemoval porte notamment AutoBuffActivateEffect vide, conservé comme chaîne vide. Quatre preloads mentionnent les liens effet→removal/beenhit, malphitecleave, apbonusdamagetotowers, root et Malphite_Base_obduracy_off.troy. Cette déclaration ne prouve ni activation ni rendu.

Le chunk ShieldEffect de343octets est entièrement parsé, mais l’interprétation littérale s’arrête à NEWTABLEpc8. Ses constantes comprennent OnPreDamagePriority,3,SpellFXOverrideSkins,MalphiteSkin06 et DoOnPreDamageInExpirationOrder. Elles ne prouvent pas des valeurs assignées, une priorité active ou un override de skin exécuté. **Limite du lecteur, pas preuve de corruption.** Le CharScript de56octets ne contient qu’un RETURN ; aucune VM originale n’est exécutée.

L’ancien texte sur Jax, les chaînes de régénération de mana+40/+60/+80%, Passive1=9 et les niveaux3/7/11 sont conservés sans adoption comme règles actives. L’activation initiale et la politique de niveau ne sont pas déduites de ces restes. Les cinq références communautaires, dont CharScriptMalphite.cs vide, gardent leur provenance ; elles ne deviennent pas une implémentation serveur originale.

## Code courant et diagnostic

Le chemin relie join, stats/maxPV, achat Ruby, refresh_item_caps, Attack, advance_attacks, libération mêlée, basic_attack_hit, apply_damage, grant_shield, advance_shields, absorb_shields, régénération et tick. Les dégâts consomment les boucliers déjà présents avant de diminuer la vie. grant_shield est une API d’événement serveur, pas une commande client ni le déclencheur de Granite Shield. L’expiration générique et la recharge du passif sont deux comportements distincts.

Trois parties Map10 avec navigation réelle : sans objet, Rubis1028 (+150PV max), et sans objet avec témoin de bouclier fourni ultérieurement. Le core reste non-test. Commandes publiques d’achat, déplacement, Attack et Stop ; aucun dégât, vie, or, XP ou position injecté. Seul le troisième cas reçoit plus tard un événement serveur de bouclier explicitement diagnostique. Champions vivants au niveau1, sans victoire.

Chaque partie observe301ticks à l’apparition, puis déplace Malphite/Garen vers deux points praticables. Une attaque ordinaire touche Malphite au tick1117. Garen est arrêté et une nouvelle fenêtre301ticks est observée. Deux attaques supplémentaires arrivent aux ticks1429 et1477 ; Garen est arrêté de nouveau et301ticks sont observés. Fenêtres :1..301,1118..1418,1478..1778. Les observations incluent donc le300e tick et le tick suivant après le dernier impact.

Le contrôle des fenêtres impose une vie non décroissante, le maintien au niveau1 et l’absence de fin de partie ; Garen est arrêté. **Il ne constitue pas une trace exhaustive de tous les événements de dégâts.** Le nom `quiet`/`no_damage_window` décrit le scénario ; le fait observé est l’absence de baisse nette de vie et de bouclier dans les échantillons. Cette limite est conservée, notamment pour une future qualification des interruptions par dégâts absorbés ou compensés.

| Cas | PV maximum | Capacité selon texte10% | Bouclier naturel dans les fenêtres |
|---|---:|---:|---:|
| Sans objet |574.2000122070312|57.42000198364258|0|
| Rubis1028 |724.2000122070312|72.42000579833984|0|

Les premières attaques retirent environ45.113PV après prise en compte de la régénération du tick, sans absorption. Dans le troisième cas, **après** la première fenêtre suivant l’attaque, le diagnostic appelle au tick1418 `grant_shield` avec le tag diagnostic-control,57.42000198364258PV et600ticks de durée. Ce montant est choisi d’après le texte pour servir de témoin ; il est fourni par le diagnostic et n’est pas produit par le passif.

Au tick1429, le témoin absorbe45.11301803588867PV et aucune vie n’est perdue au-delà de la régénération. Au tick1477, il absorbe ses12.306983947753906PV restants ;32.8060302734375PV atteignent la vie. Il est alors épuisé, avant son expiration déclarée2018 ; l’expiration n’est pas testée ici. Aucun bouclier n’apparaît dans la fenêtre suivante. Ces résultats démontrent le fonctionnement de l’absorption générique, pas l’activation ni une recharge native de Granite Shield.

Neuf refus Attack : joueur inconnu,cible inconnue,soi-même comme cible dans chaque partie. Cinq refus grant_shield dans le seul cas témoin : montant0,NaN,durée0,tag vide,cible inconnue. Chaque refus est entouré de sa propre comparaison de snapshot complet, inchangé. Neuf attaques ordinaires au total ; les dégâts totaux vie+bouclier correspondent à la mitigation courante avec tolérance0.002PV. Les attentes de ce diagnostic sont distinctes d’une acceptation du passif.

Build/run0 ; core non-test en cache Cargo.1158 entrées source/ressource, anciens artefacts et identité/checksums des dépendances du Cargo.lock racine restent exacts. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-malphite-passive-shield-probe.exe` ;6023680octets ; SHA-256 `e2c25e99023107e7a5a8a543972f15c9385ddcf9e23a1c93631386a874c9a39f`. Source, outils, manifestes, verrous, logs et commandes pinés dans `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision548_Malphite_passive_probe\OBSERVATIONS.json`. Aucun client historique, serveur natif, GPU, réseau, audio ou validation visuelle exécuté.

## Livraison et conservation

Inspection,prepare,check,publish,audit réussis.66 associations invalides et quatre graphes invalides refusés : témoin présenté comme activation native, NEWTABLE pris pour corruption, ancienne règle ou skin adopté, disponibilité/recharge ou binding non prouvé, source/binaire modifié, question étrangère et dépendance retirée. Quatre preuves ajoutées ; anciens descripteurs préservés.

Par base réelle : quatre destinataires actualisés,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques exacts. Store.task/copy_text/summary, questions/dépendances, integrity_check et sync_catalog idempotent vérifiés. Trois fragments changent,42212 restent exacts ;42211 autres objets tâche/trace conservés. IDs,hiérarchie et registre des inconnus identiques en octets.

Réexamen :42215 exigences,98868 sources,2893 consommateurs ;26189 questions ouvertes et5517 résolues.2893 ancres et527 fichiers actuels exacts,zéro divergence ;17 auxiliaires conservés. Pas de nouveau census physique des98k sources.8342CH au seul chargeur partagé reste une file de recherche,pas un taux de complétion.

## Fichiers et reste à faire

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/malphite-passive-shield-links-v548.json ; preuve docs/fidelity_malphite_passive_shield_links_v548.json. Quatre lignes données/consignes changées par base. Couverture,plan documentaire,reprise,CURRENT et HANDOFF actualisés avec sauvegardes et anciens champs conservés. Scripts sur F et archivés. Aucun gameplay/asset modifié ni stage/reset/commit.

Restent ouverts : déclencheur autoritaire,f1/f2,activation initiale/niveaux,interruption et réactivation,effet d’un dégât entièrement absorbé,ordre,durée,mort,aliases,override de skin et présentation. Le serveur original n’est pas reconstitué par ces métadonnées ou ce témoin. V547 et antérieurs restent conservés.

Continuer SYS-01.2-02 depuis revision549_trace_review/REVIEW.json. V548 Malphite publié/audité :3fiches,14sources natives,42arêtes,28liens vers14frontières ;3questions propres/4dépendances préservées. Trois parties niveau1,sans objet/Ruby/contrôle serveur :neuf fenêtres301ticks à bouclier0,attaquant arrêté,vie non décroissante ;ce contrôle ne trace pas exhaustivement les événements de dégâts. Texte10%maxPV et10s,capacités57.420/72.420 non formées naturellement dans ces cas. Seul grant_shield explicite57.42 au tick1418 absorbe45.113 puis12.307,avec32.806débordement ;contrôle artificiel,pas passif. Neuf refus Attack,cinq refus événement,snapshots exacts. Cinq Lua sans callbacks ; ShieldEffect NEWTABLEpc8 est une limite de lecteur,pas corruption. Priorité/skin06,anciens Jax/mana/Passive1=9/niveaux3/7/11 et textes non liés restent ouverts. Aucun gameplay modifié/passif accepté. Ne pas republier ni relancer ces diagnostics sans cause nouvelle. Examiner ensuite Shen/Ki Strike : le lookahead anglais montre9s dans Shen_Passive_Marker2622 contre8s dans description4272 ; conserver cette divergence sans choisir arbitrairement. Identifier bindings,source de dégâts magiques/10%PV bonus,récupération d’énergie et réduction1s par attaque avant diagnostic.104autres contrats/parents de passifs restent à examiner ;8342CH au seul chargeur partagé reste une file de recherche,pas un taux de complétion. Goal actif. Découverte Shen déjà effectuée et revalidée : revision549_Shen_discovery/OBSERVATIONS.json,18 sources natives,4 bindings de buff,6 Lua sans callback enfant et5 preloads. La définition lie effectivement ShenWayOfTheNinjaMarker et les clés WIP ; le marker lie le texte9s,la description WIP8s. ShenKiAttack.description mentionne vie maximale contre vie bonus dans le marker. Ne choisir ni délai ni base de calcul à partir de ces seuls textes. ShenKiAttack Lua entièrement parsé mais NEWTABLEpc10 non interprété,pas corrompu. Runtime,inspection qualifiée et publication Shen restent à faire ; ne pas relancer la découverte sans cause nouvelle.
