# Audit SYS-01.2-02 — Soraka Q, VFX et consommateur courant

Date : 2026-11-02. Tâche requise : `CH-Soraka-Q-PRESENTATION-VFX` (`OLF-447b598f-df68-5a00-aa41-eca862755334`). L’inconnue liée reste ouverte : `OLU-1daf7b06-3671-5558-a3bf-c6c5dd60df04`. Le registre la classe `partial_with_open_questions`; aucun statut n’est modifié.

## Sources 4.20 et résultat attendu

Les deux fichiers natifs associés sont dans le client fourni PUBLIC 4.20, release de projet 0.0.1.68 :

| Fichier | Octets | SHA-256 observé | SHA-256 du registre |
|---|---:|---|---|
| `DATA/Characters/Soraka/Soraka.inibin` | 1 899 | `c6d7f0e3f550c0faa4d3616206bfc0d9f39cd6fdfd0ed580d7971ca011571635` | identique |
| `DATA/Characters/Soraka/Spells/SorakaQ.inibin` | 1 249 | `822bef5029523babf8b2a39f1f8756ccc0dc926cd4607525cc628a8af3160c74` | identique |

Le lecteur INIBIN local confirme `Data.Spell1 = SorakaQ` dans le premier fichier, puis `SpellData.AnimationName = Spell1` dans le second. Le manifeste courant `data/4.20/animation_manifest.json` associe le rôle `spell1` au clip `Soraka_Spell1` (index 17). Cela relie les données natives à un clip chargé par le consommateur générique `crates/client/src/animation.rs:410`; cela ne prouve pas le déclenchement du sort ni un VFX.

Le décodage relève aussi les chaînes brutes `Soraka_Q.dds` et `AOE_leona_outer.dds`, mais cette vérification ne leur attribue pas de champ VFX ni d’événement. Elles ne sont donc pas présentées comme l’effet natif de Soraka Q.

## Consommateurs courants examinés

Les quatre anchors déjà attachés à cette tâche dans le registre correspondent à :

- `crates/core/src/lib.rs:598` — dispatch des commandes Cast/CastAt.
- `crates/core/src/spells.rs:101` — dispatch de sort par champion et slot.
- `crates/core/src/spells.rs:120` — refus explicite `champion spell not implemented` pour les champions sans branche.
- `crates/client/src/animation.rs:410` — chargement de l’animation de base par nom de modèle.

Dans `Simulation::cast`, les branches de sort présentes sont Garen, Annie, Trundle et Ezreal. Soraka atteint le refus explicite avant la création d’un événement de sort; aucun consommateur VFX propre à Soraka Q n’est appelé dans ce parcours. Le clip `spell1` présent dans le manifeste n’active pas à lui seul une présentation.

Deux ressources nommées Soraka apparaissent dans d’autres parcours actuels : `Soraka_Heal_Sparkle_Green.dds` est chargée par la présentation de relique dans `crates/client/src/tt_capture_live.rs`; `SorakaBasicAttack04.dds` est une texture du projectile E d’Ezreal dans `crates/client/src/ezreal_e_bolt_images.rs`. Aucune preuve consultée ne les relie à Soraka Q.

## Attendu, observé et limites

| Cas | Attendu | Observé statiquement |
|---|---|---|
| Soraka Q, slot 0 | Dispatch du sort puis demande de son VFX identifié | Le dispatch actuel refuse Soraka avec `champion spell not implemented`; aucun événement ou appel VFX Q n’est atteint |
| Animation déclarée | `AnimationName=Spell1` rejoint un rôle local compatible | Le rôle `spell1` et le clip `Soraka_Spell1` existent dans le manifeste; aucune activation Soraka Q n’est établie |
| VFX/asset | Source native, ressource précise, événement et consommateur associés | Le trace n’associe que les deux INIBIN cités; l’identité exacte du VFX et son événement restent inconnus |

La recherche ciblée dans `crates/core/src` et `crates/client/src` n’a trouvé aucune branche ou fonction Soraka Q. Ce constat borne les consommateurs inspectés; il ne démontre pas l’absence d’autres ressources ou callbacks dans tout le client natif. Aucun test, build, lancement ou rendu n’a été exécuté pendant ce lot.

**Clôture du sous-audit :** les deux sources sont identifiées et fraîches, le consommateur générique courant et son refus de Soraka sont nommés, et l’absence de chemin local Soraka-Q-VFX est documentée. **La tâche VFX et sa fonctionnalité restent ouvertes** jusqu’à l’identification du champ/asset natif et du déclencheur, puis à leur intégration et vérification runtime. Le goal parent SYS-01.2-02 et la complétion de Soraka restent ouverts.

## Conditions de reprise

1. Résoudre les champs INIBIN des chaînes `Soraka_Q.dds` et `AOE_leona_outer.dds` avec un mapping de hash vérifié; identifier le vrai asset de particule/effet et son appartenance source.
2. Établir le déclencheur natif Soraka Q et le callsite de présentation courant; intégrer le passage sort → événement VFX.
3. Vérifier le nominal et les refus dans le moteur local, puis une capture de rendu identifiée. Garder animation, VFX, audio et acceptation visuelle comme critères distincts.

Contrôles effectués : comparaison des SHA-256 des deux INIBIN de D aux valeurs du registre; décodage ciblé des champs `Data.Spell1` et `SpellData.AnimationName`; inspection statique des anchors et du refus de sort; lecture du manifeste d’animation et vérification des usages locaux des textures homonymes. Aucun registre, goal, statut, code, Plan, UI ou base de données modifié.

## Résolution bornée des deux noms DDS (2026-11-02)

Lecture ciblée du SorakaQ.inibin natif avec tools/project-plan/reference_inibin.py, puis vérification des ressources exactes dans le déploiement D et des reçus RADS locaux :

| Valeur dans SorakaQ.inibin | Correspondance vérifiée | Identité de la ressource native | Conclusion |
|---|---|---|---|
| Soraka_Q.dds, clé 2059614685 | SpellData*InventoryIcon | DATA/Characters/Soraka/HUD/Icons2D/Soraka_Q.dds; 2 176 octets; SHA-256 1330b6a1824f1fb29e23a4c122a8b252f709d5d15427494eb18491108f65014c | Icône HUD du sort. Ce nom ne désigne pas son VFX. |
| AOE_leona_outer.dds, clés brutes 3401378034 et 4156942032 | Propriété INIBIN non résolue | DATA/Spells/Textures/AOE_leona_outer.dds; 349 680 octets; SHA-256 df2c275c006ab70ed43248a33cd010b9759b0c7fa4da48fa900ea005a8c34e80 | Texture partagée présente dans le client natif; aucun lien d’usage propre à Soraka Q établi. |

Les trois SHA-256 observés dans le déploiement D (les deux DDS et SorakaQ.inibin) correspondent aux valeurs des reçus et du registre déjà inspectés. Une liste ciblée de noms de champs d’icône, de ciblage, d’AOE, de particules et de missiles n’a pas résolu les deux clés brutes de la seconde ligne. La recherche de fichiers portant exactement ces deux noms dans assets/ et data/4.20/ n’a trouvé que les reçus de source, pas de DDS importé portant ce nom.

**Résultat de ce lot :** le faux candidat Soraka_Q.dds est écarté du périmètre VFX et l’identité de la texture globale AOE est confirmée. La relation hash → propriété → rôle de la texture AOE, son déclencheur natif et son consommateur local restent inconnus. Le chemin courant de sort conserve le refus explicite documenté plus haut. La fonction VFX, l’inconnue OLU-1daf7b06-3671-5558-a3bf-c6c5dd60df04 et le goal parent restent ouverts.

**Reprise précise :** ne pas rechercher à nouveau Soraka_Q.dds. Reprendre la piste AOE uniquement avec une table de hash vérifiée pour 3401378034/4156942032, un lien natif Soraka Q vers un événement/asset d’effet, ou une capture native exploitable. À défaut, passer à une autre exigence requise dont les sources et consommateurs actuels disposent déjà de preuves réutilisables. Aucun test, build, lancement ou rendu n’a été exécuté.

## Liaison de l’icône Soraka Q à l’interface courante (2026-11-02)

Le manifeste data/4.20/native_spell_icons.json contient Soraka / slot 0 / SorakaQ / InventoryIcon et l’asset local assets/ui/native420/spells/soraka/0-InventoryIcon.dds. Les deux fichiers ont 2 176 octets et un SHA-256 identique : 1330b6a1824f1fb29e23a4c122a8b252f709d5d15427494eb18491108f65014c.

Le consommateur courant est relié statiquement : crates/client/src/native_hud_spells.rs:35-38 charge les entrées InventoryIcon dans le cache d’images; :47 sélectionne l’icône par champion et slot; :48-52 prépare et crée le panneau. crates/client/src/main.rs:717 enregistre le plugin. Pour Soraka/slot 0, le chemin de sélection rejoint donc l’asset importé de l’icône Q. Le comportement nominal est établi par lecture des données et du code, pas par un lancement.

La limite de fermeture est précise : le manifeste n’est pas complet (486 icônes primaires récupérées sur 488 requises; complete=false), même si l’entrée Soraka Q existe. Le rendu réel, la fidélité visuelle de l’icône à l’écran et les variantes de forme/recast ne sont pas vérifiés ici. Le test existant all486_source_primary_icon_payloads_and_fourteen_widgets_are_preserved n’a pas été exécuté. Ce lien ferme l’audit statique source → asset → consommateur pour l’icône Soraka Q; il ne réalise ni ne valide son VFX. La fonction Soraka Q reste refusée par le parcours courant et OLU-1daf7b06-3671-5558-a3bf-c6c5dd60df04 reste ouverte.

