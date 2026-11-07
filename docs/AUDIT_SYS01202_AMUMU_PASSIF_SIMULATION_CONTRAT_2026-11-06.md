# Amumu — branches connues de Cursed Touch et écarts de simulation

6 novembre 2026 · V1450 · AUD-SYS-01.2-02-AMUMU-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et frontière

CH-Amumu-PASSIF-SIMULATION-CONTRAT, OLF-9f2efb22-23a3-56bd-9224-6eba70171c1a, parent SYS-01.2-02. Décrire les branches établies par les preuves conservées et leurs consommateurs actuels. **L’audit borné des déclarations connues et des écarts statiques est terminé ; la tâche complète reste ouverte.** Les politiques historiques inconnues, le gameplay, le réseau, la présentation et l’acceptation ne sont pas fermés. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct.

V550 associait déjà cette tâche : docs/FIDELITY_AMUMU_PASSIVE_MR_LINKS_V550.md, SHA f3b725657ab7e04784f0f846bcd7342c791f41f4608ff53614ceb336e64956c0. Reçu docs/reference_requirement_trace_sources/amumu-passive-mr-links-v550.json, 497345 octets, SHA 105a430e2ebdb3cb975ef811d339f3443bc3fb7573e65bf847d7a496197bb174 : huit sources natives, deux bindings, trois Lua et un preload ; références communautaires distinctes. Identités/décodages natifs hérités, non rejoués.

Amumu.inibin est identifié antérieurement : 2952 octets, SHA e75b90750a8f2a0a1ce555029852d2927667b883198061eb0e90c7125dc4c802. Le miroir en_GB courant est relu : 2220957 octets, SHA 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3. Trois chaînes exactes aux lignes1809,1810,4154 ; identité native/mirroir héritée de la preuve commune du fichier, sans gameplay Ahri réutilisé. Locale effective en exécution inconnue.

## 3. Branches et consommateurs

contract_review.json décrit dix branches : identité/alias ; impact d’attaque ; montant/progression ; durée/refresh ; composition de résistance magique ; cibles ; propriétaire/cumul ; cycle de vie ; métadonnées ; contrôles et frontière courante.

Le marker lié décrit une réduction de résistance magique de @f1@ pendant trois secondes après les attaques de base. Le texte d’effet constate la résistance réduite ; la description du champion reste générale. CursedTouchMarker et CursedTouch sont distincts. Les variantes underscore/Self ne deviennent pas des alias effectifs. La description brute20/30/40/50 et les niveaux1/9/17 ne résolvent pas f1. Passive1 absent ne reçoit aucun défaut ; anciens textes de régénération de mana et NightmareBot non adoptés.

Dix-sept ancres enregistrées sont retrouvées ; dix fichiers sélectionnés concordent avec V550, dont spells.rs ajouté pour la structure Effects. Dix-huit fenêtres, dont douze communes réutilisées après égalité d’identité, relient la commande Attack, la libération mêlée, basic_attack_hit et apply_damage. Les bonus d’objets alimentent la MR des statistiques ; penetrated_defenses applique la pénétration de l’attaquant ; mitigate consomme la MR fournie. L’ajustement défensif de Trundle appartient à un autre champion.

Les nouvelles fenêtres sont damage.rs:31–49, penetration.rs:4–18, shop.rs:215–246 et314–322, trundle_r.rs:103–114, attacks.rs:236–249. Les recherches négatives nomment huit fenêtres seulement ; aucune absence globale ni inspection exhaustive du graphe d’appels revendiquée. Le préfixe mêlée ne couvre pas tout advance_attacks. Aucun de ces récepteurs génériques n’est promu en producteur Cursed Touch.

## 4. Attendu, observé et contrôles

Attendu : source, politique inconnue et consommateur ou manque précis pour chaque branche. Observé : dix branches uniques, dix-huit fenêtres, dix-sept ancres et dix-neuf identités courantes ; **44/44 contrôles documentaires et 30/30 cohérences du même agent**. Quatre opérations journalisées réussies.

V550 reste hérité : trois cas Amumu/Ahri niveau1, neuf attaques aux ticks828/875/922 ; MR30/55 inchangée, puis91ticks observés par cas. L’objet1033 ajoute25MR à la cible ;1036 ajoute10AD à Amumu. Ces cas ne montrent ni application ni expiration du passif.

Le diagnostic a fourni séparément100dégâts magiques à922 : post-mitigation76.9230804 à30MR et64.5161285 à55MR. C’est un événement serveur de contrôle explicite, pas un sort ou déclenchement natif. Les retraits de vie conservent leurs arrondis float32 distincts. Quinze refus de commandes publiques et douze refus d’événements serveur restent deux catégories, pas vingt-sept commandes client.

Identité de l’ancien binaire inerte : 6041088 octets, SHA 06ded743b0595f7836567f72cb455cad3574e3edf3ac018011aa010b4ab8eb8b. Aucun nouveau build, test Rust, runtime, réseau, Lua, accès D/F-work/EXE, REA, GPU ou capture. Les1158dépendances historiques ne sont pas recensées à nouveau.

## 5. Écarts et conclusions ouvertes

Restent inconnus : événement d’impact et ordre d’application, fournisseur f1, valeurs/niveaux effectifs, réduction fixe/pourcentage, composition avec objets/pénétration/Trundle, MR négative, immunités, cibles, propriétaires multiples, cumul, refresh, expiration et transitions de mort/reconnexion.

Trois chunks donnent sept globals littéraux sans prototype enfant ni serveur exécuté. Le marker déclare PersistsThroughDeath/NonDispellable ; CharScript cite une autre icône. Ces déclarations ne prouvent pas une machine d’états, un rendu ou une politique de dispel. Les preloads et anciens audits de présentation restent distincts.

Audit borné terminé ; implémentation Cursed Touch non établie dans les fenêtres ; runtime non exécuté ici ; acceptation humaine non donnée. Prérequis SOURCE, dépendances et inconnues conservés.

## 6. Corrections et reprise

corrections_and_restart.json propose cinq objectifs documentaires COR-SYS-01.2-02-AMUMU-CURSED-TOUCH : SEMANTICS-01, ONHIT-01, MRSTATE-01, LIFECYCLE-01 et VERIFICATION-01. Chaque fiche précise entrées, travail, fin et reprise. Aucun registre modifié ni correction produit implicite.

Reprendre sur artefact serveur, fournisseur, capture, callsite ou dérive précis. Les corrections fonctionnelles nécessitent leur politique sourcée et une autorisation adaptée. La prochaine paire réelle est Akali SIMULATION-CONTRAT : première ligne alphabétique hors des unités déjà traitées ou courante de cette série. La sélection sur122paires n’est pas une qualification des anciens audits et ne les déclare pas complets.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_amumu_passive_simulation_contract_20261106 : contrat, dix branches, ancres, identités, journaux, corrections et reprise. Projection familiale existante réutilisée ; aucun grand registre chargé ni gain temporel chiffré.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF sauvegardés exactement. Sept registres, goal, Plan/UI, bases, code et assets inchangés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2436entrées groupées conservées. Relecture du même agent, sans revue indépendante. Une unité bornée close ; aucune tâche complète, fonctionnalité, inconnue ou acceptation fermée.
