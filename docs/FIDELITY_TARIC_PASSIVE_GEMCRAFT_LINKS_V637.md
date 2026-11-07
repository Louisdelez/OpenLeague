# Taric — Gemcraft : sources et consommateurs V637

Date UTC : 2026-10-26T20:28:25.901278+00:00. Tâche SYS-01.2-02, projet F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Build indiqué 2014-11-17 17:46:45, fuseau et date de déploiement inconnus.

## Résultat

Trois fiches Taric reçoivent 126 associations vers 42 fichiers natifs et 52 liens vers 26 points de code actuel. La découverte, l’inspection et le diagnostic du vrai moteur sont exécutés. Les commandes de sorts Taric testées sont refusées : le déclenchement de Gemcraft reste non exercé. Les attaques ordinaires vérifiées ne constituent donc pas une preuve de fonctionnement ou d’échec du passif après activation. Aucun code de gameplay n’est modifié.

## Contrat annoncé et contradictions natives

La description du personnage (fontconfig ligne 4287), la description du sort Gemcraft et le BuffData de Gemcraft concordent sur une prochaine attaque renforcée après un sort, avec dégâts magiques liés à l’armure. Le tooltip BuffData ligne 1943 ajoute une réduction des délais de récupération de **2 secondes**, avec dégâts `@f1@` et pourcentage d’armure `@f2@`. Les producteurs de ces paramètres et leur progression restent non qualifiés.

Les contradictions sont conservées :

- Gemcraft.inibin lie son **SpellData** à `game_spell_tooltip_Gemcraft` (ligne 11543), qui annonce des dégâts liés au **mana maximal**. Son **BuffData** lie le texte armure/après-sort/2s. Aucun dispatch historique n’a été exécuté pour établir une priorité.
- TaricGemcraftBuff lie un BuffData de prochaine attaque renforcée, mais ses champs SpellData renvoient au tooltip et à la description de **TaricHammerSmash/Radiance**. Ses valeurs Effect et Coefficient ne sont pas adoptées comme formule du passif.
- Taric.inibin conserve une description Singed mana→santé. Passive1 et les six marqueurs Passive1Level sont absents ; ces absences ne deviennent pas des zéros ou des règles Singed.
- Le texte `TaricRadianceBuff` trouvé par recherche large parle d’Opal Harmony, vitesse et dégâts périodiques. Les bindings Radiance/RadianceAura sélectionnés parlent de bonus AD/AP. Ce résultat large n’écrase pas les bindings effectivement lus.
- `game_buff_tooltip_TaricHammerSmash` n’est pas résolu. Le tooltip de sort Radiance existe, mais ce n’est pas la même clé.

## Inventaire et portée des lecteurs

Le corpus contient 16 INIBIN, 14 Lua, 10 preloads, Taric.ddf et fontconfig. Les 42 identités sont comparées aux sources enregistrées et aux manifestes des projets sélectionnés. CharScriptTaric est sous Scripts ; son initialisation Lua est vide et son preload cite Gemcraft, TaricGemcraftBuff et les buffs Shatter.

Les 14 Lua sont entièrement lus, sans fonctions enfants. Cinq initialisations rencontrent NEWTABLE : Dazzle, TaricDazzleStunMissile, TaricGemcraftBuff, TaricHammerInternal et TaricHammerSmash. Gemcraft.luaobj déclare notamment persistance et NonDispellable ; ces métadonnées ne prouvent pas un callback serveur, la durée ou le comportement après décès.

Neuf BuffData sont liés, huit traductions exactes et une clé non résolue. Taric.ddf contient douze lignes et quatre liens non vides : Shatter f1/f2/f3 vers armure 0,12/0,2/0,05 ; Imbue f2 vers bonushealth 0,07. Aucune association Gemcraft f1/f2 n’y est présente. Les coefficients de Shatter ne deviennent pas ceux de Gemcraft.

## Références communautaires inspectées

24 fichiers sont inspectés, y compris les buffs dans les sous-répertoires Taric. Aucun C# n’est exécuté. La recherche dans les fichiers `.cs` de LeagueSandbox-Scripts ne trouve ni Gemcraft ni CharScriptTaric. Un éventuel producteur extérieur reste inconnu ; cela ne signifie pas que tous les assets Taric manquent.

- **Q / Imbue** : soin allié et lanceur, ratios AP 0,3 et bonusHP 0,05 ; soin personnel augmenté avec AP 0,42 et bonusHP 0,07. La présence de ces calculs ne démontre pas un déclenchement du passif.
- **W / Shatter** : dégâts magiques et réduction d’armure pendant 4s. Aura d’armure passive, retrait/restauration de l’armure propre et interaction avec Gemcraft non démontrés. Le cast en ObjAIBase avant le test de type et le retour de fonction sur un ennemi déjà buffé nécessitent qualification. TaricWDis porte le type DISARM ; il ne produit pas Gemcraft.
- **E / Dazzle** : le lancement de projectile est commenté. ApplyEffects contient dégâts, stun et trois bandes de distance, mais son appel effectif n’est pas établi par ce fichier.
- **R / Radiance** : dégâts de zone et appels de buffs de 10s. Les producteurs Radiance et Radiance_ally sont présents : bonus AD/AP de 10+20×rang, moitié pour les alliés. Retrait, rafraîchissement, portée, conditions de ciblage et activation du passif restent à qualifier dans un runtime.

## Moteur actuel et diagnostic

Une recherche Taric/Gemcraft sur les sources Rust de core ne trouve pas de branche nommée. Les points génériques sont inspectés séparément : admission des rangs et sorts, commandes, attaques, dommages, armure, objets, ressources et CDR. Le calcul générique de réduction en pourcentage n’est pas le producteur d’une soustraction de 2s déclenchée par Gemcraft ; ses deux points de code sont associés comme contexte statique, sans prétendre les avoir exercés dans ce diagnostic.

Deux scénarios niveau 1 via commandes publiques : Taric sans objet, puis avec Cloth Armor 1029. Le second réalise réellement achat, vente et rachat ; aucune position, XP, dommage, rang ou buff n’est injecté. Quatre trajets aboutissent sans réordre. Les apprentissages, casts ciblés et casts au sol Taric essayés sont refusés ; les instantanés restent identiques pour les 54 refus.

| Profil | Armure | AD | Impacts ordinaires | Dégâts observés min–max | Refus | Opérations boutique |
|---|---:|---:|---:|---:|---:|---:|
| base | 25.875999 | 57.880001 | 6 | 48.548889–48.548904 | 27 | 0 |
| Cloth15Armor | 40.875999 | 57.880001 | 6 | 48.548889–48.548904 | 27 | 3 |

La cible est Annie. Douze impacts sont comparés au calcul physique ordinaire avec son armure et sa régénération, tolérance 0,002. L’armure de Taric augmente de 15, son AD reste identique et ses attaques non amorcées restent ordinaires. Chaque cas observe aussi 181 ticks au repos, soit 362 au total. Rangs et délais Taric restent à zéro, mana au maximum, personnages vivants au niveau 1, sans bouclier ni contrôle ni événement de mort.

**Limite essentielle :** aucun sort Taric n’est accepté pour amorcer Gemcraft. Les dégâts magiques renforcés, leur coefficient d’armure, leur consommation et la réduction de délais ne sont pas testés positivement. L’attente ne prouve ni une durée native de buff ni une soustraction de 2 secondes.

BUILD et RUN retournent 0. Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-taric-passive-gemcraft-probe.exe` ; 6077952 octets ; SHA-256 `7d1d70fbacf797b28454e4df977190d3199fc27fc225ade51146d1b97a1df2f7`. Le vrai core de F:/OpenLeague est compilé en profil non-test, avec identités/checksums Cargo alignés. Les 1158 entrées de code/ressources et les artefacts précédents sont contrôlés à l’octet et conservés. Une commande exploratoire de lecture JSON a rencontré une erreur de syntaxe Python avant toute mutation ; la lecture corrigée a réussi. Cet incident n’est ni un échec de build ni un test gameplay.

## Intégration et contrôles

PREPARE, CHECK, PUBLISH et AUDIT retournent 0 avant cette synthèse. 72 altérations d’associations et quatre altérations du graphe sont refusées. Trois liens courts de fiches sont actualisés. Les deux bases conservent les 42603 autres lignes, les 42607 états manuels et les 23 historiques ; quatre destinataires sont vérifiés et la synchronisation est idempotente.

Les trois questions propres et quatre dépendances sont conservées ; aucune inconnue n’est fermée. Index d’exigences, hiérarchie et registre des inconnues sont conservés à l’octet. Graphe courant : 99225 sources et 4961 consommateurs. La revue contrôle les 4961 ancres exactes et les empreintes des fichiers consommateurs, sans divergence. Elle n’est pas un recensement à nouveau des octets de toutes les sources du graphe ; le corpus sélectionné et les entrées du diagnostic ont leurs contrôles distincts.

Fichiers modifiés : registres des tâches/sources/traces, association et preuve V637, coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md et HANDOFF.md. Statuts, critères, propriétaires, dépendances, cases, notes et historiques conservés ; aucun stage/reset/commit.

## Preuves et travail restant

Répertoire privé : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Reçus dans revision637_Taric_discovery, revision637_Taric_passive_probe, revision637_Taric_inspection et revision637_Taric ; revue dans revision638_trace_review. Les scripts/générateurs sont archivés avec la livraison. Association publique : docs/reference_requirement_trace_sources/taric-passive-gemcraft-links-v637.json ; preuve : docs/fidelity_taric_passive_gemcraft_links_v637.json.

1. Établir les producteurs f1/f2, la progression et le dispatch entre les descriptions natives contradictoires ; ne pas remplir les inconnues avec des valeurs supposées.
2. Produire l’activation après les sorts admissibles, durée/réapplication et une seule consommation sur l’attaque appropriée.
3. Qualifier le calcul d’armure, les dégâts magiques, cibles admises, résistances, invulnérabilité, boucliers, attaques interrompues/esquivées, critiques et effets à l’impact.
4. Qualifier la réduction de 2s, les compétences concernées, son plancher et son ordre avec CDR et événements simultanés.
5. Tester niveaux, objets, Shatter, mort/réapparition, reconnexion et déterminisme.
6. Qualifier séparément HUD, VFX, sons, animations, rendu et transport réseau. Aucun serveur historique ou de ces parcours de présentation n’est exécuté ici.

Les limites V564/V606 et les autres inconnues du projet restent ouvertes. Cette livraison ne termine ni Taric ni le jeu.

Suite : Continuer SYS-01.2-02 depuis revision638_trace_review/REVIEW.json. V637 Taric / Gemcraft : 42 fichiers natifs, 126 associations, 26 points de code et 52 liens. BuffData annonce une attaque renforcée après un sort, dégâts magiques selon armure f1/f2 et réduction des délais de 2 secondes ; producteurs f1/f2 et dispatch restent ouverts. SpellData Gemcraft parle de mana maximal, TaricGemcraftBuff renvoie au tooltip R et une description Singed subsiste : contradictions conservées. Quatorze Lua sans fonctions enfants, cinq limites NEWTABLE, dix preloads, neuf BuffData dont huit résolus ; DDF douze lignes avec quatre liens Q/W, aucun Gemcraft. Vingt-quatre références communautaires ; aucun Gemcraft/CharScriptTaric trouvé dans le sous-arbre C# inspecté. E a un lancement de projectile commenté, W ne démontre pas son aura passive, R et ses buffs restent des références non exécutées. Deux cas publics base/Cloth15Armor : douze attaques non amorcées, 54 refus atomiques, 362 ticks au repos, quatre trajets et achat/vente/rachat. Armure25,876/40,876 ; dégâts ordinaires48,54889 dans les deux cas. Aucun sort Taric accepté, aucun proc ni réduction de2s exercés. BUILD/RUN/inspection0 ; gameplay, états, cases, inconnues et preuves antérieures conservés. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Teemo. Goal actif.

## Sources et points de code sélectionnés

Les chemins complets, appartenances RADS et empreintes se trouvent dans les reçus JSON.

| Fichier | Identifiant de source |
|---|---|
| Taric.inibin | OLS-01100f44-6519-544f-a87d-d267d9a066dd |
| Taric.ddf | OLS-5e60cf5e-fc58-5f39-a176-49543d426cff |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptTaric.luaobj | OLS-abbd1dc0-642c-5a0d-9b58-c74c451c7645 |
| CharScriptTaric.preload | OLS-0fac302b-3e0c-5a92-adad-823768f9e455 |
| Dazzle.inibin | OLS-a4041b6a-67b9-58f4-90ab-8ee17b4dcd2a |
| Dazzle.luaobj | OLS-5146cf85-d854-5794-b67f-43be89ff7e97 |
| Dazzle.preload | OLS-4f77f3f4-0314-52ce-998a-7c6cb939decd |
| Gemcraft.inibin | OLS-439e59fc-6e3d-5d82-8aa3-d673e61669ee |
| Gemcraft.luaobj | OLS-944a23af-7ef8-5e1d-92f7-4e74312e5c91 |
| Gemcraft.preload | OLS-ffe1c917-fbfe-59d5-82ae-103460f4fb43 |
| Imbue.inibin | OLS-1fe282e8-5d5b-50ef-95ec-8d45ac8db928 |
| Imbue.luaobj | OLS-8a16000c-30fd-538b-931e-a98fc4785494 |
| Imbue.preload | OLS-269640f0-2733-57e9-b942-0e576318dd3d |
| Radiance.inibin | OLS-9a9af782-fc19-5ead-aa89-719d5a144307 |
| Radiance.luaobj | OLS-fbf1f27e-898d-5288-878d-58a940fe4fd2 |
| Radiance.preload | OLS-34c600b7-66e5-5106-aa69-7b1ebb427e12 |
| RadianceAura.inibin | OLS-79cdeb40-0b70-5fb0-88da-d5f96855bfb0 |
| RadianceAura.luaobj | OLS-fc7024e0-43d2-5265-8e96-8fc5f7e0fda8 |
| RadianceAura.preload | OLS-2b2f8990-7fc6-5f57-946f-f5f594eab552 |
| Shatter.inibin | OLS-871427db-6e04-5a88-b4a6-b63138b48760 |
| Shatter.luaobj | OLS-2d076ac9-e02f-5c03-bab8-27b560919f06 |
| Shatter.preload | OLS-b7d1c6f9-cedd-5435-9ddb-c63ee04dae19 |
| ShatterAura.inibin | OLS-67fb68da-f3d7-55f3-b706-6e88566f5e9f |
| ShatterAura.luaobj | OLS-0208d9f1-354a-5878-ac2a-2cc332042374 |
| ShatterAuraSelf.inibin | OLS-8273c6be-e9d8-55e4-bc5f-e3d1b6adee18 |
| ShatterAuraSelf.luaobj | OLS-b0a791a0-119a-5204-a791-2867132d791c |
| ShatterSelfBonus.inibin | OLS-f6f9f118-84de-5023-9729-b5438716329f |
| ShatterSelfBonus.luaobj | OLS-bf64f94b-b942-5acc-b42b-a30e001349d5 |
| ShatterSelfBonus.preload | OLS-2cd26b8c-939e-5d60-b41c-4ad70ef8186d |
| TaricBasicAttack.inibin | OLS-a106b16b-0cdd-5076-b3fd-46c2e5a17cad |
| TaricBasicAttack2.inibin | OLS-55a70671-77e7-596a-8022-7b588a5571ee |
| TaricCritAttack.inibin | OLS-a053cda2-382c-5333-a055-3d234f6b0fc8 |
| TaricDazzleStunMissile.inibin | OLS-1552389a-0305-525b-89a2-8ae8c4db893d |
| TaricDazzleStunMissile.luaobj | OLS-a382023d-8f39-5337-b93d-544d29029e2d |
| TaricGemcraftBuff.inibin | OLS-ad27079a-7510-5ded-a286-06137af96b2e |
| TaricGemcraftBuff.luaobj | OLS-106bc695-06cc-5f27-b83a-64f1d781d30c |
| TaricHammerInternal.luaobj | OLS-072e1fe0-3aca-5f3c-95a9-79550cc7132b |
| TaricHammerInternal.preload | OLS-b989b76b-e911-57fa-a82a-859c8346a8cb |
| TaricHammerSmash.inibin | OLS-416c3f43-eae4-5948-9e99-40085b49620d |
| TaricHammerSmash.luaobj | OLS-6843674a-a437-5ad3-8d5c-e94520b4608f |
| TaricHammerSmash.preload | OLS-628da394-8f90-5e81-b829-bb964f39e873 |

| Point de code | Rôle borné |
|---|---|
| crates/core/src/lib.rs:533 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lib.rs:598 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/progression.rs:68 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/progression.rs:150 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/progression.rs:159 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/spells.rs:101 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/annie_w.rs:29 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lib.rs:685 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lib.rs:744 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/damage.rs:53 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:157 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:32 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:10 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/shop.rs:261 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/shop.rs:215 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/world.rs:226 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/damage.rs:38 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:26 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/spells.rs:5 | current Taric unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/cooldown.rs:10 | generic percentage CDR cap,not Gemcraft two-second subtraction;not exercised by this diagnostic |
| crates/core/src/cooldown.rs:11 | generic CDR conversion,not Gemcraft triggered reduction;not exercised by this diagnostic |
