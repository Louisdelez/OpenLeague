# SYS-01.2-02 — item 3114 : régénération de mana de base et consumer actuel

Date de contrôle : 2026-11-02 UTC. Unité : `AUD-SYS01202-ITEM3114-BASE-MANA-REGEN-01`. Exigence parente : `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`.

## Lot, frontière et décision

Question : le bonus de régénération de mana de l’Idole interdite est-il attesté dans la référence 4.20, relié à la donnée Map10 et appliqué par le simulateur actuel ?

Résultat attendu de la cartographie : identifier le champ natif `PercentBaseMPRegenMod`, sa valeur, l’admission locale et le calcul de taux/ticks. Cas nominal attendu dans le modèle local : pour un champion qui utilise le mana, un taux de base `r` au niveau courant devient `1,6 × r`. Limite : un champion qui n’utilise pas le mana ne reçoit pas ce bonus; un état qui ne restaure pas de ressource ne régénère pas.

**Décision :** l’audit statique de la relation source→catalogue→consumer est terminé pour la régénération de mana du 3114. Le champ natif et le tooltip en_GB concordent avec la donnée locale à 60 %, et le consumer actuel est identifié. Aucun contrôle d’exécution du 3114 n’a été fait; le comportement serveur historique et l’arrondi exact de la ressource restent ouverts.

## Sources et identité

INIBIN natif : `DATA/Items/3114.inibin`, build de référence `PUBLIC 4.20.0.315 EUW/en_GB`, release extraite `0.0.1.68`. `docs/fidelity_sources_4_20.json` identifie le fichier sous `OLS-50640763-f9d2-561d-89d2-bc02f1bb1632`, 558 octets, SHA-256 `ab572056875e390973fdb9c2f46510d68c9eb9b73865d2d83f7b92da5986cc0e`; rehash courant concordant. Le reçu de membership associe chemin, taille et MD5 au manifeste sélectionné (`lol_game_client`, project/release `0.0.1.7`); la precedence effective du runtime n’est pas qualifiée.

Le lecteur local en lecture seule `tools/project-plan/reference_inibin.py` a décodé `Data*PercentBaseMPRegenMod=0.6000000000000001`, `Data*Effect1Amount=-0.10000000149011612` et `Data*Price=240`, avec recette 1004+1004. Le champ de régénération de base, et non le champ distinct `PercentMPRegenMod=0`, est celui relié à cette unité.

Le reçu de comparaison communautaire indique 70 champs égaux, 0 différents et 0 clé native absente. Le miroir a le SHA-256 `7274d2ef57c563f4f85e3d0d1a72489f3c4ce6aa6e6a289a255111927a858029`; `ContentFormatVersion=4` est un format d’export et le commit exact reste inconnu.

La localisation primaire `DATA/menu/fontconfig_en_GB.txt`, clé `game_item_description_3114`, ligne 6766, a été identifiée en V844 sous `OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d`. Son SHA-256 vérifié est `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`; membership du client confirmée. Elle affiche +60 % de régénération de base et la formule `round(0.6 × BaseManaRegenRate × 5)`. Elle prouve la valeur descriptive côté client, pas l’exécution serveur.

## Donnée et consumer courants

`data/4.20/shop_foundation.json` relie le même SHA source à `mana_regen_percent=0.6000000000000001`, 10 % de réduction des délais, recette 1004+1004 et coût total 600. `data/4.20/map10_shop_admission.json` admet l’item. Empreintes courantes : shop foundation `504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae`; admission `6393e7c2a39abed63b6f3db36c265e94d5ce2fc5435e29c17ccf012f288ad485`.

Consumer courant, rehashé pour ce lot :

- `crates/core/src/shop.rs:223-240` agrège `mana_regen_percent`; `:185-189` expose le taux de régénération de base pour le calcul de devis, selon la ressource utilisée.
- `crates/core/src/regeneration.rs:10-27` appelle `shop::bonuses`, ajoute le facteur `1 + mana_regen_percent` pour un champion utilisant le mana et dont le cycle restaure les ressources. La fréquence et l’application par tick se trouvent dans `advance_regeneration`.
- Les empreintes actuelles sont `shop.rs` `3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0` et `regeneration.rs` `d0a0731627f3d21f27b2aedb4c0aa67e68ad32def3e950b251069798ffb8ed07`.

Preuves antérieures réutilisées avec leur frontière : `AUDIT_SYS01202_ITEM1004_BASE_MP_REGEN_LINK_2026-11-02.md` identifie le même consumer et un contrôle sur 1004 à +25 %. Ce résultat ne prouve pas l’achat ni le taux du 3114. Le code courant `cooldown.rs` achète 3114 dans un scénario de réduction des délais, pas dans un test de régénération du 3114. Aucun test d’effet de régénération propre au 3114 n’a été trouvé dans la recherche ciblée.

## Attendu, observé et contrôles

- Attendu local nominal : si `r` est le taux de base au niveau courant d’un champion utilisant le mana, le taux avec un 3114 est `r × 1,6`; le tooltip affiche ensuite une quantité arrondie par tranche de 5 secondes.
- Limites locales : aucun bonus de mana pour un champion qui n’utilise pas cette ressource; aucune restauration durant les états filtrés par `restores_resource`.
- Observé statiquement : champ natif `PercentBaseMPRegenMod≈0,6`; tooltip en_GB à +60 %; catalogue reprend 0,6 et le SHA; Map10 l’admet; le consumer calcule le multiplicateur. Aucune valeur de taux ou de mana n’a été observée en exécution avec le 3114.
- Contrôles effectués : décodage en lecture seule du seul INIBIN; SHA-256 de la source, des données et du consumer; lecture du comparatif/membership; lecture ciblée de la clé en_GB; inspection du consumer et réutilisation du contrôle 1004 pour son seul périmètre.
- Contrôles non exécutés : tests Rust, build, binaire, achat 3114, observation d’un taux ou de ticks, réseau, client graphique ou serveur historique.

## Écarts et reprise

La règle serveur historique, la priorité du fichier en runtime, l’observation du bonus 3114 en jeu, le mode d’arrondi effectif (notamment face à la quantité affichée arrondie par 5 s), la transmission réseau et l’acceptation humaine restent ouverts. Le test 1004 antérieur n’est pas substitué à une preuve 3114.

Proposition documentaire non inscrite au registre : `OPEN-ITEM-3114-CURRENT-BASE-MANA-REGEN-VERIFY`. Reprise avec vérification autorisée liée aux sources actuelles : acheter 3114 sur un champion utilisant le mana; comparer le taux de base et le taux avec l’objet (`×1,6`) à plusieurs niveaux; observer les ticks sur une durée mesurée; vérifier le refus/non-effet pour un champion sans mana et dans un état qui ne restaure pas; rapporter séparément l’écart d’arrondi et la preuve réseau. Utiliser une source serveur versionnée pour conclure sur la fidélité historique.

## Relecture des sept critères

1. Exigence et frontière limitées au bonus de régénération de base du 3114.
2. Source native numérique, tooltip primaire, identité, membership et limites de version établis.
3. Donnée Map10 et consumers du taux/tick repérés.
4. Attendus et constats statiques explicités; exécution 3114 clairement non faite.
5. Manques et conditions de reprise nommés.
6. Vérification fonctionnelle future dotée d’un ID proposé; aucun registre/statut modifié.
7. Rapport daté, chemins, hashes et preuves antérieures réutilisées avec limites.

**Clôture limitée :** cartographie statique du 3114 terminée. Le bonus est implémenté dans le modèle local; comportement de l’item en exécution, fidélité serveur et acceptation restent ouverts. Aucun code, registre, goal, Plan, application ou base de suivi modifié; aucun logiciel installé, aucune migration, aucun test/build/runtime lancé.

