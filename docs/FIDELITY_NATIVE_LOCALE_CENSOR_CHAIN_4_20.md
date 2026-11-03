# D01-SYS-01-2 — langue et drapeau des effets — V37

Référence inchangée :PUBLIC4.20.0.315/Releases4.20,EUW/en_GB,catalogue4.20.1.

## Source et résultat conditionnel

Le code82D1A0 lit General/LanguageLocaleRegion dans Data/Cfg/Locale.cfg via
8B0630. Si le résultat est vide,il appelle le getter global8B15D0 avec en_US
comme défaut. Il initialise ensuite le résolveur8B2E70 et la chaîne publiée
par le pointeur global2D78D08. Le fragment575801..57582F compare cette chaîne
à zh_CN via C9CF31,puis passe le résultat bas-octet au setter virtuel primaire
slot58,92C9E0. Le getter secondaire92C9D0 relit le même octet.

**Le fichier fourni `DATA/CFG/defaults/Locale.cfg` n'est membre d'aucun des deux
manifestes sélectionnés.** Ses37octets observés sont `[General]`,CRLF,puis
`LanguageLocaleRegion=en_GB`,sans nouvelle ligne finale. SHA256 :
053f2ad45a7d6c808ba0b394f6a101e985099a953e5a2c7575ab44467804b42f.
L'origine du fichier généré/ajouté et sa priorité historique restent inconnues.
Il n'est ni remplacé ni promu en ressource authentifiée par manifeste.

Deux essais frais utilisent ces octets sous le backend décompressé en lecture
seule déclaré. Le cache,ReadAll,parseur INI,82D1A0/8B2E70,fragment de comparaison,
setter et getter originaux s'exécutent sous **Unicorn x86 avec garde des octets**.
Avec un octet initial0 puis1,le résultat conditionnel est0. Le fichier est lu
entièrement et fermé ;aucun fallback global Game.cfg n'est utilisé.
23416 instructions/4135PC,sortie normale0,aucun accès invalide.

Quarante-six profils supplémentaires fournissent explicitement la langue,
le stockage SSO ou heap et l'octet initial. Les variantes de casse zh_CN donnent1 ;
les autres profils,notamment en_GB et zh_CN_suffix,donnent0.4016 instructions/
61PC,sortie0,aucun accès invalide ou allocation invitée restante. Seul l'octet
primaire359 change et la pile est conservée. Les24bits hauts de l'argument
du setter restent opaques :son code consomme DL,donc le bas-octet seulement.

## Portée et consommateurs

Ces observations qualifient une chaîne de lecture **conditionnelle aux entrées
et au backend déclarés**. Elles ne prouvent ni le montage historique RADS,
les overlays/arguments de lancement,la création de Locale.cfg,le constructeur
réel du gestionnaire,la totalité du caller ni la valeur effective du processus EUW.
L'objet stdstring publié et le stockage/vtable du gestionnaire sont fournis
par les harness existants. Les adaptations d'allocateur,chaînes/copie,thread,
locale CRT initiale,mtime courant,OS et streams virtuels sont déclarées.

L'auditeur installé est `tools/project-plan/audit_native_locale_censor_chain.py`.
Il vérifie aussi le statut négatif d'appartenance aux manifestes. Deux
consommateurs Rust existants sont identifiés sans nouveau test Rust :

- `native_hud_font_configuration::load`,pour la configuration de langue des fontes ;
- `audio_replay_loading_owner::construct`,qui lit LANGUAGE_GLOBAL2D78D08 et
  compare ZH_CN pour un wrapper de chargement distinct.

Ces ancres ne constituent pas une implémentation du setter du gestionnaire
d'effets. Aucun runtime du jeu,rendu,audio ou acceptation humaine n'est déduit.

## Recherches corrigées et conservées

Le premier scan Capstone sans skipdata s'arrêtait après63187instructions ;
son résultat vide ne prouve aucune absence. Le second reprend la politique
de scan précédente :4114619instructions linéaires,144candidats sur deux globals,
avec présence vérifiée du consommateur575801. Cela reste une recherche de
candidats,pas un CFG complet.

La première collecte supposait à tort une appartenance au manifeste en_gb ;
son assertion échouée est conservée et la classification devient explicitement
« configuration locale observée,origine inconnue ». L'auditeur a aussi refusé
initialement une différence de casse du chemin Windows ;la correction normalise
uniquement la comparaison du chemin et conserve les gardes de taille/SHA/racine.
Les expériences natives et les anciennes preuves n'ont pas été relancées ou réécrites.

## Livraison et inconnues

Seules les traces SYS-01.2-02/03/06 et une inconnue composée existante sont
enrichies ;elle demeure ouverte. IDs,versions/SHA et états manuels sont conservés.
Le reçu `docs/fidelity_registry_native_locale_censor_chain_revision_4_20.json`
documente qualification,intégration,contrôles réels et fichiers modifiés.

Restent l'origine et la génération de la configuration,les mounts/overlays/CLI,
le bootstrap entier,le chargement918B30/918E90 et ses groupes/callbacks,
le raccordement Rust/événements/rendu/audio,les deux caps AIR4312/4313 et les
contradictions communautaires. Ce lot ne clôture ni ces six objectifs ni le jeu.
