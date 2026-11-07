# SYS-01.2-02 — Galio : liaison de Runic Skin au HUD, V1215

4 novembre 2026. Unité `AUD-SYS-01.2-02-GALIO-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Galio-PASSIF-PRESENTATION-HUD`, `OLF-2c20fcd2-ae0d-55dd-b977-f98a2d627b7f`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Galio-PASSIF-NETWORK`. L’inconnue `OLU-e6f4c41a-d21a-5723-9668-fc6406015909` reste ouverte.

Ce lot relie déclarations, ressources et conversion RM→AP aux consommateurs inspectés. Résistance totale ou bonus, réduction de résistance de la cible, pénétration de la source, AP des objets et multiplicateurs d’autels sont distincts. Le passif moderne n’est pas une référence4.20.

## 2. Sources, identité et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Reçu primaire V546 daté 2026-10-25T18:19:55.861481+00:00, sans date d’exécution déduite. Six identités natives datées réutilisées sans nouvelle lecture de métadonnées : définition, font, buff INIBIN/Lua, CharScript Lua/preload. Dix-huit associations historiques concernent trois tâches ; HUD porte une relation native, définition `OLS-c7854e66-def3-5360-9340-743830fcf5e1`.

`Passive1LuaName=GalioRunicSkin`, `Passive1Icon=Galio_RunicSkin.dds`. BuffName et BuffTextureName concordent. Les quatre PassLev1Desc pointent vers game_character_passiveDescription_Galio ; leur répétition ne démontre pas des rangs. Tooltip1930 et description4188 indiquent50% de RM, la description précise totale. Nom Runic Skin conservé ; producteur @f1@ inconnu.

Passive1Desc ancien décrit1AP pour3armure et3RM : conservé sans adoption. Passive1=9 et niveaux3/7/11 sont des littéraux, sans activation initiale ou politique de rang qualifiée. SpellBlock32.099998474121094, croissance1.25 ; BaseSpellBlock absent ne reçoit aucun défaut inventé.

Deux Lua hérités entièrement parsés, sans prototype enfant : buff214octets avec déclarations de persistance/non-dissipation ; CharScript56octets avec RETURN seul. Preload galiorunicskin/apbonusdamagetotowers : présence distincte d’une exécution. Deux JSON communautaires et CharScript communautaire vide restent secondaires. Observations historiques déjà pinées capturées exactement E, origine F-work inerte ; gardes inchangées.

Inventaire exact avant les lectures DDS nécessaires :

| Chemin | Octets / format | Version du membre, projet sélectionné core0.0.1.7 |
|---|---|---|
| DATA/Characters/Galio/info/Galio_RunicSkin.dds | 2872 / 64×64 DXT1, champ mip brut=7 | 0.0.0.25 |
| DATA/Spells/Icons2D/Galio_RunicSkin.dds | 2872 / 64×64 DXT1, champ mip brut=7 | 0.0.0.25 |

SHA-256 des contenus : `a78c10b4ae9c0c7e0c793c123b0fbe0259891e0b1418f76d64ccf9da33ad0772`. Captures E exactes, tailles/MD5 conformes au manifeste sélectionné ; identité ne prouve ni alias, priorité, pixels ou rendu. Aucun OLS créé. Textes anglais conservés bruts, f1 non substitué ; provenance V546 et preuve Ahri comparées au miroir F, font D non relu. Locale effective et lookup restent ouverts.

## 3. Consommateurs courants

CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` : catalogue appelé par Simulation::new. Ce lecteur et les autres sites SOURCE sont des frontières de données.

Provider/StartupHud et plugins ordinaires existent. Sélecteurs, textes, barres, widgets QWER-D/F et payloads inspectés n’établissent aucun binding Runic Skin pour icône, texte, rang, bonus converti ou états. HP/Mana, Buff0 Ezreal et F3/Annie4 restent distincts. InventoryIcon QWER et maxima/learning ne prouvent pas un rang passif. Recherche corroborative bornée, sans absence globale de code ou d’alias déduite.

Join, achats/ventes, refresh_item_caps, shop::bonuses, stats, autels et advance sont inspectés. Les calculs RM de base/croissance/objets et modificateurs temporaires, ainsi que l’AP des objets et les multiplicateurs courants, restent établis. Aucun producteur spécifique de conversion Galio relié au HUD n’est identifié dans ces corps. Afficher une statistique AP/MR ne prouve pas son origine Runic Skin ; projection et horloges génériques ne fournissent pas un état qualifié du passif.

## 4. Attendu, observé et contrôles

Attendu : ressources et bonus/états autoritaires du passif reliés aux audiences/widgets qualifiés. Observé : déclarations et chemins génériques réels, liaison spécifique non établie. Sources 70/70, consommateurs 47/47 contrôles documentaires ; aucun nouveau scénario HUD nominal/refus exécuté.

Seize fichiers/29 extraits communs ;4 fichiers/10 sites V546 et deux lecteurs/six sites SOURCE comparés ;2 nouveaux pins/11 fenêtres nécessaires. Le gate initial a refusé annie_w.rs non piné avant toute sortie ; collecteur archivé, pin ajouté. Deux attendus d’horodatage convertis à tort ont été corrigés selon les littéraux JSON UTC, avec script/échec antérieurs archivés. Aucune recapture native. Preuves communes réutilisées, sans census.

V546 hérité : deux parties publiques Galio/Ahri au niveau1, sans injection. Galio RM32.1 puis57.1 avec1033(+25),AP0 dans les deux cas ; calcul arithmétique du texte16.05/28.55, delta12.5. Ces prédictions ne démontrent pas l’activation native au niveau1. Trente ticks stables, ventes rétablissant les valeurs ;1052 donne20AP,1029 donne15armure sans conversion observée. Ahri témoin RM30→55/AP0, puis20AP au Tome : aucune prédiction Galio attribuée au témoin. Dix refus atomiques avec snapshots individuels inchangés.

Binaire hérité identifié dans V546 :5998592octets, SHA256 `36803f17bedd74d09c5212be070a35fc50b10eca3892407103f1071f4dd2f52a`, build/run0 historiques. Aucun replay, build, test produit, VM, REA, runtime, GPU, réseau, audio ou rendu exécuté ici. Niveaux, activation initiale et comportement natif restent indéterminés.

## 5. Écarts et inconnues

Producteurs du passif/f1, activation initiale, rang applicable, niveaux, arrondis, ordre avec réductions temporaires/RM négatives/autels, mort/réapparition, lookup/états, audiences/reconnexion et rendu restent ouverts. Le texte lié qualifie une déclaration ; les essais qualifient les observations courantes de niveau1, sans serveur original exécuté. Aucun besoin de reconstruction graphique établi.

## 6. Correction et reprise

Réutiliser `CH-Galio-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Critères : qualifier ressources/textes/lookup et politique de rang/activation4.20 ; définir puis produire la conversion RM totale→AP et f1, avec ordre/arrondis et états ; relier les audiences et widgets autorisés, sans valeur/rang/activation fictifs ; vérifier niveaux, achats/ventes, modificateurs/autels, retrait/mort/reconnexion et refus de données invalides/périmées/non autorisées avec rendu identifié ; conserver témoins et statistiques génériques ; obtenir séparément l’acceptation humaine applicable. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise ; ne pas rejouer V546 inchangé ni adopter le texte tiers pour combler les manques.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_galio_passive_hud_20261104`, sources/captures/manifestes, consommateurs, scripts/journaux, result et finalpeer. Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes et sept protégés avant/après/readback.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée ; fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
