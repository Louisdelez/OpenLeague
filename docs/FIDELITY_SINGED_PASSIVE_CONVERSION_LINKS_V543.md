# SYS-01.2-02 — Singed : sources de conversion mana/vie, V543

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 à17:46:45 ; fuseau et date de déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle, sans acceptation du passif ou du jeu.**

## Résultat intégré et prérequis

CH-Singed-PASSIF-SOURCE, CH-Singed-PASSIF-SIMULATION-CONTRAT et CH-Singed-PASSIF-SIMULATION reçoivent18 arêtes vers six sources natives. Les deux fiches de simulation reçoivent20 liens vers dix points de code qualifiés `entry_boundary_only`, `provides_feature_consumer=false`. Le chargeur partagé et les anciens lecteurs SOURCE sont conservés sans promotion en mécanique acceptée. SYS-01.2-02 référence le lot.

Phases D01/D06, lots et prérequis réels sont consignés dans le reçu. Leurs sorties complètes ne sont pas déclarées atteintes. Trois questions propres et quatre dépendances restent exactes ; les questions des dépendances gardent leur propriétaire. Aucun inconnu ajouté ou fermé, aucun statut, critère, case, note ou historique modifié.

## Sources et noms exacts

| Source native | Identifiant |
|---|---|
| Singed.inibin | OLS-2235ba6a-bf6e-5b1d-83bc-2b42d8269d07 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Empowered Bulwark.inibin | OLS-3fb3ed7a-abfc-5330-bb2e-5e54f6dd709a |
| EmpoweredBulwark.luaobj | OLS-38ef5ac2-dd39-5c99-9b4f-02e41f60605a |
| CharScriptSinged.luaobj | OLS-8fe4db45-803e-574a-b32d-fd3a3b91d204 |
| CharScriptSinged.preload | OLS-0d468644-c910-52ea-bc6d-256c4c0cfedb |

Les six payloads correspondent aux tailles/SHA du registre et tailles/MD5 des projets sélectionnés dans le manifeste RADS. Le périmètre de recherche comprend les trois variantes de nom EmpoweredBulwark, Empowered Bulwark et Empowered_Bulwark dans DATA/Spells, la définition Singed et ses CharScript. Ce n’est pas une recherche exhaustive du serveur original.

La définition déclare Passive1LuaName=`Empowered Bulwark`. Le fichier `Empowered Bulwark.inibin` lie directement `game_buff_tooltip_Empowered_Bulwark`, qui contient f1/f2/f3. Le fichier `EmpoweredBulwark.luaobj` déclare BuffName=`Empowered Bulwark`, identique à la définition. Le preload emploie `empoweredbulwark`. Ces correspondances textuelles sont conservées ; aucun alias ou ordre de chargement effectif du moteur natif n’est exécuté ou déduit.

PassLev1Desc1 renvoie à `game_character_passiveDescription_Singed`, ligne4277 du font anglais : **25 points de vie pour100 points de mana**. Le ratio0.25 est une conversion de ce texte. Les fournisseurs des variables dynamiques f1/f2/f3 de l’infobulle ligne1867 restent inconnus ; le ratio ne les identifie pas. Le texte ne tranche pas ici le détail mana courant contre capacité maximale, ni tous les arrondis et moments de recalcul.

La définition conserve aussi PassLev1Desc2 annonçant10% de réduction des dégâts magiques : cette ancienne chaîne n’est pas adoptée comme règle du passif. Le champ Passive1 est absent ; aucune valeur par défaut inventée. BaseHP vaut542.760009765625, BaseMP290.6000061035156. Les textures `Singed_Passive.dds` et `ChemicalMan_EmpoweredBulwark.dds` restent distinctes.

Deux Lua parsés intégralement n’ont aucun prototype de callback enfant. Le buff déclare PersistsThroughDeath et NonDispellable ; le CharScript contient seulement un retour. Les déclarations et préchargements ne sont pas une implémentation serveur. Les miroirs communautaires Stats/Singed et Spells/Empowered Bulwark, ainsi que le C# CharScriptSinged vide de cette copie, sont relus avec leur provenance ; aucune absence mondiale de source n’en est déduite.

## Consommateurs actuels et diagnostic réel

Le core charge champions.json et champion_growth_420.json. La vie maximale est calculée à partir de la base, de la croissance et de la vie des objets ; le mana maximal utilise la base, la croissance et le mana des objets. Les achats/ventes appellent refresh_item_caps, qui conserve les valeurs courantes puis les plafonne aux nouvelles capacités. Les sources de la fontaine et de la régénération ordinaire sont liées séparément de la conversion passive.

Deux simulations Map10 non-test emploient les commandes publiques Buy/Sell et advance : Singed et Ahri comme témoin. Aucun champ ni montant de mana/vie n’est injecté directement. Après achat du Saphir1027, le mana courant reste initialement inchangé tandis que le maximum augmente200. Les ticks normaux à la fontaine remplissent le mana en90ticks dans les deux cas. **Il s’agit du comportement local de fontaine plus régénération ; pas d’une preuve de cadence native.** Les points comparés ont le mana courant égal au maximum, ce qui évite de choisir arbitrairement une interprétation du texte.

| Mesure Singed, niveau1 | Apparition | Saphir après remplissage |
|---|---:|---:|
| Mana courant et maximal | 290.6000061035156 | 490.6000061035156 |
| Vie maximale observée | 542.760009765625 | 542.760009765625 |
| Vie ajoutée au-delà de BaseHP | 0 | 0 |
| Bonus décrit par25/100, calculé sur le mana plein | 72.6500015258789 | 122.6500015258789 |

Le supplément textuel augmenterait de50PV, mais cette augmentation n’est pas observée. Le contrôle Rubis1028 ajoute réellement150PV au maximum ; sa vente ramène le maximum à la base. La vente du Saphir ramène le mana maximal à sa base et plafonne le mana courant. Ahri suit le même comportement générique sans être présentée comme possédant le passif de Singed.

L’écart est borné aux statistiques observées niveau1 à l’apparition, lors des achats/ventes et après remplissage du mana. Aucun correctif de gameplay n’est livré. La présence du calcul générique ou le succès d’achat ne vaut pas implémentation du bonus de Singed. Les autres niveaux, buffs, mort, arrondis, modification du mana par sort et rendu restent ouverts.

Huit refus publics vérifiés : pour chaque champion, joueur inconnu → unknown player ; objet inconnu → item behavior not implemented ; case6 → invalid inventory slot ; vente case0 vide → empty inventory slot. Le snapshot complet reste identique avant/après ces refus. Les deux champions restent vivants et niveau1, aucune fin de partie pendant le diagnostic.

## Exécution et conservation

Build/run qualifiés codes0, core non-test en cache, src_path F:/OpenLeague/crates/core/src/lib.rs. Dépendances, versions et checksums conformes au Cargo.lock racine. Les1158 entrées source/ressource, les anciens artefacts et les registres avant publication restent exacts. Les échecs d’outillage antérieurs Dr. Mundo restent conservés ; aucun ancien diagnostic relancé.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-singed-passive-healing-probe.exe`, 5996032octets, SHA256 `3258bdc4d47c193a0a36ef8994956e6062bd3b73271386eeb1a3b8d48b6b8cc4`. Son nom historique contient `healing`, mais son source et ses observations vérifient les statistiques mana/vie, pas un soin injecté. Identités des outils, manifeste privé, lock, code Rust et journaux sont dans revision543_Singed_passive_probe/OBSERVATIONS.json. Aucun code produit ou asset modifié. Aucun client/serveur original, VM Lua, GPU ou réseau exécuté par ce lot.

La préparation du script de livraison a nécessité la correction d’un sélecteur de ressource avant sa génération ; aucun registre ou base n’avait alors changé. Le script de livraison final passe sa vérification de syntaxe avant exécution.

## Livraison vérifiée

Inspection, prepare, check, publish et audit réussis.60 associations invalides et quatre graphes invalides refusés : source absente, question étrangère, faux bonus, fausse identité binaire, dépendance supprimée, faux passif accepté, alias/fournisseur/politique mana inventés ou vieux texte magique pris pour règle.

Chaque base réelle conserve42603 autres lignes de catalogue,42607 états manuels et23 événements historiques ; quatre fiches actualisées. Store.task, copie complète, summary, dépendances/questions, integrity_check et sync_catalog idempotent sont vérifiés. Trois fragments changent,42212 sont exacts ;42211 autres objets tâche/trace et anciens descripteurs restent exacts. Identifiants, hiérarchie et registre des inconnus restent identiques en octets.

Réexamen :42215 exigences,98847 sources,2835 consommateurs ;26189 questions ouvertes/5517 résolues. Les2835 ancres et les octets de527 fichiers correspondent, zéro divergence,17 auxiliaires conservés. Il ne s’agit pas d’un nouveau contrôle physique de toutes les98k sources. Les8352 fiches CH au seul chargeur partagé sont une file d’examen, pas un pourcentage de complétion.

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/singed-passive-conversion-links-v543.json ; preuve docs/fidelity_singed_passive_conversion_links_v543.json. Quatre lignes données/consignes changent par base. Couverture, plan documentaire, reprise, CURRENT et HANDOFF actualisés avec sauvegardes et conservation des anciens champs ; scripts archivés. Aucun stage/reset/commit.

## Inconnues restantes et suite

Corps serveur original, fournisseur du bonus actuel, f1/f2/f3, politique mana courant/maximal, résolution des noms, autres niveaux/transitions, mort, arrondis et affichage restent non qualifiés. La correspondance BuffName/définition et les tests de statistiques ne ferment pas ces inconnues.

Continuer SYS-01.2-02 depuis revision544_trace_review/REVIEW.json. V543 Singed est publié/audité : trois fiches, six sources natives,18 arêtes et20 liens vers10 frontières. Texte25PV/100mana ; mana plein290.6 puis490.6 après achat1027 et90ticks à la fontaine, vie maximale542.76 inchangée. Bonus textuel72.65/122.65PV non observé ; objet1028 ajoute150PV, ventes rétablissent les capacités, Ahri témoin. Noms exacts, vieux texte réduction magique10%, icônes et f1/f2/f3 conservés sans règle de chargement ou politique mana courant/maximal inventée. Aucun code gameplay changé ni passif accepté ; inconnus/statuts/cases conservés. Ne pas republier V543 ni relancer les diagnostics sans cause nouvelle. Examiner ensuite Blitzcrank : liaison ManaBarrierIcon/Check/CD et chemin actuel dégâts/boucliers. Le lookahead du font annonce sous20%vie,50%mana courant,durée10s,recharge90s ; vérifier ses sources natives et disponibilité initiale avant qualification. Préserver les métadonnées déjà rencontrées pour Volibear sans en déduire le même mécanisme.109 autres contrats/parents restent à examiner ;8352CH au seul chargeur partagé sont une file de recherche, pas un taux de complétion. Goal actif.
