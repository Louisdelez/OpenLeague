# SYS-01.2-02 — Dr. Mundo : liaison de Nevershade au HUD, V1210

4 novembre 2026. Unité `AUD-SYS-01.2-02-DRMUNDO-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-DrMundo-PASSIF-PRESENTATION-HUD`, `OLF-16925a3f-4bb1-5c3f-a073-04640550f4f0`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-DrMundo-PASSIF-NETWORK`. L’inconnue `OLU-3413cd34-3216-537d-8ce5-04ce0c3bb03d` reste ouverte.

Le lot relie les déclarations Nevershade/AdrenalineRush aux consommateurs courants, en séparant HP, régénération de base et autres soins du passif. Aucun compteur, charge, cooldown ou état récent de Mundo n’est inventé. V542 et les voies communes ne transfèrent aucune clôture.

## 2. Sources, identité et provenance

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Six identités V542 datées réutilisées sans nouvelle lecture des métadonnées natives. Les18associations historiques concernent trois tâches, pas18ressources. HUD porte une seule relation native, définition `OLS-43c7dad5-4d18-5a75-8800-427dc769783c` ; CharScript reste une source V542 distincte, sans ajouter une seconde relation HUD.

`Passive1LuaName=Nevershade`, `Passive1=1`, `Passive1Icon=DrMundo_AdrenalineRush2.dds`. Le buff déclare DrMundo_AdrenalineRush.dds. Ces noms restent distincts. Ancien Passive1Desc20/30/40%dégâts sous40%PV conservé sans adoption. BaseStaticHPRegen1.5520000457763672, BaseFactorHPRegen chaîne`0`, BaseHPRegen absent : ni règle serveur ni zéro de remplacement. Rang/applicabilité non qualifiés. Deux Lua hérités entièrement parsés, sans prototype enfant ; CharScript RETURN-only et flags Nevershade NonDispellable/PersistsThroughDeath ne prouvent ni cadence ni persistance exécutée. Références communautaires secondaires, classe C# vide sans absence mondiale déduite.

Inventaire initial limité aux chemins HUD corrigé vers les basenames exacts dans Characters/DrMundo/Info, avant lecture des payloads ; script/preuve initiaux conservés. Trois DDS,6528octets :

| Chemin | Octets / format | Membre core0.0.1.7 |
|---|---|---|
| DATA/Characters/DrMundo/Info/DrMundo_AdrenalineRush.dds | 2176 / 64×64 DXT1, champ mip brut=0 | 0.0.0.25 |
| DATA/Characters/DrMundo/Info/DrMundo_AdrenalineRush2.dds | 2176 / 64×64 DXT1, champ mip brut=0 | 0.0.0.25 |
| DATA/Spells/Icons2D/DrMundo_AdrenalineRush.dds | 2176 / 64×64 DXT1, champ mip brut=0 | 0.0.0.25 |

Un contenu SHA-256 `a4b90988dc714e4db8ebd58c769fcf11fbc8d2bf67ce5a2b6bfe033d3995541e`. Tailles/MD5 conformes au manifeste sélectionné. Même contenu ne prouve ni alias, ni priorité de lookup. Captures E exactes issues des lectures D de ce lot ; aucun OLS créé, pixels/rendu non qualifiés. Localisation Info ne démontre pas un asset manquant.

Un preload V542 conserve ses références nevershade/apbonusdamagetotowers comme déclarations, pas des effets exécutés. Textes en_GB Nevershade2349 et description4181 annoncent0,3%vie maximale/seconde ; nom Adrenaline Rush conservé. 0.003 est une conversion arithmétique du texte, pas une cadence serveur récupérée. Provenance font V542/reçu Ahri exact/empreinte du miroir F comparée ; Font D non relu, locale effective ouverte.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et cinq sites lecteurs SOURCE restent des frontières de données.

Provider/StartupHud et plugins ordinaires sont montés. Les18textes/11barres/14widgets QWER-D/F et payloads inspectés n’identifient aucun binding Nevershade icône/texte/rang/états. HPStat/HPBar existent ; afficher les PV ne prouve pas la présentation du passif. Buff0/BuffIcon0/BuffStack0 Ezreal, F3/Annie4 et QWER restent distincts. Quatre icônes primaires,0variante/0unresolved ; ManaCost1..5=0 littéraux ne qualifient ni gratuité ni coûtPV. Recherche .rs corroborative après les corps, sans absence globale de code, alias ou assets.

regeneration_rates calcule base/croissance/bonus objets. advance_regeneration ajoute la voie Garen puis healing::received_multiplier, applique le tick et plafonne aux PV maximum. Les voies Garen, Ignite, Trundle et heal existent ; aucune ne qualifie le supplément Nevershade dans les corps lus. stats et achats calculent les PV maximum ; HP/soins génériques, flags natifs et changement de maximum ne fournissent pas un état autoritaire spécifique ni sa liaison au HUD.

## 4. Attendu, observé et contrôles

Attendu : ressources, texte et états réellement applicables du passif reliés aux audiences/widgets qualifiés. Observé : sources et chemins génériques réels, aucune liaison Nevershade spécifique établie dans le trajet inspecté. Sources59/59, consommateurs41/41 contrôles documentaires ; aucun nouveau nominal/refus HUD exécuté.

Seize pins/29fenêtres communs, sept fichiers/dix sites V542 et deux lecteurs/six sites SOURCE concordent. Auxiliaires sélectionnés comparés et 11pins/12fenêtres directes ; inventaires et analyses historiques réutilisés sans census.

V1210 conserve l’inventaire initial et sa correction Info, ainsi qu’une syntaxe Python refusée avant exécution/lecture DDS, puis corrigée. Deux parses manifeste documentés ; aucun échec produit inféré. Ces tentatives sont distinctes des erreurs historiques V542 ci-dessous.

V542 : deux fenêtres180ticks chacune, niveau1 vivant sous plafond, sans soin/PV injectés. Maximum582.52001953125 puis732.52001953125 avec Cristal1028(+150PV) ; base1.552PV/s seulement. Supplément textuel attendu1.74756 puis2.19756PV/s, non observé ; ne pas convertir la somme des différences par tick en seconde trajectoire contrefactuelle cumulée. Les six/sept coups ennemis préparent les fenêtres, pas un déclenchement qualifié. Deux contrôles30ticks à pleine vie avant achat, six refus Attack et deux None de regeneration_rates hérités. Erreur initiale «achat150PV remplit150PV» et erreur de syntaxe conservées ; leurs corrections qualifiées ne sont pas des défauts du jeu. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté ici.

## 5. Écarts et inconnues

Producteur du supplément, cadence serveur, progression/rang applicable, ressources/lookup, états réellement requis, mort/persistance/réapparition, changement de maximum, réduction/amplification, audiences/confidentialité, reconnexion et rendu restent ouverts. Base, soins et affichage HP ne remplacent pas Nevershade. Aucun besoin de reconstruction graphique démontré.

## 6. Correction et reprise

Réutiliser `CH-DrMundo-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/lookup4.20 et rang/états applicables ; qualifier état autoritaire et événements utiles sans compteur/cooldown fictif ; intégrer widgets/refus sans faux zéro/activation ; vérifier vivant/plein/mort/réapparition, variations de maximum, modificateurs, audiences/reconnexion et rendu identifié ; séparer HP/base/Garen/Trundle/Ignite/heal et autres widgets du passif ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, mapping, producteur/consommateur ou contrat pertinent, ou dérive précise, sans rejeu inchangé. Cadence et variantes restent inconnues jusqu’à preuve.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_drmundo_passive_hud_20261104` : source_worker/sourceproof.json, inventaires/captures/manifestes/archives, reçu consommateur, scripts/journaux, result.json et finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes et sept protégés contrôlés avant/après puis relus.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
