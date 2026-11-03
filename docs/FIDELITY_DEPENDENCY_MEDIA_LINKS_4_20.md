# Dépendances Troy/INIBIN et banques/médias — V46

Cette preuve enrichit SYS-01.2-02/03/06 et les relations des exigences SYS-02.2-06/07. Elle conserve les six objectifs du Goal et les preuves V45. Les deux futures tâches de validation restent a_faire ;aucun état manuel ou critère de fidélité du jeu n'est accepté automatiquement.

## Sources et usages actuels

Dix fichiers natifs exacts correspondent aux manifestes sélectionnés par la solution4.20 EUW :terrain.inibin,TT_Heal_Rune.troybin,TT_Heal_Plus.sco,color-hold.DDS,Init.bnk et cinq banques ambiantes/PNJ. Les tailles/MD5 des membres et SHA256 sont vérifiés. Les releases de projet et de membre restent distinctes du build4.20.0.315 et de la priorité effective d'un provider.

Onze ancres relient le décodeur Map10 et son consommateur FoW, le lecteur de comparaison Troy et l'admission du document authored, le lecteur BKHD et son appel dans le manager mémoire, l'extracteur DIDX/DATA, le décodeur PCM et la population/inscription du bridge Bevy. Les sources,versions et SHA utilisés figurent dans le reçu. Les anciens compteurs/tests restent historiques ;les empreintes actuelles sont qualifiées par héritage V45 et delta relu explicitement.

## Attendu et observé

| Portée | Attendu | Observé |
|---|---|---|
| INIBIN Map10 | Module actuel inchangé,fichiers originaux et lecture typée cohérente |53champs et58lectures typées concordent avec les oracles hérités ;366préfixes tronqués et2autres entrées sont refusés |
| En-têtes Wwise | Préserver codes,cursor/pointeurs/octets de sortie et flag,y compris lectures courtes |63profils oracle concordants ;6en-têtes de banques réelles acceptent la version88 |
| Médias embarqués | Identifier chaque source par DIDX et plage DATA exacte |31WEM correspondent byte pour byte aux banques natives et à leurs empreintes |
| PCM existants | Lire les31WAV sans altérer fréquences/canaux/frames |31décodages vérifiés ;31troncatures et4autres entrées sont refusées |
| Troy | Préserver les noms/logiques des dépendances |4champs raw correspondent au document courant :p-mesh,p-meshtex,p-type,p-scale ;color-hold.tga n'est pas renommé en DDS silencieusement |
| Preuves altérées | Refuser identités,ancres,comptes,projections,médias et promotions indues |36contrôles :34refus,1nominal et1représentation numérique équivalente |

Les modules Rust Config,BKHD et PCM actuels sont compilés dans un hôte de composant. Huit déclarations/méthodes de dépendance du getter typé et du Stream sont des projections textuelles exactes de leurs sources courantes. Un Error minimal transporte les quatre erreurs nécessaires ;il ne qualifie pas l'ABI,le manager complet ou les autres branches du moteur. Les oracles historiques sont des données héritées,pas des exécutions natives répétées.

La compilation et le composant terminent avec code0. Le premier script de publication avait échoué en lisant le JSON échappé imprimé par l'hôte ;les journaux sont conservés et décodés séparément,sans relancer les commandes terminées.

## Inconnues conservées

La question générique de liaison banques/médias est résolue uniquement pour les sources et fonctions actuelles. Cela ne prouve ni validation de toutes les banques/types HIRC,ni fidélité de conversion WEM-to-WAV,ni mixage/boucles/écoute. Le code courant consomme les WAV existants et ses erreurs restent explicites.

La question Troy/INIBIN reste ouverte :le raw demande color-hold.tga tandis que le transport courant admet un DDS fourni. Les priorités de provider,alias,overlays et résolution exhaustive des dépendances ne sont pas établies par une égalité de pixels ou une chaîne de noms. Le décodeur Map10 couvre seulement ses cinq types présents.

Aucune conversion de médias n'est rejouée,aucun device audio ou client Bevy n'est lancé. Le reçu `docs/fidelity_registry_dependency_media_revision_4_20.json` contient les commandes réellement exécutées,identités,fichiers modifiés,publication additive et audit final. Les42214consignes,15échantillons HTTP et42606états/historique du plan sont contrôlés séparément. Les divergences4312/4313 et les autres scripts/liens du Goal restent ouverts.
