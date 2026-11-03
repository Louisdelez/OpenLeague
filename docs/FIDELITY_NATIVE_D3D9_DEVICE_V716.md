# SYS-01.2-02 — Création du périphérique Direct3D9, V716

Date : 28 octobre 2026. Projet : F:/OpenLeague. Référence : PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct.

V716 : les instructions originales créent un vrai périphérique Direct3D9 via un pont x86/Windows64 déclaré sur RTX3060. Surfaces, caps, requête et32 petits buffers sont initialisés. Le parcours normal reste arrêté avant D3DKMTEscape privé ; sa requête est capturée sans exécution. Deux refus natifs sont vérifiés ; un troisième profil avec refus de pilote synthétique retourne le wrapper original. Trois points précis du renderer Rust sont reliés, sans équivalence Direct3D9/Vulkan ni validation de frame.

## Résultats observés

| Profil | Attendu | Observé |
|---|---|---|
| Entrée nominale, API réelles | Observer la création et la première limite non qualifiée, sans inventer sa réponse | CreateDevice HRESULT0 ;32 buffers Lock/Unlock ; arrêt avant48AC16, constructeur non retourné |
| Pointeur de sortie nul | Retour sans création de device | Aucun CreateDevice, sentinelle inchangée, pile+24, constructeur non exécuté |
| Allocation3380hex refusée | Pas de wrapper ; libérer le device déjà créé | CreateDevice0, Release0, sortie nulle, constructeur non exécuté |
| Refus privé0xC000000D synthétique | Observer la branche de repli sans exécuter l’appel privé réel | Wrapper10E2F30 retourné, publication de la sortie, pile+24 ; résultat conditionnel |

Les tables contiennent respectivement 3236, 169, 364 et 3329 adresses natives distinctes vérifiées contre le PE. SHA256 du PE : `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Six altérations de preuves sont refusées : faux retour normal,identité native changée,faux appel privé réel,faux succès d’allocation,mauvais sélecteur et fenêtre non détruite.

Le code original écrit1225C58=0 à9B7590 puis1225B04=0 à9C16C5 dans les deux profils avec constructeur. Ces écritures sont observées par le banc ; les globals ne sont pas injectés par l’hôte. Les render targets1–3 retournent réellement0x88760866 et le code continue. La requête multi-GPU NVIDIA retourne-113, soit une absence de SLI actif selon la [documentation NVIDIA actuelle](https://docs.nvidia.com/nvapi/group__nvapistatus.html). Cela n’empêche pas la création Direct3D9 déjà observée et ne signifie pas que la carte graphique est absente.

La conversion HDC32/64 et la libération de l’adaptateur s’appuient sur le [contrat Microsoft](https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/d3dkmthk/nf-d3dkmthk-d3dkmtopenadapterfromhdc). Ces contrats actuels ne sont pas une preuve d’identité des DLL de2014.

## Consommateurs actuels

Trois ancres sont ajoutées dans `vendor/bevy_render/src/renderer/mod.rs` : initialize_renderer ligne181, request_adapter ligne281 et request_device ligne342. Elles utilisent les options,features et limites de wgpu. Le rendu Vulkan du client observé enV712 reste une preuve antérieure ; il n’est pas relancé ici. La présence et la liaison de ces points ne démontrent pas une équivalence avec les états ou erreurs de Direct3D9.

## Limites et suite

- La sonde exécute les instructions x86 du PE fourni avec Unicorn. Appels COM/Win32 traduits explicitement vers les API actuelles64bits ; ni processus original32bits complet ni Windows/pilote2014. Chaque instruction retenue est comparée aux octets du PE.
- Entrée graphique déclarée1280x800,32bits,fenêtré,sans MSAA issue du contrat de présentation déjà recensé ; pas de composition complète avec le lecteur/configuration et le démarrageV715. Le fournisseur Direct3D9 et les routines9C3E30/9C46B0/9C4E40/9C1430 restent originaux.
- Cg est explicitement indisponible dans le banc. Allocateur/arène,bootstrap,memcpy/memset,cookie,sortie diagnostic,atexit et Sleep100ms sont adaptés. InterlockedExchange est limité à un thread. Sections critiques hôte isolées ; champs internes natifs non fournis.
- nvapi.dll32bits est explicitement associé à nvapi64.dll du même pilote actuel32.0.16.1088. NVAPI Initialize retourne0 ; GetCurrentSLIState retourne-113 (aucune topologie SLI active). Les champs de sortie restés non initialisés ne sont pas interprétés comme un état SLI valide.
- Le parcours normal est interrompu avant l’appel privé D3DKMTEscape48AC16. Charge utile536octets capturée ; contrat et réponse du pilote actuel/historique non établis. Aucun appel privé réel au pilote n’est exécuté.
- Le profil escape_refusal injecte uniquement STATUS_INVALID_PARAMETER0xC000000D à cette frontière et observe ensuite le code original jusqu’au retour du wrapper10E2F30. Ce refus synthétique est un test de branche ; il ne prouve pas un retour du constructeur sous les réponses normales du pilote.
- Entrée de sortie nulle : aucun CreateDevice. Allocation du wrapper3380hex refusée : vrai CreateDevice réussi puis Release natif0, sortie nulle. Le drapeau TLS vaut1 dans ces cas également : il ne prouve pas une création complète.
- Toutes les ressources COM/DC/adaptateur possédées par les quatre profils finaux sont libérées par des appels vérifiés et leurs fenêtres cachées détruites. Aucun cycle de destruction natif complet ni libération physiqueVRAM indépendamment mesurée.
- Aucun Present/draw/frame/readback,écranStandard ou gameplay exécuté ici. Les preuvesV711/V712 du moteur courant restent des résultats antérieurs distincts ; le fichier réel renderer/mod.rs est seulement relu et identifié dansV716. Aucun mapping automatique des catégories natives0/1/2 vers wgpu.
- Premiers essais interrompus et un échec de cleanup conservés. Les fichiers du jeu, anciens liens, inconnues, états manuels et prérequis restent inchangés. Les écarts de localisationV715, troisième fournisseurV714, textures et montage historique restent ouverts.

Qualifier le contrat de la requête privée multi-GPU, puis la création et le retour normaux du device ; composer l’inscription des textures978820 et l’écranStandard avec les fournisseurs effectifs. Conserver les preuves conditionnelles séparées et poursuivre les autres liens incomplets du registre. SYS-01.2-02 reste partielle.

## Livraison

Deux fiches du registre et les deux bases du plan reçoivent ces liens. Les cases,notes,historiques,autres tâches et inconnues sont conservés. Les contrôles d’intégrité,les lectures réelles Store/copy_text et l’idempotence sont enregistrés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision716_delivery/VERIFIED.json. Seuls des deltas ciblés sont archivés,aucune nouvelle copie intégrale de base.

[Reçu détaillé](fidelity_native_d3d9_device_v716.json). Code du jeu inchangé ; fichiers modifiés : registre de tâches,registre de sources,graphe de traçabilité,docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md,docs/ai/HANDOFF.md et les deux bases du plan. Le script et les essais détaillés restent sur F:/OpenLeague-work.
