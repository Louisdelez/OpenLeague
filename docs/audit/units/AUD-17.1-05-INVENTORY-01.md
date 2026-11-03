# AUD-17.1-05-INVENTORY-01 — Inventaire, charges et présentation

Contrôles : 2026-10-30T19:18:24.627247+00:00. Goal SYS-01.2-02 actif et incomplet, sans modification. Lot précédent buffs/durées classé progrès documentaire.

## R1 — Exigence, périmètre et clôture distincte

**SYS-17.1-05** : « Afficher l’inventaire et les charges d’objet ». Référence **OLF-0e2d77ab-62ab-59c0-bf3e-70cbcb22f2da**, inconnue réutilisée **OLU-7a6c5e5b-4269-5e2c-a3a2-b770e4bde194**, toujours open. Le registre garde a_faire, implementation_complete=false, acceptance_complete=false.

Ce lot complète l’audit actuel de toute l’exigence : sources des icônes, piles/charges, raccourcis, retours d’actif/récupération, slot de vision, données et consommateurs de présentation/commande. Le précédent COUNT-01 reste acquis pour ses six Text ; il ne suffisait pas à qualifier les charges d’instance ni tout l’inventaire.

| Dimension | Résultat |
|---|---|
| Audit | Clôture documentaire uniquement après relecture indépendante des sept rubriques. Le reçu principal garde audit_scope_closed=false pour ne pas s’auto-valider. |
| Implémentation | Partielle : six icônes et six compteurs, 33 objets/icônes, deux potions, geste local de déplacement avec comparaison serveur ; charges d’instance et présentation générale des actifs/vision non qualifiées. |
| Vérification | Sources et code comparés ; test DDS ancien réutilisé seulement ; aucun nouveau test du jeu ou rendu. |
| Acceptation humaine | Non demandée ; aucune acceptation du jeu déduite. |

Référence : LoL PUBLIC 4.20.0.315 / Releases/4.20, EUW/en_GB ; catalogue local 4.20.1 distinct du numéro de build. La date de compilation n’est pas une date de déploiement établie. Portée actuelle : liste HUD ShadowIsles normale ; ressources conditionnelles distinguées, sans prétendre qualifier tous les modes historiques.

Prérequis vérifiés : D17, lot D17-SYS-17-1 ; il requiert D05-SYS-05-5, encore a_faire. Ses prérequis D05-SYS-05-1/02 ne sont pas déclarés acquis. La fiche audit-unit.json porte des sorties de ce lot documentaire ; aucun critère normatif du goal ou du plan n’est changé.

## R2 — Sources, provenance et sélection réelle

HUD.zip original et copie de travail : 122169 octets chacun, SHA-256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`.

- Copie : F:/OpenLeague/data/4.20/archives/menu/HUD.zip.
- Original : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/menu/HUD.zip.

Binaire des captures héritées : League of Legends.exe du même déploiement, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Identité relue ; aucune exécution native ici. L’identité des archives ne qualifie pas à elle seule leur ordre de montage historique.

**Ressources actuellement sélectionnées : 58 définitions**, soit 29 Icon, 14 Effect et 15 Text, dans les deux membres ci-dessous. Chaque définition est reliée à son offset original, ses propriétés et sa capture native héritée ; les 15 Text gardent leurs identifiants HUD antérieurs.

| Membre sous HUD/Elements | Définitions pertinentes | SHA-256 |
|---|---|---|
| ShadowIslesChampionLeft.ini | {'Icon': 24, 'Effect': 12, 'Text': 12} | `7a23abc56478e252a3d3174e24d4cbf8cbb8e03ae71f8f1ec6cb6c581bd1cf14` |
| VisionSlot.ini | {'Icon': 5, 'Effect': 2, 'Text': 3} | `548b18a1c5a21b7408a43eaa1b5f6094c0a6975c0348ddd87e00e80b73b8dfd6` |

Pour les slots propriétaires 0…6 : huit composants par slot, comprenant actif, animation de sheen, effet de récupération, icône, compteur, overlay, fond de raccourci et Text de raccourci. Les deux autres composants de VisionSlot.ini sont l’icône TargetItem6_ et le Text TargetItem6_Count ; ils relèvent aussi de l’audit de cible SYS-17.1-07. Leurs familles ne sont pas confondues avec l’inventaire propre.

Le consommateur actuel ne retient que les icônes InventoryItem0…5 et compteurs InventoryItemCount0…5 de ShadowIslesChampionLeft.ini : douze composants. Il ne sélectionne pas les six Text de raccourci, états actifs/overlays/effets ni les composants du slot 6. Cela n’annule pas les touches d’action déjà présentes.

**Source conditionnelle conservée : CenterHUD_ActiveItems.ini**, 18403 octets, 60 définitions (30 Icon, 12 Effect, 18 Text). Ce fichier est absent de la liste normale actuelle et des captures natives par élément réutilisées ; aucun identifiant HUD existant n’est inventé pour ses 18 Text. Ses six groupes de dix composants sont décrits lexicalement seulement. Ni présence du fichier ni nom ActiveItem ne prouvent qu’il doit être activé dans cette configuration.

VisionSlot_Right.ini appartient au contexte de liste inversée, pas à la sélection normale actuelle. Son texte cible s’appelle TargetItem6_Stack, distinct de TargetItem6_Count. Son origine est comparée ; aucune équivalence native/dynamique de variante n’est affirmée.

Les 33 ponts d’icônes V217 sont préservés et leurs trois fichiers recontrôlés : configuration INIBIN originale, DDS original et DDS consommé. Même ensemble de 33 IDs dans shop_foundation.json et native_inventory_icons.json ; shop_sha256 correspond au catalogue. Aucun manque d’icône de ce catalogue courant n’est inventé. Le libellé ancien « 32-item » ne remplace pas le nombre réel de 33 entrées.

Le catalogue local Data Dragon identifie 280 entrées, version 4.20.1. Les 33 IDs courants y figurent ; les 247 autres ne deviennent pas automatiquement des objets admissibles en Map10. native_item_audit.json est une liste de 849 enregistrements de décodage hérités, pas 849 objets jouables. Aucun taux de jeu terminé n’est calculé à partir de ces cardinalités, aucune nouvelle lecture INIBIN générale effectuée.

## R3 — Consommateurs réels, quantité, charge et entrée

| Source/consommateur actuel | Acquis | Limite |
|---|---|---|
| native_hud_inventory.rs:15–75 | Valide joueur/objet/quantité ; sélectionne six icônes et six compteurs natifs dans le bon fichier. | Modèle de six slots ; catalogue limité ; aucune charge d’instance générique lue par ce chemin. |
| même module :77–130 | Charge les 33 DDS, crée les icônes et efface les objets indisponibles/invalides ; source de géométrie et UV native. | Setup contrôle la longueur des fichiers, pas leur SHA à l’exécution. Les comparaisons SHA du présent audit sont distinctes. Pas de parité framebuffer démontrée. |
| même module :132–165 | Prépare les six Text, masque non-empilable/vide, garde ASCII/copie, reconstruit et retire les glyphes. | Piles de potions ; le contrat complet des charges n’en découle pas. |
| core/lib.rs:172–179 ; shop.rs:82–96 | inventory=[Option<u32>;6], inventory_counts=[u8;6], serde(default) ; occupé zéro brut devient une unité via max(1). | Absence héritée et zéro ne sont pas distingués ; ne pas casser cette convention sans décision de protocole. |
| consumables.rs:1–24 | UseItem reconnaît les deux consommables et retire une unité ; garde vivant, stun, ressources et file de potion. | Un autre actif renvoie item active not implemented ; la quantité de potion n’est pas une charge d’instance réutilisable. |
| main.rs:1351–1363 | Touches 1,2,3,5,6,7 identiques aux six événements par défaut originaux ; Digit4 n’alimente pas les six slots. | La lecture historique/merge/remappage complet de l’input et l’affichage des labels restent distincts. |
| native_hud_inventory_drag.rs:1–78,219–280 | Capture locale d’un slot occupé ; contexte session/joueur/époque/fenêtre/géométrie et état brut ; annulation sur changement ; envoie SwapItemsChecked au relâchement vers un autre slot. | Geste explicitement local ; callbacks/seuil natifs non récupérés ; aucun déplacement optimiste ni retry automatique revendiqué. |
| session_connection.rs:89–97,129–144 | Identité de geste disponible seulement si prêt ; commande via session sécurisée ou paquet legacy suivant le chemin actif. | Aucun nouvel essai réseau réel dans cet audit. |
| session_host.rs:137–147 → core/lib.rs:612–618 → shop.rs:323–347 | Commande adressée au participant accepté ; compare les tableaux bruts complets avant échange objets/quantités. Écart : inventory changed sans swap. | L’état d’instance/charge absent ne peut pas être préservé par un simple échange de ces deux tableaux. |

**Piles :** seules 2003 et 2004 sont empilables selon le prédicat local, maximum cinq. Le contrôle HUD est par slot ; quote_with_counts agrège à l’achat. L’état 3+3 peut passer chaque contrôle local d’affichage alors qu’un achat supplémentaire est refusé. Ce sont des règles de code déjà auditées, pas une nouvelle exécution ni une politique historique complète.

**Charges — cas nommé 2041 :** la recherche par nom dans le catalogue local retrouve Crystalline Flask avec trois charges et recharge à la boutique. L’entrée originale DATA/Items/2041.inibin est disponible et son SHA correspond au cache : `51f5781d42e273d6bd8b7d1062a761e673821a8e86a8ba2c1d180cac4a1a21ae`. Son champ SpellName désigne ItemCrystalFlask. L’objet ne fait pas partie du catalogue courant ; le consommateur ne doit donc pas prétendre afficher ses charges. Texte client et métadonnées ne récupèrent pas les callbacks serveur ni le cycle de vie de l’instance. Applicabilité du mode, état/autorité des charges, recharge, usage, déplacement et session sont les entrées précises pour reprendre INV-INSTANCE-CHARGES-01.

**Vision — borne 3340 :** l’entrée locale Warding Totem porte maps[10]=false. Le layout VisionSlot et la touche4 ne justifient donc pas son activation en 3v3. Cette restriction d’un objet ne prouve pas non plus toute la politique du slot de vision ou de tous les modes ; ne pas extrapoler silencieusement dans l’autre sens.

**Entrées originales :** les six événements GameEvents evtUseItem1…6 valent [1],[2],[3],[5],[6],[7]. evtUseVisionItem vaut [4]. evtUseItem7=[b] est conservé comme événement distinct, sans le convertir en septième slot d’inventaire ou de vision. input.ini contient des réglages Quickbinds smart, pas de remplacement de ces clés exactes dans les lignes retenues. Le chargeur/merge natif complet n’est pas exécuté.

La recherche nouvelle des noms InventoryActive/Sheen/Cooldown/Overlay/HotKey, ActiveItem0…5 et item_charges/instance_charges dans les 1168 fichiers Rust/JS/HTML identifiés ne retourne aucun consommateur supplémentaire. Les sources et chemins du corpus sont inchangés. Ce constat de noms complète les schémas et sélecteurs relus ; ce n’est pas une preuve d’absence sémantique universelle.

La fraîcheur de rendu et les règles de geste sont séparées : le drag vérifie ready/session/époque et état de joueur, alors que le rendu courant lit snapshot et connection.id avec ses propres gardes. Leurs signatures ne suffisent pas à qualifier toute reconnexion ou absence d’état périmé dans le client réel.

## R4 — Contrôles, attendu/observé et erreurs conservées

| Contrôle | Attendu | Observé |
|---|---|---|
| Ressources normales | Ne retenir comme capturé/chargé que les membres réellement sélectionnés | 58 définitions, 15 IDs Text ; 12 composants du renderer présent. |
| Actifs conditionnels | Ne pas inventer sélection ni capture native | 60 définitions séparées, zéro capture native héritée et zéro ID HUD antérieur pour ce fichier. |
| Icônes | Conserver provenance de chaque objet courant | 33 ponts config/DDS original/DDS consommé identiques ; deux potions seulement pour la pile. |
| Raccourcis | Vérifier avant d’annoncer une absence/erreur | Les six touches sont déjà conformes ; Text de raccourci et remappage intégral non qualifiés. |
| Charges et mode | Nommer une entrée exploitable et sa limite | 2041 et source native identifiés, toujours non pris en charge ; 3340 explicitement interdit Map10 dans le catalogue local. |
| Déplacement/refus | Conserver les protections existantes | CAS brut, annulation de contexte et refus de changement relus ; pas d’exécution fraîche ni de parité native proclamée. |
| Conservation | Aucune mutation du travail antérieur | 25 fichiers protégés, cinq registres et Git identiques ; HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ; 76 fichiers suivis déjà modifiés conservés. |

**Exécuté :** Python existant -X utf8 -E -B verify_inventory_v3.py, code0 ; **408 contrôles documentaires réussis**. Lectures ZIP/JSON/mmap, empreintes, comparaisons de sources/consommateurs et lecture Git. Les attendus/observés individuels sont dans checks du reçu.

**Preuve Rust héritée :** un seul test DDS/slots, daté du 23 octobre 2026 à 13:50:38.876186 UTC, code0. Log et reçu conservés/recontrôlés ; les quatre autres tests disponibles dans le module ne deviennent pas quatre nouvelles exécutions. L’ancien binaire et toutes les dépendances transitives ne sont pas requalifiés.

**Non exécutés :** Cargo/compilation/tests Rust, jeu actuel/historique, code natif ou REA, réseau, GPU/capture, application de suivi, base de données, installation, migration ou changement du goal. Neuf cas de quantité de COUNT-01 sont réutilisés comme déductions de code, pas comme observations runtime nouvelles.

**Échecs du vérificateur conservés :** v1 supposait à tort CenterHUD_ActiveItems sélectionné ; contrôle refusé. La v2 séparait les ressources, mais une erreur de syntaxe de remplacement a arrêté le script avant exécution. Les deux scripts et deux reçus d’échec sont gardés ; aucun reçu principal n’avait été écrit. La v3 est vérifiée syntaxiquement, garde la fiche initiale et sérialise le reçu avant son écriture exclusive. Aucun de ces défauts d’outillage n’est attribué au jeu. Une taille de fichier recopiée à tort dans le brouillon (12177) est rectifiée depuis la preuve source (18403 octets) ; le brouillon exact et son erratum sont conservés. Le reçu machine était déjà correct.

Une lecture préparatoire traitait à tort native_item_audit comme un dictionnaire ; son type liste a été confirmé avant utilisation. La piste numérique 2031 n’était présente dans aucune des deux entrées locales consultées ; la recherche par nom a fourni 2041. Ni défaut de fichier ni valeur de charge n’ont été inventés à partir de cette piste écartée.

## R5 — Manques et conditions de reprise

- Charges d’instance : utiliser 2041 comme cas nommé, confirmer mode et source de sa mécanique ; définir identité/quantité/charges distinctes, projection autorisée et horloge éventuelle, puis usage/recharge/déplacement/disparition. Le texte de catalogue n’est pas une implémentation serveur.
- Labels : raccorder séparément InventoryItemHotKey0…5 au binding réellement actif. Le mapping physique déjà conforme est conservé ; ne pas le refaire sur une supposition.
- États actifs/effets : choisir un objet réellement pris en charge et une autorité de récupération, puis sélectionner les éléments de la bonne liste. Ne pas activer les soixante composants conditionnels ou confondre quantité restante et cooldown.
- Vision : identifier la sélection de mode, son objet et son autorité avant de changer le modèle à six slots. Une ressource nommée, la touche4 ou evtUseItem7 ne suffit pas ; maps[10]=false pour 3340 reste une limite explicite.
- Catalogue : ajouter un seul objet nommé à la fois sous INV-CATALOG-01, après règle d’éligibilité/consommation/charge et icône vérifiées. Les autres IDs de la référence ne sont pas automatiquement tous requis dans le même mode.
- Affichage/geste : comparer aux sources et à une trace réelle, contrôle de contexte et réconciliation. Les 33 DDS et le mécanisme CAS existent ; ne pas les reconstruire. Réexécuter seulement les vérifications pertinentes après changement ou nouveau contexte.

Arrêt de la recherche courante : inventaire normal et contextes conditionnels classés, acquis et refus conservés, cas précis pour les charges identifié. Nouvelle recherche requiert un appelant natif, un contrat d’objet/mode ou une modification réelle du consommateur. L’audit documentaire peut se clore ; l’inconnue normative et la fonctionnalité restent ouvertes.

## R6 — Actions réutilisées, petites propositions non appliquées

Ces fiches complètent les preuves d’audit et ne changent ni goal, ni critères normatifs, ni plan. Une réalisation future choisit un objet/comportement précis ; aucun lot global « tous les objets » n’est adopté.

| Correction existante | Usage dans cette reprise |
|---|---|
| INV-RAW-COUNT-01 | Contrat d’absence/zéro/compatibilité ; convention max(1) conservée. |
| INV-AGGREGATE-01 | Admission de quantité répartie ; séparée du renderer. |
| INV-INSTANCE-CHARGES-01 | Cas maintenant nommé 2041, sources présentes ; conditions d’instance/autorité/mode ci-dessus, aucune réalisation implicite. |
| INV-COUNT-RENDER-01 | Rendu des six compteurs, cas d’absence/disparition/slot/session. |
| INV-CATALOG-01 | Ajout indépendant d’un objet nommé et de son icône/règle d’éligibilité. |

| Proposition non appliquée | Résultat et critère de fin | Condition de reprise |
|---|---|---|
| `INV-HOTKEY-LABELS-01` | Raccorder les six Text InventoryItemHotKey au binding effectif, un slot par cas — Source/label/action cohérents pour les six touches et leurs refus ; préserver le mapping déjà conforme, ne pas fabriquer un libellé depuis un autre slot. | Producteur de labels et remappage natif ou politique locale versionnée ; vrais glyphes et capture requises pour le rendu. |
| `INV-ACTIVE-FEEDBACK-01` | Raccorder état actif/récupération pour un seul objet nommé — Objet et autorité de récupération identifiés ; un slot affiche les bons icône/overlay/temps, masque inconnu et se réconcilie après déplacement. | Contrat de l’objet et choix de ses éléments Inventory*/ActiveItem*, aucune activation globale des soixante définitions. |
| `INV-VISION-SCOPE-01` | Qualifier séparément le slot de vision et son applicabilité au mode — Source de sélection de VisionSlot et objet admissible identifiés ; définir les limites du modèle six slots sans activer 3340 sur Map10 contre sa restriction explicite. | Règle de mode native ou politique locale nommée ; présence du layout et touche4 insuffisantes. |
| `INV-DRAG-FIDELITY-01` | Qualifier le geste local existant face à un comportement natif précis — Conserver CAS objets/quantités, contrôle de session/fenêtre/état et absence de mutation optimiste ; ajouter comparaison native et nominal/refus/capture pour le geste nommé. | Callback/seuil/trace native du drag ou contrat local assumé ; ancien test de DDS ne prouve pas le geste. |
| `INV-FULL-RENDER-LIFECYCLE-01` | Qualifier l’affichage des six icônes sur changements d’inventaire et de session — Un parcours achat/déplacement/usage/vente et pertes de source/session montre icônes et quantités cohérentes dans le vrai client, version/viewport identifiés. | Consommateurs et ressources déjà présents ; reprendre les tests/captures uniquement sur périmètre pertinent, ne pas récupérer à nouveau les33DDS. |

| ID HUD existant | Text | Sélection actuelle par le renderer d’inventaire |
|---|---|---|
| `HUD-0beb3b9c91219326` | InventoryItemCount0 | oui |
| `HUD-17405556e9e2f00f` | InventoryItemCount1 | oui |
| `HUD-6443198d215a09e9` | InventoryItemCount2 | oui |
| `HUD-02800e58ae94dedf` | InventoryItemCount3 | oui |
| `HUD-bbe4d1848f3d616c` | InventoryItemCount4 | oui |
| `HUD-09cb9d00cf6e3acf` | InventoryItemCount5 | oui |
| `HUD-ee65e713d4fe21bf` | InventoryItemHotKey0 | non, autre rôle ou non raccordé |
| `HUD-515c49247bfff404` | InventoryItemHotKey1 | non, autre rôle ou non raccordé |
| `HUD-b2d0d8e9dbf77e90` | InventoryItemHotKey2 | non, autre rôle ou non raccordé |
| `HUD-428f35f2cd803be0` | InventoryItemHotKey3 | non, autre rôle ou non raccordé |
| `HUD-9b2c2cd7445c9734` | InventoryItemHotKey4 | non, autre rôle ou non raccordé |
| `HUD-93009f00239715d6` | InventoryItemHotKey5 | non, autre rôle ou non raccordé |
| `HUD-d55726e4d3fdcde3` | InventoryItemCount6 | non, autre rôle ou non raccordé |
| `HUD-51c27c71700b7804` | InventoryItemHotKey6 | non, autre rôle ou non raccordé |
| `HUD-32ab87c3249c862a` | TargetItem6_Count | non, autre rôle ou non raccordé |

## R7 — Livraison, relecture et conservation

Nouveaux fichiers uniquement :

- F:/OpenLeague/docs/audit/units/AUD-17.1-05-INVENTORY-01.md, ce rapport.
- F:/OpenLeague-work/audit-units/AUD-17.1-05-INVENTORY-01/ : audit-unit.json ; verify_inventory.py, verify_inventory_v2.py et verify_inventory_v3.py ; attempt-1-failure.json, attempt-2-failure.json ; inventory-proof.json ; verify_delivery.py ; delivery-readback.json.

Reçu principal : SHA-256 `99764c03cf6a2ac9d806f4fa088e090eae2c4132c906c9a6ddd44cf8718b5ed1`. Identités de sources, corpus, entrées, ancien test, preuves de reprise et consommateur avec lignes dans ce reçu. Les 19 fichiers logiciels gelés et six documents de contexte restent identiques ; aucun registre normatif ou fichier antérieur remplacé.

Le lecteur indépendant recontrôle l’état courant, reconstitue les définitions et identifiants depuis l’inventaire original, classe à part les 60 éléments conditionnels, vérifie les sources de 2041 et les bindings, puis les sept rubriques. delivery-readback.json porte la clôture documentaire seulement si tous ces contrôles réussissent. La fonctionnalité et le goal restent incomplets.

Recontrôle sans écrire : Python existant -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-17.1-05-INVENTORY-01/verify_delivery.py --check-only. Les reçus sont exclusifs ; toute nouvelle preuve porte un nouveau nom. Aucun serveur de suivi ni aucune base ne sont ouverts.

Résolu : état complet des sources/consommateurs de cette exigence, touches déjà conformes reconnues, quantités et charges distinguées, cas2041 et limites de mode identifiés, fichiers et protections conservés. Ouvert : charges effectives, autres objets éligibles, labels/actifs/vision, fidélité du geste et comparaison graphique. Audit terminé ne signifie pas fonctionnalité terminée.
