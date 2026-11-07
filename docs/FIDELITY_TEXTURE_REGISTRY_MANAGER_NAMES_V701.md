# SYS-01.2-02 — Gestionnaire de textures et noms : intégration V701

UTC : 2026-10-27T23:31:20.247302+00:00. Projet : F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Cette livraison relie les preuves V700 au registre canonique et aux deux bases du plan. Elle ne termine ni l'inscription des textures ni le jeu.

## Résultat natif et entrées déclarées

Le préfixe original9783D0 publie lui-même le gestionnaire80 à978457. Deux conteneurs32 et cinq blocs240 sont vérifiés sous allocateur CRT adapté à mémoire initialement nulle. Le host n'invente pas le pointeur. Une seconde composition poursuit le constructeur jusqu'au nom source texture_registry_system_default à10DB9A8,poussé à978479 ;elle s'arrête avant978482→978660. La fabrique de secours et la fin du constructeur ne sont pas exécutées ;11mots bruts de pile ne deviennent pas une signature de11arguments.

Sept appels séparés de99B170 utilisent le conteneur ainsi construit :deux appels du nom source et cinq contrôles synthétiques explicites. Attendu/observé :retours,octets d'entrée inchangés,chaînes détenues égales,pas de nouvelle allocation lors des répétitions,casse distincte. Cinq identités distinctes,quinze blocs389 détenus ;secondconteneur etslot4C restent0. Aucun teardown ou manager prêt complet n'est revendiqué.

| Appel | Adresse de chaîne retournée | FNV natif observé en insertion | Nouveaux blocs |
|---|---|---|---:|
| native_default | 0x408000f0 | [2410742636] | 2 |
| native_default_repeat | 0x408000f0 | [] | 0 |
| control_upper | 0x40800120 | [3937439165] | 2 |
| control_lower | 0x40800150 | [928743741] | 2 |
| control_empty | 0x40800180 | [2166136261] | 2 |
| control_unsigned_ff | 0x408001a0 | [2047574606] | 2 |
| control_empty_repeat | 0x40800180 | [] | 0 |

**99B170 renvoie une adresse de chaîne détenue, pas un hash.** FNV-1a32 est vérifié contre la boucle d'insertion originale. Le contrat actuel8E50F0 emploie65599,minusculesASCII et octets signés :il conserve son rôle de hash de fichier. Les valeurs65599 comparées sont calculées depuis le source, sans nouvelle exécution Rust/8E50F0. Aucun remplacement du consommateur existant ou absence globale d'un consommateur d'inscription n'est déduit.

## Correction du contrat de nom

Le nom natif par défaut est une clé logique interne,pas un chemin VFS. La condition VFS trop générale de V698/V699 est précisée **selon chaque caller et son vrai producteur**. La question et sa condition précédentes restent en historique daté. Le nom normal des portraits reste inconnu ;un label technique du banc ne le remplace pas. Le manager2D79030 reste distinct du provider90AD00 ;backend1225B04 distinct du copy-mode1225C58.

## Intégration et vérifications

SYS-17.3-01 et SYS-01.2-02 reçoivent 1 lien natif EXE et 29 sources nouvelles. Les huit consommateurs existants sont revérifiés sur leurs fichiers/lignes et conservés dans leurs rôles. Aucun code,asset ou nouveau consommateur du moteur n'est ajouté.

La question OLU-ac85c18c-d131-517e-83a7-d0987d643c48 reste ouverte. Propriétaires,aspects,statuts et autres inconnues sont conservés. Le graphe compte 99855 sources/5613consommateurs,42215exigencesactives,26189inconnuesouvertes/5517résolues antérieures. Les pins de cette livraison sont vérifiés ;ce compteur n'est pas un rehachage global.

Cinq falsifications supplémentaires sont refusées :constructeur complet prétendu,fabrique prétendument exécutée,adresse présentée commehash,nomportrait normal prétendu et hashfichier substitué auFNV. Les deux revues V700 ont également leurs cinq refus chacune. Cinq mutations de candidat sont refusées ;inversion documentaire exacte,inversionSQLite logique et idempotence vérifiées. Les deux bases auditées conservent chacune42605autreslignes,42607étatsmanuels et23historiques. Aucun prérequis levé ou case cochée automatiquement.

| Étape | Code attendu | Code observé | SHA-256 journal |
|---|---:|---:|---|
| V700_MANAGER_PREFIX | 0 | 0 | 5fd9145f14a1dac068fffe2cb6a2e608d4d378378a95f30031d3e8b6b9b7403d |
| V700_MANAGER_REVIEW | 0 | 0 | 10707cfdef07d53a071a6e914e94c800da36e9f9a42c0769bd6d8e635467f9cf |
| V700_NAME_INTERN | 0 | 0 | a98fcdf05dd32ad9deaf00016e58bc19b76d24d470511903b5f6068879ea3010 |
| V700_NAME_REVIEW | 0 | 0 | 71aedbf046bdc1f5b2beecde78990c7c4ea3260414569d742955cc4c678ec018 |
| V700_MANAGER_NAME_CHECKPOINT | 0 | 0 | 1383df59b95671525fef26d7214e656e751fa1ba992933e9ac91f85f7768dd3f |
| V701_ASSOCIATIONS | 0 | 0 | 70001db1cc23988a7f8fc78e4ebf6fba76dc320997671fc6cc6a2315590bae7c |
| V701_STORAGE | 0 | 0 | 8e13944348499809065de2917a30839ed478bbb3a5f4f47f77a5c04f15cf01c4 |
| V701_PREPARE | 0 | 0 | 810bb333be739a4bbfe25e382219449780458f291a98be8f8aa54f8bbdfe8f86 |
| V701_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V701_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V701_DELIVERY_AUDIT | 0 | 0 | 53cb6e87e5ac9cc05e482939176ee7aff35bdeee5294e2ca3f91fa694994b442 |

Le SyntaxWarning nonfatal de la revue préfixe V700 est conservé ;la compilation AST de son validateur le reproduit dans le lecteur V701. Les assertions et refus s'exécutent. Aucun arrêt réel n'est requalifié en succès.

13 fichiers historiques fermés sont compressés sans perte après contrôle d'ouverture exclusive,de sidecars et de taille/SHA identiques. Aucune suppression ou base active touchée. Le scratch privé reste surF et le garde de réserve4GiB est conservé.

## Fichiers, binaires et limites

Rapport présent,preuve docs/fidelity_texture_registry_manager_names_v701.json et reçu docs/reference_requirement_trace_sources/texture-registry-manager-names-v701.json ajoutés. Quatre documents canoniques REG/TR/SRC/UNK actualisés ;IDS et phases/lots byte-identiques. Deux bases synchronisées puis auditées via leur consommateur réel. Couverture,completion_plan,resume_checkpoint etCURRENT/HANDOFF actualisés avec sauvegardes et anciens champs conservés. V700 préliminaire garde son état daté ;V701 est son intégration ultérieure.

Lecteur :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision701_manager_name_associations\OBSERVATIONS.json. Observations :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision700_native_name_intern\OBSERVATIONS.json. PE d'origine15973880octets,SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Exécutions V700 héritées :Unicorn2.1.4,x86/32bits,instructions comparées aux octetsPE,allocations/états contrôlés ;les scripts,reçus,journaux et identités de runtime restent pinés. Le lecteur V701 n'exécute aucun nouveau code natif/API/GPU/Rust. Aucun build moteur ou rendu nouveau n'est revendiqué.

Restent ouverts :fin du constructeur,fabrique978660/backend1225B04,inscription978820/signature/ownership,nom normal des portraits,UV/couleur/sampler,transportactuel,collisions,growth>8,concurrence,échecsallocateur et teardown. Le bootstrap et les entrées historiques effectives ne sont pas reconstruits par ces contrôles. Les acquis V699/ARGB8/DXT et toutes leurs limites restent conservés :résidus83 nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms. Aucun écran,champion ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 sur F:/OpenLeague. V701 a intégré/audité V700 au registre et deuxfiches/bases : vrai constructeur9783D0 publie manager80 via978457 ;nom source logique texture_registry_system_default et appels séparés99B170/7retours/5identités,retouradresseCString,FNV1a interne distinct8E50F0. Huitconsommateurs conservés,questionouverte historisée et conditionVFS précisée par caller. Suite : qualifier978660 et sélecteur1225B04,finconstructeur,fabrique de secours et inscription978820/signature/ownership sans forcer un backend ou manager prêt. Le nom par défaut interne est connu ;nom normal des portraits reste àqualifier au vrai producteur,avec UV/couleur/sampler/transportactuel. Distinguer copymode1225C58,provider90AD00 et manager2D79030. Collisions,growth>8,concurrence,échecsallocateur et teardown restent ouverts. V69912postcopy,ARGB8/DXT,résidus83 nonacceptés,alphaopaque,DLL2014,Kalista288octets et12noms conservés. Avant prochaineprepare vérifier réserve4GiBF/scratchprivé ;pasdesuppression/casepromue. Goal actif,aucunécran/jeuaccepté.
