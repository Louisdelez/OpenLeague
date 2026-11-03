# SYS-01.2-02 — Contrôles primaires et échantillons audio, V749

Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. La livraison V748 reste conservée et sa relecture indépendante est liée aux entrées de cet audit. Cette livraison documente la liaison source → exigence → consommateur, sans qualifier le jeu complet.

## Résultat observé

Les contrôles produits par B17A60 puis B171F0/B18530 alimentent les deux filtres primaires. Après le parent, le banc appelle explicitement B28810 sur parent+1F0 puis parent+2E0 ; cette fonction ajoute 0x10 au receveur et transfère vers B2B4F0. Les filtres effectifs sont donc parent+200 et parent+2F0. Leurs cibles sont parent+2C4 et parent+3B4, conformément à V748.

Les deux filtres originaux traitent successivement le même buffer. Les composants Rust actuels, composés dans le même ordre par le banc, produisent exactement les mêmes échantillons, états et historiques dans les cas testés. L’orchestration complète du jeu n’est pas exercée.

## REA et identité des sources

REA 6.4.0 avec Ghidra 12.1.4 analyse le PE original complet. Cinq résolutions donnent quatre fonctions : B28810, B0DFC0, B2B4F0 et B2BE10. Les 492 instructions et six références sont recoupées avec les octets du PE ; pseudocode et réponses sont épinglés par SHA256. B0E066 et B0E088 appartiennent tous deux à B0DFC0. La session est fermée normalement, sans erreur ; REA ne lance pas le jeu.

Client : 15 973 880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Init.bnk : 6 890 octets, SHA256 41d3befb0b934fc609c7b9d5305a8d361cbc77c35e713d37b66e1ac87de3f004. Les chemins absolus sont dans les reçus. B0DFC0 et B0ED50 ne sont pas exécutés dans ce lot : leurs liens restent statiques.

## Banc natif et attentes

Sept profils ENVS, quatre dispositions d’auditeurs et six couples obstruction/occlusion forment 168 contextes. Le parent original est appelé deux fois par contexte, soit 336 appels. Ses deux contrôles primaires sont clamp(head240,0,100) et clamp(max(head244,voiceA0=30),0,100). Les cibles identiques au second appel ne réactivent pas dirty.

Chaque contexte traite deux blocs, chacun traversant les deux filtres originaux : 336 blocs et 672 étapes. Les géométries couvrent 0, 1, 2, 3, 17, 129 et 259 frames, avec trois samples de remplissage par canal conservés. Deux canaux, masque 3, fréquences 44 100/48 000/96 000 Hz, deux modes DSP et alignements 0/4/8/12 octets sont déclarés. Un buffer non nul de zéro frame consomme le contrôle, mais préserve échantillons et historique. Un pointeur de samples nul retourne avant ce traitement ; les deux états de filtre restent inchangés dans les 168 contextes.

Initialisation fournie : coefficients identité via le corps original B2BB30, historiques nuls, current=target=0, step=8, bypass=true, dirty=false, immediate=true. Les allocateurs/constructeurs des filtres ne sont pas qualifiés. Après chaque étape testée : current=target attendu, step=8, bypass=false, dirty=false, immediate=false. Les 3 493 adresses exécutées sont vérifiées contre le PE ; aucun accès bas mémoire observé.

Le contexte parent conserve les limites explicites du banc V748 : bus racine nul, absence de branche auxiliaire, état de voix en cache, ressource non nulle, flags=5 et callback virtuel vtable+30 adapté à -1. Le booléen transmis est porté par AL, bien que le DWORD observé soit FFFFFF00. Allocation d’environnement, verrous, TLS et transport mémoire utilisent les adaptations déclarées. Ce contexte n’est pas une voix historique complète.

## Consommateurs Rust et correction du banc

Quatre fichiers core actuels sont compilés sans modification : audio_filter.rs, audio_pcm.rs, audio_filter_expand.rs et audio_filter_transition.rs. Le banc compose deux Controller, appelle update_target puis process_planar et conserve le buffer entre les deux filtres. Les 672 étapes comparent bit pour bit état avant/après, huit mots d’historique et chaque mot de samples, soit 93 968 comparaisons de samples, remplissage compris.

Le premier banc Rust échouait au contexte 8, bloc 1, étage 0 : un Vec n’avait pas reproduit l’alignement natif. Le consommateur actuel choisit préfixe scalaire, blocs de quatre et fin scalaire selon l’adresse effective. Le banc corrigé utilise un stockage aligné sur 16 octets et vérifie explicitement les offsets 0/4/8/12. Compilation et exécution finales retournent 0 ; l’échec initial reste conservé. Aucun défaut produit n’a été établi et aucun code produit n’a été modifié.

Cinq refus Rust passent : frames au-delà de la capacité, capacité hors u16, buffer tronqué, NaN et infini. Ils préservent état, historique et samples. Ces refus sont des contrats locaux ; leur équivalence aux comportements de mémoire invalide du client historique n’est pas revendiquée.

Deux rôles sont ajoutés : process_planar et le traitement PCM sensible à l’alignement. Le rôle existant de update_target est réutilisé. Le module client Bevy complet et la sortie sonore physique ne sont pas exécutés.

## Intégration et vérification

Six falsifications de preuves sont rejetées : sample altéré, décalage du wrapper confondu, conservation sur pointeur nul supprimée, historique altéré, alignement faux et refus mutateur. Il s’agit de refus de métadonnées incohérentes, distincts des cinq refus Rust.

SYS-01.2-02 et SYS-02.2-07 reçoivent ces preuves dans les trois registres, les deux bases du plan et leurs instructions copiables. Les cases, notes, historiques, autres tâches, prérequis et inconnues sont conservés. Les deltas permettent de retrouver exactement les octets précédents, sans copie intégrale des bases. coverage.json, completion_plan.json, resume_checkpoint.json et les notes de reprise sont mis à jour. Les reçus VERIFIED.json et INDEPENDENT_READBACK.json séparent publication et relecture indépendante.

Preuves de travail : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision749_rea_primary_pcm ; revision749_primary_pcm_native ; revision749_rust_primary_pcm_aligned ; revision749_primary_pcm_associations ; revision749_delivery. Le premier banc revision749_rust_primary_pcm reste conservé.

## Limites et suite

Qualifier B0DFC0 et B0ED50 entiers, le cycle source/effets/mixage, l’initialisation et la propriété réelles des filtres, les transitions dynamiques et l’orchestration Rust ordinaire. Les deux filtres sont composés explicitement dans le banc. Le chemin auxiliaire distinct de V748, ses producteurs, les branches bus, commande20/état étendu, Meter, Init complet, médias, locale et son audible restent ouverts. SYS-01.2-02 demeure partiel ; aucune acceptation humaine ni fin globale du jeu n’est déduite de ce lot.
