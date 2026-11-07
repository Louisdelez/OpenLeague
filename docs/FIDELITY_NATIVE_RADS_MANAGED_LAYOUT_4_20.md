# RADS natif : manifeste en_GB et chemins managedfiles — référence4.20

Le manifeste récupéré en_GB0.0.0.235 est sélectionné par les solution/configurationmanifest originaux. Ses49251octets ont le SHA-256 c06c83f829dd18cf587098529aa83459c8356dc2fe5ee82d7203c7a9ee3662f0. Sa provenance archivistique conservée reste distincte d’une authentification RiotCDN ou d’une installation historique complète.

Les essais25..29 et17contrôles Windows ont été exécutés au tour précédent,relus ici sans rerun. Les essais30/31 et8contrôles du layout sont frais dans ce tour. Les API de dates exposent des buffers possédés et les paramètres actuels,avec alias exact conservé et chevauchement partiel refusé. Aucun fuseau2014 ni date de déploiement n’en découle.

| Cas | Attendu | Observé |
|---|---|---|
| Lecture native du manifeste | Lire les octets exacts |49152+99octets,corps DLL originaux exécutés |
| Absence de chemin managed | Identifier la cause et conserver le refus d’écriture |GetFileArchiveMetadata signale le premier membre226 manquant ;SOFT_REPAIR/GENERIC_WRITE/CREATE_ALWAYS refusé avantaccèshôte |
|563membres en_GB | Comparer tous les candidats,distinguer releaseprojet et payload |563/563tailles etMD5 exacts dans deploy ;0cheminmanaged original présent ;flagsbruts5 sansinterprétationinventée |
| Correspondance déclarée | Uniquement fichiers exacts et lecture seule |8contrôles passent ;6refus(dont mauvaiserelease,fichierinconnu,dossier,traversée,NUL,altérationmêmetaille) |
| Essai30 | Conserver le vrai résultat du garde | Processus détenu arrêté parborne90secondes,aucunrésultatnatif brut ;aucunesuccèsdéduit |
| Essai31 | Mêmecode/arguments/refus,instrumentationdeprogression | 563aliases/563membres observés ;voirarrêtexactdanslereçu |

Essai31 : les 563 membres distincts sont effectivement visités. Après 9 423 222 instructions observées,le programme retourne normalement ; Python0,sans arrêt forcé ni accès invalide. Le vrai export RadsInitialize renvoie 80004005 quand le manifeste core0.0.1.7,volontairement non exposé,n’est pas trouvé. Le caller garde RADS_manager=0/initialized=0 et deux providers de repli ;ce n’est pas un montage réussi. Aucun code de retour fabriqué. Le budget hôte est600secondes ;les10millions instructions par appel,attentes natives,contrôles des octets,limites de read et refus écriture restent inchangés. Le tas DLL et plusieurs feuilles OS/handles/NLS sont virtuels et explicitement hérités ;tous les flux physiques sont déjà fermés par le code avant cleanup hôte(0àfermer),les5handles DLL virtuels restants ne sont pas un teardown historique. Aucun programme historique lancé sur Windows,aucun code Rust/C de production ni asset modifié.

Les consommateurs actuels reliés sont RadsReferenceMembership.inspect,read_manifest etrelease_manifest : outils de référence réellement présents,aucuneéquivalence avec un montageRust complet inférée. Les prioritésprovider/base/legacy/overlays,config/argumentshistoriques,IOnonvides effectives,OS/NLS/FP/contentions,TLSfallback etautresrôles/AIR4312/4313/communauté restent ouverts. Une inconnue composée est affinée,sansfermeture ;aucunstatut/case/acceptationautomatique.

Preuves : [composition](reference_native_skin_loader_sources/original-rads-recovered-managed-layout.json),[intégration et audit](fidelity_registry_rads_managed_layout_revision_4_20.json).
