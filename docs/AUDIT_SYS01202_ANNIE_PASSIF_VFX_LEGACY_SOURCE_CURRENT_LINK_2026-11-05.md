# Annie — sources anciennes des VFX et consommateur courant

2026-11-05 · V1323 · AUD-SYS-01.2-02-ANNIE-PASSIF-VFX-LEGACY-SOURCE-CURRENT-LINK-01

## 1. Exigence et frontières

SYS-01.2-02 ;CH-Annie-PASSIF-PRESENTATION-VFX,OLF-7d6d534a-366c-55eb-b072-5e8696c2a0d4. Qualifier deux formats de reçus laissés non mappés par V1322 et leur liaison au rendu partiel existant. Exclusions : nouvel inventaire natif exhaustif,décodage,rendu exécuté,correction produit et acceptation du passif. Le titre complet lancement/trajet/impact reste conservé ;l’applicabilité n’est pas réduite à l’effet prêt.

Audit de ce lien borné clôturable après publication vérifiée. Implémentation partielle inchangée ;vérification statique/documentaire ;acceptation humaine non donnée. Dépendance CH-Annie-PASSIF-NETWORK,questions,phase et6prérequis de lots conservés sans acceptation implicite.

## 2. Sources et qualification des formats

PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau/déploiement inconnus,catalogue4.20.1 distinct. Réutilisation des copies E retenues par V1322,identités vérifiées avant usage :annie_passive_sources.json5332octets/SHA0f0692ec828277c332db1c32e9719147af900cdf7f32bd617953694896b4dc10 et V66889618octets/SHA1c10e5a7e5ff026f759c98fd0798578bdf33369aeb47c5592ac2131cdd81c6f9.

Le premier expose native_lua[*].initialization.globals ;le second associations[0].field.native_metadata[*].initialization.globals. Trois chunks concordent :Pyromania146octets/cdd6e5a4…,marker214/76c18bfa…,particle201/5486fbc7…. Neuf globals et troisIDs natifs préservés ;particle déclare AutoBuffActivateEffect=StunReady.troy. Les deux reçus décrivent le même effet nommé,pas deuxeffets distincts. Stopped=null et child_functions=0 sont des métadonnées,non corps serveur ou preuve de consommation exhaustive du lecteur.

V668 identifie StunReady.troybin894octets/SHA432e205616d2cb1bd0a73ef236efb585657758e5a1715a6b599029d02897a86e. Ses98champs,22conversions de chaînes,quatre comparaisons RGBA et11contrôles dont8refus restent hérités ;aucune nouvelle lecture D,décodage ou comparaison de pixels. Le marqueur persistant ne prouve pas la persistance des charges à la mort.

## 3. Consommateur réel conservé

annie_ready.rs importe data/4.20/particles/StunReady.json et lit uniquement sections.ready1. Le JSON27086octets/SHA0ed52c49… est inchangé. Snapshot :champion annie,vivant,pyromania>=4 ;retrait au changement de session ou d’éligibilité. Texture base AnnieStunReady.png,quads bornés,horloge EffectClock,offset/20 et rotation reconstruits. Main enregistre matériau et scheduling ;le shader sépare RGB mobile et alpha fixe. Dix ancres exactes V668 et huit identités code/JSON/PNG concordent avec V668.

Cette route ne lit ni les LuaObj ni AutoBuffActivateEffect :liaison documentaire via conversion/valeurs et sélection Rust codée explicitement,pas un dispatch natif importé. Les11consommateurs enregistrés restent conservés ;dix points V668 vérifiés dans ce lot,chargeur commun non réaudité. Le produit existant est préservé.

## 4. Attendu, observé et contrôles

Attendu :formats et valeurs exactes reliés,base et variantes séparées,conditions statiques et limites documentées. Observé :52/52contrôles documentaires et49/49de cohérence séparée du même agent réussissent sur les reçus originaux et huit entrées courantes retenues.

Cas nominal statique :ready1 fournit e-rate=4 et p-life=2.5,capacité calculée10,source du renderer et texture identifiées. Limites/refus dans le code :âge négatif/non fini refusé,Annie morte ou non prête exclue,session/éligibilité retirent les entités. Ces branches ne sont pas exécutées ce tour. L’identité des quatre PNG autorise la réutilisation de leurs anciennes preuves RGBA,non une nouvelle mesure de pixels.

Premier bootstrap code1 :sortie resume supposée JSON seul,alors qu’elle contient des notes puis un JSON terminal. Original/journaux conservés ;lecteur de reprise corrigé uniquement sur E,sortie compacte,bootstrap02code0. Aucun prédicat fonctionnel assoupli. Aucun build,test Rust,jeu,GPU,réseau,REA ou probe rejoué.

## 5. Écarts et inconnues

System déclare ready1,ready2,ready1_frost,ready2_frost ;le contrat retenu définit ready1 et les deuxgroupes frost,sans définition ready2 dans ce périmètre. Ce n’est pas une absence prouvée dans tous les providers natifs. Le renderer nommé ne sélectionne pas les groupes frost malgré leurs textures recensées. Identité d’asset,conversion,montage et rendu restent distincts.

Naissance/phase/attaches,audiences,blend historique et politique de skin restent ouverts. Le blend courant cite une référence communautaire transversion ;pas une preuve Riot4.20. Le diagnostic garde sa racine E:/OpenLeague/logs,donc n’est pas exécuté sur F. V1322 demeure immuable :son défaut d’adaptation pour Annie reçoit ce supplément qualifié,non un effacement de l’historique.

Seul lien ancien/courant clos ;aucun inventaire secondaire complet,tâche VFX,feature,inconnue,acceptation ou goal clos.

## 6. Corrections et prochain lot

Réutiliser CH-Annie-PASSIF-PRESENTATION-VFX pour les clauses ready2-source-contract,frost-selection-render,state-attachment-fidelity :définition/fallback qualifié ou manque borné ;sélection skin et ressources reliées ;état/attache/lifecycle/blend/audience et applicabilité contrôlés avec preuves adéquates. Préconditions et critères précis dans corrections_and_restart.json. Ne pas inventer ready2 ni substituer des textures générées à une recette non qualifiée.

Réutiliser COR-ANNIE-READY-DIAGNOSTIC-ROOT-01 avant tout futur diagnostic F autorisé. NETWORK et SIMULATION-CONTRAT restent distincts. Reprendre sur source/callsite/capture nouveau,dérive ou décision de périmètre précise ;pas de replay inchangé.

Prochain lot :CH-Blitzcrank-PASSIF-PRESENTATION-VFX,qualifier les vues anciennes buff/cooldown/active_chunk V544 déjà retenues ;conserver limites NEWTABLE et comparer les consommateurs réels nécessaires,avant toute assertion d’absence ou de rendu complet.

## 7. Preuves et reprise

E:/mapslol3v3/audit_sys01202_annie_passive_vfx_20261105 :initial_scope,inspection,evidence_review,coherence_review,corrections_and_restart,journaux et témoins. Relecture séparée du même agent,non indépendante ni acceptation humaine. Sept rubriques relues avant publication.

Livraison :présent rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ;sept registres protégés identiques. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2310entrées sales groupées préexistantes conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ;aucune installation,migration,relance,nettoyage ou mutation Git.
