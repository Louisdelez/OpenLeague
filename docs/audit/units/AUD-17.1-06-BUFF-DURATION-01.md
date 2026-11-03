# AUD-17.1-06-BUFF-DURATION-01 — Buffs, debuffs et durée autorisée

Contrôles : 2026-10-30T19:03:32.555953+00:00. Goal SYS-01.2-02 conservé actif et incomplet. Le lot précédent SYS-17.1-08 est classé progrès documentaire, sans clôture fonctionnelle.

## R1 — Exigence, périmètre et décision

**SYS-17.1-06** : « Afficher les buffs et debuffs avec leur durée autorisée ». Exigence stable **OLF-83708898-03fe-5ac8-bcd6-f7cebe2bed4e**, inconnue antérieure **OLU-44e36fd3-396b-5405-9efd-a04f638cfcb5**, toujours open. Le registre conserve a_faire, implementation_complete=false, acceptance_complete=false.

Question : quelles sources fournissent les icônes, décorations positives/négatives, piles, effets de durée et panneaux de perte de contrôle ; quels consommateurs actuels reçoivent réellement une échéance autorisée ? Ce lot achève la description documentaire des clauses de cette exigence, au-delà des seuls quarante compteurs Text de BUFF-01. Il ne réalise pas implicitement le HUD ni toutes les mécaniques de buff de chaque champion.

| Dimension | Conclusion |
|---|---|
| Audit | Clôture documentaire conditionnée aux sept rubriques et au reçu indépendant delivery-readback.json. Le reçu brut garde audit_scope_closed=false pour ne pas se valider lui-même. |
| Implémentation | Partielle : icône et nombre de piles privés du passif Ezreal dans un emplacement fixe ; données temporelles de certains autres états existantes. Allocation/affichage génériques des buffs/debuffs et durées autorisées non identifiés dans les routes inspectées. |
| Vérification | Comparaisons de sources, contrats et code effectuées ; résultats natifs et quatre essais Rust anciens réutilisés à leur date. Aucun nouveau jeu, rendu ou test Rust exécuté. |
| Acceptation humaine | Non demandée ; aucune acceptation du jeu déduite. |

Référence : LoL PUBLIC 4.20.0.315 / Releases/4.20, EUW/en_GB, catalogue officiel 4.20.1 distinct ; la date de compilation n’est pas interprétée comme date de déploiement. Portée actuelle : HUD ShadowIsles normal et classement des autres layouts de buffs fournis. Un nombre de positions de layout n’est pas un plafond serveur de buffs.

Prérequis : D17, lot D17-SYS-17-1 ; ce lot requiert D05-SYS-05-5, encore a_faire, lui-même lié à D05-SYS-05-1/02. Les prérequis fonctionnels ne sont pas promus en acquis par cet audit. Une fiche de périmètre audit-unit.json consigne la question, les entrées, les sorties et la règle d’arrêt du lot ; aucun critère normatif du goal ou du plan n’est modifié.

## R2 — Sources, provenance, variantes et réparations

Archive fournie et copie consommée : même SHA-256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`, 122169 octets.

- Copie : F:/OpenLeague/data/4.20/archives/menu/HUD.zip.
- Original : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/menu/HUD.zip.

Le binaire associé aux captures natives héritées est League of Legends.exe du même déploiement, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Son identité a été relue ; il n’a pas été exécuté ici. L’égalité des archives ne prouve pas leur priorité de montage historique ni une appartenance RADS supplémentaire.

Quatre membres sont réellement dans la liste normale actuellement chargée. Le reçu relie **261 définitions : 141 Icon, 60 Effect, 60 Text**. Chaque définition possède chemin, offset, propriétés conservées et capture native héritée. Les 60 Text reprennent leurs identifiants HUD existants : 40 compteurs de piles et 20 textes de contrôle.

| Membre sous HUD/Elements | Octets | Icon / Effect / Text | SHA-256 |
|---|---:|---|---|
| CenterHUD_Buffs.ini | 45915 | 96 / 32 / 32 | `a9d3ec42552998c63c9ac47f10d2ec7711225e1523fb083ba1011461eeb6f218` |
| TargetBar_Buffs.ini | 11247 | 24 / 8 / 8 | `ab26e62d3e67be6e21b5ffdaac138a1b7cdd93d6d8dc05bafd0ad6dcc9b567f5` |
| LossOfControlUI.ini | 8007 | 9 / 8 / 8 | `c0115dd409fdbe8e258195a2a6e837a19ea01e434b1684ae7109a2d0d094d31a` |
| LossOfControlUI_AbilityOverlay.ini | 12177 | 12 / 12 / 12 | `1382937989825dad93de3c8dfa4e9b30d4dc7b63fd140905f0df417de0b8a005` |

Pour chacun des 32 emplacements du propriétaire et huit de cible, cinq éléments sont reliés : icône, bordure négative, bordure positive, Text de pile et effet Cooldown. Les 200 éléments commencent désactivés. Les quarante effets portent EffectParams0=0,0,0,0 dans ces sources ; ces valeurs de configuration ne sont ni une échéance ni une preuve d’expiration du buff. Le rendu temporel exige un producteur d’état dynamique.

Les icônes BuffIcon0…31 et TargetBuffIcon0…7 sont des noms de liaison dynamique. Leur présence n’est pas la preuve de fichiers image manquants et ne justifie aucune génération automatique de textures. Le seul choix fixe actuel est Icons2D/Ezreal_RisingSpellForce.dds : membre d’archive et deux copies originales sous Spells/Icons2D et Characters/Ezreal/Info ont les mêmes 2176 octets, SHA-256 `c9ee974177653ac460514c0818bbeca3093cd45d336b21db4d84775688a80543`. Le code exige une image 64×64 ; aucun nouveau décodage GPU n’est revendiqué.

**Neuf layouts alternatifs conservés :** ils ne sont pas sélectionnés par la liste normale actuelle. Ce constat ne signifie pas inutilisés dans tous les modes.

| Membre alternatif | Icon / Effect / Text | Limite |
|---|---|---|
| CenterHUD_BuffGroupTracker.ini | 16 / 8 / 8 | Octets comparés à l’original ; sélection et parseur/runtime non qualifiés par ce lot. |
| LeftBuffGroupNegative.ini | 24 / 12 / 12 | Octets comparés à l’original ; sélection et parseur/runtime non qualifiés par ce lot. |
| LeftBuffGroupPositive.ini | 24 / 12 / 12 | Octets comparés à l’original ; sélection et parseur/runtime non qualifiés par ce lot. |
| RightBuffGroupNegative.ini | 24 / 12 / 12 | Octets comparés à l’original ; sélection et parseur/runtime non qualifiés par ce lot. |
| RightBuffGroupPositive.ini | 24 / 12 / 12 | Octets comparés à l’original ; sélection et parseur/runtime non qualifiés par ce lot. |
| ShadowIslesCenterHUD_Buffs.ini | 96 / 32 / 32 | Octets comparés à l’original ; sélection et parseur/runtime non qualifiés par ce lot. |
| ShurimaCenterHUD_Buffs.ini | 96 / 32 / 32 | Octets comparés à l’original ; sélection et parseur/runtime non qualifiés par ce lot. |
| TargetBuffGroupNegative.ini | 20 / 10 / 10 | Octets comparés à l’original ; sélection et parseur/runtime non qualifiés par ce lot. |
| TargetBuffGroupPositive.ini | 20 / 10 / 10 | Octets comparés à l’original ; sélection et parseur/runtime non qualifiés par ce lot. |

Les fichiers ShadowIslesCenterHUD_Buffs et ShurimaCenterHUD_Buffs ont la même empreinte entre eux, mais diffèrent de CenterHUD_Buffs malgré leur taille identique. Aucun remplacement, dédoublonnage ou choix implicite par le nom n’est effectué. TrackerBuffStack0…7 et les familles positives/négatives restent des variantes classées, sans nouveaux identifiants HUD fabriqués pour les présenter comme déjà qualifiées.

**Réparations antérieures conservées, jamais écrites à nouveau :**

- TargetBar_Buffs.ini : overlay de 11280 octets, SHA-256 `504e33f7fe6b5cadbb9d7e6e5fcaa547710b0837f5da475bbd44f217e1efe709`. Original exact suivi des 33 octets \r\nEffectColor1: 64, 64, 64, 100\r\n. Le seul rejet hérité par élément est TargetBuffCooldown7 à l’offset 11005. Boucle native héritée : original 39 éléments / 7 effets ; overlay 40 / 8.
- LossOfControlUI.ini : overlay de 8024 octets, SHA-256 `56479f80a3d33dafd77cb67b59e311dcd0d998b8d3b824ba933af16fb77b7968`. Préfixe ajouté exact de 17 octets BaseOffset: 0,0\r\n ; reste du fichier original inchangé. Boucle originale héritée : zéro affectation d’en-tête et zéro élément ; overlay : deux affectations, 25 éléments, huit effets et **deux avertissements conservés**.

Distinction indispensable : les captures par élément de LossOfControlUI utilisaient une origine fournie à zéro ; leur acceptation ne prouve pas l’acceptation du fichier entier par sa boucle d’origine. L’échec de cette boucle sur le fichier fourni ne prouve pas que le jeu historique utilisait ce même chemin ni que son fichier était corrompu. L’overlay est une adaptation locale explicite ; ses deux avertissements ne sont pas masqués comme une qualification complète.

LossOfControlUI_AbilityOverlay garde dans le contrat hérité 36 éléments et 12 effets. Aucune nouvelle exécution de ces parseurs natifs n’est effectuée. Le fournisseur actuel compare les octets originaux et les overlays aux entrées qualifiées avant de les charger ; différences ou absence ont des refus explicites dans le code.

## R3 — Consommateurs et autorité des durées

| Consommateur réel | Acquis observé dans le code | Limite |
|---|---|---|
| native_zip_provider.rs:75–138 | Charge la liste normale, applique les deux overlays identifiés, parse et lie structure/groupes/textures/effets. | Lecture et liaison distinctes d’un pilote temporel ou d’un affichage interactif. |
| native_ezreal_passive_hud.rs:13–75 | Sélectionne exclusivement Buff0 et BuffStack0 de CenterHUD_Buffs, copie/active ces deux stockages et choisit l’icône fixe Ezreal. | Affectation locale au slot zéro ; ni allocateur générique ni bordures positives/négatives ni effet de durée sélectionnés. |
| même module :97–115,195–222 | Accepte 1..5, prépare un chiffre ASCII, glyphes et icône ; absence/erreur/session/horloge/fenêtre ou ressource indisponible retire le rendu. | Aucun compte à rebours autorisé obtenu par ce chemin. |
| main.rs:687–691,1212–1215 | Plugin réellement enregistré ; les frames acceptées alimentent ezreal_passive_hud. | Canal optionnel privé ; ne démontre pas une liste de buffs publics de tous les personnages. |
| core/ezreal_passive.rs:8–19,80–90 | Politique locale six secondes, état privé Buff.until ; projection OwnerPassive={session,owner,stacks}. | Le DTO n’expose aucune échéance ni durée totale. Cette politique est une reconstruction locale, pas des callbacks serveur Riot récupérés. |
| ezreal_r_passive_presentation.rs:53–74,180–236 | Vérifie identité, joueur Ezreal vivant, roster, session, époque, tick et horloge ; erreurs masquent le canal. | FRESH_SECONDS=0.2 mesure la fraîcheur de présentation, pas la durée du passif. |
| native_hud_effect_uniforms.rs:1–14 | Convertit les paramètres et couleurs de stockage Effect. | Ce helper ne crée pas à lui seul un effet animé, une allocation, une échéance ou un rendu Cooldown. |
| core/shields.rs:1–8 ; slows.rs:1–14 ; stuns.rs:1–7 | Boucliers, ralentissements et étourdissements ont déjà expires_at. Ces états sont sérialisables et présents dans les états de jeu correspondants. | Leur présence ne prouve ni une interface générique ni la permission historique de publier chaque donnée à chaque spectateur. |
| main.rs:1673–1685 | Diagnostic de bouclier, contrôle, durée d’étourdissement et charges de Pyromanie. | Ce diagnostic n’est pas le panneau natif générique de buffs ; les effets de gameplay et feedbacks déjà présents sont conservés. |
| core/vision + session_host + réception client | Projection par spectateur et transport actuellement identifiés ; les corps invisibles sont filtrés. | La visibilité d’un corps ne qualifie pas automatiquement l’audience de toutes ses métadonnées de buff. |

Le champ privé until du passif n’est pas perdu par accident dans cet audit : sa non-transmission est explicitement observée. Il est donc faux de déduire un temps restant de la fraîcheur client ou du nombre de piles. Il serait également faux d’affirmer que toutes les durées manquent dans le jeu : des échéances existent pour les états nommés ci-dessus.

Recherche nouvelle délimitée sur les 1168 fichiers Rust/JS/HTML identifiés : noms des effets de durée, TrackerBuff, variantes positives/négatives, LossOfControlSpell/Ability, buff_duration/debuff. Deux occurrences seulement, toutes deux commentaires de gameplay dans healing.rs et summoner_exhaust.rs ; aucun branchement d’UI supplémentaire identifié par ces tokens. Le corpus, ses chemins et ses empreintes sont inchangés. Cette recherche complète la lecture directe des sélecteurs ; elle ne prouve pas une absence sémantique universelle ni l’absence de toute mécanique de debuff.

Les positions de contrôles Spell0…3 et Ability0…5 et leurs vingt Text sont maintenant reliées, mais leur sélection/priorité, leurs labels et leurs échéances publiques ne sont pas établis comme consommateurs actuels. Les noms et le layout seuls ne permettent pas de choisir un contrôle actif.

## R4 — Attendu, observé, essais hérités et contrôles frais

| Contrôle | Attendu | Observé |
|---|---|---|
| Source originale | Identifier chaque composant avec son origine | 261 liaisons par chemin/offset/kind/propriétés ; 60 identifiants Text existants repris ; un rejet original conservé. |
| Composition des emplacements | Distinguer icône, signe, pile et effet | 40 groupes de cinq composants ; tous désactivés initialement ; seuls Buff0 et BuffStack0 raccordés par le HUD privé. |
| Variantes | Ne pas choisir d’après le nom ou la taille | Neuf membres classés, comparés aux originaux ; aucun déclaré globalement inutilisé. |
| Icône actuelle | Conserver sa provenance réelle | Un membre Icons2D et deux sources originales identiques ; pas de génération ni substitution. |
| Durée autorisée | Séparer état serveur, projection et fraîcheur | until privé, DTO sans échéance ; fraîcheur 0,2 seconde distincte ; expires_at existants pour d’autres états reconnus. |
| Refus | Identifier les branches et leur statut d’exécution | 1..5, identité/session/époque/santé/horloge et ressources/fenêtre gardés ; code relu, anciens essais datés, aucun nouveau refus runtime revendiqué. |
| Overlays | Préserver originales/adaptations et limites | Couleur finale TargetBar et préfixe BaseOffset LossOfControl inchangés ; deux avertissements d’overlay gardés. |
| Conservation | Ne modifier aucun acquis normatif/applicatif | 25 fichiers protégés, cinq registres et Git identiques avant/après ; 76 fichiers suivis déjà modifiés conservés. |

Exécuté : Python existant -X utf8 -E -B verify_buff_duration.py, code 0 ; **1071 contrôles documentaires réussis**. Actions fraîches : lectures ZIP/JSON/mmap, empreintes, liens par élément, comparaisons de code et ressources, recherche bornée et lecture Git. Le détail attendu/observé de chaque contrôle est conservé dans checks du reçu.

Réutilisés seulement : quatre tests HUD passés le 23 octobre 2026 à 14:21:01–14:21:04 UTC ; leurs quatre logs et le reçu de qualification V222 sont toujours identiques. Ils couvrent source/ordre de police/icône, chiffres/redimensionnement, retrait/réemploi des handles et masquage/absence de prédiction. L’ancien binaire et toutes les dépendances transitives ne sont pas requalifiés ici ; leurs résultats ne valent pas une nouvelle intégration du client courant.

Non exécutés : tests Rust/Cargo, compilation, jeu actuel ou historique, émulateur, REA, réseau, GPU, capture, application de suivi, base de données, installation, migration ou changement du goal. Les résultats du parseur natif sont hérités et restent dans leur portée initiale. Aucun avertissement n’est converti en succès global.

## R5 — Manques et reprise précise

- Affectation générique : il faut une identité d’effet autorisée, un ordre/priorité, une règle d’ajout/retrait/remplacement et une correspondance effet→slot. Préserver le slot fixe d’Ezreal tant que son remplacement n’est pas qualifié. Les 31 autres positions ne constituent pas à elles seules 31 fonctionnalités manquantes.
- Icônes/décorations : il faut un producteur de liaison BuffIcon/TargetBuffIcon et de signe positif/négatif pour un effet nommé ; rechercher un fichier seulement si sa résolution concrète échoue. Ne pas générer des textures d’après ces seuls noms de liaison.
- Temps : il faut une projection d’échéance et une horloge explicitement autorisées, avec durée totale ou progression si nécessaire à l’effet. Distinguer intemporel, inconnu, expiré et durée cachée. Le seuil 0,2 seconde ne fournit aucune de ces informations.
- Données publiques : définir effet/champ/audience/visibilité et état dernier connu/indisponible. Ne pas recopier un état privé complet au motif que son acteur est visible. Les limites de cible identifiée, changement de cible et perte de vision sont réutilisées depuis TARGET-01.
- Contrôles : retrouver le producteur du choix LossOfControl et de sa priorité, label et temps, ou nommer explicitement une politique locale reconstruite. Les vingt Text et les deux avertissements de l’overlay doivent rester distingués du comportement actif.
- Variantes : une nouvelle trace de sélecteur/provider ou un profil local documenté est nécessaire avant de revendiquer les autres listes/layouts. Aucun nouvel essai sur les mêmes noms et empreintes ne tranche cette priorité.
- Fonctionnalité : après un consommateur nommé, observer application, rafraîchissement, expiration, pause, mort, changement de vision, déconnexion/reconnexion/session et rendu réel à viewport déclaré. Le modèle, les primitives de parseur et un champ ajouté seuls ne terminent pas la fonctionnalité.

Conditions d’arrêt du lot satisfaites au niveau documentaire : sources disponibles classées, consommateur partiel établi, absence de raccordement délimitée, durées présentes/absentes distinguées et entrées nécessaires nommées. Il n’y a pas de demande de nouvelle autorisation ni de blocage artificiel. L’inconnue normative reste ouverte, car ses conditions fonctionnelles ne sont pas réalisées.

## R6 — Corrections réutilisées et propositions distinctes

Ces fiches appartiennent aux résultats d’audit. Elles ne modifient ni le plan, ni le goal, ni leurs critères de clôture. Pour une réalisation, choisir un effet et un comportement nommés ; ne pas convertir un contrat commun d’admission en tâche d’implémentation de tous les buffs/champions à la fois.

| Correction existante conservée | Résultat propre / relation |
|---|---|
| `BUFF-OWNER-SLOTS-01` | Identity/order/replacement of authorized owner effects; retain fixed Ezreal slot until migration is qualified. |
| `BUFF-OWNER-DURATION-01` | Ezreal expiry projection and clock, application/refresh/expiry/pause/death/reconnect, with unavailable distinct from zero. |
| `BUFF-TARGET-IDENTITY-01` | Per-viewer target effect/stack/deadline permission and identity lifetime. |
| `BUFF-COUNTER-FORMAT-01` | Original stack Text/font and digit/hide/render contract. |
| `TARGET-09-BUFF-0` | Independent target buff slot 0 icon/stack/effect and unavailable/hidden/changed target clearing. |
| `TARGET-09-BUFF-1` | Independent target buff slot 1 icon/stack/effect and unavailable/hidden/changed target clearing. |
| `TARGET-09-BUFF-2` | Independent target buff slot 2 icon/stack/effect and unavailable/hidden/changed target clearing. |
| `TARGET-09-BUFF-3` | Independent target buff slot 3 icon/stack/effect and unavailable/hidden/changed target clearing. |
| `TARGET-09-BUFF-4` | Independent target buff slot 4 icon/stack/effect and unavailable/hidden/changed target clearing. |
| `TARGET-09-BUFF-5` | Independent target buff slot 5 icon/stack/effect and unavailable/hidden/changed target clearing. |
| `TARGET-09-BUFF-6` | Independent target buff slot 6 icon/stack/effect and unavailable/hidden/changed target clearing. |
| `TARGET-09-BUFF-7` | Independent target buff slot 7 icon/stack/effect and unavailable/hidden/changed target clearing. |

| Proposition non appliquée | Résultat unique et fin proposée | Entrée de reprise |
|---|---|---|
| `BUFF-OWNER-ICON-01` | Bind authorized owner effect icon and positive/negative decoration — One named effect has correct identity/icon/border and source slot mapping; add/remove/refresh/unavailable and source/current render checked without changing fixed Ezreal binding accidentally. | Native icon/decoration producer or explicitly local policy plus authorized effect identity. Dynamic BuffIcon names are not missing texture filenames. |
| `BUFF-OWNER-DURATION-EFFECT-01` | Render one authorized owner duration as the original cooldown effect — Per-effect start/end or normalized progress, server tick/clock, untimed/unknown/expired/paused semantics qualified; source Effect state reaches actual renderer and expected/refusals documented. | Authorized expiry/total-duration projection, native effect-update semantics or explicit local reconstruction. Uniform color/parameter copy alone does not satisfy this. |
| `BUFF-CATALOGUE-PUBLIC-01` | Define the canonical authorized HUD effect identity and metadata admission — Each implemented effect exposed to HUD has an identified producer, audience, category/icon, stack and optional timing semantics; unsupported/hidden/unknown effects stay unavailable, not invented. | Existing typed producers first; native buff catalogue/allocator metadata or a named local scope. This audit does not declare all champion buff gameplay complete. |
| `BUFF-LOSS-CONTROL-01` | Qualify control overlay selection and authorized label/duration — One named control type has an authorized source, priority and clock, binds its correct spell/ability overlay and clears on state/session loss; original missing BaseOffset and two retained warnings accounted for. | Native/control-state selector and label/time policy, plus current effect renderer; source child names alone cannot select the active control. |
| `BUFF-ALTERNATE-LAYOUT-01` | Resolve the supplied alternate buff layout selection before claiming parity — For each claimed profile, exact list/selector and chosen member are evidenced, corresponding slot semantics qualified; unselected layouts retained and current normal layout preserved. | New native selector trace or declared profile choice. Same sizes/names do not prove byte equality or runtime precedence. |
| `BUFF-LIFECYCLE-RENDER-01` | Verify actual authorized buff presentation lifecycle — Real client/transport/render evidence for named effect covers add/refresh/expire, pause, death, remove, visibility, disconnect and session change; source/current comparison at declared viewport, optional timing unavailable refused or hidden. | Working named consumer and approved per-field projection; reuse old tests after checking relevant source changes rather than claiming broad readiness. |

Les 32 slots propriétaires et huit cibles sont des positions de présentation. Leur inventaire machine relie les cinq composants de chaque slot ; les huit actions de cible TARGET-09-BUFF-0…7 restent indépendantes. Les corrections owner/durée/format antérieures sont réutilisées ; aucune copie du plan ni nouvelle case n’est créée.

| Identifiant Text antérieur | Définition | Source primaire |
|---|---|---|
| `HUD-7c6ec008c083b066` | BuffStack0 | CenterHUD_Buffs.ini |
| `HUD-0ab1ba2342598c0b` | BuffStack1 | CenterHUD_Buffs.ini |
| `HUD-3bf687909c2a1e12` | BuffStack10 | CenterHUD_Buffs.ini |
| `HUD-bf329c3dfb96bdb1` | BuffStack11 | CenterHUD_Buffs.ini |
| `HUD-508e611a50a9e66d` | BuffStack12 | CenterHUD_Buffs.ini |
| `HUD-94c53c573867fe8a` | BuffStack13 | CenterHUD_Buffs.ini |
| `HUD-b930c56387353484` | BuffStack14 | CenterHUD_Buffs.ini |
| `HUD-85fabbe37f444760` | BuffStack15 | CenterHUD_Buffs.ini |
| `HUD-040411bc7f0b890a` | BuffStack16 | CenterHUD_Buffs.ini |
| `HUD-8a171eb26908ce7d` | BuffStack17 | CenterHUD_Buffs.ini |
| `HUD-61d0b06ac0e477d1` | BuffStack18 | CenterHUD_Buffs.ini |
| `HUD-3b7d67eb239d5dc8` | BuffStack19 | CenterHUD_Buffs.ini |
| `HUD-4965bc2bd7ad759c` | BuffStack2 | CenterHUD_Buffs.ini |
| `HUD-399355364ce39944` | BuffStack20 | CenterHUD_Buffs.ini |
| `HUD-0d5dfeadcaacfd2e` | BuffStack21 | CenterHUD_Buffs.ini |
| `HUD-fc4d51549538186f` | BuffStack22 | CenterHUD_Buffs.ini |
| `HUD-e9019c2e117d9780` | BuffStack23 | CenterHUD_Buffs.ini |
| `HUD-f0cfa1adae079726` | BuffStack24 | CenterHUD_Buffs.ini |
| `HUD-5f4da27b34616532` | BuffStack25 | CenterHUD_Buffs.ini |
| `HUD-3fb1dd96af182b87` | BuffStack26 | CenterHUD_Buffs.ini |
| `HUD-3da502e4df6fb04c` | BuffStack27 | CenterHUD_Buffs.ini |
| `HUD-d9856b1184bddd6f` | BuffStack28 | CenterHUD_Buffs.ini |
| `HUD-8f29e35ace4988ea` | BuffStack29 | CenterHUD_Buffs.ini |
| `HUD-54616b0f4598b6ff` | BuffStack3 | CenterHUD_Buffs.ini |
| `HUD-831fde1605790d74` | BuffStack30 | CenterHUD_Buffs.ini |
| `HUD-e3a1b722fa75a528` | BuffStack31 | CenterHUD_Buffs.ini |
| `HUD-6dff9a96b7762ec6` | BuffStack4 | CenterHUD_Buffs.ini |
| `HUD-ad7c39d06a7468ed` | BuffStack5 | CenterHUD_Buffs.ini |
| `HUD-e2ba256f628a3c66` | BuffStack6 | CenterHUD_Buffs.ini |
| `HUD-b7684c482609a779` | BuffStack7 | CenterHUD_Buffs.ini |
| `HUD-c87e3bb9e17fffbb` | BuffStack8 | CenterHUD_Buffs.ini |
| `HUD-427783189b6a81bb` | BuffStack9 | CenterHUD_Buffs.ini |
| `HUD-5df4ee3e85465b14` | TargetBuffStack0 | TargetBar_Buffs.ini |
| `HUD-39156381cecd1809` | TargetBuffStack1 | TargetBar_Buffs.ini |
| `HUD-2429fbf438e562d6` | TargetBuffStack2 | TargetBar_Buffs.ini |
| `HUD-aaa3dac8668dca07` | TargetBuffStack3 | TargetBar_Buffs.ini |
| `HUD-cc4cf15ac3c4887d` | TargetBuffStack4 | TargetBar_Buffs.ini |
| `HUD-29e7827082a432b1` | TargetBuffStack5 | TargetBar_Buffs.ini |
| `HUD-10261dcdee165c9a` | TargetBuffStack6 | TargetBar_Buffs.ini |
| `HUD-4ac6b878d700c509` | TargetBuffStack7 | TargetBar_Buffs.ini |
| `HUD-67cde2ea84788147` | LossOfControlSpell0Cooldown | LossOfControlUI.ini |
| `HUD-c7d29ab28f18da5e` | LossOfControlSpell0Text | LossOfControlUI.ini |
| `HUD-5e5513acf65d3822` | LossOfControlSpell1Cooldown | LossOfControlUI.ini |
| `HUD-f85ff6b45a956ccb` | LossOfControlSpell1Text | LossOfControlUI.ini |
| `HUD-8351c1b105117f54` | LossOfControlSpell2Cooldown | LossOfControlUI.ini |
| `HUD-0afc2a0ceca57b9e` | LossOfControlSpell2Text | LossOfControlUI.ini |
| `HUD-ec06da323014dc14` | LossOfControlSpell3Cooldown | LossOfControlUI.ini |
| `HUD-aabe59f93d3401af` | LossOfControlSpell3Text | LossOfControlUI.ini |
| `HUD-63c6c3adf1ada31a` | LossOfControlAbility0Cooldown | LossOfControlUI_AbilityOverlay.ini |
| `HUD-10a8ae3bc36d9a7b` | LossOfControlAbility0Text | LossOfControlUI_AbilityOverlay.ini |
| `HUD-c9b111a73fb826a6` | LossOfControlAbility1Cooldown | LossOfControlUI_AbilityOverlay.ini |
| `HUD-592f24bb58cb6dad` | LossOfControlAbility1Text | LossOfControlUI_AbilityOverlay.ini |
| `HUD-4666f3886848b027` | LossOfControlAbility2Cooldown | LossOfControlUI_AbilityOverlay.ini |
| `HUD-513e7b3394201926` | LossOfControlAbility2Text | LossOfControlUI_AbilityOverlay.ini |
| `HUD-d108fc71d68e77d7` | LossOfControlAbility3Cooldown | LossOfControlUI_AbilityOverlay.ini |
| `HUD-912c07f25829c7ca` | LossOfControlAbility3Text | LossOfControlUI_AbilityOverlay.ini |
| `HUD-062e5baf714d6005` | LossOfControlAbility4Cooldown | LossOfControlUI_AbilityOverlay.ini |
| `HUD-9bae663bbb089170` | LossOfControlAbility4Text | LossOfControlUI_AbilityOverlay.ini |
| `HUD-39d1f234b12154e9` | LossOfControlAbility5Cooldown | LossOfControlUI_AbilityOverlay.ini |
| `HUD-abee333edbe0ac64` | LossOfControlAbility5Text | LossOfControlUI_AbilityOverlay.ini |

## R7 — Livraison, preuve et relecture

Nouveaux fichiers uniquement :

- F:/OpenLeague/docs/audit/units/AUD-17.1-06-BUFF-DURATION-01.md, ce rapport.
- Dossier F:/OpenLeague-work/audit-units/AUD-17.1-06-BUFF-DURATION-01/ : audit-unit.json, verify_buff_duration.py, buff-duration-proof.json, verify_delivery.py, delivery-readback.json.

Reçu principal : SHA-256 `366712cae4b0611187eb96189f1cabc5ba25e66ae855e43b1a3e310733f262d9`. Producteur : `26562d82d626bb86263dc9428355557ec3c09d972788a503436bd9d2a29ca7e2`. La fiche de lot, les anciennes preuves, sources originales, offsets, variantes, réparations, logs datés, consommateurs et résultats attendus/observés sont identifiés dans le reçu.

Le lecteur indépendant vérifie les sources actuelles, reconstruit les liaisons depuis les offsets, recoupe les variantes, les deux réparations, l’icône, les limites de durée et les sept rubriques. delivery-readback.json donne la clôture documentaire uniquement si tous ses contrôles réussissent ; la fonctionnalité et le goal restent incomplets.

Recontrôle sans écriture : Python existant -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-17.1-06-BUFF-DURATION-01/verify_delivery.py --check-only. Les reçus sont créés exclusivement, jamais remplacés. Les 19 fichiers logiciels gelés et six documents de contexte restent identiques ; les cinq registres normatifs restent inchangés. Aucun accès à une base et aucune installation/migration/reprise de l’application.

Résolu : couverture documentaire des composants de buff et contrôles, provenance de l’icône existante, distinction des durées/DTO/fraîcheur, variantes et limites des réparations, corrections et reprise sans doublon. Ouvert : allocation générique, politique publique par champ, pilotes d’icône et durée, priorité des contrôles, variante effective et vérification fonctionnelle/graphique. Audit terminé ne signifie pas fonctionnalité terminée.
