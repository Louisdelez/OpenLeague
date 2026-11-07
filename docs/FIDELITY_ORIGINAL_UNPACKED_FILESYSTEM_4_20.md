# Bootstrap et lectures physiques natifs de la référence 4.20

Le binaire PUBLIC4.20.0.315 appelle réellement sa routine58f880 dans Unicorn. Elle construit, ordonne et déduplique deux objets natifs (vtables10c9998 puis10c9854), après passage par995260/953480/9533e0/9529b0. Les anciens slots fournis et le faux sentinel d'initialisation sont effacés avant cet appel. Le second appel conserve les mêmes deux objets.

RiotRadsIO.dll est celui de la copie native, SHA60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521 ; VERSIONINFO2.21.0.237 désigne ce composant, pas le jeu. Son payload correspond au membre du manifeste patcher0.0.0.11. Son entrypoint100f2c22 tourne séparément dans la mémoire isolée ; un adaptateur déclare ensuite ce module préchargé. Les adresses d'exports proviennent de sa vraie table PE. Aucun chargement de ce DLL ni programme original sur l'OS hôte.

Sur21contextes froids, le véritable appel RadsInitialize retourne80004005 : le manifeste natif en_gb0.0.0.235 est absent. Le manager reste nul et le drapeau jeu vaut0. Le manifeste core0.0.1.7 est lui aussi absent ; les copies récupérées dans OpenLeague sont des sources séparées et ne sont pas substituées à ces chemins. Le montage des archives n'est donc pas qualifié.

Les lectures suivantes passent effectivement par le provider physique8b6280, le constructeur/wrapper8b5f90, la méthode Read8b61f0, le cache et les parsers/getters originaux. Seules les feuilles CRT fopen_s/access/setvbuf/seek/tell/read/eof/close exposent de vrais octets hôte en lecture seule ; aucun layout FILE historique n'est inventé. Allocation/SSO/thread/cwd/clock/TLS/NLS/runtime et pages invitées sont déclarés. Le reçu conserve aussi des notes et drapeaux de l'expérience parente concernant la découverte/package ; les nouveaux drapeaux bootstrap/physical et les limites explicitent cette portée, sans convertir ces anciennes notes en succès du montage.

Attendu : conserver les6champs identité/chemins et2scalaires de chaque sélection antérieure en remplaçant le provider fourni par les constructions et wrappers natifs. Observé :668sélections,5344champs,21contextes froids,393sources réelles conformes. Tous les résultats concordent. Les fichiers logiques et sections restent les entrées conditionnelles de l'expérience antérieure ; la découverte complète outer/base/fallback/package/skin et les overlays historiques restent ouverts.

Contrôles de provenance : le wrapper sélectionne ici la copie looseUrf515octets (BaseHP2980), Cheats150octets (GoldAmount99950.0) et Locale37octets (en_GB). Les alternatives exactes des manifestesUrf610/Cheats148 restent conservées. La génération/admission historique de ces variantes, notamment Locale absent des deux projets, n'est pas déduite du seul fallback de cette copie.

La correction de deux sites PCMPISTRI imm0C (100ece7f/100ecebb) réutilise la preuve CPU antérieure de2123vecteurs, sans nouveau run hardware. L'intégralité du corps original strstr611octets est conservée et a été réexécutée sur6369cas sous trois valeurs déclarées du global ISA ; tous concordent.2691événements corrigés dans le profilISA2,aucun dans0/1. Le corps/opcode/pile/registres et l'identité du DLL sont gardés. Le contexte ISA/heap/NLS/FP historique n'est pas déduit de ces profils.

Huit tests installés passent : construction/déduplication,locale physique,cachehit/reload,variantesUrf/Cheats,défaut absent,refus des écritures/horsracine,FILE inconnu/layout direct et lecture surdimensionnée/nettoyage. Le premier essai7/8 est conservé : une assertion attendait un fopen du fichier absent,alors que quatre vérifications access le rejettent avant ouverture. Seule cette assertion est réparée ; les helpers natifs sont inchangés. Une erreur de préparation des métadonnées Python (chemin pythonlibs non déclaré) est aussi conservée et corrigée sans rejouer ni altérer le corpus.

Les112questions Renekton,12écarts d'unULP installés,une question de bootstrap/locale et trois provenances sont affinés avec l'ancien texte et leurs recherches conservés ; tous128restent ouverts. Aucun fichier de jeu/source originale,manifeste de modèle,build/test Rust ou état utilisateur modifié. Les autres écarts DataDragon et scripts communautaires demeurent distincts.

Reproduction depuis E:/OpenLeague :

    python -B -m unittest discover -s tools/project-plan -p test_original_unpacked_filesystem_reference.py -v
    python -B tools/project-plan/exercise_original_unpacked_filesystem.py --root E:/OpenLeague --output <nouveau-recu.json>

Choisir un nouveau reçu : l'outil refuse d'écraser une preuve. [Corpus](reference_native_skin_loader_sources/original-unpacked-filesystem-execution.json). Les identités détaillées Python/unicorn/pefile/capstone et bibliothèques Windows actuelles,la qualification strstr,les premiers échecs et les contrôles complets du plan sont liés par la preuve de révision.
