# AUD-17.1-04-SUMMONERS-01 — Deux sorts invocateur et récupération

Contrôles : 2026-10-30T19:37:02.527696+00:00. Goal SYS-01.2-02 actif et incomplet ; lot précédent inventaire classé progrès documentaire. Aucun changement de goal, du suivi ou de ses bases.

## R1 — Exigence, portée et décision de clôture

**SYS-17.1-04** : « Afficher les deux sorts invocateur et leur récupération ». Exigence stable **OLF-74f21ee3-ab37-5499-a7fe-3f00bda53d66**, inconnue **OLU-441a4e27-2e77-5363-9f8a-f3a842ef04ad**, toujours open. La tâche normative conserve a_faire, implementation_complete=false, acceptance_complete=false.

Question : quelles sources et données alimentent les deux emplacements D/F, leurs icônes/états, textes et anneaux ; quelle couverture réelle du catalogue et quelle autorité du temps sont établies ? Ce lot couvre l’état documentaire de toute cette exigence. Il conserve les limites d’implémentation, de sélection et de règle historique ; il ne ferme pas les mécanismes de tous les invocateurs ni leur rendu réel.

| Dimension | Conclusion |
|---|---|
| Audit | Clôture documentaire après contrôle indépendant des sept rubriques dans delivery-readback.json. Le reçu brut reste audit_scope_closed=false et ne se valide pas lui-même. |
| Implémentation | Partielle : deux slots D/F, cinq noms enum, icônes/états/textes/anneaux raccordés ; huit autres noms du catalogue non admis ; profils et variantes historiques encore partiels. |
| Vérification | Données, sources, consommateurs et refus relus ; captures de primitives natives et résultats numériques antérieurs hérités. Aucun nouveau test Rust, jeu, réseau ou GPU. |
| Acceptation humaine | Non demandée ; aucune acceptation déduite des contrôles. |

Référence : LoL PUBLIC 4.20.0.315 / Releases/4.20, EUW/en_GB ; catalogue local 4.20.1 distinct du build. Date de compilation distincte d’une date de déploiement. Portée actuellement chargée : HUD ShadowIsles normal. Les restrictions de mode/niveau et la priorité de chargement natives ne sont pas déduites du seul catalogue.

Prérequis : phase D17, lot D17-SYS-17-1 qui requiert D05-SYS-05-5 encore a_faire. Les relations de sélection/transmission SYS-08.3-01/02/03/04 et SYS-08.4-03 sont réutilisées comme preuves et travaux connexes, sans modifier les dépendances normatives. La fiche audit-unit.json définit ce lot uniquement ; aucun critère du goal ou du plan n’est changé.

## R2 — Sources, identité et données conservées

HUD.zip local et original : 122169 octets, SHA-256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`.

- F:/OpenLeague/data/4.20/archives/menu/HUD.zip.
- D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/menu/HUD.zip.

Binaire associé aux captures natives héritées : League of Legends.exe du même déploiement, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Identité relue, pas d’exécution actuelle. L’égalité des archives ne prouve pas leur priorité historique de montage.

Les deux membres sont réellement dans la liste normale et correspondent au manifeste HUD consommé. Les 20 définitions — six Icon, huit Effect et six Text — sont reliées au chemin/offset/propriétés et aux captures par élément héritées. Les six Text reprennent les identifiants HUD existants.

| Membre sous HUD/Elements | Octets | SHA-256 |
|---|---:|---|
| CenterHUD_AbilitiesSpellSummoner0.ini | 3343 | `20ecebd6193a83d80860408065875a2d7dcbfdf028b0f43a0a304f5cb68220d7` |
| CenterHUD_AbilitiesSpellSummoner1.ini | 3345 | `32f449cc7753b1a25d3780d87814a6f16ae9891eff8a11cb5cc92d7b17983414` |

Par slot : icône, HighlightFX, Text Cooldown, Text Ammo, effet CooldownFX, effet AmmoFX, SheenFX, overlay, Text HotKey et fond HotKeyBG. Douze composants ont un consommateur actuel (six icônes/overlays/fonds, quatre Text, deux effets Cooldown). Les huit autres définitions restent classées sans devenir automatiquement huit fonctionnalités obligatoires : Ammo/AmmoFX, HighlightFX et SheenFX exigent un contexte natif applicable.

Les cinq ponts configuration INIBIN originale → DDS original → DDS consommé sont comparés. Chaque image est un DDS de 64×64 conservé à l’identique ; aucune nouvelle texture reconstruite. Les sources native_summoner_hud.json et native_summoners_420.json sont distinctes : la première se déclare incomplete/implemented_spells_only, la seconde contient 13 noms et IDs de catalogue 4.20.1.

| Sort courant | Nom natif | Profil local (secondes) | Cooldown du catalogue local |
|---|---|---:|---|
| Barrier | SummonerBarrier | 210.0 | [210] |
| Heal | SummonerHeal | 240 | [300] |
| Exhaust | SummonerExhaust | 210 | [210] |
| Ignite | SummonerDot | 180.0 | [180] |
| Smite | SummonerSmite | 90 | [90] |

Les 13 configurations originales portant les noms du catalogue existent ; leur disponibilité et empreinte sont enregistrées, sans nouveau décodage complet ni admission automatique. Les huit noms non pris en charge sont : SummonerBoost, SummonerClairvoyance, SummonerFlash, SummonerHaste, SummonerMana, SummonerOdinGarrison, SummonerRevive, SummonerTeleport. Garrison, par exemple, ne porte que ODIN dans le catalogue ; les modes de catalogue ne sont pas un payload de désactivation historique EUW4.20.

Les preuves de sélection existantes et leurs cinq sources principales sont relocalisées E→F par chemin et SHA identique ; anciens chemins conservés comme provenance. AIR/catégories/IDs et transport local restent distingués. Aucun choix implicite de tous les sorts sur Map10.

## R3 — Consommateurs et contrats exacts

| Consommateur | Observation actuelle | Limite |
|---|---|---|
| core/summoners.rs:5–89 | Enum Barrier/Heal/Exhaust/Ignite/Smite ; Loadout.spells et ready_at ont chacun deux entrées. Doublon non nul refusé avant création ; slots vides permis. | Ce type ne couvre pas les 13 IDs historiques et ne versionne pas leur correspondance. |
| native_hud_summoners.rs:8–36 | SLOT_COUNT=6 combine Q/W/E/R puis les deux invocateurs aux indices4/5 ; noms, layouts et labels D/F sont reliés. | Six positions communes ne signifient pas six invocateurs. Remappage clavier natif complet non qualifié. |
| même module :38–101 | Remaining vient de ready_at moins tick avec saturation ; total provient des règles locales de base, Smite getter provisoire. États et traces exposent cette origine. | Aucun total de récupération autoritaire propre aux invocateurs dans leur Loadout ; les cooldown_totals du champion concernent QWER. |
| native_hud_spells.rs:8–56 | Charge les cinq DDS et sélectionne six composants d’icône D/F au sein des 14 panneaux QWER/D/F. État/couleur d’overlay calculé, image absente omise sans substitut. | Renderer partagé et données QWER peuvent provoquer un refus du groupe ; variantes/recasts/masques complets restent ouverts. |
| native_hud_widgets.rs:66–127 | Deux HotKey et deux Cooldown Text ; le formatteur utilise ready_at/tick et NumericCooldownFormat. | Erreurs/absence effacent ; les labels restent D/F même pour slot vide, mais le texte de récupération n’est ajouté que si un sort est équipé. Pas de parité des glyphes/CRT/pixels déduite. |
| native_hud_recharge_live.rs:7–47 | Sélectionne six sources CooldownFX dont deux invocateurs ; calcule les paramètres, dessine secteur et ligne, masque sur erreur ou source de joueur absente. | remaining>profil de base est refusé par l’adaptateur et peut masquer le groupe commun ; pas de durée totale propre récupérée depuis le serveur historique. |
| native_hud_recharge.rs:1–20 | Angle normalisé depuis remaining/total ; garde non fini, total nul/négatif et overflow. | Le helper mathématique seul ne valide ni le producteur de durée ni le rendu natif. |
| summoner_heal.rs:75–84 ; summoner_smite.rs:28–34 | Les producteurs locaux utilisent les mêmes règles que le HUD pour l’échéance Heal et la durée Smite provisoire. | Cohérence locale distincte d’une qualification historique du serveur. |
| main.rs:1394–1452,687–717 | D/F construisent l’action pour le slot correspondant ; plugins textes, icônes et récupération sont réellement enregistrés. | Aucun nouveau parcours entrée/réseau/rendu exécuté. |
| launcher/src-tauri/src/main.rs:34–68 | Accepte les cinq noms du même périmètre ; preuves de sélection/transmission réutilisées. | Niveau du compte, mode, IDs historiques et paires interdites restent les sujets des tâches SYS-08 déjà ouvertes. |

D et F sont vérifiés dans Input.ini, section GameEvents, evtCastAvatarSpell1=[d] et evtCastAvatarSpell2=[f], puis comparés au manifeste utilisé. La présence de ces valeurs ne prouve pas le chargeur/merge natif, tous les layouts de clavier ou le remappage.

Les deux WGSL actuels de secteur/ligne et le HLSL source Cooldown.ps_2_0 existent et sont identifiés. Leur présence et les captures de mathématiques ne prouvent pas une équivalence des pixels, de gamma, de projection ou de blending.

**Soin — écart déjà documenté, conservé :** heal_rules.json impose 240, déclare native_cooldown_conflict=300 et cite une copie de communiqué4.5. Le reçu heal_source_validation.json conserve Cooldown/Cooldown1/Cooldown2=300 côté client et le même override240. Cette différence n’est pas découverte comme une modification accidentelle dans ce lot ; elle est reclassée avec ses autorités et limites. ready_at et le dénominateur HUD local utilisent tous deux240. Une comparaison au catalogue300 ne suffit pas à décider de changer le code à300.

Le même reçu contient CastRange=25000 et CastRangeDisplayOverride=850 ; la portée locale850 correspond au champ d’affichage. Ne pas conclure à une erreur de portée à partir du seul champ25000 ni confondre acquisition/présentation et règle de ciblage serveur.

**Recherche bornée de provenance :** le lien secondaire déjà cité dans heal_rules a été ouvert pour classer sa provenance. Les deux adresses officielles essayées n’ont fourni aucun corps exploitable via l’outil (inaccessible / timeout). Les recherches ont renvoyé des résultats communautaires hors du périmètre primaire demandé, écartés des conclusions techniques. Journal : heal-source-search.json. Aucune page communautaire ne tranche ici la règle serveur4.20 ; aucune copie intégrale d’article enregistrée. Reprise : source primaire Riot/archive ou override/caller serveur exact. Cela n’établit pas l’inexistence d’une source officielle.

URL secondaire conservée comme provenance déclarée, sans autorité technique adoptée : https://www.nerfplz.com/2014/04/official-patch-45-notes-released.html. Essais primaires : https://www.leagueoflegends.com/en-us/news/game-updates/patch-4-5-notes/ et https://na.leagueoflegends.com/en/news/game-updates/patch/patch-45-notes.

**Smite :** le getter90 reste explicitement provisoire. Son accord numérique avec le catalogue90 ne démontre pas le serveur Map10, les modificateurs, les variantes ou une politique de munitions. Les champs génériques Ammo du layout et l’absence de valeur maxammo dans ce catalogue ne permettent pas d’inventer un mécanisme de charges.

Recherche nouvelle des familles SummonerSpellAmmo/AmmoFX/HighlightFX/SheenFX sur les 1168 sources Rust/JS/HTML identifiées : aucun consommateur supplémentaire trouvé ; chemins et hashes inchangés. Recherche lexicale délimitée complétée par les sélecteurs réels, pas une preuve d’absence sémantique universelle.

## R4 — Attendu/observé, refus et contrôles exécutés

| Cas / contrôle | Attendu ou résultat du code examiné | Statut de preuve |
|---|---|---|
| Sources | Deux fichiers sélectionnés, 20 composants, six Text, cinq DDS originaux/copies | Comparaisons fraîches conformes ; capture native héritée. |
| Slot vide | État1, pas d’icône/overlay principal ni anneau ; fond/label peuvent rester | Déduction de code, pas de nouvelle exécution. |
| Équipé, vivant, prêt | État0 si autorisé ; récupération absente à zéro | Déduction de code. |
| Mort prêt / mort en récupération | État3 si prêt/interdit ; priorité de cooldown donne état4 si remaining>0 | Déduction du sélecteur local ; ne pas affirmer masquage systématique à la mort. |
| Santé non finie / source absente | Erreur ou retrait/masquage des routes correspondantes | Branches citées, non exécutées ici. |
| Remaining supérieur au profil | Anneau refusé ; le Text suit sa propre garde de format | Distinction explicite, pas de parité native revendiquée. |
| Doublon équipé / slot invalide | Refus du core ; deux slots vides restent possibles | Code relu ; sélection serveur historique encore ouverte. |
| Heal240 / catalogue300 | Conserver le contrat local et déclarer l’écart historique | Règles/fichiers identiques, aucune correction appliquée. |
| Capture helper | SSE256 ; sélecteur384 et couleurs192 déjà conservés | Héritage daté, pas de nouvelle exécution native ou de test Rust. |
| Conservation | Aucun changement de contexte/code/registre | 25 fichiers protégés, cinq registres, HEAD et76 fichiers suivis déjà modifiés identiques avant/après. |

**Exécuté :** vérificateur Python existant -X utf8 -E -B verify_summoners.py, prévalidé syntaxiquement, code0 : **245 contrôles documentaires réussis**. Lectures ZIP/JSON/mmap, empreintes, liens par composant/ressource, comparaison de code, recherche délimitée, lecture Git et consultation web bornée ci-dessus. Tous les attendus/observés sont dans checks du reçu.

**Héritage conservé :** NUMERIC-01 et les quatre Text D/F avec leurs limites ; contrats natifs de récupération256 cas et état384/couleurs192 avec complete=false. Leurs entrées viennent de contextes fournis pour les accesseurs/profils ; elles ne qualifient pas toutes les données d’acteur ni l’autorité de l’échéance. Les totaux d’anciens tests ne sont pas recopiés comme résultats actuels.

**Non exécutés :** Cargo, compilation, tests Rust, jeu historique/courant, émulateur, REA, réseau de partie, GPU ou capture, application de suivi ou base, installation, migration, changement du goal. Les fonctions de tests présentes dans le code sont seulement des cas disponibles ; aucune partie ni acceptation technique globale inventée.

Une recherche préparatoire de nom native_hud_recharge_gpu.rs ne désignait aucun module actuel ; l’inventaire a identifié recharge_live, material et line réellement utilisés. Aucun manque de renderer n’est déduit de ce mauvais nom. Le producteur livré n’a pas échoué ; aucun ancien fichier réécrit.

## R5 — Manques, limites et conditions de reprise

- Catalogue : conserver les cinq sorts actuels et ajouter seulement un nom précisément admis avec ses ID/mode/niveau/protocole/icône/état ; les huit autres noms sont individualisés ci-dessous. Les13configurations présentes ne réalisent pas leurs mécaniques.
- Heal : nouvelle entrée requise = preuve primaire de la règle4.20/override et contexte de modificateur. Conserver240, le conflit300 et les résultats locaux ; ne pas réécrire une valeur en se fondant sur le catalogue seul.
- Smite : qualifier le profil provisoire pour le mode retenu. Pour toute variation de durée, identifier une durée totale autoritaire/version et sa correspondance ready_at avant de modifier le dénominateur.
- Ammo/effets : démontrer l’applicabilité pour un sort nommé avant de connecter des munitions, highlight ou sheen. Un composant générique non sélectionné ne vaut pas un défaut fonctionnel prouvé.
- Présentation : préciser le refus du groupe partagé QWER/D/F, l’indépendance compteur/anneau et la fraîcheur/session ; le contrôle spécifique RespawnTimer des widgets ne prouve pas une garde globale D/F.
- Validation réelle : scénario nommé avec deux emplacements, cast/refus, retour prêt, mort/pause/reconnexion/changement de paire, ressource manquante et viewport ; réutiliser tests et sources actuels avant toute recherche de texture.

Règle d’arrêt satisfaite pour ce lot documentaire : ressources et consommateurs identifiés, écarts bornés et entrées nécessaires explicites. Pas de répétition des mêmes recherches web/binaires sans source primaire nouvelle, nouveau caller, changement de consommateur ou anomalie pertinente. Les inconnues fonctionnelles ne sont ni remplies par une hypothèse ni transformées en blocage artificiel de l’audit.

## R6 — Actions existantes réutilisées et petites propositions

Ces fiches sont des résultats d’audit, sans adoption dans le plan et sans modification des critères normatifs. Chaque proposition porte un résultat indépendant et un seul sort lorsqu’un ajout est nécessaire. Les tâches SYS-08.3 et SYS-08.4 déjà identifiées restent les consommateurs de disponibilité/IDs/transmission ; aucune reconstruction concurrente du launcher.

| Référence existante | Portée réutilisée |
|---|---|
| NUM-COOLDOWN-PRINTF-01 | Octets/locale CRT du format de récupération ; ne décide pas le cooldown serveur. |
| NUM-KEY-LABEL-01 | Binding réel/label court/remappage D/F ; défauts de clavier non inventés. |
| NUM-CURRENT-RENDER-01 | Qualification des Text concernés dans le renderer existant. |
| SYS-08.3-01/02/03/04 ; SYS-08.4-03 | Catalogue, paires, mode/niveau, IDs/version et transmission de la paire, chacun dans sa portée. |

| Proposition non appliquée | Résultat et fin proposée | Condition de reprise |
|---|---|---|
| `HUD-SUM-HEAL-PROFILE-01` | Qualifier la provenance du profil Heal240 face au client/catalogue300 — Autorité exacte4.20 et portée mode/modificateur établies ; état serveur/ready_at/dénominateur/counter cohérents pour un cas nominal et ses refus. Préserver240 tant qu’aucune correction distincte n’est autorisée. | Source primaire Riot/archive ou override/caller serveur exact ; copie secondaire citée dans heal_rules ne prouve pas à elle seule cette exécution4.20. |
| `HUD-SUM-SMITE-PROFILE-01` | Qualifier le profil provisoire Smite90 pour le mode retenu — Producteur d’échéance et durée de référence/version/modificateurs identifiés puis comparés au HUD, sans faire du nombre90 une preuve serveur. | Règle native ou contrat local nommé pour Map10 ; conserver le getter provisoire existant. |
| `HUD-SUM-AMMO-SCOPE-01` | Qualifier l’applicabilité de Ammo pour un invocateur nommé — Démontrer si le sort nommé utilise des munitions dans la référence avant d’exposer compte/progression ; absence/inconnu distincts de zéro. | Producteur/caller et état d’instance qualifiés ; les deux Text et deux FX génériques ne prouvent pas que Smite4.20 avait des charges. |
| `HUD-SUM-ERROR-BOUNDARY-01` | Qualifier la frontière de refus du renderer partagé QWER/D/F — Cas QWER/total invalide avec invocateur valide, session absente et dépassement de profil documentés ; portée du masquage commun assumée ou isolée sous contrat explicite. | Nouveau test d’intégration pertinent ou règle native ; un helper QWER peut actuellement faire masquer le groupe partagé. |
| `HUD-SUM-RENDER-LIFECYCLE-01` | Qualifier le parcours visuel de deux slots équipés — Un sort nommé par slot, cast/refus/retour prêt, changement de paire, mort/session/pause et défaut de ressource observés dans le client réel avec versions/viewport ; aucune parité GPU déduite de la présence du WGSL. | Client/transport prêts et scénario nommé ; réutiliser d’abord les sources et tests existants. |
| `HUD-SUM-CATALOG-SummonerBoost-01` | Admission HUD indépendante de SummonerBoost — Sort/mode/ID et prise en charge de gameplay/transport identifiés, icône/source/état et paire D/F vérifiés, refus des autres modes/valeurs documentés. Fin limitée à ce sort. | Configuration native disponible ; réutiliser SYS-08.3-01/02/03/04 et SYS-08.4-03 pour disponibilité/IDs/transmission. Aucune activation automatique des treize noms. |
| `HUD-SUM-CATALOG-SummonerClairvoyance-01` | Admission HUD indépendante de SummonerClairvoyance — Sort/mode/ID et prise en charge de gameplay/transport identifiés, icône/source/état et paire D/F vérifiés, refus des autres modes/valeurs documentés. Fin limitée à ce sort. | Configuration native disponible ; réutiliser SYS-08.3-01/02/03/04 et SYS-08.4-03 pour disponibilité/IDs/transmission. Aucune activation automatique des treize noms. |
| `HUD-SUM-CATALOG-SummonerFlash-01` | Admission HUD indépendante de SummonerFlash — Sort/mode/ID et prise en charge de gameplay/transport identifiés, icône/source/état et paire D/F vérifiés, refus des autres modes/valeurs documentés. Fin limitée à ce sort. | Configuration native disponible ; réutiliser SYS-08.3-01/02/03/04 et SYS-08.4-03 pour disponibilité/IDs/transmission. Aucune activation automatique des treize noms. |
| `HUD-SUM-CATALOG-SummonerHaste-01` | Admission HUD indépendante de SummonerHaste — Sort/mode/ID et prise en charge de gameplay/transport identifiés, icône/source/état et paire D/F vérifiés, refus des autres modes/valeurs documentés. Fin limitée à ce sort. | Configuration native disponible ; réutiliser SYS-08.3-01/02/03/04 et SYS-08.4-03 pour disponibilité/IDs/transmission. Aucune activation automatique des treize noms. |
| `HUD-SUM-CATALOG-SummonerMana-01` | Admission HUD indépendante de SummonerMana — Sort/mode/ID et prise en charge de gameplay/transport identifiés, icône/source/état et paire D/F vérifiés, refus des autres modes/valeurs documentés. Fin limitée à ce sort. | Configuration native disponible ; réutiliser SYS-08.3-01/02/03/04 et SYS-08.4-03 pour disponibilité/IDs/transmission. Aucune activation automatique des treize noms. |
| `HUD-SUM-CATALOG-SummonerOdinGarrison-01` | Admission HUD indépendante de SummonerOdinGarrison — Sort/mode/ID et prise en charge de gameplay/transport identifiés, icône/source/état et paire D/F vérifiés, refus des autres modes/valeurs documentés. Fin limitée à ce sort. | Configuration native disponible ; réutiliser SYS-08.3-01/02/03/04 et SYS-08.4-03 pour disponibilité/IDs/transmission. Aucune activation automatique des treize noms. |
| `HUD-SUM-CATALOG-SummonerRevive-01` | Admission HUD indépendante de SummonerRevive — Sort/mode/ID et prise en charge de gameplay/transport identifiés, icône/source/état et paire D/F vérifiés, refus des autres modes/valeurs documentés. Fin limitée à ce sort. | Configuration native disponible ; réutiliser SYS-08.3-01/02/03/04 et SYS-08.4-03 pour disponibilité/IDs/transmission. Aucune activation automatique des treize noms. |
| `HUD-SUM-CATALOG-SummonerTeleport-01` | Admission HUD indépendante de SummonerTeleport — Sort/mode/ID et prise en charge de gameplay/transport identifiés, icône/source/état et paire D/F vérifiés, refus des autres modes/valeurs documentés. Fin limitée à ce sort. | Configuration native disponible ; réutiliser SYS-08.3-01/02/03/04 et SYS-08.4-03 pour disponibilité/IDs/transmission. Aucune activation automatique des treize noms. |

| ID HUD existant | Text | Consommateur actuel |
|---|---|---|
| `HUD-2e6f399e46258a9f` | SummonerSpellCooldown0 | native_hud_widgets |
| `HUD-3784fb1f1fa30749` | SummonerSpellAmmo0 | non sélectionné ; applicabilité à qualifier |
| `HUD-91f2233252ace500` | SummonerSpellHotKey0 | native_hud_widgets |
| `HUD-f4ec1688bd39bde0` | SummonerSpellCooldown1 | native_hud_widgets |
| `HUD-2a7dd42d17a0de94` | SummonerSpellAmmo1 | non sélectionné ; applicabilité à qualifier |
| `HUD-b9d67dc0aa9a45e7` | SummonerSpellHotKey1 | native_hud_widgets |

## R7 — Livraison, preuve et relecture

Nouveaux fichiers uniquement :

- F:/OpenLeague/docs/audit/units/AUD-17.1-04-SUMMONERS-01.md, ce rapport.
- F:/OpenLeague-work/audit-units/AUD-17.1-04-SUMMONERS-01/ : audit-unit.json, heal-source-search.json, verify_summoners.py, summoner-hud-proof.json, verify_delivery.py, delivery-readback.json.

Reçu principal : SHA-256 `2ad900dafd21e3e7a48224814950f3f1888ac20fecec8042dc572e93b7723e08`. Le reçu contient les versions/empreintes,20 composants, six IDs,13disponibilités de configuration, cinq ponts d’icône et profils, bindings, contrats hérités, consommateurs avec lignes et attendus/observés. Les sources de shaders sont identifiées ; leurs pixels ne sont pas déclarés observés.

Le lecteur indépendant recoupe les sources actuelles, les composants/IDs et les profils, le conflit Heal conservé, la séparation des types de sources, les fichiers protégés et les sept rubriques. delivery-readback.json porte la clôture documentaire si tous ses contrôles réussissent. La fonctionnalité et le goal restent incomplets.

Recontrôle sans écriture : Python existant -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-17.1-04-SUMMONERS-01/verify_delivery.py --check-only. Reçus exclusifs, aucune preuve remplacée. Les 19 fichiers logiciels gelés et six documents de contexte restent identiques ; les cinq registres normatifs sont conservés. Aucun accès à une base et aucun lancement du suivi.

Résolu : liaisons des deux emplacements, icônes et producteurs de récupération établies ; périmètre cinq/treize et composants optionnels distincts ; Heal/Smite et provenance classés sans modification aveugle. Ouvert : autorité historique des profils/modificateurs, huit admissions nommées, applicabilité des variantes et comparaison fonctionnelle/graphique. Audit terminé ne signifie pas fonctionnalité terminée.

## R8 — Addendum du 2026-11-03 — SYS-01.2-02 : SummonerBoost / Cleanse, source native → consommateur actuel

**Lot et portée.** Relecture statique d’un lien source-consommateur, en réutilisant R2–R3 ci-dessus et le reçu de membership natif. Ce complément ferme le constat de liaison et de refus statique pour cette entrée seulement ; il ne ferme ni la tâche fonctionnelle Cleanse, ni SYS-01.2-02 global.

**Source native.** Le fichier fourni D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\SummonerBoost.inibin fait 699 octets, SHA-256 282F624C129929A2FA5785673642D71CACB780C0B40BA41CD453D00539B1E59E, MD5 854F2E1F37DED410B9B3D505B9E84A7A. native-release-membership.json le relie au membre lol_game_client, release 0.0.1.7, avec les mêmes taille et MD5. Le lecteur local en lecture seule tools/project-plan/reference_inibin.py décode 61 clés : SpellData*Cooldown (hash 1229951523) = 210.0000 et SpellData*CastRange (hash 3806805222) = 200.0000. Ces valeurs sont celles du fichier client ; CastRange ne prouve pas à lui seul la sémantique cible/portée serveur.

Le catalogue local distinct data/4.20/native_summoners_420.json est versionné 4.20.1, SHA-256 6E2077BEBE889F34B8E27E01DBB7E0B9CC61A8E0B799CDF1226F498751559FC5. Il associe SummonerBoost à « Cleanse », cooldown 210, summonerLevel 6, range self et aux modes listés dans ce catalogue. Ce catalogue 4.20.1 n’est pas une preuve de disponibilité historique EUW/Map10 dans le build client 4.20.0.315.

**Consommateur courant.** crates/core/src/summoners.rs, SHA-256 7AF19297380715624CB37F70AB62DFA9A65F7C8665E49B7699EE495D7A0D56A3, ne déclare que Barrier, Heal, Exhaust, Ignite et Smite dans Spell; le nom natif et le dispatch de cast ne couvrent que ces cinq. crates/core/src/session_transport.rs, SHA-256 139A7CE15AC5261DEE15FE0AA60716FB1BB6993ECD9ACB0D41C34ACB84AB00BC, transporte deux Option<Spell> dans JoinRequest. L’état nominal de contrôle reste donc un sort déjà déclaré, par exemple Barrier. Pour Cleanse, aucun chemin de succès n’existe dans le code consulté : une valeur JSON Cleanse ou SummonerBoost ne correspond à aucune variante dérivée de Spell et devrait être refusée au décodage. C’est une conclusion statique ; le message exact et le refus runtime n’ont pas été exécutés. Aucun test, build ou lancement n’a été fait.

**Attendu / observé.** Attendu pour cette liaison d’audit : retrouver la ressource native versionnée et déterminer si le consommateur courant la représente. Observé : source présente et membre du manifeste ; paramètres 210/200 décodés ; Cleanse absent du type, du mapping et du dispatch actuels. Le lien est donc documenté avec un refus statique prévisible, mais aucune exécution nominale de Cleanse n’est possible à attester.

**Ouvert et reprise.** SUMMONER-SummonerBoost-SCOPE reste a_qualifier; aucun registre ni statut n’a été modifié. Restent à établir par source primaire 4.20 : disponibilité par carte/mode EUW, règle réelle de déblocage, sémantique des cibles/effets et comportement serveur. Reprendre seulement sur une configuration/code serveur daté ou un payload AIR 4.20 identifié et vérifiable ; ne pas déduire ces points du catalogue 4.20.1 ni répéter les recherches déjà faites sans nouvel indice.
