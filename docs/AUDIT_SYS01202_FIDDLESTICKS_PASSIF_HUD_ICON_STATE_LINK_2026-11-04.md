# SYS-01.2-02 — Fiddlesticks : liaison de Dread au HUD, V1213

4 novembre 2026. Unité `AUD-SYS-01.2-02-FIDDLESTICKS-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-FiddleSticks-PASSIF-PRESENTATION-HUD`, `OLF-504b01ef-f5ec-5638-9840-fbbfd6b41bcd`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-FiddleSticks-PASSIF-NETWORK`. L’inconnue `OLU-5f6cae13-d622-50c8-a146-1e90d84e06cf` reste ouverte. Identité canonique FiddleSticks conservée.

Ce lot relie aura/source/cible, ressources et marqueur aux consommateurs HUD inspectés. Réduction de résistance magique de la cible, pénétration du lanceur, statistiques et dégâts génériques restent distincts. Fearmonger/Drain, Nocturne et versions récentes ne reçoivent aucune autorité Dread.

## 2. Sources, identité et provenance

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Reçu V568 UTC2026-10-25T23:34:13.335383+00:00 : neuf identités retenues parmi dix candidats, datées et réutilisées sans nouvelle lecture des métadonnées natives. Les27associations historiques concernent trois tâches, pas27ressources. HUD porte une relation native, définition `OLS-1c3d6951-d205-57dd-87b6-aff191d268f4`.

`Passive1LuaName=Paranoia`, `Passive1Icon=Fiddlesticks_Paranoia.dds`, buff concordant. Passive1/Passive1Desc, PassLev1Desc1 et six niveaux explicitement null restent sans valeurs par défaut. La description de personnage trouvée est candidate de localisation : aucune liaison de champ PassLev1Desc1 inventée.

Trois Lua hérités entièrement parsés, initialisations littérales sans prototype enfant. CharScript sans global littéral ; PersistsThroughDeath/NonDispellable ne prouvent pas la politique serveur. ParanoiaMissChance déclare BuffName=Paranoia Aura, pas un effet de raté déduit du nom. Fearmonger_marker, BuffNameDrain et sa particule restent un candidat exclu ; NocturneParanoia/NightmareBot et textes Doom ne sont pas liés à Dread. Huit références communautaires, dont CharScript vide, restent secondaires.

Inventaire exact avant les deux lectures DDS,8448octets :

| Chemin | Octets / format | Membre core0.0.1.7 |
|---|---|---|
| DATA/Characters/FiddleSticks/info/Fiddlesticks_Paranoia.dds | 4224 / 64×64 DXT5, champ mip brut=0 | 0.0.0.172 |
| DATA/Spells/Icons2D/Fiddlesticks_Paranoia.dds | 4224 / 64×64 DXT5, champ mip brut=0 | 0.0.0.25 |

Un contenu SHA-256 `8d5275a2d4b3a7cfb435cb4f8eddcfcfdef47dbd7c9dfeb5c0134db14321917f`. Tailles/MD5 conformes au manifeste sélectionné ; identité ne prouve ni alias, ni priorité, ni pixels/rendu. Captures E exactes issues des lectures D de ce lot ; aucun OLS créé, aucune texture du candidat exclu recherchée pour ce lot.

Découverte V568 déjà épinglée capturée byte-identique E,343484octets, pour les deux preloads et références communautaires. Original horsracines non rouvert au gate, gardes inchangées ; déclarations sans aura/chargement qualifiés.

Quatre clés en_GB : Paranoia2449 décrit10points de résistance magique retirés aux unités ennemies proches ; Paranoia_Aura2450 décrit la cible affectée et SourceName ; description candidate4185 concordante ; nom4361Dread. Rayon, éligibilité, cumul, maintien après sortie et source de substitution restent inconnus. Provenance font V568/reçu Ahri exact/empreinte du miroir F comparée ; Font D non relu, locale effective ouverte.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et cinq sites lecteurs SOURCE restent des frontières de données.

Provider/StartupHud et plugins ordinaires sont montés. Les18textes/11barres/14widgets QWER-D/F et payloads inspectés n’identifient aucun binding Dread icône/texte/rang/aura/source/cible. HP/Mana, Buff0/BuffIcon0/BuffStack0 Ezreal et F3/Annie4 restent distincts. QWER contient quatre primaires et quatre variantes E/R ; setup sélectionne InventoryIcon, sans qualifier Dread ou les variantes actives. Recherche .rs corroborative après les corps, sans absence globale de code, alias ou assets.

stats agrège base/croissance/objets, Annie, Exhaust et TrundleR ; ces modificateurs réels ne sont pas Dread. penetrated_defenses lit les bonus de pénétration de la source avant mitigation ; modifier ce calcul ne prouve pas une réduction de la résistance propre de la cible. apply_damage/Magical, boucliers et statistiques existent sans producteur Paranoia identifié dans les corps lus. Ni les valeurs MR ordinaires, ni les dégâts génériques ne fournissent un état autoritaire d’aura relié au HUD.

## 4. Attendu, observé et contrôles

Attendu : ressources, application/retrait de l’aura et source/cibles autoritaires reliés aux audiences/widgets qualifiés. Observé : sources et chemins génériques réels, aucune liaison Dread spécifique établie dans le trajet inspecté. Sources64/64, consommateurs44/44 contrôles documentaires ; aucun nouveau nominal/refus HUD exécuté.

Seize pins/29fenêtres communs, douze fichiers/24sites V568 et deux lecteurs/six sites SOURCE concordent. Auxiliaires sélectionnés comparés et 8pins/13fenêtres directes ; inventaires et analyses historiques réutilisés sans census. Le premier gate42/43, incomplet en pins shields/server, est archivé ; couverture corrigée, dépendance recap inutile retirée, helpers maxima/learning QWER pinés sans les assimiler au rang passif. Aucun échec produit déduit de ces révisions documentaires.

V568 trois phases publiques à250unités pendant300ticks/10s chacune : cible Annie MR30 près de Fiddlesticks,55 avec1033(+25),30 près de Garen ;33refus atomiques. Achat/mouvement publics, sans injection de stats.250 est une distance d’essai, pas le rayon natif ; résultat confronté aux chemins actuels, pas qualification du rayon/éligibilité/cadence historiques.

Après chaque phase, événement serveur explicite apply_damage(100,Magical) : dégâts76.92308044/64.51612854/76.92308044, avec9refus de diagnostic. Ces résultats qualifient la mitigation courante, pas un sort public ou un déclenchement/amplification Dread. Les phases restent séparées.

Premier driver build0/run101 : mauvais chemin JSON bonuses.magic_resist au lieu du champ objet magic_resist. Driver/binaire/log conservés ; version qualified distincte build/run0, sans défaut produit déduit. Mouvement V564 et chaîne antérieure ouverts. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté ici.

## 5. Écarts et inconnues

Rayon/éligibilité/cibles, cadence, sortie/maintien, mort/réapparition, cumul de plusieurs sources, ordre avec modificateurs/résistances négatives, rang/lookup/états, SourceName, audiences/confidentialité/reconnexion et rendu restent ouverts. Réduction cible et pénétration lanceur ne sont pas interchangeables. Aucun besoin de reconstruction graphique démontré.

## 6. Correction et reprise

Réutiliser `CH-FiddleSticks-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/rangs/lookup4.20, rayon et source/cibles ; qualifier états autoritaires application/retrait/maintien/cumul et audiences ; intégrer widgets/refus sans faux zéro/rayon/activation ; vérifier entrée/sortie, sources multiples, mort/reconnexion, ordre des modificateurs et confidentialité avec rendu identifié ; séparer MR/objets/Annie/Exhaust/Trundle/pénétration et dégâts diagnostiques du passif ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, mapping, producteur/consommateur ou contrat pertinent, ou dérive précise, sans rejeu inchangé ni rayon déduit de250.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_fiddlesticks_passive_hud_20261104` : source_worker/sourceproof.json, inventaires/captures/manifestes, reçu consommateur, scripts/journaux/archives, result.json et finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes et sept protégés contrôlés avant/après puis relus.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
