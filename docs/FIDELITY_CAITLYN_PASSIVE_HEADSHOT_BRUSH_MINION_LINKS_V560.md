# SYS-01.2-02 — Caitlyn : Headshot, V560

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré

Les fiches CH-Caitlyn-PASSIF-SOURCE, CH-Caitlyn-PASSIF-SIMULATION-CONTRAT et CH-Caitlyn-PASSIF-SIMULATION reçoivent 45 associations vers 15 fichiers natifs. Les deux fiches de simulation reçoivent 44 liens vers 22 points de code, tous entry_boundary_only et provides_feature_consumer=false pour Headshot. SYS-01.2-02 référence le lot. Les lecteurs et chargeurs antérieurs sont conservés sans être assimilés à une mécanique terminée.

Prérequis de phase et de lot relevés dans le reçu. Trois questions propres et quatre dépendances conservées. Aucun statut, critère, identifiant, case, note ou historique manuel modifié. Aucun code du jeu ni asset modifié.

## Sources présentes et limites natives

| Fichier | Identifiant |
|---|---|
| Caitlyn.inibin | OLS-b0e4afc8-c608-5188-9e7c-3e383bb14ea2 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptCaitlyn.luaobj | OLS-dc32578f-73a2-543e-b8b0-72286bba30b2 |
| CharScriptCaitlyn.preload | OLS-3eb5fe06-aff8-532c-bd98-7c39c95c37bf |
| CaitlynHeadshot.luaobj | OLS-0fe85053-5e51-5359-8ac5-a8aa4922efe6 |
| CaitlynHeadshot.preload | OLS-5835241e-5689-5691-86ed-18c8b90976d4 |
| CaitlynHeadshotCount.inibin | OLS-c0b80e35-cf20-5b2b-9458-ef7557ea0b5e |
| CaitlynHeadshotCount.luaobj | OLS-ddc20394-1e2c-5348-9265-ed07d275369f |
| CaitlynHeadshotCount.preload | OLS-e553a7e1-aa6c-5719-ba4c-ccc2518ee119 |
| CaitlynHeadshotMissile.inibin | OLS-c145dc1b-26cc-5122-9e3c-930c8bd06e82 |
| CaitlynHeadshotMissile.luaobj | OLS-7e42ebce-bd2f-5971-9362-95734b13bd3e |
| CaitlynHeadshotMissile.preload | OLS-107b5583-9eef-51bb-bbd1-0a3f6df41fa0 |
| CaitlynHeadshotpassive.luaobj | OLS-593981ca-68b3-5964-91c0-c5a1f567d3d3 |
| CaitlynHeadshotReady.inibin | OLS-c52a4d83-1b4f-5609-8984-622a4845afaf |
| Headshot Marker.inibin | OLS-a3a47b7d-cc7f-5cd7-b76f-f88ddf45ce63 |

Taille/SHA256 conformes au registre et taille/MD5 conformes aux projets RADS sélectionnés lors de la découverte ; identités revérifiées à l’inspection. CharScriptCaitlyn se trouve à la racine du champion et Headshot Marker.inibin dans DATA/Spells. Le fichier CaitlynHeadshotpassive.luaobj déclare BuffName=Headshot Marker, concordant avec Passive1LuaName, et l’icône Caitlyn_Headshot.dds.

Trois bindings de tooltip : compteur, disponibilité et marqueur. Le texte1979 indique f1 attaques, double contribution des attaques depuis un buisson, 150% des dégâts sur champion et 250% sur sbire. Le texte9345 parle de huit attaques. Le texte1763 confirme les deux multiplicateurs pour le prochain tir. **Le fournisseur f1, les niveaux et l’articulation avec le texte huit attaques ne sont pas qualifiés.** Les champs Passive1, Passive1Desc et Passive1Level1/2/3 absents restent absents.

Cinq Lua entièrement parsés, sans prototype enfant. Trois permettent l’extraction d’initialisations littérales : CharScript avec globals vides, compteur, et marqueur. Le marqueur déclare PersistsThroughDeath=true et NonDispellable=true ; ces métadonnées ne sont pas une exécution serveur ni un test de persistance. CaitlynHeadshot.luaobj dépasse le lecteur littéral sur NEWTABLE au pc4 et CaitlynHeadshotMissile.luaobj au pc0. Ces limites ne sont pas une corruption. Quatre preloads et six références communautaires conservent leur provenance ; le CharScript communautaire est vide.

## Chemins actuels inspectés

Initialisation, stats, commandes, Learn/next_rank, Cast/CastAt ; lancement/impact des attaques ; dégâts physiques et dégâts aux unités ; profil et tirage des critiques ; flags de navigation, visibilité et ligne de vue ; création du monde et des vagues ; régénération ; achats et bonus d’objets.

advance_attacks construit les dégâts bruts depuis AD, avec des branches Garen/Trundle et critique ordinaire ; aucune branche Headshot n’est qualifiée dans ce chemin. La navigation expose un flag buisson et la visibilité l’utilise ; cela ne prouve pas un compteur Headshot. Le profil critique ordinaire de Caitlyn déclare une chance de zéro dans les cas testés. La route exacte et les lignes sont épinglées dans le reçu, avec un rôle borné à cette exigence.

## Essais publics exécutés

Trois simulations Map10 réelles depuis l’API publique : déplacement de Caitlyn et Garen, arrêt, attaques sur champion ; puis une partie distincte contre les vagues normales de sbires. Aucun PV, mana, or, XP, dégât, position ou effet directement injecté. Les champions survivent, Caitlyn reste niveau1, aucune fin de partie.

| Cas | Lancements | Impacts champion isolés | Dégât brut | Refus |
|---|---:|---:|---:|---:|
| champion_open | 12 | 12 | 50.04000 | 17 |
| champion_brush | 12 | 12 | 50.04000 | 17 |
| lane_minions | 12 | 0 | 50.04000 | 17 |

En terrain ouvert, départs845 à1373 par pas de48ticks ; impacts848 à1376. Depuis le buisson, départs882 à1410 par pas de48 ; impacts885 à1413. Le flag source vaut respectivement0 et1 à chacun des12lancements. Les24impacts correspondent à AD×100/(100+armure), après compensation de régénération plafonnée aux PV maximum ; erreur maximale 0.0000190735. Aucun supplément de dégâts Headshot n’est observé dans ces séquences.

Contre les sbires, deux achats publics depuis les825or de départ : Cristal de rubis1028 à400or (+150PV) et Armure d’étoffe1029 à300or (+15armure), sans bonusAD. Les vagues sont produites par le monde courant, sans création de cible artificielle. Quatre ordres visent des sbires Melee et Caster. Douze projectiles partent aux ticks2963 à3491 par pas de48 ; ils portent tous50.0400009155 dégâts bruts, identiques à l’AD courant. Onze retraits de projectiles sont enregistrés ; le douzième reste en vol à l’arrêt de l’observation. Les dégâts nets des sbires ne sont pas isolés des autres combattants et ne sont pas revendiqués comme douze impacts qualifiés. Caitlyn termine avec215.50087PV et192XP au niveau1.

Attendu : observer séparément les tirs ordinaires, l’état buisson et les cibles sbires, sans déduire un compteur natif de la seule présence de fichiers. Observé :36lancements ordinaires non critiques, dont24impacts champion contrôlés ; aucun tir renforcé observé. Cette conclusion est limitée aux séquences et chemins exécutés, pas à tous les scénarios possibles de Headshot.

51refus atomiques : dans chaque cas, joueur inconnu, cible inconnue, cible propre, objet inconnu, slot de vente invalide et12refus Learn/Cast/CastAt sur quatre slots. Snapshot complet inchangé avant/après chaque refus. Le refus d’un sort ne prouve pas l’activation du passif.

## Travail restant et limites ouvertes

- Qualifier f1 et les niveaux du compteur, le moment de comptage, le double comptage en buisson, la consommation du tir et la relation avec le texte huit attaques.
- Qualifier les multiplicateurs150%/250%, la base AD et les types de cible, notamment monstres et structures ; isoler les impacts sur sbires.
- Qualifier annulation de l’attaque, cible morte, projectile déjà parti, critique et autres modificateurs, réinitialisation et persistance au décès.
- Relier état serveur, projection réseau, icône/compteur, missile, modèle, effets et audio à des observations effectives.
- Dépasser les limites littérales NEWTABLEpc4/pc0 et retrouver le contrat serveur nécessaire. Aucun client original, VM Lua complète, GUI, GPU, audio ou réseau exécuté ici.

## Vérifications et conservation

Build/run, inspection, préparation, contrôle du candidat, publication et audit : code0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-caitlyn-passive-headshot-brush-minion-probe.exe` ; 6053888octets ; SHA256 `91ea4502e4f6cfaf8b487b12e01b86962b15a33884bdd37bee0fa711907cade6`. Runtime `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision560_Caitlyn_passive_probe\OBSERVATIONS.json` ; logs BUILD/RUN conservés.1158entrées de code/ressources et anciens artefacts exacts ; verrou privé aligné au Cargo.lock racine. Core non-test en cache ; la suite historique complète n’a pas été réexécutée.

72associations invalides et4graphes invalides rejetés : Headshot inventé, critique assimilé au passif, flag buisson assimilé à compteur, persistance déduite des métadonnées, dégâts nets sbires qualifiés à tort, niveaux inventés, question étrangère ou dépendance retirée.

Deux bases SQLite :4destinataires chacune ;42603autres lignes de catalogue,42607états manuels,23événements historiques exacts. Store.task/copy_text/summary, dépendances, références, intégrité et synchronisation idempotente vérifiés. Trois fragments changés,42212inchangés. IDs, hiérarchie et inconnues identiques en octets.

Graphe42215exigences,98916sources,3113consommateurs ;3113ancres et527fichiers courants exacts, zéro divergence.26189questions ouvertes/5517résolues. Pas de nouveau recensement physique de toutes les sources.8318fiches CH à chargeur partagé seulement restent une file de recherche, pas un pourcentage de réalisation.

## Fichiers et suite

completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json ; reçu docs/reference_requirement_trace_sources/caitlyn-passive-headshot-brush-minion-links-v560.json ; preuve docs/fidelity_caitlyn_passive_headshot_brush_minion_links_v560.json ; couverture, plan, reprise, CURRENT et HANDOFF sauvegardés puis complétés. Scripts archivés, anciennes preuves conservées. Aucun stage/reset/commit.

Continuer SYS-01.2-02 depuis revision561_trace_review/REVIEW.json. Caitlyn V560 publié/audité :15sources natives,45arêtes,22points/44liens false. Trois cas publics :12impacts champion hors buisson,12depuis buisson,12lancements vers sbires Melee/Caster naturels.36projectiles non critiques àAD ordinaire50.04,aucun Headshot observé ;24impacts conformes armure/régénération,51refus,aucune injection. Cas sbires avec Ruby1028+Cloth1029=700or,4ordres,11retraits et dernier projectile en vol ;dégâts nets non isolés.3bindings,5Lua sans callbacks,4preloads,6références communautaires. Headshot Marker concordant ;PersistsThroughDeath/NonDispellable restent métadonnées. Limites lecteur NEWTABLEpc4/pc0,non corruption. f1 versus texte8attaques,buisson×2,150%champion/250%sbire,persistance/critique et présentation restent ouverts. Aucun gameplay changé ni statut/case/inconnue fermé. Examiner ensuite Corki/RapidReload :bonus dégâts vrais10%AD total et exclusion structures,avec cibles et mitigation séparées. Ne pas republier V560 sans cause nouvelle. Goal actif. Découverte Corki déjà faite :revision561_Corki_discovery/OBSERVATIONS.json,6sources natives,1binding,2Lua entièrement parsés/littéraux sans callbacks,1preload,3références communautaires. RapidReload BuffName/icône concordants,PersistsThroughDeath/NonDispellable métadonnées. Texte2510 bonus vrais10%AD total et structures exclues ;description4176 sbires/monstres/champions. Passive1Desc porte une ancienne phrase Annie ;niveaux1/4/7/texte10/13/16 présents,non adoptés comme politique Corki. Aucun runtime Corki encore exécuté. Comparer des attaques publiques avec AD de base puis Épée longue1036 et avec armure cible1029 ;séparer le moteur générique DamageKind::True de son déclenchement automatique. Structure et autres types de cible à qualifier sans injection ni assimilation de dégâts bruts à dégâts nets. Ne pas refaire découverte sans cause nouvelle.
