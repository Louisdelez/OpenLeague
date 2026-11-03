# SYS-01.2-02 — Continuation native après copie, V698 préliminaire

UTC :2026-10-27T22:41:17.549324+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB,catalogue4.20.1 distinct. Les douze parcours ci-dessous sont exécutés et revus sous entrées déclarées ;**leurs liens au registre canonique et aux deux fiches/bases restent à intégrer**. Dernier audit canonique :V697,99 762sources/5613consommateurs,42 215exigences actives,26 189inconnues ouvertes.

## Contrat du banc et résultat observé

Le code original reprend à9B8738 après l'appelD3DX. Le retourS_OK est un **adaptateur explicite**,comparé au résultat réel local V693 du même source/tampon/format/étendue/filtre. Il ne s'agit pas d'un nouvel appelAPI/GPU ou d'une copie de pixels dans une vraie surface par ce banc. Le PE original est identifié par SHA-256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 ;ses instructions exécutées sont comparées aux octets source. CRT,renderer,caps,categorie,COM et métadonnées restent des entrées déclarées/héritées.

Un premier contexteAhri0 est revu avant l'extension aux douze sources. Attendu :octets source et garde intacts,adaptationstdcallsur10arguments/pop40,parcours natif vérifiable,état observable à une frontière exacte. Observé sur12/12 :4 312 000octetsCPU identiques au niveau0DDS,TLS1,surface remise à0,wrappers de surface et tamponsCPU temporaires libérés. La texture est publiée dansOBJ+8C etOBJ+90. Dans le tas suivi,une seule allocation de20octets reste détenue par contexte ;son premier mot est10E3270,mot de référence2,textureCOM adaptée conservée à1.

| Portrait | FormatDWORD | Étendue logique observée | Références surface | Références textureCOM | Allocation suivie encore vivante |
|---|---:|---|---:|---:|---|
| Ahri:0 | 21 | [308, 560] | 0 | 1 | {'1082130528': 20} |
| Ahri:1 | 21 | [308, 560] | 0 | 1 | {'1082130528': 20} |
| Braum:0 | 894720068 | [308, 560] | 0 | 1 | {'1082130464': 20} |
| Braum:1 | 827611204 | [308, 560] | 0 | 1 | {'1082130464': 20} |
| Kalista:0 | 827611204 | [308, 560] | 0 | 1 | {'1082130464': 20} |
| Kalista:1 | 894720068 | [308, 560] | 0 | 1 | {'1082130640': 20} |
| Lulu:0 | 21 | [308, 560] | 0 | 1 | {'1082130528': 20} |
| Lulu:1 | 21 | [308, 560] | 0 | 1 | {'1082130528': 20} |
| Rengar:0 | 827611204 | [308, 560] | 0 | 1 | {'1082130464': 20} |
| Rengar:1 | 21 | [308, 560] | 0 | 1 | {'1082130528': 20} |
| Zac:0 | 894720068 | [308, 560] | 0 | 1 | {'1082130464': 20} |
| Zac:1 | 827611204 | [308, 560] | 0 | 1 | {'1082130464': 20} |

L'étendue logique reste308×560 tandis que la texture déclarée a512×1024. Ces valeurs ne qualifient pas lesUV,un recadrage ou le rendu final. La référence texture encore détenue à l'arrêt ne constitue pas,à elle seule,une fuite ;la libération de la surface n'atteste pas une VRAM entièrement libérée.

## Frontière précise et entrées encore non qualifiées

Les douze parcours s'arrêtent **avant l'instruction98964D**,appel vers978820. Cette instruction et son callee ne figurent pas parmi les instructions exécutées ;l'arrêt et la pile sont observés avant appel. Le PE confirme8B0D3090D702 à989640 (lecture du global2D79030) et l'appel relatif vers978820. La valeurmanager0 est celle du contexte de test,dont le bootstrap n'est pas exécuté. Elle ne prouve pas une absence dans le client historique ou notre jeu.

Ce gestionnaire d'inscription est distinct du provider90AD00 plus amont. Les quatre mots de pile enregistrés sont une capture brute ;la signature complète et l'ownership des arguments ne sont pas déduits. Le nomNAME fourni est le labeltechnique du banc(Ahri:0:success:selector1:caps0,etc.),pas un nomVFS normal qualifié. Aucun nom n'est consommé par978820 ici. Cette entrée doit être établie avant de poursuivre l'inscription ;aucun pointeurmanager ou nomVFS n'est inventé.

Le consommateur existant est recherché depuis ses descripteurs réels :le module de références d'image est crates/client/src/relic_image_reference_store.rs,avec acquire_dds/release/cleanup_renderer. Le chemin présumé dans crates/core n'existe pas. Cette correction de localisation ne démontre pas une correspondance nouvelle avec978820 ni une absence globale de consommateur ;les huit liens existants restent conservés.

## Candidats statiques pour la suite

| Adresse candidate | Octets | Instruction |
|---|---|---|
| 0x978457 | 89353090d702 | mov dword ptr [0x2d79030], esi |
| 0x978574 | c7053090d70200000000 | mov dword ptr [0x2d79030], 0 |
| 0x97858c | c7053090d70200000000 | mov dword ptr [0x2d79030], 0 |

Les appels relatifs candidats vers978820 sont98964D,989802 et98B0C6. Le préfixe de978820 est borné à51instructions,au premierret,et ne constitue pas une récupération complète de signature/fonction. Les motifsMOV/E8 restent des candidats à qualifier dans leur flot de contrôle ;écritures et appels indirects ne sont pas exhaustivement résolus. Aucun publisher ou bootstrap n'est exécuté par cette analyse statique.

## Échecs du banc conservés et refus

Le premier essai s'arrête/code2 à9BB764 :un garde hérité exigeait à tort que seul un retour de texture nulle passe par ce point. La trace positive et les octets montrent une jonction commune de publication. Un programme distinct corrige seulement cette classification. Le premier lecteur s'arrête/code1 car il exigeait l'adresse d'arrêt98964D parmi les instructions exécutées ;une revue distincte exige correctement son absence et conserve l'événement avant appel. Aucun PE ou résultat précédent n'est réécrit ;aucun nouveau parcours natif n'est nécessaire pour corriger cette revue.

Cinq falsifications sont refusées par la revue complète :mauvais popstdcall,prétendu retour complet du loader,prétendue exécutionAPI,étendue logique altérée et manager d'inscription modifié. Le corps989500 n'est pas terminé et aucun retour normal accepté n'est déclaré.

| Étape | Code nominal attendu | Code observé | SHA-256 journal |
|---|---:|---:|---|
| V698_POST_COPY_FIRST | 0 | 2 | c67d691dfef70cfcb9214c34634160c477eb2563463dd2eb64b2b422bed5ae6a |
| V698_POST_COPY_JOIN_CHECKED | 0 | 0 | 89e79dca81b7929c2b1a29c3baadcff1df4512710f251abddf0549f9bb6727d4 |
| V698_FIRST_REVIEW | 0 | 1 | dc4d9e92782c6118e0cec6e1f408cbb4078fe160a30e0ca893438fb44a492cc6 |
| V698_FIRST_REVIEW_CHECKED | 0 | 0 | 70ec4aaecb2b6ae19de772dc2b8ba37a18d854651a3de5dd7e0293a891aaf4ed |
| V698_POST_COPY_ALL | 0 | 0 | 8638059415fa8ebed944a94df7a4a0a0aa6e472554d8beb5fa7302c6486e40b0 |
| V698_ALL_REVIEW | 0 | 0 | 2269371afb80d5bbe5721e0bd23397aaf673e9039a593507a1bcee12044651bf |
| V698_REGISTRATION_STATIC | 0 | 0 | 3d94182e625bbd93ead02fa9cbce33498781fb2ce58819bb53f167be24486ddb |

## Livraison et limites

Observations :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision698_native_post_copy_all\OBSERVATIONS.json. Revue indépendante :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision698_all_post_copy_review\REVIEW.json. Candidats statiques :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision698_registration_static\OBSERVATIONS.json. Les payloads,scripts,reçus et journaux sont dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Ce rapport,preuveJSON,couverture,completion_plan,resume_checkpoint,CURRENT/HANDOFF sont ajoutés/actualisés avec sauvegardes et conservation des anciens champs. Le registre canonique,les tâches,inconnues et bases ne sont pas modifiés par ce checkpoint. Aucune case cochée et aucun code/asset de production modifié.

Le finisherV697 avait copié le nombre695dans son seul FINAL_CHECKPOINT privé ;sa preuve,son contexte,son rapport et l'audit des bases désignent déjàV697. Un successeur FINAL_CHECKPOINT_REVISION_CORRECTION.json porte697et référence l'ancien en conservant ses octets. Cette correction de métadonnée ne change pas les résultats,registres ou états manuels.

Les décodagesDXT V697 et les cinqARGB8/max0.5V695 restent acquis,avec résiduscompression jusqu'à83non acceptés et alpha réel opaque. Restent ouverts :manager/nom/signature/ownership d'inscription,bootstrap/mode/catégorie/caps effectifs,UV/couleur/sampler,transport actuel,caller normal,nettoyage nominal complet,DLL2014,frame/VRAM,Kalista288octets et12noms antérieurs. Aucunécran,champion ou jeu complet accepté.

## Suite concrète

Continuer SYS-01.2-02 surF. V697 intégré/audité :7DXT,décodages exacts14images/4877376pixels,qualitécompression non acceptée(maxrésidu83),deuxfiches/bases,99762sources/5613consommateurs. V698 exécuté/revu :12contextes natifs après copie avec HRESULTS_OK explicitement adapté depuis les vrais résultatsAPI V693,mêmes bytes/format/extent/filter,pas de nouvelleAPI/GPU. TLS1,surface0,tamponsCPU et wrappers temporaires libérés ;texture publiée dansOBJ+8C/+90,wrapper20octets encore détenu par contexte(wordref2/rawtexture1). Arrêt avant98964D→978820,globalmanager2D79030=0dans contexte déclaré ;caller non terminé. Cette preuve V698 reste à associer au registre et deuxfiches/bases. Premier garde698 classait à tort9BB764comme branche nulle exclusive(code2),première revue exigeait à tort le stopPC parmi les exécutés(code1) ;sources/reçus conservés,versionsdistinctes corrigées. Statique :producteur candidat978457(ESI→2D79030),remisesàzéro978574/97858C ;appelscandidats978820depuis98964D/989802/98B0C6,prefixe51instructions non complet. Examiner/qualifier le constructeur et ce publisher,l’identité du manager et la signature/ownership de978820. Le nom fourni au banc est technique(label),pas un nomVFS qualifié :identifier/remplacer correctement cette entrée avant toute exécution plus loin. Ne pas inventer de manager et ne pas confondre2D79030avec le provider90AD00 plus amont ;l’état0du banc ne prouve aucune absence historique ou produit. Associer d’abord les états observés puis poursuivreinscription/UV/couleur/sampler/cleanup/transportactuel,résiduscompression etmode1225C58/9B7590. DLL2014,Kalista288octets et12noms ouverts conservés. Le vieux FINAL_CHECKPOINT V697 portait revision695par copie ;successeur FINAL_CHECKPOINT_REVISION_CORRECTION.json rétablit697sans effacer l’original. Avantprepare vérifier réserve4GiBF et scratchF strict. Goal actif,aucunécran/jeuaccepté.
