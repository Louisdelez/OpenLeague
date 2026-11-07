# SYS-01.2-02 — Elise : liaison de Spider Swarm au HUD, V1211

4 novembre 2026. Unité `AUD-SYS-01.2-02-ELISE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Elise-PASSIF-PRESENTATION-HUD`, `OLF-9c417be4-02ff-5927-82b2-dec600f3f268`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Elise-PASSIF-NETWORK`. L’inconnue `OLU-e5ddca43-ec81-56b3-ba47-35d53a66f378` reste ouverte.

Le lot relie ressources, forme, réserve et araignées aux consommateurs HUD inspectés. Réserve préparée par touches de sorts humains, forme araignée et araignées vivantes restent distinctes. R, IA/familiers, animation/VFX/audio, réseau et mouvement ne reçoivent aucune clôture transférée.

## 2. Sources, identité et provenance

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Quarante-et-une identités V566 datées réutilisées sans nouvelle lecture des métadonnées natives. SOURCE47relations/41identités ; HUD deux relations définition `OLS-b9c6ff97-a8a4-5d7a-85b4-11436ba3f556` et CharScript `OLS-5298518b-5c7c-5941-9b79-bdda91e9797f`. Les123associations historiques concernent trois tâches, pas123ressources.

`Passive1LuaName=ElisePassive`, `Passive1Icon=ElisePassive.dds`, buff concordant. Trois définitions Elise/EliseSpider/EliseSpiderling sont distinctes ; portées littérales«550»/125/175, vitesses335/345/345 et slots humains/araignée ne prouvent pas leur sélection effective. Passive1 absent et six niveaux null explicitement interrogés ne deviennent pas valeurs par défaut ; rang/applicabilité restent ouverts.

Vingt-cinq Lua hérités entièrement parsés, initialisations littérales sans prototype enfant ; globals vides ou flags de persistance/slot ne prouvent pas des callbacks serveur. Spider1..5 ne prouve pas un plafond5. Anciens textes régénération alliée/+40/+60/+80%mana, référence Morgana et littéraux Swain/Akali/Twitch conservés sans règles étrangères, réécriture d’alias ou diagnostic de corruption. Quatorze références communautaires restent secondaires ; R.cs simplifié ajoute/retire marqueur et particule, sans transformation native prouvée.

Inventaire exact avant les deux lectures DDS,10496octets :

| Chemin | Octets / format | Membre core0.0.1.7 |
|---|---|---|
| DATA/Characters/Elise/HUD/ElisePassive.DDS | 8320 / 128×128 DXT1, champ mip brut=1 | 0.0.0.130 |
| DATA/Characters/Elise/HUD/Icons2D/ElisePassive.DDS | 2176 / 64×64 DXT1, champ mip brut=1 | 0.0.0.130 |

- `DATA/Characters/Elise/HUD/ElisePassive.DDS` : `342dfeed57d2e1d99070d3ffba20f66a19ff9a6a0537a0aabfa71ab949450164`.
- `DATA/Characters/Elise/HUD/Icons2D/ElisePassive.DDS` : `68b6a22c512ab1b7fca8ebe9615f14549f2f74709a1a9a9f6bc5c20771dbbcc4`.

Deux contenus, tailles/MD5 conformes au manifeste sélectionné. Aucun autre basename étranger lu ; priorité de lookup, variante et pixels rendus inconnus. Captures E exactes issues des lectures D de ce lot ; aucun OLS créé.

Découverte V566 déjà épinglée capturée byte-identique E,570981octets, pour conserver six preloads1602octets/22références. Original horsracines non rouvert au gate, gardes inchangées ; déclarations sans invocation, chargement ou rendu acceptés.

Trois clés en_GB : tooltip1853, description4182 et nom Spider Swarm. Les sorts humains touchant un ennemi préparent une araignée, maximumf3 ; forme araignée invoque pour attaquer les ennemis proches. Producteur de f3, plafond et transitions inconnus. La fermeture brute `</postScriptLeft>` est préservée sans normalisation ; parse/rendu non qualifiés. Provenance font V566/reçu Ahri exact/empreinte du miroir F comparée ; Font D non relu, locale effective ouverte.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et cinq sites lecteurs SOURCE restent des frontières de données.

Provider/StartupHud et plugins ordinaires sont montés. Les18textes/11barres/14widgets QWER-D/F et payloads inspectés n’identifient aucun binding Spider Swarm icône/texte/rang/réserve/forme/araignées. HP/Mana et QWER configurés ne prouvent pas une transition de forme ou de slots. Quatre primaires humains et deux variantes R déclarés ; setup sélectionne InventoryIcon, pas une forme. Les limites génériques de rang, dont R>3, ne qualifient pas le rang natif d’Elise. Buff0/BuffIcon0/BuffStack0 Ezreal et F3/Annie4 restent distincts. Recherche .rs corroborative après les corps, sans absence globale de code, alias ou assets.

join initialise les rangs ordinaires[0;4] ; Learn/Cast et sélection des définitions ne qualifient pas les rangs particuliers d’Elise. Les attaques ordinaires ne constituent pas les touches de sorts décrites. world possède une fabrique d’unités et inscrit annietibbers ; annie_r porte cast, propriétaire, expiration, ordres et aura. Snapshot et chemins d’audience projettent des unités/owners ; cela ne fournit pas un état réserve/forme/f3 ni les audiences spécifiques d’Elise. Ces chemins existants sont conservés sans assimiler Tibbers aux araignées.

## 4. Attendu, observé et contrôles

Attendu : états autoritaires réserve/forme/araignées, ressources et audiences qualifiés reliés aux widgets. Observé : sources identifiées et voies ordinaires réelles, aucune liaison Spider Swarm spécifique établie dans le trajet inspecté. Sources56/56, consommateurs43/43 contrôles documentaires ; aucun nouveau nominal/refus HUD exécuté.

Seize pins/29fenêtres communs, neuf fichiers/24sites V566 et deux lecteurs/six sites SOURCE concordent. Auxiliaires sélectionnés comparés et 3pins/12fenêtres directes ; inventaires et analyses historiques réutilisés sans census.

V566 deux parcours publics sans injection, AP0/20 :12impacts physiques isolés par projectile précédent,34refus atomiques. Aucun sort humain touché ni forme araignée atteinte ; zéro familier durant ces autoattaques ne suffit pas à qualifier le passif. Tome20AP ne prouve pas des statistiques d’araignées.

Deux diagnostics séparés accordent2525XP via award_experience, niveau6 : Elise12Learn/Cast/CastAt refusés, aucune invocation après120ticks ; AnnieRnonappris refusé puis LearnR/CastAtR acceptés, un annietibbers. Cette XP n’est pas une progression ordinaire et ce témoin ne qualifie pas Elise. Mouvement V564 et chaîne V565/V563 préservés, non résolus. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté ici.

## 5. Écarts et inconnues

f3/plafond, événements humains/multitouches, réserve, transformation/rangs/slots, apparitions/retours, propriétaires, statistiques/IA/cibles/soins/mort, lookup/états, audiences/confidentialité/reconnexion et rendu restent ouverts. Ni noms de fichiers, ni marqueur communautaire, ni familiers génériques ne remplacent Spider Swarm. Aucun besoin de reconstruction graphique démontré.

## 6. Correction et reprise

Réutiliser `CH-Elise-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/rangs/lookup4.20 et f3 ; qualifier états autoritaires distincts réserve/forme/araignées et audiences ; intégrer widgets/refus sans faux zéro/plafond/activation ; vérifier touches humaines effectives, plafond sourcé, transformations, cycle des araignées, mort/reconnexion et confidentialité avec rendu identifié ; séparer autoattaques/Tibbers/Ezreal/Annie et diagnostics XP du passif ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, mapping, producteur/consommateur ou contrat pertinent, ou dérive précise, sans rejeu inchangé ni plafond déduit de Spider1..5.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_elise_passive_hud_20261104` : source_worker/sourceproof.json, inventaires/captures/manifestes, reçu consommateur, scripts/journaux/archives, result.json et finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes et sept protégés contrôlés avant/après puis relus.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
