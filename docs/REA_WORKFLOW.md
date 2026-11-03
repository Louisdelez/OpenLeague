# REA pour le goal OpenLeague

Demande utilisateur du29octobre2026 : utiliser https://github.com/morluto/rea pour le goal. Objectif actif : SYS-01.2-02, relier les exigences aux sources et consommateurs actuels. Projet, nouvelles analyses et temporaires sur F.

## Lancer l’outil

```powershell
# Diagnostic du moteur Ghidra utilisé : contrôle réellement passé.
powershell.exe -NoProfile -File F:\OpenLeague\tools\rea-openleague.ps1

# Afficher la version installée.
powershell.exe -NoProfile -File F:\OpenLeague\tools\rea-openleague.ps1 --version
```

Le lanceur transmet aussi les autres commandes REA, notamment `inspect-pe-resources <fichier> --format json`. Les chemins se trouvent dans `tools/rea-openleague.config.json`. Ce fichier décrit cette machine ; ce n’est pas un installateur portable. Il réutilise REA6.4.0 et Ghidra12.1.4 déjà présents sur E, Java21.0.10 et Node24.22.1. Aucun logiciel supplémentaire téléchargé. Temporaires sur F:/OpenLeague-work/rea-temp, variables du processus restaurées à la fin.

Ne pas présumer que toutes les commandes de la branche GitHub actuelle existent dans6.4.0. Consulter l’aide de la version installée. Aucun enregistrement MCP global ni redémarrage Codex nécessaire pour la CLI ou la session MCP locale privée utilisée ici.

## Résultats effectivement obtenus

- Diagnostic ciblé Ghidra : code0, healthy=true. L’audit global retourne1 parce que d’autres moteurs/intégrations ne sont pas configurés ; son reçu est conservé.
- Client original PE32, SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 : dix ressources inspectées par REA, identités, offsets, tailles et empreintes recoupés indépendamment. Voir [V742](FIDELITY_REA_OWNER_LINKS_V742.md).
- Premier import complet V742 : timeout après600000ms, session fermée et original inchangé. Nouvelle session V745 sur le PE complet : import et requêtes réussis sous budget1800000ms, environ589.394s au total. Deux fonctions/55instructions et22références directes sont recoupées avec la source ; cela ne qualifie pas toutes les sémantiques du jeu. Voir [V745](FIDELITY_REA_FULL_IMAGE_LINKS_V745.md).
- Analyse ciblée réussie : une copie exacte des71octets AF63B0..AF63F7 et de la constante255.0 est placée aux mêmes adresses virtuelles dans un conteneur PE d’analyse explicitement synthétique. REA/Ghidra retrouve19instructions, la convention `__thiscall` et le pseudocode. Les instructions sont recoupées avec le PE original et les102cas natifs déjà exécutés. Voir [preuve V743](rea_af63b0_slice_verification_v743.json).

Le conteneur d’analyse ne doit jamais remplacer le client original ni être lancé comme jeu. Ses en-têtes et remplissages sont synthétiques. Son unique référence entrante est celle de son en-tête ; l’absence d’appelants dans ce petit fichier ne dit rien des appelants historiques. Le pseudocode est une reconstruction d’analyse ; les conversions hors plage doivent être interprétées à partir des instructions et observations natives.

## Utilisation dans les prochaines tâches du goal

1. Sélectionner une question précise et identifier le fichier source par son empreinte.
2. Utiliser REA pour les ressources, fonctions et références pertinentes. Pour plusieurs requêtes natives, conserver une seule session MCP afin de ne pas réimporter le même binaire à chaque appel.
3. Conserver un budget d’import explicite et chaque résultat terminal : V742 expire à600s, V745 réussit sur le même PE sous budget1800s en environ589.394s de session totale. Ne pas attribuer cette différence au seul budget. Conserver une session pour plusieurs requêtes. Les conteneurs ciblés restent possibles avec octets et limites tracés.
4. Conserver les réponses REA, le bundle Evidence, versions, empreintes, diagnostics et confirmations de fermeture. Recouper les conclusions avec les sources et, quand utile, des contrôles natifs et les vrais consommateurs Rust.
5. Relier les preuves au registre sans transformer une décompilation, une correspondance de nom ou un import en validation du jeu. Garder inconnues et états manuels.

V745 ajoute l’analyse REA du PE complet, l’initialisation native des16octets owner38..47 et leur conservation lors d’une réinscription. Il vérifie aussi les deux refus de répartiteurs de banques et la projection limitée du registre Rust. Les cinq adaptateurs dispatch_command trouvés sont réservés aux tests ; la recherche reste bornée et ne prouve pas une absence globale. Les signatures Ghidra par défaut diffèrent entre image complète et conteneurs : utiliser le contrat ECX/pile observé, pas une convention C++ supposée. Production amont20, backend normal, état étendu, ENVS et sortie audible restent ouverts. Les preuves sont intégrées aux deux fiches et bases ; le goal reste actif.

## Reproduction et preuves locales

Corpus : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

- revision742_rea_native.mjs : session sur le PE complet et timeout conservé.
- revision742_audio_owner_native.py :102cas originaux isolés.
- revision742_rea_resources/ : inventaire REA et contrôle indépendant.
- revision742_delivery/ : intégration ciblée et conservation du plan.
- revision743_prepare_slice.py : conteneur d’analyse, provenance et correspondance des octets.
- revision743_rea_slice.mjs : session REA ciblée réussie.
- revision743_verify_slice.py et revision743_rea_slice/VERIFIED.json : comparaison de la décompilation, des instructions et des limites.

Les scripts à destination exclusive refusent d’écraser un reçu existant : choisir un nouveau répertoire de reprise pour une nouvelle observation. [Dépôt officiel](https://github.com/morluto/rea), [documentation Windows/Ghidra](https://github.com/morluto/rea/blob/main/docs/windows-ghidra-p0.md).


## Suite V746 — producteurs et transport

Nouvelle session sur le PE complet :19fonctions/762instructions et43références recoupées, dont41appels et2sauts directs.16appelants directs de B05ED0 et17écritures de sélecteur sont vérifiés. Aucun20 dans ces17affectations ; les chemins indirects et autres points d’entrée ne sont pas exclus. Neuf producteurs natifs passent360cas ;342paquets sont comparés aux deux fonctions de transport Rust,684comparaisons et2refus. Cela ne qualifie pas leurs producteurs Rust ordinaires ni les corps des commandes. REA est fermé normalement. Rapport : [V746](FIDELITY_REA_PRODUCER_LINKS_V746.md).


## Suite V747 — parent audio, publication de frame et filtre PCM

REA a analysé neuf fonctions du PE complet, soit 2 533 instructions et 13 références recoupées avec les octets originaux. B17486 appartient à B171F0 ; B15086 appartient à B15030. Leurs appelants B17A60 et B0ED50 indiquent la prochaine recherche sur le transport des contrôles. Une présence dans les références ne démontre pas ce transport.

Le parent natif passe 352 cas sous contextes déclarés. Les branches actives, alternatives et silencieuses sont distinguées. B08440 publie un marqueur opcode 0 ; ses 90 cas concordent avec publish_frame actuel. Cela ne qualifie ni un producteur opcode 20 ni des workers physiques. Le consommateur PCM ordinaire est présent et son filtre est optionnel, None par défaut. Les activations externes trouvées sont sous cfg(test) ; l’inspection syntaxique bornée ne prouve pas une absence globale.

Session REA fermée normalement ; résultat publié et relu indépendamment. Rapport : [V747](FIDELITY_REA_PARENT_LINKS_V747.md).


## Suite V748 — distinguer les voies primaires et auxiliaires

REA sur le PE complet relie B0E066 à B17A60, B0E088 à B0ED50 et B0EF10 à B15030. Trois fonctions, 699 instructions et trois références sont recoupées. Le parent exécuté copie head240 vers parent2C4 et max(head244,voiceA0) vers parent3B4. B15030 lit séparément voice18C+0C. Suivre B28810 sur les wrappers1F0/2E0 pour continuer vers le PCM primaire ; ne pas confondre ces chemins.

L’argument booléen transmis par le parent est porté par AL : les octets supérieurs du DWORD peuvent rester résiduels. La décompilation ne remplace pas ce contrat observé. FilterControl est testé comme contrat local extrait exactement ; il ne prouve pas une orchestration native en jeu. Rapport : [V748](FIDELITY_REA_CONTROL_TRANSPORT_V748.md).


## Suite V749 — wrappers primaires et alignement PCM

REA sur le PE complet résout le caller commun B0E066/B0E088 en B0DFC0. B28810 retourne sur pointeur de samples nul ; sinon il décale le receveur de 0x10 et transfère à B2B4F0. Quatre fonctions, 492 instructions et six références sont recoupées avec le PE. Le banc natif poursuit les deux contrôles du parent vers les corps PCM originaux.

Pour les comparaisons exactes du PCM, reproduire l’alignement effectif de chaque canal : le préfixe scalaire et les blocs de quatre modifient l’ordre des opérations. Le premier Vec du banc ne reproduisait pas cet alignement ; le stockage aligné et les offsets explicites corrigent le banc. Un pointeur nul et un buffer non nul de zéro frame ont des effets distincts sur le contrôle. B0DFC0 et B0ED50 entiers restent à exécuter. Rapport : [V749](FIDELITY_REA_PRIMARY_PCM_V749.md).


## Suite V750 — ordre des effets et quota entre les filtres

REA relie B0ED50 aux helpers de source, B16FA0, AF4D50 et B267F0. Sept fonctions, 517 instructions et douze références nouvelles sont recoupées. L’exécution de B0ED50 sous callbacks d’effets déclarés confirme la recherche descendante, le traitement ascendant et la limitation des frames après le premier filtre. Ne pas déplacer cette limite en amont des deux filtres dans un banc de comparaison.

La branche source/rééchantillonnage B28AE0/B28870 et les corps de mixage restent statiques ; les deux modes de suppression du mixage sont déclarés dans chaque ligne. Les callbacks d’effets ne sont pas des plugins historiques. Rapport : [V750](FIDELITY_REA_PCM_PIPELINE_V750.md).


## Suite V751 — source, changement de pas et libération

REA analyse huit fonctions du PE original : 681 instructions et 17 références recoupées. Les noyaux de copie, pas fixe et changement de pas sont exercés dans le chemin source B0ED50 avec fournisseur explicite, sortie48k/stéréo float32 et requêtes8frames. 115 scénarios, 962 blocs ; 962 allocations/libérations appariées. L’initialiseur original ne remplace pas la qualification des constructeurs englobants ou du décodeur source.

Le ratio courant est compilé, mais la projection vers un pas fixe est seulement diagnostique. Le lecteur conserve la fréquence source. Conserver cet écart et les 102 séquences différentes ; 13 séquences unitaires égales ne prouvent pas le timing ou le raccordement. Rapport : [V751](FIDELITY_REA_SOURCE_PIPELINE_V751.md).


## Suite V752 — décodeur résident et médias réels

Deux sessions REA fermées :six fonctions et deux instructions individuelles ;première résolution B3F620 en erreur conservée. Ne pas attribuer des procédures complètes à B3F620/B27E80. Les instructions exécutées dans le banc sont contrôlées séparément contre le PE.

Les31 membres DIDX/DATA sont identifiés par offsets relatifs au payload DATA et hashes. Le décodeur résident original alimente B0ED50 avec allocation bornée explicite. Suivre les emprunts source sur le flux complet :ils peuvent traverser un bloc de sortie pendant le rééchantillonnage. Conserver l’écart PCM16 maximal1 avec les WAV,la différence de validation RIFF et l’absence d’intégration Vorbis actuelle. Rapport :[V752](FIDELITY_REA_MEDIA_PIPELINE_V752.md).


## Suite V753 — source de banque et fabrique

REA6.4.0 :deux sessions sur PE complet,14 fonctions,632 instructions et28 références ;fermetures confirmées.587 HIRC Sound analysés/exécutés,31 médias résidents décodés. Ne pas assimiler539 constructeurs stream à539 lectures audio. Le registre codec B09520/B093C0 est distinct du registre courant de plugins d’effets.

B22AF0 est analysé statiquement ;AFA240+B02000/B01ED0 sont composés dans le banc. La continuation B00A50 reste ouverte. Le lookup natif consomme un descripteur construit depuis DIDX :sa production historique est une limite explicite. Source::kind actuel ignore stream_type ;ne pas déclarer une équivalence avec la fabrique. Rapport :[V753](FIDELITY_REA_BANK_FACTORY_V753.md).


## Suite V754 — chargement complet de Sound et limites actuelles

REA6.4.0 analyse le PE original :13 fonctions,1058 instructions,115 références. Exécution native isolée distincte :B226A0/B22AF0/B00A50/AFF450/B00180 sur587 objets. Les six BKHD produisent réellement le drapeau490 ;le gestionnaire,son index vide,les allocateurs et verrous restent des contextes de banc. Les IDs de parents ne sont pas des liens vivants.

Deux sondes Rust compilent des modules complets inchangés ;leur projection de propriétés est privée. load_section refuse HIRC2 sous ses deux politiques :ne pas transformer ce refus en absence d’asset ni annoncer une implémentation. Rapport :[V754](FIDELITY_REA_SOUND_NODE_V754.md).


## Suite V755 — parents et héritage réellement construits

REA11fonctions et exécution native isolée :Init/STMG puis739Sound,524conteneurs,28acteurs chargés dans l’ordre des sources. Les1269liens sont réciproques ;tous les corps sont entièrement consommés. Les82écarts face aux valeurs isolées illustrent la portée du contexte,sans invalider V754.

Le calcul Rust reproduit1478mots sous projection des chaînes. load_section refuse2/5/7 ;les catalogues ne produisent pas les acteurs ancêtres/flags. Ne pas présenter la projection comme intégration du jeu. Références des objets retirées,Init encore vivant ;pas de teardown global ni sortie audible. Rapport :[V755](FIDELITY_REA_HIERARCHY_V755.md).


## Suite V756 — sections HIRC et holders complets

REA10fonctions et exécution isolée du véritable AFB630 sur Init et sixbanques :2516objets de toutes les classes présentes,33paramètres de plugins natifs. AFC410 libère les références des banques et rétablit les index ;le contexte Init reste vivant. Les contrôles de compteurs/descripteurs/corps tronqués conservent puis libèrent les préfixes chargés.

Ne pas déduire la prise en charge Silence du seul statut1 :avec registre vide,le paramètre reste nul. Avec son enregistrement réel,le code Rust refuse le créateur. Les8Meter concordent. Réutiliser les preuves et distinguer section HIRC,orchestration de banque,événement et voix. Rapport :[V756](FIDELITY_REA_HIRC_SECTION_V756.md).


## Suite V757 — orchestration des banques complètes

REA12fonctions et caller AF9D40/AF9960 exécutés sur septfichiers originaux entiers. Les noms STID et les courbes ENVS sont produits dans leur ordre réel ;les relectures entrent dans le cache avant de relire les corps. L’écriture de7C appartient à AFBE05/HIRC8,non STMG :trace79bus par ID,conserver les hypothèses réfutées.

Le même STID tronqué donne56 dans un cache de noms frais et1 après installation des noms. Ne pas convertir ce succès en validation d’intégrité. Le Rust actuel refuse les profils complets ;ses contrôles header/cache/cleanup ne prouvent pas les médias ou le jeu. Aucun DIDX/DATA présent dans ces septbanques. Rapport :[V757](FIDELITY_REA_BANK_READER_V757.md).


## Suite V758 — médias et taille réelle des descripteurs

REA analyse dixfonctions de lecture/recherche/libération. AF9F50/AF9E10 produisent417nœuds à partir des banques complètes,mémoire1 sans copie ;les recherches originales donnent les octets exacts. L’allocation de nœud fait36octets et porte un ID supplémentaire à+32. Ne pas remplacer cette preuve par une capture32octets ;la projection Rust reste explicitement diagnostique.

Les succès1 sur DIDX/DATA tronqués et après refus d’allocation du secondnœud ne garantissent pas l’intégrité. Les contrôles ne déréférencent pas les médias malformés ;le buffer du banc reste mappé au-delà de la longueur déclarée. Le mode copié et les propriétaires simultanés restent à qualifier. Rapport :[V758](FIDELITY_REA_BANK_MEDIA_V758.md).


## Suite V759 — propriétaires et copies

REA analyse 12 fonctions. AF9810 insère le propriétaire récent à l’index0 ; AF93E0 ignore les détenteurs marqués différés. Un holder détaché mais encore emprunté reste sélectionnable tant que le drapeau8 est absent. Les quatre profils couvrent 1668 recherches sur cinq banques chargées deux fois. Les mutations de drapeau sont déclarées ; AF9900/AFCDE0 restent statiques.

AFAAE0 copie 417 médias dans des buffers alignés16/pool0 ; AFC170/AFCC00 rendent le niveau Init. Ce corps sous contexte construit ne qualifie pas AF9960 en mode copié avec provider. Garder les descripteurs natifs36 et la projection Rust32 distincts. Rapport :[V759](FIDELITY_REA_MEDIA_OWNERSHIP_V759.md).


## Suite V760 — vrai drapeau différé et consommation de banque

AFCDE0/AF9900 produisent le drapeau8 et la commande24 ;B06C60 consomme commande/frame et libère le holder quand ses emprunts le permettent. Vingt scénarios,6672recherches et dixcallbacks,avec deuxpages2048 déclarées et scans de voix vides. REA qualifie12fonctions,1687instructions et35références.

Le consumer Rust conserve les descripteurs36,concorde si le holder reste emprunté et refuse le nettoyage terminal. La projection32 n’est utilisée que pour diagnostiquer la dernière libération. Garder padding non sémantique8octets,contextes fournis,CloseHandle/DeleteCriticalSection adaptés,worker/voix/concurrence ouverts. Rapport :[V760](FIDELITY_REA_DEFERRED_MEDIA_V760.md).


## Suite V761 — sources et médias réellement chargés

REA confirme11fonctions sur12adresses demandées ;B3F620 seulement inspecté à une instruction,non promu en procédure. Full HIRC Sound+0x58 et vrais descripteurs/propriétaires alimentent31flux Vorbis résidents. Les voix,parent,filtres bypass et libération explicite du propriétaire restent du contexte de banc. Les31sorties sont recalculées et les fichiers V753 réutilisés après égalité SHA256. Le Rust refuse36octets/WEM ;projection32 et WAV distincts. Rapport [V761](FIDELITY_REA_LOADED_PIPELINE_V761.md).


## Suite V762 — démarrage et nettoyage des voix

REA résout AEDA10,AEEF20,AECF80 et B16380. Le banc final exécute AEDA10/AEEF20 sur31 médias originaux ;les appels B02040/AFBFD0 sont cette fois produits par le cleanup englobant. Conserver la distinction voix fournie/constructeur réel et oracle de services Rust/raccordement produit. Rapport [V762](FIDELITY_REA_VOICE_LIFETIME_V762.md).


## Suite V763 — constructeurs de voix et file de contrôle

REA résout12 procédures du parent et du recalcul. B15BC0 construit la vtable FF166C ;AFD530/AEBE20,désassemblés directement dans le même PE,construisent les voix. Les31 décodeurs sont initialisés avec les médias réellement chargés. AECEE0 et AF3AA0 sont exécutés sans callback simulé ;ils publient puis nettoient et détruisent. Conserver la capacité64 et les contextes secondary/query/path fournis,ainsi que les limites du Rust comparé sous résultats de dépendances importés. Rapport [V763](FIDELITY_REA_CONSTRUCTED_VOICES_V763.md).


## Suite V764 — registre des voix et sortie fallback

REA suit dix procédures du registre natif. B0CE90 inscrit31 parents dans le graphe construit par B0C6B0 ;AF5CE0 initialise les drapeaux/gains du secondaire. Deux frames actives par média restent silencieuses :ne pas les promouvoir en mixage audible. Conserver les contextes fournis et le clock fixé1000 ;poursuivre B09BF0,événement/listener,B17A60 et scheduler. Rust create/configure sont déjà présents et comparés via adaptateur de sonde ;audio_factory_fallback reste un consommateur de composition à réutiliser. Rapport [V764](FIDELITY_REA_REGISTERED_VOICES_V764.md).


## Suite V765 — manager et objets audio réels

REA analyse douze procédures du registre et des décisions de mixage. B09A90 crée le manager et objet0 ;B09BF0 alloue100octets plus nœud12.32 identifiants déclarés en collision et33 positions sont suivis dans les banques réellement chargées. B09FE0 peut renvoyer1 malgré l’échec52 du stockage ;conserver les deux niveaux de résultat. Le Rust logique existe déjà :register réutilisé,acquire/unregister/apply_registered liés. Ses pointeurs/pools/frees et frames ne sont pas qualifiés par cette projection. Rapport [V765](FIDELITY_REA_REGISTERED_OBJECTS_V765.md).


## Suite V766 — observation avant effacement

REA examine12 fonctions de gain et transfert ;la sonde x86 capture B0C1A0/B277F0/B264C0/B27AD0 sur93 passages. Le bus/device sont déjà vides avant effacement. Wrapper+258=0 malgré parent20 positif,seuil inchangé. Le premier transfert copie root434 vers428/42C ;ne pas exiger à tort tous les octets identiques. Rust setter/post/configure existent,liés statiquement sans promotion. Rapport [V766](FIDELITY_REA_AUDIO_OUTPUT_V766.md).


## Suite V767 — listeners initialisés et signal mesuré

REA examine 12 fonctions de géométrie et gain. B19E30/B1A0B0 sont exécutés directement dans le PE original, sans être comptés comme deux décompilations REA supplémentaires. Le banc compose les listeners natifs avec banques, objets, voix et sortie. Les 62 gates autorisent le traitement ; 18 frames de 9 médias contiennent un signal, 44 frames actives restent nulles. Table::native du Rust avait déjà les valeurs correctes. Prochaine frontière : bootstrap historique, positions réelles, préfixes décodés et scheduler ; aucune absence d’asset déduite de deux frames. Rapport [V767](FIDELITY_REA_LISTENER_INITIALIZATION_V767.md).


## Suite V768 — préfixes audio et bootstrap

REA vérifie neuf fonctions, 658 instructions et neuf références ; AF3810 comprend un bloc disjoint B0FC50..B0FCB0. La frontière B3F620 reste non résolue, conservée comme instruction inspectée. Le banc audio mesure les 31 médias jusqu’à leur premier signal, avec borne80 ; un seul cas atteint cette borne sur sa première frame positive79. Les dix profils de B0F550 exécutent le vrai initialiseur B19E30, avec sept autres appels adaptés. Trois liens source actuels précisent ressource/default/caméra, sans exécution du client. Rapport [V768](FIDELITY_REA_AUDIO_PREFIXES_V768.md).


## Suite V769 — scheduler et post natifs

REA examine12 fonctions,1717 instructions et13 références. Le banc compose B06950 avec31 médias,804appels dont31quotas0,773frames traitées. Les742 sorties actives sont identiques à V768. Les notifications listener,préparation de sortie et nettoyages sont natifs ;common/transition/choix device et horloge restent fournis. Trois liens source Rust sont ajoutés,dispatchPost réutilisé ;aucune exécution Rust nouvelle. Rapport [V769](FIDELITY_REA_AUDIO_SCHEDULER_V769.md).


## Suite V770 — initialisation audio native

V770 : AF3810/B0F550 initialisent les files, listeners et périphérique de secours natifs ; B05810/B06020 et AF5450/AF5950 construisent leurs contextes réels. 25 profils vérifient 18 succès et 7 refus d’allocation. Les 742 sorties actives des 31 médias sont conservées. REA analyse 12 fonctions, 673 instructions et 13 références. Trois liens source Rust ajoutés, un réutilisé ; aucun nouveau Rust/client exécuté. AF3810/B0F550 et les constructeurs sont exécutés ; parents entiers,publication des globals,COM physique et worker restent ouverts. Rapport [V770](FIDELITY_REA_AUDIO_CONTEXTS_V770.md).


## Suite V771 — worker et initialisation aléatoire

V771 : AEA640 publie le common et B089A0/B20DA0 prépare le worker natif. B20D10 traite31médias par846attentes coopératives, puis stop/join/close natifs. 25profils vérifient8refus de démarrage et13parcours de boucle. Le seed initial explique les différences avecV770 :784sorties correspondent exactement au témoin réinitialisé. REA analyse12fonctions,469instructions et55références. Un lien Rust ajouté et quatre ancres existantes réutilisées ; aucun nouveau Rust/client Windows exécuté. Thread physique et transport restent ouverts. Rapport [V771](FIDELITY_REA_AUDIO_WORKER_V771.md).


## Suite V772 — composants audio natifs

V772 : AEA9D0 construit et publie dix composants audio ; AF49B0 publie aussi son registre de callbacks. Le parcours des 31 médias conserve les 784 sorties et 713 buffers de V771. Les 59 profils distinguent 39 retours52, 5 retours2 et 15 retours1, sans assimiler retour1 et initialisation complète. REA analyse 21 fonctions, 813 instructions et 27 références. Quatre ancres Rust précises ajoutées ; aucune nouvelle exécution Rust ou sortie audio physique. Rapport [V772](FIDELITY_REA_AUDIO_MANAGERS_V772.md).


## Suite V773 — worker des banques et paramètres

V773 : le worker natif AF8C80 charge six banques et leurs doublons via AFBAE0/AF8AE0 ; AFC7F0 réalise stop/signal/join/close. Les 784 sorties et 713 buffers des 31 médias restent identiques à V772. Quinze profils de file/arrêt et 26 profils de paramètres/prérequis sont vérifiés ; 16 falsifications rejetées. REA analyse 12 fonctions, 831 instructions et 25 références. Quatre ancres Rust ajoutées, sans nouvelle exécution Rust ou audio physique. Rapport [V773](FIDELITY_REA_BANK_WORKER_V773.md).


## Suite V774 — mémoire, flux et parent audio

V774 : le parent natif AEA510 termine son initialisation dans deux profils contrôlés, après publication native de la mémoire et du gestionnaire de flux. Dix composants et quatre pools par profil ; relance retournant2. Vingt-trois profils de limites et12falsifications vérifiés. REA :14fonctions,717instructions,20références. Quatre ancres Rust existantes conservées ; aucune nouvelle exécution Rust ni sortie audio physique. Rapport [V774](FIDELITY_REA_AUDIO_BOOTSTRAP_V774.md).


## Suite V775 — banques et médias après initialisation

V775 : six banques et 31 préfixes audio sont composés après la publication native mémoire/flux et le parent AEA510. Les 784 sorties et 713 buffers restent identiques à V773 ; 730112 échantillons comparés aux WAV, écart maximal 1 PCM16. Deux workers coopératifs exécutés et arrêtés ; 1659 allocations globales restent vivantes. REA : 8 fonctions, 114 instructions, 10 références. Douze falsifications refusées. Quatre ancres Rust existantes conservées, sans nouvelle exécution Rust ni audio physique. Rapport [V775](FIDELITY_REA_AUDIO_COMPOSITION_V775.md).


## Suite V776 — Initialisation ADB

V776 : ADB130/ADB260/ADB1D0 exécutés avant les plugins, puis six banques et31préfixes. 815 callbacks ADB3C0 exécutés avec liste active vide ; 784sorties et713buffers identiques aux références précédentes. Dix profils de limites : allocation propriétaire et événement refusés, retour1 conservé après échec du tableau de callbacks, doublon à la relance. 1660allocations restent vivantes. REA : 13 fonctions, 531 instructions, 39 références.18falsifications refusées ; quatre ancres Rust relues, aucun test Rust nouveau. Rapport [V776](FIDELITY_REA_AUDIO_ADB_V776.md).


## Suite V777 — IO natif

V777 : wrapper IO704590/704700, fabrique B37A40, worker B3D090 et destructeur704620 exécutés dans le banc natif. Six banques et31préfixes ;784sorties et713buffers identiques à V776.21profils IO vérifiés :6retours1,15retours2 ; le quatrième événement manquant ne bloque pas l'initialisation, et15refus laissent le resolver publié après libération du wrapper.1661allocations globales restent vivantes. REA :14fonctions,523instructions,24références.26falsifications refusées ; quatre ancres Rust relues, aucun nouveau test Rust. Rapport [V777](FIDELITY_REA_AUDIO_IO_V777.md).


## Suite V778 — Configuration et démarrage audio

V778 : constructeur704B10 et démarrage704E60 exécutés avec Audio.ini réel via706A20 ; retour1 et second appel sans réinitialisation. Réglages1350/-5/40/8Mio/16Mio.13profils de configuration vérifiés. REA :17fonctions,1133instructions,460références.12altérations de preuve refusées ; quatre ancres Rust relues. Diagnostic998430 et services physiques fournis ; trois demandes de workers différées,56allocations vivantes, aucun nouveau test Rust. Rapport [V778](FIDELITY_REA_AUDIO_CALLER_V778.md).


## Suite V779 — Médias et fermeture séparée

V779 : 704E60 lit Audio.ini puis six banques et31préfixes sont exécutés ;784sorties et713buffers identiques à V777, écart WAV maximal1 PCM16.3870allocations,2204libérations,1666restantes dans ce parcours. Séparément, sans banques chargées :705080 et704C30 libèrent60allocations suivies et ferment15handles simulés ; trois refus donnent2/52 au vidage mais1 au propriétaire. REA :14fonctions,696instructions,70références ;18altérations refusées. Nouvelle ancre Rust run_with_common :0/1 pris en charge,5/8 refusés statiquement. Rapport [V779](FIDELITY_REA_AUDIO_LIFECYCLE_V779.md).


## Suite V780 — Fermeture après banques chargées

V780 : caller704E60, six banques et31préfixes suivis de705080/704C30 dans la même mémoire.784sorties et713buffers identiques à V779 ; écart WAV maximal1 PCM16. 3874allocations suivies libérées,21handles simulés fermés. Six attentes banque→mixage avec callbacks natifs. Trois refus avec banques chargées donnent2/52 au vidage mais1 au propriétaire ; allocations suivies libérées. REA :11fonctions,606instructions,26références. Six ancres Rust existantes relues ;0/1 disponibles,5/8 refusés statiquement. Aucun test Rust nouveau. Rapport [V780](FIDELITY_REA_AUDIO_LOADED_SHUTDOWN_V780.md).


## Suite V781 — Arrêt avec voix active

V781 : arrêt global avec une voix résidente active51118002. Premier parcours après31préfixes arrêté à sa borne de quatre cycles : cinq banques fermées,406allocations encore vivantes. Essai ciblé corrigé : 2211allocations suivies libérées,21handles simulés fermés ; 202cycles pour la plus longue attente. 188071échantillons PCM16 comparés au WAV, écart maximal1. REA :8fonctions,723instructions,11références. Huit ancres Rust, dont le lien statique ajouté pour AF3AA0 ;5/8 restent refusés. Rapport [V781](FIDELITY_REA_AUDIO_ACTIVE_SHUTDOWN_V781.md).


## Suite V782 — Événement natif vers la voix

V782 : événement natif Play_sfx_TT_Shopkeeper_idle2 → publication de frame → action → voix → arrêt. 6 144 échantillons PCM16 comparés au WAV, écart maximal 1 ; 1 791 allocations suivies libérées. Nom vide et événement absent renvoient 0 ; objet non enregistré : identifiant 1 sans voix. REA : 8 fonctions, 1 752 instructions, 28 références. Douze ancres Rust inspectées, dont une nouvelle ancre statique audio_event_post::dispatch. Intégration complète encore ouverte. Rapport [V782](FIDELITY_REA_AUDIO_EVENT_VOICE_V782.md).


## Suite V783 — Seek et notifications natifs

V783 : quatre profils natifs sur deux événements du marchand, dont deux seek500ms et deux notifications de fin. 24 576 échantillons PCM16 comparés aux WAV, erreur maximale1 ; 7 164 allocations suivies libérées sur quatre exécutions. Deux modules Rust inchangés comparés aux traces natives, quatre cas et six contrôles locaux. REA :6fonctions,237instructions,9références. Deux ancres ajoutées ; intégration audio complète encore ouverte. Rapport [V783](FIDELITY_REA_AUDIO_EVENT_PARAMETERS_V783.md).


## Suite V784 — Recensement et ressources PE

REA6.4.0 est réutilisé via inspect-pe-resources sur le client original :10ressources recoupées avec un second parseur et les octets du PE ; source inchangée. Ce contrôle n’est pas une nouvelle décompilation Ghidra. Le recensement vérifie5 740ancres dans584fichiers pour42 215exigences. Les1 964entrées génériques/partielles et384exigences sans native_inputs restent distinguées des fonctionnalités terminées et des assets manquants. Une fiche et deux bases vérifiées ; cases, notes et historiques conservés. Rapport [V784](FIDELITY_REA_AUDIO_REGISTRY_CENSUS_V784.md).


## Suite V785 — Contrats de livraison

34contrats locaux explicites,93liens conservés vers21consommateurs et trois liens de supervision/reprise signalés hors périmètre.24cas du downloader inchangé sur ZIP de test : remplacement par fichier sans rollback du paquet, verify-only limité aux ZIP, protections et refus vérifiés. Le lecteur réel et les deux bases conservent les états manuels. Aucune nouvelle analyse native/REA ; V784 reste une preuve antérieure. Prochaine association : manifeste/GLB restauré/chargeur pour SYS-10.1-02 et SYS-10.1-03. Rapport [V785](FIDELITY_DELIVERY_CONTRACTS_V785.md).


## Suite V786 — Vrai pack de carte

Le ZIP04 réel, ses3007membres et le GLB installé sont comparés ; cinq cas du restaurateur inchangé, dont deux refus. L’ancien GLB réel est refusé par l’outil optionnel. Cela ne prouve pas le garde-fou au démarrage du client, non exécuté. Trois ancres existantes réutilisées, deux contrats locaux ajoutés et deux questions précisées avec historique.1,25Go temporaires supprimés après vérification du périmètre. Aucune nouvelle analyse native REA. Prochaine recherche : contrats et consommateurs des24références communautaires et identifiant stable. Rapport [V786](FIDELITY_MAP_DISTRIBUTION_V786.md).


## Suite V787 — Références et identités

Le lecteur des décisions est corrigé par un nouveau reçu immuable ; V158 est conservé. Douze résolutions, treize refus et vingt-deux tests de versions passent. Les93documents sont rehashés,25contrats locaux et34liens précis sont ajoutés. Les états et24questions communautaires restent inchangés. Les7exigences restantes sans entrée native ni contrat local explicite concernent SYS-04.3-14/15 et les5tâches Battle Training. Aucune nouvelle analyse native REA ; utiliser REA pour leur recherche native lorsque nécessaire. Rapport [V787](FIDELITY_REFERENCE_CONTRACTS_V787.md).


## Suite V788 — Boucliers et ordre des dégâts

REA analyse deux fonctions de configuration des couleurs HUD ;743entrées d’assemblage,34références chaînes et36CALL recoupés dans le PE. Huit sources natives conformes aux manifestes RADS liées. Trois tests de la vraie simulation Rust confirment le bouclier générique, deux ordres d’appels au même tick et les refus/expiration. Quatre ancres ajoutées ; filtre par catégorie et ordre total restent ouverts. Un contrat local partiel est explicité ; deux questions sont affinées sans clôture. Aucun binaire original exécuté. Rapport [V788](FIDELITY_COMBAT_SHIELD_ORDER_V788.md).


## Suite V789 — Événements audio environnementaux

V789 : REA analyse cinq fonctions audio originales, recoupées sur 368 instructions et 11 références. Quatre profils natifs de trois événements environnementaux produisent six voix et deux refus probabilistes ; 205824 échantillons PCM sont comparés aux WAV, écart maximal 1. Deux tests du vrai core Rust recoupent ces sélections et deux refus locaux. Les services physiques sont fournis ; le jeu complet et son backend audio ne sont pas qualifiés.
Les quatre indications passives de propriété corrigées et le premier essai trop court sont conservés dans le rapport. Deux fiches enrichies ; inconnues et états manuels inchangés. [Rapport V789](FIDELITY_REA_ENVIRONMENT_EVENTS_V789.md).


## Suite V790 — Parent audio et objets temporaires

V790 : le parent7067B0, ses branches liée/temporaire et la fabrique native d’objet sont composés avec deux voix par profil et leur arrêt. Trois profils, trois limites natives, 49152 échantillons PCM comparés et5526allocations suivies libérées. REA :10fonctions,567instructions,11références. Deux tests Rust comparent dispatch, sélection, callbacks et nettoyage ; quatre ancres ajoutées. Backend physique et jeu complet restent non qualifiés.
Trois limites natives vérifiées : deux noms vides et un événement absent qui conserve son objet pour nettoyage différé. Inconnues et états manuels inchangés. [Rapport V790](FIDELITY_REA_LAUNCH_PARENT_V790.md).


## Suite V791 — Fin naturelle et nettoyage audio différé

V791 : fin naturelle de deux voix, puis mise à jour native705150 et nettoyage différé706720. 89597 échantillons PCM comparés,43 frames audio,43 mises à jour et1985 allocations suivies libérées. REA :6 fonctions,451 instructions,6 références. Deux tests Rust réussis ; quatre ancres précises ajoutées. Horloge amont, backend physique et intégration complète du parent restent non qualifiés.
La libération de l’objet est suivie de la désinscription lors d’un worker ultérieur. Les états manuels et les inconnues sont conservés. [Rapport V791](FIDELITY_REA_RETIRED_UPDATE_V791.md).


## Suite V792 — Marqueurs natifs et callbacks

V792 : producteur natif de callbacks4 AF4D50 relié aux marqueurs cue/LIST de deux médias Map10 intacts. Trois profils,8 callbacks de marqueurs,3 fins,39936 échantillons PCM comparés et5515 allocations suivies libérées. REA :7 fonctions,622 instructions,19 références. Deux tests Rust réussis sur les consommateurs existants ; aucune intégration complète du producteur ou du backend physique revendiquée.
Les marqueurs proviennent de deux WEM Map10 originaux. L’API numérique conserve le nom historique comme inconnu ; le producteur Rust et le backend restent non qualifiés. [Rapport V792](FIDELITY_REA_CALLBACK_MARKER_V792.md).


## Suite V793 — Types de ressources et cycle de vie

V793 : sept exigences de ressources reliées à31 liens de consommateurs supplémentaires, sans nouveaux doublons.122 INIBIN et244 champs de capacité vérifiés ;3 tests Rust passent avec164 observations,22 réapparitions et96 refus de commandes. REA analyse2 fonctions et3802 instructions. Les mécaniques spécifiques, le fournisseur natif et les valeurs initiales historiques restent non qualifiés.
Sources natives et parcours du core distingués des règles de serveur et de l’intégration complète. [Rapport V793](FIDELITY_REA_RESOURCE_LIFECYCLE_V793.md).


## Suite V794 — Compteurs secondaires

Neuf liens existants ajoutés à SYS-05.4-08 ;14 fichiers natifs et5 chunks Lua de métadonnées vérifiés. Deux tests Rust publics couvrent Annie E/W/mort/réapparition et Ezreal W/R/plafond/rafraîchissement/expiration/statistiques/projection. REA6.4.0 est disponible ; la preuve V793 est rehashée et reste héritée. Aucune nouvelle décompilation, aucune règle serveur secondaire déduite de PARType, aucun écran ordinaire accepté. [Rapport V794](FIDELITY_SECONDARY_RESOURCE_LIFECYCLE_V794.md).


## Suite V795 — Sources et lecteurs de localisation

REA analyse trois procédures natives de chargement/rapport de localisation et de liaison HandleLocalizeText ; leurs instructions sont recoupées dans le PE. Dix-neuf sources fontconfig,12704clés lexicales par profil et leurs copies sont vérifiées. Les vrais modules Rust réussissent38sélections de configuration,refusent7entrées et acceptent une ligne tr invalide sans la lire comme traduction. Dix-neuf fiches HUD et trois exigences SYS restent partielles ; rendu des textes,glyphes,choix de langue ordinaire et sémantique native complète ouverts. [Rapport V795](FIDELITY_REA_LOCALE_TEXT_V795.md).
