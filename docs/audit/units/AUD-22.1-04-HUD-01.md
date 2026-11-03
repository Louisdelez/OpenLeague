# AUD-22.1-04-HUD-01 — Inventaire des routes de texte du HUD Rust

Contrôle : 2026-10-30T12:02:15.521135+00:00. Parent principal SYS-22.1-04 ; constats connexes SYS-22.1-05/07. Audit documentaire seulement ; aucun changement du Goal, de l'application de suivi, des bases ou du jeu.

## 1. Périmètre, critère de fin et décision

Question : quels chemins du client de jeu actuel produisent des textes visibles, quelles sources utilisent-ils et quels raccordements à la locale manquent ? Critère : chaque candidat trouvé dans le corpus actuel reçoit une qualification ; les routes ordinaires sont reliées à leur enregistrement et à leurs sources ; les diagnostics et limites sont distincts.

**Audit de cet inventaire terminé.** Neuf routes actuelles sont identifiées. Les 25 fichiers candidats sont expliqués : producteurs ordinaires, helpers, tests, observations, sonde dédiée ou types de configuration sans widget. Le corpus couvre les 498 fichiers Rust sous crates/client/src. Ce résultat est borné aux usages explicites Bevy Text et aux chemins de glyphes actuels inspectés ; ce n'est pas un graphe d'appels Rust complet ni l'inventaire de tous les textes historiques du jeu.

| Dimension | État |
|---|---|
| Audit | Terminé pour l'inventaire actuel et les constats de code/données ci-dessous |
| Implémentation | Textes présents par plusieurs chemins ; commutation de langue des libellés et titres non raccordée dans les routes inspectées |
| Vérification | Partielle : recherches, identités, indexation et comparaisons statiques exécutées ; aucun rendu ou test Rust lancé |
| Acceptation humaine | Non demandée |

SYS-22.1-04 reste ouverte pour l'attribution précise de toutes les clés et la réalisation/vérification de la localisation. L'inventaire terminé n'est pas une fonctionnalité terminée.

## 2. Sources et preuves réutilisées

Le code courant et ses enregistrements dans main.rs constituent les consommateurs réels. locale.cfg sélectionne en_GB. Le catalogue shop_foundation.json reste un catalogue de noms/descriptions français déjà vérifiés dans KEY-01 ; SEARCH-01 relie le placeholder natif et son consommateur actuel.

Le fichier `data/4.20/native_hud_source_records_contract.json` est une capture héritée du 2026-10-06. Il contient 154 enregistrements Text acceptés et les octets d'entrée de 32 fichiers. Les 32 empreintes des octets capturés et les liens par file_sha256 ont été vérifiés. Le parseur natif, la boucle externe et le provider ne sont pas réexécutés : leurs limites antérieures restent conservées, notamment l'acceptation externe de LossOfControlUI.

`data/4.20/endgame_ui_native.json` relie les PNG de titre aux atlas d'origine fr_FR. Les SHA256 du DDS original et du PNG effectivement référencé sont vérifiés pour victoire et défaite. Le choix de région/locale natif de l'atlas reste non qualifié par cette seule extraction.

Les audits CALLBACK, PROVIDER, MOUNT et STATE sont conservés comme preuves de la chaîne native. Leurs expériences ne sont pas rejouées. La première insertion de StateBag et sa durée de vie ne bloquent pas la présente conclusion sur les routes de texte actuelles ; elles restent des clauses ouvertes séparées.

## 3. Routes et consommateurs réels

| Route | Source / branchement | Donnée actuellement affichée et qualification |
|---|---|---|
| Connexion et diagnostic | main.rs, labels, enregistrement Update ; session_connection.rs:98-108 | Messages français locaux de connexion ; diagnostic F3 lorsqu'en partie. Le statut de connexion reste visible hors readiness. Pas de résolution de clés native dans ce chemin |
| Boutique | shop_ui.rs, setup/update enregistrés main.rs:809,825 | Libellés français, catalogue fixe, descriptions, recettes, prix ; Notice peut recevoir une erreur déjà formatée. La clé native de recherche est connue mais non raccordée |
| Récapitulatif de mort | death_recap_panel::Plugin, main.rs:690 | Présentation locale française, noms canoniques de champions, libellés d'unités et montants. Le code annonce explicitement une UI propre, pas une recréation du film Flash natif |
| Pause | ordinary_pause::Plugin, main.rs:710 | Bouton, état et retours français de la politique locale de pause. Préserver la distinction avec un panneau historique de tournoi |
| Fin de partie | native_endgame_ui::setup/update, main.rs:811,851 | Titres bitmap fr_FR et libellé CONTINUER fixe ; géométrie/atlas natifs distincts d'une sélection de langue fonctionnelle |
| Résultats | match_results_ui::setup/update, main.rs:810,853 | Tableau local français, résultat immuable, titre victoire/défaite et bouton RETOUR AU LAUNCHER |
| Compteurs HUD natifs | native_hud_widgets::Plugin, main.rs:687 | 18 enregistrements de layout : heure, or, niveau, PV/mana, cooldowns, réapparition et raccourcis. Valeurs numériques/touches, pas dictionnaire général de textes |
| Compteur passif Ezreal | native_ezreal_passive_hud::Plugin, main.rs:688 | BuffStack0, une valeur ASCII 1..5, source HUD/Elements/CenterHUD_Buffs.ini |
| Quantités d'inventaire | native_hud_inventory::Plugin, main.rs:691 | Six InventoryItemCount0..5 du layout ShadowIslesChampionLeft.ini, quantités numériques des piles |

La provenance du mot et la provenance de sa police sont séparées. Les textes Bevy locaux utilisent essentiellement DejaVuSans ; la boutique charge la police de son propre chemin Foundry ; les compteurs utilisent le transport et les glyphes natifs. Charger une police sélectionnée par locale ne traduit pas ces libellés.

La sonde --native-hud-text-gpu-probe est un chemin CLI explicite avec sortie anticipée de main. Elle n'est pas comptée comme une dixième route ordinaire. Les observations et tests qui lisent Text ne sont pas pris pour des producteurs.

## 4. Contrôles exécutés et constats

Commande exécutée avec code 0 : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-22.1-04-HUD-01/inventory_hud.py`.

| Contrôle | Attendu / observé |
|---|---|
| Corpus et candidats | 498 sources hachées ; 25 candidats ; zéro candidat sans qualification manuelle. Les motifs de recherche et les occurrences sont conservés |
| Branches de production | Neuf routes reliées au main ; aucun alias Text trouvé par le motif examiné. Les helpers, types Value::Text et tests sont séparés par relecture |
| Capture native | 154 enregistrements Text hérités indexés, identités uniques ; 32 entrées capturées conformes à leur SHA256 |
| Sélecteurs actuels de layouts | 18 enregistrements pour native_hud_widgets, six pour inventaire, un pour Ezreal. L'indexation statique concorde avec les gardes du code |
| Titres de fin de partie | DDS et PNG référencés conformes aux empreintes fr_FR du manifeste ; locale courante en_GB ; chemin d'asset fixe dans le code |
| Encodage du diagnostic | Quatre exemples de chaînes mal décodées confirmés directement dans les octets UTF-8 de main.rs, pas déduits d'un terminal ou d'une capture écran |

Constat HUD-ENCODING-01 : main.rs:1683-1685 contient notamment prÃªte, Ã‰tourdi, ContrÃ´le et unitÃ©s. La preuve conserve leurs octets et les candidats de réparation prête, Étourdi, Contrôle et unités. Ces candidats ne sont pas appliqués. Le diagnostic est masqué par défaut pendant une partie prête et activé par F3 ; son existence ne prouve pas que le HUD numérique ordinaire affiche ces chaînes.

Constat HUD-ENDGAME-LOCALE-01 : les PNG victory_title/defeat_title proviennent d'atlas fr_FR explicitement sélectionnés dans le manifeste. Le code choisit victoire/défaite mais ne consulte pas la locale pour ces chemins. C'est un écart de branchement établi par le code et les assets, sans observation graphique nouvelle.

Acquis à conserver pour SYS-22.1-07 : native_hud_widgets.rs:109-113 refuse les valeurs dépassant 255 octets et les contenus non ASCII, puis traite les erreurs de copie. native_hud_inventory et native_ezreal_passive_hud ont aussi des contrôles explicites de format. Ces gardes de transport ne sont ni un diagnostic de clé de traduction absente, ni une mesure de débordement en pixels. L'absence de cette dernière dans la boutique, étudiée dans OVF-01, n'est pas généralisée aveuglément à tous les chemins.

Aucun cas de rendu, presse-papiers, serveur, compilation ou test Rust n'est exécuté. Les profils natifs et les anciennes captures gardent leur date héritée.

## 5. Couverture et manques sans faux pourcentage

Les 25 enregistrements sélectionnés par les trois consommateurs de glyphes sont des noms/positions de widgets sourcés, pas 25 traductions complètes. Les 129 autres enregistrements de cette capture ne sont pas sélectionnés par ces trois chemins. Ils sont conservés individuellement dans hud-inventory.json avec chemin, nom, offset, SHA256 et identifiant documentaire stable.

**129 enregistrements non sélectionnés ne signifient pas 129 fonctionnalités manquantes.** Certains peuvent appartenir à d'autres états, variantes, éléments masqués ou périmètres non implémentés ; leur contexte doit être qualifié avant une conclusion. Aucun taux de jeu terminé n'en est déduit.

Les manques établis sont le raccordement de langue des libellés locaux et titres, la qualification de leurs clés/contrats, les exemples d'encodage, les formats de nombres/durées et les vérifications graphiques. Les sources de noms français, tableaux de police et titres examinées sont disponibles. Aucun besoin de logiciel supplémentaire ou de génération d'image n'est démontré par ce lot.

Le périmètre exclut le launcher Tauri/AIR, les voix, les messages réseau possibles non encore reçus, les macros/alias non couverts par les motifs et tous les textes historiques hors capture. Le classement complet des candidats trouvés est établi ; une preuve d'exhaustivité de tout code généré Rust n'est pas revendiquée.

## 6. Corrections précises et reprise par zone

Précisions documentaires sous les tâches existantes ; aucun ajout de tâche ou de case dans le suivi :

| Action / rattachement | Résultat unique et critère de fin | Entrée ou dépendance |
|---|---|---|
| HUD-CONNECTION-01 / SYS-22.1-04 | Raccorder les messages de session de session_connection.rs à la locale retenue, sous contrat local explicite. Vérifier les états connexion/synchronisation/reconnexion/fermeture sans changer le protocole | Service de texte défini ; messages natifs non inventés pour les services propres au projet |
| SEARCH-TEXT-01 et RESP-ITEM-01, réutilisées / SYS-22.1-04 | Raccorder placeholder et noms d'objets dans shop_ui, puis traiter les autres rôles nommés de NativeText avec sources/contrats identifiés. Fin : cas en_GB/fr_FR et clé absente distingués | Sources et critères dans SEARCH-01 / RESP-01 ; erreurs serveur préformatées à distinguer des libellés UI |
| HUD-RECAP-01 / SYS-22.1-04/05 | Localiser les libellés et formats du récapitulatif local, avec cas montant faible, durée et source masquée. Préserver l'identité et la confidentialité des données | death_recap_panel.rs ; ne pas revendiquer une équivalence Flash sans preuve |
| HUD-PAUSE-01 / SYS-22.1-04 | Localiser boutons et retours de pause locale pour ses états existants. Fin : source des textes et attendu/observé par état, sans modifier l'autorité serveur | ordinary_pause.rs et service de texte |
| HUD-ENDGAME-LOCALE-01 / SYS-22.1-04 | Sélectionner les titres selon une correspondance de locale vérifiée, puis raccorder CONTINUER. Fin : atlas exacts, origine et rendu en_GB/fr_FR contrôlés | EndOfGame.gfx, atlas et manifeste ; correspondance/fallback natifs à qualifier avant de choisir un autre atlas |
| HUD-RESULTS-01 / SYS-22.1-04/05 | Localiser titres, en-têtes, bouton de retour et formats du résultat local. Fin : victoire, défaite et résultat sans joueur local vérifiés | match_results_ui.rs ; conserver les données immuables |
| HUD-NUMERIC-01 / SYS-22.1-05 | Qualifier les formats et touches des 18 widgets nommés dans l'inventaire, avec contrats natifs/locaux et cas limites | Sources de layouts et fonctions de formatage identifiées ; ne pas traduire arbitrairement des noms de widgets |
| HUD-EZCOUNT-01 / SYS-22.1-06 | Qualifier les glyphes 1..5 de BuffStack0 pour les profils retenus, avec refus hors plage et résultat visible | Chemin passif et fontes existants ; garder réception/fraîcheur de la donnée séparées |
| HUD-INVENTORY-COUNT-01 / SYS-22.1-06 | Qualifier les six compteurs et leurs glyphes, valeurs vides/piles et rendu | native_hud_inventory.rs, source InventoryItemCount0..5 et politique de piles existante |
| HUD-ENCODING-01 / SYS-22.1-04 | Corriger seulement les chaînes mal encodées de l'overlay F3 identifié. Fin : octets UTF-8 corrects et rendu F3 contrôlé, sans changement des valeurs/formats de jeu | Quatre exemples et emplacements dans la preuve ; correction fonctionnelle autorisée séparément |
| HUD-CONTEXT-01 / SYS-22.1-04 | Classer les enregistrements non sélectionnés par panneau/contexte, un petit lot de source à la fois. Fin : usage, absence actuelle ou inconnue précise établie pour chaque lot examiné | 129 lignes conservées avec IDs documentaires ; nouvelle piste d'usage avant recherche native détaillée |

Toute réalisation fonctionnelle exige une instruction distincte du présent audit. Les preuves internes du dictionnaire restent utilisables ; leur prolongement n'est pas un prérequis automatique à la correction d'un libellé local déjà identifié.

## 7. Livraison et relecture

Fichiers créés : ce rapport ; `F:/OpenLeague-work/audit-units/AUD-22.1-04-HUD-01/inventory_hud.py` ; son résultat hud-inventory.json, 253925 octets, SHA256 6e1df68158158e6c32c7a6347831a589c27726e926d7e4f9e8042d0c9d0c757e. Le JSON conserve le manifeste des 498 sources, chaque candidat et sa qualification, les routes, les 154 enregistrements, les observations d'encodage et les identités des titres.

Relecture des sept rubriques : portée, sources, consommateurs, attendu/observé, limites, actions et preuves explicites. Aucun pourcentage de jeu terminé, aucune acceptation humaine, aucune exécution graphique inventée. Les anciens rapports et acquis restent conservés. Aucun fichier logiciel du jeu ou du suivi modifié, aucune base ouverte, aucune installation/migration et aucun changement du Goal.
