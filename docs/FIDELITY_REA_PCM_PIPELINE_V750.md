# SYS-01.2-02 — Pipeline PCM et limite de frames, V750

Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. V749 a modifié deux fiches, trois registres et deux bases, avec relecture indépendante et reçu final réparé puis vérifié. Ce lot poursuit la liaison source → exigence → consommateur. Aucune fin globale du jeu n’est déclarée.

## Résultat

B0ED50 entier est maintenant exécuté dans 336 contextes de buffer, après le parent B17A60/B171F0/B18530. Les callbacks d’effets sont explicitement fournis par le banc : ils exposent des buffers déjà préparés et retournent les statuts déclarés, sans transformer les samples. Les effets réels, le fournisseur source et le rééchantillonnage restent à qualifier.

Ordre constaté : recherche descendante des slots d’effets ; traitement ascendant après le slot disponible ; premier filtre B28810/B2B4F0 ; limite de frames B16FA0 ; AF4D50 avec métadonnées absentes ; second filtre B28810/B2B4F0. Le chemin de mixage final est évité par job+38 ou par le drapeau output+25C. Le corps B0ED50 retourne normalement dans tous ces contextes, mais cela ne couvre pas toutes ses branches.

La limite de voix est appliquée entre les deux filtres. 196 des 336 blocs ont donc une seconde étape plus courte. Les composants Rust existants correspondent exactement lorsque le banc reproduit cette limite à cet emplacement. Cette composition de banc n’est pas présentée comme une orchestration déjà raccordée en jeu.

## Sources et analyse REA

REA 6.4.0/Ghidra 12.1.4 analyse sept fonctions du PE complet : B28AE0, B28870, B16FA0, AF4D50, B267F0, B28520 et B280F0. Les 517 instructions et douze références sont recoupées avec les octets originaux ; réponses et pseudocode sont épinglés. Session fermée normalement, zéro erreur. B0ED50 et B0DFC0 réutilisent les analyses V748/V749 conservées.

Client : 15 973 880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Init.bnk : 6 890 octets, SHA256 41d3befb0b934fc609c7b9d5305a8d361cbc77c35e713d37b66e1ac87de3f004. Les chemins absolus et les versions d’outils figurent dans les reçus.

B28AE0/B28870/B28520/B280F0 et B267F0 sont analysés statiquement dans ce lot, sans qualification d’exécution de leurs chemins source/rééchantillonnage/mixage. AF4D50 est exécuté avec une liste de métadonnées vide, ce qui ne qualifie pas ses callbacks de notification.

## Exécution originale et limites déclarées

Sept profils ENVS, quatre dispositions d’auditeurs et six couples obstruction/occlusion donnent 168 cas ; le parent et le pipeline sont appelés deux fois par cas. Les 3 661 adresses natives exécutées sont vérifiées contre le PE, sans accès bas mémoire observé. L’initialisation des filtres, leurs coefficients identité, leurs historiques nuls, les deux canaux, fréquences et alignements sont fournis comme en V749. Les constructeurs/propriétaires des filtres ne sont pas qualifiés.

Quatre configurations d’effets couvrent les slots [3], [1,3], [1,2,3] et [0,1,2,3]. Les statuts déclarés 43, 45 et 17 entraînent 1 344 appels d’effets dont l’ordre est contrôlé. Ces nombres restent des codes observés ; aucune sémantique de plugin réelle n’est inventée. Le callback virtuel de limite renvoie selon le cas FFFFFFFF, 0, 1, 2, frames+1 ou frames/2. FFFFFFFF préserve la longueur ; les autres valeurs fixent min(frames,limite) et le drapeau job+2D. La comparaison des jobs vérifie que seuls ces champs et le statut attendu changent.

Les buffers couvrent 0, 1, 2, 3, 17, 129 et 259 frames, alignements 0/4/8/12, deux modes DSP et trois fréquences. Le remplissage et les portions au-delà de la longueur propre à chaque filtre restent conservés. Les pointeurs nuls sont contrôlés séparément sur les wrappers, pas présentés comme un passage complet dans B0ED50.

Six cas supplémentaires retournent avant les filtres : statuts 0, 2 et 46, sur get ou process. Le job conserve tous ses octets sauf le statut prévu ; états de filtres, historiques et samples restent inchangés. Les corps d’effets restent des adaptations explicitement déclarées. Aucun code natif n’est remplacé pour les deux filtres, la limite B16FA0 ou la route principale B0ED50.

Le contexte parent conserve les limites V749 : voix en cache, bus racine et branche auxiliaire absents, callback de frames restant à -1 pour B17A60, allocation/verrous/TLS/transport mémoire adaptés. Le nouveau callback B16FA0 est distinct et ses six valeurs sont déclarées. La propriété historique des objets et le son physique restent ouverts.

## Consommateurs Rust actuels

Cinq fichiers core inchangés sont compilés : audio_filter.rs, audio_pcm.rs, audio_filter_expand.rs, audio_filter_transition.rs et audio_media.rs. La compilation hors ligne et l’exécution retournent 0. Les 672 étapes comparent état avant/après, historique et 93 968 mots de samples, avec la longueur spécifique à chaque étape. Cinq refus géométriques/non finis préservent état, historique et samples.

Playback::read est vérifié séparément avec les entrées des buffers converties en ordre entrelacé : 280 lectures positives conservent les samples et rendent la queue silencieuse ; 280 sorties non alignées sont refusées sans déplacer le curseur ni modifier la sortie. Les 56 buffers natifs de zéro frame donnent, si on tente d’en faire un clip vide, InvalidPcm. Un bloc vide et un clip vide ne sont pas des entrées équivalentes : cette différence est documentée, pas traitée comme un défaut.

Le consommateur réel Decoder::next est inspecté à la source : playback.read précède un VoiceFilter optionnel et process_voice. Ce module client Bevy n’est pas compilé dans ce lot. Cette inspection ciblée ne prouve pas l’absence globale d’autres routes ; elle ne qualifie pas ce décodeur comme l’équivalent de B0ED50 à deux filtres avec quota intermédiaire. Ses rôles existants et ceux des filtres core sont conservés. Un rôle précis est ajouté pour Playback::read.

## Publication et vérification

Deux fiches enrichies : SYS-01.2-02 et SYS-02.2-07. Le livrable est intégré aux registres, aux deux bases et aux instructions copiables. Les états manuels, notes, historiques, autres tâches, prérequis et inconnues sont conservés. coverage.json, completion_plan.json, resume_checkpoint.json et les notes de reprise sont actualisés.

Six incohérences de preuves sont refusées : quota placé avant le premier filtre, ordre d’effets altéré, conservation sur pointeur nul supprimée, retour natif mutateur, sample Rust altéré et confusion entre bloc vide/clip vide. Ces contrôles de métadonnées sont distincts des refus réellement exécutés en natif et en Rust.

Preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision750_pcm_pipeline_native ; revision750_pipeline_refusals ; revision750_rust_pipeline_transport ; revision750_rea_pcm_pipeline ; revision750_pipeline_associations ; revision750_delivery. Le premier probe Rust revision750_rust_pipeline passe également et reste conservé. VERIFIED.json, INDEPENDENT_READBACK.json et FINAL_REVIEW_DELTA.json.gz distinguent publication, relecture et checkpoint.

## Suite

Qualifier le fournisseur source/rééchantillonnage et ses constructeurs, les effets réels, les métadonnées non vides, B267F0 et le mixage physique, puis B0DFC0 et l’orchestration Rust ordinaire. Le chemin auxiliaire, les bus, commande20/état étendu, Meter, Init complet, médias, locale et sortie audible restent ouverts. Aucun code produit ni asset modifié ; aucune acceptation humaine ou fidélité globale déduite des tests.
